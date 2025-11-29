import 'package:advance_math/advance_math.dart';
import 'package:test/test.dart';
import 'package:advance_math/src/math/algebra/calculus/integration.dart';

void main() {
  group('Numerical Integration Tests', () {
    // Tolerance for numerical comparisons
    const double tol = 1e-6;
    const double relaxedTol = 1e-4;

    group('Trapezoidal Rule', () {
      test('integrates polynomial x^2 from 0 to 1', () {
        num f(num x) => x * x;
        final result = NumericalIntegration.trapezoidal(f, 0, 1, n: 1000);
        expect(result, closeTo(1 / 3, tol));
      });

      test('integrates sin(x) from 0 to π', () {
        num f(num x) => sin(x);
        final result = NumericalIntegration.trapezoidal(f, 0, pi, n: 1000);
        expect(result, closeTo(2.0, 1e-5));
      });

      test('integrates exponential e^x from 0 to 1', () {
        num f(num x) => exp(x);
        final result = NumericalIntegration.trapezoidal(f, 0, 1, n: 1000);
        expect(result, closeTo(e - 1, tol));
      });

      test('returns 0 for zero interval', () {
        num f(num x) => x * x;
        final result = NumericalIntegration.trapezoidal(f, 1, 1, n: 100);
        expect(result, equals(0));
      });

      test('throws error for non-positive n', () {
        num f(num x) => x;
        expect(() => NumericalIntegration.trapezoidal(f, 0, 1, n: 0),
            throwsArgumentError);
        expect(() => NumericalIntegration.trapezoidal(f, 0, 1, n: -10),
            throwsArgumentError);
      });

      test('handles negative intervals', () {
        num f(num x) => x * x;
        final result = NumericalIntegration.trapezoidal(f, 1, 0, n: 1000);
        expect(result, closeTo(-1 / 3, tol));
      });
    });

    group('Simpson\'s Rule', () {
      test('integrates x^3 from 0 to 2', () {
        num f(num x) => x * x * x;
        final result = NumericalIntegration.simpsons(f, 0, 2, n: 100);
        expect(result, closeTo(4.0, tol));
      });

      test('integrates 1/(1+x^2) from 0 to 1 (π/4)', () {
        num f(num x) => 1 / (1 + x * x);
        final result = NumericalIntegration.simpsons(f, 0, 1, n: 100);
        expect(result, closeTo(pi / 4, tol));
      });

      test('integrates cos(x) from 0 to π/2', () {
        num f(num x) => cos(x);
        final result = NumericalIntegration.simpsons(f, 0, pi / 2, n: 100);
        expect(result, closeTo(1.0, tol));
      });

      test('throws error for odd n', () {
        num f(num x) => x;
        expect(() => NumericalIntegration.simpsons(f, 0, 1, n: 99),
            throwsArgumentError);
      });

      test('returns 0 for zero interval', () {
        num f(num x) => x * x;
        final result = NumericalIntegration.simpsons(f, 1, 1, n: 100);
        expect(result, equals(0));
      });

      test('more accurate than trapezoidal for smooth functions', () {
        num f(num x) => sin(x);
        final trap = NumericalIntegration.trapezoidal(f, 0, pi, n: 100);
        final simp = NumericalIntegration.simpsons(f, 0, pi, n: 100);
        final exact = 2.0;

        final trapError = (trap - exact).abs();
        final simpError = (simp - exact).abs();

        expect(simpError, lessThan(trapError));
      });
    });

    group('Adaptive Simpson\'s Rule', () {
      test('integrates x^4 from 0 to 1', () {
        num f(num x) => x * x * x * x;
        final result =
            NumericalIntegration.adaptiveSimpson(f, 0, 1, tolerance: 1e-8);
        expect(result, closeTo(0.2, tol));
      });

      test('handles rapidly changing functions', () {
        num f(num x) => exp(-x * x);
        final result =
            NumericalIntegration.adaptiveSimpson(f, 0, 2, tolerance: 1e-6);
        // Known value for this integral
        expect(result, closeTo(0.8820813908, tol));
      });

      test('respects tolerance parameter', () {
        num f(num x) => sin(x);
        final result1 =
            NumericalIntegration.adaptiveSimpson(f, 0, pi, tolerance: 1e-4);
        final result2 =
            NumericalIntegration.adaptiveSimpson(f, 0, pi, tolerance: 1e-10);

        // Both should be close to 2.0, but result2 should be more accurate
        expect(result1, closeTo(2.0, 1e-3));
        expect(result2, closeTo(2.0, 1e-8));
      });

      test('returns 0 for zero interval', () {
        num f(num x) => x * x;
        final result = NumericalIntegration.adaptiveSimpson(f, 1, 1);
        expect(result, equals(0));
      });
    });

    group('Romberg Integration', () {
      test('integrates exp(-x^2) from 0 to 1', () {
        num f(num x) => exp(-x * x);
        final result = NumericalIntegration.romberg(f, 0, 1, tolerance: 1e-10);
        expect(result, closeTo(0.746824132812427, 1e-9));
      });

      test('integrates polynomial accurately', () {
        num f(num x) => 3 * x * x + 2 * x + 1;
        final result = NumericalIntegration.romberg(f, 0, 2, tolerance: 1e-8);
        // Exact: [x^3 + x^2 + x] from 0 to 2 = 8 + 4 + 2 = 14
        expect(result, closeTo(14.0, tol));
      });

      test('converges quickly for smooth functions', () {
        num f(num x) => sin(x);
        final result = NumericalIntegration.romberg(f, 0, pi,
            tolerance: 1e-12, maxDepth: 15);
        expect(result, closeTo(2.0, 1e-10));
      });

      test('returns 0 for zero interval', () {
        num f(num x) => x * x;
        final result = NumericalIntegration.romberg(f, 1, 1);
        expect(result, equals(0));
      });
    });

    group('Gaussian Quadrature', () {
      test('integrates x^2 exactly with order 2', () {
        num f(num x) => x * x;
        final result =
            NumericalIntegration.gaussianQuadrature(f, 0, 1, order: 2);
        // Quadrature of order n is exact for polynomials of degree 2n-1
        expect(result, closeTo(1 / 3, 1e-10));
      });

      test('integrates x^7 exactly with order 4', () {
        num f(num x) => pow(x, 7);
        final result =
            NumericalIntegration.gaussianQuadrature(f, 0, 1, order: 4);
        expect(result, closeTo(1 / 8, 1e-10));
      });

      test('handles different orders', () {
        num f(num x) => exp(x);

        for (int order = 2; order <= 10; order++) {
          final result =
              NumericalIntegration.gaussianQuadrature(f, 0, 1, order: order);
          expect(result, closeTo(e - 1, 1e-3));
        }
      });

      test('throws error for invalid order', () {
        num f(num x) => x;
        expect(() => NumericalIntegration.gaussianQuadrature(f, 0, 1, order: 1),
            throwsArgumentError);
        expect(
            () => NumericalIntegration.gaussianQuadrature(f, 0, 1, order: 11),
            throwsArgumentError);
      });

      test('returns 0 for zero interval', () {
        num f(num x) => x * x;
        final result =
            NumericalIntegration.gaussianQuadrature(f, 1, 1, order: 5);
        expect(result, equals(0));
      });

      test('integrates trig functions accurately', () {
        num f(num x) => sin(x);
        final result =
            NumericalIntegration.gaussianQuadrature(f, 0, pi, order: 10);
        expect(result, closeTo(2.0, tol));
      });
    });

    group('Double Integration', () {
      test('integrates x*y over unit square', () {
        num f(num x, num y) => x * y;
        final result = NumericalIntegration.doubleIntegral(
            f, 0, 1, (x) => 0, (x) => 1,
            nx: 100, ny: 100);
        expect(result, closeTo(0.25, tol));
      });

      test('integrates x^2 + y^2 over unit square', () {
        num f(num x, num y) => x * x + y * y;
        final result = NumericalIntegration.doubleIntegral(
            f, 0, 1, (x) => 0, (x) => 1,
            nx: 100, ny: 100);
        expect(result, closeTo(2 / 3, 1e-4));
      });

      test('handles variable y bounds', () {
        // Integrate over triangle: 0 ≤ x ≤ 1, 0 ≤ y ≤ x
        num f(num x, num y) => 1;
        final result = NumericalIntegration.doubleIntegral(
            f, 0, 1, (x) => 0, (x) => x,
            nx: 100, ny: 100);
        // Area of triangle = 1/2
        expect(result, closeTo(0.5, tol));
      });

      test('integrates exp(-(x^2 + y^2))', () {
        num f(num x, num y) {
          final r2 = x * x + y * y;
          return exp(-r2);
        }

        final result = NumericalIntegration.doubleIntegral(
            f, 0, 1, (x) => 0, (x) => 1,
            nx: 50, ny: 50);
        expect(result, closeTo(0.5577, relaxedTol));
      });
    });

    group('Triple Integration', () {
      test('integrates x*y*z over unit cube', () {
        num f(num x, num y, num z) => x * y * z;
        final result = NumericalIntegration.tripleIntegral(
            f, 0, 1, (x) => 0, (x) => 1, (x, y) => 0, (x, y) => 1,
            nx: 30, ny: 30, nz: 30);
        expect(result, closeTo(0.125, tol));
      });

      test('integrates constant over unit cube', () {
        num f(num x, num y, num z) => 1;
        final result = NumericalIntegration.tripleIntegral(
            f, 0, 1, (x) => 0, (x) => 1, (x, y) => 0, (x, y) => 1,
            nx: 20, ny: 20, nz: 20);
        expect(result, closeTo(1.0, tol));
      });

      test('handles variable bounds', () {
        // Integrate over tetrahedron: 0≤x≤1, 0≤y≤1-x, 0≤z≤1-x-y
        num f(num x, num y, num z) => 1;
        final result = NumericalIntegration.tripleIntegral(
            f, 0, 1, (x) => 0, (x) => 1 - x, (x, y) => 0, (x, y) => 1 - x - y,
            nx: 20, ny: 20, nz: 20);
        // Volume of tetrahedron = 1/6
        expect(result, closeTo(1 / 6, 1e-3));
      });
    });

    group('Monte Carlo Integration', () {
      test('integrates over 2D unit square', () {
        num f(List<num> coords) {
          final x = coords[0];
          final y = coords[1];
          return x * x + y * y;
        }

        final result = NumericalIntegration.monteCarloIntegral(
            f, [0, 0], [1, 1],
            samples: 100000, seed: 42);
        expect(result, closeTo(2 / 3, 0.01)); // MC has larger error
      });

      test('integrates over 3D unit cube', () {
        num f(List<num> coords) {
          final x = coords[0];
          final y = coords[1];
          final z = coords[2];
          return x * y * z;
        }

        final result = NumericalIntegration.monteCarloIntegral(
            f, [0, 0, 0], [1, 1, 1],
            samples: 50000, seed: 42);
        expect(result, closeTo(0.125, 0.01));
      });

      test('estimates π using circle area', () {
        num f(List<num> coords) {
          final x = coords[0];
          final y = coords[1];
          final r2 = x * x + y * y;
          return r2 <= 1 ? 1 : 0;
        }

        final result = NumericalIntegration.monteCarloIntegral(
            f, [-1, -1], [1, 1],
            samples: 100000, seed: 42);
        // Area of unit circle = π, area of square = 4, so result ≈ π
        expect(result, closeTo(pi, 0.05));
      });

      test('handles high-dimensional integrals (4D)', () {
        num f(List<num> coords) {
          // Product of all coordinates
          num product = 1;
          for (var c in coords) {
            product *= c;
          }
          return product;
        }

        final result = NumericalIntegration.monteCarloIntegral(
            f, [0, 0, 0, 0], [1, 1, 1, 1],
            samples: 50000, seed: 42);
        // Exact integral = (1/2)^4 = 1/16
        expect(result, closeTo(1 / 16, 0.01));
      });

      test('throws error for mismatched dimensions', () {
        num f(List<num> coords) => coords[0];
        expect(
            () => NumericalIntegration.monteCarloIntegral(f, [0, 0], [1, 1, 1],
                samples: 1000),
            throwsArgumentError);
      });

      test('reproducible with same seed', () {
        num f(List<num> coords) => coords[0] * coords[0];

        final result1 = NumericalIntegration.monteCarloIntegral(f, [0], [1],
            samples: 1000, seed: 123);
        final result2 = NumericalIntegration.monteCarloIntegral(f, [0], [1],
            samples: 1000, seed: 123);

        expect(result1, equals(result2));
      });
    });

    group('Integration with Error Estimation', () {
      test('provides error estimate for smooth functions', () {
        num f(num x) => sin(x);
        final result =
            NumericalIntegration.integrateWithError(f, 0, pi, tolerance: 1e-8);

        expect(result['value'], closeTo(2.0, 1e-6));
        expect(result['error'], lessThan(1e-6));
      });

      test('returns both value and error', () {
        num f(num x) => x * x;
        final result = NumericalIntegration.integrateWithError(f, 0, 1);

        expect(result.containsKey('value'), isTrue);
        expect(result.containsKey('error'), isTrue);
        expect(result['value'], isA<num>());
        expect(result['error'], isA<num>());
      });
    });

    group('Comparison Tests', () {
      test('all methods agree for polynomial', () {
        num f(num x) => x * x * x;
        final a = 0, b = 2;
        final exact = 4.0;

        final trap = NumericalIntegration.trapezoidal(f, a, b, n: 1000);
        final simp = NumericalIntegration.simpsons(f, a, b, n: 1000);
        final romberg = NumericalIntegration.romberg(f, a, b, tolerance: 1e-6);
        final gauss =
            NumericalIntegration.gaussianQuadrature(f, a, b, order: 5);

        expect(trap, closeTo(exact, 1e-3));
        expect(simp, closeTo(exact, tol));
        expect(romberg, closeTo(exact, tol));
        expect(gauss, closeTo(exact, 1e-10)); // Best for polynomials
      });

      test('accuracy comparison for smooth functions', () {
        num f(num x) => exp(-x);
        final a = 0, b = 1;
        final exact = 1 - 1 / e;

        final trap = NumericalIntegration.trapezoidal(f, a, b, n: 100);
        final simp = NumericalIntegration.simpsons(f, a, b, n: 100);
        final gauss =
            NumericalIntegration.gaussianQuadrature(f, a, b, order: 5);

        final trapError = (trap - exact).abs();
        final simpError = (simp - exact).abs();
        final gaussError = (gauss - exact).abs();

        // Simpson's should be better than trapezoidal
        expect(simpError, lessThan(trapError));
        // Gaussian should be best
        expect(gaussError, lessThan(simpError));
      });
    });

    group('Edge Cases', () {
      test('handles very small intervals', () {
        num f(num x) => x;
        final result = NumericalIntegration.simpsons(f, 0, 1e-10, n: 10);
        expect(result, closeTo(5e-21, 1e-25));
      });

      test('handles very large intervals', () {
        num f(num x) => 1 / (x * x + 1);
        final result = NumericalIntegration.trapezoidal(f, -10, 10, n: 2000);
        // arctan(x) from -10 to 10 = 2*arctan(10) ≈ 2.9422
        final expected = 2 * atan(10);
        expect(result, closeTo(expected, 0.01));
      });

      test('handles discontinuous functions reasonably', () {
        num f(num x) => x < 0.5 ? 1 : 0;
        final result = NumericalIntegration.trapezoidal(f, 0, 1, n: 1000);
        expect(result, closeTo(0.5, 0.01));
      });
    });
  });
}
