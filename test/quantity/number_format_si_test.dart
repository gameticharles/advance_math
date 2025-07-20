import 'package:advance_math/src/quantity/quantity.dart';
import 'package:test/test.dart';

void main() {
  group('NumberFormatSI', () {
    group('insertSpaces', () {
      test('regular spaces; no uncertainty', () {
        final f1 = NumberFormatSI(unicode: false);
        expect(f1.insertSpaces('1'), '1');
        expect(f1.insertSpaces('12'), '12');
        expect(f1.insertSpaces('123'), '123');
        expect(f1.insertSpaces('1234'), '1234');
        expect(f1.insertSpaces('12345'), '12 345');
        expect(f1.insertSpaces('123456'), '123 456');
        expect(f1.insertSpaces('1234567'), '1 234 567');
        expect(f1.insertSpaces('12345678'), '12 345 678');
        expect(f1.insertSpaces('123456789'), '123 456 789');
        expect(f1.insertSpaces('1234567890'), '1 234 567 890');

        expect(f1.insertSpaces('0.0'), '0.0');
        expect(f1.insertSpaces('10.01'), '10.01');
        expect(f1.insertSpaces('100.001'), '100.001');
        expect(f1.insertSpaces('1000.0001'), '1000.0001');
        expect(f1.insertSpaces('10000.00001'), '10 000.000 01');
        expect(f1.insertSpaces('9876543210.1234'), '9 876 543 210.1234');
        expect(f1.insertSpaces('1234.9876543210'), '1234.987 654 321 0');
      });

      test('unicode thin spaces; no uncertainty', () {
        final f1 = NumberFormatSI(unicode: true);
        expect(f1.insertSpaces('1'), '1');
        expect(f1.insertSpaces('12'), '12');
        expect(f1.insertSpaces('123'), '123');
        expect(f1.insertSpaces('1234'), '1234');
        expect(f1.insertSpaces('12345'), '12\u{2009}345');
        expect(f1.insertSpaces('123456'), '123\u{2009}456');
        expect(f1.insertSpaces('1234567'), '1\u{2009}234\u{2009}567');
        expect(f1.insertSpaces('12345678'), '12\u{2009}345\u{2009}678');
        expect(f1.insertSpaces('123456789'), '123\u{2009}456\u{2009}789');
        expect(f1.insertSpaces('1234567890'),
            '1\u{2009}234\u{2009}567\u{2009}890');

        expect(f1.insertSpaces('0.0'), '0.0');
        expect(f1.insertSpaces('10.01'), '10.01');
        expect(f1.insertSpaces('100.001'), '100.001');
        expect(f1.insertSpaces('1000.0001'), '1000.0001');
        expect(f1.insertSpaces('10000.00001'), '10\u{2009}000.000\u{2009}01');
        expect(f1.insertSpaces('9876543210.1234'),
            '9\u{2009}876\u{2009}543\u{2009}210.1234');
        expect(f1.insertSpaces('1234.9876543210'),
            '1234.987\u{2009}654\u{2009}321\u{2009}0');
      });
    });

    group('format', () {
      test('real only; num; regular spaces', () {
        final f1 = NumberFormatSI(unicode: false);
        expect(f1.format(1), '1');
        expect(f1.format(12), '12');
        expect(f1.format(123), '123');
        expect(f1.format(1234), '1234');
        expect(f1.format(12345), '12 345');
        expect(f1.format(123456), '123 456');
        expect(f1.format(1234567), '1 234 567');
        expect(f1.format(12345678), '12 345 678');
        expect(f1.format(123456789), '123 456 789');
        expect(f1.format(1234567890), '1 234 567 890');

        expect(f1.format(0.0), '0.0');
        expect(f1.format(10.01), '10.01');
        expect(f1.format(100.001), '100.001');
        expect(f1.format(1000.0001), '1000.0001');
        expect(f1.format(10000.00001), '10 000.000 01');
        expect(f1.format(9876543210.1234), '9 876 543 210.1234');
        expect(f1.format(1234.9876543219), '1234.987 654 321 9');
      });

      test('real only; Number; regular spaces', () {
        final f1 = NumberFormatSI(unicode: false);
        expect(f1.format(Integer(1)), '1');
        expect(f1.format(Integer(12)), '12');
        expect(f1.format(Integer(123)), '123');
        expect(f1.format(Integer(1234)), '1234');
        expect(f1.format(Integer(12345)), '12 345');
        expect(f1.format(Integer(123456)), '123 456');
        expect(f1.format(Integer(1234567)), '1 234 567');
        expect(f1.format(Integer(12345678)), '12 345 678');
        expect(f1.format(Integer(123456789)), '123 456 789');
        expect(f1.format(Integer(1234567890)), '1 234 567 890');

        expect(f1.format(Double(0)), '0.0');
        expect(f1.format(Double(10.01)), '10.01');
        expect(f1.format(Double(100.001)), '100.001');
        expect(f1.format(Double(1000.0001)), '1000.0001');
        expect(f1.format(Double(10000.00001)), '10 000.000 01');
        expect(f1.format(Double(9876543210.1234)), '9 876 543 210.1234');
        expect(f1.format(Double(1234.9876543219)), '1234.987 654 321 9');
      });

      test('imaginary only; regular spaces', () {
        final f1 = NumberFormatSI(unicode: false);
        expect(f1.format(Imaginary(1)), '1i');
        expect(f1.format(Imaginary(12)), '12i');
        expect(f1.format(Imaginary(123)), '123i');
        expect(f1.format(Imaginary(1234)), '1234i');
        expect(f1.format(Imaginary(12345)), '12 345i');
        expect(f1.format(Imaginary(123456)), '123 456i');
        expect(f1.format(Imaginary(1234567)), '1 234 567i');
        expect(f1.format(Imaginary(12345678)), '12 345 678i');
        expect(f1.format(Imaginary(123456789)), '123 456 789i');
        expect(f1.format(Imaginary(1234567890)), '1 234 567 890i');

        expect(f1.format(Imaginary(0.0)), '0.0i');
        expect(f1.format(Imaginary(10.01)), '10.01i');
        expect(f1.format(Imaginary(100.001)), '100.001i');
        expect(f1.format(Imaginary(1000.0001)), '1000.0001i');
        expect(f1.format(Imaginary(10000.00001)), '10 000.000 01i');
        expect(f1.format(Imaginary(9876543210.1234)), '9 876 543 210.1234i');
        expect(f1.format(Imaginary(1234.9876543219)), '1234.987 654 321 9i');
      });

      test('complex; regular spaces', () {
        final f1 = NumberFormatSI(unicode: false);
        expect(f1.format(Complex(1, 2)), '1 + 2i');
        expect(f1.format(Complex(1, 0)), '1');
        expect(f1.format(Complex(0, 2)), '2i');
        expect(f1.format(Complex(12, 21)), '12 + 21i');
        expect(f1.format(Complex(123, 321)), '123 + 321i');
        expect(f1.format(Complex(1234, 4321)), '1234 + 4321i');
        expect(f1.format(Complex(12345, 54321)), '12 345 + 54 321i');
        expect(f1.format(Complex(123456, 654321)), '123 456 + 654 321i');
        expect(f1.format(Complex(1234567, 7654321)), '1 234 567 + 7 654 321i');
        expect(
            f1.format(Complex(12345678, 87654321)), '12 345 678 + 87 654 321i');
        expect(f1.format(Complex(123456789, 987654321)),
            '123 456 789 + 987 654 321i');
        expect(f1.format(Complex(1234567898, 8987654321)),
            '1 234 567 898 + 8 987 654 321i');

        expect(f1.format(Complex(0, 0)), '0');
        expect(f1.format(Complex(10.01, 11.22)), '10.01 + 11.22i');
        expect(f1.format(Complex(100.001, 111.222)), '100.001 + 111.222i');
        expect(
            f1.format(Complex(1000.0001, 1111.2222)), '1000.0001 + 1111.2222i');
        expect(f1.format(Complex(10000.00001, 11111.22222)),
            '10 000.000 01 + 11 111.222 22i');
        expect(f1.format(Complex(9876543210.1234, 4321.0123456789)),
            '9 876 543 210.1234 + 4321.012 345 678 9i');
      });

      test('removeInsignificantZeros', () {
        expect(NumberFormatSI.removeInsignificantZeros('10'), '10');
        expect(NumberFormatSI.removeInsignificantZeros('100'), '100');
        expect(NumberFormatSI.removeInsignificantZeros('1000'), '1000');
        expect(NumberFormatSI.removeInsignificantZeros('10001'), '10001');
        expect(NumberFormatSI.removeInsignificantZeros('100010'), '100010');
        expect(NumberFormatSI.removeInsignificantZeros('0.0'), '0.0');
        expect(NumberFormatSI.removeInsignificantZeros('0.00'), '0.0');
        expect(NumberFormatSI.removeInsignificantZeros('0.000'), '0.0');
        expect(NumberFormatSI.removeInsignificantZeros('0.0001'), '0.0001');
        expect(NumberFormatSI.removeInsignificantZeros('0.00010'), '0.0001');
        expect(NumberFormatSI.removeInsignificantZeros('1.0'), '1.0');
        expect(NumberFormatSI.removeInsignificantZeros('1.00'), '1.0');
        expect(NumberFormatSI.removeInsignificantZeros('1.00000000000000000'),
            '1.0');
        expect(
            NumberFormatSI.removeInsignificantZeros(
                '-9000001.00000000000600000'),
            '-9000001.000000000006');
        expect(NumberFormatSI.removeInsignificantZeros('5E7'), '5E7');
        expect(NumberFormatSI.removeInsignificantZeros('5.870E12'), '5.87E12');
        expect(
            NumberFormatSI.removeInsignificantZeros('5.920000E31'), '5.92E31');
      });
    });

    group('parse', () {
      test('real with regular spaces', () {
        final f1 = NumberFormatSI(unicode: false);
        expect(f1.parse('12 345'), 12345);
        expect(f1.parse('12 345.678 90'), 12345.67890);
        expect(f1.parse('1\u{2009}234\u{2009}567'), 1234567);
      });
    });
  });
}
