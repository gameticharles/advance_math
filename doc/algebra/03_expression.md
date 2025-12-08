# Expression Module

Comprehensive symbolic mathematics with variables, operators, functions, parsing, evaluation, simplification, equation solving, and calculus operations.

---

## Table of Contents

1. [Overview](#overview)
2. [Expression Creation Methods](#expression-creation-methods)
3. [Variables and Literals](#variables-and-literals)
4. [Operators](#operators)
5. [Mathematical Functions](#mathematical-functions)
6. [Expression Parsing](#expression-parsing)
7. [Evaluation](#evaluation)
8. [Simplification](#simplification)
9. [Equation Solving](#equation-solving)
10. [Calculus: Differentiation](#calculus-differentiation)
11. [Calculus: Integration](#calculus-integration)
12. [Calculus: Taylor/Maclaurin Series](#calculus-taylormalclaurin-series)
13. [Calculus: Limits](#calculus-limits)
14. [Polynomials](#polynomials)
15. [VarArgsFunction](#varargsfunction)
16. [Error Handling](#error-handling)

---

## Overview

The Expression system provides symbolic mathematics with:

- Three equivalent methods for creating expressions
- Full parsing from string
- Symbolic differentiation and integration
- Equation solving (linear, quadratic, cubic, with parameters)
- Taylor/Maclaurin series expansion
- Simplification and expansion

---

## Expression Creation Methods

Three interchangeable approaches for creating expressions:

### Method 1: Explicit Literal Objects (Traditional)

```dart
import 'package:advance_math/advance_math.dart';

var x = Variable('x');
var expr = Add(Pow(x, Literal(2)), Literal(1));  // x² + 1
print(expr);  // ((x ^ 2) + 1)
```

### Method 2: Extension Method `toExpression()`

```dart
var x = Variable('x');
var expr = (x ^ 2.toExpression()) + 1.toExpression();
print(expr);  // ((x ^ 2) + 1)
```

### Method 3: Helper Function `ex()` (Shortest)

```dart
var x = Variable('x');
var expr = (x ^ ex(2)) + ex(1);
print(expr);  // ((x ^ 2) + 1)
```

### Mixed Approaches (Recommended for Complex Expressions)

```dart
var x = Variable('x');
var y = Variable('y');

// Mix all three freely
var expr = 2.toExpression() * x + ex(3) * y - Literal(1);
print(expr.evaluate({'x': 2, 'y': 3}));  // 12
```

### All Methods Produce Equivalent Results

```dart
var x = Variable('x');

var literal = Literal(5) * x;
var extension = 5.toExpression() * x;
var helper = ex(5) * x;

// All evaluate identically
print(literal.evaluate({'x': 2}));    // 10
print(extension.evaluate({'x': 2}));  // 10
print(helper.evaluate({'x': 2}));     // 10
```

---

## Variables and Literals

### Variable Class

```dart
var x = Variable('x');
var y = Variable('y');
var theta = Variable('theta');

var expr = x + y;
print(expr);  // (x + y)
```

### Literal Class

```dart
var two = Literal(2);
var half = Literal(0.5);
var pi_val = Literal(pi);

// Using helpers
var three = ex(3);
var four = 4.toExpression();
```

---

## Operators

### Arithmetic Operators

| Operation      | Class            | Operator |
| -------------- | ---------------- | -------- |
| Addition       | `Add(a, b)`      | `a + b`  |
| Subtraction    | `Subtract(a, b)` | `a - b`  |
| Multiplication | `Multiply(a, b)` | `a * b`  |
| Division       | `Divide(a, b)`   | `a / b`  |
| Power          | `Pow(a, b)`      | `a ^ b`  |
| Negation       | `Negate(a)`      | `-a`     |

```dart
var x = Variable('x');

// Using operators
var expr = 3.toExpression() * (x ^ ex(2)) - 2.toExpression() * x + ex(5);
print(expr);  // ((3 * (x ^ 2)) - (2 * x) + 5)
```

---

## Mathematical Functions

### Trigonometric

```dart
var x = Variable('x');

Sin(x);   Sin(x, n: 2);  // sin(x), sin²(x)
Cos(x);   Cos(x, n: 3);  // cos(x), cos³(x)
Tan(x);   Cot(x);
Sec(x);   Csc(x);
```

### Inverse Trigonometric

```dart
Asin(x);  Acos(x);  Atan(x);
```

### Hyperbolic

```dart
Sinh(x);  Cosh(x);  Tanh(x);
Asinh(x); Acosh(x); Atanh(x);
```

### Exponential and Logarithmic

```dart
Exp(x);           // e^x
Ln(x);            // ln(x)
Log(ex(10), x);   // log₁₀(x)
Log.base10(x);    // log₁₀(x)
```

### Power and Root

```dart
Pow(x, ex(2));    // x²
Sqrt(x);          // √x
Cbrt(x);          // ³√x
```

---

## Expression Parsing

### Basic Parsing

```dart
// Arithmetic
Expression.parse('1 + 2 * 3');       // 7
Expression.parse('(1 + 2) * 3');     // 9
Expression.parse('2^3^2');           // 512 (right associative)

// Scientific notation
Expression.parse('1.234e+1');        // 12.34
Expression.parse('12.3e-1');         // 1.23
```

### Functions

```dart
Expression.parse('sin(1)');                    // 0.841...
Expression.parse('sin(sin(2)) + 4');           // 4.789...
Expression.parse('max(4, 6, 3)');              // 6
Expression.parse('max(4, 5+7, 3)');            // 12
```

### Percentages and Modulus

```dart
Expression.parse('5%');         // 0.05
Expression.parse('100*10%');    // 10
Expression.parse('10%4');       // 2 (modulus when between numbers)
```

### Arrays and Vectors

```dart
Expression.parse('[1, 2, 3]');
Expression.parse('[1, [3, 5, 7], [1, [2, [1, 2]]]]');

// Accessing elements
Expression.parse('[1, 2, 3, 4, 5][2]');      // 3
Expression.parse('[1, 2, 3, 4, 5][1:4]');    // [2, 3, 4]
Expression.parse('[1, 2, 3, 4, 5][-2]');     // 4 (negative index)
```

### Ternary and Comparison

```dart
Expression.parse('a ? y : x');
Expression.parse('4 > 2 ? "bigger" : "smaller"');
Expression.parse('3 != 3');      // false
Expression.parse('5! != 120');   // false (5! = 120)
```

### Factorial, Permutations, Combinations

```dart
Expression.parse('5!');          // 120
Expression.parse('(2+3)!');      // 120
Expression.parse('5P3');         // 60 (permutations)
Expression.parse('5C3');         // 10 (combinations)
Expression.parse('nPr(5, 3)');   // 60
Expression.parse('nCr(5, 3)');   // 10
```

### Prefixes (Unary Minus)

```dart
Expression.parse('-(-3*-(4))');           // -12
Expression.parse('-(-1-+1)^2');           // -4
Expression.parse('5^---3');               // 0.008
Expression.parse('-(--5*--7)');           // -35
```

---

## Evaluation

### Basic Evaluation

```dart
var expr = Expression.parse('6*x + 4');

// With context
print(expr.evaluate({'x': 3}));  // 22

// Direct evaluation
print(Expression.parse('5*3 - 4').evaluate());  // 11
```

### Default Context

```dart
import 'package:advance_math/advance_math.dart';

// defaultContext includes pi, e, and common functions
var context = {...defaultContext, 'x': 3.0, 'y': 4.0};

Expression.parse('sqrt(x^2 + y^2)').evaluate(context);  // 5.0
Expression.parse('pi').evaluate(context);               // 3.14159...
```

### Built-in Functions

```dart
// Math functions
Expression.parse('abs(-5)').evaluate();
Expression.parse('sqrt(49)').evaluate();
Expression.parse('round(4.5)').evaluate();
Expression.parse('factorial(10)').evaluate();
Expression.parse('mean([1, 2, 3, 4, 5])').evaluate();

// String functions
Expression.parse('length("test")').evaluate();
Expression.parse('toUpper("hello")').evaluate();
Expression.parse('concat("Hello ", "World")').evaluate();

// DateTime functions
Expression.parse('daysDiff(now, "2018-10-04")').evaluate();
```

---

## Simplification

### Automatic Simplification

```dart
var x = Variable('x');

// Combine like terms
Expression.parse('2*sin(x) + 4*sin(x)').simplify();  // 6*sin(x)
Expression.parse('sin(x) + sin(x)').simplify();      // 2*sin(x)

// Simplify powers
Expression.parse('cosh(x)*cosh(x)').simplify();      // cosh(x)^2
Expression.parse('y*tanh(x)*tanh(x)').simplify();    // y*tanh(x)^2

// Arithmetic simplification
Expression.parse('2*-4').simplify();                 // -8
Expression.parse('0-4').simplify();                  // -4
```

### Core Examples

```dart
Expression.parse('((((((1+1)))))').simplify();       // 2
Expression.parse('4^2').simplify();                  // 16
Expression.parse('6.5*2').simplify();                // 13.0
```

---

## Equation Solving

### Linear Equations

```dart
Expression.parse('solve(x+1=5, x)').evaluate();      // [4]
Expression.parse('solve(2*x-4=0, x)').evaluate();    // [2]
Expression.parse('solve(x/2+1=3, x)').evaluate();    // [4]
```

### Quadratic Equations

```dart
Expression.parse('solve(x^2-1=0, x)').evaluate();        // [1, -1]
Expression.parse('solve(x^2+2*x+1=0, x)').evaluate();    // [-1, -1]
Expression.parse('solve(x^2+1=0, x)').evaluate();        // [i, -i]
```

### Cubic Equations

```dart
Expression.parse('solve(x^3-10x^2+31x-30,x)').evaluate();  // [3, 5, 2]
Expression.parse('solve(8x^3-26x^2+3x+9,x)').evaluate();   // [3/4, -1/2, 3]
```

### Factored Equations

```dart
Expression.parse('solve((x-1)*(x-2)=0, x)').evaluate();  // [2, 1]
Expression.parse('solve(x*(x+3)=0, x)').evaluate();      // [0, -3]
```

### Equations with Parameters

```dart
Expression.parse('solve(x+a=0, x)').evaluate();          // [-1*a]
Expression.parse('solve(a*x+b=0, x)').evaluate();        // [-b/a]
Expression.parse('solve(a*x^2+b*x+c, x)').evaluate();    // Quadratic formula
```

### System of Equations

```dart
Expression.parse('solveEquations(["x+y=1", "x-y=1"])').evaluate();
// [x, 1, y, 0]

Expression.parse('solveEquations(["x+y=1", "2*x=6", "4*z+y=6"])').evaluate();
// [x, 3, y, -2, z, 2]

Expression.parse('solveEquations(["x+y=3", "y^3-x=7"])').evaluate();
// [x, 1, y, 2]
```

### Advanced Solve Examples

```dart
// Logarithmic
Expression.parse('solve(log(a*x-c)-b=21, x)').evaluate();
// [-(-c-e^(21+b))*a^(-1)]

// Trigonometric
Expression.parse('solve(3*sin(a^2*x-b)-4,x)').evaluate();
// [a^(-2)*asin(4/3)]

// Square roots
Expression.parse('solve(sqrt(x)+sqrt(2x+1)=5,x)').evaluate();  // [4]
```

---

## Calculus: Differentiation

### Basic Differentiation

```dart
var x = Variable('x');

Literal(5).differentiate();           // 0
x.differentiate();                    // 1
x.differentiate(Variable('y'));       // 0
```

### Power Rule

```dart
Pow(x, Literal(3)).differentiate(x);     // 3 * x^2
Pow(x, Literal(-1)).differentiate(x);    // -1 * x^-2
```

### Product Rule

```dart
Multiply(x, Sin(x)).differentiate(x);
// sin(x) + x * cos(x)
```

### Quotient Rule

```dart
Divide(x, Pow(x, Literal(2))).differentiate(x);
// (x² - 2x²) / x⁴
```

### Chain Rule - Trigonometric

```dart
Sin(x).differentiate(x);                          // cos(x)
Cos(x).differentiate(x);                          // -sin(x)
Tan(x).differentiate(x);                          // sec²(x)
Sin(Multiply(Literal(2), x)).differentiate(x);    // 2*cos(2x)
```

### Chain Rule - Inverse Trigonometric

```dart
Asin(x).differentiate(x);  // 1/√(1-x²)
Acos(x).differentiate(x);  // -1/√(1-x²)
Atan(x).differentiate(x);  // 1/(1+x²)
```

### Chain Rule - Exponential/Logarithmic

```dart
Exp(x).differentiate(x);                    // e^x
Exp(Multiply(Literal(2), x)).differentiate(x);  // 2*e^(2x)
Ln(x).differentiate(x);                     // 1/x
Ln(Pow(x, Literal(2))).differentiate(x);    // 2/x
```

### Partial Derivatives

```dart
import 'package:advance_math/src/math/algebra/calculus/symbolic_calculus.dart';

var x = Variable('x');
var y = Variable('y');

var f = Multiply(Multiply(x, x), y);  // x²y

// ∂f/∂x = 2xy
var dfdx = f.differentiate(x);

// ∂f/∂y = x²
var dfdy = f.differentiate(y);

// Using extension method
var expr = Expression.parse('x^3');
var deriv = expr.partialD('x');
```

---

## Calculus: Integration

### Power Rule

```dart
var x = Variable('x');

x.integrate();                    // x²/2
Pow(x, Literal(2)).integrate();   // x³/3
Pow(x, Literal(-1)).integrate();  // ln(x)
Literal(5).integrate();           // 5*x
```

### Trigonometric Integration

```dart
Sin(x).integrate();                              // -cos(x)
Cos(x).integrate();                              // sin(x)
Pow(Sec(x), Literal(2)).integrate();             // tan(x)
Pow(Csc(x), Literal(2)).integrate();             // -cot(x)

// With coefficients
Sin(Multiply(Literal(2), x)).integrate();        // -0.5*cos(2x)
Cos(Multiply(Literal(4), x)).integrate();        // 0.25*sin(4x)
Tan(Multiply(Literal(2), x)).integrate();        // -0.5*ln|cos(2x)|
Csc(Multiply(Literal(2), x)).integrate();        // 0.5*ln|tan(x)|
```

### Exponential Integration

```dart
Exp(x).integrate();                    // e^x
Pow(Literal(2), x).integrate();        // 2^x / ln(2)
```

### Sum and Difference

```dart
Add(x, Pow(x, Literal(2))).integrate();        // x²/2 + x³/3
Add(Sin(x), Cos(x)).integrate();               // -cos(x) + sin(x)
```

### U-Substitution

```dart
// ∫2x·sin(x²) dx = -cos(x²)
Multiply(Multiply(Literal(2), x), Sin(Pow(x, Literal(2)))).integrate();

// ∫2x·e^(x²) dx = e^(x²)
Multiply(Multiply(Literal(2), x), Exp(Pow(x, Literal(2)))).integrate();
```

### Integration by Parts

```dart
// ∫x·cos(x) dx = x·sin(x) + cos(x)
Multiply(x, Cos(x)).integrate();

// ∫x·e^x dx = x·e^x - e^x
Multiply(x, Exp(x)).integrate();
```

### Definite Integrals

```dart
import 'package:advance_math/src/math/algebra/calculus/symbolic_calculus.dart';

var x = Variable('x');

// ∫₀² x² dx = 8/3
SymbolicCalculus.definiteIntegral(Pow(x, Literal(2)), 'x', 0, 2);

// ∫₀^π sin(x) dx = 2
SymbolicCalculus.definiteIntegral(Sin(x), 'x', 0, pi);

// Using extension
var expr = Expression.parse('x^3');
expr.definiteIntegral('x', 0, 2);  // 4
```

---

## Calculus: Taylor/Maclaurin Series

### Taylor Series

```dart
import 'package:advance_math/src/math/algebra/calculus/symbolic_calculus.dart';

var x = Variable('x');

// Taylor series of sin(x) around x=0, order 3
var taylor = SymbolicCalculus.taylorSeries(Sin(x), 'x', 0, 3);

// Using extension
var expr = Expression.parse('x^2');
var taylor = expr.taylor('x', 1, 2);  // Around x=1, order 2
```

### Maclaurin Series (Taylor at x=0)

```dart
// Maclaurin series of e^x, order 4
var maclaurin = SymbolicCalculus.maclaurinSeries(Exp(x), 'x', 4);

// Using extension
var cosExpr = Cos(Variable('x'));
var series = cosExpr.maclaurin('x', 4);
```

---

## Calculus: Limits

### Basic Limits

```dart
import 'package:advance_math/src/math/algebra/calculus/symbolic_calculus.dart';

var x = Variable('x');

// lim(x→1) (x² - 1)/(x - 1) = 2
var expr = (Expression.parse('x^2') - Literal(1)) / (x - Literal(1));
SymbolicCalculus.limit(expr, 'x', 1);  // 2.0

// lim(x→0) sin(x)/x = 1
SymbolicCalculus.limit(Sin(x) / x, 'x', 0);  // 1.0
```

### One-Sided Limits

```dart
var expr = Literal(1) / x;

// From right: approaches +∞
SymbolicCalculus.limit(expr, 'x', 0, direction: 'right');

// From left: approaches -∞
SymbolicCalculus.limit(expr, 'x', 0, direction: 'left');

// Using extension
expr.limitAt('x', 2);  // Limit as x→2
```

---

## Polynomials

### Single Variable Polynomials

```dart
var p = Polynomial.fromString('x^2 + 2x + 1');
print(p);                    // x² + 2x + 1
print(p.roots());            // [-1, -1]
print(p.factorize());        // (x + 1)²
print(p.factorizeString());  // "(x + 1)^2"
```

### Polynomial Division

```dart
Polynomial P = Polynomial.fromString("x^4 + 6x^2 + 4");
Polynomial Q = Polynomial.fromString('x^2 - 9');

var result = RationalFunction(P, Q);
print("Quotient: ${result.quotient}");
print("Remainder: ${result.remainder}");
```

### Multi-Variable Polynomials

```dart
var polynomial = MultiVariablePolynomial([
  Term(3, {'x': 2, 'y': 1}),  // 3x²y
  Term(2, {'x': 1}),          // 2x
  Term(1, {'y': 2}),          // y²
  Term(4, {})                 // 4
]);

print(polynomial);  // 3x²y + 2x + y² + 4
print(polynomial.evaluate({'x': 2, 'y': 3}));  // 49

// From string
var parsed = MultiVariablePolynomial.fromString("7x^2y^3 + 2x + 5");

// Multiplication
print(polynomial * parsed);
```

---

## VarArgsFunction

Handle variable number of arguments in functions:

```dart
import 'package:advance_math/advance_math.dart';

// Create custom varargs function
dynamic superHeroes = VarArgsFunction((args, kwargs) {
  for (final hero in args) {
    print("There's no stopping $hero");
  }
});

superHeroes('UberMan', 'Exceptional Woman', 'The Hunk');

// With positional and named arguments
dynamic myFunc = VarArgsFunction((args, kwargs) {
  print('Got args: $args, kwargs: $kwargs');
});

myFunc(1, 2, 3, x: 'hello', y: 'world');
```

### Built-in VarArgs Functions

```dart
// avg - works with list or individual args
Expression.parse('avg(10, 20, 30)').evaluate();   // 20.0
Expression.parse('avg([10, 20, 30])').evaluate(); // 20.0

// max/min
Expression.parse('max(1, 5, 2)').evaluate();      // 5
Expression.parse('min([1, 5, 2])').evaluate();    // 1

// sum
Expression.parse('sum(1, 2, 3)').evaluate();      // 6
Expression.parse('sum([1, 2, 3])').evaluate();    // 6
```

---

## Error Handling

### Domain Validation

```dart
// Inverse trig domain checks
Asin(Literal(2)).evaluate();   // throws ArgumentError (|x| > 1)
Acos(Literal(-2)).evaluate();  // throws ArgumentError

// atan works for all real numbers
Atan(Literal(1000)).evaluate(); // OK
```

### Unsupported Integration

```dart
// Some complex expressions throw UnimplementedError
Multiply(Sin(x), Cos(x)).integrate();  // throws UnimplementedError
```

### Limit Edge Cases

```dart
// Invalid direction
SymbolicCalculus.limit(x, 'x', 0, direction: 'invalid');  // throws ArgumentError

// Negative Taylor order
expr.taylor('x', 0, -1);  // throws ArgumentError
```

---

## Complete Example

```dart
import 'package:advance_math/advance_math.dart';

void main() {
  var x = Variable('x');

  // Create polynomial using enhanced methods
  var poly = ex(3) * (x ^ ex(2)) + 2.toExpression() * x + Literal(1);
  print('Polynomial: $poly');

  // Evaluate
  print('P(2) = ${poly.evaluate({'x': 2})}');  // 17

  // Differentiate
  var deriv = poly.differentiate();
  print('P\'(x) = $deriv');  // 6x + 2

  // Integrate
  var integral = poly.integrate();
  print('∫P(x)dx = $integral');  // x³ + x² + x

  // Simplify expression
  var complex = Expression.parse('2*sin(x) + 4*sin(x)');
  print('Simplified: ${complex.simplify()}');  // 6*sin(x)

  // Solve equation
  var solution = Expression.parse('solve(x^2-4=0, x)').evaluate();
  print('Solutions: $solution');  // [2, -2]
}
```

## Related Documentation

- [Enhanced Expression Creation](enhanced_expression_creation.md)
- [Migration Guide](expression_migration_guide.md)
- [Troubleshooting](expression_troubleshooting.md)
