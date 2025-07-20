part of 'bases.dart';

/// An string extension on the [base] class that provides additional functionality.
extension BaseString on String {
  /// Converts a string to a number in the specified [base].
  ///
  /// The [base] must be between 2 and 36, inclusive.
  ///
  /// Example:
  /// ```dart
  /// int result = String.fromBase(255, 16); // result = 255
  /// ```
  int toBase(int base) {
    return Bases.toDecimal(this, base);
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
  /// String result = "1011".convert( 2, 16); // result = "B"
  /// ```
  String convert(int sourceBase, int targetBase) {
    return Bases.convert(this, sourceBase, targetBase);
  }

  // Validates that each character in [value] is allowed in the specified [base].
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
  /// bool isValid = "1A".isValidForBase( 16); // true
  /// bool isInvalid = "1G".isValidForBase( 16); // false
  /// ```
  bool isValidForBase(int base) {
    return Bases.isValidForBase(this, base);
  }

  /// Converts a binary [value] (base 2) to a decimal string (base 10).
  ///
  /// Example:
  /// ```dart
  /// String result = "1011".binaryToDecimal(); // result = "11"
  /// ```
  String binaryToDecimal() => Bases.binaryToDecimal(this);

  /// Converts a decimal [value] (base 10) to a binary string (base 2).
  ///
  /// Example:
  /// ```dart
  /// String result = "11".decimalToBinary("11"); // result = "1011"
  /// ```
  String decimalToBinary() => Bases.decimalToBinary(this);

  /// Converts a hexadecimal [value] (base 16) to a decimal string (base 10).
  ///
  /// Example:
  /// ```dart
  /// String result = "A".hexToDecimal(); // result = "10"
  /// ```
  String hexToDecimal() => Bases.hexToDecimal(this);

  /// Converts a decimal [value] (base 10) to a hexadecimal string (base 16).
  ///
  /// Example:
  /// ```dart
  /// String result = "255".decimalToHex(); // result = "FF"
  /// ```
  String decimalToHex() => Bases.decimalToHex(this);

  /// Converts an octal [value] (base 8) to a decimal string (base 10).
  ///
  /// Example:
  /// ```dart
  /// String result = BaseConverter.octalToDecimal("17"); // result = "15"
  /// ```
  String octalToDecimal() => Bases.octalToDecimal(this);

  /// Converts a decimal [value] (base 10) to an octal string (base 8).
  ///
  /// Example:
  /// ```dart
  /// String result = "15".decimalToOctal(); // result = "17"
  /// ```
  String decimalToOctal() => Bases.decimalToOctal(this);
}

extension BaseInt on int {
  /// Converts a number in the specified [base] to a string.
  ///
  /// The [base] must be between 2 and 36, inclusive.
  ///
  /// Example:
  /// ```dart
  /// String result = 255.toBase(16); // result = "FF"
  /// ```
  String fromBase(int base, {int padLength = 0}) {
    return Bases.fromDecimal(this, base, padLength: padLength);
  }

  /// Converts a binary [value] (base 2) to a decimal string (base 10).
  ///
  /// Example:
  /// ```dart
  /// String result = 1011.binaryToDecimal(); // result = "11"
  /// ```
  String binaryToDecimal() => Bases.binaryToDecimal(toString());

  /// Converts a decimal [value] (base 10) to a binary string (base 2).
  ///
  /// Example:
  /// ```dart
  /// String result = 11.decimalToBinary("11"); // result = "1011"
  /// ```
  String decimalToBinary() => Bases.decimalToBinary(toString());

  /// Converts a decimal [value] (base 10) to a hexadecimal string (base 16).
  ///
  /// Example:
  /// ```dart
  /// String result = 255.decimalToHex(); // result = "FF"
  /// ```
  String decimalToHex() => Bases.decimalToHex(toString());

  /// Converts an octal [value] (base 8) to a decimal string (base 10).
  ///
  /// Example:
  /// ```dart
  /// String result = 17.octalToDecimal(); // result = "15"
  /// ```
  String octalToDecimal() => Bases.octalToDecimal(toString());

  /// Converts a decimal [value] (base 10) to an octal string (base 8).
  ///
  /// Example:
  /// ```dart
  /// String result = 15.decimalToOctal(); // result = "17"
  /// ```
  String decimalToOctal() => Bases.decimalToOctal(toString());
}
