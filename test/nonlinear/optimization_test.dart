import 'package:advance_math/advance_math.dart';
import 'package:test/test.dart';

void main() {
  group('Optimization', () {
    const double tol = 1e-3; // Relaxed tolerance for optimization

    // Test function 1: Simple quadratic (x-3)^2 + (y-2)^2
    // Minimum at (3, 2) with value 0
    num quadratic(List<num> x) {
      return (x[0] - 3) * (x[0] - 3) + (x[1] - 2) * (x[1] - 2);
    }

    List<num> quadraticGradient(List<num> x) {
      return [
        2 * (x[0] - 3),
        2 * (x[1] - 2),
      ];
    }

    // Test function 2: Rosenbrock function
    // f(x,y) = (1-x)^2 + 100(y-x^2)^2
    // Minimum at (1, 1) with value 0
    num rosenbrock(List<num> x) {
      return (1 - x[0]) * (1 - x[0]) +
          100 * (x[1] - x[0] * x[0]) * (x[1] - x[0] * x[0]);
    }

    List<num> rosenbrockGradient(List<num> x) {
      return [
        -2 * (1 - x[0]) - 400 * x[0] * (x[1] - x[0] * x[0]),
        200 * (x[1] - x[0] * x[0]),
      ];
    }

    test('Gradient Descent minimizes quadratic function', () {
      var result = Optimization.gradientDescent(
        quadratic,
        quadraticGradient,
        [0.0, 0.0],
        learningRate: 0.1,
        maxIter: 5000,
      );

      expect(result.converged, isTrue);
      expect(result.solution[0][0].toDouble(), closeTo(3.0, tol));
      expect(result.solution[1][0].toDouble(), closeTo(2.0, tol));
      expect(result.value, closeTo(0.0, tol));
    });

    test('Conjugate Gradient minimizes quadratic function', () {
      var result = Optimization.conjugateGradient(
        quadratic,
        quadraticGradient,
        [0.0, 0.0],
        maxIter: 100,
      );

      expect(result.converged, isTrue);
      expect(result.solution[0][0].toDouble(), closeTo(3.0, tol));
      expect(result.solution[1][0].toDouble(), closeTo(2.0, tol));
    });

    test('BFGS minimizes quadratic function', () {
      var result = Optimization.bfgs(
        quadratic,
        quadraticGradient,
        [0.0, 0.0],
        maxIter: 100,
      );

      expect(result.converged, isTrue);
      expect(result.solution[0][0].toDouble(), closeTo(3.0, tol));
      expect(result.solution[1][0].toDouble(), closeTo(2.0, tol));
    });

    test('BFGS minimizes Rosenbrock function', () {
      var result = Optimization.bfgs(
        rosenbrock,
        rosenbrockGradient,
        [0.0, 0.0],
        maxIter: 1000,
        tolerance: 1e-4,
      );

      // Rosenbrock is harder - check we get close
      expect(result.solution[0][0].toDouble(), closeTo(1.0, 0.1));
      expect(result.solution[1][0].toDouble(), closeTo(1.0, 0.1));
    });

    test('Nelder-Mead minimizes quadratic function (derivative-free)', () {
      var result = Optimization.nelderMead(
        quadratic,
        [0.0, 0.0],
        maxIter: 1000,
      );

      expect(result.converged, isTrue);
      expect(result.solution[0][0].toDouble(), closeTo(3.0, tol));
      expect(result.solution[1][0].toDouble(), closeTo(2.0, tol));
    });

    test('Penalty Method handles constraints', () {
      // Minimize (x-5)^2 + (y-5)^2 subject to x + y <= 8
      num objective(List<num> x) {
        return (x[0] - 5) * (x[0] - 5) + (x[1] - 5) * (x[1] - 5);
      }

      // Constraint: x + y - 8 <= 0, violation = max(0, x + y - 8)
      num constraint(List<num> x) {
        double violation = x[0] + x[1] - 8;
        return violation > 0 ? violation : 0;
      }

      var result = Optimization.penaltyMethod(
        objective,
        [constraint],
        [0.0, 0.0],
        penalty: 100.0,
        maxIter: 1000,
      );

      // Should find point near (4, 4) on the constraint boundary
      double sum =
          result.solution[0][0].toDouble() + result.solution[1][0].toDouble();
      expect(sum,
          lessThanOrEqualTo(8.0 + 0.02)); // Slight tolerance for penalty method
      // Should be close to (4, 4)
      expect(result.solution[0][0].toDouble(), closeTo(4.0, 0.5));
      expect(result.solution[1][0].toDouble(), closeTo(4.0, 0.5));
    });
  });
}
