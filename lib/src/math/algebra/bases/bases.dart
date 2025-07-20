library bases;

part 'ext.dart';

/// Supports bases up to 64.
const _chars =
    '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';

/// A utility class for converting numbers between various bases.
///
/// The `BaseConverter` class supports conversions between bases ranging from 2 to 64.
/// It includes methods for direct conversions between common bases (binary, octal, decimal,
/// and hexadecimal) as well as a general-purpose conversion method.
class Bases {
  /// Validates that each character in [value] is allowed in the specified [base].
  ///
  /// This method ensures that the [value] contains only characters that are
  /// valid within the [base]. For example, in base 16, only characters in the
  /// range 0-9 and A-F are valid.
  ///
  /// Returns `true` if all characters in [value] are valid for the given [base],
  /// otherwise returns `false`.
  ///
  /// Example:
  /// ```dart
  /// bool isValid = BaseConverter.isValidForBase("1A", 16); // true
  /// bool isInvalid = BaseConverter.isValidForBase("1G", 16); // false
  /// ```
  static bool isValidForBase(String value, int base) {
    final allowedChars = Set.from(_chars.substring(0, base).split(''));
    return value.split('').every(allowedChars.contains);
  }

  /// Converts a number [value] in the specified [sourceBase] to a decimal integer.
  ///
  /// Throws an [ArgumentError] if [value] contains characters invalid for [sourceBase].
  ///
  /// Example:
  /// ```dart
  /// int result = BaseConverter.toDecimal("A", 16); // result = 10
  /// ```
  static int toDecimal(String value, int sourceBase) {
    if (!isValidForBase(value, sourceBase)) {
      throw ArgumentError('Invalid characters for base $sourceBase');
    }
    value = value.replaceAll('_', '');

    // Use Dart's built-in parser for bases 2-36
    if (sourceBase <= 36) {
      return int.parse(value, radix: sourceBase);
    }

    // Manual conversion for bases > 36
    int result = 0;
    int power = 1;

    for (int i = value.length - 1; i >= 0; i--) {
      int digitValue = _chars.indexOf(value[i]);
      if (digitValue == -1 || digitValue >= sourceBase) {
        throw ArgumentError(
            'Invalid character "${value[i]}" for base $sourceBase');
      }
      result += digitValue * power;
      power *= sourceBase;
    }

    return result;
  }

  /// Converts a decimal integer [value] to a string in the specified [targetBase].
  ///
  /// Throws an [ArgumentError] if [targetBase] is outside the range 2 to 36.
  ///
  /// Example:
  /// ```dart
  /// String result = BaseConverter.fromDecimal(255, 16); // result = "FF"
  /// ```
  static String fromDecimal(int value, int targetBase, {int padLength = 0}) {
    if (targetBase < 2 || targetBase > _chars.length) {
      throw ArgumentError(
          'Target base must be between 2 and ${_chars.length}, inclusive.');
    }
    if (value == 0) return '0'.padLeft(padLength, '0');
    if (value < 0) return '-${fromDecimal(-value, targetBase)}';

    String result = '';
    int quotient = value;

    while (quotient > 0) {
      int remainder = quotient % targetBase;
      result = _chars[remainder] + result;
      quotient ~/= targetBase;
    }
    return result.padLeft(padLength, '0');
  }

  /// Converts a [value] from [sourceBase] to [targetBase].
  ///
  /// This method first converts the [value] from the [sourceBase] to decimal,
  /// then converts the decimal value to the [targetBase].
  ///
  /// Throws an [ArgumentError] if either [sourceBase] or [targetBase] are outside
  /// the range 2 to 36.
  ///
  /// Example:
  /// ```dart
  /// String result = BaseConverter.convert("1011", 2, 16); // result = "B"
  /// ```
  static String convert(String value, int sourceBase, int targetBase) {
    if (sourceBase < 2 ||
        sourceBase > _chars.length ||
        targetBase < 2 ||
        targetBase > _chars.length) {
      throw ArgumentError('Base must be between 2 and ${_chars.length}');
    }

    // Step 1: Convert from source base to decimal
    int decimalValue = toDecimal(value, sourceBase);

    // Step 2: Convert from decimal to target base
    return fromDecimal(decimalValue, targetBase);
  }

  /// Generates a list of numbers within a range, represented in the specified [targetBase].
  /// The function generates numbers from start to stop inclusively.
  ///
  /// The method returns a list of strings, where each string is a number in the [targetBase].
  /// If [targetBase] is outside the range 2 to 36, an [ArgumentError] is thrown.
  ///
  /// Example:
  /// ```dart
  /// List<String> result = BaseConverter.rangeInBase(4, 20, 5);
  /// // result = ["4", "10", "11", "12", ... , "34"]
  /// ```
  static List<String> rangeInBase(int start, int stop, int targetBase) {
    if (targetBase < 2 || targetBase > _chars.length) {
      throw ArgumentError('Target base must be between 2 and ${_chars.length}');
    }

    List<String> result = [];
    for (int i = start; i <= stop; i++) {
      result.add(fromDecimal(i, targetBase));
    }
    return result;
  }

  /// Converts a binary [value] (base 2) to a decimal string (base 10).
  ///
  /// Example:
  /// ```dart
  /// String result = BaseConverter.binaryToDecimal("1011"); // result = "11"
  /// ```
  static String binaryToDecimal(String binary) => convert(binary, 2, 10);

  /// Converts a decimal [value] (base 10) to a binary string (base 2).
  ///
  /// Example:
  /// ```dart
  /// String result = BaseConverter.decimalToBinary("11"); // result = "1011"
  /// ```
  static String decimalToBinary(String decimal) => convert(decimal, 10, 2);

  /// Converts a hexadecimal [value] (base 16) to a decimal string (base 10).
  ///
  /// Example:
  /// ```dart
  /// String result = BaseConverter.hexToDecimal("A"); // result = "10"
  /// ```
  static String hexToDecimal(String hex) => convert(hex, 16, 10);

  /// Converts a decimal [value] (base 10) to a hexadecimal string (base 16).
  ///
  /// Example:
  /// ```dart
  /// String result = BaseConverter.decimalToHex("255"); // result = "FF"
  /// ```
  static String decimalToHex(String decimal) => convert(decimal, 10, 16);

  /// Converts an octal [value] (base 8) to a decimal string (base 10).
  ///
  /// Example:
  /// ```dart
  /// String result = BaseConverter.octalToDecimal("17"); // result = "15"
  /// ```
  static String octalToDecimal(String octal) => convert(octal, 8, 10);

  /// Converts a decimal [value] (base 10) to an octal string (base 8).
  ///
  /// Example:
  /// ```dart
  /// String result = BaseConverter.decimalToOctal("15"); // result = "17"
  /// ```
  static String decimalToOctal(String decimal) => convert(decimal, 10, 8);
}
