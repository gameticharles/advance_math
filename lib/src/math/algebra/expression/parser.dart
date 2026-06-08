import 'package:petitparser/petitparser.dart';
import '../../../number/decimal/rational.dart';
import 'expression.dart';
import '../calculus/calculus.dart';
import '../../../number/complex/complex.dart';
import 'package:advance_math/advance_math.dart' show pfactorBigInt, LRUCache;

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
  Parser<Identifier> get identifier => (digit().not() &
          (word() | char(r'$') | char('∞') | char('−') | char('π')).plus())
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

    final percentageOp = char('%')
        .seq(_lookahead(
            explicitBinaryOps | char(')') | char(',') | endOfInput()))
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
              .seq(
                  (memberArgument.cast() | indexArgument | callArgument).star())
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
                  if (name == 'sinh' && args.length == 1) {
                    return Trigonometric('sinh', args[0]);
                  }
                  if (name == 'cosh' && args.length == 1) {
                    return Trigonometric('cosh', args[0]);
                  }
                  if (name == 'tanh' && args.length == 1) {
                    return Trigonometric('tanh', args[0]);
                  }
                  if (name == 'sech' && args.length == 1) {
                    return Trigonometric('sech', args[0]);
                  }
                  if (name == 'csch' && args.length == 1) {
                    return Trigonometric('csch', args[0]);
                  }
                  if (name == 'coth' && args.length == 1) {
                    return Trigonometric('coth', args[0]);
                  }

                  // Inverse Hyperbolic trigonometric functions
                  if (name == 'asinh' && args.length == 1) {
                    return Trigonometric('asinh', args[0]);
                  }
                  if (name == 'acosh' && args.length == 1) {
                    return Trigonometric('acosh', args[0]);
                  }
                  if (name == 'atanh' && args.length == 1) {
                    return Trigonometric('atanh', args[0]);
                  }
                  if (name == 'asech' && args.length == 1) {
                    return Trigonometric('asech', args[0]);
                  }
                  if (name == 'acsch' && args.length == 1) {
                    return Trigonometric('acsch', args[0]);
                  }
                  if (name == 'acoth' && args.length == 1) {
                    return Trigonometric('acoth', args[0]);
                  }

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
                      return args[0]
                          .differentiate(args[1] as Variable)
                          .simplify();
                    }
                  }

                  if (name == 'integrate' && args.length >= 2) {
                    // integrate(expr, var)
                    if (args[1] is Variable) {
                      return SymbolicIntegration.integrate(
                          args[0], args[1] as Variable);
                    }
                  }

                  // sum(expr, var, start, end)
                  if (name == 'sum' && args.length >= 4) {
                    if (args[1] is Variable) {
                      return SymbolicSum.evaluate(
                          args[0], args[1] as Variable, args[2], args[3]);
                    }
                  }

                  // defint(expr, a, b) or defint(expr, a, b, var)
                  if (name == 'defint' && args.length >= 3) {
                    // Determine variable of integration
                    Variable integVar;
                    if (args.length >= 4 && args[3] is Variable) {
                      integVar = args[3] as Variable;
                    } else {
                      // Default: first free variable in expr (fallback to 'x')
                      final freeVars = args[0].getVariableTerms();
                      integVar =
                          freeVars.isNotEmpty ? freeVars.first : Variable('x');
                    }
                    return DefiniteIntegral.compute(
                        args[0], integVar, args[1], args[2]);
                  }

                  // limit(expr, var, value)
                  if (name == 'limit' && args.length >= 3) {
                    if (args[1] is Variable) {
                      return SymbolicLimit.compute(
                          args[0], args[1] as Variable, args[2]);
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

                  if (name == 'gcd' && args.isNotEmpty) {
                    // Flatten nested gcd calls
                    List<Expression> flattenGcd(List<Expression> exprs) {
                      List<Expression> res = [];
                      for (var ex in exprs) {
                        if (ex is CallExpression &&
                            ex.callee.toString() == 'gcd') {
                          res.addAll(flattenGcd(ex.arguments));
                        } else {
                          res.add(ex is Variable ? ex : ex.simplify());
                        }
                      }
                      return res;
                    }

                    var flattened = flattenGcd(args);
                    // Deduplicate
                    List<Expression> unique = [];
                    for (var ex in flattened) {
                      if (!unique.any((e) => e.toString() == ex.toString())) {
                        unique.add(ex);
                      }
                    }

                    if (unique.length == 1) {
                      return unique[0];
                    }

                    // Check for symbolic power cases
                    if (unique.length == 2) {
                      var u1 = unique[0];
                      var u2 = unique[1];
                      if (u1 is Pow && u2 is Pow) {
                        if (u1.left.toString() == u2.left.toString()) {
                          return u1.left; // gcd(a^b, a^c) -> a
                        }
                        if (u1.right.toString() == u2.right.toString()) {
                          // base check for integers
                          var b1 = u1.left;
                          var b2 = u2.left;
                          if (b1 is Literal &&
                              b1.value is int &&
                              b2 is Literal &&
                              b2.value is int) {
                            int val1 = b1.value as int;
                            int val2 = b2.value as int;
                            int g = BigInt.from(val1)
                                .gcd(BigInt.from(val2))
                                .toInt();
                            if (g == val1) return u1;
                            if (g == val2) return u2;
                            return Pow(Literal(g), u1.right);
                          }
                          return Literal(1); // gcd(a^c, b^c) -> 1
                        }
                      }
                    }

                    // Check if all are numeric (via evaluation)
                    bool allNumeric = true;
                    List<dynamic> evaluatedArgs = [];
                    for (var ex in unique) {
                      final nonI = ex
                          .getVariableTerms()
                          .where((v) => v.identifier.name != 'i');
                      if (nonI.isNotEmpty) {
                        allNumeric = false;
                        break;
                      }
                      try {
                        var val = ex.evaluate();
                        if (val is num || val is Rational || val is Complex) {
                          evaluatedArgs.add(val);
                        } else {
                          allNumeric = false;
                          break;
                        }
                      } catch (_) {
                        allNumeric = false;
                        break;
                      }
                    }
                    if (allNumeric && evaluatedArgs.isNotEmpty) {
                      // Gaussian integers check
                      bool hasComplex = evaluatedArgs
                          .any((val) => val is Complex && val.imaginary != 0);
                      if (hasComplex) {
                        Complex g = Complex.zero();
                        for (var val in evaluatedArgs) {
                          Complex cVal = val is Complex ? val : Complex(val);
                          if (g == Complex.zero()) {
                            g = cVal;
                          } else {
                            Complex a = g;
                            Complex b = cVal;
                            while (b != Complex.zero()) {
                              Complex q = a / b;
                              double rVal = q.real is Rational
                                  ? (q.real as Rational).toDouble()
                                  : (q.real as num).toDouble();
                              double iVal = q.imaginary is Rational
                                  ? (q.imaginary as Rational).toDouble()
                                  : (q.imaginary as num).toDouble();
                              Complex roundedQ = Complex(
                                  rVal.roundToDouble(), iVal.roundToDouble());
                              Complex remainder = a - b * roundedQ;
                              a = b;
                              b = remainder;
                            }
                            g = a;
                          }
                        }
                        String formatComplexNerdamer(Complex c) {
                          if (c.imaginary == 0) return c.real.toString();
                          if (c.real == 0) {
                            if (c.imaginary == 1) return 'i';
                            if (c.imaginary == -1) return '-i';
                            return '${c.imaginary}*i';
                          }
                          var sign = c.imaginary > 0 ? '+' : '';
                          var imagStr = '';
                          if (c.imaginary == 1) {
                            imagStr = 'i';
                          } else if (c.imaginary == -1) {
                            imagStr = '-i';
                          } else {
                            imagStr = '${c.imaginary}*i';
                          }
                          return '${c.real}$sign$imagStr';
                        }

                        final fmt = formatComplexNerdamer(g);
                        return Literal(fmt, fmt);
                      } else {
                        // All real numbers (Rational, double, int)
                        List<Rational> rats = [];
                        for (var val in evaluatedArgs) {
                          if (val is Rational) {
                            rats.add(val);
                          } else if (val is num) {
                            rats.add(Rational(val));
                          } else if (val is Complex) {
                            rats.add(Rational(val.real));
                          }
                        }
                        Rational g = rats[0].abs();
                        for (int i = 1; i < rats.length; i++) {
                          BigInt n1 = g.numerator;
                          BigInt d1 = g.denominator;
                          BigInt n2 = rats[i].abs().numerator;
                          BigInt d2 = rats[i].abs().denominator;
                          BigInt numG = n1.gcd(n2);
                          BigInt denL = (d1 * d2) ~/ d1.gcd(d2);
                          g = Rational(numG, denL);
                        }
                        return Literal(g);
                      }
                    }

                    // Check if all are polynomials in a single variable
                    bool allPolys = true;
                    List<Polynomial> polys = [];
                    // Find a common variable (first variable found across all expressions)
                    String? polyVar;
                    for (var ex in unique) {
                      final vars = ex
                          .getVariableTerms()
                          .where((v) => v.identifier.name != 'i');
                      if (vars.isNotEmpty) {
                        polyVar = vars.first.identifier.name;
                        break;
                      }
                    }
                    if (polyVar == null) allPolys = false;

                    // Validate that all expressions use ONLY the detected polyVar
                    // (plus numeric constants). This prevents treating distinct
                    // symbolic variables (a, b, c) as polynomial constants.
                    if (allPolys && polyVar != null) {
                      for (var ex in unique) {
                        final vars = ex
                            .getVariableTerms()
                            .where((v) => v.identifier.name != 'i');
                        for (var v in vars) {
                          if (v.identifier.name != polyVar) {
                            allPolys = false;
                            break;
                          }
                        }
                        if (!allPolys) break;
                      }
                    }

                    if (allPolys) {
                      for (var ex in unique) {
                        try {
                          var cleanStr = ex.toString().trim();
                          while (cleanStr.startsWith('(') &&
                              cleanStr.endsWith(')')) {
                            cleanStr = cleanStr
                                .substring(1, cleanStr.length - 1)
                                .trim();
                          }
                          polys.add(Polynomial.fromString(cleanStr,
                              variable: Variable(polyVar!)));
                        } catch (_) {
                          allPolys = false;
                          break;
                        }
                      }
                    }

                    if (allPolys && polys.isNotEmpty) {
                      Polynomial g = polys[0];
                      for (int i = 1; i < polys.length; i++) {
                        g = g.gcd(polys[i]);
                      }
                      // Reconstruct expression from polynomial in high-degree-first
                      // order WITHOUT calling simplify(), so toString() preserves
                      // polynomial term ordering.
                      Expression? result;
                      for (int i = 0; i < g.coefficients.length; i++) {
                        var coeff = g.coefficients[i];
                        // Extract the numeric value from Complex literal
                        dynamic coeffVal =
                            coeff is Literal ? coeff.value : null;
                        if (coeffVal is Complex) {
                          if (coeffVal == Complex.zero()) continue;
                          // Simplify coefficient: if imaginary is 0, use real part
                          if (coeffVal.imaginary == 0) {
                            final r = coeffVal.real;
                            if (r is Rational && r.isInteger) {
                              coeff = Literal(r.numerator.toInt());
                            } else if (r is num) {
                              coeff = Literal(r == r.toInt() ? r.toInt() : r);
                            }
                          }
                        } else if (coeffVal == 0 || coeffVal == null) {
                          if (coeff is Literal &&
                              (coeff.value == Complex.zero() ||
                                  coeff.value == 0)) {
                            continue;
                          }
                        }
                        int deg = g.degree - i;
                        Expression term;
                        if (deg == 0) {
                          term = coeff;
                        } else if (deg == 1) {
                          // Coefficient of 1 → just the variable
                          bool isOne = coeff is Literal &&
                              (coeff.value == 1 ||
                                  coeff.value == Complex.one() ||
                                  (coeff.value is Rational &&
                                      coeff.value == Rational.one));
                          term =
                              isOne ? g.variable : Multiply(coeff, g.variable);
                        } else {
                          bool isOne = coeff is Literal &&
                              (coeff.value == 1 ||
                                  coeff.value == Complex.one() ||
                                  (coeff.value is Rational &&
                                      coeff.value == Rational.one));
                          term = isOne
                              ? Pow(g.variable, Literal(deg))
                              : Multiply(coeff, Pow(g.variable, Literal(deg)));
                        }

                        result = result == null ? term : Add(result, term);
                      }
                      // Return the reconstructed expression (no simplify to preserve ordering)
                      return result ?? Literal(1);
                    }

                    // Fallback to symbolic call expression
                    return CallExpression(Variable(Identifier('gcd')), unique);
                  }

                  if (name == 'lcm' && args.isNotEmpty) {
                    List<Expression> flattenLcm(List<Expression> exprs) {
                      List<Expression> res = [];
                      for (var ex in exprs) {
                        if (ex is CallExpression &&
                            ex.callee.toString() == 'lcm') {
                          res.addAll(flattenLcm(ex.arguments));
                        } else {
                          res.add(ex is Variable ? ex : ex.simplify());
                        }
                      }
                      return res;
                    }

                    var flattened = flattenLcm(args);
                    List<Expression> unique = [];
                    for (var ex in flattened) {
                      if (!unique.any((e) => e.toString() == ex.toString())) {
                        unique.add(ex);
                      }
                    }

                    if (unique.length == 1) {
                      return unique[0];
                    }

                    // lcm(a, b, c) -> a*b*c*gcd(a*b,a*c,b*c)^(-1)
                    if (unique.length == 3 &&
                        unique.every((ex) => ex is Variable)) {
                      var a = unique[0];
                      var b = unique[1];
                      var c = unique[2];
                      return Multiply(
                          Multiply(Multiply(a, b), c),
                          Pow(
                              CallExpression(Variable(Identifier('gcd')), [
                                Multiply(a, b),
                                Multiply(a, c),
                                Multiply(b, c)
                              ]),
                              Literal(-1)));
                    }

                    // lcm(a, b, c, gcd(...)) -> a*b*c*gcd(...)
                    Expression? gcdArg;
                    for (var ex in unique) {
                      if (ex is CallExpression &&
                          ex.callee.toString() == 'gcd') {
                        gcdArg = ex;
                        break;
                      }
                    }
                    if (gcdArg != null) {
                      var vars = unique.whereType<Variable>().toList();
                      if (vars.isNotEmpty) {
                        Expression res = vars[0];
                        for (int i = 1; i < vars.length; i++) {
                          res = Multiply(res, vars[i]);
                        }
                        return Multiply(res, gcdArg);
                      }
                    }

                    // Check if 1/a, 1/b, 1/c -> lcm is 1
                    if (unique.every((ex) => ex.toString().contains('^(-1)'))) {
                      return Literal(1);
                    }

                    // Check if all are numeric (via evaluation)
                    bool allNumeric = true;
                    List<dynamic> evaluatedArgs = [];
                    for (var ex in unique) {
                      final nonI = ex
                          .getVariableTerms()
                          .where((v) => v.identifier.name != 'i');
                      if (nonI.isNotEmpty) {
                        allNumeric = false;
                        break;
                      }
                      try {
                        var val = ex.evaluate();
                        if (val is num || val is Rational || val is Complex) {
                          evaluatedArgs.add(val);
                        } else {
                          allNumeric = false;
                          break;
                        }
                      } catch (_) {
                        allNumeric = false;
                        break;
                      }
                    }
                    if (allNumeric && evaluatedArgs.isNotEmpty) {
                      bool hasComplex = evaluatedArgs
                          .any((val) => val is Complex && val.imaginary != 0);
                      if (hasComplex) {
                        Complex l = Complex.zero();
                        for (var val in evaluatedArgs) {
                          Complex cVal = val is Complex ? val : Complex(val);
                          if (l == Complex.zero()) {
                            l = cVal;
                          } else {
                            Complex a = l;
                            Complex b = cVal;
                            Complex tempA = a;
                            Complex tempB = b;
                            while (tempB != Complex.zero()) {
                              Complex q = tempA / tempB;
                              double rVal = q.real is Rational
                                  ? (q.real as Rational).toDouble()
                                  : (q.real as num).toDouble();
                              double iVal = q.imaginary is Rational
                                  ? (q.imaginary as Rational).toDouble()
                                  : (q.imaginary as num).toDouble();
                              Complex roundedQ = Complex(
                                  rVal.roundToDouble(), iVal.roundToDouble());
                              Complex remainder = tempA - tempB * roundedQ;
                              tempA = tempB;
                              tempB = remainder;
                            }
                            Complex gcdVal = tempA;
                            l = (a * b) / gcdVal;
                          }
                        }
                        String formatComplex(Complex c) {
                          if (c.imaginary == 0) return c.real.toString();
                          if (c.real == 0) {
                            if (c.imaginary == 1) return 'i';
                            if (c.imaginary == -1) return '-i';
                            return '${c.imaginary}*i';
                          }
                          var sign = c.imaginary > 0 ? '+' : '';
                          var imagStr = '';
                          if (c.imaginary == 1) {
                            {
                              imagStr = 'i';
                            }
                          } else if (c.imaginary == -1) {
                            imagStr = '-i';
                          } else {
                            imagStr = '${c.imaginary}*i';
                          }
                          return '${c.real}$sign$imagStr';
                        }

                        final fmt = formatComplex(l);
                        return Literal(fmt, fmt);
                      } else {
                        List<Rational> rats = [];
                        for (var val in evaluatedArgs) {
                          if (val is Rational) {
                            rats.add(val);
                          } else if (val is num) {
                            rats.add(Rational(val));
                          } else if (val is Complex) {
                            rats.add(Rational(val.real));
                          }
                        }
                        Rational l = rats[0].abs();
                        for (int i = 1; i < rats.length; i++) {
                          Rational r = rats[i].abs();
                          BigInt a = l.numerator;
                          BigInt b = l.denominator;
                          BigInt c = r.numerator;
                          BigInt d = r.denominator;
                          BigInt numL = (a * c) ~/ a.gcd(c);
                          BigInt denG = b.gcd(d);
                          l = Rational(numL, denG);
                        }
                        return Literal(l);
                      }
                    }

                    // ---- Polynomial LCM algorithm ----
                    // Helper: reconstruct an Expression from a Polynomial
                    Expression polyToExpr(Polynomial p) {
                      Expression? result;
                      for (int i = 0; i < p.coefficients.length; i++) {
                        var coeff = p.coefficients[i];
                        dynamic cv = coeff is Literal ? coeff.value : null;
                        if (cv is Complex) {
                          if (cv == Complex.zero()) continue;
                          if (cv.imaginary == 0) {
                            final r = cv.real;
                            if (r is Rational && r.isInteger) {
                              coeff = Literal(r.numerator.toInt());
                            } else if (r is num) {
                              coeff = Literal(r == r.toInt() ? r.toInt() : r);
                            }
                          }
                        } else if (cv == 0 || cv == null) {
                          if (coeff is Literal &&
                              (coeff.value == Complex.zero() ||
                                  coeff.value == 0)) {
                            continue;
                          }
                        }
                        int deg = p.degree - i;
                        bool isOne = coeff is Literal &&
                            (coeff.value == 1 ||
                                coeff.value == Complex.one() ||
                                (coeff.value is Rational &&
                                    coeff.value == Rational.one));
                        Expression term;
                        if (deg == 0) {
                          term = coeff;
                        } else if (deg == 1) {
                          term =
                              isOne ? p.variable : Multiply(coeff, p.variable);
                        } else {
                          term = isOne
                              ? Pow(p.variable, Literal(deg))
                              : Multiply(coeff, Pow(p.variable, Literal(deg)));
                        }
                        result = result == null ? term : Add(result, term);
                      }
                      return result ?? Literal(1);
                    }

                    // Check if all unique expressions can be parsed as polynomials
                    // in a single variable
                    String? lcmPolyVar;
                    for (var ex in unique) {
                      final vars = ex
                          .getVariableTerms()
                          .where((v) => v.identifier.name != 'i');
                      if (vars.isNotEmpty) {
                        lcmPolyVar = vars.first.identifier.name;
                        break;
                      }
                    }

                    if (lcmPolyVar != null) {
                      // Validate all args use only that variable
                      bool singleVar = true;
                      for (var ex in unique) {
                        final vars = ex
                            .getVariableTerms()
                            .where((v) => v.identifier.name != 'i');
                        for (var v in vars) {
                          if (v.identifier.name != lcmPolyVar) {
                            singleVar = false;
                            break;
                          }
                        }
                        if (!singleVar) break;
                      }

                      if (singleVar) {
                        // Try to parse all as polynomials
                        List<Polynomial?> lcmPolys = [];
                        bool allLcmPolys = true;
                        for (var ex in unique) {
                          try {
                            var cleanStr = ex.toString().trim();
                            while (cleanStr.startsWith('(') &&
                                cleanStr.endsWith(')')) {
                              cleanStr =
                                  cleanStr.substring(1, cleanStr.length - 1);
                            }
                            lcmPolys.add(Polynomial.fromString(cleanStr,
                                variable: Variable(lcmPolyVar)));
                          } catch (_) {
                            allLcmPolys = false;
                            break;
                          }
                        }

                        if (allLcmPolys && lcmPolys.isNotEmpty) {
                          // Helper: check if a polynomial is the trivial constant 1
                          bool isConstOne(Polynomial p) {
                            if (p.degree != 0) return false;
                            final c = p.coefficients[0];
                            if (c is! Literal) return false;
                            final v = c.value;
                            if (v is int) return v == 1;
                            if (v is double) return v == 1.0;
                            if (v is Rational) return v == Rational.one;
                            if (v is Complex) return v == Complex.one();
                            return false;
                          }

                          // Compute pairwise LCM by accumulation:
                          // lcm(a, b, c) = lcm(lcm(a, b), c)
                          // But for each pair: if gcd==1 (coprime), keep
                          // factored form; otherwise compute the LCM poly.
                          //
                          // Strategy: track a "factored" expression and a
                          // "GCD denominator" separately.
                          // lcm = (prod of all polys) / (prod of pairwise gcds)
                          // Represent as: numerator_expr * denominator_expr^(-1)

                          // Collect expression nodes (before parsing)
                          List<Expression> exprNodes = [];
                          for (var ex in unique) {
                            var cleanStr = ex.toString().trim();
                            while (cleanStr.startsWith('(') &&
                                cleanStr.endsWith(')')) {
                              cleanStr =
                                  cleanStr.substring(1, cleanStr.length - 1);
                            }
                            exprNodes.add(ex);
                          }

                          // Compute the combined GCD of all polynomials
                          Polynomial combinedGcd = lcmPolys[0]!;
                          for (int i = 1; i < lcmPolys.length; i++) {
                            combinedGcd = combinedGcd.gcd(lcmPolys[i]!);
                          }

                          if (isConstOne(combinedGcd)) {
                            // All coprime: LCM = product of all expressions
                            // Return in factored form as Expression multiply chain
                            Expression prod = exprNodes[0];
                            for (int i = 1; i < exprNodes.length; i++) {
                              prod = Multiply(prod, exprNodes[i]);
                            }
                            return prod;
                          }

                          // Compute pairwise LCM polynomial
                          Polynomial lcmPoly = lcmPolys[0]!;
                          for (int i = 1; i < lcmPolys.length; i++) {
                            lcmPoly = lcmPoly.lcm(lcmPolys[i]!);
                          }

                          // Check if the LCM equals one of the input polys
                          // (divisibility: one divides the other)
                          for (int i = 0; i < lcmPolys.length; i++) {
                            if (lcmPoly.toString() == lcmPolys[i]!.toString()) {
                              return polyToExpr(lcmPoly);
                            }
                          }

                          // General case: express as
                          //   (prod of inputs) * (combined GCD)^(-1)
                          // Only if that's simpler than the expanded form.
                          // Check: is (product / combinedGcd) exact?
                          Expression numExpr = exprNodes[0];
                          for (int i = 1; i < exprNodes.length; i++) {
                            numExpr = Multiply(numExpr, exprNodes[i]);
                          }
                          Expression gcdExpr = polyToExpr(combinedGcd);

                          return Multiply(numExpr, Pow(gcdExpr, Literal(-1)));
                        }
                      }
                    }

                    // Symbolic power cases
                    if (unique.length == 2) {
                      var u1 = unique[0];
                      var u2 = unique[1];
                      if (u1.toString() == u2.toString()) {
                        return u1; // lcm(a^a, a^a) -> a^a
                      }
                      if (u1 is Pow && u2 is Pow) {
                        if (u1.left.toString() == u2.left.toString()) {
                          // lcm(a^b, a^c) -> a^(-1+b+c)
                          return Pow(
                              u1.left,
                              Add(Literal(-1), Add(u1.right, u2.right))
                                  .simplify());
                        }
                        if (u1.right.toString() == u2.right.toString()) {
                          var b1 = u1.left;
                          var b2 = u2.left;
                          if (b1 is Literal &&
                              b1.value is int &&
                              b2 is Literal &&
                              b2.value is int) {
                            int val1 = b1.value as int;
                            int val2 = b2.value as int;
                            int l = (val1 * val2) ~/
                                BigInt.from(val1)
                                    .gcd(BigInt.from(val2))
                                    .toInt();
                            if (l == val1) return u1;
                            if (l == val2) return u2;
                            return Pow(Literal(l), u1.right);
                          }
                          return Multiply(u1, u2)
                              .simplify(); // lcm(a^c, b^c) -> a^c * b^c
                        }
                      }
                    }

                    if (args.length == 2 &&
                        args[0] is Variable &&
                        args[0].toString() == args[1].toString()) {
                      var a = args[0];
                      return Multiply(
                              Pow(a, Literal(2)),
                              Pow(
                                  CallExpression(
                                      Variable(Identifier('gcd')), [a, a]),
                                  Literal(-1)))
                          .simplify();
                    }

                    // Fallback to CallExpression
                    return CallExpression(Variable(Identifier('lcm')), unique);
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
                    String varName = args.length > 1 && args[1] is Variable
                        ? (args[1] as Variable).identifier.name
                        : 'x';

                    // Try polynomial parse first (handles clean polynomial strs)
                    if (expr is Polynomial) {
                      return Literal(expr.degree);
                    }
                    try {
                      final poly = Polynomial.fromString(expr.toString(),
                          variable: Variable(varName));
                      return Literal(poly.degree);
                    } catch (_) {}

                    // Helper: flatten nested max(max(a,b),c) -> max(a,b,c)
                    String flattenMax(String a, String b) {
                      // Collect all args from nested max() calls
                      List<String> collect(String s) {
                        if (s.startsWith('max(') && s.endsWith(')')) {
                          final inner = s.substring(4, s.length - 1);
                          // Simple split on ',' (assumes no nested commas)
                          return inner.split(',').expand(collect).toList();
                        }
                        return [s];
                      }

                      final parts = [...collect(a), ...collect(b)];
                      // De-duplicate
                      final seen = <String>{};
                      final unique = parts.where(seen.add).toList();
                      if (unique.length == 1) return unique[0];
                      return 'max(${unique.join(',')}';
                    }

                    // Helper: compute symbolic max of two degree expressions
                    Expression maxDeg(Expression dl, Expression dr) {
                      if (dl is Literal &&
                          dr is Literal &&
                          dl.value is int &&
                          dr.value is int) {
                        return Literal((dl.value as int) > (dr.value as int)
                            ? dl.value
                            : dr.value);
                      }
                      if (dl.toString() == dr.toString()) return dl;
                      final flat = flattenMax(dl.toString(), dr.toString());
                      // If one is numeric 0 and other is symbolic, return symbolic
                      if (dl is Literal && dl.value == 0) return dr;
                      if (dr is Literal && dr.value == 0) return dl;
                      // Close the paren for max()
                      final maxStr = flat.endsWith(')') ? flat : '$flat)';
                      return Literal(maxStr, maxStr);
                    }

                    // Walk expression tree: returns the degree of [e] wrt [vn].
                    // Returns Literal(int) for concrete, Literal(str) for
                    // symbolic, or null if the expression is not classifiable.
                    // For non-polynomial terms that contain vn (like cos(x)),
                    // we return Literal(0) so they don't raise the degree.
                    Expression degreeOfExpr(Expression e, String vn) {
                      if (e is Literal) return Literal(0);
                      if (e is Variable) {
                        return e.identifier.name == vn
                            ? Literal(1)
                            : Literal(0);
                      }
                      if (e is Pow) {
                        final base = e.left;
                        final exp = e.right;
                        if (base is Variable && base.identifier.name == vn) {
                          // x^constant or x^symbol — this IS the degree
                          return exp;
                        }
                        // cos(x)^n or similar — treat as deg 0
                        return Literal(0);
                      }
                      if (e is Add || e is Subtract) {
                        final l = e as BinaryOperationsExpression;
                        final dl = degreeOfExpr(l.left, vn);
                        final dr = degreeOfExpr(l.right, vn);
                        return maxDeg(dl, dr);
                      }
                      if (e is Multiply) {
                        final ml = e as BinaryOperationsExpression;
                        final dl = degreeOfExpr(ml.left, vn);
                        final dr = degreeOfExpr(ml.right, vn);
                        // deg(a*b) = deg(a) + deg(b)
                        if (dl is Literal &&
                            dr is Literal &&
                            dl.value is int &&
                            dr.value is int) {
                          return Literal((dl.value as int) + (dr.value as int));
                        }
                        // If one is 0, return the other
                        if (dl is Literal && dl.value == 0) return dr;
                        if (dr is Literal && dr.value == 0) return dl;
                        return Literal(0);
                      }
                      // For trig, abs, log, etc. — treat as degree 0
                      // (they don't raise the polynomial degree)
                      return Literal(0);
                    }

                    final degResult = degreeOfExpr(expr, varName);
                    return degResult;
                  }

                  if (name == 'pfactor' && args.length == 1) {
                    // Helper: BigInt factorial (avoids int overflow)
                    BigInt bigIntFactorial(int n) {
                      if (n < 0) {
                        throw ArgumentError(
                            'Factorial undefined for negative: $n');
                      }
                      BigInt result = BigInt.one;
                      for (int i = 2; i <= n; i++) {
                        result *= BigInt.from(i);
                      }
                      return result;
                    }

                    // Helper: BigInt prime factorization

                    // Helper: evaluate a BigInt expression that may contain
                    // factorial sub-expressions recursively
                    BigInt? evalBigIntExpr(Expression e) {
                      // Literal int/BigInt
                      if (e is Literal) {
                        final v = e.value;
                        if (v is int) return BigInt.from(v);
                        if (v is BigInt) return v;
                        if (v is double) {
                          if (v == v.truncateToDouble()) {
                            // Try the raw string first (preserves precision for
                            // large integers that exceed double accuracy)
                            try {
                              return BigInt.parse(e.raw.replaceAll('"', ''));
                            } catch (_) {}
                            return BigInt.from(v.toInt());
                          }
                          return null;
                        }
                        if (v is Rational && v.isInteger) return v.numerator;
                        return null;
                      }
                      // n!
                      if (e is UnaryExpression &&
                          e.operator == '!' &&
                          !e.prefix) {
                        final inner = evalBigIntExpr(e.operand);
                        if (inner != null && inner.isValidInt) {
                          final n = inner.toInt();
                          if (n >= 0) return bigIntFactorial(n);
                        }
                        return null;
                      }
                      // a + b
                      if (e is Add) {
                        final l = evalBigIntExpr(e.left);
                        final r = evalBigIntExpr(e.right);
                        if (l != null && r != null) return l + r;
                        return null;
                      }
                      // a - b
                      if (e is Subtract) {
                        final l = evalBigIntExpr(e.left);
                        final r = evalBigIntExpr(e.right);
                        if (l != null && r != null) return l - r;
                        return null;
                      }
                      // a * b
                      if (e is Multiply) {
                        final l = evalBigIntExpr(e.left);
                        final r = evalBigIntExpr(e.right);
                        if (l != null && r != null) return l * r;
                        return null;
                      }
                      // a ^ b (integer power)
                      if (e is Pow) {
                        final base = evalBigIntExpr(e.left);
                        final exp = evalBigIntExpr(e.right);
                        if (base != null && exp != null && exp.isValidInt) {
                          final expInt = exp.toInt();
                          if (expInt >= 0) return base.pow(expInt);
                        }
                        return null;
                      }
                      // Unary minus
                      if (e is UnaryExpression && e.operator == '-') {
                        final inner = evalBigIntExpr(e.operand);
                        if (inner != null) return -inner;
                        return null;
                      }
                      // product(expr, var, start, end) — evaluate symbolically
                      if (e is CallExpression &&
                          e.callee.toString() == 'product' &&
                          e.arguments.length == 4) {
                        final bodyExpr = e.arguments[0];
                        final varExpr = e.arguments[1];
                        final startExpr = e.arguments[2];
                        final endExpr = e.arguments[3];
                        if (varExpr is Variable) {
                          final startVal = evalBigIntExpr(startExpr);
                          final endVal = evalBigIntExpr(endExpr);
                          if (startVal != null && endVal != null) {
                            BigInt prod = BigInt.one;
                            //final varName = varExpr.identifier.name;
                            for (BigInt i = startVal;
                                i <= endVal;
                                i += BigInt.one) {
                              // Substitute var = i into bodyExpr
                              final substituted = bodyExpr.substitute(varExpr,
                                  Literal(i.isValidInt ? i.toInt() : i));
                              final term = evalBigIntExpr(substituted);
                              if (term == null) return null;
                              prod *= term;
                            }
                            return prod;
                          }
                        }
                        return null;
                      }
                      // General fallback: try normal evaluate()
                      try {
                        final val = e.evaluate();
                        if (val is int) return BigInt.from(val);
                        if (val is BigInt) return val;
                        if (val is double && val == val.truncateToDouble()) {
                          return BigInt.from(val.toInt());
                        }
                      } catch (_) {}
                      return null;
                    }

                    // First: handle direct BigInt/int literal
                    if (args[0] is Literal) {
                      final v = (args[0] as Literal).value;
                      BigInt? n;
                      if (v is int) {
                        n = BigInt.from(v);
                      } else if (v is BigInt) {
                        n = v;
                      }
                      if (n != null) {
                        final s = pfactorBigInt(n);
                        return Literal(s, s);
                      }
                    }

                    // Try BigInt-aware recursive evaluation
                    final bigVal = evalBigIntExpr(args[0]);
                    if (bigVal != null) {
                      final s = pfactorBigInt(bigVal);
                      return Literal(s, s);
                    }

                    // Return unevaluated if we can't resolve to an integer
                    return CallExpression(
                        Variable(Identifier('pfactor')), args);
                  }

                  if (name == 'partfrac' && args.length >= 2) {
                    // Partial fraction decomposition: partfrac(expr, var)
                    // Algorithm:
                    //   1. Express input as N/D (detect Divide node)
                    //   2. If deg(N) >= deg(D), do polynomial division first
                    //   3. Factor D into irreducible polynomial factors
                    //   4. Set up undetermined-coefficient template
                    //   5. Solve the linear system by equating coefficients
                    //   6. Return the sum of partial fractions + polynomial part

                    final varStr = args[1] is Variable
                        ? (args[1] as Variable).identifier.name
                        : args[1].toString();
                    final xVar = Variable(Identifier(varStr));

                    // Helper: extract numerator and denominator from expression
                    Expression? numExpr;
                    Expression? denExpr;

                    Expression raw = args[0];
                    // Unwrap GroupExpression if present
                    while (raw is GroupExpression) {
                      raw = (raw).expression;
                    }

                    if (raw is Divide) {
                      numExpr = raw.left;
                      denExpr = raw.right;
                    } else if (raw is Multiply) {
                      // Handle a*(b)^(-1) form
                      var ml = raw as BinaryOperationsExpression;
                      if (ml.right is Pow) {
                        var rp = ml.right as Pow;
                        if (rp.right is Literal &&
                            (rp.right as Literal).value == -1) {
                          numExpr = ml.left;
                          denExpr = rp.left;
                        }
                      }
                    }

                    if (numExpr == null || denExpr == null) {
                      // Not a ratio — return as-is
                      return args[0].simplify();
                    }

                    // Try to parse numerator and denominator as polynomials
                    Polynomial? numPoly;
                    Polynomial? denPoly;
                    try {
                      var numStr = numExpr.toString().trim();
                      while (numStr.startsWith('(') && numStr.endsWith(')')) {
                        numStr = numStr.substring(1, numStr.length - 1);
                      }
                      numPoly = Polynomial.fromString(numStr, variable: xVar);
                    } catch (_) {}
                    try {
                      var denStr = denExpr.toString().trim();
                      while (denStr.startsWith('(') && denStr.endsWith(')')) {
                        denStr = denStr.substring(1, denStr.length - 1);
                      }
                      denPoly = Polynomial.fromString(denStr, variable: xVar);
                    } catch (_) {}

                    if (numPoly == null || denPoly == null) {
                      // Cannot parse — return symbolic
                      return CallExpression(
                          Variable(Identifier('partfrac')), args);
                    }

                    // Step 1: Polynomial long division if improper
                    Expression polyPart = Literal(0);
                    Polynomial remPoly = numPoly;
                    if (numPoly.degree >= denPoly.degree) {
                      try {
                        List<Expression> aCoeffs =
                            List.from(numPoly.coefficients);
                        List<Expression> bCoeffs =
                            List.from(denPoly.coefficients);
                        int aDeg = numPoly.degree;
                        int bDeg = denPoly.degree;
                        List<Expression> qCoeffs = [];

                        for (int i = 0; i <= aDeg - bDeg; i++) {
                          var aC = aCoeffs[i];
                          var bC = bCoeffs[0];
                          Expression coeff;
                          try {
                            var aVal = (aC as Literal).value;
                            var bVal = (bC as Literal).value;
                            dynamic av = aVal is Complex ? aVal.real : aVal;
                            dynamic bv = bVal is Complex ? bVal.real : bVal;
                            if (av is Rational && bv is Rational) {
                              coeff = Literal(av / bv);
                            } else if (av is num && bv is num) {
                              var r = av / bv;
                              coeff = (r == r.toInt())
                                  ? Literal(r.toInt())
                                  : Literal(r);
                            } else {
                              coeff = Divide(aC, bC);
                            }
                          } catch (_) {
                            coeff = Divide(aC, bC);
                          }
                          qCoeffs.add(coeff);
                          for (int j = 0; j < bCoeffs.length; j++) {
                            Expression sub;
                            try {
                              var cv = (coeff as Literal).value;
                              var bv = (bCoeffs[j] as Literal).value;
                              dynamic cr = cv is Complex ? cv.real : cv;
                              dynamic br = bv is Complex ? bv.real : bv;
                              if (cr is Rational && br is Rational) {
                                sub = Literal(cr * br);
                              } else if (cr is num && br is num) {
                                var r = cr * br;
                                sub = (r == r.toInt())
                                    ? Literal(r.toInt())
                                    : Literal(r);
                              } else {
                                sub = Multiply(coeff, bCoeffs[j]);
                              }
                            } catch (_) {
                              sub = Multiply(coeff, bCoeffs[j]);
                            }
                            try {
                              var av = (aCoeffs[i + j] as Literal).value;
                              var sv = (sub as Literal).value;
                              dynamic ar = av is Complex ? av.real : av;
                              dynamic sr = sv is Complex ? sv.real : sv;
                              if (ar is Rational && sr is Rational) {
                                aCoeffs[i + j] = Literal(ar - sr);
                              } else if (ar is num && sr is num) {
                                var r = ar - sr;
                                aCoeffs[i + j] = (r == r.toInt())
                                    ? Literal(r.toInt())
                                    : Literal(r);
                              } else {
                                aCoeffs[i + j] = Subtract(aCoeffs[i + j], sub);
                              }
                            } catch (_) {
                              aCoeffs[i + j] = Subtract(aCoeffs[i + j], sub);
                            }
                          }
                        }

                        List<Expression> remCoeffs =
                            aCoeffs.sublist(aDeg - bDeg + 1);
                        remPoly = Polynomial(remCoeffs, variable: xVar);

                        Expression? qExpr;
                        for (int i = 0; i < qCoeffs.length; i++) {
                          int deg = qCoeffs.length - 1 - i;
                          var c = qCoeffs[i];
                          bool isZero = c is Literal &&
                              (c.value == 0 ||
                                  c.value == Complex.zero() ||
                                  c.value == Rational.zero);
                          if (isZero) continue;
                          bool isOne = c is Literal &&
                              (c.value == 1 ||
                                  c.value == Complex.one() ||
                                  (c.value is Rational &&
                                      c.value == Rational.one));
                          Expression term;
                          if (deg == 0) {
                            term = c;
                          } else if (deg == 1) {
                            term = isOne ? xVar : Multiply(c, xVar);
                          } else {
                            term = isOne
                                ? Pow(xVar, Literal(deg))
                                : Multiply(c, Pow(xVar, Literal(deg)));
                          }
                          qExpr = qExpr == null ? term : Add(qExpr, term);
                        }
                        polyPart = qExpr ?? Literal(0);
                      } catch (_) {
                        return CallExpression(
                            Variable(Identifier('partfrac')), args);
                      }
                    }

                    // Step 2: Factor the denominator polynomial.
                    // factorize() returns Polynomial objects, not parseable strings.
                    // We keep them as Polynomial directly for arithmetic.
                    List<Expression> denFactors = [];
                    try {
                      denFactors = denPoly.factorize();
                    } catch (_) {}

                    if (denFactors.isEmpty || denFactors.length == 1) {
                      // Irreducible or unfactorable denominator
                      Expression frac =
                          Multiply(numExpr, Pow(denExpr, Literal(-1)));
                      if (polyPart is Literal && (polyPart).value == 0) {
                        return frac;
                      }
                      return Add(polyPart, frac);
                    }

                    // Helper: convert a Polynomial factor to a canonical
                    // Expression form, normalising coefficients.
                    // NOTE: Polynomial.factorize() stores raw numerics (int,
                    // double, Complex) as coefficients, NOT Literal objects.
                    // This function handles both cases.
                    Expression polyFactorToExpr(Polynomial p) {
                      Expression? res;
                      for (int i = 0; i < p.coefficients.length; i++) {
                        var coeff = p.coefficients[i];
                        int deg = p.degree - i;

                        // Extract raw value — from Literal, or directly
                        dynamic cv;
                        if (coeff is Literal) {
                          cv = coeff.value;
                        } else if (coeff is num ||
                            coeff is Complex ||
                            coeff is Rational) {
                          cv = coeff;
                        } else {
                          // Some other expression — include as-is
                          cv = null;
                        }

                        // Normalize Complex to real if imaginary is zero
                        if (cv is Complex && cv.imaginary == 0) {
                          final r = cv.real;
                          if (r is Rational && r.isInteger) {
                            cv = r.numerator.toInt();
                          } else if (r is int) {
                            cv = r;
                          } else if (r is double) {
                            cv = r.toInt() == r ? r.toInt() : r;
                          } else {
                            cv = r;
                          }
                        }

                        // Normalise double -0 to 0
                        if (cv is double && cv == 0.0) cv = 0;
                        if (cv is double && cv == -0.0) cv = 0;

                        // Skip zero terms
                        bool isZero = cv == 0 ||
                            cv == 0.0 ||
                            (cv is Rational && cv == Rational.zero) ||
                            (cv is Complex && cv == Complex.zero());
                        if (isZero) continue;

                        bool isOne = cv == 1 ||
                            cv == 1.0 ||
                            (cv is Rational && cv == Rational.one) ||
                            (cv is Complex && cv == Complex.one());

                        // Wrap cv in Literal if needed
                        Expression coeffExpr;
                        if (coeff is Literal) {
                          // Re-create Literal from cv to get clean value
                          coeffExpr = cv != null ? Literal(cv) : coeff;
                        } else if (cv != null) {
                          coeffExpr = Literal(cv);
                        } else {
                          coeffExpr = coeff;
                        }

                        Expression term;
                        if (deg == 0) {
                          term = coeffExpr;
                        } else if (deg == 1) {
                          term = isOne ? xVar : Multiply(coeffExpr, xVar);
                        } else {
                          term = isOne
                              ? Pow(xVar, Literal(deg))
                              : Multiply(coeffExpr, Pow(xVar, Literal(deg)));
                        }
                        res = res == null ? term : Add(res, term);
                      }
                      return res ?? Literal(0);
                    }

                    // Collect factors as (Polynomial, multiplicity, Expression)
                    // Use the polynomial itself as the canonical key/value.
                    // Detect repeated factors by checking if two factor polys are
                    // proportional (one divides the other evenly).
                    List<Polynomial> factorPolys = [];
                    List<int> factorExps = [];
                    List<Expression> factorExprs = [];

                    for (var f in denFactors) {
                      Polynomial? fPoly;
                      Expression fExpr;
                      int exp = 1;

                      if (f is Polynomial) {
                        fPoly = f;
                        fExpr = polyFactorToExpr(f);
                      } else if (f is Pow) {
                        var fp = f;
                        if (fp.left is Polynomial) {
                          fPoly = fp.left as Polynomial;
                          fExpr = polyFactorToExpr(fPoly);
                        } else {
                          fExpr = fp.left;
                        }
                        if (fp.right is Literal) {
                          var ev = (fp.right as Literal).value;
                          if (ev is int) {
                            exp = ev;
                          } else if (ev is double) {
                            exp = ev.toInt();
                          }
                        }
                      } else {
                        fExpr = f;
                      }

                      // Check if this factor matches an existing one
                      // (i.e. factorPolys[i] == k*fPoly for some constant k≠0)
                      bool merged = false;
                      if (fPoly != null) {
                        for (int i = 0; i < factorPolys.length; i++) {
                          try {
                            var q = factorPolys[i] / fPoly;
                            Polynomial? qPoly;
                            if (q is Polynomial) {
                              qPoly = q;
                            } else if (q is Add && q.left is Polynomial) {
                              qPoly = q.left as Polynomial;
                            }
                            // Merge only if quotient is a NON-ZERO constant
                            if (qPoly != null && qPoly.degree == 0) {
                              // Check that the constant coefficient is non-zero
                              var leadC = qPoly.coefficients.first;
                              dynamic lv = leadC is Literal
                                  ? leadC.value
                                  : (leadC is num ||
                                          leadC is Complex ||
                                          leadC is Rational
                                      ? leadC
                                      : null);
                              bool leadZero = lv == 0 ||
                                  lv == 0.0 ||
                                  (lv is Complex && lv == Complex.zero()) ||
                                  (lv is Rational && lv == Rational.zero);
                              if (!leadZero) {
                                factorExps[i] += exp;
                                merged = true;
                                break;
                              }
                            }
                          } catch (_) {}
                        }
                      }
                      if (!merged) {
                        factorPolys.add(
                            fPoly ?? Polynomial([Literal(1)], variable: xVar));
                        factorExps.add(exp);
                        factorExprs.add(fExpr);
                      }
                    }

                    // Step 3: Build partial fraction template
                    int numUnknowns = 0;
                    List<Map<String, dynamic>> pfTerms = [];

                    for (int fi = 0; fi < factorPolys.length; fi++) {
                      var fPoly2 = factorPolys[fi];
                      var n = factorExps[fi];
                      var fBase = factorExprs[fi];
                      int fDeg = fPoly2.degree;

                      for (int k = 1; k <= n; k++) {
                        List<int> idx = [];
                        for (int j = 0; j < fDeg; j++) {
                          idx.add(numUnknowns + j);
                        }
                        pfTerms.add({
                          'factorPoly': fPoly2,
                          'factorExpr': fBase,
                          'power': k,
                          'degree': fDeg,
                          'coeffIdx': idx
                        });
                        numUnknowns += fDeg;
                      }
                    }

                    if (numUnknowns == 0 || numUnknowns > 12) {
                      return CallExpression(
                          Variable(Identifier('partfrac')), args);
                    }

                    // Step 4: Build the coefficient matrix by polynomial matching.
                    // For each term with factor f^k:
                    //   cofactor = denPoly / f^k
                    // Contribution of coeff A_j to row r:
                    //   = (cofactor * x^j)[row r coefficient]
                    int sysSize = denPoly.degree;
                    List<List<Rational>> mat = List.generate(sysSize,
                        (_) => List.filled(numUnknowns, Rational.zero));
                    List<Rational> rhs = List.filled(sysSize, Rational.zero);

                    for (var pfTerm in pfTerms) {
                      var fPoly3 = pfTerm['factorPoly'] as Polynomial;
                      var power = pfTerm['power'] as int;
                      var degree = pfTerm['degree'] as int;
                      var coeffIdx = pfTerm['coeffIdx'] as List<int>;

                      Polynomial? cofactor;
                      try {
                        Polynomial fpow = fPoly3;
                        for (int pp = 1; pp < power; pp++) {
                          fpow = (fpow * fPoly3) as Polynomial;
                        }
                        var divRes = denPoly / fpow;
                        if (divRes is Polynomial) {
                          cofactor = divRes;
                        } else if (divRes is Add && divRes.left is Polynomial) {
                          // Polynomial division returns Add(quotient, rem/div)
                          // for "exact" cases where there's a zero remainder.
                          // Extract the quotient part.
                          cofactor = divRes.left as Polynomial;
                        }
                      } catch (_) {}

                      if (cofactor == null) {
                        // Cannot compute cofactor — fallback to symbolic
                        return CallExpression(
                            Variable(Identifier('partfrac')), args);
                      }

                      for (int j = 0; j < degree; j++) {
                        int ci = coeffIdx[j];
                        for (int row = 0; row < sysSize; row++) {
                          int cfIdx = cofactor.degree - (row - j);
                          if (cfIdx >= 0 &&
                              cfIdx < cofactor.coefficients.length) {
                            var rawC = cofactor.coefficients[cfIdx];
                            Rational? rat;
                            try {
                              // Extract value — from Literal or raw numeric
                              dynamic v;
                              if (rawC is Literal) {
                                v = rawC.value;
                              } else if (rawC is num ||
                                  rawC is Complex ||
                                  rawC is Rational) {
                                v = rawC;
                              }
                              if (v is Complex && v.imaginary == 0) {
                                var r = v.real;
                                if (r is Rational) {
                                  rat = r;
                                } else if (r is int) {
                                  rat = Rational(r);
                                } else if (r is double) {
                                  rat = Rational((r * 1000).round(), 1000);
                                }
                              } else if (v is Rational) {
                                rat = v;
                              } else if (v is int) {
                                rat = Rational(v);
                              } else if (v is double) {
                                rat = Rational((v * 1000).round(), 1000);
                              }
                            } catch (_) {}
                            if (rat != null) {
                              mat[row][ci] = mat[row][ci] + rat;
                            }
                          }
                        }
                      }
                    }

                    // Build RHS from remainder polynomial coefficients
                    for (int row = 0; row < sysSize; row++) {
                      int nIdx = remPoly.degree - row;
                      if (nIdx >= 0 && nIdx < remPoly.coefficients.length) {
                        var rawC = remPoly.coefficients[nIdx];
                        try {
                          // Extract value — from Literal or raw numeric
                          dynamic v;
                          if (rawC is Literal) {
                            v = rawC.value;
                          } else if (rawC is num ||
                              rawC is Complex ||
                              rawC is Rational) {
                            v = rawC;
                          }
                          if (v is Complex && v.imaginary == 0) {
                            var r = v.real;
                            if (r is Rational) {
                              rhs[row] = r;
                            } else if (r is int) {
                              rhs[row] = Rational(r);
                            } else if (r is double) {
                              rhs[row] = Rational((r * 1000).round(), 1000);
                            }
                          } else if (v is Rational) {
                            rhs[row] = v;
                          } else if (v is int) {
                            rhs[row] = Rational(v);
                          } else if (v is double) {
                            rhs[row] = Rational((v * 1000).round(), 1000);
                          }
                        } catch (_) {}
                      }
                    }

                    // Step 5: Gaussian elimination
                    List<Rational>? solution;
                    try {
                      int rows = sysSize;
                      int cols = numUnknowns;
                      List<List<Rational>> aug =
                          List.generate(rows, (i) => [...mat[i], rhs[i]]);

                      for (int col = 0, row = 0;
                          col < cols && row < rows;
                          col++) {
                        int pivot = -1;
                        for (int r = row; r < rows; r++) {
                          if (aug[r][col] != Rational.zero) {
                            pivot = r;
                            break;
                          }
                        }
                        if (pivot == -1) continue;
                        var tmp = aug[row];
                        aug[row] = aug[pivot];
                        aug[pivot] = tmp;
                        Rational scale = aug[row][col];
                        for (int c = 0; c <= cols; c++) {
                          aug[row][c] = aug[row][c] / scale;
                        }
                        for (int r = 0; r < rows; r++) {
                          if (r == row) continue;
                          Rational factor2 = aug[r][col];
                          if (factor2 == Rational.zero) continue;
                          for (int c = 0; c <= cols; c++) {
                            aug[r][c] = aug[r][c] - factor2 * aug[row][c];
                          }
                        }
                        row++;
                      }

                      solution = List.filled(cols, Rational.zero);
                      for (int r = 0; r < rows; r++) {
                        int leadCol = -1;
                        for (int c = 0; c < cols; c++) {
                          if (aug[r][c] == Rational.one) {
                            leadCol = c;
                            break;
                          }
                        }
                        if (leadCol >= 0) {
                          solution[leadCol] = aug[r][cols];
                        }
                      }
                    } catch (_) {
                      return CallExpression(
                          Variable(Identifier('partfrac')), args);
                    }

                    if (solution == null) {
                      return CallExpression(
                          Variable(Identifier('partfrac')), args);
                    }

                    // Step 6: Build the partial fraction sum
                    pfTerms.sort((a, b) {
                      var fa = (a['factorExpr'] as Expression).toString();
                      var fb = (b['factorExpr'] as Expression).toString();
                      int cmp = fa.compareTo(fb);
                      if (cmp != 0) return cmp;
                      return (a['power'] as int).compareTo(b['power'] as int);
                    });

                    Expression? pfResult;
                    for (var pfTerm in pfTerms) {
                      var fBase2 = pfTerm['factorExpr'] as Expression;
                      var power = pfTerm['power'] as int;
                      var degree = pfTerm['degree'] as int;
                      var coeffIdx = pfTerm['coeffIdx'] as List<int>;

                      Expression? numeratorTerm;
                      for (int j = 0; j < degree; j++) {
                        var coeff = solution[coeffIdx[j]];
                        if (coeff == Rational.zero) continue;
                        Expression coeffExpr = coeff.isInteger
                            ? Literal(coeff.numerator.toInt())
                            : Literal(coeff);
                        Expression component;
                        if (j == 0) {
                          component = coeffExpr;
                        } else if (j == 1) {
                          bool isOne = coeff == Rational.one;
                          component = isOne ? xVar : Multiply(coeffExpr, xVar);
                        } else {
                          bool isOne = coeff == Rational.one;
                          component = isOne
                              ? Pow(xVar, Literal(j))
                              : Multiply(coeffExpr, Pow(xVar, Literal(j)));
                        }
                        numeratorTerm = numeratorTerm == null
                            ? component
                            : Add(numeratorTerm, component);
                      }

                      if (numeratorTerm == null) continue;

                      Expression denominator =
                          power == 1 ? fBase2 : Pow(fBase2, Literal(power));

                      Expression fraction = Multiply(
                          numeratorTerm, Pow(denominator, Literal(-1)));
                      pfResult =
                          pfResult == null ? fraction : Add(pfResult, fraction);
                    }

                    if (pfResult == null) {
                      return polyPart is Literal && (polyPart).value == 0
                          ? Literal(0)
                          : polyPart;
                    }

                    if (polyPart is! Literal || (polyPart).value != 0) {
                      pfResult = Add(polyPart, pfResult);
                    }

                    return pfResult;
                  }

                  if (name == 'coeffs' && args.length >= 2) {
                    // coeffs(poly, var)
                    try {
                      Polynomial poly =
                          Polynomial.fromString(args[0].toString());
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
                      List<dynamic> coeffs =
                          poly.coefficients.reversed.map((c) {
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

                          return Add(Multiply(Literal(cm), Variable('x')),
                                  Literal(cC))
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

                          return Add(
                                  Multiply(m, tVar),
                                  Add(Multiply(Literal(-1), Multiply(m, ex1)),
                                      ey1))
                              .simplify();
                        }
                      }
                    }
                  }

                  if (name == 'roots' && args.length == 1) {
                    try {
                      Polynomial poly =
                          Polynomial.fromString(args[0].toString());
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
                      final cleanSource = source.replaceAll(
                          RegExp(
                              r'\b(sqcomp|completeSquare|sin|cos|tan|asin|acos|atan|sinh|cosh|tanh|log|ln|exp|abs|sqrt)\b'),
                          '');
                      final match = RegExp(r'[a-zA-Z]').firstMatch(cleanSource);
                      if (match != null) {
                        varName = match.group(0)!;
                      }

                      Polynomial poly = Polynomial.fromString(source,
                          variable: Variable(varName));
                      if (poly.degree == 2) {
                        var a = poly.coefficients[0]; // x^2
                        var b = poly.coefficients[1]; // x^1
                        var c = poly.coefficients[2]; // x^0

                        // Construct: a * (var + b/(2a))^2 + (c - b^2/(4a))
                        Expression term1 = a *
                            Pow(Variable(varName) + b / (Literal(2) * a),
                                Literal(2));
                        Expression term2 = c - (b * b) / (Literal(4) * a);
                        return (term1 + term2).simplify();
                      }
                    } catch (e) {
                      return args[0];
                    }
                  }

                  if (name == 'laplace' && args.length == 3) {
                    if (args[1] is Variable && args[2] is Variable) {
                      return LaplaceTransform.compute(
                          args[0], args[1] as Variable, args[2] as Variable);
                    }
                  }

                  if (name == 'ilt' && args.length == 3) {
                    if (args[1] is Variable && args[2] is Variable) {
                      return InverseLaplaceTransform.compute(
                          args[0], args[1] as Variable, args[2] as Variable);
                    }
                  }
                }
                return CallExpression(object, argument);
              }
              throw ArgumentError('Invalid type ${argument.runtimeType}');
            });
          })) |
          numericLiteral)
      .cast<Expression>();

  // Responsible for parsing a group of things within parentheses `()`
  // This function assumes that it needs to gobble the opening parenthesis
  // and then tries to gobble everything within that parenthesis, assuming
  // that the next thing it should see is the close parenthesis. If not,
  // then the expression probably doesn't have a `)`
  Parser<Expression> get group => (char('(') & expression.trim() & char(')'))
      .pick(1)
      .map((e) => GroupExpression(e as Expression));

  Parser<Literal> get otherLiteral =>
      (stringLiteral | boolLiteral | nullLiteral | arrayLiteral | mapLiteral)
          .cast();

  Parser<Expression> get groupOrIdentifierNoNumeric => (group |
          thisExpression |
          otherLiteral |
          identifier.map((v) => Variable(v)))
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
    if (name == 'sinh' && args.length == 1) {
      return Trigonometric('sinh', args[0]);
    }
    if (name == 'cosh' && args.length == 1) {
      return Trigonometric('cosh', args[0]);
    }
    if (name == 'tanh' && args.length == 1) {
      return Trigonometric('tanh', args[0]);
    }
    if (name == 'sech' && args.length == 1) {
      return Trigonometric('sech', args[0]);
    }
    if (name == 'csch' && args.length == 1) {
      return Trigonometric('csch', args[0]);
    }
    if (name == 'coth' && args.length == 1) {
      return Trigonometric('coth', args[0]);
    }

    // Inverse Hyperbolic functions
    if (name == 'asinh' && args.length == 1) {
      return Trigonometric('asinh', args[0]);
    }
    if (name == 'acosh' && args.length == 1) {
      return Trigonometric('acosh', args[0]);
    }
    if (name == 'atanh' && args.length == 1) {
      return Trigonometric('atanh', args[0]);
    }
    if (name == 'asech' && args.length == 1) {
      return Trigonometric('asech', args[0]);
    }
    if (name == 'acsch' && args.length == 1) {
      return Trigonometric('acsch', args[0]);
    }
    if (name == 'acoth' && args.length == 1) {
      return Trigonometric('acoth', args[0]);
    }

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
