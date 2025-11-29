import 'package:advance_math/advance_math.dart';
import 'package:advance_math/src/math/algebra/calculus/hybrid_calculus.dart';
import 'package:test/test.dart';

void main() {
  group('HybridCalculus Validation Tests', () {
    const double tol = 1e-4;

    test('Derivative Comparison: x^2 at x=3', () {
      var expr = Expression.parse('x^2');
      var results = HybridCalculus.compareResults(expr, 'x', 3);

      var derivResults = results['derivative'];
      // Symbolic: 2x -> 6
      // Numerical: ~6
      expect(derivResults['symbolic'], closeTo(6.0, tol));
      expect(derivResults['numerical'], closeTo(6.0, tol));
      expect(derivResults['error'], lessThan(tol));
    });

    test('Derivative Comparison: sin(x) at x=0.5', () {
      var expr = Sin(Variable('x'));
      var results = HybridCalculus.compareResults(expr, 'x', 0.5);

      var derivResults = results['derivative'];
      // Symbolic: cos(0.5)
      // Numerical: ~cos(0.5)
      expect(derivResults['symbolic'], closeTo(cos(0.5), tol));
      expect(derivResults['numerical'], closeTo(cos(0.5), tol));
      expect(derivResults['error'], lessThan(tol));
    });

    test('Integral Comparison: x^2 from 0 to 1', () {
      var expr = Expression.parse('x^2');
      var results = HybridCalculus.compareResults(expr, 'x', 0, a: 0, b: 1);

      var integralResults = results['integral'];
      // Symbolic: [x^3/3] from 0 to 1 = 1/3
      // Numerical: ~1/3
      expect(integralResults['symbolic'], closeTo(1 / 3, tol));
      expect(integralResults['numerical'], closeTo(1 / 3, tol));
      expect(integralResults['error'], lessThan(tol));
    });

    test('Integral Comparison: exp(x) from 0 to 1', () {
      var expr = Exp(Variable('x'));
      var results = HybridCalculus.compareResults(expr, 'x', 0, a: 0, b: 1);

      var integralResults = results['integral'];
      // Symbolic: [e^x] from 0 to 1 = e - 1
      // Numerical: ~e - 1
      expect(integralResults['symbolic'], closeTo(e - 1, tol));
      expect(integralResults['numerical'], closeTo(e - 1, tol));
      expect(integralResults['error'], lessThan(tol));
    });

    test('Hybrid Numerical Derivative Direct Call', () {
      var expr = Expression.parse('x^3');
      // d/dx(x^3) = 3x^2. At x=2, result is 12.
      var val = HybridCalculus.evaluateDerivative(expr, 'x', 2);
      expect(val, closeTo(12, tol));
    });

    test('Hybrid Numerical Integral Direct Call', () {
      var expr = Expression.parse('x');
      // Integral x dx from 0 to 2 = [x^2/2] = 2
      var val = HybridCalculus.evaluateIntegral(expr, 'x', 0, 2);
      expect(val, closeTo(2, tol));
    });
  });
}
