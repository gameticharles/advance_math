part of maths;

/// Returns the base-10 logarithm of a number.
///
/// Example:
/// ```dart
/// print(log10(100));  // Output: 2.0
/// ```
double log10(num x) => math.log(x) / math.ln10;

/// Returns the logarithm (base `b`) of `x`.
///
/// If `b` is null, then it returns the natural logarithm of a number.
///
/// Throws an [ArgumentError] if `x` or `b` is less than or equal to 0.
///
/// Example 1:
/// ```dart
/// print(log(100, 10)); // prints: 2.0
/// ```
///
/// Example 2:
/// ```dart
/// print(log(math.e));  // Output: 1.0
double log(num x, [double? b]) {
  if (x <= 0 || (b != null && b <= 0)) {
    throw ArgumentError('Invalid input for log: n and b must be > 0');
  }
  return b != null ? math.log(x) / math.log(b) : math.log(x);
}

/// Returns the logarithm of a number to a given base.
/// The logarithm to base b of x is equal to the value y such that b to the power of y is equal to x.
///
/// Example:
/// ```dart
/// print(logBase(10, 100));  // Output: 2.0
/// print(logBase(2, 8));  // Output: 3.0
/// print(logBase(2, 32));  // Output: 5.0
/// ```
double logBase(num base, num x) => math.log(x) / math.log(base);
