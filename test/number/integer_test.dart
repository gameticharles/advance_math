import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Integer', () {
    test('constants', () {
      const d = Integer.constant(42);
      expect(d.value, 42);
      expect(Integer.zero.value, 0);
      expect(Integer.one.value, 1);
      expect(Integer.ten.value, 10);
      expect(Integer.hundred.value, 100);
      expect(Integer.thousand.value, 1000);
    });

    test('operator ==', () {
      final d = Integer(42);
      final d2 = Integer(14);
      final d3 = Integer(42);
      final d4 = Integer(44);
      final d5 = Integer(44.234.toInt());
      expect(d == d, true);
      expect(d == d2, false);
      expect(d == d3, true);
      // ignore: unrelated_type_equality_checks
      expect(d == 42, true);
      // ignore: unrelated_type_equality_checks
      expect(d == 42.000, true);
      // ignore: unrelated_type_equality_checks
      expect(d == 42.0000001, false);
      expect(d4 == d5, true);

      // equality with nums
      // ignore: unrelated_type_equality_checks
      expect(d4 == 44, true);
      // ignore: unrelated_type_equality_checks
      expect(d5 == 44, true);
      // ignore: unrelated_type_equality_checks
      expect(d4 == 44.0, true);
      // ignore: unrelated_type_equality_checks
      expect(d5 == 44.0, true);

      // equality with complex
      final c1 = Complex.num(Integer(42), Imaginary(0.0));
      // ignore: unrelated_type_equality_checks
      expect(d == c1, true);
      final c2 = Complex.num(Integer(42), Imaginary(0.1));
      // ignore: unrelated_type_equality_checks
      expect(d == c2, false);
      final c3 = Complex.num(Integer(41), Imaginary(0.0));
      // ignore: unrelated_type_equality_checks
      expect(d == c3, false);
    });

    test('hashcode', () {
      expect(Double.NaN.hashCode, double.nan.hashCode);
      expect(Double.infinity.hashCode, double.infinity.hashCode);
      expect(Double.negInfinity.hashCode, double.negativeInfinity.hashCode);
      expect(Integer(0).hashCode, 0.hashCode);
      expect(Integer(1).hashCode, 1.hashCode);
      expect(Integer(-5).hashCode, (-5).hashCode);
      expect(Integer(99).hashCode, Precision('99').hashCode);
      expect(Integer(-99).hashCode, Precision('-99').hashCode);
      expect(Integer(-99).hashCode == Integer(99).hashCode, false);
    });

    test('operator +', () {
      final d = Integer(42);

      // + int
      expect(d + 77 is Integer, true);
      expect((d + 77 as Integer).value == 119, true);
      expect(d + -53 is Integer, true);
      expect((d + -53 as Integer).value == -11, true);

      // + double
      expect(d + 6.5 is Double, true);
      expect((d + 6.5 as Double).value == 48.5, true);
      expect(d + -12.3 is Double, true);
      expect((d + -12.3 as Double).value == 29.7, true);

      // + Integer
      final d2 = Integer(14);
      expect(d + d2 is Integer, true);
      expect((d + d2 as Integer).value == 56, true);
      final d3 = Integer(-901);
      expect(d + d3 is Integer, true);
      expect((d + d3 as Integer).value == -859, true);

      // + Imaginary
      final i = Imaginary(34.21);
      expect(d + i is Complex, true);
      expect((d + i as Complex).real.value == 42, true);
      // ignore: unrelated_type_equality_checks
      expect((d + i as Complex).imag.value == 34.21, true);
      final i2 = Imaginary(-8);
      expect(d + i2 is Complex, true);
      expect((d + i2 as Complex).real.value == 42, true);
      // ignore: unrelated_type_equality_checks
      expect((d + i2 as Complex).imag.value == -8, true);

      // + Complex
      var cx = Complex.num(Double(2.1), Imaginary(9.6));
      dynamic sum = d + cx;
      expect(sum is Complex, true);
      expect((sum as Complex).real.toDouble(), closeTo(44.1, 0.000001));
      expect(sum.imag.value.toDouble(), 9.6);
      cx = Complex.num(Double(-2.1), Imaginary(-9.6));
      sum = d + cx;
      expect(sum is Complex, true);
      expect((sum as Complex).real.toDouble(), closeTo(39.9, 0.000001));
      expect(sum.imag.value.toDouble(), -9.6);

      // + Precise
      var p = Precision('34.21');
      expect(d + p is Precision, true);
      expect((d + p as Precision).value == 76.21, true);
      p = Precision('-21.7');
      expect(d + p is Precision, true);
      expect((d + p as Precision).value == 20.3, true);
    });

    test('operator -', () {
      final i = Integer(42);

      // - int
      var diff = i - 3;
      expect(diff is Integer, true);
      expect((diff as Integer).value.toInt(), 39);
      diff = i - (-4);
      expect(diff is Integer, true);
      expect((diff as Integer).value.toDouble(), 46);

      // - double
      diff = i - 5.1;
      expect(diff is Double, true);
      expect((diff as Double).value.toDouble(), 36.9);
      diff = i - (-5.1);
      expect(diff is Double, true);
      expect((diff as Double).value.toDouble(), 47.1);

      // - Integer
      var a = Integer(4);
      diff = i - a;
      expect(diff is Integer, true);
      expect(diff, Integer(38));
      a = Integer(-2);
      diff = i - a;
      expect(diff is Integer, true);
      expect(diff, Integer(44));

      // - Double
      final d = Double(14.265);
      diff = i - d;
      expect(diff is Double, true);
      expect((diff as Double).value, closeTo(27.735, 0.000001));

      // - Imaginary
      var imag = Imaginary(34.21);
      diff = i - imag;
      expect(diff is Complex, true);
      expect((diff as Complex).real.toInt(), 42);
      expect(diff.imag.value.toDouble(), closeTo(-34.21, 0.000001));
      imag = Imaginary(-6);
      diff = i - imag;
      expect(diff is Complex, true);
      expect((diff as Complex).real.toInt(), 42);
      expect(diff.imag.value.toDouble(), 6);

      // - Complex
      var cx = Complex.num(Double(2), Imaginary(9.6));
      diff = i - cx;
      expect(diff is Complex, true);
      expect((diff as Complex).real.toInt(), 40);
      expect(diff.imag.value.toDouble(), -9.6);
      cx = Complex.num(Double(-2.1), Imaginary(-9.6));
      diff = i - cx;
      expect(diff is Complex, true);
      expect((diff as Complex).real.toDouble(), closeTo(44.1, 0.000001));
      expect(diff.imag.value.toDouble(), 9.6);

      // - Precise
      var p = Precision('1');
      diff = i - p;
      expect(diff is Precision, true);
      expect(diff, Precision('41'));
      p = Precision('-1.013');
      diff = i - p;
      expect(diff is Precision, true);
      expect(diff, Precision('43.013'));
    });

    test('operator unary-', () {
      final i0 = Integer(0);
      final i1 = Integer(1);
      final iNeg2 = Integer(-2);
      expect(-i0, Integer(0));
      expect(-i1, Integer(-1));
      expect(-iNeg2, Integer(2));
    });

    test('operator *', () {
      final d = Integer(5);

      // * int
      var prod = d * 3;
      expect(prod is Integer, true);
      expect((prod as Integer).value.toInt(), 15);
      prod = d * (-6);
      expect(prod is Integer, true);
      expect((prod as Integer).value.toDouble(), -30);

      // * double
      prod = d * 2.1;
      expect(prod is Double, true);
      expect((prod as Double).value.toDouble(), closeTo(10.5, 0.000001));
      prod = d * (-1.2);
      expect(prod is Integer, true);
      expect((prod as Integer).value.toInt(), -6);

      // * Integer
      var a = Integer(4);
      prod = d * a;
      expect(prod is Integer, true);
      expect(prod, Integer(20));
      a = Integer(-2);
      prod = d * a;
      expect(prod is Integer, true);
      expect(prod, Integer(-10));

      // * Double
      final d2 = Double(-3.1);
      prod = d * d2;
      expect(prod is Double, true);
      expect((prod as Double).value, closeTo(-15.5, 0.000001));

      // * Imaginary
      var i = Imaginary(2.3);
      prod = d * i;
      expect(prod is Imaginary, true);
      expect((prod as Imaginary).value.toDouble(), closeTo(11.5, 0.000001));
      i = Imaginary(-6);
      prod = d * i;
      expect(prod is Imaginary, true);
      expect((prod as Imaginary).value is Integer, true);
      expect(prod.value.toInt(), -30);

      // * Complex
      var cx = Complex.num(Double(2.1), Imaginary(9.6));
      prod = d * cx;
      expect(prod is Complex, true);
      expect((prod as Complex).real.toDouble(), closeTo(10.5, 0.000001));
      expect(prod.imag.value is Integer, true);
      expect(prod.imag.value.toDouble(), 48);
      cx = Complex.num(Double(-2.1), Imaginary(-9.6));
      prod = d * cx;
      expect(prod is Complex, true);
      expect((prod as Complex).real.toDouble(), closeTo(-10.5, 0.000001));
      expect(prod.imag.value is Integer, true);
      expect(prod.imag.value.toDouble(), -48);

      // * Precise
      var p = Precision('1.013');
      prod = d * p;
      expect(prod is Precision, true);
      expect(prod, Precision('5.065'));
      p = Precision('-1.013');
      prod = d * p;
      expect(prod is Precision, true);
      expect(prod, Precision('-5.065'));
    });

    test('operator /', () {
      final d = Integer(4);

      // / int
      var quot = d / 8;
      expect(quot is Double, true);
      expect((quot as Double).value.toDouble(), closeTo(0.5, 0.000001));
      quot = d / (-6);
      expect(quot is Double, true);
      expect(
          (quot as Double).value.toDouble(), closeTo(-0.666666666, 0.000001));

      // * double
      quot = d / 0.1;
      expect(quot is Integer, true);
      expect((quot as Integer).value.toInt(), 40);
      quot = d / (-0.044);
      expect(quot is Double, true);
      expect((quot as Double).value.toDouble(),
          closeTo(-90.90909090909092, 0.000001));

      // / Integer
      var a = Integer(16);
      quot = d / a;
      expect(quot is Double, true);
      expect(quot, Double(0.25));
      a = Integer(-2);
      quot = d / a;
      expect(quot is Integer, true);
      expect(quot, Integer(-2));

      // / Double
      final d2 = Double(3.4);
      quot = d / d2;
      expect(quot is Double, true);
      expect((quot as Double).value, closeTo(1.17647058823529422, 0.000000001));
      final d3 = Double(-0.2);
      quot = d / d3;
      expect(quot is Integer, true);
      expect((quot as Integer).value, -20);

      // / Imaginary
      var i = Imaginary(8);
      quot = d / i;
      expect(quot is Imaginary, true);
      expect((quot as Imaginary).value.toDouble(), closeTo(-0.5, 0.000001));
      i = Imaginary(-2);
      quot = d / i;
      expect(quot is Imaginary, true);
      expect((quot as Imaginary).value is Integer, true);
      expect(quot.value.toInt(), 2);

      // / Complex
      // (a + 0i) / (c + di) = (ac - adi) / (c^2 + d^2)
      var cx = Complex.num(Double(1), Imaginary(2));
      quot = Integer(4) / cx;
      expect(quot is Complex, true);
      expect((quot as Complex).real.toDouble(), closeTo(0.8, 0.000001));
      expect(quot.imag.value.toDouble(), -1.6);
      cx = Complex.num(Double(-1), Imaginary(-2));
      quot = Integer(4) / cx;
      expect(quot is Complex, true);
      expect((quot as Complex).real.toDouble(), closeTo(-0.8, 0.000001));
      expect(quot.imag.value.toDouble(), 1.6);

      // / Precise
      var p = Precision('16.00');
      quot = d / p;
      expect(quot is Precision, true);
      expect(quot, Precision('0.25'));
      p = Precision('-4.876876858');
      quot = d / p;
      expect(quot is Precision, true);
      expect(quot.toDouble(), closeTo(-0.0821970475097036, 0.000000000000001));
      expect(Integer(0) / Precision('0'), Double.NaN);
      expect(Integer(1) / Precision('0'), Double.infinity);
      expect(Integer(-1) / Precision('0'), Double.negInfinity);
    });

    test('operator ~/', () {
      final d = Integer(43);

      // ~/ int
      var n = d ~/ 8;
      expect(n is Integer, true);
      expect((n as Integer).value.toInt(), 5);
      n = d ~/ (-6);
      expect(n is Integer, true);
      expect((n as Integer).value.toInt(), -7);
      n = d ~/ 1;
      expect(n is Integer, true);
      expect(n, Integer(43));

      // * double
      n = d ~/ 2.01;
      expect((n as Integer).value.toInt(), 21);
      n = d ~/ (-0.4);
      expect((n as Integer).value.toInt(), -107);

      // / Integer
      var a = Integer(16);
      n = d ~/ a;
      expect(n, Integer(2));
      a = Integer(-2);
      n = d ~/ a;
      expect(n, Integer(-21));

      // / Double
      final d2 = Double(3.4);
      n = d ~/ d2;
      expect(n, Integer(12));
      final d3 = Double(-0.2);
      n = d ~/ d3;
      expect(n, Integer(-215));

      // / Imaginary
      var i = Imaginary(8);
      n = d ~/ i;
      expect(n, Imaginary(-5));
      i = Imaginary(-2);
      n = d ~/ i;
      expect(n, Imaginary(21));

      // / Complex
      // (a + 0i) / (c + di) = (ac - adi) / (c^2 + d^2)
      final cx = Complex.num(Double(1), Imaginary(2));
      n = Integer(12) ~/ cx;
      expect(n is Complex, true);
      expect((n as Complex).real is Integer, true);
      expect(n.real, Integer(2));
      expect(n.imag.value.toDouble(), -24 / 5);

      // / Precise
      var p = Precision('16.00');
      n = d ~/ p;
      expect(n is Precision, true);
      expect(n, Precision('2.0'));
      p = Precision('-4.876876858');
      n = d ~/ p;
      expect(n is Precision, true);
      expect(n, Precision('-8.0'));
    });

    test('operator <', () {
      expect(Integer(1) < 0.5, false);
      expect(Integer(1) < 0, false);
      expect(Integer(1) < 1, false);
      expect(Integer(1) < 2, true);
      expect(Integer(1) < 1.1, true);
      expect(Integer(42) < Integer(43), true);
      expect(Integer(43) < Integer(43), false);
      expect(Integer(44) < Integer(43), false);
      expect(Integer(1) < Double(0), false);
      expect(Integer(0) < Double(1), true);
      expect(Integer(0) < Double(0), false);
      expect(Integer(-9) < Double(2), true);
      expect(Integer(2) < Double(-9), false);

      // < only looks at real parts.
      expect(Integer(77) < Imaginary(5), false);
      expect(Integer(77) < Imaginary(85.7), false);
      expect(Integer(-77) < Imaginary(6), true);
      expect(Integer(77) < Complex.num(Double(6.5), Imaginary(99)), false);
      expect(Integer(-77) < Complex.num(Double(77.001), Imaginary(55)), true);

      expect(Integer(88) < Precision('87.999999999999999999'), false);
      expect(Integer(88) < Precision('88.000000000000000000'), false);
      expect(Integer(88) < Precision('88.000000000000000001'), true);
    });

    test('operator <=', () {
      expect(Integer(1) <= 0.5, false);
      expect(Integer(1) <= 0, false);
      expect(Integer(1) <= 1, true);
      expect(Integer(1) <= 2, true);
      expect(Integer(1) <= 1.1, true);
      expect(Integer(42) <= Integer(43), true);
      expect(Integer(43) <= Integer(43), true);
      expect(Integer(44) <= Integer(43), false);
      expect(Integer(1) <= Double(0), false);
      expect(Integer(0) <= Double(1), true);
      expect(Integer(0) <= Double(0), true);
      expect(Integer(-9) <= Double(2), true);
      expect(Integer(2) <= Double(-9), false);

      // < only looks at real parts.
      expect(Integer(77) <= Imaginary(5), false);
      expect(Integer(77) <= Imaginary(85.7), false);
      expect(Integer(-77) <= Imaginary(6), true);
      expect(Integer(77) <= Imaginary(77), false);
      expect(Integer(77) <= Complex.num(Double(6.5), Imaginary(99)), false);
      expect(Integer(77) <= Complex.num(Double(77), Imaginary(55)), true);
      expect(Integer(77) <= Complex.num(Double(76.999999999), Imaginary(55)),
          false);

      expect(Integer(88) <= Precision('87.999999999999999999'), false);
      expect(Integer(88) <= Precision('88.000000000000000000'), true);
      expect(Integer(88) <= Precision('88.000000000000000001'), true);
    });

    test('operator >', () {
      expect(Integer(1) > 0.5, true);
      expect(Integer(1) > 0, true);
      expect(Integer(1) > 1, false);
      expect(Integer(1) > 2, false);
      expect(Integer(1) > 1.1, false);
      expect(Integer(42) > Integer(43), false);
      expect(Integer(43) > Integer(43), false);
      expect(Integer(44) > Integer(43), true);
      expect(Integer(1) > Double(0), true);
      expect(Integer(0) > Double(1), false);
      expect(Integer(0) > Double(0), false);
      expect(Integer(-9) > Double(2), false);
      expect(Integer(2) > Double(-9), true);

      // < only looks at real parts.
      expect(Integer(77) > Imaginary(5), true);
      expect(Integer(77) > Imaginary(85.7), true);
      expect(Integer(-77) > Imaginary(6), false);
      expect(Integer(77) > Complex.num(Double(6.5), Imaginary(99)), true);
      expect(Integer(77) > Complex.num(Double(77.001), Imaginary(55)), false);

      expect(Integer(88) > Precision('87.999999999999999999'), true);
      expect(Integer(88) > Precision('88.000000000000000000'), false);
      expect(Integer(88) > Precision('88.000000000000000001'), false);
    });

    test('operator >=', () {
      expect(Integer(1) >= 0.5, true);
      expect(Integer(1) >= 0, true);
      expect(Integer(1) >= 1, true);
      expect(Integer(1) >= 2, false);
      expect(Integer(1) >= 1.1, false);
      expect(Integer(42) >= Integer(43), false);
      expect(Integer(43) >= Integer(43), true);
      expect(Integer(44) >= Integer(43), true);
      expect(Integer(1) >= Double(0), true);
      expect(Integer(0) >= Double(1), false);
      expect(Integer(0) >= Double(0), true);
      expect(Integer(-9) >= Double(2), false);
      expect(Integer(2) >= Double(-9), true);

      // < only looks at real parts.
      expect(Integer(77) >= Imaginary(5), true);
      expect(Integer(77) >= Imaginary(85.7), true);
      expect(Integer(-77) >= Imaginary(6), false);
      expect(Integer(77) >= Complex.num(Double(6.5), Imaginary(99)), true);
      expect(
          Integer(77) >= Complex.num(Double(77.00001), Imaginary(55)), false);
      expect(Integer(77) >= Complex.num(Double(77), Imaginary(55)), false);
      expect(Integer(77) >= Complex.num(Double(77), Imaginary(0)), true);

      expect(Integer(88) >= Precision('87.999999999999999999'), true);
      expect(Integer(88) >= Precision('88.000000000000000000'), true);
      expect(Integer(88) >= Precision('88.000000000000000001'), false);
    });

    test('operator ^', () {
      expect(Integer(2) ^ 0, Integer(1));
      expect(Integer(2) ^ 1, Integer(2));
      expect(Integer(2) ^ 2, Integer(4));
      expect(Integer(2) ^ 3, Integer(8));
      expect(Integer(2) ^ 4, Integer(16));
      expect(Integer(2) ^ -1, Double(0.5));
      expect(Integer(2) ^ -2, Double(0.25));
      expect(Integer(2) ^ -3, Double(0.125));
      expect(Integer(2) ^ -4, Double(0.0625));
    });

    test('operator %', () {
      expect(Integer(14) % 2, Integer(0));
      expect(Integer(14) % -3, Integer(2));
      expect(Integer(14) % 4, Integer(2));
      expect(Integer(14) % -5, Integer(4));
      expect(Integer(14) % 6, Integer(2));
      expect(Integer(14) % -7, Integer(0));
      expect(Integer(14) % 8, Integer(6));
      expect(Integer(14) % -9, Integer(5));
      expect(Integer(14) % 10, Integer(4));
      expect(Integer(14) % -11, Integer(3));
      expect(Integer(14) % 12, Integer(2));
      expect(Integer(14) % -13, Integer(1));
      expect(Integer(14) % 14, Integer(0));
      expect(Integer(14) % 15, Integer(14));
      expect(Integer(14) % -16, Integer(14));
    });

    test('operator | (Bitwise OR)', () {
      expect(Integer(2) | 0, Integer(2));
      expect(Integer(2) | 1, Integer(3));
      expect(Integer(2) | 2, Integer(2));
      expect(Integer(2) | 3, Integer(3));
      expect(Integer(3) | 2, Integer(3));
      expect(Integer(4) | 3, Integer(7));
      expect(Integer(2) | Integer(0), Integer(2));
      expect(Integer(2) | Integer(1), Integer(3));
      expect(Integer(2) | Integer(2), Integer(2));
      expect(Integer(2) | Integer(3), Integer(3));
      expect(Integer(3) | Integer(2), Integer(3));
      expect(Integer(4) | Integer(3), Integer(7));
    });

    test('operator & (Bitwise AND)', () {
      expect(Integer(2) & 0, Integer(0));
      expect(Integer(2) & 1, Integer(0));
      expect(Integer(2) & 2, Integer(2));
      expect(Integer(2) & 3, Integer(2));
      expect(Integer(3) & 2, Integer(2));
      expect(Integer(4) & 3, Integer(0));
      expect(Integer(2) & Integer(0), Integer(0));
      expect(Integer(2) & Integer(1), Integer(0));
      expect(Integer(2) & Integer(2), Integer(2));
      expect(Integer(2) & Integer(3), Integer(2));
      expect(Integer(3) & Integer(2), Integer(2));
      expect(Integer(4) & Integer(3), Integer(0));
    });

    test('bitwise XOR (not the ^ operator, which is power for Numbers)', () {
      expect(Integer(2).bitwiseXor(0), Integer(2));
      expect(Integer(2).bitwiseXor(1), Integer(3));
      expect(Integer(2).bitwiseXor(2), Integer(0));
      expect(Integer(2).bitwiseXor(3), Integer(1));
      expect(Integer(3).bitwiseXor(2), Integer(1));
      expect(Integer(4).bitwiseXor(3), Integer(7));
      expect(Integer(2).bitwiseXor(Integer(0)), Integer(2));
      expect(Integer(2).bitwiseXor(Integer(1)), Integer(3));
      expect(Integer(2).bitwiseXor(Integer(2)), Integer(0));
      expect(Integer(2).bitwiseXor(Integer(3)), Integer(1));
      expect(Integer(3).bitwiseXor(Integer(2)), Integer(1));
      expect(Integer(4).bitwiseXor(Integer(3)), Integer(7));
    });

    test('operator << (Bit shift left)', () {
      expect(Integer(2) << 0, Integer(2));
      expect(Integer(2) << 1, Integer(4));
      expect(Integer(2) << 2, Integer(8));
      expect(Integer(2) << 3, Integer(16));
      expect(Integer(3) << 2, Integer(12));
      expect(Integer(4) << 3, Integer(32));
      expect(Integer(2) << Integer(0), Integer(2));
      expect(Integer(2) << Integer(1), Integer(4));
      expect(Integer(2) << Integer(2), Integer(8));
      expect(Integer(2) << Integer(3), Integer(16));
      expect(Integer(3) << Integer(2), Integer(12));
      expect(Integer(4) << Integer(3), Integer(32));
    });

    test('operator >> (Bit shift right)', () {
      expect(Integer(2) >> 0, Integer(2));
      expect(Integer(2) >> 1, Integer(1));
      expect(Integer(2) >> 2, Integer(0));
      expect(Integer(2) >> 3, Integer(0));
      expect(Integer(3) >> 1, Integer(1));
      expect(Integer(4) >> 1, Integer(2));
      expect(Integer(2) >> Integer(0), Integer(2));
      expect(Integer(2) >> Integer(1), Integer(1));
      expect(Integer(2) >> Integer(2), Integer(0));
      expect(Integer(2) >> Integer(3), Integer(0));
      expect(Integer(3) >> Integer(1), Integer(1));
      expect(Integer(4) >> Integer(1), Integer(2));
    });

    test('operator ~ (bit-wise negate)', () {
      final i1 = Integer(123456789);
      final i2 = Integer(-234567890);
      expect(~i1, Integer(-123456790));
      expect(~i2, Integer(234567889));
    });

    test('clamp', () {
      expect(Integer(0).clamp(-5, 5), Integer(0));
      expect(Integer(0).clamp(2, 7), Integer(2));
      expect(Integer(8).clamp(2, 7), Integer(7));
      expect(Integer(3).clamp(2.9, 7), Integer(3));
      expect(Integer(-10).clamp(-9.5, -8.2), Double(-9.5));
      expect(Integer(10).clamp(-9.5, -8.2), Double(-8.2));
    });

    test('abs', () {
      expect(Integer(0).abs(), Integer(0));
      expect(Integer(1).abs(), Integer(1));
      expect(Integer(-1).abs(), Integer(1));
      expect(Integer.zero.abs(), Integer(0));
      expect(Integer.one.abs(), Integer(1));
      expect(Integer.negOne.abs(), Integer(1));
    });

    test('ceil', () {
      expect(Integer(0).ceil(), Integer(0));
      expect(Integer(1).ceil(), Integer(1));
      expect(Integer(-1).ceil(), Integer(-1));
      expect(Integer.zero.ceil(), Integer(0));
      expect(Integer.one.ceil(), Integer(1));
      expect(Integer.negOne.ceil(), Integer(-1));
    });

    test('floor', () {
      expect(Integer(0).floor(), Integer(0));
      expect(Integer(1).floor(), Integer(1));
      expect(Integer(-1).floor(), Integer(-1));
      expect(Integer.zero.floor(), Integer(0));
      expect(Integer.one.floor(), Integer(1));
      expect(Integer.negOne.floor(), Integer(-1));
    });

    test('reciprocal', () {
      expect(Integer(0).reciprocal(), Double.NaN);
      expect(Integer(1).reciprocal(), Integer(1));
      expect(Integer(-1).reciprocal(), Integer(-1));
      expect(Integer(2).reciprocal(), Double(0.5));
      expect(Integer(-2).reciprocal(), Double(-0.5));
    });

    test('remainder', () {
      expect(Integer(0).remainder(5), Integer(0));
      expect(Integer(1).remainder(5), Integer(1));
      expect(Integer(4).remainder(1), Integer(0));
      expect(Integer(23).remainder(4), Integer(3));
      expect(Integer(-23).remainder(4), Integer(-3));
      expect(Integer(23).remainder(-4), Integer(3));
      expect(Integer(-23).remainder(-4), Integer(-3));
    });

    test('round', () {
      expect(Integer(0).round(), Integer(0));
      expect(Integer(1).round(), Integer(1));
      expect(Integer(-1).round(), Integer(-1));
      expect(Integer(2).round(), Integer(2));
      expect(Integer(-2).round(), Integer(-2));
    });

    test('truncate', () {
      expect(Integer(0).truncate(), Integer(0));
      expect(Integer(1).truncate(), Integer(1));
      expect(Integer(-1).truncate(), Integer(-1));
      expect(Integer(2).truncate(), Integer(2));
      expect(Integer(-2).truncate(), Integer(-2));
    });

    test('toDouble', () {
      expect(Integer(0).toDouble(), 0.0);
      expect(Integer(1).toDouble(), 1.0);
      expect(Integer(-1).toDouble(), -1.0);
      expect(Integer(2).toDouble(), 2.0);
      expect(Integer(-2).toDouble(), -2.0);
    });

    test('toInt', () {
      expect(Integer(0).toInt(), 0);
      expect(Integer(1).toInt(), 1);
      expect(Integer(-1).toInt(), -1);
      expect(Integer(2).toInt(), 2);
      expect(Integer(-2).toInt(), -2);
    });

    test('toString', () {
      expect(Integer(0).toString(), '0');
      expect(Integer(1).toString(), '1');
      expect(Integer(-1).toString(), '-1');
      expect(Integer(2).toString(), '2');
      expect(Integer(-2).toString(), '-2');
    });

    test('isInfinite', () {
      expect(Integer(0).isInfinite, false);
      expect(Integer(double.maxFinite.toInt()).isInfinite, false);
    });

    test('isNaN', () {
      expect(Integer(0).isNaN, false);
      expect(Integer(double.maxFinite.toInt()).isNaN, false);
      expect(Integer(double.minPositive.toInt()).isNaN, false);
    });

    test('isNegative', () {
      expect(Integer(0).isNegative, false);
      expect(Integer(1).isNegative, false);
      expect(Integer(-1).isNegative, true);
    });
  });

  group('Binary', () {
    test('constructor', () {
      expect(Binary('0'), Integer(0));
      expect(Binary('1'), Integer(1));
      expect(Binary('10'), Integer(2));
      expect(Binary('11'), Integer(3));
      expect(Binary('100'), Integer(4));
      expect(Binary('101'), Integer(5));
      expect(Binary('110'), Integer(6));
      expect(Binary('111'), Integer(7));
      expect(Binary('0000111'), Integer(7));
      expect(Binary('-111'), Integer(-7));
      expect(Binary('1000'), Integer(8));

      dynamic exc;
      try {
        Binary('2');
      } catch (e) {
        exc = e;
      }
      expect(exc is FormatException, true);
    });

    test('toString', () {
      expect(Binary('0').toString(), '0');
      expect(Binary('100').toString(), '100');
      expect(Binary('0010').toString(), '10');
      expect(Binary('-00101').toString(), '-101');
      expect(Binary('111111110').toString(), '111111110');
    });
  });

  group('Octal', () {
    test('constructor', () {
      expect(Octal('0'), Integer(0));
      expect(Octal('1'), Integer(1));
      expect(Octal('2'), Integer(2));
      expect(Octal('3'), Integer(3));
      expect(Octal('4'), Integer(4));
      expect(Octal('5'), Integer(5));
      expect(Octal('6'), Integer(6));
      expect(Octal('7'), Integer(7));
      expect(Octal('10'), Integer(8));
      expect(Octal('11'), Integer(9));
      expect(Octal('100'), Integer(64));
      expect(Octal('101'), Integer(65));
      expect(Octal('110'), Integer(72));
      expect(Octal('111'), Integer(73));
      expect(Octal('0000111'), Integer(73));
      expect(Octal('-111'), Integer(-73));
      expect(Octal('1000'), Integer(512));

      dynamic exc;
      try {
        Octal('8');
      } catch (e) {
        exc = e;
      }
      expect(exc is FormatException, true);
    });

    test('toString', () {
      expect(Octal('0').toString(), '0');
      expect(Octal('700').toString(), '700');
      expect(Octal('0070').toString(), '70');
      expect(Octal('-00701').toString(), '-701');
      expect(Octal('111711110').toString(), '111711110');
    });
  });

  group('Hexadecimal', () {
    test('constructor', () {
      expect(Hexadecimal('0'), Integer(0));
      expect(Hexadecimal('1'), Integer(1));
      expect(Hexadecimal('2'), Integer(2));
      expect(Hexadecimal('3'), Integer(3));
      expect(Hexadecimal('4'), Integer(4));
      expect(Hexadecimal('5'), Integer(5));
      expect(Hexadecimal('6'), Integer(6));
      expect(Hexadecimal('7'), Integer(7));
      expect(Hexadecimal('8'), Integer(8));
      expect(Hexadecimal('9'), Integer(9));
      expect(Hexadecimal('a'), Integer(10));
      expect(Hexadecimal('b'), Integer(11));
      expect(Hexadecimal('c'), Integer(12));
      expect(Hexadecimal('d'), Integer(13));
      expect(Hexadecimal('e'), Integer(14));
      expect(Hexadecimal('f'), Integer(15));
      expect(Hexadecimal('A'), Integer(10));
      expect(Hexadecimal('B'), Integer(11));
      expect(Hexadecimal('C'), Integer(12));
      expect(Hexadecimal('D'), Integer(13));
      expect(Hexadecimal('E'), Integer(14));
      expect(Hexadecimal('F'), Integer(15));
      expect(Hexadecimal('10'), Integer(16));
      expect(Hexadecimal('11'), Integer(17));
      expect(Hexadecimal('100'), Integer(256));
      expect(Hexadecimal('101'), Integer(257));
      expect(Hexadecimal('110'), Integer(272));
      expect(Hexadecimal('111'), Integer(273));
      expect(Hexadecimal('0000111'), Integer(273));
      expect(Hexadecimal('-111'), Integer(-273));
      expect(Hexadecimal('1000'), Integer(4096));

      dynamic exc;
      try {
        Hexadecimal('g');
      } catch (e) {
        exc = e;
      }
      expect(exc is FormatException, true);
    });

    test('toString', () {
      expect(Hexadecimal('0').toString(), '0');
      expect(Hexadecimal('F').toString(), 'f');
      expect(Hexadecimal('7a0').toString(), '7a0');
      expect(Hexadecimal('0a70').toString(), 'a70');
      expect(Hexadecimal('-0b7e1').toString(), '-b7e1');
      expect(Hexadecimal('1117abc0').toString(), '1117abc0');
    });
  });
}
