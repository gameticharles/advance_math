// ignore_for_file: unnecessary_type_check

import 'package:advance_math/src/quantity/number.dart';
import 'package:test/test.dart';

void main() {
  group('Digit', () {
    test('constructors', () {
      final d1 = Digit(0);
      final d2 = Digit(1);
      final d3 = Digit(2);
      final d4 = Digit(3);
      expect(d1.value.getUint8(0), 0);
      expect(d2.value.getUint8(0), 1);
      expect(d3.value.getUint8(0), 2);
      expect(d4.value.getUint8(0), 3);

      final d5 = Digit.char('5');
      final d6 = Digit.char('6');
      final d7 = Digit.char('7');
      final d8 = Digit.char('8');
      expect(d5.value.getUint8(0), 5);
      expect(d6.value.getUint8(0), 6);
      expect(d7.value.getUint8(0), 7);
      expect(d8.value.getUint8(0), 8);

      // Bad values
      try {
        Digit(10);
        fail(
            'Should not be allowed to construct a Digit with a value greater than 9');
      } catch (e) {
        expect(e is Exception, true);
      }
      try {
        Digit(-1);
        fail(
            'Should not be allowed to construct a Digit with a value less than 0');
      } catch (e) {
        expect(e is Exception, true);
      }
      try {
        Digit.char('12');
        fail(
            'Should not be allowed to construct a Digit with a string having more than one character');
      } catch (e) {
        expect(e is Exception, true);
      }
      try {
        Digit.char('');
        fail('Should not be allowed to construct a Digit with an empty string');
      } catch (e) {
        expect(e is Exception, true);
      }
    });

    test('toInt()', () {
      final d1 = Digit(0);
      final d2 = Digit(1);
      final d3 = Digit(2);
      final d4 = Digit(3);
      expect(d1.toInt(), 0);
      expect(d2.toInt(), 1);
      expect(d3.toInt(), 2);
      expect(d4.toInt(), 3);
    });

    test('operator <', () {
      final d1 = Digit(0);
      final d2 = Digit(1);
      final d3 = Digit(2);
      expect(d1 < d2, true);
      expect(d2 < d3, true);
      expect(d3 < d2, false);
      expect(d3 < Digit.two, false);
      expect(d3 < Digit.three, true);
    });
  });

  group('Precise', () {
    test('constructors', () {
      var p = Decimal('0');
      expect(p.digits.length, 1);
      expect(p.digits[0].toInt(), 0);
      expect(p.power, 0);

      p = Decimal('0.0');
      expect(p.digits.length, 2);
      expect(p.digits[0].toInt(), 0);
      expect(p.digits[1].toInt(), 0);
      expect(p.power, -1);

      p = Decimal('12345.6789');
      expect(p.digits.length, 9);
      expect(p.digits[0].toInt(), 9);
      expect(p.digits[1].toInt(), 8);
      expect(p.digits[2].toInt(), 7);
      expect(p.digits[3].toInt(), 6);
      expect(p.digits[4].toInt(), 5);
      expect(p.digits[5].toInt(), 4);
      expect(p.digits[6].toInt(), 3);
      expect(p.digits[7].toInt(), 2);
      expect(p.digits[8].toInt(), 1);
      expect(p.power, -4);

      p = Decimal('543.91e7');
      expect(p.digits.length, 5);
      expect(p.digits[0].toInt(), 1);
      expect(p.digits[1].toInt(), 9);
      expect(p.digits[2].toInt(), 3);
      expect(p.digits[3].toInt(), 4);
      expect(p.digits[4].toInt(), 5);
      expect(p.power, 5);

      // Limited to default (50) sig digits
      p = Decimal(
          '5.00000000000000000000000000000000000000000000000000000000000000000000000000000000001');
      expect(p.digits.length, 50);
      expect(p.digits[0].toInt(), 0);
      expect(p.digits[49].toInt(), 5);
      expect(p.power, -49);

      // Raised precision
      p = Decimal(
          '5.00000000000000000000000000000000000000000000000000000000000000000000000000000000001',
          sigDigits: 500);
      expect(p.digits.length > 50, true);
      expect(p.digits[0].toInt(), 1);
      expect(p.digits.last.toInt(), 5);
      expect(p.power < -49, true);
    });

    test('decimalPortion', () {
      var p = Decimal('123');
      expect(p.decimalPortion, Decimal.zero);

      p = Decimal('123.00000');
      expect(p.decimalPortion, Decimal.zero);

      p = Decimal('123.4567');
      expect(p.decimalPortion, Decimal('0.4567'));

      p = Decimal('-6.789');
      expect(p.decimalPortion, Decimal('-0.789'));
    });

    test('operator ==', () {
      final p = Decimal('123');
      final p2 = Decimal('456');
      final p3 = Decimal('456');
      final p4 = Decimal('456.000');
      final p5 = Decimal('-456');
      expect(p == p, true);
      expect(p == p2, false);
      expect(p2 == p3, true);
      expect(p2 == p4, true);
      expect(p3 == p5, false);
      expect(p4 == p5, false);
    });

    test('operator <', () {
      final p = Decimal('123');
      final p2 = Decimal('456');
      final p3 = Decimal('456');
      final p4 = Decimal('456.000');
      final p5 = Decimal('-456');
      expect(p < p, false);
      expect(p < p2, true);
      expect(p2 < p, false);
      expect(p2 < p3, false);
      expect(p2 < p4, false);
      expect(p5 < p3, true);
      expect(p5 < p4, true);
      expect(p3 < p5, false);
      expect(p4 < p5, false);
    });

    test('operator >', () {
      final p = Decimal('123');
      final p2 = Decimal('456');
      final p3 = Decimal('456');
      final p4 = Decimal('456.000');
      final p5 = Decimal('-456');
      expect(p > p, false);
      expect(p > p2, false);
      expect(p2 > p, true);
      expect(p2 > p3, false);
      expect(p2 > p4, false);
      expect(p5 > p3, false);
      expect(p5 > p4, false);
      expect(p3 > p5, true);
      expect(p4 > p5, true);
    });

    test('operator <=', () {
      final p = Decimal('123');
      final p2 = Decimal('456');
      final p3 = Decimal('456');
      final p4 = Decimal('456.000');
      final p5 = Decimal('-456');
      expect(p <= p, true);
      expect(p <= p2, true);
      expect(p2 <= p, false);
      expect(p2 <= p3, true);
      expect(p2 <= p4, true);
      expect(p5 <= p3, true);
      expect(p5 <= p4, true);
      expect(p3 <= p5, false);
      expect(p4 <= p5, false);
    });

    test('operator >=', () {
      final p = Decimal('123');
      final p2 = Decimal('456');
      final p3 = Decimal('456');
      final p4 = Decimal('456.000');
      final p5 = Decimal('-456');
      expect(p >= p, true);
      expect(p >= p2, false);
      expect(p2 >= p, true);
      expect(p2 >= p3, true);
      expect(p2 >= p4, true);
      expect(p5 >= p3, false);
      expect(p5 >= p4, false);
      expect(p3 >= p5, true);
      expect(p4 >= p5, true);
    });

    test('operator +', () {
      final p = Decimal('123');
      final p2 = Decimal('456');
      Number sum = p + p2;
      expect(sum is Decimal, true);
      expect((sum as Decimal).digits.length, 3);
      expect(sum.power, 0);
      expect(sum.digits[0], Digit.nine);
      expect(sum.digits[1], Digit.seven);
      expect(sum.digits[2], Digit.five);
      expect(sum.toString(), '579');

      final p3 = Decimal('9999');
      sum = p + p3;
      expect(sum is Decimal, true);
      expect(sum.digits.length, 5);
      expect(sum.power, 0);
      expect(sum.digits[0], Digit.two);
      expect(sum.digits[1], Digit.two);
      expect(sum.digits[2], Digit.one);
      expect(sum.digits[3], Digit.zero);
      expect(sum.digits[4], Digit.one);
      expect(sum.toString(), '10122');

      final p4 = Decimal('123.456');
      final p5 = Decimal('987.654');
      sum = p4 + p5; // 1111.110
      expect(sum is Decimal, true);
      expect(sum.digits.length, 7);
      expect(sum.power, -3);
      expect(sum.digits[0], Digit.zero);
      expect(sum.digits[1], Digit.one);
      expect(sum.digits[2], Digit.one);
      expect(sum.digits[3], Digit.one);
      expect(sum.digits[4], Digit.one);
      expect(sum.digits[5], Digit.one);
      expect(sum.digits[6], Digit.one);
      expect(sum.toString(), '1111.110');

      final p6 = Decimal('-382');
      sum = p + p6; // -259
      expect(sum is Decimal, true);
      expect(sum.digits.length, 3);
      expect(sum.power, 0);
      expect(sum.isNegative, true);
      expect(sum.digits[0], Digit.nine);
      expect(sum.digits[1], Digit.five);
      expect(sum.digits[2], Digit.two);
      expect(sum.toString(), '-259');
    });

    test('operator -', () {
      final p = Decimal('456');
      final p2 = Decimal('321');
      Number diff = p - p2;
      expect(diff is Decimal, true);
      expect((diff as Decimal).digits.length, 3);
      expect(diff.power, 0);
      expect(diff.digits[0], Digit.five);
      expect(diff.digits[1], Digit.three);
      expect(diff.digits[2], Digit.one);
      expect(diff.toString(), '135');

      diff = p2 - p; // -135
      expect(diff.digits.length, 3);
      expect(diff.power, 0);
      expect(diff.isNegative, true);
      expect(diff.digits[0], Digit.five);
      expect(diff.digits[1], Digit.three);
      expect(diff.digits[2], Digit.one);
      expect(diff.toString(), '-135');

      final p3 = Decimal('-5');
      final p4 = Decimal('-7');
      diff = p3 - p4;
      expect(diff.digits.length, 1);
      expect(diff.power, 0);
      expect(diff.isNegative, false);
      expect(diff.digits[0], Digit.two);
      expect(diff.toString(), '2');

      diff = p4 - p3;
      expect(diff.digits.length, 1);
      expect(diff.power, 0);
      expect(diff.isNegative, true);
      expect(diff.digits[0], Digit.two);
      expect(diff.toString(), '-2');

      final p5 = Decimal('12345.6789');
      diff = p - p5; // -11889.6789
      expect(diff.digits.length, 9);
      expect(diff.power, -4);
      expect(diff.isNegative, true);
      expect(diff.toString(), '-11889.6789');

      final p6 = Decimal('-0.5371057032');
      diff = p5 - p6; // 12345.1417942968
      expect(diff.digits.length, 15);
      expect(diff.power, -10);
      expect(diff.isNegative, false);
      expect(diff.toString(), '12346.2160057032');
    });

    group('operator *', () {
      test('operator * Precise', () {
        final p0 = Decimal.zero;
        final p1 = Decimal('1');
        final p2 = Decimal('2');
        final p3 = Decimal('3');
        Number prod = p0 * p0;
        expect(prod is Decimal, true);
        expect((prod as Decimal).digits.length, 1);
        expect(prod.power, 0);
        expect(prod.digits[0], Digit.zero);
        expect(prod.toString(), '0');

        prod = p0 * p1;
        expect(prod.digits.length, 1);
        expect(prod.power, 0);
        expect(prod.digits[0], Digit.zero);
        expect(prod.toString(), '0');

        prod = p1 * p2;
        expect(prod.digits.length, 1);
        expect(prod.power, 0);
        expect(prod.digits[0], Digit.two);
        expect(prod.toString(), '2');

        prod = p3 * p3;
        expect(prod.digits.length, 1);
        expect(prod.power, 0);
        expect(prod.digits[0], Digit.nine);
        expect(prod.toString(), '9');

        final p4 = Decimal('4');
        prod = p3 * p4;
        expect(prod.digits.length, 2);
        expect(prod.power, 0);
        expect(prod.digits[0], Digit.two);
        expect(prod.digits[1], Digit.one);
        expect(prod.toString(), '12');

        final pNeg5 = Decimal('-5');
        prod = p4 * pNeg5;
        expect(prod.digits.length, 2);
        expect(prod.power, 0);
        expect(prod.isNegative, true);
        expect(prod.digits[0], Digit.zero);
        expect(prod.digits[1], Digit.two);
        expect(prod.toString(), '-20');

        final p123 = Decimal('123');
        prod = p4 * p123;
        expect(prod.digits.length, 3);
        expect(prod.power, 0);
        expect(prod.digits[0], Digit.two);
        expect(prod.digits[1], Digit.nine);
        expect(prod.digits[2], Digit.four);
        expect(prod.toString(), '492');

        final pNeg432 = Decimal('-432');
        prod = p123 * pNeg432;
        expect(prod.digits.length, 5);
        expect(prod.power, 0);
        expect(prod.isNegative, true);
        expect(prod.digits[0], Digit.six);
        expect(prod.digits[1], Digit.three);
        expect(prod.digits[2], Digit.one);
        expect(prod.digits[3], Digit.three);
        expect(prod.digits[4], Digit.five);
        expect(prod.toString(), '-53136');

        final p1pt2 = Decimal('1.2');
        prod = p123 * p1pt2;
        expect(prod.digits.length, 4);
        expect(prod.power, -1);
        expect(prod.digits[0], Digit.six);
        expect(prod.digits[1], Digit.seven);
        expect(prod.digits[2], Digit.four);
        expect(prod.digits[3], Digit.one);
        expect(prod.toString(), '147.6');

        final pNeg478pt192 = Decimal('-478.192');
        prod = p1pt2 * pNeg478pt192;
        expect(prod.digits.length, 7);
        expect(prod.power, -4);
        expect(prod.digits[0], Digit.four);
        expect(prod.digits[1], Digit.zero);
        expect(prod.digits[2], Digit.three);
        expect(prod.digits[3], Digit.eight);
        expect(prod.digits[4], Digit.three);
        expect(prod.digits[5], Digit.seven);
        expect(prod.digits[6], Digit.five);
        expect(prod.toString(), '-573.8304');
      });

      test('operator * num', () {
        expect(Decimal('0') * 0, Decimal('0'));
        expect(Decimal('0') * -9, Decimal('0'));
        expect(Decimal('1.00000000000000000001') * -9,
            Decimal('-9.00000000000000000009'));
      });
    });

    test('operator /', () {
      final p0 = Decimal.zero;
      final p1 = Decimal('1');
      final p2 = Decimal('2');
      final p10 = Decimal('10');
      final pNeg20 = Decimal('-20');

      var result = p0 / p0;
      expect(result, Double.NaN);

      result = p1 / p0;
      expect(result, Double.infinity);

      result = p1 / p1;
      expect(result, Decimal.one);
      expect((result as Decimal).digits.length, 1);
      expect(result.power, 0);
      expect(result.digits[0], Digit.one);
      expect(result.toString(), '1');

      result = p2 / p1;
      expect(identical(result, p2), true);

      result = p1 / p2;
      expect(result, Decimal('0.5'));

      result = p10 / p2;
      expect(result, Decimal('5'));

      result = p2 / p10;
      expect(result, Decimal('0.2'));

      result = pNeg20 / p2;
      expect(result, Decimal('-10'));

      result = pNeg20 / p10;
      expect(result, Decimal('-2'));

      result = p0 / pNeg20;
      expect(result, Decimal('0'));

      result = p2 / pNeg20;
      expect(result, Decimal('-0.1'));

      final pPt1 = Decimal('0.1');
      result = pPt1 / p10;
      expect(result, Decimal('0.01'));

      final pPt0002 = Decimal('0.0002');
      result = pPt0002 / p2;
      expect(result, Decimal('0.0001'));
      result = pPt0002 / p10;
      expect(result, Decimal('0.00002'));
      result = pPt0002 / pPt1;
      expect(result, Decimal('0.002'));
      result = pPt1 / pPt0002;
      expect(result, Decimal('500'));

      final pNegPt0002 = Decimal('-0.0002');
      result = pNegPt0002 / p2;
      expect(result, Decimal('-0.0001'));
      result = pNegPt0002 / p10;
      expect(result, Decimal('-0.00002'));
      result = pNegPt0002 / pPt1;
      expect(result, Decimal('-0.002'));
      result = pPt1 / pNegPt0002;
      expect(result, Decimal('-500'));
    });

    test('operator ^', () {
      final p0 = Decimal.zero;
      expect(identical(p0 ^ 0, Double.NaN), true);
      expect(p0 ^ 1, Decimal.zero);
      expect(p0 ^ 2, Decimal.zero);
      expect(p0 ^ -2, Decimal.zero);
      expect(p0 ^ 100, Decimal.zero);

      final p1 = Decimal(1);
      expect(p1 ^ 0, p1);
      expect(p1 ^ 1, p1);
      expect(identical(p1 ^ 1, p1), true);
      expect(p1 ^ 2, p1);
      expect(p1 ^ 10, p1);
      expect(p1 ^ 2, p1);

      final p10 = Decimal(10);
      expect(p10 ^ 0, p1);
      expect(p10 ^ 1, p10);
      expect(p10 ^ 2, Decimal(100));
      expect(p10 ^ -1, Decimal(0.1));
      expect(p10 ^ -2, Decimal(0.01));
      expect(p10 ^ -5, Decimal(0.00001));

      final p1000 = Decimal(1000);
      expect(p1000 ^ 0, p1);
      expect(p1000 ^ 1, p1000);
      expect(p1000 ^ 2, Decimal(1000000));
      expect(p1000 ^ -1, Decimal(0.001));
      expect(p1000 ^ -2, Decimal(0.000001));

      final pNeg5 = Decimal(-5);
      expect(pNeg5 ^ 0, p1);
      expect(pNeg5 ^ 1, pNeg5);
      expect(pNeg5 ^ 2, Decimal(25));
      expect(pNeg5 ^ 3, Decimal(-125));
    });

    test('operator ~/', () {
      final p0 = Decimal.zero;
      expect(p0 ~/ 1, Decimal.zero);
      expect(p0 ~/ 2, Decimal.zero);
      expect(p0 ~/ -2, Decimal.zero);
      expect(p0 ~/ 100, Decimal.zero);

      final p10 = Decimal(10);
      expect(p10 ~/ 3, Decimal('3'));
      expect(p10 ~/ Integer(3), Decimal('3'));
      expect(p10 ~/ Double(3), Decimal('3'));
      expect(p10 ~/ Decimal('3'), Decimal('3'));
      expect(p10 ~/ Decimal(3), Decimal('3'));

      expect(p10 ~/ 2, Decimal('5'));
      expect(p10 ~/ -2, Decimal('-5'));
      expect(p10 ~/ -3, Decimal('-3'));
      expect(p10 ~/ 0.003, Decimal('3333'));
    });

    test('operator %', () {
      final p0 = Decimal.zero;
      expect(p0 % 1, Decimal.zero);
      expect(p0 % 2, Decimal.zero);
      expect(p0 % -2, Decimal.zero);
      expect(p0 % 100, Decimal.zero);

      final p10 = Decimal(10);
      expect(p10 % 3, Decimal('1'));
      expect(p10 % Integer(3), Decimal('1'));
      expect(p10 % Double(3), Decimal('1'));
      expect(p10 % Decimal('3'), Decimal('1'));
      expect(p10 % Decimal(3), Decimal('1'));

      expect(p10 % 2, Decimal.zero);
      expect(p10 % -2, Decimal.zero);
      expect(p10 % -3, Decimal.one);
      expect(p10 % 0.003, Decimal('0.001'));
    });

    test('operator unary -', () {
      final p0 = Decimal('0');
      expect(-p0, Decimal('0'));

      final p10 = Decimal(10);
      expect(-p10, Decimal('-10.0'));

      final pNeg = Decimal('-345.6789123456789');
      expect(-pNeg, Decimal('345.6789123456789'));
    });

    test('abs', () {
      var p = Decimal('0');
      var abs = p.abs();
      expect(abs is Decimal, true);
      expect(abs, Decimal.zero);

      p = Decimal('-0.00000001');
      abs = p.abs();
      expect(abs, Decimal('0.00000001'));

      p = Decimal('0.00000001');
      abs = p.abs();
      expect(abs, Decimal('0.00000001'));

      p = Decimal('-99999999999');
      abs = p.abs();
      expect(abs, Decimal('99999999999'));

      p = Decimal('-99999999999.9999999999999');
      abs = p.abs();
      expect(abs, Decimal('99999999999.9999999999999'));
    });

    test('ceil', () {
      var p = Decimal('5.678');
      Number ceil = p.ceil();
      expect(ceil is Decimal, true);
      expect((ceil as Decimal).digits.length, 1);
      expect(ceil.isNegative, false);
      expect(ceil.power, 0);
      expect(ceil.digits[0], Digit.six);
      expect(ceil.toString(), '6');

      p = Decimal('-5.678');
      ceil = p.ceil();
      expect(ceil.isNegative, true);
      expect(ceil.toString(), '-5');

      p = Decimal('-9.1');
      ceil = p.ceil();
      expect(ceil.isNegative, true);
      expect(ceil.toString(), '-9');

      p = Decimal('10');
      ceil = p.ceil();
      expect(ceil.toString(), '10');

      p = Decimal('10.000000000001');
      ceil = p.ceil();
      expect(ceil.toString(), '11');
    });

    test('clamp', () {
      var p = Decimal('5.678');

      var clamp = p.clamp(5.7, 6);
      expect(clamp is Decimal, true);
      expect(clamp.toString(), '5.7');

      clamp = p.clamp(5.1, 5.5111);
      expect(clamp.toString(), '5.5111');

      clamp = p.clamp(Decimal('5.69'), 100);
      expect(clamp.toString(), '5.69');

      clamp = p.clamp(0, 100);
      expect(clamp.toString(), '5.678');
      expect(identical(clamp, p), true);

      p = Decimal('-12.345');

      clamp = p.clamp(5.7, 6);
      expect(clamp.toString(), '5.7');

      clamp = p.clamp(-13, -12.5);
      expect(clamp.toString(), '-12.5');

      clamp = p.clamp(-12.20001, -6);
      expect(clamp.toString(), '-12.20001');

      clamp = p.clamp(-100, 0);
      expect(clamp.toString(), '-12.345');
      expect(identical(clamp, p), true);
    });

    test('floor', () {
      var p = Decimal('5.678');
      Number floor = p.floor();
      expect(floor is Decimal, true);
      expect((floor as Decimal).digits.length, 1);
      expect(floor.isNegative, false);
      expect(floor.power, 0);
      expect(floor.digits[0], Digit.five);
      expect(floor.toString(), '5');

      p = Decimal('-5.678');
      floor = p.floor();
      expect(floor.isNegative, true);
      expect(floor.toString(), '-6');

      p = Decimal('-9.1');
      floor = p.floor();
      expect(floor.isNegative, true);
      expect(floor.toString(), '-10');

      p = Decimal('10');
      floor = p.floor();
      expect(floor.toString(), '10');

      p = Decimal('10.000000000001');
      floor = p.floor();
      expect(floor.toString(), '10');

      p = Decimal('99.9999999999999999999999999');
      floor = p.floor();
      expect(floor.toString(), '99');

      p = Decimal('-999.9999999999999999999999999');
      floor = p.floor();
      expect(floor.toString(), '-1000');
    });

    test('isInteger', () {
      var p = Decimal('4');
      expect(p.isInteger, true);

      p = Decimal('4.0');
      expect(p.isInteger, true);

      p = Decimal('-4.0000');
      expect(p.isInteger, true);

      p = Decimal(4);
      expect(p.isInteger, true);

      p = Decimal(4.000);
      expect(p.isInteger, true);

      p = Decimal(-4);
      expect(p.isInteger, true);

      p = Decimal('4.000000000000000000000001');
      expect(p.isInteger, false);

      p = Decimal('-4.1');
      expect(p.isInteger, false);

      p = Decimal(4.0000000001);
      expect(p.isInteger, false);

      p = Decimal(-4.1);
      expect(p.isInteger, false);
    });

    test('reciprocal', () {
      final p = Decimal('4');
      final recip = p.reciprocal();
      expect(recip is Decimal, true);
      expect((recip as Decimal).digits.length, 3);
      expect(recip.isNegative, false);
      expect(recip.power, -2);
      expect(recip.digits[0], Digit.five);
      expect(recip.digits[1], Digit.two);
      expect(recip.digits[2], Digit.zero);
      expect(recip.toString(), '0.25');
    });

    test('remainder', () {
      final p = Decimal('4');
      expect(p.remainder(3), Decimal('1'));
    });

    test('round', () {
      var p = Decimal('5.678');
      Number round = p.round();
      expect(round is Decimal, true);
      expect((round as Decimal).digits.length, 1);
      expect(round.isNegative, false);
      expect(round.power, 0);
      expect(round.digits[0], Digit.six);
      expect(round.toString(), '6');

      p = Decimal('-5.678');
      round = p.round();
      expect(round.isNegative, true);
      expect(round.toString(), '-6');

      p = Decimal('1236.5');
      round = p.round();
      expect(round.isNegative, false);
      expect(round.toString(), '1237');

      p = Decimal('-1236.5');
      round = p.round();
      expect(round.isNegative, true);
      expect(round.toString(), '-1237');

      p = Decimal('1236.49999999999999999999999999999999999999');
      round = p.round();
      expect(round.isNegative, false);
      expect(round.isInteger, true);
      expect(round.toString(), '1236');

      p = Decimal('-1236.4999999999999999999999999999999999999');
      round = p.round();
      expect(round.isNegative, true);
      expect(round.isInteger, true);
      expect(round.toString(), '-1236');
    });

    test('truncate', () {
      var p = Decimal('5.678');
      Number trunc = p.truncate();
      expect(trunc is Decimal, true);
      expect((trunc as Decimal).digits.length, 1);
      expect(trunc.isNegative, false);
      expect(trunc.power, 0);
      expect(trunc.digits[0], Digit.five);
      expect(trunc.toString(), '5');

      p = Decimal('-1234.5678');
      trunc = p.truncate();
      expect(trunc.isNegative, true);
      expect(trunc.power, 0);
      expect(trunc.toString(), '-1234');

      p = Decimal('123456.78');
      trunc = p.truncate();
      expect(trunc.power, 0);
      expect(trunc.toString(), '123456');

      p = Decimal('0.999999999999999999999999999999999');
      trunc = p.truncate();
      expect(trunc.isNegative, false);
      expect(trunc.power, 0);
      expect(trunc.toString(), '0');

      p = Decimal('-0.000000000000000000000000000001');
      trunc = p.truncate();
      expect(trunc.isNegative, false);
      expect(trunc.power, 0);
      expect(trunc.toString(), '0');

      p = Decimal('10.000000000001');
      trunc = p.truncate();
      expect(trunc.isNegative, false);
      expect(trunc.power, 0);
      expect(trunc.toString(), '10');
    });
  });
}
