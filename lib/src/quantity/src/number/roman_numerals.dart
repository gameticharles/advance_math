/// A class to convert between Roman and decimal numerals.
///
/// The class provides functionality to represent an integer as a Roman numeral
/// and vice versa. For numbers greater than 3999, a bracket notation is used
/// to represent multiplication by 1000.
///
/// Example:
///
/// ```dart
/// var numeral = RomanNumerals(4567);
/// print(numeral); // Outputs: (IV)DLXVII
///
/// var numeralFromRoman = RomanNumerals.fromRoman('(IV)DLXVII');
/// print(numeralFromRoman.value); // Outputs: 4567
/// ```
class RomanNumerals {
  /// A private constant map that represents the standard numerals.
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

  /// The integer value represented by this instance.
  final int value;

  /// Private cache to improve performance for the conversion methods.
  static final Map<int, String> _numToRomanCache = {};
  static final Map<String, int> _romanToNumCache = {};

  /// Constructs a [RomanNumerals] object from a given integer [value].
  ///
  /// Throws an [ArgumentError] if [value] is negative.
  ///
  /// Example:
  /// ```dart
  /// print(RomanNumerals(69)); // LXIX
  /// print(RomanNumerals(8785)); // (VIII)DCCLXXXV
  /// ```
  RomanNumerals(this.value) {
    if (value < 0) {
      throw ArgumentError('Roman numerals cannot represent negative numbers.');
    }
  }

  /// Constructs a [RomanNumerals] object from a given Roman numeral [roman].
  ///
  /// Example:
  /// ```dart
  /// var numeral = RomanNumerals.fromRoman('XIV'); // 14
  /// ```
  RomanNumerals.fromRoman(String roman) : value = _fromRoman(roman);

  /// A private method to convert a Roman numeral string to an integer.
  static int _fromRoman(String roman) {
    roman = roman.toUpperCase();

    // Using cache's putIfAbsent to streamline caching
    return _romanToNumCache.putIfAbsent(roman, () {
      int result = 0;
      int prevValue = 0;
      int i = roman.length - 1;

      while (i >= 0) {
        // Check if the current character is a parenthesis
        if (roman[i] == ')') {
          // Find the matching opening parenthesis
          int j = roman.lastIndexOf('(', i);
          if (j == -1) {
            throw ArgumentError('Invalid Roman numeral: $roman');
          }

          // Convert the part of the string inside the parentheses
          String innerRoman = roman.substring(j + 1, i);
          int innerValue = _fromRomanWithoutParentheses(innerRoman);
          result += innerValue * 1000;

          i = j - 1;
        } else {
          String currentSymbol = roman[i];

          int? currentValue = _numerals[currentSymbol];
          if (currentValue == null) {
            throw ArgumentError('Invalid Roman numeral: $roman');
          }

          if (currentValue < prevValue) {
            result -= currentValue;
          } else {
            result += currentValue;
          }
          prevValue = currentValue;

          i--;
        }
      }

      // Cache the converse for improved performance
      _numToRomanCache[result] = roman;

      return result;
    });
  }

  /// A helper private method to convert a Roman numeral string
  /// (without parentheses) to an integer.
  static int _fromRomanWithoutParentheses(String roman) {
    int result = 0;
    int prevValue = 0;
    int i = roman.length - 1;

    while (i >= 0) {
      String currentSymbol = roman[i];

      int? currentValue = _numerals[currentSymbol];
      if (currentValue == null) {
        throw ArgumentError('Invalid Roman numeral: $roman');
      }

      if (currentValue < prevValue) {
        result -= currentValue;
      } else {
        result += currentValue;
      }
      prevValue = currentValue;

      i--;
    }

    return result;
  }

  /// Converts the integer value of this instance to a Roman numeral string.
  ///
  /// Example:
  /// ```dart
  /// var numeral = RomanNumerals(14);
  /// print(numeral.toRoman());  // Outputs: XIV
  /// ```
  String toRoman() {
    // Using cache's putIfAbsent to streamline caching
    return _numToRomanCache.putIfAbsent(value, () {
      if (value <= 0) {
        throw ArgumentError(
            'Number out of range. Roman numerals support positive numbers.');
      }

      int number = value;
      StringBuffer result = StringBuffer();

      // If the value is more than 3999, use brackets for the thousands part
      if (value > 3999) {
        int thousands = value ~/ 1000;
        number %= 1000;
        result.write('(${_toRomanWithoutParentheses(thousands)})');
      }

      // Then handle the rest of the number
      result.write(_toRomanWithoutParentheses(number));

      // Cache the converse for improved performance
      _romanToNumCache[result.toString()] = value;

      return result.toString();
    });
  }

  /// A helper private method to convert an integer to a Roman numeral string
  /// without using parentheses.
  String _toRomanWithoutParentheses(int value) {
    int number = value;
    StringBuffer result = StringBuffer();

    // Loop through the numerals, from largest to smallest
    for (var entry in _numerals.entries) {
      while (number >= entry.value) {
        number -= entry.value;
        result.write(entry.key);
      }
    }

    return result.toString();
  }

  /// Validates if a given string [roman] is a valid Roman numeral.
  ///
  /// Returns `true` if [roman] is a valid Roman numeral, `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// print(RomanNumerals.isValidRoman('XIV'));  // Outputs: true
  /// print(RomanNumerals.isValidRoman('XIVV')); // Outputs: false
  /// ```
  static bool isValidRoman(String roman) {
    try {
      _fromRoman(roman);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Adds the values of two [RomanNumerals] objects and returns a new one.
  RomanNumerals operator +(RomanNumerals other) {
    return RomanNumerals(value + other.value);
  }

  /// Subtracts the value of another [RomanNumerals] from this one and returns a new one.
  RomanNumerals operator -(RomanNumerals other) {
    if (value - other.value < 0) {
      throw ArgumentError(
          'Result of subtraction cannot be a negative value in Roman numerals.');
    }
    return RomanNumerals(value - other.value);
  }

  /// Multiplies the values of two [RomanNumerals] objects and returns a new one.
  RomanNumerals operator *(RomanNumerals other) {
    return RomanNumerals(value * other.value);
  }

  /// Divides the value of this [RomanNumerals] by another and returns a new one.
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

  @override
  bool operator ==(Object other) {
    if (other is RomanNumerals) {
      return value == other.value;
    }
    return false;
  }

  @override
  int get hashCode => value.hashCode;

  /// Returns the Roman numeral string representation of this instance.
  @override
  String toString() {
    return toRoman();
  }
}
