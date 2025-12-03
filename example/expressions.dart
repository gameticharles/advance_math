import 'package:advance_math/advance_math.dart';

final context1 = {
  'x': 3.0,
  'y': 4.0,
  'z': 2,
  'a': true,
  'b': [1, 2, 3],
  'pi': pi,
  'e': e,
};

final context = {...defaultContext, ...context1};

void main(List<String> args) {
  // Example 1: Handle only positional arguments
  dynamic superHeroes = VarArgsFunction((args, kwargs) {
    for (final superHero in args) {
      print("There's no stopping $superHero");
    }
  });

  superHeroes(
      'UberMan', 'Exceptional Woman', 'The Hunk'); // Positional args only

  // Example 2: Handle both positional and named arguments
  dynamic myFunc = VarArgsFunction((args, kwargs) {
    print('Got args: $args, kwargs: $kwargs');
  });

  myFunc(1, 2, 3, x: 'hello', y: 'world'); // Positional + Named args
  myFunc(10, 20, x: true, y: false); // Another set of Positional + Named args
  myFunc('A', 'B', 'C'); // Positional args only

  // Example 3: Use the avg function
  print(avg([1, 2, 3, 4, 5]));
  print(avg(1, 2, 3, 4, 5));

  final testCases = [
    "1 + 2 * 3",
    "x + y - z",
    "(1 + 2) * 3",
    "foo.bar.baz",
    "foo(bar, baz)",
    "b[z]",
    "1 + 2 * (3 - 4)",
    "true",
    "null",
    "[1, 2, 3]",
    "{'a': 1, 'b': 2}",
    "'hello world'",
    '"this is \\nJSEP"',
    'a ? y : x',
    "-1",
    '!true',
    '1 - -2',
    '5! + 1',
    '(2 + 3)!',
    '3 != 3',
    '5! != 120',
    '5! + 3!',
    'x! != y'
  ];

  evaluateExpressions(testCases, "Test Cases", context);

  simpleMath();
  complexMath();
  conditionMath();

  logicMath();
  stringMath();
  dateTimeMath();
  polynomial();
  multiPolynomial();
  expressionMath();
}

var parsec = ExpressionParser();
void printExpressionResult(String expression, dynamic context) {
  try {
    var result = parsec.parse(expression).evaluate(context);
    print('Expression: $expression => $result');
  } catch (e) {
    print('Error evaluating expression `$expression`: $e');
  }
}

void evaluateExpressions(
    List<String> expressions, String category, dynamic context) {
  printLine(category);
  for (var expr in expressions) {
    printExpressionResult(expr, context);
  }
}

void simpleMath() {
  List<String> expressions = [
    '(5 + 1) + (6 - 2)',
    '4 + 4 * 3',
    '6*x + 4',
    'pi',
    '10.5 / 5.25',
    'abs(-5)',
    'sqrt(49)+10',
    'cos(x) + 2',
    'sqrt(x) - 3',
    'sqrt(x) + sin(pi/2)',
    'sqrt(16) + cbrt(8)',
    'log10(10)',
    'round(4.4)',
    '(3^3)^2',
    '3^(3^(2))',
    '3^2',
    'factorial(10)',
    'bigIntNChooseRModPrime(500, 250, 1000000007)',
    'string(10)',
    'roundTo(123.4567, 2)',
    'mean([1, 2, 3, 4, 5])',
    'nPr(5, 3)',
    '5P3',
    'nCr(5, 3)',
    '5C3',
    '5P3 + 5C3',
    'cosh(60)',
    'acosh(60)',
    'acot(0.5)',
    'csc(60)',
    'atan2(3,2)'
  ];

  evaluateExpressions(expressions, "Simple Math equations", context);

  print(Expression.parse('5*3-4').evaluate()); // 11
  print(Expression.parse('5*3-4').evaluate(context)); // 11
  print(Expression.parse('x').evaluate(context)); // 3.0
  print(Expression.parse('pi').evaluate(context)); // 3.14
  print(Expression.parse('6*x + 4').evaluate(context)); // 22

  print(Expression.parse('6*x + 4').evaluate(3)); // 22
  print(Expression.parse('sqrt(x) - 3').evaluate({'sqrt': sqrt, 'x': 81})); // 6
}

