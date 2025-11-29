import 'package:advance_math/src/math/differential_equations/ode.dart';
import 'package:test/test.dart';
import 'dart:math' as math;

void main() {
  group('ODE Solvers', () {
    const double tol = 1e-2; // Relaxed tolerance for numerical methods

    test('Euler method solves exponential decay', () {
      // dy/dt = -y, y(0) = 1
      // Analytical solution: y(t) = e^(-t)
      num dydt(num t, num y) => -y;

      var result = ODE.euler(dydt, 1.0, 0, 2, steps: 100);

      expect(result.success, isTrue);
      expect(result.y.last, closeTo(math.exp(-2), tol));
    });

    test('RK4 method solves harmonic oscillator', () {
      // y'' + y = 0 => system: y1' = y2, y2' = -y1
      // y(0) = 1, y'(0) = 0
      // Analytical: y(t) = cos(t)
      List<num> dydt(num t, List<num> y) => [y[1], -y[0]];

      var result = ODE.rk4(dydt, [1.0, 0.0], 0, math.pi, steps: 100);

      expect(result.success, isTrue);
      // At t=π, y should be -1
      expect(result.y.last[0], closeTo(-1.0, 0.01));
    });

    test('RK45 adaptive method handles varying dynamics', () {
      // dy/dt = -y
      num dydt(num t, num y) => -y;

      var result = ODE.rk45(dydt, 1.0, 0, 2, tol: 1e-6);

      expect(result.success, isTrue);
      expect(result.y.last, closeTo(math.exp(-2), 1e-3));
      // Should use fewer steps than fixed-step methods
      expect(result.steps, lessThan(100));
    });

    test('Euler solves system of ODEs (Lotka-Volterra)', () {
      // Predator-prey model
      // dx/dt = ax - bxy
      // dy/dt = -cy + dxy
      double a = 1.0, b = 0.1, c = 1.5, d = 0.075;

      List<num> dydt(num t, List<num> y) {
        double x = y[0].toDouble(), yPrey = y[1].toDouble();
        return [
          a * x - b * x * yPrey,
          -c * yPrey + d * x * yPrey,
        ];
      }

      var result = ODE.euler(dydt, [10.0, 5.0], 0, 10, steps: 1000);

      expect(result.success, isTrue);
      expect(result.y.length, equals(1001));
      // Both populations should remain positive
      expect(result.y.last[0], greaterThan(0));
      expect(result.y.last[1], greaterThan(0));
    });

    test('RK4 solves system with high accuracy', () {
      // Simple coupled system
      // y1' = y2, y2' = -y1
      List<num> dydt(num t, List<num> y) => [y[1], -y[0]];

      var result = ODE.rk4(dydt, [0.0, 1.0], 0, math.pi / 2, steps: 50);

      expect(result.success, isTrue);
      // At t=π/2: y1 should be 1, y2 should be 0
      expect(result.y.last[0], closeTo(1.0, 0.01));
      expect(result.y.last[1], closeTo(0.0, 0.01));
    });

    test('Backward Euler handles stiff equation', () {
      // Stiff equation: dy/dt = -100y + 100
      // Solution: y(t) = 1 + (y0-1)e^(-100t)
      num dydt(num t, num y) => -100 * y + 100;

      var result = ODE.backwardEuler(dydt, 0.0, 0, 0.1, steps: 50);

      expect(result.success, isTrue);
      // Should approach 1
      expect(result.y.last, closeTo(1.0, 0.1));
    });
  });
}
