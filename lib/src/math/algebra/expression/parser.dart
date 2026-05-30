import 'package:petitparser/petitparser.dart';
import '../../../number/decimal/rational.dart';
import 'expression.dart';
import '../calculus/symbolic_integration.dart';
import '../../../number/complex/complex.dart';
import 'package:advance_math/advance_math.dart' show LRUCache;

class ExpressionParser {
  static final _parseCache = LRUCache<String, Expression>(maxSize: 1000);

  ExpressionParser() {
    expression.set(binaryExpression.seq(conditionArguments.optional()).map(
        (l) => l[1] == null
            ? l[0]
            : ConditionalExpression(
                condition: l[0], ifTrue: l[1][0], ifFalse: l[1][1])));
    token.set((unaryExpression | variable).cast<Expression>());
  }

  Expression? tryParse(String formattedString) {
    final cached = _parseCache.get(formattedString);
    if (cached != null) return cached;

    final result = expression.trim().end().parse(formattedString);
    if (result is Success) {
      final parsed = result.value;
      _parseCache.put(formattedString, parsed);
      return parsed;
    }
    return null;
  }

  Expression parse(String formattedString) {
    final cached = _parseCache.get(formattedString);
    if (cached != null) return cached;

    final parsed = expression.trim().end().parse(formattedString).value;
    _parseCache.put(formattedString, parsed);
    return parsed;
  }

  // Gobbles only identifiers
  // e.g.: `foo`, `_value`, `$x1`
  Parser<Identifier> get identifier =>
      (digit().not() & (word() | char(r'$')).plus())
          .flatten()
          .map((v) => Identifier(v));

