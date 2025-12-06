import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  group('Special Functions (Top-Level Wrappers)', () {
    test('erf handles num and Complex', () {
      // erf(0) = 0
      expect(erf(0), equals(0));
      expect(erf(0.0), closeTo(0.0, 1e-10));

      // erf(1) ~ 0.8427
      expect(erf(1), closeTo(0.84270079, 1e-5));
      expect(erf(Complex(1, 0)), equals(Complex(1, 0).erf()));
    });

    test('gamma handles num and Complex', () {
      expect(gamma(5), closeTo(24.0, 1e-10)); // 4!
      expect(gamma(0.5), closeTo(sqrt(pi), 1e-10));
      expect(gamma(Complex(5, 0)), equals(Complex(5, 0).gamma()));
    });

    test('beta handles num and Complex', () {
      // B(1, 2) = Γ(1)Γ(2)/Γ(3) = 1*1/2 = 0.5
      expect(beta(1, 2), closeTo(0.5, 1e-10));
    });

    test('zeta handles num and Complex', () {
      // ζ(2) = π^2/6 ~ 1.64493
      expect(zeta(2), closeTo(1.64493, 1e-5));
    });

    test('expm1 handles precision', () {
      // expm1(1e-10) ~ 1e-10
      expect(expm1(1e-10), closeTo(1e-10, 1e-20));
      expect(expm1(0), equals(0));
    });

    test('log1p handles precision', () {
      // log1p(1e-10) ~ 1e-10
      expect(log1p(1e-10), closeTo(1e-10, 1e-20));
      expect(log1p(0), equals(0));
    });

    test('digamma works', () {
      // ψ(1) = -γ (Euler-Mascheroni) ~ -0.57721
      expect(digamma(1), closeTo(-0.57721, 1e-4));
    });

    test('frexp works', () {
      var parts = frexp(8.0);
      expect(parts.mantissa, equals(0.5));
      expect(parts.exponent, equals(4));

      parts = frexp(-8.0);
      expect(parts.mantissa, equals(-0.5));
      expect(parts.exponent, equals(4));

      parts = frexp(0);
      expect(parts.mantissa, equals(0.0));
      expect(parts.exponent, equals(0));
    });

    test('ldexp works', () {
      expect(ldexp(0.5, 4), equals(8.0));
      expect(ldexp(-0.5, 4), equals(-8.0));
      expect(ldexp(1, 10), equals(1024.0));
    });
  });
}
