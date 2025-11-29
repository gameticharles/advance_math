import 'package:advance_math/advance_math.dart';
import 'package:test/test.dart';
import 'package:advance_math/src/math/algebra/calculus/differentiation.dart';

void main() {
  group('Numerical Differentiation Tests', () {
    // Tolerance for numerical comparisons
    const double tol = 1e-4;
    const double relaxedTol = 1e-3;

    group('Central Difference', () {
      test('differentiates x^2 at x=3', () {
        num f(num x) => x * x;
        final result = NumericalDifferentiation.derivative(f, 3);
        expect(result, closeTo(6.0, tol)); // d/dx(x²) = 2x = 6
      });

      test('differentiates sin(x) at x=0', () {
        num f(num x) => sin(x);
        final result = NumericalDifferentiation.derivative(f, 0);
        expect(result, closeTo(1.0, tol)); // d/dx(sin) = cos, cos(0) = 1
      });

      test('differentiates e^x at x=1', () {
        num f(num x) => exp(x);
        final result = NumericalDifferentiation.derivative(f, 1);
        expect(result, closeTo(e, tol)); // d/dx(e^x) = e^x
      });

      test('differentiates x^3 at various points', () {
        num f(num x) => x * x * x;

        expect(NumericalDifferentiation.derivative(f, 0), closeTo(0.0, tol));
        expect(NumericalDifferentiation.derivative(f, 1), closeTo(3.0, tol));
        expect(NumericalDifferentiation.derivative(f, 2), closeTo(12.0, tol));
        expect(NumericalDifferentiation.derivative(f, -1), closeTo(3.0, tol));
      });
    });

    group('Forward Difference', () {
      test('approximates derivative of x^2', () {
        num f(num x) => x * x;
        final result = NumericalDifferentiation.forwardDifference(f, 2);
        expect(result, closeTo(4.0, tol));
      });

      test('works at boundaries', () {
        num f(num x) => x * x * x;
        final result = NumericalDifferentiation.forwardDifference(f, 0);
        expect(result, closeTo(0.0, tol));
      });
    });

    group('Backward Difference', () {
      test('approximates derivative of x^2', () {
        num f(num x) => x * x;
        final result = NumericalDifferentiation.backwardDifference(f, 2);
        expect(result, closeTo(4.0, tol));
      });

      test('works at boundaries', () {
        num f(num x) => exp(x);
        final result = NumericalDifferentiation.backwardDifference(f, 0);
        expect(result, closeTo(1.0, tol));
      });
    });

    group('Second Derivative', () {
      test('computes second derivative of x^3', () {
        num f(num x) => x * x * x;
        final result = NumericalDifferentiation.secondDerivative(f, 2);
        expect(result, closeTo(12.0, tol)); // d²/dx²(x³) = 6x = 12
      });

      test('computes second derivative of sin(x)', () {
        num f(num x) => sin(x);
        final result = NumericalDifferentiation.secondDerivative(f, pi / 2);
        expect(result, closeTo(-1.0, tol)); // d²/dx²(sin) = -sin
      });

      test('computes second derivative of e^x', () {
        num f(num x) => exp(x);
        final result = NumericalDifferentiation.secondDerivative(f, 1);
        expect(result, closeTo(e, tol)); // d²/dx²(e^x) = e^x
      });
    });

    group('nth Derivative', () {
      test('computes 3rd derivative of x^4', () {
        num f(num x) => x * x * x * x;
        final result = NumericalDifferentiation.nthDerivative(f, 1, 3);
        expect(result,
            closeTo(24.0, 1.0)); // Relaxed tolerance for recursive derivatives
      });

      test('throws error for non-positive n', () {
        num f(num x) => x;
        expect(() => NumericalDifferentiation.nthDerivative(f, 1, 0),
            throwsArgumentError);
        expect(() => NumericalDifferentiation.nthDerivative(f, 1, -1),
            throwsArgumentError);
      });

      test('n=1 equals first derivative', () {
        num f(num x) => x * x;
        final nthDeriv = NumericalDifferentiation.nthDerivative(f, 3, 1);
        final firstDeriv = NumericalDifferentiation.derivative(f, 3);
        expect(nthDeriv, closeTo(firstDeriv, 1e-8));
      });

      test('n=2 equals second derivative', () {
        num f(num x) => x * x * x;
        final nthDeriv = NumericalDifferentiation.nthDerivative(f, 2, 2);
        final secondDeriv = NumericalDifferentiation.secondDerivative(f, 2);
        expect(nthDeriv, closeTo(secondDeriv, 1e-6));
      });
    });

    group('Gradient', () {
      test('computes gradient of x² + y²', () {
        num f(List<num> coords) {
          final x = coords[0];
          final y = coords[1];
          return x * x + y * y;
        }

        final grad = NumericalDifferentiation.gradient(f, [1, 2]);
        expect(grad[0], closeTo(2.0, tol)); // ∂/∂x = 2x = 2
        expect(grad[1], closeTo(4.0, tol)); // ∂/∂y = 2y = 4
      });

      test('computes gradient of x*y*z', () {
        num f(List<num> coords) {
          final x = coords[0];
          final y = coords[1];
          final z = coords[2];
          return x * y * z;
        }

        final grad = NumericalDifferentiation.gradient(f, [2, 3, 4]);
        expect(grad[0], closeTo(12.0, tol)); // ∂/∂x = y*z = 12
        expect(grad[1], closeTo(8.0, tol)); // ∂/∂y = x*z = 8
        expect(grad[2], closeTo(6.0, tol)); // ∂/∂z = x*y = 6
      });

      test('gradient at minimum is zero', () {
        num f(List<num> coords) {
          final x = coords[0];
          final y = coords[1];
          return x * x + y * y;
        }

        final grad = NumericalDifferentiation.gradient(f, [0, 0]);
        expect(grad[0], closeTo(0.0, tol));
        expect(grad[1], closeTo(0.0, tol));
      });
    });

    group('Jacobian', () {
      test('computes Jacobian of linear transformation', () {
        // f1(x,y) = 2x + y, f2(x,y) = x - 3y
        List<num Function(List<num>)> functions = [
          (coords) => 2 * coords[0] + coords[1],
          (coords) => coords[0] - 3 * coords[1],
        ];

        final J = NumericalDifferentiation.jacobian(functions, [1, 1]);

        expect(J[0][0], closeTo(2.0, tol));
        expect(J[0][1], closeTo(1.0, tol));
        expect(J[1][0], closeTo(1.0, tol));
        expect(J[1][1], closeTo(-3.0, tol));
      });

      test('computes Jacobian of nonlinear functions', () {
        // f1(x,y) = x², f2(x,y) = xy
        List<num Function(List<num>)> functions = [
          (coords) => coords[0] * coords[0],
          (coords) => coords[0] * coords[1],
        ];

        final J = NumericalDifferentiation.jacobian(functions, [2, 3]);

        expect(J[0][0], closeTo(4.0, tol)); // ∂(x²)/∂x = 2x = 4
        expect(J[0][1], closeTo(0.0, tol)); // ∂(x²)/∂y = 0
        expect(J[1][0], closeTo(3.0, tol)); // ∂(xy)/∂x = y = 3
        expect(J[1][1], closeTo(2.0, tol)); // ∂(xy)/∂y = x = 2
      });
    });

    group('Hessian', () {
      test('computes Hessian of x² + y²', () {
        num f(List<num> coords) {
          final x = coords[0];
          final y = coords[1];
          return x * x + y * y;
        }

        final H = NumericalDifferentiation.hessian(f, [1, 1]);

        expect(H[0][0], closeTo(2.0, tol)); // ∂²f/∂x² = 2
        expect(H[1][1], closeTo(2.0, tol)); // ∂²f/∂y² = 2
        expect(H[0][1], closeTo(0.0, tol)); // ∂²f/∂x∂y = 0
        expect(H[1][0], closeTo(0.0, tol)); // ∂²f/∂y∂x = 0
      });

      test('computes Hessian of x² + xy + y²', () {
        num f(List<num> coords) {
          final x = coords[0];
          final y = coords[1];
          return x * x + x * y + y * y;
        }

        final H = NumericalDifferentiation.hessian(f, [1, 1]);

        expect(H[0][0], closeTo(2.0, tol)); // ∂²f/∂x² = 2
        expect(H[1][1], closeTo(2.0, tol)); // ∂²f/∂y² = 2
        expect(H[0][1], closeTo(1.0, tol)); // ∂²f/∂x∂y = 1
        expect(H[1][0], closeTo(1.0, tol)); // ∂²f/∂y∂x = 1 (symmetry)
      });

      test('Hessian is symmetric', () {
        num f(List<num> coords) {
          final x = coords[0];
          final y = coords[1];
          return x * x * y + y * y * y;
        }

        final H = NumericalDifferentiation.hessian(f, [2, 3]);

        expect(H[0][1], closeTo(H[1][0], tol)); // Symmetry
      });
    });

    group('Directional Derivative', () {
      test('computes in x-direction', () {
        num f(List<num> coords) {
          final x = coords[0];
          final y = coords[1];
          return x * x + y * y;
        }

        final dd =
            NumericalDifferentiation.directionalDerivative(f, [1, 1], [1, 0]);
        expect(dd, closeTo(2.0, tol)); // ∂f/∂x at (1,1) = 2
      });

      test('computes in arbitrary direction', () {
        num f(List<num> coords) {
          final x = coords[0];
          final y = coords[1];
          return x * x + y * y;
        }

        // Direction at 45 degrees
        final dd =
            NumericalDifferentiation.directionalDerivative(f, [1, 1], [1, 1]);
        // Gradient is (2, 2), direction normalized is (1/√2, 1/√2)
        // dd = (2, 2) · (1/√2, 1/√2) = 4/√2 = 2√2
        expect(dd, closeTo(2 * sqrt(2), tol));
      });

      test('throws error for zero direction', () {
        num f(List<num> coords) => coords[0];
        expect(
            () => NumericalDifferentiation.directionalDerivative(
                f, [1, 1], [0, 0]),
            throwsArgumentError);
      });

      test('throws error for mismatched dimensions', () {
        num f(List<num> coords) => coords[0];
        expect(
            () => NumericalDifferentiation.directionalDerivative(
                f, [1, 1], [1, 0, 0]),
            throwsArgumentError);
      });
    });

    group('Derivative with Error Estimation', () {
      test('provides error estimate for smooth functions', () {
        num f(num x) => sin(x);
        final result = NumericalDifferentiation.derivativeWithError(f, 0);

        expect(result['value'], closeTo(1.0, tol));
        expect(result['error'], lessThan(1e-6));
      });

      test('returns both value and error', () {
        num f(num x) => x * x;
        final result = NumericalDifferentiation.derivativeWithError(f, 3);

        expect(result.containsKey('value'), isTrue);
        expect(result.containsKey('error'), isTrue);
        expect(result['value'], isA<num>());
        expect(result['error'], isA<num>());
      });
    });

    group('Laplacian', () {
      test('computes Laplacian of x² + y²', () {
        num f(List<num> coords) {
          final x = coords[0];
          final y = coords[1];
          return x * x + y * y;
        }

        final lapl = NumericalDifferentiation.laplacian(f, [1, 1]);
        expect(lapl, closeTo(4.0, tol)); // ∇²(x²+y²) = 2 + 2 = 4
      });

      test('computes Laplacian of x² + y² + z²', () {
        num f(List<num> coords) {
          final x = coords[0];
          final y = coords[1];
          final z = coords[2];
          return x * x + y * y + z * z;
        }

        final lapl = NumericalDifferentiation.laplacian(f, [1, 1, 1]);
        expect(lapl, closeTo(6.0, tol)); // ∇²(x²+y²+z²) = 2 + 2 + 2 = 6
      });

      test('Laplacian of harmonic function is zero', () {
        // ln(r) is harmonic in 2D (except at origin)
        num f(List<num> coords) {
          final x = coords[0];
          final y = coords[1];
          final r = sqrt(x * x + y * y);
          return log(r);
        }

        final lapl = NumericalDifferentiation.laplacian(f, [1, 1]);
        expect(lapl, closeTo(0.0, relaxedTol));
      });
    });

    group('Divergence', () {
      test('computes divergence of (x, y)', () {
        List<num Function(List<num>)> F = [
          (coords) => coords[0],
          (coords) => coords[1],
        ];

        final div = NumericalDifferentiation.divergence(F, [1, 1]);
        expect(div, closeTo(2.0, tol)); // div(x, y) = 1 + 1 = 2
      });

      test('computes divergence of (x², xy, z)', () {
        List<num Function(List<num>)> F = [
          (coords) => coords[0] * coords[0],
          (coords) => coords[0] * coords[1],
          (coords) => coords[2],
        ];

        final div = NumericalDifferentiation.divergence(F, [2, 3, 4]);
        // div = ∂(x²)/∂x + ∂(xy)/∂y + ∂z/∂z = 2x + x + 1 = 2*2 + 2 + 1 = 7
        expect(div, closeTo(7.0, tol));
      });

      test('throws error for mismatched dimensions', () {
        List<num Function(List<num>)> F = [
          (coords) => coords[0],
        ];

        expect(() => NumericalDifferentiation.divergence(F, [1, 1]),
            throwsArgumentError);
      });
    });

    group('Curl', () {
      test('computes curl of rotation field', () {
        // F = (−y, x, 0) - rotation around z-axis
        List<num Function(List<num>)> F = [
          (coords) => -coords[1],
          (coords) => coords[0],
          (coords) => 0,
        ];

        final curl = NumericalDifferentiation.curl(F, [1, 0, 0]);
        expect(curl[0], closeTo(0.0, tol));
        expect(curl[1], closeTo(0.0, tol));
        expect(
            curl[2], closeTo(2.0, tol)); // curl_z = ∂x/∂x - ∂(-y)/∂y = 1+1 = 2
      });

      test('curl of gradient field is zero', () {
        // F = ∇(x² + y² + z²) = (2x, 2y, 2z)
        List<num Function(List<num>)> F = [
          (coords) => 2 * coords[0],
          (coords) => 2 * coords[1],
          (coords) => 2 * coords[2],
        ];

        final curl = NumericalDifferentiation.curl(F, [1, 1, 1]);
        expect(curl[0], closeTo(0.0, tol));
        expect(curl[1], closeTo(0.0, tol));
        expect(curl[2], closeTo(0.0, tol));
      });

      test('throws error for non-3D fields', () {
        List<num Function(List<num>)> f2d = [
          (coords) => coords[0],
          (coords) => coords[1],
        ];

        expect(() => NumericalDifferentiation.curl(f2d, [1, 1]),
            throwsArgumentError);
      });
    });

    group('Accuracy Comparisons', () {
      test('central difference more accurate than forward/backward', () {
        num f(num x) => sin(x);
        final exact = cos(pi / 4);

        final central = NumericalDifferentiation.derivative(f, pi / 4);
        final forward = NumericalDifferentiation.forwardDifference(f, pi / 4);
        final backward = NumericalDifferentiation.backwardDifference(f, pi / 4);

        final centralError = (central - exact).abs();
        final forwardError = (forward - exact).abs();
        final backwardError = (backward - exact).abs();

        expect(centralError, lessThan(forwardError));
        expect(centralError, lessThan(backwardError));
      });
    });

    group('Edge Cases', () {
      test('handles very small step sizes', () {
        num f(num x) => x * x;
        final result = NumericalDifferentiation.derivative(f, 1, h: 1e-10);
        expect(result, closeTo(2.0, tol));
      });

      test('handles negative x values', () {
        num f(num x) => x * x * x;
        final result = NumericalDifferentiation.derivative(f, -2);
        expect(result, closeTo(12.0, tol));
      });

      test('handles zero', () {
        num f(num x) => x * x * x;
        final result = NumericalDifferentiation.derivative(f, 0);
        expect(result, closeTo(0.0, tol));
      });
    });
  });
}
