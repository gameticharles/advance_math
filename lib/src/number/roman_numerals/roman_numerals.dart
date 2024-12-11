import 'package:characters/characters.dart';
import 'package:intl/intl.dart';

import '../util/romans_exception.dart';

part 'config.dart';
part 'int_ext.dart';
part 'string_ext.dart';

/// Sets the [RomanNumeralsConfig] to be used globally for all [RomanNumerals] instances.
/// This allows customizing the behavior of the [RomanNumerals] class, such as the
/// representation of zero or the use of overline.
RomanNumeralsConfig romanNumeralConfig = CommonRomanNumeralsConfig();

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
  /// The [RomanNumeralsConfig] used to create this [RomanNumerals] instance.
  final RomanNumeralsConfig _config;

  /// Sets the [RomanNumeralsConfig] to be used globally for all [RomanNumerals] instances.
  /// This allows customizing the behavior of the [RomanNumerals] class, such as the
  /// representation of zero or the use of overline.
  static set romanNumeralsConfig(RomanNumeralsConfig config) {
    romanNumeralConfig = config;
  }

  /// A private constant map that represents the standard numerals.
  static const Map<String, int> _numerals = {
    'M\u0305': 1000000,
    'D\u0305': 500000,
    'C\u0305': 100000,
    'L\u0305': 50000,
    'X\u0305': 10000,
    'V\u0305': 5000,
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

  /// Determines if the numeral is represented as a negative.
  final bool _isNegative;

  /// The character to represent zero.
  final String zeroChar;

  /// Determines if the numeral should use overline.
  final bool useOverline;

  /// Private cache to improve performance for the conversion methods.
  static final Map<int, String> _numToRomanCache = {};
  static final Map<String, int> _romanToNumCache = {};

  /// Constructs a [RomanNumerals] object from a given integer [value].
  ///
  /// Throws an [InvalidRomanNumeralException] if [value] is negative.
  ///
  /// Example:
  /// ```dart
  /// print(RomanNumerals(69)); // LXIX
  /// print(RomanNumerals(8785)); // (VIII)DCCLXXXV
  /// ```
  RomanNumerals(this.value,
      {RomanNumeralsConfig? config,
      this.zeroChar = 'N',
      this.useOverline = false})
      : _isNegative = value < 0,
        _config = config ?? romanNumeralConfig;

  /// Constructs a [RomanNumerals] object from a given Roman numeral [roman].
  ///
  /// Example:
  /// ```dart
  /// var numeral = RomanNumerals.fromRoman('XIV'); // 14
  /// ```
  RomanNumerals.fromRoman(String roman,
      {RomanNumeralsConfig? config,
      this.zeroChar = 'N',
      this.useOverline = false})
      : _isNegative = roman.startsWith('-'),
        _config = config ?? romanNumeralConfig,
        value = _fromRoman(roman.startsWith('-') ? roman.substring(1) : roman,
                zeroChar: zeroChar) *
            (roman.startsWith('-') ? -1 : 1);

  /// A private method to convert a Roman numeral string to an integer.
  static int _fromRoman(String roman,
      {String zeroChar = 'N', bool useOverline = false}) {
    roman = roman.toUpperCase();

    // Handle the special case for zero
    if (roman == zeroChar) return 0;

    // Validate the provided Roman numeral
    if (!_validateRoman(roman)) {
      throw InvalidRomanNumeralException('Invalid Roman numeral: $roman');
    }

    // Using cache's putIfAbsent to streamline caching
    return _romanToNumCache.putIfAbsent(roman, () => _decodeRoman(roman));
  }

  /// Helper method to convert a Roman numeral string to an integer

  static int _decodeRoman(String roman) {
    int result = 0;
    int prevValue = 0;
    int i = roman.length - 1;

    while (i >= 0) {
      // Check if the current character is a parenthesis
      if (roman[i] == ')') {
        // Find the matching opening parenthesis
        int j = roman.lastIndexOf('(', i);
        if (j == -1) {
          throw InvalidRomanNumeralException('Invalid Roman numeral: $roman');
        }
        // Convert the part of the string inside the parentheses
        String innerRoman = roman.substring(j + 1, i);
        int innerValue = _fromRomanWithoutParentheses(innerRoman);
        result += innerValue * 1000;

        i = j - 1;
      } else if (i > 0 &&
          _numerals.containsKey(roman.substring(i - 1, i + 1))) {
        String currentSymbol = roman.substring(i - 1, i + 1);
        int currentValue = _numerals[currentSymbol]!;
        if (currentValue < prevValue) {
          result -= currentValue;
        } else {
          result += currentValue;
        }
        prevValue = currentValue;
        i -= 2;
      } else {
        String currentSymbol = roman[i];
        int currentValue = _numerals[currentSymbol]!;
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
        throw InvalidRomanNumeralException('Invalid Roman numeral: $roman');
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
  String toRoman({bool useOverline = false}) {
    if (value == 0) return zeroChar;

    // Using cache's putIfAbsent to streamline caching
    return _numToRomanCache.putIfAbsent(value, () {
      int number = value.abs();
      StringBuffer result = StringBuffer();

      // If the value is more than 3999, use brackets for the thousands part
      if (number >= 10000) {
        //if (value > 3999) {
        int thousands = value ~/ 1000;
        number %= 1000;
        if (useOverline) {
          result.write(_addOverline(_toRomanWithoutParentheses(thousands)));
        } else {
          result.write('(${_toRomanWithoutParentheses(thousands)})');
        }
      }

      // Then handle the rest of the number
      result.write(_toRomanWithoutParentheses(number));

      // Cache the converse for improved performance
      _romanToNumCache[result.toString()] = value;

      return _isNegative ? '-${result.toString()}' : result.toString();
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

  static String _addOverline(String numeral) {
    const overline = '\u0305';
    return numeral.split('').map((char) => char + overline).join('');
  }

  /// Helper private method to check the roman numeral string
  static bool _validateRoman(String roman) {
    // 1. Invalid Characters
    if (RegExp(r"[^MDCLXVI\(\)\u0305]").hasMatch(roman)) {
      return false;
    }

    // 2. Invalid Repetitions
    if (RegExp(r"D{2,}|\u0305D{2,}|L{2,}|\u0305L{2,}|V{2,}|\u0305V{2,}")
        .hasMatch(roman)) {
      return false;
    }

    // 3. Check for more than three consecutive I, X, or C characters
    if (RegExp(r"I{4,}|\u0305I{4,}|X{4,}|\u0305X{4,}|C{4,}|\u0305C{4,}")
        .hasMatch(roman)) {
      return false;
    }

    // 4. Invalid subtractive combinations
    if (RegExp(
            r"IL|IC|ID|IM|XD|XM|VX|VL|VC|VD|VM|LC|LD|LM|DM|\u0305IL|\u0305IC|\u0305ID|\u0305IM|\u0305XD|\u0305XM|\u0305VX|\u0305VL|\u0305VC|\u0305VD|\u0305VM|\u0305LC|\u0305LD|\u0305LM|\u0305DM")
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
  static bool isValidRoman(String roman, {String zeroChar = 'N'}) {
    try {
      _fromRoman(roman, zeroChar: zeroChar);
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
      throw InvalidRomanNumeralException('Invalid Roman numeral date format.');
    }

    final month = RomanNumerals.fromRoman(parts[0].trim()).value;
    final day = RomanNumerals.fromRoman(parts[1].trim()).value;
    final year = RomanNumerals.fromRoman(parts[2].trim()).value;

    final dt = DateTime(year, month, day);
    return DateFormat(format).format(dt);
  }

  /// Checks if the numeral is zero.
  bool isZero() => value == 0;

  /// Checks if the numeral is positive.
  bool isPositive() => value > 0 && !_isNegative;

  /// Since Roman numerals cannot be negative, this will always return false.
  /// However, it's added for consistency.
  bool isNegative() => _isNegative;

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
      throw InvalidRomanNumeralException('Not valid type for Roman numerals.');
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
      throw InvalidRomanNumeralException('Not valid type for Roman numerals.');
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
      throw InvalidRomanNumeralException('Not valid type for Roman numerals.');
    }
    return RomanNumerals(newValue);
  }

  /// Divides the value of this [RomanNumerals] by another and returns a new one.
  RomanNumerals operator /(dynamic other) {
    if ((other is RomanNumerals && other.value == 0) ||
        (other is num && other <= 0)) {
      throw InvalidRomanNumeralException(
          'Division by negative or zero is not allowed.');
    }

    int newValue = 0;
    if (other is num) {
      newValue = (value / other).round();
    } else if (other is String && _validateRoman(other)) {
      newValue = (value / RomanNumerals.fromRoman(other).value).round();
    } else if (other is RomanNumerals) {
      newValue = (value / other.value).round();
    } else {
      throw InvalidRomanNumeralException('Not valid type for Roman numerals.');
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
      throw InvalidRomanNumeralException('Not valid type for Roman numerals.');
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
      throw InvalidRomanNumeralException('Not valid type for Roman numerals.');
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
      throw InvalidRomanNumeralException('Not valid type for Roman numerals.');
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
      throw InvalidRomanNumeralException('Not valid type for Roman numerals.');
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
      throw InvalidRomanNumeralException('Not valid type for Roman numerals.');
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
      throw InvalidRomanNumeralException('Not valid type for Roman numerals.');
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
      throw InvalidRomanNumeralException('Not valid type for Roman numerals.');
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
      throw InvalidRomanNumeralException('Not valid type for Roman numerals.');
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
    return toRoman(useOverline: useOverline);
  }
}