void complexMath() {
  List<String> expressions = [
    'log10(10) + ln(e) + log(10)',
    'sin(1) + cos(0) + tan(0.15722)',
    'max(1, 2) + min(3, 4) + sum(5, 6)',
    // 'avg(9, 9.8, 10)',
    'avg([9, 9.8, 10])',
    'pow(2, 3)',
    'round(4.559, 2)'
  ];
  evaluateExpressions(expressions, "Complex Math equations", context);
}

void conditionMath() {
  List<String> expressions = [
    '4 > 2 ? "bigger" : "smaller"',
    '2 == 2 ? true : false',
    '2 != 2 ? true : false',
    '"this" == "this" ? "yes" : "no"',
    '"this" != "that" ? "yes" : "no"'
  ];
  evaluateExpressions(expressions, "IF THEN ELSE equations", context);
}

void logicMath() {
  List<String> expressions = [
    '!true',
    'true and false',
    'true or false',
    '(3==3) and (3!=3)',
    'exp(1) == e'
  ];
  evaluateExpressions(expressions, "Logic equations", context);
}

void stringMath() {
  List<String> expressions = [
    'length("test string")',
    'toUpper("test string")',
    'toLower("TEST STRING")',
    'concat("Hello ", "World")',
    'link("Title", "http://foo.bar")',
    'str2number("5")',
    'left("Hello World", 5)',
    'right("Hello World", 5)',
    'number("5")'
  ];
  evaluateExpressions(expressions, "String equations", context);
}

void dateTimeMath() {
  List<String> expressions = [
    // # Date equations (return the difference in days)
    'now',
    'daysDiff(now, "2018-10-04")',
    'daysDiff("2018-01-01", "2018-12-31")',

    // # DateTime equations (return the difference in hours)
    'hoursDiff("2018-01-01", "2018-01-02")',
    'hoursDiff("2019-02-01T08:00", "2019-02-01T12:00")',
    'hoursDiff("2019-02-01T08:20", "2019-02-01T12:00")',
    'hoursDiff("2018-01-01", "2018-01-01")'
  ];

  evaluateExpressions(expressions, "DateTime Math equations", context);
}

void polynomial() {
  printLine('Polynomials');
  // printExpressionResult('roots(x^2 + 2x + 1)');
  var p = Polynomial.fromString('x^2 + 2x + 1');
  print(p.factorize());
  print(p.factorizeString());
  print(p.roots());
  // print(Expression.parse('x^2 + 2x + 1'));

  // Define P(x) and Q(x)
  Polynomial P = Polynomial.fromString("x^4 + 6x^2 + 4");
  print(P);
  Polynomial Q = Polynomial.fromString('x-2 - 9');
  print(Q);

  print(Expression.parse('(x-2)^2 - 9').expand());

  print(Q.factorizeString());
  print(Q.factorize());
  print(Q.roots());
  print(P / Q);

  // Perform the division
  var result = RationalFunction(P, Q); //Q.divide(P);

  // Print the quotient and remainder
  print("Quotient: ${result.quotient}");
  print("Remainder: ${result.remainder}");
}

void multiPolynomial() {
  printLine("Multi Polynomial");
  var polynomial = MultiVariablePolynomial([
    Term(3, {'x': 2, 'y': 1}),
    Term(2, {'x': 1}),
    Term(1, {'y': 2}),
    Term(4, {})
  ]);

  var result = polynomial.evaluate(
      {'x': 2, 'y': 3}); // This would compute 3*(x^2)*(y^1) + 2*x + y^2 + 4

  print(polynomial);
  print(result);

  var parsedPolynomial = MultiVariablePolynomial.fromString("7x^2y^3 + 2x + 5");
  print(parsedPolynomial);

  print(polynomial * parsedPolynomial);
}

