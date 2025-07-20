import 'package:characters/characters.dart';
import 'package:intl/intl.dart';

import '../util/romans_exception.dart';

part 'config.dart';
part 'int_ext.dart';
part 'string_ext.dart';

/// Sets the [RomanNumeralsConfig] to be used globally for all [RomanNumerals] instances.
/// This allows customizing the behavior of the [RomanNumerals] class, such as the
/// representation of zero or the use of overline.
RomanNumeralsConfig romanNumeralConfig = VinculumRomanNumeralsConfig();

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
  late final RomanNumeralsConfig _config;

  /// Sets the [RomanNumeralsConfig] to be used globally for all [RomanNumerals] instances.
  /// This allows customizing the behavior of the [RomanNumerals] class, such as the
  /// representation of zero or the use of overline.
  static set romanNumeralsConfig(RomanNumeralsConfig config) {
    romanNumeralConfig = config;
  }

  /// The integer value represented by this instance.
  late int value;

  /// Determines if the numeral is represented as a negative.
  final bool _isNegative;

  /// The character to represent zero.
  final String zeroChar;

  /// Determines if the numeral should use overline.
  final bool useOverline;

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
  RomanNumerals.fromRoman(
    String roman, {
    RomanNumeralsConfig? config,
    this.zeroChar = 'N',
    this.useOverline = false,
  })  : _isNegative = roman.startsWith('-'),
        _config = config ?? romanNumeralConfig {
    // Adjust configuration if `zeroChar` differs from `config.nulla`
    if (zeroChar != 'N' && zeroChar != _config.nulla) {
      switch (_config.configType) {
        case RomanNumeralsType.common:
          _config = CommonRomanNumeralsConfig(nulla: zeroChar);
          break;
        case RomanNumeralsType.apostrophus:
          _config = ApostrophusRomanNumeralsConfig(nulla: zeroChar);
          break;
        case RomanNumeralsType.vinculum:
          _config = VinculumRomanNumeralsConfig(nulla: zeroChar);
          break;
      }
    }

    // Calculate the value of the numeral
    var res = roman.toRomanNumeralValue(config: _config);
    value = res ??
        (throw InvalidRomanNumeralException('Invalid Roman numeral: $roman'));
  }

  String toRoman() {
    return value.toRomanNumeralString(config: _config)!;
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
    } else if (other is String &&
        (other.isValidRomanNumeralValue(config: _config))) {
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
    } else if (other is String &&
        (other.isValidRomanNumeralValue(config: _config))) {
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
    } else if (other is String &&
        (other.isValidRomanNumeralValue(config: _config))) {
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
    } else if (other is String &&
        (other.isValidRomanNumeralValue(config: _config))) {
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
    } else if (other is String &&
        (other.isValidRomanNumeralValue(config: _config))) {
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
    } else if (other is String &&
        (other.isValidRomanNumeralValue(config: _config))) {
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
    } else if (other is String &&
        (other.isValidRomanNumeralValue(config: _config))) {
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
    } else if (other is String &&
        (other.isValidRomanNumeralValue(config: _config))) {
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
    } else if (other is String &&
        (other.isValidRomanNumeralValue(config: _config))) {
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
    } else if (other is String &&
        (other.isValidRomanNumeralValue(config: _config))) {
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
    } else if (other is String &&
        (other.isValidRomanNumeralValue(config: _config))) {
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
    } else if (other is String &&
        (other.isValidRomanNumeralValue(config: _config))) {
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
    return value.toRomanNumeralString(config: _config)!;
  }
}
