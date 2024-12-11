import 'package:advance_math/src/math/algebra/bases/bases.dart';
import 'package:test/test.dart';

void main() {
  group('Bases.isValidForBase', () {
    test('Validates characters correctly', () {
      expect(Bases.isValidForBase("1A", 16), isTrue);
      expect(Bases.isValidForBase("1G", 16), isFalse);
      expect(Bases.isValidForBase("101", 2), isTrue);
      expect(Bases.isValidForBase("102", 2), isFalse);
      expect(Bases.isValidForBase("ABcd+", 64), isTrue);
    });
  });

  group('Bases.toDecimal', () {
    test('Converts valid base-n numbers to decimal', () {
      expect(Bases.toDecimal("A", 16), equals(10));
      expect(Bases.toDecimal("101", 2), equals(5));
      expect(Bases.toDecimal("ZZ", 36), equals(1295));
      expect(Bases.toDecimal("z/", 64), equals(4095));
    });

    test('Throws error for invalid characters', () {
      expect(() => Bases.toDecimal("1G", 16), throwsArgumentError);
    });
  });

  group('Bases.fromDecimal', () {
    test('Converts decimal to valid base-n numbers', () {
      expect(Bases.fromDecimal(255, 16), equals("FF"));
      expect(Bases.fromDecimal(5, 2), equals("101"));
      expect(Bases.fromDecimal(1295, 36), equals("ZZ"));
      expect(Bases.fromDecimal(4095, 64), equals("z/"));
    });

    test('Handles padding correctly', () {
      expect(Bases.fromDecimal(5, 2, padLength: 8), equals("00000101"));
    });

    test('Throws error for invalid base', () {
      expect(() => Bases.fromDecimal(255, 65), throwsArgumentError);
    });
  });

  group('Bases.convert', () {
    test('Converts between arbitrary bases', () {
      expect(Bases.convert("A", 16, 2), equals("1010"));
      expect(Bases.convert("1010", 2, 16), equals("A"));
      expect(Bases.convert("ZZ", 36, 64), equals("z/"));
    });

    test('Throws error for invalid bases', () {
      expect(() => Bases.convert("A", 16, 65), throwsArgumentError);
    });
  });

  group('Bases.rangeInBase', () {
    test('Generates a range of numbers in target base', () {
      expect(Bases.rangeInBase(0, 5, 2),
          equals(["0", "1", "10", "11", "100", "101"]));
      expect(Bases.rangeInBase(4, 8, 16), equals(["4", "5", "6", "7", "8"]));
      expect(Bases.rangeInBase(10, 15, 64),
          equals(["A", "B", "C", "D", "E", "F"]));
    });

    test('Throws error for invalid base', () {
      expect(() => Bases.rangeInBase(0, 5, 65), throwsArgumentError);
    });
  });

  group('Specialized conversions', () {
    test('Binary to Decimal', () {
      expect(Bases.binaryToDecimal("1011"), equals("11"));
    });

    test('Decimal to Binary', () {
      expect(Bases.decimalToBinary("11"), equals("1011"));
    });

    test('Hex to Decimal', () {
      expect(Bases.hexToDecimal("A"), equals("10"));
    });

    test('Decimal to Hex', () {
      expect(Bases.decimalToHex("255"), equals("FF"));
    });

    test('Octal to Decimal', () {
      expect(Bases.octalToDecimal("17"), equals("15"));
    });

    test('Decimal to Octal', () {
      expect(Bases.decimalToOctal("15"), equals("17"));
    });
  });
}
