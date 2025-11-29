import 'package:advance_math/advance_math.dart';
import 'package:test/test.dart';
import 'dart:math' as math;

void main() {
  group('RootFinding', () {
    const double tol = 1e-6;

    // Test functions
    num poly(num x) => x * x - 4; // Roots at 2, -2
    num transcendental(num x) =>
        math.exp(x) - 3 * x; // Roots near 0.619 and 1.512
    num cubic(num x) => x * x * x - x - 2; // Root near 1.521

    // Derivatives
    num polyDeriv(num x) => 2 * x;
    num transcendentalDeriv(num x) => math.exp(x) - 3;

    group('Bracketing Methods', () {
      test('Bisection finds root of x^2 - 4', () {
        var root = RootFinding.bisection(poly, 0, 3);
        expect(root, closeTo(2, tol));
      });

      test('False Position finds root of x^2 - 4', () {
        var root = RootFinding.falsePosition(poly, 0, 3);
        expect(root, closeTo(2, tol));
      });

      test('Brent finds root of x^2 - 4', () {
        var root = RootFinding.brent(poly, 0, 3);
        expect(root, closeTo(2, tol));
      });

      test('Brent finds root of transcendental function', () {
        var root = RootFinding.brent(transcendental, 0, 1);
        expect(root, closeTo(0.619061, tol));
      });

      test('Bracketing methods throw if signs are same', () {
        expect(() => RootFinding.bisection(poly, 3, 5), throwsArgumentError);
        expect(
            () => RootFinding.falsePosition(poly, 3, 5), throwsArgumentError);
        expect(() => RootFinding.brent(poly, 3, 5), throwsArgumentError);
      });
    });

    group('Open Methods', () {
      test('Newton-Raphson finds root of x^2 - 4', () {
        var root = RootFinding.newtonRaphson(poly, polyDeriv, 3);
        expect(root, closeTo(2, tol));
      });

      test('Newton-Raphson finds root of transcendental function', () {
        var root =
            RootFinding.newtonRaphson(transcendental, transcendentalDeriv, 0);
        expect(root, closeTo(0.619061, tol));
      });

      test('Secant finds root of x^3 - x - 2', () {
        var root = RootFinding.secant(cubic, 1, 2);
        expect(root, closeTo(1.52138, tol));
      });

      test('Fixed Point finds root of cos(x) = x', () {
        // g(x) = cos(x)
        var root = RootFinding.fixedPoint(math.cos, 0.5);
        expect(root, closeTo(0.739085, tol));
      });
    });

    group('Complex Roots', () {
      test('Muller finds real root of x^3 - 1', () {
        // Roots: 1, -0.5 ± 0.866i
        Complex f(Complex z) => z * z * z - Complex.one();

        var root = RootFinding.muller(f, 0.5, 1.5, 2.0);
        expect(root.real, closeTo(1, tol));
        expect(root.imaginary, closeTo(0, tol));
      });

      test('Muller finds complex root of x^2 + 1', () {
        // Roots: ±i
        Complex f(Complex z) => z * z + Complex.one();

        var root = RootFinding.muller(f, -0.5, 0, 0.5);
        // Depending on initial guesses, it might find i or -i
        // Here we just check if it satisfies the equation
        var val = f(root);
        expect(val.abs(), closeTo(0, tol));
      });
    });
  });
}
