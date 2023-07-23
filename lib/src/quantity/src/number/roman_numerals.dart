class RomanNumerals {
  static const Map<String, int> _numerals = {
    'M': 1000,
    'CM': 900,
    'D': 500,
    'CD': 400,
    'C': 100,
    'XC': 90,
    'L': 50,
    'XL': 40,
    'X': 10,
    'IX': 9,
    'V': 5,
    'IV': 4,
    'I': 1
  };

  /// Extended Roman numerals
  static const Map<String, int> _extendedNumerals = {
    '_M': 1000000, // Represents an overlined M (1,000,000)
    '_D': 500000, // Represents an overlined D (500,000)
    '_C': 100000, // Represents an overlined C (100,000)
    '_L': 50000, // Represents an overlined L (50,000)
    '_X': 10000, // Represents an overlined X (10,000)
    '_V': 5000, // Represents an overlined V (5,000)
  };

  // Combining standard and extended numerals
  static final Map<String, int> _allNumerals = {
    ..._extendedNumerals,
    ..._numerals,
  };

  final int value;

  static final Map<int, String> _numToRomanCache = {};
  static final Map<String, int> _romanToNumCache = {};

  RomanNumerals(this.value) {
    if (value < 0) {
      throw ArgumentError('Roman numerals cannot represent negative numbers.');
    }
  }

  RomanNumerals.fromRoman(String roman) : value = _fromRoman(roman);

  static int _fromRoman(String roman) {
    roman = roman.toUpperCase();

    // Using cache's putIfAbsent to streamline caching
    return _romanToNumCache.putIfAbsent(roman, () {
      int result = 0;
      int prevValue = 0;
      int i = roman.length - 1;

      while (i >= 0) {
        String currentSymbol =
            (i > 0 && _allNumerals.containsKey(roman.substring(i - 1, i + 1)))
                ? roman.substring(i - 1, i + 1)
                : roman[i];

        int? currentValue = _allNumerals[currentSymbol];
        if (currentValue == null) {
          throw ArgumentError('Invalid Roman numeral: $roman');
        }

        if (currentValue < prevValue) {
          result -= currentValue;
        } else {
          result += currentValue;
        }
        prevValue = currentValue;

        i -= currentSymbol.length;
      }

      // Cache the converse for improved performance
      _numToRomanCache[result] = roman;

      return result;
    });
  }

  /// Converts an integer to a Roman numeral string.
  String toRoman() {
    // Using cache's putIfAbsent to streamline caching
    return _numToRomanCache.putIfAbsent(value, () {
      if (value <= 0) {
        throw ArgumentError(
            'Number out of range. Roman numerals support positive numbers.');
      }

      int number = value;
      StringBuffer result = StringBuffer();

      // Loop through the combined numerals, from largest to smallest
      for (var entry in _allNumerals.entries) {
        while (number >= entry.value) {
          number -= entry.value;
          result.write(entry.key);
        }
      }

      // Cache the converse for improved performance
      _romanToNumCache[result.toString()] = value;

      return result.toString();
    });
  }

  /// Validates if the string is a valid Roman numeral.
  static bool isValidRoman(String roman) {
    try {
      _fromRoman(roman);
      return true;
    } catch (_) {
      return false;
    }
  }

  // Operator overrides
  RomanNumerals operator +(RomanNumerals other) {
    return RomanNumerals(value + other.value);
  }

  RomanNumerals operator -(RomanNumerals other) {
    return RomanNumerals(value - other.value);
  }

  RomanNumerals operator *(RomanNumerals other) {
    return RomanNumerals(value * other.value);
  }

  RomanNumerals operator /(RomanNumerals other) {
    if (other.value == 0) {
      throw ArgumentError('Division by zero is not allowed.');
    }
    return RomanNumerals((value / other.value).round());
  }

  bool operator <(RomanNumerals other) {
    return value < other.value;
  }

  bool operator <=(RomanNumerals other) {
    return value <= other.value;
  }

  bool operator >(RomanNumerals other) {
    return value > other.value;
  }

  bool operator >=(RomanNumerals other) {
    return value >= other.value;
  }

  RomanNumerals operator &(RomanNumerals other) {
    return RomanNumerals(value & other.value);
  }

  RomanNumerals operator |(RomanNumerals other) {
    return RomanNumerals(value | other.value);
  }

  RomanNumerals operator ^(RomanNumerals other) {
    return RomanNumerals(value ^ other.value);
  }

  RomanNumerals operator %(RomanNumerals other) {
    return RomanNumerals(value % other.value);
  }

  RomanNumerals operator <<(int shift) {
    return RomanNumerals(value << shift);
  }

  RomanNumerals operator >>(int shift) {
    return RomanNumerals(value >> shift);
  }

  RomanNumerals operator ~() {
    return RomanNumerals(~value);
  }

  @override
  bool operator ==(Object other) {
    if (other is RomanNumerals) {
      return value == other.value;
    }
    return false;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return toRoman();
  }
}
