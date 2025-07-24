part of advance_math;

extension NumExtension on num {
  /// Generates a range from this number to [end] (inclusive).
  /// Example: 1.to(5) => [1, 2, 3, 4, 5]
  Iterable<num> to(num end, {num step = 1}) sync* {
    if (step == 0) throw ArgumentError('Step cannot be zero');
    if ((step > 0 && this > end) || (step < 0 && this < end)) {
      throw ArgumentError(
          'Invalid range: step direction must match range direction');
    }

    var current = this;
    while (step > 0 ? current <= end : current >= end) {
      yield current;
      current += step;
    }
  }

  ///The absolute value of this number.
  num absolute() => abs();

  /// Square root of the number
  dynamic squareRoot() =>
      this >= 0 ? math.sqrt(this) : Complex(0, math.sqrt(-this));

  /// Cube root of a number
  dynamic cubeRoot() => nthRoot(3);

  /// Compute the nth root of a number
  dynamic nthRoot(double nth) => this >= 0
      ? math.pow(this, 1 / nth)
      : Complex(0, math.pow(-this, 1 / nth));

  /// Exponent of a number
  dynamic exponentiation(num exponent) => math.exp(this);

  /// Get the power of a number
  dynamic power(num exponent) => math.pow(this, exponent);

  /// Checks if the number is even
  bool isEven() => this % 2 == 0;

  /// Checks if the number is odd
  bool isOdd() => this % 2 != 0;

  /// Checks if the number is a perfect square
  bool isPerfectSquare() {
    var x = math.sqrt(this).toInt();
    return x * x == this;
  }

  /// Checks if the number is prime
  bool isPrime() {
    if (this <= 1) return false;
    for (int i = 2; i * i <= this; i++) {
      if (this % i == 0) return false;
    }
    return true;
  }

  // ... more methods here

  /// Round down to the nearest integer
  int floor() => this.floor();

  /// Round up to the nearest integer
  int ceil() => this.ceil();

  /// Round to the nearest integer
  int round() => this.round();

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

  /// Raises a number to the power of another number.
  dynamic pow(dynamic exponent) => math.pow(this, exponent);
}

/// A helper function to convert a number to an [Expression].
/// 
/// This function provides a concise way to convert a number to an [Expression]
/// when the extension method cannot be used due to type inference limitations.
/// 
/// Example:
/// 
/// var x = Variable('x');
/// var expr = ex(2) * x + ex(3);
/// 
Expression ex(num value) => Literal(value);

/// Extension to provide Expression conversion capabilities for numeric types.
/// This extension allows seamless conversion of numbers to Literal expressions
/// and provides operator overloads for num + Expression operations.
extension NumToExpressionExtension on num {
  /// Converts this number to a Literal expression.
  /// 
  /// Example:
  /// ```dart
  /// final expr = 5.toExpression(); // Creates Literal(5)
  /// ```
  Expression toExpression() => Literal(this);
  
  /// Addition operator for num + Expression operations.
  /// Converts this number to a Literal and performs addition.
  /// 
  /// Example:
  /// ```dart
  /// final x = Variable('x');
  /// final expr = 2 + x; // Creates Add(Literal(2), x)
  /// ```
  Expression operator +(Expression other) => Literal(this) + other;
  
  /// Subtraction operator for num - Expression operations.
  /// Converts this number to a Literal and performs subtraction.
  /// 
  /// Example:
  /// ```dart
  /// final x = Variable('x');
  /// final expr = 5 - x; // Creates Subtract(Literal(5), x)
  /// ```
  Expression operator -(Expression other) => Literal(this) - other;
  
  /// Multiplication operator for num * Expression operations.
  /// Converts this number to a Literal and performs multiplication.
  /// 
  /// Example:
  /// ```dart
  /// final x = Variable('x');
  /// final expr = 3 * x; // Creates Multiply(Literal(3), x)
  /// ```
  Expression operator *(Expression other) => Literal(this) * other;
  
  /// Division operator for num / Expression operations.
  /// Converts this number to a Literal and performs division.
  /// 
  /// Example:
  /// ```dart
  /// final x = Variable('x');
  /// final expr = 10 / x; // Creates Divide(Literal(10), x)
  /// ```
  Expression operator /(Expression other) => Literal(this) / other;
  
  /// Power operator for num ^ Expression operations.
  /// Converts this number to a Literal and performs exponentiation.
  /// 
  /// Example:
  /// ```dart
  /// final x = Variable('x');
  /// final expr = 2 ^ x; // Creates Pow(Literal(2), x)
  /// ```
  Expression operator ^(Expression other) => Literal(this) ^ other;
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
