# Nonlinear Mathematics

Root finding, optimization, and solving nonlinear systems of equations.

## Table of Contents

- [Root Finding](#root-finding)
- [Optimization](#optimization)
- [Nonlinear Systems](#nonlinear-systems)
- [Examples](#examples)

## Root Finding

Find zeros of single-variable functions.

### Bisection Method

```dart
import 'package:advance_math/src/math/algebra/nonlinear/root_finding.dart';

// Find root of f(x) = x² - 4
num f(num x) => x * x - 4;

var result = RootFinding.bisection(
  f,
  a: 0,           // Lower bound
  b: 3,           // Upper bound
  tolerance: 1e-6,
);

print('Root: ${result.root}');          // ≈ 2.0
print('Iterations: ${result.iterations}');
print('Success: ${result.success}');
```

### Newton-Raphson Method

```dart
// Find root of f(x) = x² - 4
// f'(x) = 2x
num f(num x) => x * x - 4;
num fPrime(num x) => 2 * x;

var result = RootFinding.newton(
  f,
  fPrime,
  x0: 1.0,        // Initial guess
  tolerance: 1e-10,
  maxIterations: 100,
);

print('Root: ${result.root}');          // ≈ 2.0
print('Iterations: ${result.iterations}');
```

### Secant Method

```dart
// Similar to Newton but doesn't require derivative
num f(num x) => x * x - 4;

var result = RootFinding.secant(
  f,
  x0: 1.0,
  x1: 3.0,
  tolerance: 1e-10,
);

print('Root: ${result.root}');
```

### Fixed-Point Iteration

```dart
// Find fixed point of g(x) where x = g(x)
// Example: g(x) = sqrt(4) to solve x² = 4
num g(num x) => sqrt(4);

var result = RootFinding.fixedPoint(
  g,
  x0: 1.0,
  tolerance: 1e-6,
);

print('Fixed point: ${result.root}');
```

### Brent's Method

Combines bisection, secant, and inverse quadratic interpolation:

```dart
num f(num x) => x * x * x - x - 2;  // Cubic equation

var result = RootFinding.brent(
  f,
  a: 1.0,
  b: 2.0,
  tolerance: 1e-12,
);

print('Root: ${result.root}');
```

## Optimization

Find minima and maxima of functions.

### Golden Section Search (1D)

```dart
import 'package:advance_math/src/math/algebra/nonlinear/optimization.dart';

// Minimize f(x) = (x-3)²
num f(num x) => (x - 3) * (x - 3);

var result = Optimization.goldenSection(
  f,
  a: 0,
  b: 10,
  tolerance: 1e-6,
);

print('Minimum at: ${result.x}');       // ≈ 3.0
print('Min value: ${result.value}');    // ≈ 0.0
```

### Gradient Descent

```dart
// Minimize f(x, y) = x² + y²
List<num> gradient(List<num> x) => [2*x[0], 2*x[1]];

var result = Optimization.gradientDescent(
  gradient: gradient,
  x0: [10.0, 10.0],
  learningRate: 0.1,
  tolerance: 1e-6,
  maxIterations: 1000,
);

print('Minimum at: ${result.x}');       // ≈ [0, 0]
print('Iterations: ${result.iterations}');
```

### Newton's Method for Optimization

```dart
// Minimize f(x, y) = x² + y²
// Gradient: ∇f = [2x, 2y]
// Hessian: H = [[2, 0], [0, 2]]

List<num> gradient(List<num> x) => [2*x[0], 2*x[1]];
List<List<num>> hessian(List<num> x) => [[2, 0], [0, 2]];

var result = Optimization.newton(
  gradient: gradient,
  hessian: hessian,
  x0: [5.0, 5.0],
  tolerance: 1e-8,
);

print('Minimum at: ${result.x}');
```

### Conjugate Gradient Method

```dart
List<num> gradient(List<num> x) {
  // Rosenbrock function gradient
  var g1 = -400*x[0]*(x[1] - x[0]*x[0]) - 2*(1 - x[0]);
  var g2 = 200*(x[1] - x[0]*x[0]);
  return [g1, g2];
}

var result = Optimization.conjugateGradient(
  gradient: gradient,
  x0: [-1.0, 1.0],
  tolerance: 1e-6,
);

print('Minimum at: ${result.x}');       // ≈ [1, 1]
```

### BFGS (Quasi-Newton Method)

```dart
// Broyden-Fletcher-Goldfarb-Shanno algorithm
List<num> gradient(List<num> x) => [2*x[0], 2*x[1]];

var result = Optimization.bfgs(
  gradient: gradient,
  x0: [10.0, 10.0],
  tolerance: 1e-8,
);

print('Minimum at: ${result.x}');
```

### Constrained Optimization

```dart
// Minimize f(x, y) subject to g(x, y) ≤ 0

num objective(List<num> x) => x[0]*x[0] + x[1]*x[1];
List<num Function(List<num>)> constraints = [
  (x) => x[0] + x[1] - 1,  // x + y ≤ 1
];

var result = Optimization.constrainedOptimization(
  objective: objective,
  constraints: constraints,
  x0: [0.5, 0.5],
);

print('Minimum at: ${result.x}');
```

## Nonlinear Systems

Solve systems of nonlinear equations.

### Newton's Method for Systems

```dart
import 'package:advance_math/src/math/algebra/nonlinear/systems.dart';

// Solve:
// x² + y² = 25
// x - y = 1

List<num> equations(List<num> vars) {
  var x = vars[0];
  var y = vars[1];
  return [
    x*x + y*y - 25,  // x² + y² - 25 = 0
    x - y - 1,       // x - y - 1 = 0
  ];
}

List<List<num>> jacobian(List<num> vars) {
  var x = vars[0];
  var y = vars[1];
  return [
    [2*x, 2*y],      // ∂f₁/∂x, ∂f₁/∂y
    [1, -1],         // ∂f₂/∂x, ∂f₂/∂y
  ];
}

var result = NonlinearSystems.newton(
  equations: equations,
  jacobian: jacobian,
  x0: [4.0, 3.0],
  tolerance: 1e-8,
);

print('Solution: ${result.x}');         // ≈ [4, 3] or [-3, -4]
print('Iterations: ${result.iterations}');
```

### Broyden's Method

Quasi-Newton method for systems (doesn't require Jacobian):

```dart
List<num> equations(List<num> vars) {
  var x = vars[0];
  var y = vars[1];
  return [
    x*x + y*y - 25,
    x - y - 1,
  ];
}

var result = NonlinearSystems.broyden(
  equations: equations,
  x0: [4.0, 3.0],
  tolerance: 1e-8,
);

print('Solution: ${result.x}');
```

### Fixed-Point Iteration for Systems

```dart
// Transform F(x) = 0 to x = G(x)
List<num> g(List<num> x) {
  return [
    sqrt(25 - x[1]*x[1]),  // x = sqrt(25 - y²)
    x[0] - 1,              // y = x - 1
  ];
}

var result = NonlinearSystems.fixedPoint(
  g: g,
  x0: [4.0, 3.0],
  tolerance: 1e-6,
);

print('Solution: ${result.x}');
```

## Result Structures

### Root Finding Result

```dart
class RootResult {
  final num root;
  final bool success;
  final int iterations;
  final num? error;
  final String? message;
}
```

### Optimization Result

```dart
class OptimizationResult {
  final List<num> x;          // Optimal point
  final num value;            // Optimal value
  final bool success;
  final int iterations;
  final num? gradientNorm;    // ||∇f(x)||
  final String? message;
}
```

### System Solution Result

```dart
class SystemResult {
  final List<num> x;          // Solution vector
  final bool success;
  final int iterations;
  final num? residualNorm;    // ||F(x)||
  final String? message;
}
```

## Examples

### Complete Root Finding Example

```dart
import 'package:advance_math/src/math/algebra/nonlinear/root_finding.dart';

void main() {
  // Find zeros of f(x) = e^x - 3x
  num f(num x) => exp(x) - 3*x;
  num fPrime(num x) => exp(x) - 3;

  // Multiple methods
  print('--- Bisection ---');
  var bisect = RootFinding.bisection(f, a: 0, b: 2, tolerance: 1e-6);
  print('Root: ${bisect.root}');

  print('\\n--- Newton-Raphson ---');
  var newton = RootFinding.newton(f, fPrime, x0: 1.0, tolerance: 1e-10);
  print('Root: ${newton.root}');
  print('Iterations: ${newton.iterations}');

  print('\\n--- Brent ---');
  var brent = RootFinding.brent(f, a: 0, b: 2, tolerance: 1e-12);
  print('Root: ${brent.root}');
  print('Iterations: ${brent.iterations}');
}
```

### Complete Optimization Example

```dart
import 'package:advance_math/src/math/algebra/nonlinear/optimization.dart';

void main() {
  // Minimize Rosenbrock function: f(x,y) = (1-x)² + 100(y-x²)²
  // Global minimum at (1, 1)

  List<num> gradient(List<num> x) {
    return [
      -2*(1 - x[0]) - 400*x[0]*(x[1] - x[0]*x[0]),
      200*(x[1] - x[0]*x[0])
    ];
  }

  print('--- Gradient Descent ---');
  var gd = Optimization.gradientDescent(
    gradient: gradient,
    x0: [0.0, 0.0],
    learningRate: 0.001,
    tolerance: 1e-6,
    maxIterations: 10000,
  );
  print('Minimum at: ${gd.x}');

  print('\\n--- BFGS ---');
  var bfgs = Optimization.bfgs(
    gradient: gradient,
    x0: [0.0, 0.0],
    tolerance: 1e-6,
  );
  print('Minimum at: ${bfgs.x}');
  print('Iterations: ${bfgs.iterations}');
}
```

## Related Tests

- [`test/nonlinear/root_finding_test.dart`](../test/nonlinear/root_finding_test.dart)
- [`test/nonlinear/optimization_test.dart`](../test/nonlinear/optimization_test.dart)
- [`test/nonlinear/systems_test.dart`](../test/nonlinear/systems_test.dart)

## Related Documentation

- [Calculus](calculus.md) - Symbolic and numerical differentiation
- [Differential Equations](differential_equations.md) - ODEs and PDEs
- [Algebra](algebra.md) - Linear systems and matrix operations
