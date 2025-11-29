import 'package:advance_math/src/math/differential_equations/pde.dart';
import 'package:test/test.dart';
import 'dart:math' as math;

void main() {
  group('PDE Solvers', () {
    test('Heat equation with zero boundaries', () {
      // Initial condition: sin(πx)
      // Analytical solution: u(x,t) = sin(πx)e^(-π²αt)
      num alpha = 0.01;

      var result = PDE.heatEquation1D(
        alpha,
        [0, 1],
        [0, 0.1],
        (x) => math.sin(math.pi * x),
        0, // Left boundary
        0, // Right boundary
        nx: 21,
        nt: 100,
      );

      expect(result.success, isTrue);
      expect(result.solution.rowCount, equals(101));
      expect(result.solution.columnCount, equals(21));

      // Check boundaries are maintained
      for (int i = 0; i < result.solution.rowCount; i++) {
        expect(result.solution[i][0].toDouble(), closeTo(0, 1e-10));
        expect(result.solution[i][result.solution.columnCount - 1].toDouble(),
            closeTo(0, 1e-10));
      }

      // Solution should decay over time
      num initial = result.solution[0][10].toDouble();
      num final_ = result.solution.last[10].toDouble();
      expect(final_.abs(), lessThan(initial.abs()));
    });

    test('Wave equation propagation', () {
      // Initial displacement: Gaussian pulse
      // No initial velocity
      num c = 1.0;

      var result = PDE.waveEquation1D(
        c,
        [0, 1],
        [0, 0.5],
        (x) => math.exp(-100 * (x - 0.5) * (x - 0.5)), // Gaussian at center
        (x) => 0, // No initial velocity
        0, // Boundary
        0, // Boundary
        nx: 51,
        nt: 100,
      );

      expect(result.success, isTrue);

      // Check boundaries
      for (int i = 0; i < result.solution.rowCount; i++) {
        expect(result.solution[i][0].toDouble(), closeTo(0, 1e-10));
        expect(result.solution[i][result.solution.columnCount - 1].toDouble(),
            closeTo(0, 1e-10));
      }
    });

    test('Heat equation with larger time steps', () {
      // Use moderate parameters that are stable
      var result = PDE.heatEquation1D(
        0.1, // Moderate alpha
        [0, 1],
        [0, 0.1],
        (x) => math.sin(math.pi * x),
        0,
        0,
        nx: 20,
        nt: 50,
      );

      expect(result.success, isTrue);
    });
  });

  group('BVP Solvers', () {
    test('Shooting method solves simple BVP', () {
      // y'' + y = 0, y(0) = 0, y(π) = 0
      // Analytical: y = A*sin(x)
      num f(num x, num y, num yPrime) => -y;

      var result = BVP.shootingMethod(
        f,
        0,
        math.pi,
        0,
        0,
        initialSlope: 1,
        tol: 0.01,
      );

      expect(result.success, isTrue);
      // Solution should be sin-like, max at π/2
      int midIdx = result.t.length ~/ 2;
      expect(result.y[midIdx].abs(), greaterThan(0.5));
    });

    test('Finite difference solves linear BVP', () {
      // y'' = 0, y(0) = 0, y(1) = 1
      // Analytical: y = x
      var result = BVP.finiteDifference(
        (x) => 0, // p(x)
        (x) => 0, // q(x)
        (x) => 0, // r(x)
        0,
        1,
        0,
        1,
        n: 9,
      );

      expect(result.success, isTrue);

      // Check linear solution
      for (int i = 0; i < result.t.length; i++) {
        expect(result.y[i], closeTo(result.t[i], 0.01));
      }
    });

    test('Finite difference solves non-homogeneous BVP', () {
      // y'' = -2, y(0) = 0, y(1) = 0
      // Analytical: y = -x² + x
      var result = BVP.finiteDifference(
        (x) => 0,
        (x) => 0,
        (x) => -2,
        0,
        1,
        0,
        0,
        n: 19,
      );

      expect(result.success, isTrue);

      // Check parabolic solution at x=0.5
      int midIdx = result.t.length ~/ 2;
      num expected = -0.5 * 0.5 + 0.5; // Should be 0.25
      expect(result.y[midIdx], closeTo(expected, 0.01));
    });
  });
}
