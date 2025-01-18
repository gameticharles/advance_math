import 'package:advance_math/advance_math.dart';

final context1 = {
  'x': 3.0,
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
  print(avg([1, 2, 3, 4, 5])); // This will print the average of the numbers
  print(avg(1, 2, 3, 4, 5));

  printLine();

  final testCases = [
    "1 + 2 * 3",
    "a + b - c",
    "(1 + 2) * 3",
    "foo.bar.baz",
    "foo(bar, baz)",
    "a[b]",
    "1 + 2 * (3 - 4)",
    "true",
    "null",
    "this",
    "[1, 2, 3]",
    "{'a': 1, 'b': 2}",
    "'hello world'",
    '"this is \\nJSEP"',
    'a ? b : c',
    "-1",
    '!true',
    '1 - -2',
  ];

  for (final input in testCases) {
    printExpressionResult(input);
  }

  //simpleMath();
  complexMath();
  conditionMath();
  polynomial();
  multiPolynomial();
  logicMath();
  stringMath();
  dateTimeMath();
  expressionMath();
}

var parsec = ExpressionParser();
void printExpressionResult(String expression) {
  try {
    var result = parsec.parse(expression).evaluate(context);
    print('Expression: $expression => $result');
  } catch (e) {
    print('Error evaluating expression `$expression`: $e');
  }
}

void simpleMath() {
  printLine("Simple Math equations");

  print(Expression.parse('5*3-4').evaluate()); // 11
  print(Expression.parse('5*3-4').evaluate(context)); // 11
  print(Expression.parse('x').evaluate(context)); // 3.0
  print(Expression.parse('pi').evaluate(context)); // 3.14
  print(Expression.parse('6*x + 4').evaluate(context)); // 22

  print(Expression.parse('6*x + 4').evaluate(3)); // 22
  print(Expression.parse('sqrt(x) - 3').evaluate({'sqrt': sqrt, 'x': 81})); // 6

  print('');

  printExpressionResult('(5 + 1) + (6 - 2)');
  printExpressionResult('4 + 4 * 3');
  printExpressionResult('6*x + 4');
  printExpressionResult('pi');
  printExpressionResult('10.5 / 5.25');
  printExpressionResult('abs(-5)');
  printExpressionResult('sqrt(49)+10');
  printExpressionResult('cos(x) + 2');
  printExpressionResult('sqrt(x) + sin(pi/2)');
  printExpressionResult('sqrt(16) + cbrt(8)');
  printExpressionResult('log10(10)');
  printExpressionResult('round(4.4)');
  printExpressionResult('(3^3)^2');
  printExpressionResult('3^(3^(2))');
  printExpressionResult('3^2'); //
  printExpressionResult('factorial(10)');
  printExpressionResult('bigIntNChooseRModPrime(500, 250, 1000000007)');
  printExpressionResult('string(10)');
  printExpressionResult('roundTo(123.4567, 2)');
  printExpressionResult('mean([1, 2, 3, 4, 5])');
  printExpressionResult('nPr(5, 3)');
  printExpressionResult('5P3');
  printExpressionResult('nCr(5, 3)');
  printExpressionResult('5C3');
  printExpressionResult('5P3 + 5C3');
  printExpressionResult('cosh(60)');
  printExpressionResult('acosh(60)');
  printExpressionResult('acot(0.5)');
  printExpressionResult('csc(60)');
  printExpressionResult('atan2(3,2)');
}

void complexMath() {
  printLine("Complex Math equations");

  printExpressionResult('log10(10) + ln(e) + log(10)');
  printExpressionResult('sin(1) + cos(0) + tan(0.15722)');
  printExpressionResult('max(1, 2) + min(3, 4) + sum(5, 6)');
  printExpressionResult('avg(9, 9.8, 10)');
  printExpressionResult('pow(2, 3)');
  printExpressionResult('round(4.559, 2)');
}

void conditionMath() {
  printLine("IF THEN ELSE equations");

  printExpressionResult('4 > 2 ? "bigger" : "smaller"');
  printExpressionResult('2 == 2 ? true : false');
  printExpressionResult('2 != 2 ? true : false');
  printExpressionResult('"this" == "this" ? "yes" : "no"');
  printExpressionResult('"this" != "that" ? "yes" : "no"');
}

void logicMath() {
  printLine("Logic equations");

  printExpressionResult('!true');
  printExpressionResult('true and false');
  printExpressionResult('true or false');
  printExpressionResult('(3==3) and (3!=3)');
  printExpressionResult('exp(1) == e');
}