  // Parse simple numeric literals: `12`, `3.4`, `.5`, `1.2e3`, `1e-4`
  Parser<Literal> get numericLiteral => ((digit() | char('.')).and() &
              (digit().star() &
                  ((char('.') &
                              digit().plus() &
                              (anyOf('Ee') &
                                      anyOf('+-').optional() &
                                      digit().plus())
                                  .optional()) |
                          (anyOf('Ee') &
                              anyOf('+-').optional() &
                              digit().plus()) |
                          (char('x') & digit().plus()))
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
    '=': 6,
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
    'IMPLICIT_MUL': 10,
    'P': 11,
    'C': 12,
    ':': 13,
  };

  // Explicit binary operators (excluding implicit multiplication)
  Parser<String> get explicitBinaryOps {
    // Order operators by descending length to avoid partial matches
    final sortedOps = binaryOperations.keys
        .where((k) => k != 'IMPLICIT_MUL')
        .toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    return sortedOps
        .map<Parser<String>>((v) => string(v))
        .reduce((a, b) => (a | b).cast<String>())
        .trim();
  }

  // This function is responsible for gobbling an individual expression,
  // e.g. `1`, `1+2`, `a+(b*2)-Math.sqrt(2)`
  Parser<String> get binaryOperation {
    final explicitOps = explicitBinaryOps;

    // Implicit multiplication: matches empty string if followed by a token start
    // Token starts: digit, ., letter, $, _, (, [, {
    final implicitOp = whitespace()
        .star()
        .seq(_lookahead(digit() |
            char('.') |
            letter() |
            anyOf(r'$_([{') |
            anyOf('!~'))) // ! and ~ are unary but not binary.
        .map((_) => 'IMPLICIT_MUL');

    return explicitOps.or(implicitOp).cast<String>();
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
            case 'IMPLICIT_MUL':
              // Check for implicit function call: sin x -> sin(x)
              if (left is Variable) {
                final name = left.identifier.name;
                if (_implicitFunctions.contains(name)) {
                  return _createFunctionCall(name, [right]);
                }
              }
              return Multiply(left, right);
            case '/':
              return Divide(left, right);
            case '^':
              return Pow(left, right);
            case '=':
              return Subtract(left, right);
            case '%':
              return Modulo(left, right);
            case ':':
              return BinaryExpression(':', left, right);
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

            // Precedence fix for -x^y vs (-x)^y
            // If left is UnaryExpression (prefix) and NOT GroupExpression,
            // we rewrite -x^y as -(x^y).
            // Note: GroupExpression wraps parenthesized expressions.
            // If we have (-2)^2, left is GroupExpression(UnaryExpression).
            // If we have -2^2, left is UnaryExpression.
            if (left is UnaryExpression &&
                left.prefix &&
                left is! GroupExpression) {
              // Rewrite: Unary(op, operand) ^ right -> Unary(op, operand ^ right)
              // We need to create a new binary expression for operand ^ right
              var innerBinary = createBinary(operator, left.operand, right);
              tokens.insert(
                  index - 1,
                  UnaryExpression(left.operator, innerBinary,
                      prefix: left.prefix));
            } else {
              tokens.insert(index - 1, createBinary(operator, left, right));
            }
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
    final factorialOp =
        string('!').seq(_lookahead(char('=').not())).map((_) => '!').trim();

    // Percentage operator: % (only if followed by explicit binary op, ) or end)
    // We explicitly exclude IMPLICIT_MUL from the lookahead to avoid ambiguity with modulo
    final percentageOp = char('%')
        .seq(_lookahead(explicitBinaryOps | char(')') | endOfInput()))
        .map((_) => '%')
        .trim();

    final suffixOps = (factorialOp | percentageOp).cast<String>();

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
      .plusSeparated(char(',').trim())
      .map((result) => result.elements)
      .castList<Expression>()
      .optionalWith([]);

  Parser<Map<Expression, Expression>> get mapArguments =>
      (expression & char(':').trim() & expression)
          .map((l) => MapEntry<Expression, Expression>(l[0], l[2]))
          .plusSeparated(char(',').trim())
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
  Parser<Expression> get variable => ((groupOrIdentifierNoNumeric
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

              // Hyperbolic trigonometric functions
              if (name == 'sinh' && args.length == 1) return Trigonometric('sinh', args[0]);
              if (name == 'cosh' && args.length == 1) return Trigonometric('cosh', args[0]);
              if (name == 'tanh' && args.length == 1) return Trigonometric('tanh', args[0]);
              if (name == 'sech' && args.length == 1) return Trigonometric('sech', args[0]);
              if (name == 'csch' && args.length == 1) return Trigonometric('csch', args[0]);
              if (name == 'coth' && args.length == 1) return Trigonometric('coth', args[0]);

              // Inverse Hyperbolic trigonometric functions
              if (name == 'asinh' && args.length == 1) return Trigonometric('asinh', args[0]);
              if (name == 'acosh' && args.length == 1) return Trigonometric('acosh', args[0]);
              if (name == 'atanh' && args.length == 1) return Trigonometric('atanh', args[0]);
              if (name == 'asech' && args.length == 1) return Trigonometric('asech', args[0]);
              if (name == 'acsch' && args.length == 1) return Trigonometric('acsch', args[0]);
              if (name == 'acoth' && args.length == 1) return Trigonometric('acoth', args[0]);

              // Exponential / Logarithmic
              if (name == 'exp' && args.length == 1) return Exp(args[0]);
              if (name == 'abs' && args.length == 1) return Abs(args[0]);
              if (name == 'sqrt' && args.length == 1) {
                return Pow(args[0], Literal(Rational(1, 2)));
              }
              if (name == 'sinc' && args.length == 1) {
                return Divide(Sin(args[0]), args[0]);
              }
              if (name == 'ln' && args.length == 1) return Ln(args[0]);
              if (name == 'log' && args.length == 1) {
                // log(x) treated as natural logarithm for solver compatibility
                return Ln(args[0]);
              }
              if (name == 'log' && args.length == 2) {
                // log(base, x) => Log(base, operand)
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

              if (name == 'solveEquations' && args.isNotEmpty) {
                // solveEquations(equations, [variables])
                var equationsArg = args[0];
                List<Expression> equations = [];

                if (equationsArg is Literal && equationsArg.value is List) {
                  final list = equationsArg.value as List;
                  for (var item in list) {
                    if (item is Literal && item.value is String) {
                      // Parse the string
                      equations.add(ExpressionParser().parse(item.value));
                    } else if (item is Expression) {
                      equations.add(item);
                    } else if (item is String) {
                      // Parse the string (if raw string in list)
                      equations.add(ExpressionParser().parse(item));
                    }
                  }
                }

                List<Variable>? variables;
                if (args.length > 1) {
                  var varsArg = args[1];
                  if (varsArg is Literal && varsArg.value is List) {
                    variables = (varsArg.value as List).map((e) {
                      if (e is Literal && e.value is String) {
                        return Variable(Identifier(e.value));
                      }
                      return Variable(Identifier(e.toString()));
                    }).toList();
                  }
                }

                final solutions =
                    ExpressionSolver.solveEquations(equations, variables);
                return Literal(solutions, solutions.join(','));
              }

              // Algebra functions
              if (name == 'simplify' && args.length == 1) {
                return args[0].simplify();
              }

              if (name == 'factor' && args.length == 1) {
                if (args[0] is Polynomial) {
                  final factors = (args[0] as Polynomial).factorize();
                  if (factors.isEmpty) return Literal(1);
                  Expression result = factors[0];
                  for (int i = 1; i < factors.length; i++) {
                    result = Multiply(result, factors[i]);
                  }
                  return result;
                }
                // Try to parse as polynomial
                try {
                  final poly = Polynomial.fromString(args[0].toString());
                  final factors = poly.factorize();
                  if (factors.isEmpty) return Literal(1);
                  Expression result = factors[0];
                  for (int i = 1; i < factors.length; i++) {
                    result = Multiply(result, factors[i]);
                  }
                  return result;
                } catch (e) {
                  return args[0];
                }
              }

              if (name == 'deg' && args.isNotEmpty) {
                Expression expr = args[0];
                if (expr is Polynomial) {
                  return Literal(expr.degree);
                }
                try {
                  final poly = Polynomial.fromString(expr.toString());
                  return Literal(poly.degree);
                } catch (e) {
                  // If variable provided, try to find max degree of that variable
                  if (args.length > 1 && args[1] is Variable) {
                    // Placeholder for general degree finding
                    return Literal(0);
                  }
                  return Literal(0);
                }
              }

              if (name == 'pfactor' && args.length == 1) {
                // Prime factorization of integer
                if (args[0] is Literal && (args[0] as Literal).value is int) {
                  int n = (args[0] as Literal).value as int;
                  // Basic implementation
                  Map<int, int> factors = {};
                  int d = 2;
                  int temp = n;
                  while (d * d <= temp) {
                    while (temp % d == 0) {
                      factors[d] = (factors[d] ?? 0) + 1;
                      temp ~/= d;
                    }
                    d++;
                  }
                  if (temp > 1) {
                    factors[temp] = (factors[temp] ?? 0) + 1;
                  }
                  // Construct expression: (p1^e1)*(p2^e2)...
                  if (factors.isEmpty) return args[0];

                  List<Expression> terms = [];
                  factors.forEach((p, e) {
                    terms.add(Pow(Literal(p), Literal(e)));
                  });

                  Expression result = terms[0];
                  for (int i = 1; i < terms.length; i++) {
                    result = Multiply(result, terms[i]);
                  }
                  return result;
                }
                // Factorial case: pfactor(100!)
                if (args[0] is UnaryExpression &&
                    (args[0] as UnaryExpression).operator == '!') {
                  // Placeholder for factorial prime factorization
                  return args[0];
                }
                return args[0];
              }

              if (name == 'coeffs' && args.length >= 2) {
                // coeffs(poly, var)
                try {
                  Polynomial poly = Polynomial.fromString(args[0].toString());
                  // Polynomial coefficients are stored high to low degree.
                  // Expectation might be low to high or specific format.
                  // Test says: coeffs(x^2+2*x+1, x) -> [1,2,1] (low to high?)
                  // Polynomial stores [1, 2, 1] for x^2+2x+1? No, usually high to low.
                  // Polynomial([1, 2, 1]) -> 1*x^2 + 2*x + 1.
                  // Let's check Polynomial implementation.
                  // coefficients[0] is highest degree.
                  // If test expects [1, 2, 1] for x^2+2x+1, it matches high to low?
                  // Wait, coeffs(t*x, x) -> [0, t]. This is low to high (constant, x^1).
                  // So we need to reverse the coefficients from Polynomial (which are high to low).
                  List<dynamic> coeffs = poly.coefficients.reversed.map((c) {
                    if (c is Literal &&
                        c.value is Complex &&
                        (c.value as Complex).imaginary == 0) {
                      return (c.value as Complex).real;
                    }
                    return c;
                  }).toList();
                  return Literal(coeffs, coeffs.toString());
                } catch (e) {
                  return Literal([]);
                }
              }

              if (name == 'line' && args.length >= 2) {
                if (args[0] is Literal &&
                    (args[0] as Literal).value is List &&
                    args[1] is Literal &&
                    (args[1] as Literal).value is List) {
                  List p1 = (args[0] as Literal).value as List;
                  List p2 = (args[1] as Literal).value as List;
                  if (p1.length == 2 && p2.length == 2) {
                    var x1 = p1[0];
                    var y1 = p1[1];
                    var x2 = p2[0];
                    var y2 = p2[1];

                    var x1Val = x1 is Expression ? x1.evaluate() : x1;
                    var y1Val = y1 is Expression ? y1.evaluate() : y1;
                    var x2Val = x2 is Expression ? x2.evaluate() : x2;
                    var y2Val = y2 is Expression ? y2.evaluate() : y2;

                    if ((x1Val is Complex ||
                            x1Val is num ||
                            x1Val is Rational) &&
                        (y1Val is Complex ||
                            y1Val is num ||
                            y1Val is Rational) &&
                        (x2Val is Complex ||
                            x2Val is num ||
                            x2Val is Rational) &&
                        (y2Val is Complex ||
                            y2Val is num ||
                            y2Val is Rational)) {
                      Complex cx1 = Complex(x1Val);
                      Complex cy1 = Complex(y1Val);
                      Complex cx2 = Complex(x2Val);
                      Complex cy2 = Complex(y2Val);
                      Complex cm = (cy2 - cy1) / (cx2 - cx1);
                      Complex cC = cy1 - cm * cx1;

                      return Add(
                              Multiply(Literal(cm), Variable('x')), Literal(cC))
                          .simplify();
                    } else {
                      Expression ex1 = x1 is Expression ? x1 : Literal(x1);
                      Expression ey1 = y1 is Expression ? y1 : Literal(y1);
                      Expression ex2 = x2 is Expression ? x2 : Literal(x2);
                      Expression ey2 = y2 is Expression ? y2 : Literal(y2);

                      var m = (ey2 - ey1) / (ex2 - ex1);
                      var tVar = args.length >= 3
                          ? Variable(args[2].toString())
                          : Variable('x');

                      return Add(Multiply(m, tVar),
                              Add(Multiply(Literal(-1), Multiply(m, ex1)), ey1))
                          .simplify();
                    }
                  }
                }
              }

              if (name == 'roots' && args.length == 1) {
                try {
                  Polynomial poly = Polynomial.fromString(args[0].toString());
                  return Literal(poly.roots(), poly.roots().toString());
                } catch (e) {
                  return Literal([]);
                }
              }

              if ((name == 'sqcomp' || name == 'completeSquare') &&
                  args.isNotEmpty) {
                // Complete the square: ax^2 + bx + c
                // a(x + b/2a)^2 + (c - b^2/4a)
                try {
                  String varName = 'x';
                  final String source = args[0].toString();
                  // Clean standard math functions to avoid mistaking them for variable name
                  final cleanSource = source.replaceAll(RegExp(r'\b(sqcomp|completeSquare|sin|cos|tan|asin|acos|atan|sinh|cosh|tanh|log|ln|exp|abs|sqrt)\b'), '');
                  final match = RegExp(r'[a-zA-Z]').firstMatch(cleanSource);
                  if (match != null) {
                    varName = match.group(0)!;
                  }

                  Polynomial poly = Polynomial.fromString(source, variable: Variable(varName));
                  if (poly.degree == 2) {
                    var a = poly.coefficients[0]; // x^2
                    var b = poly.coefficients[1]; // x^1
                    var c = poly.coefficients[2]; // x^0

                    // Construct: a * (var + b/(2a))^2 + (c - b^2/(4a))
                    Expression term1 = a *
                        Pow(Variable(varName) + b / (Literal(2) * a), Literal(2));
                    Expression term2 = c - (b * b) / (Literal(4) * a);
                    return (term1 + term2).simplify();
                  }
                } catch (e) {
                  return args[0];
                }
              }
            }
            return CallExpression(object, argument);
          }
          throw ArgumentError('Invalid type ${argument.runtimeType}');
        });
      })) | numericLiteral).cast<Expression>();

  // Responsible for parsing a group of things within parentheses `()`
  // This function assumes that it needs to gobble the opening parenthesis
  // and then tries to gobble everything within that parenthesis, assuming
  // that the next thing it should see is the close parenthesis. If not,
  // then the expression probably doesn't have a `)`
  Parser<Expression> get group => (char('(') & expression.trim() & char(')'))
      .pick(1)
      .map((e) => GroupExpression(e as Expression));

  Parser<Literal> get otherLiteral => (stringLiteral |
          boolLiteral |
          nullLiteral |
          arrayLiteral |
          mapLiteral)
      .cast();

  Parser<Expression> get groupOrIdentifierNoNumeric =>
      (group | thisExpression | otherLiteral | identifier.map((v) => Variable(v)))
          .cast();

  Parser<Expression> get groupOrIdentifier =>
      (group | thisExpression | literal | identifier.map((v) => Variable(v)))
          .cast();

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

  // Binary expression variant that does NOT include ':' as a valid operator.
  // Used in the ifTrue branch of ternary to prevent ':' from being consumed.
  Parser<String> get explicitBinaryOpsNoColon {
    final sortedOps = binaryOperations.keys
        .where((k) => k != 'IMPLICIT_MUL' && k != ':')
        .toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    return sortedOps
        .map<Parser<String>>((v) => string(v))
        .reduce((a, b) => (a | b).cast<String>())
        .trim();
  }

  Parser<String> get binaryOperationNoColon {
    final explicitOps = explicitBinaryOpsNoColon;
    final implicitOp = whitespace()
        .star()
        .seq(_lookahead(
            digit() | char('.') | letter() | anyOf(r'$_([{') | anyOf('!~')))
        .map((_) => 'IMPLICIT_MUL');
    return explicitOps.or(implicitOp).cast<String>();
  }

  Parser<Expression> get binaryExpressionNoColon =>
      token.starSeparated(binaryOperationNoColon).map((result) {
        final List<dynamic> elements = <dynamic>[];
        for (int i = 0; i < result.elements.length; i++) {
          elements.add(result.elements[i]);
          if (i < result.separators.length) {
            elements.add(result.separators[i]);
          }
        }
        if (elements.isEmpty) throw FormatException('Empty binary expression');
        if (elements.length == 1) return elements[0];

        Expression createBinary(String op, Expression l, Expression r) {
          switch (op) {
            case '+':
              return Add(l, r);
            case '-':
              return Subtract(l, r);
            case '*':
            case 'IMPLICIT_MUL':
              return Multiply(l, r);
            case '/':
              return Divide(l, r);
            case '^':
              return Pow(l, r);
            case '=':
              return Subtract(l, r);
            case '%':
              return Modulo(l, r);
            default:
              return BinaryExpression(op, l, r);
          }
        }

        List<dynamic> processRight(List<dynamic> tokens, String op) {
          while (tokens.contains(op)) {
            int idx = tokens.lastIndexOf(op);
            var right = tokens.removeAt(idx + 1);
            tokens.removeAt(idx);
            var left = tokens.removeAt(idx - 1);
            tokens.insert(idx - 1, createBinary(op, left, right));
          }
          return tokens;
        }

        var stack = elements;
        stack = processRight(stack, '^');
        while (stack.length > 1) {
          int maxPrec = BinaryExpression.precedenceForOperator(stack[1]);
          int index = 1;
          for (int i = 3; i < stack.length; i += 2) {
            int prec = BinaryExpression.precedenceForOperator(stack[i]);
            if (prec > maxPrec) {
              maxPrec = prec;
              index = i;
            }
          }
          var l = stack[index - 1];
          var op = stack[index];
          var r = stack[index + 1];
          stack.replaceRange(index - 1, index + 2, [createBinary(op, l, r)]);
        }
        return stack[0];
      });

  // Ternary expression: test ? consequent : alternate
  // Note: use binaryExpressionNoColon for ifTrue to prevent ':' (binary range op)
  // from consuming the ternary separator.
  Parser<List<Expression>> get conditionArguments =>
      (char('?').trim() & binaryExpressionNoColon.trim() & char(':').trim())
          .pick(1)
          .seq(expression)
          .castList();

  static const Set<String> _implicitFunctions = {
    'sin',
    'cos',
    'tan',
    'sec',
    'csc',
    'cot',
    'asin',
    'acos',
    'atan',
    'sinh',
    'cosh',
    'tanh',
    'sech',
    'csch',
    'coth',
    'asinh',
    'acosh',
    'atanh',
    'asech',
    'acsch',
    'acoth',
    'exp',
    'abs',
    'ln',
    'log',
    'sqrt',
    'fact',
  };

  Expression _createFunctionCall(String name, List<Expression> args) {
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

    // Hyperbolic functions
    if (name == 'sinh' && args.length == 1) return Trigonometric('sinh', args[0]);
    if (name == 'cosh' && args.length == 1) return Trigonometric('cosh', args[0]);
    if (name == 'tanh' && args.length == 1) return Trigonometric('tanh', args[0]);
    if (name == 'sech' && args.length == 1) return Trigonometric('sech', args[0]);
    if (name == 'csch' && args.length == 1) return Trigonometric('csch', args[0]);
    if (name == 'coth' && args.length == 1) return Trigonometric('coth', args[0]);

    // Inverse Hyperbolic functions
    if (name == 'asinh' && args.length == 1) return Trigonometric('asinh', args[0]);
    if (name == 'acosh' && args.length == 1) return Trigonometric('acosh', args[0]);
    if (name == 'atanh' && args.length == 1) return Trigonometric('atanh', args[0]);
    if (name == 'asech' && args.length == 1) return Trigonometric('asech', args[0]);
    if (name == 'acsch' && args.length == 1) return Trigonometric('acsch', args[0]);
    if (name == 'acoth' && args.length == 1) return Trigonometric('acoth', args[0]);

    // Exponential / Logarithmic
    if (name == 'exp' && args.length == 1) return Exp(args[0]);
    if (name == 'abs' && args.length == 1) return Abs(args[0]);
    if (name == 'ln' && args.length == 1) return Ln(args[0]);
    if (name == 'log' && args.length == 1) {
      // log(x) treated as natural logarithm for solver compatibility
      return Ln(args[0]);
    }
    if (name == 'log' && args.length == 2) {
      return Log(args[0], args[1]);
    }
    if (name == 'sqrt' && args.length == 1) {
      return Pow(args[0], Literal(0.5));
    }

    // Default to generic call
    return CallExpression(Variable(name), args);
  }

  final SettableParser<Expression> expression = undefined();
}
