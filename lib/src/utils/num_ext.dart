part of '/advance_math.dart';

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

/// Extension to calculate the integer square root of a BigInt.
extension BigIntSqrt on BigInt {
  /// Returns the integer square root of a BigInt.
  BigInt sqrt() {
    BigInt low = BigInt.zero;
    BigInt high = this;
    BigInt mid;

    while (low <= high) {
      mid = (low + high) >> 1;
      BigInt square = mid * mid;

      if (square == this) {
        return mid;
      } else if (square < this) {
        low = mid + BigInt.one;
      } else {
        high = mid - BigInt.one;
      }
    }

    return high;
  }

  /// Checks if the BigInt is a power of two.
  bool get isPowerOfTwo {
    if (this <= BigInt.zero) return false;
    return (this & (this - BigInt.one)) == BigInt.zero;
  }
}
