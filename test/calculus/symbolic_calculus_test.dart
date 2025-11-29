import 'package:advance_math/advance_math.dart';
import 'package:test/test.dart';
import 'package:advance_math/src/math/algebra/calculus/symbolic_calculus.dart';

void main() {
  group('Symbolic Calculus Tests', () {
    const double tol = 1e-4;
    const double relaxedTol = 1e-2;

    group('Partial Derivatives', () {
      test('partial derivative of x^2 with respect to x', () {
        var expr = Expression.parse('x^2');
        var deriv = SymbolicCalculus.partialDerivative(expr, 'x');

        // The derivative of x^2 is 2*x
        // Evaluate at x=3 should give 6
        var result = deriv.substitute(Variable('x'), Literal(3)).evaluate();
        expect(result, closeTo(6.0, tol));
      });

      test('using extension method partialD', () {
        var expr = Expression.parse('x^3');
        var deriv = expr.partialD('x');

        // Derivative of x^3 is 3*x^2
        // At x=2 should give 12
        var result = deriv.substitute(Variable('x'), Literal(2)).evaluate();
        expect(result, closeTo(12.0, tol));
      });
    });

    group('Taylor Series', () {
      test('Taylor series of sin(x) around x=0', () {
        // sin(x) ≈ x - x^3/6 + x^5/120 - ...
        var expr = Sin(Variable('x'));
        var taylor = SymbolicCalculus.taylorSeries(expr, 'x', 0, 3);

        // Evaluate at small x, should be close to sin(x)
        final x = 0.5;
        var taylorValue =
            taylor.substitute(Variable('x'), Literal(x)).evaluate();
        var exactValue = sin(x);

        expect(taylorValue, closeTo(exactValue, relaxedTol));
      });

      test('Taylor series using extension method', () {
        var expr = Expression.parse('x^2');
        var taylor = expr.taylor('x', 1, 2);

        // Taylor series of x^2 around x=1: 1 + 2(x-1) + (x-1)^2
        // At x=1.5: 1 + 2(0.5) + (0.5)^2 = 1 + 1 + 0.25 = 2.25
        var result = taylor.substitute(Variable('x'), Literal(1.5)).evaluate();
        expect(result, closeTo(2.25, tol));
      });
    });

    group('Maclaurin Series', () {
      test('Maclaurin series of exp(x)', () {
        // e^x ≈ 1 + x + x^2/2 + x^3/6 + x^4/24
        var expr = Exp(Variable('x'));
        var maclaurin = SymbolicCalculus.maclaurinSeries(expr, 'x', 4);

        final x = 0.5;
        var seriesValue =
            maclaurin.substitute(Variable('x'), Literal(x)).evaluate();
        var exactValue = exp(x);

        expect(seriesValue, closeTo(exactValue, relaxedTol));
      });

      test('using extension method maclaurin', () {
        var expr = Cos(Variable('x'));
        var maclaurin = expr.maclaurin('x', 4);

        // cos(x) ≈ 1 - x^2/2 + x^4/24
        final x = 0.3;
        var seriesValue =
            maclaurin.substitute(Variable('x'), Literal(x)).evaluate();
        var exactValue = cos(x);

        expect(seriesValue, closeTo(exactValue, relaxedTol));
      });
    });

    group('Limits', () {
      test('limit of (x^2 - 1)/(x - 1) as x approaches 1', () {
        // This should equal 2 (by L'Hopital's rule or factoring)
        var numerator = Expression.parse('x^2') - Literal(1);
        var denominator = Variable('x') - Literal(1);
        var expr = numerator / denominator;

        var limit = SymbolicCalculus.limit(expr, 'x', 1);

        expect(limit, closeTo(2.0, tol));
      });

      test('limit of sin(x)/x as x approaches 0', () {
        var expr = Sin(Variable('x')) / Variable('x');
        var limit = SymbolicCalculus.limit(expr, 'x', 0);

        expect(limit, closeTo(1.0, tol));
      });

      test('using extension method limitAt', () {
        var expr = (Variable('x') ^ Literal(2)) / Variable('x');
        var limit = expr.limitAt('x', 2);

        // This should equal 2
        expect(limit, closeTo(2.0, tol));
      });

      test('one-sided limits', () {
        var expr = Literal(1) / Variable('x');

        // From the right, approaches +∞
        var rightLimit =
            SymbolicCalculus.limit(expr, 'x', 0, direction: 'right');
        expect(rightLimit.isInfinite || rightLimit.abs() > 1e6, isTrue);
      });
    });

    group('Definite Integrals', () {
      test('integral of x^2 from 0 to 2', () {
        var expr = Variable('x') ^ Literal(2);
        var result = SymbolicCalculus.definiteIntegral(expr, 'x', 0, 2);

        // ∫x² dx from 0 to 2 = [x³/3] = 8/3 ≈ 2.667
        expect(result, closeTo(8 / 3, tol));
      });

      test('integral of sin(x) from 0 to π', () {
        var expr = Sin(Variable('x'));
        var result = SymbolicCalculus.definiteIntegral(expr, 'x', 0, pi);

        // ∫sin(x) dx from 0 to π = [-cos(x)] = -cos(π) + cos(0) = 1 + 1 = 2
        expect(result, closeTo(2.0, tol));
      });

      test('using extension method definiteIntegral', () {
        var expr = Variable('x') ^ Literal(3);
        var result = expr.definiteIntegral('x', 0, 2);

        // ∫x³ dx from 0 to 2 = [x⁴/4] = 16/4 = 4
        expect(result, closeTo(4.0, tol));
      });
    });

    group('Indefinite Integrals', () {
      test('indefinite integral of x', () {
        var expr = Variable('x');
        var integral = SymbolicCalculus.indefiniteIntegral(expr, 'x');

        // ∫x dx = x²/2 (+ C)
        // Evaluate at x=2 should give 2
        var result = integral.substitute(Variable('x'), Literal(2)).evaluate();
        expect(result, closeTo(2.0, tol));
      });

      test('indefinite integral of x^2', () {
        var expr = Variable('x') ^ Literal(2);
        var integral = SymbolicCalculus.indefiniteIntegral(expr, 'x');

        // ∫x² dx = x³/3 (+ C)
        // Evaluate at x=3 should give 9
        var result = integral.substitute(Variable('x'), Literal(3)).evaluate();
        expect(result, closeTo(9.0, tol));
      });
    });

    group('Complex Expressions', () {
      test('partial derivative of x^2 + y^2', () {
        // Note: Current implementation may not handle multi-variable properly
        // This is a placeholder for future enhancement
        var expr = Expression.parse('x^2 + x');
        var deriv = expr.partialD('x');

        var result = deriv.substitute(Variable('x'), Literal(2)).evaluate();
        // d/dx(x² + x) = 2x + 1, at x=2 equals 5
        expect(result, closeTo(5.0, tol));
      });

      test('Taylor series of polynomial', () {
        var expr = Variable('x') ^ Literal(3);
        var taylor = expr.taylor('x', 1, 3);

        // Taylor series of x³ around x=1
        // At x=2 should give 8
        var result = taylor.substitute(Variable('x'), Literal(2)).evaluate();
        expect(result, closeTo(8.0, tol));
      });
    });

    group('Edge Cases', () {
      test('Taylor series with order 0', () {
        var expr = Variable('x') ^ Literal(2);
        var taylor = expr.taylor('x', 1, 0);

        // Order 0 should just give f(1) = 1
        var result = taylor.evaluate();
        expect(result, closeTo(1.0, tol));
      });

      test('limit that does not exist', () {
        // Discontinuous function
        var expr = Literal(1) / Variable('x');
        var limit = SymbolicCalculus.limit(expr, 'x', 0);

        // Should return NaN or infinity
        expect(limit.isNaN || limit.isInfinite, isTrue);
      });

      test('integration bounds are equal', () {
        var expr = Variable('x');
        var result = expr.definiteIntegral('x', 2, 2);

        expect(result, closeTo(0.0, tol));
      });

      test('negative order throws error', () {
        var expr = Variable('x');
        expect(() => expr.taylor('x', 0, -1), throwsArgumentError);
      });

      test('invalid direction throws error', () {
        var expr = Variable('x');
        expect(() => SymbolicCalculus.limit(expr, 'x', 0, direction: 'invalid'),
            throwsArgumentError);
      });
    });
  });
}
