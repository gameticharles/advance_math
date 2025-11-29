# Differential Equations

Solve ordinary differential equations (ODEs) and partial differential equations (PDEs) numerically.

## Table of Contents

- [Ordinary Differential Equations (ODEs)](#ordinary-differential-equations-odes)
- [Partial Differential Equations (PDEs)](#partial-differential-equations-pdes)
- [Examples](#examples)

## Ordinary Differential Equations (ODEs)

### Single ODEs

Solve first-order ODEs of the form `dy/dt = f(t, y)`.

#### Euler's Method

```dart
import 'package:advance_math/src/math/differential_equations/ode.dart';

// Solve: dy/dt = y, y(0) = 1
// Analytical solution: y = e^t

dynamic dydt(num t, dynamic y) => y;

var result = ODE.euler(dydt, 1.0, 0, 5, steps: 100);

print('Success: ${result.success}');
print('Steps: ${result.stepsTaken}');
print('Final time: ${result.t.last}');
print('Final value: ${result.y.last}');
print('Analytical at t=5: ${exp(5)}'); // ≈ 148.41
```

#### Runge-Kutta 4th Order (RK4)

More accurate than Euler's method:

```dart
// Solve: dy/dt = -2y, y(0) = 1
dynamic dydt(num t, dynamic y) => -2 * y;

var result = ODE.rk4(dydt, 1.0, 0, 5, steps: 50);

print('Final value: ${result.y.last}');
// Analytical: y = e^(-2t) = e^(-10) ≈ 0.0000454
```

### Systems of ODEs

Solve coupled ODEs:

```dart
// Lotka-Volterra (Predator-Prey) Model
// dx/dt = α*x - β*x*y  (prey)
// dy/dt = δ*x*y - γ*y  (predator)

dynamic lotkaVolterra(num t, dynamic state) {
  var x = state[0]; // prey population
  var y = state[1]; // predator population

  var alpha = 1.5;  // prey growth rate
  var beta = 1.0;   // predation rate
  var gamma = 1.0;  // predator death rate
  var delta = 0.75; // predator growth from prey

  return [
    alpha * x - beta * x * y,
    delta * x * y - gamma * y
  ];
}

// Initial conditions: 10 prey, 5 predators
var result = ODE.euler(lotkaVolterra, [10.0, 5.0], 0, 10, steps: 1000);

// Access results
for (int i = 0; i < result.t.length; i++) {
  var t = result.t[i];
  var xy = result.y[i];
  print('t=$t: prey=${xy[0]}, predators=${xy[1]}');
}
```

### Common ODE Examples

#### Exponential Growth/Decay

```dart
// dy/dt = k*y
dynamic exponential(num t, dynamic y, {num k = 1.0}) => k * y;

// Growth (k > 0)
var growth = ODE.rk4((t, y) => exponential(t, y, k: 0.5), 1.0, 0, 10, steps: 100);

// Decay (k < 0)
var decay = ODE.rk4((t, y) => exponential(t, y, k: -0.5), 1.0, 0, 10, steps: 100);
```

#### Logistic Growth

```dart
// dy/dt = r*y*(1 - y/K)
// r: growth rate, K: carrying capacity
dynamic logistic(num t, dynamic y) {
  var r = 0.5;
  var K = 100.0;
  return r * y * (1 - y / K);
}

var result = ODE.rk4(logistic, 5.0, 0, 50, steps: 500);
```

#### Harmonic Oscillator

```dart
// Second-order ODE: d²x/dt² + ω²x = 0
// Convert to system: dx/dt = v, dv/dt = -ω²x

dynamic harmonicOscillator(num t, dynamic state) {
  var x = state[0]; // position
  var v = state[1]; // velocity
  var omega = 2.0; // angular frequency

  return [
    v,                    // dx/dt = v
    -omega * omega * x    // dv/dt = -ω²x
  ];
}

// Initial: x=1, v=0
var result = ODE.rk4(harmonicOscillator, [1.0, 0.0], 0, 10, steps: 1000);
```

## Partial Differential Equations (PDEs)

### Heat Equation (1D)

Solve `∂u/∂t = α ∂²u/∂x²` using finite differences:

```dart
import 'package:advance_math/src/math/differential_equations/pde.dart';

// Initial condition: u(x, 0) = sin(πx)
num initialCondition(num x) => sin(pi * x);

// Boundary conditions: u(0, t) = u(1, t) = 0
num boundaryLeft(num t) => 0.0;
num boundaryRight(num t) => 0.0;

var result = PDE.heatEquation1D(
  initialCondition: initialCondition,
  boundaryLeft: boundaryLeft,
  boundaryRight: boundaryRight,
  alpha: 0.01,        // thermal diffusivity
  xSteps: 50,         // spatial discretization
  tSteps: 100,        // time steps
  L: 1.0,             // domain length
  T: 1.0,             // simulation time
);

// Access solution at specific time and position
print('u(0.5, 0.5): ${result.u[25][50]}');
```

### Wave Equation (1D)

Solve `∂²u/∂t² = c² ∂²u/∂x²`:

```dart
// Initial displacement: u(x, 0) = sin(πx)
num initialDisplacement(num x) => sin(pi * x);

// Initial velocity: ∂u/∂t(x, 0) = 0
num initialVelocity(num x) => 0.0;

var result = PDE.waveEquation1D(
  initialDisplacement: initialDisplacement,
  initialVelocity: initialVelocity,
  boundaryLeft: (t) => 0.0,
  boundaryRight: (t) => 0.0,
  c: 1.0,             // wave speed
  xSteps: 100,
  tSteps: 200,
  L: 1.0,
  T: 2.0,
);
```

### Laplace's Equation (2D)

Solve `∂²u/∂x² + ∂²u/∂y² = 0` for steady-state problems:

```dart
// Boundary conditions on a rectangle [0,1] × [0,1]
num boundaryTop(num x) => sin(pi * x);
num boundaryBottom(num x) => 0.0;
num boundaryLeft(num y) => 0.0;
num boundaryRight(num y) => 0.0;

var result = PDE.laplaceEquation2D(
  boundaryTop: boundaryTop,
  boundaryBottom: boundaryBottom,
  boundaryLeft: boundaryLeft,
  boundaryRight: boundaryRight,
  xSteps: 50,
  ySteps: 50,
  tolerance: 1e-6,    // convergence tolerance
  maxIterations: 10000,
);

// Access solution
print('u(0.5, 0.5): ${result.u[25][25]}');
```

## ODE Result Structure

```dart
class ODEResult {
  final bool success;
  final List<num> t;    // time points
  final List<dynamic> y; // solution values
  final int stepsTaken;
  final String? message;
}
```

- For single ODE: `y` is `List<num>`
- For systems: `y` is `List<List<num>>` where each inner list is `[y1, y2, ..., yn]`

## PDE Result Structure

```dart
class PDEResult {
  final bool success;
  final List<List<num>> u; // solution grid
  final List<num> x;       // spatial points
  final List<num> t;       // time points (for time-dependent)
  final String? message;
}
```

## Examples

### Complete ODE Example

```dart
import 'package:advance_math/src/math/differential_equations/ode.dart';

void main() {
  // SIR epidemic model
  // dS/dt = -β*S*I
  // dI/dt = β*S*I - γ*I
  // dR/dt = γ*I

  dynamic sir(num t, dynamic state) {
    var S = state[0]; // susceptible
    var I = state[1]; // infected
    var R = state[2]; // recovered

    var beta = 0.5;   // transmission rate
    var gamma = 0.1;  // recovery rate

    return [
      -beta * S * I,
      beta * S * I - gamma * I,
      gamma * I
    ];
  }

  // Initial: 990 susceptible, 10 infected, 0 recovered
  var result = ODE.rk4(sir, [990.0, 10.0, 0.0], 0, 100, steps: 1000);

  if (result.success) {
    print('Peak infected at t=${result.t[500]}: ${result.y[500][1]}');
  }
}
```

## Related Tests

- [`test/differential_equations/ode_test.dart`](../test/differential_equations/ode_test.dart)
- [`test/differential_equations/pde_test.dart`](../test/differential_equations/pde_test.dart)

## Related Documentation

- [Calculus](calculus.md) - Symbolic differentiation and integration
- [Nonlinear Mathematics](nonlinear.md) - Root finding and optimization
- [Statistics](statistics.md) - Statistical methods
