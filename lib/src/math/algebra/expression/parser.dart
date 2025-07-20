part of 'expression.dart';

class ExpressionParser {
  ExpressionParser() {
    expression.set(binaryExpression.seq(conditionArguments.optional()).map(
        (l) => l[1] == null
            ? l[0]
            : ConditionalExpression(
                condition: l[0], ifTrue: l[1][0], ifFalse: l[1][1])));
    token.set((literal | unaryExpression | variable | groupOrIdentifier)
        .cast<Expression>());
  }

  Expression? tryParse(String formattedString) {
    final result = expression.trim().end().parse(formattedString);
    return result is Success ? result.value : null;
  }

  Expression parse(String formattedString) =>
      expression.trim().end().parse(formattedString).value;

  // Gobbles only identifiers
  // e.g.: `foo`, `_value`, `$x1`
  Parser<Identifier> get identifier =>
      (digit().not() & (word() | char(r'$')).plus())
          .flatten()
          .map((v) => Identifier(v));

  // Parse simple numeric literals: `12`, `3.4`, `.5`.
  Parser<Literal> get numericLiteral => ((digit() | char('.')).and() &
              (digit().star() &
                  ((char('.') & digit().plus()) |
                          (char('x') & digit().plus()) |
                          (anyOf('Ee') &
                              anyOf('+-').optional() &
                              digit().plus()))
                      .optional()))
          .flatten()
          .map((v) {
        return Literal(num.parse(v), v);
      });

