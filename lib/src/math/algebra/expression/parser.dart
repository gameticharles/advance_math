import 'package:petitparser/petitparser.dart';
import 'expression.dart';
import '../calculus/symbolic_integration.dart';
import '../solver/equation_solver.dart';

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
        if (elements.isEmpty) {
          throw FormatException('Binary expression cannot be empty');
        }
        if (elements.length == 1) {
          return elements[0]; // Only a single operand, return it directly
        }

        // Helper to create specific binary expressions
        Expression createBinary(String op, Expression left, Expression right) {
          switch (op) {
            case '+':
              return Add(left, right);
            case '-':
              return Subtract(left, right);
            case '*':
              return Multiply(left, right);
            case '/':
              return Divide(left, right);
            case '^':
              return Pow(left, right);
            default:
              return BinaryExpression(op, left, right);
          }
        }

        // Handle right-associativity for the `^` operator
        List<dynamic> processRightAssociative(
            List<dynamic> tokens, String operator) {
          while (tokens.contains(operator)) {
            int index = tokens.lastIndexOf(operator);
            var right = tokens.removeAt(index + 1);
            tokens.removeAt(index); // Remove operator
            var left = tokens.removeAt(index - 1);
            tokens.insert(index - 1, createBinary(operator, left, right));
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
              index - 1, index + 2, [createBinary(operator, left, right)]);
        }

        return stack[0];
      });

  // Use a quickly-accessible map to store all of the unary operators
  // Values are set to `true` (it really doesn't matter)
  static const _unaryOperations = ['-', '!', '~', '+'];

  Parser<void> _lookahead(Parser parser) => parser.and();
  Parser<UnaryExpression> get unaryExpression {
    // Atom parser: Matches literals, variables, and groups
    final atom = (literal | variable | groupOrIdentifier).trim();

    // Prefix operators: +, -, !, ~
    final prefixOps = _unaryOperations
        .map((op) => string(op))
        .reduce((a, b) => (a | b).cast<String>())
        .trim();

    // Suffix operators: ! (factorial)
    final suffixOps =
        string('!').seq(_lookahead(char('=').not())).map((_) => '!').trim();

    // Suffix unary parser: Must use atom to avoid left recursion
    final suffixUnaryParser = atom.seq(suffixOps).map((parsed) {
      final operand = parsed[0] as Expression;
      final operator = parsed[1] as String;
      return UnaryExpression(operator, operand, prefix: false);
    });

    // Prefix unary parser: Can use token because operator is consumed first
    final prefixUnaryParser = prefixOps.seq(token).map((parsed) {
      final operator = parsed[0] as String;
      final operand = parsed[1] as Expression;
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
            // Handle function calls
            if (object is Variable) {
              final name = object.identifier.name;
              final args = argument;

              // Trigonometric functions
              if (name == 'sin' && args.length == 1) return Sin(args[0]);
              if (name == 'cos' && args.length == 1) return Cos(args[0]);
              if (name == 'tan' && args.length == 1) return Tan(args[0]);
              if (name == 'sec' && args.length == 1) return Sec(args[0]);
              if (name == 'csc' && args.length == 1) return Csc(args[0]);
              if (name == 'cot' && args.length == 1) return Cot(args[0]);

              // Inverse Trigonometric functions
              if (name == 'asin' && args.length == 1) return Asin(args[0]);
              if (name == 'acos' && args.length == 1) return Acos(args[0]);
              if (name == 'atan' && args.length == 1) return Atan(args[0]);

              // Exponential / Logarithmic
              if (name == 'exp' && args.length == 1) return Exp(args[0]);
              if (name == 'abs' && args.length == 1) return Abs(args[0]);
              if (name == 'ln' && args.length == 1) return Ln(args[0]);
              if (name == 'log' && args.length == 1) {
                return Log(args[0], Literal(10)); // Default base 10
              }
              if (name == 'log' && args.length == 2) {
                return Log(args[0], args[1]);
              }

              // Calculus & Solver
              if ((name == 'diff' || name == 'differentiate') &&
                  args.length >= 2) {
                // diff(expr, var)
                if (args[1] is Variable) {
                  return args[0].differentiate(args[1] as Variable).simplify();
                }
              }

              if (name == 'integrate' && args.length >= 2) {
                // integrate(expr, var)
                if (args[1] is Variable) {
                  return SymbolicIntegration.integrate(
                      args[0], args[1] as Variable);
                }
              }

              if (name == 'solve' && args.length >= 2) {
                // solve(equation, var)
                if (args[1] is Variable) {
                  final solutions =
                      ExpressionSolver.solve(args[0], args[1] as Variable);
                  return Literal(solutions, solutions.toString());
                }
              }
            }
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
      (char('(') & arguments.trim() & char(')'))
          .pick(1)
          .cast<List<Expression>>()
          .map((l) {
        // print('Call args parsed: $l');
        return l;
      });

  // Ternary expression: test ? consequent : alternate
  Parser<List<Expression>> get conditionArguments =>
      (char('?').trim() & expression.trim() & char(':').trim())
          .pick(1)
          .seq(expression)
          .castList();

  final SettableParser<Expression> expression = undefined();
}