void expressionMath() {
  printLine("Expressions Math");
  Variable x = Variable('x'), y = Variable('y');

  // Demonstrate all three expression creation approaches
  printLine("Expression Creation Methods");

  // Method 1: Explicit Literal objects (traditional approach)
  var expr1 = Add(Pow(x, Literal(2)), Literal(1));
  print('Method 1 (Explicit Literal): $expr1');

  // Method 2: Using toExpression() extension method
  var expr2 = (x ^ 2.toExpression()) + 1.toExpression();
  print('Method 2 (toExpression): $expr2');

  // Method 3: Using ex() helper function
  var expr3 = (x ^ ex(2)) + ex(1);
  print('Method 3 (ex helper): $expr3');

  // All three methods produce equivalent results
  var context = {'x': 3.0};
  print('All evaluate to same result:');
  print('  Method 1: ${expr1.evaluate(context)}');
  print('  Method 2: ${expr2.evaluate(context)}');
  print('  Method 3: ${expr3.evaluate(context)}');

  printLine("Complex Expression Examples");

  // Complex polynomial using mixed approaches
  var polynomial = 3.toExpression() * (x ^ ex(3)) -
      2.toExpression() * (x ^ ex(2)) +
      5.toExpression() * x -
      Literal(7);
  print('Mixed polynomial: $polynomial');
  print('Evaluated at x=2: ${polynomial.evaluate({'x': 2})}');

  // Multivariate expression with all three methods
  var multivar =
      ex(2) * x * y + 3.toExpression() * (x ^ ex(2)) - Literal(4) * y + ex(1);
  print('Multivariate: $multivar');
  print('Evaluated: ${multivar.evaluate({'x': 2, 'y': 3})}');

  // Rational expression
  var numerator = (x ^ 2.toExpression()) + ex(1);
  var denominator = x - ex(1);
  var rational = numerator / denominator;
  print('Rational: $rational');
  print('Evaluated at x=3: ${rational.evaluate({'x': 3})}');

  printLine("Calculus Operations");

  // Integration examples with enhanced methods
  var integrand = 6.toExpression() * x + ex(4);
  print('Integrand: $integrand');
  print('Integral: ${integrand.integrate()}');

  // Differentiation examples
  var func = (x ^ ex(3)) + 2.toExpression() * (x ^ ex(2)) - ex(5) * x + ex(7);
  print('Function: $func');
  print('Derivative: ${func.differentiate()}');

  printLine("Trigonometric Functions");

  // Trigonometric expressions with enhanced literals
  var trigExpr = Sin(2.toExpression() * x) + Cos(ex(3) * x);
  print('Trig expression: $trigExpr');

  // Integration of trigonometric functions
  print('Sin(x) integral: ${Sin(x).integrate()}');
  print('Cos(x) integral: ${Cos(x).integrate()}');

  printLine("Advanced Examples");

  // Logarithmic expressions
  var logExpr = Ln((x ^ ex(2)) + ex(1));
  print('Log expression: $logExpr');
  print('Log derivative: ${logExpr.differentiate()}');

  // Complex nested expressions
  var nested =
      ((2.toExpression() * x + ex(1)) ^ ex(2)) * (ex(3) * x - Literal(2));
  print('Nested expression: $nested');
  print('Simplified: ${nested.simplify()}');

  // Demonstrate operator precedence with enhanced methods
  var precedence = 2.toExpression() + ex(3) * x - Literal(4) / x;
  print('Precedence example: $precedence');
  print('Evaluated at x=2: ${precedence.evaluate({'x': 2})}');

  printLine("Performance Comparison");

  // Show that all methods produce identical Expression objects
  var literal = Literal(5) * x;
  var extension = 5.toExpression() * x;
  var helper = ex(5) * x;

  print('All methods create equivalent expressions:');
  print('  Literal result: ${literal.evaluate({'x': 2})}');
  print('  Extension result: ${extension.evaluate({'x': 2})}');
  print('  Helper result: ${helper.evaluate({'x': 2})}');
}
