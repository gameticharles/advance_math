part of 'roman_numerals.dart';

extension RomanNumeralsInt on int {
  /// A map of common Roman numeral values to their corresponding letter representations.
  /// This map is used to convert integers to their Roman numeral string equivalents.
  static final _sharedRomanNumbersToLetters = {
    1: 'I',
    4: 'IV',
    5: 'V',
    9: 'IX',
    10: 'X',
    40: 'XL',
    50: 'L',
    90: 'XC',
    100: 'C',
    400: 'CD',
    500: 'D',
    900: 'CM',
  };

  /// A map of compact apostrophus Roman numeral values to their corresponding letter representations.
  /// This map is used to convert integers to their compact apostrophus Roman numeral string equivalents.
  static final _compactApostrophusRomanNumbersToLetters = {
    1: 'I',
    4: 'IV',
    5: 'V',
    9: 'IX',
    10: 'X',
    40: 'XL',
    50: 'L',
    90: 'XC',
    100: 'C',
    400: 'CCCC',
    500: 'D',
    900: 'Cↀ',
    1000: 'ↀ',
    4000: 'ↀↁ',
    5000: 'ↁ',
    9000: 'ↀↂ',
    10000: 'ↂ',
    40000: 'ↂↇ',
    50000: 'ↇ',
    90000: 'ↂↈ',
    100000: 'ↈ'
  };

  /// A map of apostrophus Roman numeral values to their corresponding letter representations.
  /// This map is used to convert integers to their compact apostrophus Roman numeral string equivalents.
  static final _apostrophusRomanNumbersToLetters = {
    1: 'I',
    4: 'IV',
    5: 'V',
    9: 'IX',
    10: 'X',
    40: 'XL',
    50: 'L',
    90: 'XC',
    100: 'C',
    400: 'CCCC',
    500: 'IↃ',
    900: 'CCIↃ',
    1000: 'CIↃ',
    4000: 'CIↃIↃↃ',
    5000: 'IↃↃ',
    9000: 'CIↃCCIↃↃ',
    10000: 'CCIↃↃ',
    40000: 'CCIↃↃIↃↃↃ',
    50000: 'IↃↃↃ',
    90000: 'CCIↃↃCCCIↃↃↃ',
    100000: 'CCCIↃↃↃ',
    400000: 'CCCIↃↃↃIↃↃↃↃ',
    500000: 'IↃↃↃↃ',
    900000: 'CCCIↃↃↃCCCCIↃↃↃↃ',
    1000000: 'CCCCIↃↃↃↃ'
  };

  /// A map that defines the mapping between common Roman numeral values and their corresponding letter representations.
  /// This map is used to convert integers to their common Roman numeral string equivalents.
  static final _commonRomanNumbersToLetters = {1000: 'M'};

// \u{0304} - combining macron
// \u{0305} - combining overline
// Prefer the overline here, as the ancestry of the "line over the number"
// called "vinculum" comes from mathematics, whereas the macron is a
// diacritical mark.
  static final _vinculumRomanNumbersToLetters = {
    1000: 'M',
    4000: 'MV\u{0305}',
    5000: 'V\u{0305}',
    9000: 'MX\u{0305}',
    10000: 'X\u{0305}',
    40000: 'X\u{0305}L\u{0305}',
    50000: 'L\u{0305}',
    90000: 'X\u{0305}C\u{0305}',
    100000: 'C\u{0305}',
    400000: 'C\u{0305}D\u{0305}',
    500000: 'D\u{0305}',
    900000: 'C\u{0305}M\u{0305}',
    1000000: 'M\u{0305}',
  };

  /// Confirms or not confirms a valid Roman numeral value. This
  /// may change for the same [int] depending on the [RomanNumeralsConfig].
  bool isValidRomanNumeralValue({RomanNumeralsConfig? config}) {
    config ??= romanNumeralConfig;

    // Check the maximum values.
    switch (config.configType) {
      case RomanNumeralsType.common:
        return !(this > 3999);
      case RomanNumeralsType.apostrophus:
        final aConfig = config as ApostrophusRomanNumeralsConfig;
        if (aConfig.compact) {
          return !(this > 399999);
        } else {
          return !(this > 3999999);
        }
      case RomanNumeralsType.vinculum:
        return !(this > 3999999);
    }
  }

  /// Create Roman numeral [String] from this [int]. Rules for creation are read
  /// from the optional [config].
  String? toRomanNumeralString({RomanNumeralsConfig? config}) {
    config ??= romanNumeralConfig;

    if (!isValidRomanNumeralValue(config: config)) {
      return null;
    }

    // Handle zero with a special case.
    final nulla = config.nulla;
    if (this == 0) {
      return nulla.substring(0, 1).toUpperCase();
    }

    Map<int, String> useMap;
    switch (config.configType) {
      case RomanNumeralsType.common:
        useMap = {
          ..._sharedRomanNumbersToLetters,
          ..._commonRomanNumbersToLetters
        };
        break;
      case RomanNumeralsType.apostrophus:
        useMap = {};
        final aConfig = config as ApostrophusRomanNumeralsConfig;
        if (aConfig.compact) {
          useMap = _compactApostrophusRomanNumbersToLetters;
        } else {
          useMap = _apostrophusRomanNumbersToLetters;
        }
        break;
      case RomanNumeralsType.vinculum:
        useMap = {
          ..._sharedRomanNumbersToLetters,
          ..._vinculumRomanNumbersToLetters
        };
        break;
    }
    List<int> nRevMap = useMap.keys.toList();
    nRevMap.sort((a, b) => b.compareTo(a));

    var curString = '';
    var accum = abs();
    var nIndex = 0;
    while (accum > 0) {
      var divisor = nRevMap[nIndex];
      var units = accum ~/ divisor;

      /**
       - When we have any amount of quotient > 0, add the current numeral to the return-string,
          subtract the amount from the accumulator, and continue.
       - When the quotient is zero, then increment the index of the number-value array to the next number.
       */
      if (units > 0) {
        var got = useMap[divisor];
        if (got != null) {
          curString += got;
          accum -= divisor;
        }
      } else {
        nIndex += 1;
      }
    }
    return (this < 0) ? '-$curString' : curString;
  }
}
