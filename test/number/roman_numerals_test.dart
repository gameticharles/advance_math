import 'package:advance_math/src/number/number.dart';
import 'package:test/test.dart';

void main() {
  group('RomanNumerals', () {
    test('Conversion from integer to Roman numeral', () {
      expect(RomanNumerals(5).toRoman(), 'V');
      expect(RomanNumerals(-5).toRoman(), '-V');
      expect(RomanNumerals(3999).toRoman(), 'MMMCMXCIX');
    });

    test('Conversion from Roman numeral to integer', () {
      expect(RomanNumerals.fromRoman('V').value, 5);
      expect(RomanNumerals.fromRoman('-V').value, -5);
      expect(RomanNumerals.fromRoman('MMMCMXCIX').value, 3999);
    });

    test('Utility methods', () {
      expect(RomanNumerals(0).isZero(), true);
      expect(RomanNumerals(5).isPositive(), true);
      expect(RomanNumerals(-5).isNegative(), true);
    });

    test('Arithmetic operations', () {
      expect((RomanNumerals(5) + 5).value, 10);
      expect((RomanNumerals(5) - 10).value, -5);
      expect((RomanNumerals(5) * 2).value, 10);
      expect((RomanNumerals(10) / 2).value, 5);
    });

    test('Invalid Roman numerals', () {
      expect(() => RomanNumerals.fromRoman('IIII'), 
          throwsA(TypeMatcher<InvalidRomanNumeralException>()));
      expect(() => RomanNumerals.fromRoman('VV'),
          throwsA(TypeMatcher<InvalidRomanNumeralException>()));
      expect(() => RomanNumerals.fromRoman('XXXX'),
          throwsA(TypeMatcher<InvalidRomanNumeralException>()));
    });

    test('Bitwise operations', () {
      expect((RomanNumerals(5) & 3).value, 1);
      expect((RomanNumerals(5) | 3).value, 7);
      expect((RomanNumerals(5) ^ 3).value, 6);
    });

    test('Shift operations', () {
      expect((RomanNumerals(5) << 1).value, 10);
      expect((RomanNumerals(5) >> 1).value, 2);
    });

    test('Equality checks', () {
      expect(RomanNumerals(5) == RomanNumerals(5), true);
      expect(RomanNumerals(-5) == RomanNumerals(-5), true);
      expect(RomanNumerals(5) == RomanNumerals(-5), false);
    });
  });
}
