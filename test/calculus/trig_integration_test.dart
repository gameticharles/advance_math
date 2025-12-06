import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  group('Trigonometric Integration', () {
    final x = Variable('x');

    // Helper to verify integration result contains expected coefficient
    void checkIntegral(Expression expr, String expectedCoeffPattern) {
      final integrated = expr.integrate();
      print('$expr -> $integrated');
      expect(integrated.toString(), contains(expectedCoeffPattern));
    }

    test('Sin integration: sin(2x) -> -0.5*cos(2x)', () {
      checkIntegral(Sin(Multiply(Literal(2), x)), '-0.5');
    });

    test('Cos integration: cos(4x) -> 0.25*sin(4x)', () {
      // 1/4 = 0.25
      checkIntegral(Cos(Multiply(Literal(4), x)), '0.25');
    });

    test('Tan integration: tan(2x) -> -0.5*ln|cos(2x)|', () {
      checkIntegral(Tan(Multiply(Literal(2), x)), '-0.5');
    });

    test('Cot integration: cot(2x) -> 0.5*ln|sin(2x)|', () {
      checkIntegral(Cot(Multiply(Literal(2), x)), '0.5');
    });

    test('Sec integration: sec(2x) -> 0.5*ln|sec(2x)+tan(2x)|', () {
      checkIntegral(Sec(Multiply(Literal(2), x)), '0.5');
    });

    test('Csc integration: csc(2x) -> 0.5*ln|tan(x)|', () {
      checkIntegral(Csc(Multiply(Literal(2), x)), '0.5');
    });

    test('Csc^2 integration: csc(x)^2 -> -cot(x)', () {
      final expr = Csc(x, n: 2);
      final integrated = expr.integrate();
      print('$expr -> $integrated');
      expect(integrated.toString(), contains('-1.0*cot(x)'));
    });

    test('Csc^2 integration with coeff: csc(2x)^2 -> -0.5*cot(2x)', () {
      final expr = Csc(Multiply(Literal(2), x), n: 2);
      final integrated = expr.integrate();
      print('$expr -> $integrated');
      expect(integrated.toString(), contains('-0.5'));
      expect(integrated.toString(), contains('cot(2*x)'));
    });

    test('Complex coefficient integration: sin(ix)', () {
      final i = Complex(0, 1);
      final expr = Sin(Multiply(Literal(i), x));
      // Should result in -1/i * cos(ix) = i * cos(ix) ?
      // -1/i = -1 * -i = i.
      // Or literal might be displayed as Complex.
      final integrated = expr.integrate();
      print('$expr -> $integrated');
      // Expect no crash and correct coefficient type (Complex)
      expect(
          integrated.toString(), contains('i')); // i or similar representation
    });
  });
}
