import 'package:intl/intl.dart';

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

    // Handle the special case for zero
    if (roman == 'N') {
      return 0;
    }

    // Validate the provided Roman numeral
    if (!_validateRoman(roman)) {
      throw ArgumentError('Invalid Roman numeral: $roman');
    }

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
    // Handle the special case for zero
    if (value == 0) {
      return 'N';
    }

    // Using cache's putIfAbsent to streamline caching
    return _numToRomanCache.putIfAbsent(value, () {
      if (value < 0) {
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

  /// Helper private method to check the roman numeral string
  static bool _validateRoman(String roman) {
    // 1. Invalid Characters
    if (RegExp(r"[^MDCLXVI()]").hasMatch(roman)) {
      return false;
    }

    // 2. Invalid Repetitions
    if (RegExp(r"D{2,}|L{2,}|V{2,}").hasMatch(roman)) {
      return false;
    }

    // 3. Check for more than three consecutive I, X, or C characters
    if (RegExp(r"I{4,}|X{4,}|C{4,}").hasMatch(roman)) {
      return false;
    }

    // 4. Invalid subtractive combinations
    if (RegExp(r"IL|IC|ID|IM|XD|XM|VX|VL|VC|VD|VM|LC|LD|LM|DM")
        .hasMatch(roman)) {
      return false;
    }

    // 5. Bracket Check
    int openBrackets = roman.split('(').length - 1;
    int closeBrackets = roman.split(')').length - 1;
    if (openBrackets != closeBrackets) {
      return false;
    }

    // 6. Subtractive Notation Inside Brackets
    RegExp bracketPattern = RegExp(r"\(([^)]+)\)");
    Iterable<Match> matches = bracketPattern.allMatches(roman);
    for (Match match in matches) {
      if (RegExp(r"[^M]").hasMatch(match.group(1)!)) {
        return false;
      }
    }

    // 7. Non-Decreasing Inside Brackets
    for (Match match in matches) {
      String bracketContent = match.group(1)!;
      for (int i = 1; i < bracketContent.length; i++) {
        if (_numerals[bracketContent[i]]! > _numerals[bracketContent[i - 1]]!) {
          return false;
        }
      }
    }

    // Additional: Invalid Order (outside of subtractive notations)
    // E.g., MC (1100) is valid, CM (900) is valid
    List<String> romanChars = roman.split('');
    for (int i = 1; i < romanChars.length; i++) {
      if (_numerals.containsKey(romanChars[i - 1] + romanChars[i])) {
        continue; // Skip valid subtractive pairs
      }
      if (_numerals[romanChars[i]]! > _numerals[romanChars[i - 1]]!) {
        return false;
      }
    }

    return true;
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

  /// Converts a date represented as a string to its Roman numeral representation.
  ///
  /// The [date] parameter should be the date string and [format] should be the corresponding format of the date.
  /// Supported formats are those supported by the `DateFormat` class from the `intl` package.
  ///
  /// The separator between the Roman numerals in the output string can also be
  /// customized using the `sep` parameter. By default, it is ' • '.
  ///
  /// Example:
  /// ```dart
  /// print(RomanNumerals.dateToRoman('August 22, 1989', format: 'MMMM d, y')); // Outputs: VIII • XXII • MCMLXXXIX
  /// print(RomanNumerals.dateToRoman('Dec-23, 2017', format: 'MMM-d, y'));    // Outputs: XII • XXIII • MMXVII
  /// print(RomanNumerals.dateToRoman('Jul-21, 2016', format: 'MMM-d, y'));    // Outputs: VII • XXI • MMXVI
  /// ```
  ///
  /// Returns the date in Roman numeral format.
  static String dateToRoman(String date,
      {String sep = ' • ', String format = 'MMM-d, y'}) {
    // Parse the date using the provided format
    DateTime parsedDate = DateFormat(format).parse(date);

    // Convert the day, month, and year components to Roman numerals
    String dayRoman = RomanNumerals(parsedDate.day).toRoman();
    String monthRoman = RomanNumerals(parsedDate.month).toRoman();
    String yearRoman = RomanNumerals(parsedDate.year).toRoman();

    // Return the formatted string
    return '$monthRoman$sep$dayRoman$sep$yearRoman';
  }

  /// Converts a Roman numeral representation of a date back to a standard date.
  ///
  /// The date format can be customized using the `format` parameter. By default,
  /// the returned date will be in the format 'MMM-d, y' (e.g., 'Aug-22, 1989').
  ///
  /// The separator between the Roman numerals in the input string can also be
  /// customized using the `sep` parameter. By default, it is ' • '.
  ///
  /// Example:
  /// ```dart
  /// print(RomanNumerals.romanToDate('VIII • XXII • MCMLXXXIX')); // Outputs: Aug-22, 1989
  /// print(RomanNumerals.romanToDate('VIII・XXII・MCMLXXXIX', sep: '・', format: 'MMMM d, y')); // Outputs: August 22, 1989
  /// ```
  ///
  /// Returns the date in the specified format.
  static String romanToDate(String romanDate,
      {String sep = ' • ', String format = 'MMM-d, y'}) {
    final parts = romanDate.split(sep);
    if (parts.length != 3) {
      throw ArgumentError('Invalid Roman numeral date format.');
    }

    final month = RomanNumerals.fromRoman(parts[0].trim()).value;
    final day = RomanNumerals.fromRoman(parts[1].trim()).value;
    final year = RomanNumerals.fromRoman(parts[2].trim()).value;

    final dt = DateTime(year, month, day);
    return DateFormat(format).format(dt);
  }

  /// Adds the values of two [dynamic] objects and returns a new one.
  RomanNumerals operator +(dynamic other) {
    int newValue = 0;
    if (other is num) {
      newValue = value + other.toInt();
    } else if (other is String && _validateRoman(other)) {
      newValue = value + RomanNumerals.fromRoman(other).value;
    } else if (other is RomanNumerals) {
      newValue = value + other.value;
    } else {
      throw ArgumentError('Not valid type for Roman numerals.');
    }
    return RomanNumerals(newValue);
  }

  /// Subtracts the value of another [RomanNumerals] from this one and returns a new one.
  RomanNumerals operator -(dynamic other) {
    int newValue = 0;
    if (other is num) {
      newValue = value - other.toInt();
    } else if (other is String && _validateRoman(other)) {
      newValue = value - RomanNumerals.fromRoman(other).value;
    } else if (other is RomanNumerals) {
      newValue = value - other.value;
    } else {
      throw ArgumentError('Not valid type for Roman numerals.');
    }
    print(newValue);
    if (newValue < 0) {
      throw ArgumentError(
          'Result of subtraction cannot be a negative value in Roman numerals.');
    }

    return RomanNumerals(newValue);
  }

  /// Multiplies the values of two [RomanNumerals] objects and returns a new one.
  RomanNumerals operator *(dynamic other) {
    int newValue = 0;
    if (other is num) {
      newValue = value * other.toInt();
    } else if (other is String && _validateRoman(other)) {
      newValue = value * RomanNumerals.fromRoman(other).value;
    } else if (other is RomanNumerals) {
      newValue = value * other.value;
    } else {
      throw ArgumentError('Not valid type for Roman numerals.');
    }
    return RomanNumerals(newValue);
  }

  /// Divides the value of this [RomanNumerals] by another and returns a new one.
  RomanNumerals operator /(dynamic other) {
    if ((other is RomanNumerals && other.value == 0) ||
        (other is num && other <= 0)) {
      throw ArgumentError('Division by negative or zero is not allowed.');
    }

    int newValue = 0;
    if (other is num) {
      newValue = (value / other).round();
    } else if (other is String && _validateRoman(other)) {
      newValue = (value / RomanNumerals.fromRoman(other).value).round();
    } else if (other is RomanNumerals) {
      newValue = (value / other.value).round();
    } else {
      throw ArgumentError('Not valid type for Roman numerals.');
    }
    return RomanNumerals(newValue);
  }

  /// Bit-wise and operator.
  RomanNumerals operator &(dynamic other) {
    int newValue = 0;
    if (other is num) {
      newValue = value & other.toInt();
    } else if (other is String && _validateRoman(other)) {
      newValue = value & RomanNumerals.fromRoman(other).value;
    } else if (other is RomanNumerals) {
      newValue = value & other.value;
    } else {
      throw ArgumentError('Not valid type for Roman numerals.');
    }
    return RomanNumerals(newValue);
  }

  /// Bit-wise or operator
  RomanNumerals operator |(dynamic other) {
    int newValue = 0;
    if (other is num) {
      newValue = value | other.toInt();
    } else if (other is String && _validateRoman(other)) {
      newValue = value | RomanNumerals.fromRoman(other).value;
    } else if (other is RomanNumerals) {
      newValue = value | other.value;
    } else {
      throw ArgumentError('Not valid type for Roman numerals.');
    }
    return RomanNumerals(newValue);
  }

  /// Bit-wise exclusive-or operator.
  RomanNumerals operator ^(dynamic other) {
    int newValue = 0;
    if (other is num) {
      newValue = value ^ other.toInt();
    } else if (other is String && _validateRoman(other)) {
      newValue = value ^ RomanNumerals.fromRoman(other).value;
    } else if (other is RomanNumerals) {
      newValue = value ^ other.value;
    } else {
      throw ArgumentError('Not valid type for Roman numerals.');
    }
    return RomanNumerals(newValue);
  }

  /// Euclidean modulo of this number by [other].
  RomanNumerals operator %(dynamic other) {
    int newValue = 0;
    if (other is num) {
      newValue = value % other.toInt();
    } else if (other is String && _validateRoman(other)) {
      newValue = value % RomanNumerals.fromRoman(other).value;
    } else if (other is RomanNumerals) {
      newValue = value % other.value;
    } else {
      throw ArgumentError('Not valid type for Roman numerals.');
    }
    return RomanNumerals(newValue);
  }

  /// Shift the bits of this integer to the left by [shiftAmount].
  RomanNumerals operator <<(int shiftAmount) {
    return RomanNumerals(value << shiftAmount);
  }

  /// Shift the bits of this integer to the right by [shiftAmount].
  RomanNumerals operator >>(int shiftAmount) {
    return RomanNumerals(value >> shiftAmount);
  }

  /// Check if this [RomanNumerals] is less than another and returns boolean value.
  bool operator <(dynamic other) {
    if (other is num) {
      return value < other.toInt();
    } else if (other is String && _validateRoman(other)) {
      return value < RomanNumerals.fromRoman(other).value;
    } else if (other is RomanNumerals) {
      return value < other.value;
    } else {
      throw ArgumentError('Not valid type for Roman numerals.');
    }
  }

  /// Check if this [RomanNumerals] is less than or equal to another and returns boolean value.
  bool operator <=(dynamic other) {
    if (other is num) {
      return value <= other.toInt();
    } else if (other is String && _validateRoman(other)) {
      return value <= RomanNumerals.fromRoman(other).value;
    } else if (other is RomanNumerals) {
      return value <= other.value;
    } else {
      throw ArgumentError('Not valid type for Roman numerals.');
    }
  }

  /// Check if this [RomanNumerals] is greater than another and returns boolean value.
  bool operator >(dynamic other) {
    if (other is num) {
      return value > other.toInt();
    } else if (other is String && _validateRoman(other)) {
      return value > RomanNumerals.fromRoman(other).value;
    } else if (other is RomanNumerals) {
      return value > other.value;
    } else {
      throw ArgumentError('Not valid type for Roman numerals.');
    }
  }

  /// Check if this [RomanNumerals] is greater than or equal to another and returns boolean value.
  bool operator >=(dynamic other) {
    if (other is num) {
      return value >= other.toInt();
    } else if (other is String && _validateRoman(other)) {
      return value >= RomanNumerals.fromRoman(other).value;
    } else if (other is RomanNumerals) {
      return value >= other.value;
    } else {
      throw ArgumentError('Not valid type for Roman numerals.');
    }
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
