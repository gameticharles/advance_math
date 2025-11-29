import 'package:advance_math/advance_math.dart';
import 'package:test/test.dart';

void main() {
  group('NonlinearSystems', () {
    const double tol = 1e-5;

    // System 1: Intersection of circle and line
    // x^2 + y^2 = 4
    // x - y = 0
    // Solution: (sqrt(2), sqrt(2)) and (-sqrt(2), -sqrt(2))
    // x = 1.41421356, y = 1.41421356
    List<Function> circleLine = [
      (List vars) => vars[0] * vars[0] + vars[1] * vars[1] - 4,
      (List vars) => vars[0] - vars[1],
    ];

    // Jacobian for System 1
    // [ 2x  2y ]
    // [ 1   -1 ]
    Matrix circleLineJacobian(List vars) {
      return Matrix.fromList([
        [2 * vars[0], 2 * vars[1]],
        [1, -1]
      ]);
    }

    // System 2: 3x3 Linear-like system (for verification)
    // x + y + z = 6
    // 2x + y - z = 1
    // x - y + z = 2
    // Solution: x=1, y=2, z=3
    List<Function> linearSys = [
      (List vars) => vars[0] + vars[1] + vars[2] - 6,
      (List vars) => 2 * vars[0] + vars[1] - vars[2] - 1,
      (List vars) => vars[0] - vars[1] + vars[2] - 2,
    ];

    test('Newton method solves 2x2 system with explicit Jacobian', () {
      var result = NonlinearSystems.newton(
        circleLine,
        [2, 1], // Guess near (sqrt(2), sqrt(2))
        jacobian: circleLineJacobian,
      );

      expect(result.converged, isTrue);
      expect((result.solution[0][0]).toDouble(), closeTo(sqrt(2), tol));
      expect((result.solution[1][0]).toDouble(), closeTo(sqrt(2), tol));
    });

    test('Newton method solves 2x2 system with numerical Jacobian', () {
      var result = NonlinearSystems.newton(
        circleLine,
        [-2, -1], // Guess near (-sqrt(2), -sqrt(2))
      );

      expect(result.converged, isTrue);
      expect((result.solution[0][0]).toDouble(), closeTo(-sqrt(2), tol));
      expect((result.solution[1][0]).toDouble(), closeTo(-sqrt(2), tol));
    });

    test('Newton method solves 3x3 system', () {
      var result = NonlinearSystems.newton(
        linearSys,
        [0, 0, 0],
      );

      expect(result.converged, isTrue);
      expect((result.solution[0][0]).toDouble(), closeTo(1, tol));
      expect((result.solution[1][0]).toDouble(), closeTo(2, tol));
      expect((result.solution[2][0]).toDouble(), closeTo(3, tol));
    });

    test('Broyden method solves 2x2 system', () {
      var result = NonlinearSystems.broyden(
        circleLine,
        [2, 1],
      );

      expect(result.converged, isTrue);
      expect((result.solution[0][0]).toDouble(), closeTo(sqrt(2), tol));
      expect((result.solution[1][0]).toDouble(), closeTo(sqrt(2), tol));
    });

    test('Fixed Point solves simple system', () {
      // x = cos(y)
      // y = sin(x)
      // Solution near (0.768, 0.694)
      List<Function> gFuncs = [
        (List vars) => cos(vars[1]),
        (List vars) => sin(vars[0]),
      ];

      var result = NonlinearSystems.fixedPoint(
        gFuncs,
        [0.5, 0.5],
      );

      expect(result.converged, isTrue);
      // Check consistency: x = cos(y), y = sin(x)
      double x = (result.solution[0][0]).toDouble();
      double y = (result.solution[1][0]).toDouble();
      expect(x, closeTo(cos(y), tol));
      expect(y, closeTo(sin(x), tol));
    });
  });
}
