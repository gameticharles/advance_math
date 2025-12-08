# Nonlinear Module

Root finding and optimization for nonlinear equations and functions.

---

## Table of Contents

1. [Root Finding](#root-finding)
2. [Optimization](#optimization)
3. [Nonlinear Systems](#nonlinear-systems)

---

## Root Finding

Find roots of f(x) = 0 using various algorithms.

### Bisection Method

Bracketing method that requires f(a) and f(b) have opposite signs:

```dart
import 'package:advance_math/advance_math.dart';

double f(double x) => x * x - 4;  // Root at x = ±2

var root = RootFinding.bisection(
  f,
  0, 3,  // Interval [0, 3]
  tolerance: 1e-6,
  maxIter: 100
);

print(root);  // 2.0
```

### False Position (Regula Falsi)

Uses linear interpolation instead of midpoint:

```dart
var root = RootFinding.falsePosition(
  f,
  0, 3,
  tolerance: 1e-6,
  maxIter: 100
);

print(root);  // 2.0
```

### Brent's Method

Combines bisection, secant, and inverse quadratic interpolation. Generally the preferred bracketing method:

```dart
var root = RootFinding.brent(
  f,
  0, 3,
  tolerance: 1e-6,
  maxIter: 100
);

print(root);  // 2.0
```

### Newton-Raphson Method

Requires the derivative. Converges quadratically near roots:

```dart
double f(double x) => x * x - 4;
double df(double x) => 2 * x;  // Derivative

var root = RootFinding.newtonRaphson(
  f,
  df,
  3,  // Initial guess
  tolerance: 1e-6,
  maxIter: 100
);

print(root);  // 2.0
```

### Secant Method

Approximates derivative using two points:

```dart
var root = RootFinding.secant(
  f,
  2.5, 3.0,  // Two initial guesses
  tolerance: 1e-6,
  maxIter: 100
);

print(root);  // 2.0
```

### Fixed Point Iteration

Find x such that g(x) = x:

```dart
double g(double x) => (x + 4 / x) / 2;  // Fixed point at x = 2

var fixedPoint = RootFinding.fixedPoint(
  g,
  3.0,  // Initial guess
  tolerance: 1e-6,
  maxIter: 100
);

print(fixedPoint);  // 2.0
```

### Muller's Method

Can find complex roots. Uses three initial guesses:

```dart
var root = RootFinding.muller(
  f,
  1.0, 2.0, 3.0,  // Three initial guesses
  tolerance: 1e-6,
  maxIter: 100
);

print(root);  // May return Complex if root is complex
```

---

## Method Comparison

| Method         | Convergence      | Requirements            |
| -------------- | ---------------- | ----------------------- |
| Bisection      | Linear (slow)    | Sign change in interval |
| False Position | Superlinear      | Sign change in interval |
| Brent          | Superlinear      | Sign change in interval |
| Newton-Raphson | Quadratic (fast) | Derivative required     |
| Secant         | Superlinear      | Two initial guesses     |
| Fixed Point    | Linear           | Convergent g(x)         |
| Muller         | Quadratic        | Three initial guesses   |

---

## Optimization

Find minima of functions f(x₁, x₂, ..., xₙ).

### Gradient Descent

First-order method using gradient:

```dart
// Minimize f(x, y) = x² + y²
double f(List<num> x) => x[0] * x[0] + x[1] * x[1];

// Gradient: ∇f = [2x, 2y]
List<num> gradient(List<num> x) => [2 * x[0], 2 * x[1]];

var result = Optimization.gradientDescent(
  f,
  gradient,
  [5.0, 3.0],  // Initial guess
  learningRate: 0.1,
  maxIter: 1000,
  tolerance: 1e-6
);

print('Minimum at: ${result.solution}');  // [0, 0]
print('Value: ${result.value}');          // 0
print('Iterations: ${result.iterations}');
```

### Conjugate Gradient (Fletcher-Reeves)

Faster convergence for quadratic functions:

```dart
var result = Optimization.conjugateGradient(
  f,
  gradient,
  [5.0, 3.0],
  maxIter: 1000,
  tolerance: 1e-6
);

print('Minimum at: ${result.solution}');
```

### BFGS (Quasi-Newton)

Approximates Hessian for Newton-like convergence:

```dart
var result = Optimization.bfgs(
  f,
  gradient,
  [5.0, 3.0],
  maxIter: 1000,
  tolerance: 1e-6
);

print('Minimum at: ${result.solution}');
```

### Nelder-Mead (Simplex)

Derivative-free optimization:

```dart
var result = Optimization.nelderMead(
  f,
  [5.0, 3.0],  // Initial guess
  maxIter: 1000,
  tolerance: 1e-6
);

print('Minimum at: ${result.solution}');
```

### Constrained Optimization (Penalty Method)

Minimize f(x) subject to constraints:

```dart
double f(List<num> x) => x[0] * x[0] + x[1] * x[1];

// Constraint: x + y >= 1 (return 0 when satisfied, positive when violated)
List<Function> constraints = [
  (List<num> x) => max(0, 1 - x[0] - x[1])  // Inequality constraint
];

var result = Optimization.penaltyMethod(
  f,
  constraints,
  [0.0, 0.0],  // Initial guess
  penalty: 10.0,
  maxIter: 1000,
  tolerance: 1e-6
);

print('Minimum at: ${result.solution}');  // [0.5, 0.5]
```

---

## OptimizationResult

```dart
class OptimizationResult {
  final List<num> solution;   // Optimal point
  final double value;         // f(solution)
  final int iterations;       // Iterations used
  final bool converged;       // Whether algorithm converged
}
```

---

## Nonlinear Systems

Solve systems of nonlinear equations.

### Newton's Method for Systems

```dart
// System:
// f₁(x, y) = x² + y² - 4 = 0
// f₂(x, y) = x - y = 0

List<double> F(List<double> v) {
  double x = v[0], y = v[1];
  return [
    x * x + y * y - 4,
    x - y
  ];
}

// Jacobian matrix
List<List<double>> J(List<double> v) {
  double x = v[0], y = v[1];
  return [
    [2 * x, 2 * y],  // ∂f₁/∂x, ∂f₁/∂y
    [1, -1]          // ∂f₂/∂x, ∂f₂/∂y
  ];
}

var solution = NonlinearSystems.newton(
  F, J,
  [1.0, 1.0],  // Initial guess
  tolerance: 1e-6,
  maxIter: 100
);

print(solution);  // [√2, √2] ≈ [1.414, 1.414]
```

### Broyden's Method

Quasi-Newton for systems (approximates Jacobian):

```dart
var solution = NonlinearSystems.broyden(
  F,
  [1.0, 1.0],
  tolerance: 1e-6,
  maxIter: 100
);

print(solution);
```

---

## Optimization Method Comparison

| Method             | Derivatives | Convergence | Memory | Best For         |
| ------------------ | ----------- | ----------- | ------ | ---------------- |
| Gradient Descent   | First-order | Linear      | O(n)   | General          |
| Conjugate Gradient | First-order | Superlinear | O(n)   | Quadratic        |
| BFGS               | First-order | Superlinear | O(n²)  | General          |
| Nelder-Mead        | None        | Linear      | O(n²)  | Noisy/non-smooth |
| Penalty Method     | Any         | Varies      | Varies | Constrained      |

---

## Tips

1. **Initial guess matters**: Good initial guesses lead to faster convergence
2. **Check convergence**: Always verify `result.converged == true`
3. **Scaling**: Scale variables to similar magnitudes for better conditioning
4. **Derivatives**: If possible, provide analytical derivatives for faster, more accurate results

## Related Tests

- [`test/nonlinear/root_finding_test.dart`](../test/nonlinear/root_finding_test.dart)
- [`test/nonlinear/optimization_test.dart`](../test/nonlinear/optimization_test.dart)
- [`test/nonlinear/systems_test.dart`](../test/nonlinear/systems_test.dart)

## Related Documentation

- [Calculus](02_calculus.md) - Symbolic and numerical differentiation
- [Differential Equations](differential_equations.md) - ODEs and PDEs
- [Algebra](algebra.md) - Linear systems and matrix operations
