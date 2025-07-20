// ignore_for_file: unnecessary_type_check

import 'dart:math';
import 'package:advance_math/src/number/number.dart';
import 'package:test/test.dart';

void main() {
  group('Complex', () {
    test('zeros', () {
      final complex0a = Complex.num(Integer.zero, Imaginary(0));
      final complex0b = Complex.num(Double(0), Imaginary(Double(0)));

      expect(complex0a.real.toDouble() == 0, true);
      expect(complex0a.imaginary.value.toDouble() == 0, true);

      expect(complex0a == complex0b, true);
    });

    group('constructors', () {
      test('coeff', () {
        final c1 = Complex(1, 2);
        expect(c1.real is Integer, true);
        expect(c1.real, Integer(1));
        expect(c1.imag is Imaginary, true);
        expect(c1.imag.value is Integer, true);
        expect(c1.imag.value, Integer(2));

        final c2 = Complex(3.3, 4.4);
        expect(c2.real is Double, true);
        expect(c2.real, Double(3.3));
        expect(c2.imag is Imaginary, true);
        expect(c2.imag.value is Double, true);
        expect(c2.imag.value, Double(4.4));
      });
    });

    group('operator +', () {
      test('operator + num', () {
        final c0 = Complex(0, 0);
        expect(c0 + 7, Integer(7));
        expect(c0 + 7 is Integer, true);
        expect(c0 + 0.001, Double(0.001));
        expect(c0 + 0.001 is Double, true);

        final c1 = Complex(1.1, 2.2);
        expect(c1 + 8, Complex(9.1, 2.2));
        expect(c1 + 0.02, Complex(1.12, 2.2));
      });

      test('operator + Integer', () {
        final c0 = Complex(0, 0);
        expect(c0 + Integer(7), Integer(7));
        expect(c0 + Integer(7) is Integer, true);
        expect(c0 + Integer(-10), Integer(-10));
        expect(c0 + Integer(-10) is Integer, true);

        final c1 = Complex(1.1, 2.2);
        expect(c1 + Integer(8), Complex(9.1, 2.2));
      });

      test('operator + Double', () {
        final c0 = Complex(0, 0);
        expect(c0 + Double(7.5), Double(7.5));
        expect(c0 + Double(7.5) is Double, true);
        expect(c0 + Double(-10.1), Double(-10.1));
        expect(c0 + Double(-10.1) is Double, true);
        expect(c0 + Double(17), Integer(17));
        expect(c0 + Double(17) is Integer, true);

        final c1 = Complex(1.1, 2.2);
        expect(c1 + Double(0.02), Complex(1.12, 2.2));
      });

      test('operator + Imaginary', () {
        final c0 = Complex(0, 0);
        expect(c0 + Imaginary(0), Complex(0, 0));
        expect(c0 + Imaginary(5.6), Imaginary(5.6));
        expect(c0 + Imaginary(-21.01), Imaginary(-21.01));

        final c1 = Complex(1.1, 2.2);
        expect(c1 + Imaginary(0), Complex(1.1, 2.2));
        expect(c1 + Imaginary(5.6), Complex(1.1, 7.8));
        expect(c1 + Imaginary(-21), Complex(1.1, -18.8));
      });

      test('operator + Complex', () {
        final c0 = Complex(0, 0);
        expect(c0 + Complex(0, 0), Integer(0));
        expect(c0 + Complex(0, 0) is Integer, true);
        expect(c0 + Complex(0, 5), Imaginary(5));
        expect(c0 + Complex(0, 5) is Imaginary, true);
        expect(c0 + Complex(5, 0), Integer(5));
        expect(c0 + Complex(5, 0) is Integer, true);
        expect(c0 + Complex(6.7, 0), Double(6.7));
        expect(c0 + Complex(6.7, 0) is Double, true);

        final c1 = Complex(1.1, 2.2);
        expect(c1 + Complex(0, 0), Complex(1.1, 2.2));
        expect(c1 + Complex(4.3, 0), Complex(5.4, 2.2));
        expect(c1 + Complex(0, 6.2), Complex(1.1, 8.4));
      });

      test('operator + Precise', () {
        final c0 = Complex(0, 0);
        expect(c0 + Precision('7.5'), Precision('7.5'));
        expect(c0 + Precision('7.5') is Precision, true);

        final c1 = Complex(1.1, 2.2);
        expect(
            c1 + Precision('0.00000000000000000000000002'),
            Complex.num(
                Precision('1.10000000000000000000000002'), Imaginary(2.2)));
      });
    });

    group('operator -', () {
      test('operator - num', () {
        final c0 = Complex(0, 0);
        expect(c0 - 7, Integer(-7));
        expect(c0 - 7 is Integer, true);
        expect(c0 - 0.001, Double(-0.001));
        expect(c0 - 0.001 is Double, true);

        final c1 = Complex(1.1, 2.2);
        expect(c1 - 8, Complex(-6.9, 2.2));
        expect(c1 - 0.02, Complex(1.08, 2.2));
      });

      test('operator - Integer', () {
        final c0 = Complex(0, 0);
        expect(c0 - Integer(7), Integer(-7));
        expect(c0 - Integer(7) is Integer, true);
        expect(c0 - Integer(-10), Integer(10));
        expect(c0 - Integer(-10) is Integer, true);

        final c1 = Complex(1.1, 2.2);
        expect(c1 - Integer(8), Complex(-6.9, 2.2));
      });

      test('operator - Double', () {
        final c0 = Complex(0, 0);
        expect(c0 - Double(7.5), Double(-7.5));
        expect(c0 - Double(7.5) is Double, true);
        expect(c0 - Double(-10.1), Double(10.1));
        expect(c0 - Double(-10.1) is Double, true);
        expect(c0 - Double(17), Integer(-17));
        expect(c0 - Double(17) is Integer, true);

        final c1 = Complex(1.1, 2.2);
        expect(c1 - Double(0.02), Complex(1.08, 2.2));
      });

      test('operator - Imaginary', () {
        final c0 = Complex(0, 0);
        expect(c0 - Imaginary(0), Complex(0, 0));
        expect(c0 - Imaginary(5.6), Imaginary(-5.6));
        expect(c0 - Imaginary(-21.01), Imaginary(21.01));

        final c1 = Complex(1.1, 2.2);
        expect(c1 - Imaginary(0), Complex(1.1, 2.2));
        expect(c1 - Imaginary(5.5), Complex(1.1, -3.3));
        expect(c1 - Imaginary(-21), Complex(1.1, 23.2));
      });

      test('operator - Complex', () {
        final c0 = Complex(0, 0);
        expect(c0 - Complex(0, 0), Integer(0));
        expect(c0 - Complex(0, 0) is Integer, true);
        expect(c0 - Complex(0, 5), Imaginary(-5));
        expect(c0 - Complex(0, 5) is Imaginary, true);
        expect(c0 - Complex(5, 0), Integer(-5));
        expect(c0 - Complex(5, 0) is Integer, true);
        expect(c0 - Complex(6.7, 0), Double(-6.7));
        expect(c0 - Complex(6.7, 0) is Double, true);

        final c1 = Complex(1.1, 2.2);
        expect(c1 - Complex(0, 0), Complex(1.1, 2.2));
        expect(c1 - Complex(4.7, 0), Complex(-3.6, 2.2));
        expect(c1 - Complex(0, 6.2), Complex(1.1, -4));
      });

      test('operator - Precise', () {
        final c0 = Complex(0, 0);
        expect(c0 - Precision('7.5'), Precision('-7.5'));
        expect(c0 - Precision('7.5') is Precision, true);

        final c1 = Complex(1.1, 2.2);
        expect(
            c1 - Precision('0.00000000000000000000000002'),
            Complex.num(
                Precision('1.09999999999999999999999998'), Imaginary(2.2)));
      });
    });

    group('operator *', () {
      test('operator * num', () {
        final c0 = Complex(0, 0);
        expect(c0 * 0, Integer(0));
        expect(c0 * 0 is Integer, true);
        expect(c0 * 1, Integer(0));
        expect(c0 * 1 is Integer, true);
        expect(c0 * 3.6, Integer(0));
        expect(c0 * 3.6 is Integer, true);
        expect(c0 * -9.1, Integer(0));
        expect(c0 * -9.1 is Integer, true);

        final c1 = Complex(2, 3);
        expect(c1 * 0, Integer(0));
        expect(c1 * 0 is Integer, true);
        expect(c1 * 1, Complex(2, 3));
        expect(c1 * 3.6, Complex(7.2, 10.8));
        expect(c1 * -2.5, Complex(-5, -7.5));
      });

      test('operator * Integer', () {
        final c0 = Complex(0, 0);
        expect(c0 * Integer(0), Integer(0));
        expect(c0 * Integer(0) is Integer, true);
        expect(c0 * Integer(1), Integer(0));
        expect(c0 * Integer(1) is Integer, true);
        expect(c0 * Integer(-9), Integer(0));
        expect(c0 * Integer(-9) is Integer, true);

        final c1 = Complex(2, 3);
        expect(c1 * Integer(0), Integer(0));
        expect(c1 * Integer(0) is Integer, true);
        expect(c1 * Integer(1), Complex(2, 3));
        expect(c1 * Integer(3), Complex(6, 9));
        expect(c1 * Integer(-2), Complex(-4, -6));
      });

      test('operator * Double', () {
        final c0 = Complex(0, 0);
        expect(c0 * Double(0), Integer(0));
        expect(c0 * Double(0) is Integer, true);
        expect(c0 * Double(1), Integer(0));
        expect(c0 * Double(1) is Integer, true);
        expect(c0 * Double(-9), Integer(0));
        expect(c0 * Double(-9) is Integer, true);

        final c1 = Complex(2, 3);
        expect(c1 * Double(0), Integer(0));
        expect(c1 * Double(0) is Integer, true);
        expect(c1 * Double(1.5), Complex(3, 4.5));
        expect(c1 * Double(-2.5), Complex(-5, -7.5));
      });

      test('operator * Imaginary', () {
        final c0 = Complex(0, 0);
        expect(c0 * Imaginary(0), Integer(0));
        expect(c0 * Imaginary(1), Integer(0));
        expect(c0 * Imaginary(-9), Integer(0));

        final c1 = Complex(2, 3);
        expect(c1 * Imaginary(0), Integer(0));
        expect(c1 * Imaginary(1), Complex(-3, 2));
        expect(c1 * Imaginary(3), Complex(-9, 6));
        expect(c1 * Imaginary(-2.5), Complex(7.5, -5));
      });

      test('operator * Complex', () {
        final c0 = Complex(0, 0);
        expect(c0 * Complex(0, 0), Integer(0));
        expect(c0 * Complex(5, 6), Integer(0));
        expect(c0 * Complex(-9.1, -12.1), Integer(0));

        final c1 = Complex(2, 3);
        expect(c1 * Complex(0, 0), Integer(0));
        expect(c1 * Complex(1, 2), Complex(-4, 7));
        expect(c1 * Complex(-3, -4), Complex(6, -17));
        expect(c1 * Complex(2.5, 1.5), Complex(0.5, 10.5));
      });

      test('operator * Precise', () {
        final c0 = Complex(0, 0);
        expect(c0 * Precision('0'), Precision('0'));
        expect(c0 * Precision('0') is Precision, true);
        expect(c0 * Precision('1'), Precision('0'));
        expect(c0 * Precision('1') is Precision, true);
        expect(c0 * Precision('-9'), Precision('0'));
        expect(c0 * Precision('-9') is Precision, true);

        final c1 = Complex(2, 3);
        expect(c1 * Precision('0'), Precision('0'));
        expect(c1 * Precision('1'), Complex(2, 3));
        expect(c1 * Precision('-9'), Complex(-18, -27));

        final c2 =
            Complex(2, 3) * Precision('-2.000000000000000000002') as Complex;
        expect(c2.real is Precision, true);
        expect(c2.real, Precision('-4.000000000000000000004'));
        expect(c2.imag.value is Precision, true);
        expect(c2.imag.value, Precision('-6.000000000000000000006'));
      });
    });

    group('operator /', () {
      test('operator / num', () {
        final c0 = Complex(0, 0);
        expect(c0 / 1, Integer(0));
        expect(c0 / 1 is Integer, true);
        expect(c0 / 3.6, Integer(0));
        expect(c0 / 3.6 is Integer, true);
        expect(c0 / -9.1, Integer(0));
        expect(c0 / -9.1 is Integer, true);
        expect(c0 / 0, Complex.num(Double.NaN, Imaginary(Double.NaN)));
        expect(c0 / double.infinity, Integer(0));
        expect(c0 / double.negativeInfinity, Integer(0));
        expect(c0 / double.nan, Complex.num(Double.NaN, Imaginary(Double.NaN)));

        final c1 = Complex(2, 3);
        expect(c1 / 1, Complex(2, 3));
        expect(c1 / 4, Complex(0.5, 0.75));
        expect(
            c1 / 0, Complex.num(Double.infinity, Imaginary(Double.infinity)));

        final c2 = Complex(-5, -2);
        expect(c2 / 1, Complex(-5, -2));
        expect(c2 / -4, Complex(1.25, 0.5));
        expect(c2 / 0,
            Complex.num(Double.negInfinity, Imaginary(Double.negInfinity)));
      });

      test('operator / Integer', () {
        final c0 = Complex(0, 0);
        expect(c0 / Integer(1), Integer(0));
        expect(c0 / Integer(1) is Integer, true);
        expect(c0 / Integer(3), Integer(0));
        expect(c0 / Integer(3) is Integer, true);
        expect(c0 / Integer(-9), Integer(0));
        expect(c0 / Integer(-9) is Integer, true);
        expect(c0 / Integer(0), Complex.num(Double.NaN, Imaginary(Double.NaN)));

        final c1 = Complex(2, 3);
        expect(c1 / Integer(1), Complex(2, 3));
        expect(c1 / Integer(4), Complex(0.5, 0.75));
        expect(c1 / Integer(0),
            Complex.num(Double.infinity, Imaginary(Double.infinity)));

        final c2 = Complex(-5, -2);
        expect(c2 / Integer(4), Complex(-1.25, -0.5));
        expect(c2 / Integer(-4), Complex(1.25, 0.5));
        expect(c2 / Integer(0),
            Complex.num(Double.negInfinity, Imaginary(Double.negInfinity)));
      });

      test('operator / Double', () {
        final c0 = Complex(0, 0);
        expect(c0 / Double(1), Integer(0));
        expect(c0 / Double(1) is Integer, true);
        expect(c0 / Double(3.3), Integer(0));
        expect(c0 / Double(3.3) is Integer, true);
        expect(c0 / Double(-9.9), Integer(0));
        expect(c0 / Double(-9.9) is Integer, true);
        expect(c0 / Double(0), Complex.num(Double.NaN, Imaginary(Double.NaN)));

        final c1 = Complex(2, 3);
        expect(c1 / Double(0.5), Complex(4, 6));
        expect(c1 / Double(-0.25), Complex(-8, -12));
        expect(c1 / Double(0),
            Complex.num(Double.infinity, Imaginary(Double.infinity)));

        final c2 = Complex(-5, -2);
        expect(c2 / Double(0.2), Complex(-25, -10));
        expect(c2 / Double(-0.1), Complex(50, 20));
        expect(c2 / Double(0),
            Complex.num(Double.negInfinity, Imaginary(Double.negInfinity)));
      });

      test('operator / Imaginary', () {
        final c0 = Complex(0, 0);
        expect(c0 / Imaginary(1), Integer(0));
        expect(c0 / Imaginary(1) is Integer, true);
        expect(c0 / Imaginary(3), Integer(0));
        expect(c0 / Imaginary(3) is Integer, true);
        expect(c0 / Imaginary(-9), Integer(0));
        expect(c0 / Imaginary(-9) is Integer, true);
        expect(
            c0 / Imaginary(0), Complex.num(Double.NaN, Imaginary(Double.NaN)));

        final c1 = Complex(2, 8);
        expect(c1 / Imaginary(1), Complex(8, -2));
        expect(c1 / Imaginary(4), Complex(2, -0.5));
        expect(c1 / Imaginary(0),
            Complex.num(Double.infinity, Imaginary(Double.negInfinity)));

        final c2 = Complex(-5, -2);
        expect(c2 / Imaginary(4), Complex(-0.5, 1.25));
        expect(c2 / Imaginary(-4), Complex(0.5, -1.25));
        expect(c2 / Imaginary(0),
            Complex.num(Double.negInfinity, Imaginary(Double.infinity)));
      });

      test('operator / Complex', () {
        final c0 = Complex(0, 0);
        expect(c0 / Complex(1, 1), Integer(0));
        expect(c0 / Complex(1, 1) is Integer, true);
        expect(c0 / Complex(3, 3), Integer(0));
        expect(c0 / Complex(3, 3) is Integer, true);
        expect(c0 / Complex(-9.9, -9.9), Integer(0));
        expect(c0 / Complex(-9.9, -9.9) is Integer, true);
        expect(c0 / Complex(1, 0), Integer(0));
        expect(c0 / Complex(0, 1), Integer(0));
        expect(
            c0 / Complex(0, 0), Complex.num(Double.NaN, Imaginary(Double.NaN)));

        final c1 = Complex(2, 8);
        expect(c1 / Complex(1, 1), Complex(5, 3));
        expect(c1 / Complex(4, 2), Complex(1.2, 1.4));
        expect(c1 / Complex(1, 0), Complex(2, 8));
        expect(c1 / Complex(0, 1), Complex(8, -2));
        expect(
            c1 / Complex(0, 0), Complex.num(Double.NaN, Imaginary(Double.NaN)));

        final c2 = Complex(-5, -2);
        expect(c2 / Complex(4, 2), Complex(-1.2, 0.1));
        expect(c2 / Complex(-4, -2), Complex(1.2, -0.1));
        expect(c2 / Complex(1, 0), Complex(-5, -2));
        expect(c2 / Complex(0, 1), Complex(-2, 5));
        expect(
            c2 / Complex(0, 0), Complex.num(Double.NaN, Imaginary(Double.NaN)));

        final c3 = Complex(3, 2);
        expect(c3 / Complex(4, -3), Complex(0.24, 0.68));
      });
    });

    group('operator ~/', () {
      test('operator ~/ num', () {
        final c0 = Complex(0, 0);
        expect(c0 ~/ 1, Complex(0, 0));

        final c1 = Complex(45, 65);
        expect(c1 ~/ 1, Complex(45, 65));
        expect(c1 ~/ 5, Complex(9, 13));
        expect(c1 ~/ -5, Complex(-9, -13));
        expect(c1 ~/ 5.1, Complex(8, 12));
        expect(c1 ~/ -5.1, Complex(-8, -12));
      });

      test('operator ~/ Integer', () {
        final c0 = Complex(0, 0);
        expect(c0 ~/ Integer(1), Complex(0, 0));

        final c1 = Complex(45, 65);
        expect(c1 ~/ Integer(1), Complex(45, 65));
        expect(c1 ~/ Integer(5), Complex(9, 13));
        expect(c1 ~/ Integer(-5), Complex(-9, -13));
      });

      test('operator ~/ Double', () {
        final c0 = Complex(0, 0);
        expect(c0 ~/ Double(1.5), Complex(0, 0));

        final c1 = Complex(45, 65);
        expect(c1 ~/ Double(5.1), Complex(8, 12));
        expect(c1 ~/ Double(-5.1), Complex(-8, -12));
      });

      test('operator ~/ Imaginary', () {
        final c0 = Complex(0, 0);
        expect(c0 ~/ Imaginary(1.5), Complex(0, 0));

        final c1 = Complex(45, 65);
        expect(c1 ~/ Imaginary(5), Complex(13, -9));
        expect(c1 ~/ Imaginary(-5.1), Complex(-12, 8));
      });
    });

    group('operator ^', () {
      test('operator ^ num', () {
        final c0 = Complex(4, 3) ^ 0;
        expect(c0, Integer(1));
        expect(c0, isA<Integer>());

        final c1 = Complex(4, 3) ^ 1 as Complex;
        expect(c1, Complex(4, 3));

        final c2 = Complex(4, 3) ^ 4 as Complex;
        expect(c2.real.toDouble(), -527);
        expect(c2.imag.value.toDouble(), closeTo(336, 0.000000000001));
      });

      test('operator ^ Integer', () {
        final c0 = Complex(4, 3) ^ Integer(0);
        expect(c0, Integer(1));
        expect(c0, isA<Integer>());

        final c1 = Complex(4, 3) ^ Integer(1) as Complex;
        expect(c1, Complex(4, 3));

        final c2 = Complex(4, 3) ^ Integer(4) as Complex;
        expect(c2.real.toDouble(), -527);
        expect(c2.imag.value.toDouble(), closeTo(336, 0.000000000001));
      });

      test('operator ^ Double', () {
        final c0 = Complex(4, 3) ^ Double(0);
        expect(c0, Integer(1));
        expect(c0, isA<Integer>());

        final c1 = Complex(4, 3) ^ Double(1) as Complex;
        expect(c1, Complex(4, 3));

        final c2 = Complex(4, 3) ^ Double(4) as Complex;
        expect(c2.real.toDouble(), -527);
        expect(c2.imag.value.toDouble(), closeTo(336, 0.000000000001));
      });

      test('operator ^ Imaginary (exception)', () {
        final c0 = Complex(1, 2) ^ Imaginary(3) as Complex;
        expect(c0.real.toDouble(), -0.02696287673540687);
        expect(c0.imag.value.toDouble(), 0.024005325657235826);
      });

      test('operator ^ Complex (exception)', () {
        expect((Complex(1, 2) ^ Complex(2, 5)) as Complex,
            Complex(0.01969615658538202, -0.0008927103407394184));
      });
    });

    test('operator % (exception)', () {
      expect(
          Complex(1, 2) % 2, Complex(0.1055728090000842, 0.21114561800016834));
    });

    test('negation operator -', () {
      expect(-Complex(1, 2), Complex(-1, -2));
      expect(-Complex(0, -2), Complex(0, 2));
      expect(-Complex(-1, 0), Complex(1, 0));
    });

    group('operator <', () {
      test('operator < num', () {
        expect(Complex(6, 2) < 4, false);
        expect(Complex(6, 6) < 6, false);
        expect(Complex(2, 8) < 4, true);

        expect(Complex(6, 2) < 4.5, false);
        expect(Complex(6, 6) < 6.0, false);
        expect(Complex(2, 8) < 4.5, true);
      });

      test('operator < Integer', () {
        expect(Complex(6, 2) < Integer(4), false);
        expect(Complex(6, 6) < Integer(6), false);
        expect(Complex(2, 8) < Integer(4), true);
      });

      test('operator < Double', () {
        expect(Complex(6, 2) < Double(4.5), false);
        expect(Complex(6.1, 6.1) < Double(6.1), false);
        expect(Complex(2, 8) < Double(4.5), true);
      });

      test('operator < Imaginary', () {
        expect(Complex(1, 2) < Imaginary(4.5), false);
        expect(Complex(6.1, 6.1) < Imaginary(6.1), false);
        expect(Complex(-2, 8) < Imaginary(-4.5), true);
      });

      test('operator < Complex', () {
        expect(Complex(1, 2) < Complex(0.5, 4), false);
        expect(Complex(6.1, 6.1) < Complex(6.1, 6.1), false);
        expect(Complex(-2, 8) < Complex(-1.5, 9), true);
      });

      test('operator < Precise', () {
        expect(Complex(6, 2) < Precision('4.5'), false);
        expect(Complex(6.1, 6.1) < Precision('6.10000000000000000000'), false);
        expect(Complex(2, 8) < Precision('4.5'), true);
      });
    });

    group('operator <=', () {
      test('operator <= num', () {
        expect(Complex(6, 2) <= 4, false);
        expect(Complex(6, 6) <= 6, true);
        expect(Complex(2, 8) <= 4, true);

        expect(Complex(6, 2) <= 4.5, false);
        expect(Complex(6, 6) <= 6.0, true);
        expect(Complex(2, 8) <= 4.5, true);
      });

      test('operator <= Integer', () {
        expect(Complex(6, 2) <= Integer(4), false);
        expect(Complex(6, 6) <= Integer(6), true);
        expect(Complex(2, 8) <= Integer(4), true);
      });

      test('operator <= Double', () {
        expect(Complex(6, 2) <= Double(4.5), false);
        expect(Complex(6.1, 6.1) <= Double(6.1), true);
        expect(Complex(2, 8) <= Double(4.5), true);
      });

      test('operator <= Imaginary', () {
        expect(Complex(1, 2) <= Imaginary(4.5), false);
        expect(Complex(6.1, 6.1) <= Imaginary(6.1), false);
        expect(Complex(-2, 8) <= Imaginary(-4.5), true);
      });

      test('operator < Complex', () {
        expect(Complex(1, 2) <= Complex(0.5, 4), false);
        expect(Complex(6.1, 6.1) <= Complex(6.1, 6.1), true);
        expect(Complex(-2, 8) <= Complex(-1.5, 9), true);
      });

      test('operator < Precise', () {
        expect(Complex(6, 2) <= Precision('4.5'), false);
        expect(Complex(6.1, 6.1) <= Precision('6.10000000000000000000'), true);
        expect(Complex(2, 8) <= Precision('4.5'), true);
      });
    });

    group('operator >', () {
      test('operator > num', () {
        expect(Complex(6, 2) > 4, true);
        expect(Complex(6, 6) > 6, false);
        expect(Complex(2, 8) > 4, false);

        expect(Complex(6, 2) > 4.5, true);
        expect(Complex(6, 6) > 6.0, false);
        expect(Complex(2, 8) > 4.5, false);
      });

      test('operator > Integer', () {
        expect(Complex(6, 2) > Integer(4), true);
        expect(Complex(6, 6) > Integer(6), false);
        expect(Complex(2, 8) > Integer(4), false);
      });

      test('operator > Double', () {
        expect(Complex(6, 2) > Double(4.5), true);
        expect(Complex(6.1, 6.1) > Double(6.1), false);
        expect(Complex(2, 8) > Double(4.5), false);
      });

      test('operator > Imaginary', () {
        expect(Complex(1, 2) > Imaginary(4.5), true);
        expect(Complex(6.1, 6.1) > Imaginary(6.1), true);
        expect(Complex(-2, 8) > Imaginary(-4.5), false);
      });

      test('operator > Complex', () {
        expect(Complex(1, 2) > Complex(0.5, 4), true);
        expect(Complex(6.1, 6.1) > Complex(6.1, 6.1), false);
        expect(Complex(-2, 8) > Complex(-1.5, 9), false);
      });

      test('operator > Precise', () {
        expect(Complex(6, 2) > Precision('4.5'), true);
        expect(Complex(6.1, 6.1) > Precision('6.10000000000000000000'), false);
        expect(Complex(2, 8) > Precision('4.5'), false);
      });
    });

    group('operator >=', () {
      test('operator >= num', () {
        expect(Complex(6, 2) >= 4, true);
        expect(Complex(6, 6) >= 6, true);
        expect(Complex(2, 8) >= 4, false);

        expect(Complex(6, 2) >= 4.5, true);
        expect(Complex(6, 6) >= 6.0, true);
        expect(Complex(2, 8) >= 4.5, false);
      });

      test('operator >= Integer', () {
        expect(Complex(6, 2) >= Integer(4), true);
        expect(Complex(6, 6) >= Integer(6), true);
        expect(Complex(2, 8) >= Integer(4), false);
      });

      test('operator >= Double', () {
        expect(Complex(6, 2) >= Double(4.5), true);
        expect(Complex(6.1, 6.1) >= Double(6.1), true);
        expect(Complex(2, 8) >= Double(4.5), false);
      });

      test('operator >= Imaginary', () {
        expect(Complex(1, 2) >= Imaginary(4.5), true);
        expect(Complex(6.1, 6.1) >= Imaginary(6.1), true);
        expect(Complex(-2, 8) >= Imaginary(-4.5), false);
      });

      test('operator >= Complex', () {
        expect(Complex(1, 2) >= Complex(0.5, 4), true);
        expect(Complex(6.1, 6.1) >= Complex(6.1, 6.1), true);
        expect(Complex(-2, 8) >= Complex(-1.5, 9), false);
      });

      test('operator >= Precise', () {
        expect(Complex(6, 2) >= Precision('4.5'), true);
        expect(Complex(6.1, 6.1) >= Precision('6.10000000000000000000'), true);
        expect(Complex(2, 8) >= Precision('4.5'), false);
      });
    });

    group('operator ==', () {
      test('operator == num', () {
        // ignore: unrelated_type_equality_checks
        expect(Complex(5, 0) == 5, true);
        // ignore: unrelated_type_equality_checks
        expect(Complex(5, 1) == 5, false);
        // ignore: unrelated_type_equality_checks
        expect(Complex(5.5, 0) == 5.5, true);
        // ignore: unrelated_type_equality_checks
        expect(Complex(5.5, -1) == 5.5, false);
      });

      test('operator == Integer', () {
        // ignore: unrelated_type_equality_checks
        expect(Complex(5, 0) == Integer(5), true);
        // ignore: unrelated_type_equality_checks
        expect(Complex(5, 1) == Integer(5), false);
      });

      test('operator == Double', () {
        // ignore: unrelated_type_equality_checks
        expect(Complex(5.5, 0) == Double(5.5), true);
        // ignore: unrelated_type_equality_checks
        expect(Complex(5.5, -1) == Double(5.5), false);
      });

      test('operator == Imaginary', () {
        expect(Complex(0, 5.5) == Imaginary(5.5), true);
        expect(Complex(5.5, 5.5) == Imaginary(5.5), false);
      });

      test('operator == Complex', () {
        expect(Complex(0, 5.5) == Complex(0, 5.5), true);
        expect(Complex(5.5, 5.5) == Complex(5, 5.5), false);
        expect(Complex(5.5, 0) == Complex(5.5, 0), true);
        expect(Complex(-2.5, -5.5) == Complex(2.5, 5.5), false);
        expect(Complex(-2.5, -5.5) == Complex(-2.5, -5.5), true);
      });

      test('operator == Precise', () {
        // ignore: unrelated_type_equality_checks
        expect(Complex(5.5, 0) == Precision('5.5000000'), true);
        // ignore: unrelated_type_equality_checks
        expect(Complex(5.5, -1) == Precision('5.5'), false);
        // ignore: unrelated_type_equality_checks
        expect(
            Complex(5.5, 0) == Precision('5.50000000000000000000001'), false);
      });

      test('operator == Reals', () {
        expect(Complex.num(Integer(0), Imaginary(8)), Imaginary(8));
        expect(Complex.num(Double(0), Imaginary(Double(8))),
            Imaginary(Integer(8)));
        expect(Complex.num(Double(8), Imaginary(0)), Double(8));
        expect(Complex.num(Integer(5), Imaginary(8)),
            Complex.num(Integer(5), Imaginary(8)));
        expect(Complex.num(Double(5), Imaginary(8)),
            Complex.num(Integer(5), Imaginary(8)));
        expect(Complex.num(Integer(5), Imaginary(Integer(8))),
            Complex.num(Integer(5), Imaginary(8)));
        expect(Complex.num(Integer(5), Imaginary(Double(8))),
            Complex.num(Integer(5), Imaginary(8)));
        expect(Complex.num(Double(5), Imaginary(Double(8))),
            Complex.num(Integer(5), Imaginary(8)));
        expect(Complex.num(Precision('5.00000'), Imaginary(Double(8))),
            Complex.num(Integer(5), Imaginary(8)));
        expect(Complex.num(Precision('5.00000'), Imaginary(Precision('8'))),
            Complex.num(Integer(5), Imaginary(8)));
      });
    });

    test('abs()', () {
      expect(Complex.num(Integer(0), Imaginary(8)).abs(), Integer(8));
      expect(Complex.num(Integer(0), Imaginary(8)).abs() is Integer, true);
      expect(Complex.num(Integer(22), Imaginary(0)).abs(), Integer(22));
      expect(Complex.num(Integer(3), Imaginary(4)).abs(), Integer(5));
      expect(Complex.num(Integer(4), Imaginary(5)).abs(), Double(sqrt(41)));
      expect(Complex.num(Integer(4), Imaginary(5)).abs() is Double, true);
    });

    test('complexModulus', () {
      expect(Complex.num(Integer(0), Imaginary(8)).complexModulus, Integer(8));
      expect(Complex.num(Integer(0), Imaginary(8)).complexModulus is Integer,
          true);
      expect(
          Complex.num(Integer(22), Imaginary(0)).complexModulus, Integer(22));
      expect(Complex.num(Integer(3), Imaginary(4)).complexModulus, Integer(5));
      expect(Complex.num(Integer(4), Imaginary(5)).complexModulus,
          Double(sqrt(41)));
      expect(
          Complex.num(Integer(4), Imaginary(5)).complexModulus is Double, true);
    });

    test('complexNorm', () {
      expect(Complex.num(Integer(0), Imaginary(8)).complexNorm, Integer(8));
      expect(
          Complex.num(Integer(0), Imaginary(8)).complexNorm is Integer, true);
      expect(Complex.num(Integer(22), Imaginary(0)).complexNorm, Integer(22));
      expect(Complex.num(Integer(3), Imaginary(4)).complexNorm, Integer(5));
      expect(
          Complex.num(Integer(4), Imaginary(5)).complexNorm, Double(sqrt(41)));
      expect(Complex.num(Integer(4), Imaginary(5)).complexNorm is Double, true);
    });

    test('absoluteSquare', () {
      expect(Complex.num(Integer(3), Imaginary(4)).absoluteSquare, Double(25));
      expect(Complex.num(Integer(4), Imaginary(5)).absoluteSquare, Double(41));
    });

    test('ceil', () {
      expect(Complex.num(Double(3.2), Imaginary(43)).ceil(), Integer(4));
      expect(Complex.num(Double(-4.9), Imaginary(55)).ceil(), Integer(-4));
    });

    test('clamp', () {
      expect(Complex.num(Double(3.2), Imaginary(43)).clamp(0, 2),
          Complex.num(Integer(2), Imaginary(43)));
      expect(Complex.num(Double(-4.9), Imaginary(55)).clamp(-4.5, -2.1),
          Complex(-4.5, 55));
    });

    test('complexArgument', () {
      expect(Complex(1, 0).complexArgument, Integer(0));
      expect(Complex(1, 1).complexArgument, Double(0.25 * pi));
      expect(Complex(0, 1).complexArgument, Double(0.5 * pi));
      expect(Complex(-1, 0).complexArgument, Double(pi));
      expect(Complex(0, -1).complexArgument, Double(-0.5 * pi));
    });

    test('phase', () {
      expect(Complex(1, 0).phase, Integer(0));
      expect(Complex(1, 1).phase, Double(0.25 * pi));
      expect(Complex(0, 1).phase, Double(0.5 * pi));
      expect(Complex(-1, 0).phase, Double(pi));
      expect(Complex(0, -1).phase, Double(-0.5 * pi));
    });

    test('floor', () {
      expect(Complex.num(Double(3.2), Imaginary(43)).floor(), Integer(3));
      expect(Complex.num(Double(-4.9), Imaginary(55)).floor(), Integer(-5));
    });

    test('isInfinite', () {
      expect(Complex(0, 0).isInfinite, false);
      expect(Complex(1, 1).isInfinite, false);
      expect(Complex(double.infinity, 1).isInfinite, true);
      expect(Complex(double.negativeInfinity, 1).isInfinite, true);
      expect(Complex(1, double.infinity).isInfinite, false);
      expect(Complex(1, double.negativeInfinity).isInfinite, false);
      expect(Complex.num(Double.infinity, Imaginary(1)).isInfinite, true);
      expect(Complex.num(Double.negInfinity, Imaginary(1)).isInfinite, true);
      expect(
          Complex.num(Double(1), Imaginary(double.infinity)).isInfinite, false);
      expect(Complex.num(Double(1), Imaginary(Double.negInfinity)).isInfinite,
          false);
    });

    test('isInteger', () {
      expect(Complex(0, 0.3).isInteger, true);
      expect(Complex(1, 1.6).isInteger, true);
      expect(Complex(0.5, 0).isInteger, false);
      expect(Complex(1.3, 6).isInteger, false);
    });

    test('isNaN', () {
      expect(Complex(0, 0).isNaN, false);
      expect(Complex(double.nan, 5).isNaN, true);
      expect(Complex(5, double.nan).isNaN, false);
    });

    test('reciprocal', () {
      expect(Complex(2, 4).reciprocal(), Complex(0.1, -0.2));
      expect(Complex(-2, -4).reciprocal(), Complex(-0.1, 0.2));
      expect(Complex(0, 0).reciprocal(), Complex(double.nan, double.nan));
    });

    test('isNegative', () {
      expect(Complex(0, 0).isNegative, false);
      expect(Complex(0, -1).isNegative, false);
      expect(Complex(1, -1).isNegative, false);
      expect(Complex(-1, 1).isNegative, true);
    });

    test('round', () {
      expect(Complex(2.8, 4.3).round(), Integer(3));
      expect(Complex(2.5, 4.3).round(), Integer(3));
      expect(Complex(2.499, 4.3).round(), Integer(2));
      expect(Complex(-2.8, 4.3).round(), Integer(-3));
      expect(Complex(-2.5, 4.3).round(), Integer(-3));
      expect(Complex(-2.499, 4.3).round(), Integer(-2));
    });

    test('truncate', () {
      expect(Complex(2.8, 4.3).truncate(), Integer(2));
      expect(Complex(2.5, 4.3).truncate(), Integer(2));
      expect(Complex(2.99999, 4.3).truncate(), Integer(2));
      expect(Complex(-2.8, 4.3).truncate(), Integer(-2));
      expect(Complex(-2.5, 4.3).truncate(), Integer(-2));
      expect(Complex(-3, 4.3).truncate(), Integer(-3));
    });

    test('toInt', () {
      expect(Complex(2.8, 4.3).toInt(), 2);
      expect(Complex(2.5, 4.3).toInt(), 2);
      expect(Complex(2.99999, 4.3).toInt(), 2);
      expect(Complex(-2.8, 4.3).toInt(), -2);
      expect(Complex(-2.5, 4.3).toInt(), -2);
      expect(Complex(-3, 4.3).toInt(), -3);
    });

    test('toDouble', () {
      expect(Complex(2.8, 4.3).toDouble(), 2.8);
      expect(Complex(2.99999, 4.3).toDouble(), 2.99999);
      expect(Complex(-2.8, 4.3).toDouble(), -2.8);
      expect(Complex(-3, 4.3).toDouble(), -3);
    });

    test('remainder', () {
      expect(Complex(2.8, 4.3).remainder(2).toDouble(), closeTo(0.8, 0.000001));
      expect(
          Complex(-2.8, 4.3).remainder(2).toDouble(), closeTo(-0.8, 0.000001));
    });

    test('toJson', () {
      final c = Complex(-9.34, 5);
      final json = c.toJson();
      expect(json['real'], isA<Map<String, dynamic>>());
      expect(json['real']['d'], -9.34);
      expect(json['imag'], isA<Map<String, dynamic>>());
      expect(json['imag']['imag'], isA<Map<String, dynamic>>());
      expect(json['imag']['imag']['i'], 5);
    });

    test('remainder', () {
      expect(Complex(2.8, 4.3).toString(), '2.8 + 4.3i');
      expect(Complex(-2.8, -4.3).toString(), '-2.8 - 4.3i');
    });
  });
}
