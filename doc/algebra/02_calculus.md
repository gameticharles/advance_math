# Calculus Module

Symbolic and numerical calculus operations including differentiation, integration, Taylor series, and limits.

---

## Table of Contents

1. [Symbolic Differentiation](#symbolic-differentiation)
2. [Symbolic Integration](#symbolic-integration)
3. [Numerical Differentiation](#numerical-differentiation)
4. [Numerical Integration](#numerical-integration)
5. [Taylor Series](#taylor-series)
6. [Limits](#limits)
7. [Hybrid Calculus](#hybrid-calculus)

---

## Symbolic Differentiation

### Basic Differentiation

```dart
import 'package:advance_math/advance_math.dart';

var x = Variable('x');

// Power rule
var f = x ^ ex(3);  // x³
print(f.differentiate());  // 3 * x²

// Product rule
var g = x * Sin(x);
print(g.differentiate());  // sin(x) + x * cos(x)

// Chain rule
var h = Sin(x ^ ex(2));
print(h.differentiate());  // 2 * x * cos(x²)

// Quotient rule
var q = x / (x + ex(1));
print(q.differentiate());
```

### Partial Derivatives

```dart
import 'package:advance_math/src/math/algebra/calculus/symbolic_calculus.dart';

var x = Variable('x');
var y = Variable('y');

var f = x * x + x * y + y * y;

// Partial derivative with respect to x
var dfdx = SymbolicCalculus.partialDerivative(f, 'x');
print(dfdx);  // 2*x + y

// Partial derivative with respect to y
var dfdy = SymbolicCalculus.partialDerivative(f, 'y');
print(dfdy);  // x + 2*y
```

### Higher-Order Derivatives

```dart
var x = Variable('x');
var f = x ^ ex(4);  // x⁴

// First derivative: 4x³
var f1 = f.differentiate();

// Second derivative: 12x²
var f2 = f1.differentiate();

// Third derivative: 24x
var f3 = f2.differentiate();

print(f3);  // 24 * x
```

---

## Symbolic Integration

### Basic Integration

```dart
import 'package:advance_math/advance_math.dart';

var x = Variable('x');

// Power rule
var f = x ^ ex(2);  // x²
print(f.integrate());  // (x³)/3 + C

// Trigonometric
print(Sin(x).integrate());  // -cos(x) + C
print(Cos(x).integrate());  // sin(x) + C

// Exponential
print(Exp(x).integrate());  // e^x + C

// Logarithmic
print((ex(1) / x).integrate());  // ln(x) + C
```

### Trigonometric Integrals

```dart
var x = Variable('x');

// Basic trig integrals
print(Sec(x).integrate());    // ln|sec(x) + tan(x)| + C
print(Csc(x).integrate());    // ln|tan(x/2)| + C
print(Tan(x).integrate());    // -ln|cos(x)| + C
print(Cot(x).integrate());    // ln|sin(x)| + C

// Powers of trig functions
print(Pow(Sin(x), Literal(2)).integrate());
print(Pow(Cos(x), Literal(2)).integrate());
print(Pow(Csc(x), Literal(2)).integrate());  // -cot(x) + C
```

### Integration with Coefficients

```dart
var x = Variable('x');

// ∫ csc(2x) dx = (1/2) ln|tan(x)| + C
print(Csc(Multiply(Literal(2), x)).integrate());

// ∫ csc(3x) dx = (1/3) ln|tan(3x/2)| + C
print(Csc(Multiply(Literal(3), x)).integrate());

// ∫ csc(4x + 1) dx = (1/4) ln|tan((4x+1)/2)| + C
print(Csc(Add(Multiply(Literal(4), x), Literal(1))).integrate());
```

---

## Numerical Differentiation

### Finite Differences

```dart
import 'package:advance_math/advance_math.dart';

double f(double x) => x * x * x;  // f(x) = x³

// Forward difference
double forwardDiff = numDifferentiate(f, 2, method: DiffMethod.forward);
print(forwardDiff);  // ≈ 12 (derivative of x³ at x=2 is 3*4=12)

// Central difference (more accurate)
double centralDiff = numDifferentiate(f, 2, method: DiffMethod.central);
print(centralDiff);  // ≈ 12

// Backward difference
double backwardDiff = numDifferentiate(f, 2, method: DiffMethod.backward);
print(backwardDiff);  // ≈ 12
```

### Higher-Order Numerical Derivatives

```dart
// Second derivative
double h = 0.001;
double f2 = (f(2 + h) - 2 * f(2) + f(2 - h)) / (h * h);
print(f2);  // ≈ 12 (d²/dx² of x³ at x=2 is 6*2=12)
```

---

## Numerical Integration

### Quadrature Methods

```dart
import 'package:advance_math/advance_math.dart';

double f(double x) => x * x;  // f(x) = x²

// Simpson's rule (default)
double integral = numIntegrate(f, 0, 2);
print(integral);  // ≈ 2.667 (∫₀² x² dx = 8/3)

// With more subdivisions
double precise = numIntegrate(f, 0, 2, n: 1000);
print(precise);  // More accurate
```

### Definite Integrals with Expressions

```dart
import 'package:advance_math/src/math/algebra/calculus/symbolic_calculus.dart';

var polyExpr = Expression.parse('x^2');
var result = SymbolicCalculus.definiteIntegral(polyExpr, 'x', 0, 3);
print(result);  // 9 (∫₀³ x² dx = 27/3 = 9)
```

---

## Taylor Series

### Computing Taylor Expansions

```dart
import 'package:advance_math/src/math/algebra/calculus/symbolic_calculus.dart';

var x = Variable('x');
var sinExpr = Sin(x);

// Taylor series of sin(x) at x=0, order 5
var taylor = SymbolicCalculus.taylorSeries(sinExpr, 'x', 0, 5);
print(taylor);
// x - x³/6 + x⁵/120 (first 3 non-zero terms)
```

### Taylor Series Parameters

| Parameter    | Description                |
| ------------ | -------------------------- |
| `expression` | The function to expand     |
| `variable`   | Variable name to expand in |
| `a`          | Point of expansion         |
| `order`      | Number of terms            |

```dart
// Taylor series of e^x at x=0
var expExpr = Exp(Variable('x'));
var taylorExp = SymbolicCalculus.taylorSeries(expExpr, 'x', 0, 5);
print(taylorExp);  // 1 + x + x²/2 + x³/6 + x⁴/24 + x⁵/120

// Taylor series at different point
var taylorAt1 = SymbolicCalculus.taylorSeries(sinExpr, 'x', pi/2, 4);
```

---

## Limits

### Computing Limits

```dart
import 'package:advance_math/advance_math.dart';

var x = Variable('x');

// Simple limit
var limitExpr = Sin(x) / x;
var limitVal = SymbolicCalculus.limit(limitExpr, 'x', 0);
print(limitVal);  // 1 (lim x→0 sin(x)/x = 1)
```

### Limit Class

```dart
var f = Expression.parse('(x^2 - 1)/(x - 1)');
var limit = Limit(f, 1);

// Compute limit (uses L'Hopital's rule for indeterminate forms)
var result = limit.compute();
print(result);  // 2 (lim x→1 = 2)
```

### Directional Limits

```dart
var f = Expression.parse('1/x');

// Left limit
var leftLimit = Limit(f, 0, direction: 'left');
print(leftLimit.compute());  // -∞

// Right limit
var rightLimit = Limit(f, 0, direction: 'right');
print(rightLimit.compute());  // +∞

// Both sides (default)
var bothLimit = Limit(f, 0, direction: 'both');
// Throws: "Limit does not exist"
```

### L'Hopital's Rule

The `Limit` class automatically applies L'Hôpital's rule for indeterminate forms (0/0, ∞/∞):

```dart
// 0/0 form
var f = (Sin(x) / x);
var limit = Limit(f, 0);
print(limit.compute());  // 1

// Applies: lim (sin(x)/x) = lim (cos(x)/1) = 1
```

---

## Hybrid Calculus

Compare symbolic and numerical results for validation:

```dart
import 'package:advance_math/src/math/algebra/calculus/hybrid_calculus.dart';

var expr = Expression.parse('x^3');

var comparison = HybridCalculus.compareResults(
  expr, 'x', 2,  // Evaluate at x=2
  a: 0, b: 2     // Integrate from 0 to 2
);

print('Derivative Error: ${comparison['derivative']['error']}');
print('Integral Error: ${comparison['integral']['error']}');
```

---

## Available Derivative Rules

| Expression Type  | Derivative                       |
| ---------------- | -------------------------------- |
| `Literal(c)`     | `0`                              |
| `Variable(x)`    | `1`                              |
| `Add(f, g)`      | `f' + g'`                        |
| `Subtract(f, g)` | `f' - g'`                        |
| `Multiply(f, g)` | `f'g + fg'` (Product rule)       |
| `Divide(f, g)`   | `(f'g - fg')/g²` (Quotient rule) |
| `Pow(f, n)`      | `n * f^(n-1) * f'` (Chain rule)  |
| `Sin(f)`         | `cos(f) * f'`                    |
| `Cos(f)`         | `-sin(f) * f'`                   |
| `Tan(f)`         | `sec²(f) * f'`                   |
| `Exp(f)`         | `e^f * f'`                       |
| `Ln(f)`          | `f'/f`                           |

---

## Available Integration Rules

| Expression Type | Integral                     |
| --------------- | ---------------------------- |
| `Literal(c)`    | `cx + C`                     |
| `Variable(x)`   | `x²/2 + C`                   |
| `Pow(x, n)`     | `x^(n+1)/(n+1) + C` (n ≠ -1) |
| `Sin(x)`        | `-cos(x) + C`                |
| `Cos(x)`        | `sin(x) + C`                 |
| `Exp(x)`        | `e^x + C`                    |
| `1/x`           | `ln(x) + C`                  |
| `Sec²(x)`       | `tan(x) + C`                 |
| `Csc²(x)`       | `-cot(x) + C`                |

---

## Related Tests

- [`test/calculus/symbolic_calculus_test.dart`](../../test/calculus/symbolic_calculus_test.dart)
- [`test/calculus/symbolic_differentiation_test.dart`](../../test/calculus/symbolic_differentiation_test.dart)
- [`test/calculus/symbolic_integration_test.dart`](../../test/calculus/symbolic_integration_test.dart)
- [`test/calculus/trig_integration_test.dart`](../../test/calculus/trig_integration_test.dart)

## Related Documentation

- [Expression](03_expression.md) - Symbolic expressions (base for calculus)
- [Nonlinear](07_nonlinear.md) - Root finding and optimization
- [Linear](06_linear.md) - Linear system solvers
