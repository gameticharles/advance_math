part of advance_math;

extension NumExtension on num {
  ///
  /// This method shifts the decimal point [decimalPlaces] places to the right,
  /// rounds to the nearest integer, and then shifts the decimal point back to the
  /// left by the same amount. The default value of [decimalPlaces] is `0`.
  ///
  /// Returns the rounded [value].
  num roundTo([int decimalPlaces = 0]) {
    if (decimalPlaces == 0) {
      return round();
    } else {
      return (this * math.pow(10, decimalPlaces)).round() /
          math.pow(10, decimalPlaces);
    }
  }
}