void stringMath() {
  printLine("String equations");

  printExpressionResult('length("test string")');
  printExpressionResult('toUpper("test string")');
  printExpressionResult('toLower("TEST STRING")');
  printExpressionResult('concat("Hello ", "World")');
  printExpressionResult('link("Title", "http://foo.bar")');
  printExpressionResult('str2number("5")');
  printExpressionResult('left("Hello World", 5)');
  printExpressionResult('right("Hello World", 5)');
  printExpressionResult('number("5")');
}

void dateTimeMath() {
  printLine("DateTime Math equations");

  // # Date equations (return the difference in days)
  printExpressionResult('current_date()');
  printExpressionResult('daysDiff(current_date(), "2018-10-04")');
  printExpressionResult('daysDiff("2018-01-01", "2018-12-31")');

  // # DateTime equations (return the difference in hours)
  printExpressionResult('hoursDiff("2018-01-01", "2018-01-02")');
  printExpressionResult('hoursDiff("2019-02-01T08:00", "2019-02-01T12:00")');
  printExpressionResult('hoursDiff("2019-02-01T08:20", "2019-02-01T12:00")');
  printExpressionResult('hoursDiff("2018-01-01", "2018-01-01")');
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
  Polynomial Q = Polynomial.fromString('(x-2) - 9');
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
  var one = Literal(1);
  var two = Literal(2);
  var expr = Add(Pow(x, two), one);
  print(expr);
  print(expr.integrate());
  print(Expression.parse('(x^2) + 1').integrate().simplify()); // 16

  print(Add(Multiply(Literal(6), Variable('x')), Literal(4)).integrate());
  print(Expression.parse('6 * x + 4').integrate());
  print(Expression.parse('6 * x + 4').evaluate(2)); // 16

  Pow xSquare = Pow(x, Literal(2));
  var yCos = Trigonometric('cos', y);
  Literal three = Literal(3);
  Expression exp = (xSquare + yCos) / three;
  print(exp);

  print(Ln(Add(xSquare, Literal(1))).differentiate());

  print((Cos(x) + Sin(x)).integrate());

  print(Csc(x).integrate()); // csc(x)  = ln|tan(x/2 )|+ C
  print(Pow(Csc(x), Literal(2)).integrate()); // csc(x)  = ln|tan(x/2 )|+ C
  print(
    Csc(Multiply(Literal(2), x)).integrate(),
  ); // csc(2x)  = 1/2 ln|tan(x)|+ C

  print(
    Csc(Multiply(Literal(3), x)).integrate(),
  ); // csc(3x)  = 1/3 ln|tan(3x/2)|+ C

  print(
    Csc(Add(Multiply(Literal(4), x), Literal(1))).integrate(),
  ); // csc(4x + 1) =  1/4 ln|tan((4x + 1)/2)|+ C

  print(Csc(x, n: 2).differentiate());

  print(
    Add(Multiply(Literal(2), x),
            Add(Add(Literal(5), x), Multiply(Literal(2), x)))
        .simplify(),
  );

  print(
    Add(Multiply(Literal(8), y), Multiply(Literal(2), x))
        .simplify()
        .evaluate({'x': 1}),
  );

  print(
    Add(
      Multiply(Literal(8), y),
      Multiply(Literal(2), x),
    ).simplify().evaluate({'x': 1, 'y': 2}),
  );

  exp = Add(
    Add(Multiply(Literal(2), xSquare), Multiply(Literal(3), xSquare)),
    Add(Literal(4) * Multiply(x, y), Literal(2) * Multiply(x, y)),
  ).simplify();
  print(exp.getVariables());
  print(exp.getVariableTerms());

  exp = Subtract(Multiply(Literal(1), x), Literal(-5));
  print(exp); // ((x * 1.0) - (-5.0))
  print(exp.simplify()); // (x + 5.0)
  print(Pow(Add(x, y), Literal(2)));
  print(Pow(Pow(Literal(3), Literal(3)), Literal(2)).evaluate()); // 729
  print(Pow(Literal(3), Pow(Literal(3), Literal(2))).evaluate()); // 19683
  print(Expression.parse(r'3^(3^(2))').evaluate());
  print(Expression.parse('10^2').evaluate());
  print(Pow(Literal(10), Literal(2)).evaluate());
}
