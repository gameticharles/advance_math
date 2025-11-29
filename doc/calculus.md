# Symbolic Calculus

The `advance_math` library provides comprehensive symbolic and numerical calculus capabilities for differentiation, integration, limit evaluation, and equation solving.

## Table of Contents

- [Symbolic Differentiation](#symbolic-differentiation)
- [Symbolic Integration](#symbolic-integration)
- [Equation Solving](#equation-solving)
- [Numerical Calculus](#numerical-calculus)
- [Hybrid Calculus](#hybrid-calculus)
- [Examples](#examples)

## Symbolic Differentiation

Compute derivatives symbolically with support for partial differentiation.

### Basic Differentiation

```dart
import 'package:advance_math/advance_math.dart';

void main() {
  var x = Variable('x');

  // Power rule: d/dx(x^3) = 3x^2
  var expr = Pow(x, Literal(3));
  var derivative = expr.differentiate(x);
  print(derivative); // 3 * (x^2)

  // Trigonometric: d/dx(sin(x)) = cos(x)
  var sinExpr = Sin(x);
  var sinDeriv = sinExpr.differentiate(x);
  print(sinDeriv); // cos(x)

  // Product rule: d/dx(x * sin(x))
  var product = Multiply(x, Sin(x));
  var productDeriv = product.differentiate(x);
  print(productDeriv); // sin(x) + x*cos(x)
}
```

### Partial Derivatives

```dart
var x = Variable('x');
var y = Variable('y');

// Define f(x,y) = x^2 * y^2
var f = Multiply(Pow(x, Literal(2)), Pow(y, Literal(2)));

// Partial derivative with respect to x: ∂f/∂x = 2xy^2
var dfdx = f.differentiate(x);
print(dfdx);

// Partial derivative with respect to y: ∂f/∂y = 2x^2y
var dfdy = f.differentiate(y);
print(dfdy);
```

### Supported Operations

- **Power Rule**: `x^n → n*x^(n-1)`
- **Product Rule**: `(u*v)' = u'*v + u*v'`
- **Quotient Rule**: `(u/v)' = (u'*v - u*v')/v^2`
- **Chain Rule**: Automatic for composite functions
- **Trigonometric**: `sin, cos, tan, sec, csc, cot`
- **Inverse Trig**: `asin, acos, atan`
- **Exponential**: `exp, ln, log`
- **Hyperbolic**: All hyperbolic functions

### Related Tests

- [`test/calculus/differentiation_test.dart`](../test/calculus/differentiation_test.dart)
- [`test/calculus/symbolic_differentiation_test.dart`](../test/calculus/symbolic_differentiation_test.dart)

---

## Symbolic Integration

Perform symbolic integration using various strategies.

### Basic Integration

```dart
import 'package:advance_math/advance_math.dart';
import 'package:advance_math/src/math/algebra/calculus/symbolic_integration.dart';

void main() {
  var x = Variable('x');

  // Power rule: ∫x^2 dx = x^3/3
  var expr = Pow(x, Literal(2));
  var integral = SymbolicIntegration.integrate(expr, x);
  print(integral);

  // Trigonometric: ∫sin(x) dx = -cos(x)
  var sinIntegral = SymbolicIntegration.integrate(Sin(x), x);
  print(sinIntegral);

  // Exponential: ∫e^x dx = e^x
  var expIntegral = SymbolicIntegration.integrate(Exp(x), x);
  print(expIntegral);
}
```

### Advanced Integration Strategies

The library supports multiple integration strategies:

1. **Power Rule Strategy**: `∫x^n dx = x^(n+1)/(n+1)` (n ≠ -1)
2. **Logarithmic Strategy**: `∫1/x dx = ln|x|`
3. **Basic Trig Strategy**: `sin, cos, sec², csc²`
4. **Exponential Strategy**: `e^x, a^x`
5. **Sum/Difference Strategy**: `∫(f+g) dx = ∫f dx + ∫g dx`
6. **Substitution Strategy**: Pattern matching for chain rule integration
7. **Integration by Parts**: ILATE heuristic

### Integration by Substitution

```dart
// ∫2x*sin(x²) dx (u-substitution with u = x²)
var x = Variable('x');
var expr = Multiply(
  Multiply(Literal(2), x),
  Sin(Pow(x, Literal(2)))
);
var result = SymbolicIntegration.integrate(expr, x);
// Result: -cos(x²)
```

### Integration by Parts

```dart
// ∫x*sin(x) dx using ILATE rule
var x = Variable('x');
var expr = Multiply(x, Sin(x));
var result = SymbolicIntegration.integrate(expr, x);
// Result: -x*cos(x) + sin(x)
```

### Definite Integration

```dart
import 'package:advance_math/src/math/algebra/calculus/symbolic_calculus.dart';

var x = Variable('x');
var expr = Pow(x, Literal(2));

// ∫₀³ x² dx = 9
var result = SymbolicCalculus.definiteIntegral(expr, 'x', 0, 3);
print(result); // 9.0
```

### Related Tests

- [`test/calculus/integration_test.dart`](../test/calculus/integration_test.dart)
- [`test/calculus/symbolic_integration_test.dart`](../test/calculus/symbolic_integration_test.dart)

---

## Equation Solving

Solve equations algebraically and numerically.

### Linear Equations

```dart
import 'package:advance_math/advance_math.dart';
import 'package:advance_math/src/math/algebra/solver/equation_solver.dart';

var x = Variable('x');

// Solve: 2x - 10 = 0
var eq = Subtract(Multiply(Literal(2), x), Literal(10));
var solutions = ExpressionSolver.solve(eq, x);
print(solutions); // [5]

// Solve: x + a + b = 0 (symbolic)
var a = Variable('a');
var b = Variable('b');
var eq2 = Add(Add(x, a), b);
var sol2 = ExpressionSolver.solve(eq2, x);
print(sol2); // [-b - a]
```

### Quadratic Equations

```dart
// Solve: x² - 2x + 1 = 0
var eq = Add(Add(Pow(x, Literal(2)), Multiply(Literal(-2), x)), Literal(1));
var solutions = ExpressionSolver.solve(eq, x);
print(solutions); // [1.0] (double root)

// Solve: x² - 9 = 0
var eq2 = Subtract(Pow(x, Literal(2)), Literal(9));
var sol2 = ExpressionSolver.solve(eq2, x);
print(sol2); // [3.0, -3.0]
```

### Factored Equations

```dart
// Solve: (x-1)(x-2) = 0
// The solver automatically handles factored forms
var eq = Multiply(
  Subtract(x, Literal(1)),
  Subtract(x, Literal(2))
);
var solutions = ExpressionSolver.solve(eq, x);
print(solutions); // [1, 2]
```

### Cubic and Higher-Order Polynomials

```dart
// Solve: x³ = 0
var eq = Pow(x, Literal(3));
var solutions = ExpressionSolver.solve(eq, x);
print(solutions); // [0]

// For higher-order polynomials, see Polynomial class
```

### Parser Integration

```dart
import 'package:advance_math/advance_math.dart';

var parser = ExpressionParser();

// Parse and solve in one step
var result = parser.parse('solve(x^2 - 5*x + 6, x)');
print(result); // [2.0, 3.0]

// Differentiation
var deriv = parser.parse('diff(x^3, x)');
print(deriv); // 3 * (x^2)

// Integration
var integ = parser.parse('integrate(sin(x), x)');
print(integ); // -cos(x)
```

### Related Tests

- [`test/solver/equation_solver_test.dart`](../test/solver/equation_solver_test.dart)
- [`test/parser_calculus_test.dart`](../test/parser_calculus_test.dart)

---

## Numerical Calculus

Compute derivatives and integrals numerically.

### Numerical Differentiation

```dart
import 'package:advance_math/src/math/algebra/calculus/differentiation.dart';

// First derivative using central difference
num f(num x) => x * x * x; // f(x) = x³
var deriv = NumericalDifferentiation.derivative(f, 2.0);
print(deriv); // ≈ 12.0 (exact: 3*4 = 12)

// Gradient for multivariable functions
num g(List<num> coords) => coords[0]*coords[0] + coords[1]*coords[1];
var grad = NumericalDifferentiation.gradient(g, [1.0, 2.0]);
print(grad); // ≈ [2.0, 4.0]

// Curl for vector fields
List<num Function(List<num>)> vectorField = [
  (coords) => coords[1], // F₁ = y
  (coords) => -coords[0], // F₂ = -x
  (coords) => 0.0, // F₃ = 0
];
var curl = NumericalDifferentiation.curl(vectorField, [1, 1, 0]);
print(curl); // ≈ [0, 0, -2] (rotation around z-axis)
```

### Numerical Integration

```dart
import 'package:advance_math/src/math/algebra/calculus/integration.dart';

num f(num x) => x * x; // f(x) = x²

// Simpson's rule
var simpson = Integration.simpson(f, 0, 3, intervals: 100);
print(simpson); // ≈ 9.0

// Trapezoidal rule
var trap = Integration.trapezoidal(f, 0, 3, intervals: 100);
print(trap); // ≈ 9.0

// Romberg integration (adaptive)
var romberg = Integration.romberg(f, 0, 3);
print(romberg); // ≈ 9.0
```

### Related Tests

- [`test/calculus/differentiation_test.dart`](../test/calculus/differentiation_test.dart)
- [`test/calculus/integration_test.dart`](../test/calculus/integration_test.dart)

---

## Hybrid Calculus

Validate symbolic results against numerical methods.

```dart
import 'package:advance_math/src/math/algebra/calculus/hybrid_calculus.dart';

var x = Variable('x');
var expr = Pow(x, Literal(3)); // x³

// Compare symbolic and numerical derivatives
var comparison = HybridCalculus.compareResults(expr, 'x', 2.0, a: 0, b: 2);

print('Derivative Comparison:');
print('  Symbolic: ${comparison['derivative']['symbolic']}');
print('  Numerical: ${comparison['derivative']['numerical']}');
print('  Error: ${comparison['derivative']['error']}');

print('Integral Comparison:');
print('  Symbolic: ${comparison['integral']['symbolic']}');
print('  Numerical: ${comparison['integral']['numerical']}');
print('  Error: ${comparison['integral']['error']}');
```

### Related Tests

- [`test/calculus/hybrid_validation_test.dart`](../test/calculus/hybrid_validation_test.dart)

---

## Examples

### Complete Example

See [`example/symbolic_calculus_example.dart`](../example/symbolic_calculus_example.dart) for a comprehensive demonstration.

```dart
import 'package:advance_math/advance_math.dart';
import 'package:advance_math/src/math/algebra/calculus/symbolic_calculus.dart';

void main() {
  var x = Variable('x');

  // Differentiation
  var expr = Sin(x) * x;
  var deriv = SymbolicCalculus.partialDerivative(expr, 'x');
  print('d/dx(x*sin(x)): $deriv'); // sin(x) + x*cos(x)

  // Taylor Series
  var taylor = SymbolicCalculus.taylorSeries(Sin(x), 'x', 0, 5);
  print('Taylor series of sin(x): $taylor');

  // Limits
  var limitExpr = Sin(x) / x;
  var limit = SymbolicCalculus.limit(limitExpr, 'x', 0);
  print('lim(x→0) sin(x)/x: $limit'); // 1.0

  // Definite integral
  var integral = SymbolicCalculus.definiteIntegral(
    Pow(x, Literal(2)), 'x', 0, 3
  );
  print('∫₀³ x² dx: $integral'); // 9.0
}
```

## Related Documentation

- [Differential Equations](differential_equations.md)
- [Nonlinear Mathematics](nonlinear.md)
- [Algebra](algebra.md)
- [Expression System](enhanced_expression_creation.md)
