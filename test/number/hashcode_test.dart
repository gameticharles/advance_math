import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('hashCodes', () {
    test('int and Integer', () {
      const d = Integer.constant(42);
      expect(d.hashCode, 42.hashCode);

      final d2 = Integer(-42);
      expect(d2.hashCode, (-42).hashCode);

      expect(d.hashCode == d2.hashCode, false);

      expect(Integer.zero.hashCode, 0.hashCode);
      expect(Integer.one.hashCode, 1.hashCode);
      expect(Integer.ten.hashCode, 10.hashCode);
      expect(Integer.hundred.hashCode, 100.hashCode);
      expect(Integer.thousand.hashCode, 1000.hashCode);
    });

    (test('Double', () {
      final d = Double(34.56);
      final d2 = Double(3.456e1);
      expect(d.hashCode, d2.hashCode);

      final d3 = Double(-34.56);
      expect(d.hashCode == d3.hashCode, false);

      final d4 = Double(217);
      expect(d4.hashCode, 217.hashCode);

      final d5 = Double(217.000000001);
      expect(d5.hashCode == 217.hashCode, false);
      expect(d5.hashCode == d4.hashCode, false);

      final d6 = Double(-217);
      expect(d6.hashCode, (-217).hashCode);
      expect(d6.hashCode == 217.hashCode, false);
      expect(d6.hashCode == d4.hashCode, false);

      final d7 = Double(1.234e-2);
      final d8 = Double(1.234e2);
      expect(d7.hashCode == d8.hashCode, false);
    }));

    test('Imaginary', () {
      final d = Imaginary(7);
      final d2 = Imaginary(7);
      expect(d.hashCode, d2.hashCode);
      expect(d.hashCode == 7.hashCode, false);

      final d3 = Imaginary(-7);
      expect(d3.hashCode == d2.hashCode, false);

      final d4 = Imaginary(23.43);
      expect(d4.hashCode == Double(23.43).hashCode, false);

      final d5 = Imaginary(0);
      expect(d5.hashCode, 0.hashCode);
    });

    test('Complex', () {
      final d = Complex.num(Double(34.56), Imaginary(7));
      final d2 = Complex.num(Double(34.56), Imaginary(7));
      expect(d.hashCode, d2.hashCode);

      final d3 = Complex.num(Double.zero, Imaginary(7));
      expect(d3.hashCode == d2.hashCode, false);

      final d4 = Complex.num(Double(34.56), Imaginary(0));
      expect(d4.hashCode == d2.hashCode, false);
    });

    test('Precise', () {
      final d = Precise('32.456');
      final d2 = Precise('32.456');
      expect(d.hashCode, d2.hashCode);

      final d3 = Double(32.456);
      expect(d2.hashCode, d3.hashCode);

      final d4 = Complex.num(Double(32.456), Imaginary(0));
      expect(d2.hashCode, d4.hashCode);

      final d5 = Precise('-32.456');
      expect(d.hashCode == d5.hashCode, false);
    });
  });
}