  Parser<String> get escapedChar =>
      (char(r'\') & anyOf("nrtbfv\"'\\")).pick(1).cast();

  String unescape(String v) => v.replaceAllMapped(
      RegExp("\\\\[nrtbf\"']"),
      (v) => const {
            'n': '\n',
            'r': '\r',
            't': '\t',
            'b': '\b',
            'f': '\f',
            'v': '\v',
            "'": "'",
            '"': '"'
          }[v.group(0)!.substring(1)]!);

  Parser<Literal> get sqStringLiteral => (char("'") &
          (anyOf(r"'\").neg() | escapedChar).star().flatten() &
          char("'"))
      .pick(1)
      .map((v) => Literal(unescape(v), "'$v'"));

  Parser<Literal> get dqStringLiteral => (char('"') &
          (anyOf(r'"\').neg() | escapedChar).star().flatten() &
          char('"'))
      .pick(1)
      .map((v) => Literal(unescape(v), '"$v"'));

  // Parses a string literal, staring with single or double quotes with basic
  // support for escape codes e.g. `'hello world'`, `'this is\nJSEP'`
  Parser<Literal> get stringLiteral =>
      sqStringLiteral.or(dqStringLiteral).cast();

  // Parses a boolean literal
  Parser<Literal> get boolLiteral =>
      (string('true') | string('false')).map((v) => Literal(v == 'true', v));

  // Parses the null literal
  Parser<Literal> get nullLiteral =>
      string('null').map((v) => Literal(null, v));

  // Parses the this literal
  Parser<ThisExpression> get thisExpression =>
      string('this').map((v) => ThisExpression());

  // Responsible for parsing Array literals `[1, 2, 3]`
  // This function assumes that it needs to gobble the opening bracket
  // and then tries to gobble the expressions as arguments.
  Parser<Literal> get arrayLiteral =>
      (char('[').trim() & arguments & char(']').trim())
          .pick(1)
          .map((l) => Literal(l, '$l'));

  Parser<Literal> get mapLiteral =>
      (char('{').trim() & mapArguments & char('}').trim())
          .pick(1)
          .map((l) => Literal(l, '$l'));

  Parser<Literal> get literal => (numericLiteral |
          stringLiteral |
          boolLiteral |
          nullLiteral |
          arrayLiteral |
          mapLiteral)
      .cast();

  // An individual part of a binary expression:
  // e.g. `foo.bar(baz)`, `1`, `'abc'`, `(a % 2)` (because it's in parenthesis)
  final SettableParser<Expression> token = undefined<Expression>();

  // Also use a map for the binary operations but set their values to their
  // binary precedence for quick reference:
  // see [Order of operations](http://en.wikipedia.org/wiki/Order_of_operations#Programming_language)
  static const Map<String, int> binaryOperations = {
    '??': 0,
    '||': 1,
    'or': 1,
    '&&': 2,
    'and': 2,
    '|': 3,
    '^': 4,
    '&': 5,
    '==': 6,
    '!=': 6,
    '<=': 7,
    '>=': 7,
    '<': 7,
    '>': 7,
    '<<': 8,
    '>>': 8,
    '+': 9,
    '-': 9,
    '*': 10,
    '/': 10,
    '%': 10,
    '~/': 10,
    'P': 11,
    'C': 12,
  };

  // This function is responsible for gobbling an individual expression,
  // e.g. `1`, `1+2`, `a+(b*2)-Math.sqrt(2)`
  Parser<String> get binaryOperation {
    // Order operators by descending length to avoid partial matches
    final sortedOps = binaryOperations.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    return sortedOps
        .map<Parser<String>>((v) => string(v))
        .reduce((a, b) => (a | b).cast<String>())
        .trim();
  }

  Parser<Expression> get binaryExpression =>
      token.starSeparated(binaryOperation).map((result) {
        // Reconstruct the flat list with elements and separators interleaved
        final List<dynamic> elements = <dynamic>[];
        for (int i = 0; i < result.elements.length; i++) {
          elements.add(result.elements[i]);
          if (i < result.separators.length) {
            elements.add(result.separators[i]);
          }
        }
        // elements = [leftOperand, operator, rightOperand, operator, rightOperand, ...]
        if (elements.length == 1) {
          return elements[0]; // Only a single operand, return it directly
        }

        // Handle right-associativity for the `^` operator
        List<dynamic> processRightAssociative(
            List<dynamic> tokens, String operator) {
          while (tokens.contains(operator)) {
            int index = tokens.lastIndexOf(operator);
            var right = tokens.removeAt(index + 1);
            tokens.removeAt(index); // Remove operator
            var left = tokens.removeAt(index - 1);
            tokens.insert(index - 1, BinaryExpression(operator, left, right));
          }
          return tokens;
        }

        // Start with the rightmost `^` operators
        var stack = elements;
        stack = processRightAssociative(stack, '^');

        // Then handle other operators with standard precedence rules
        while (stack.length > 1) {
          int maxPrecedence = BinaryExpression.precedenceForOperator(stack[1]);
          int index = 1;

          for (int i = 3; i < stack.length; i += 2) {
            int precedence = BinaryExpression.precedenceForOperator(stack[i]);
            if (precedence > maxPrecedence) {
              maxPrecedence = precedence;
              index = i;
            }
          }

          var left = stack[index - 1];
          var operator = stack[index];
          var right = stack[index + 1];

          stack.replaceRange(
              index - 1, index + 2, [BinaryExpression(operator, left, right)]);
        }

        return stack[0];
      });

  // Use a quickly-accessible map to store all of the unary operators
  // Values are set to `true` (it really doesn't matter)
  static const _unaryOperations = ['-', '!', '~', '+'];

  Parser<void> _lookahead(Parser parser) => parser.and();
  Parser<UnaryExpression> get unaryExpression {
    // Operand parser: Matches numbers and booleans
    final operandParser = (string('true').map((_) => Literal(true)) |
            string('false').map((_) => Literal(false)) |
            digit().plus().flatten().map((value) => Literal(int.parse(value))))
        .trim();

    // Operator parser
    final operatorParser = _unaryOperations
        .map<Parser<String>>((op) {
          // Special handling for factorial to avoid conflict with !=
          if (op == '!') {
            return string('!').seq(_lookahead(char('=').not())).map((_) => '!');
          }
          return string(op);
        })
        .reduce((a, b) => (a | b).cast())
        .trim();

    // Suffix unary parser
    final suffixUnaryParser = operandParser.seq(operatorParser).map((parsed) {
      final operand = parsed[0] as Expression; // Ensure it's an Expression
      final operator = parsed[1] as String; // Operator is a string
      return UnaryExpression(operator, operand, prefix: false);
    });

    // Prefix unary parser
    final prefixUnaryParser = operatorParser.seq(operandParser).map((parsed) {
      final operator = parsed[0] as String; // Operator is a string
      final operand = parsed[1] as Expression; // Ensure it's an Expression
      return UnaryExpression(operator, operand, prefix: true);
    });

    // Combine prefix and suffix parsers
    return (prefixUnaryParser | suffixUnaryParser).cast();
  }

  // Gobbles a list of arguments within the context of a function call
  // or array literal. This function also assumes that the opening character
  // `(` or `[` has already been gobbled, and gobbles expressions and commas
  // until the terminator character `)` or `]` is encountered.
  // e.g. `foo(bar, baz)`, `my_func()`, or `[bar, baz]`
  Parser<List<Expression>> get arguments => expression
      .starSeparated(char(',').trim())
      .map((result) => result.elements)
      .castList<Expression>()
      .optionalWith([]);

  Parser<Map<Expression, Expression>> get mapArguments =>
      (expression & char(':').trim() & expression)
          .map((l) => MapEntry<Expression, Expression>(l[0], l[2]))
          .starSeparated(char(',').trim())
          .map((result) => result.elements)
          .castList<MapEntry<Expression, Expression>>()
          .map((l) => Map.fromEntries(l))
          .optionalWith({});

  // Gobble a non-literal variable name. This variable name may include properties
  // e.g. `foo`, `bar.baz`, `foo['bar'].baz`
  // It also gobbles function calls:
  // e.g. `Math.acos(obj.angle)`
  Parser<Expression> get variable => groupOrIdentifier
          .seq((memberArgument.cast() | indexArgument | callArgument).star())
          .map((l) {
        var a = l[0] as Expression;
        var b = l[1] as List;
        return b.fold(a, (Expression object, argument) {
          if (argument is Identifier) {
            return MemberExpression(object, argument);
          }
          if (argument is Expression) {
            return IndexExpression(object, argument);
          }
          if (argument is List<Expression>) {
            return CallExpression(object, argument);
          }
          throw ArgumentError('Invalid type ${argument.runtimeType}');
        });
      });

  // Responsible for parsing a group of things within parentheses `()`
  // This function assumes that it needs to gobble the opening parenthesis
  // and then tries to gobble everything within that parenthesis, assuming
  // that the next thing it should see is the close parenthesis. If not,
  // then the expression probably doesn't have a `)`
  Parser<Expression> get group =>
      (char('(') & expression.trim() & char(')')).pick(1).cast();

  Parser<Expression> get groupOrIdentifier =>
      (group | thisExpression | identifier.map((v) => Variable(v))).cast();

  Parser<Identifier> get memberArgument =>
      (char('.') & identifier).pick(1).cast();

  Parser<Expression> get indexArgument =>
      (char('[') & expression.trim() & char(']')).pick(1).cast();

  Parser<List<Expression>> get callArgument =>
      (char('(') & arguments.trim() & char(')')).pick(1).cast();

  // Ternary expression: test ? consequent : alternate
  Parser<List<Expression>> get conditionArguments =>
      (char('?').trim() & expression.trim() & char(':').trim())
          .pick(1)
          .seq(expression)
          .castList();

  final SettableParser<Expression> expression = undefined();
}
