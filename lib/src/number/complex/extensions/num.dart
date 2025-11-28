part of '../complex.dart';

// Extension to allow operations when num is on the left side
// Extension for precise integer conversion
extension PrecisionChecks on double {
  int truncate() {
    try {
      return toInt();
    } catch (_) {
      // Handle numbers beyond 64-bit integer range
      final str = toString().split('.')[0];
      return int.parse(str);
    }
  }
}

/// The [NumComplexExtension] expose methods for easy convertion from
/// [num] to [Complex].
///
/// {@template ComplexX_real}
/// To create a [Complex] without imaginary part (i.e. a real) from a [num],
/// use [num].`real` getter.
///
/// ```
/// final a = 3.real; // a = Complex(3.0, 0);
/// final b = 4.0.real; // b = Complex(4.0, 0);
/// final c = 3.re; // c = Complex(3.0, 0);
/// final d = 4.0.re; // d = Complex(4.0, 0);
/// ```
/// {@endtemplate}
///
/// {@template ComplexX_imag}
/// use [num].`imag` getter.
///
/// ```
/// final a = 3.imag; // a = Complex(0, 3.0);
/// final b = 4.0.imag; // b = Complex(0, 4.0);
/// final c = 3.im; // c = Complex(0, 3.0);
/// final d = 4.0.im; // d = Complex(0, 4.0);
/// ```
/// {@endtemplate}
extension NumComplexExtension on num {
  /// Adds a complex number to this number.
  ///
  /// Example:
  /// ```dart
  /// 5 + Complex(3, 4)  // 8.0 + 4.0i
  /// ```
  Complex operator +(Complex other) =>
      Complex(this + other.real, other.imaginary);

  /// Subtracts a complex number from this number.
  ///
  /// Example:
  /// ```dart
  /// 5 - Complex(3, 4)  // 2.0 - 4.0i
  /// ```
  Complex operator -(Complex other) =>
      Complex(this - other.real, -other.imaginary);

  /// Multiplies this number by a complex number.
  ///
  /// Example:
  /// ```dart
  /// 3 * Complex(1, 2)  // 3.0 + 6.0i
  /// ```
  Complex operator *(Complex other) =>
      Complex(this * other.real, this * other.imaginary);

  /// Divides this number by a complex number.
  ///
  /// Example:
  /// ```dart
  /// 15 / Complex(3, 4)  // 1.8 - 2.4i
  /// ```
  Complex operator /(Complex other) {
    // Handle special cases
    if (other.isNaN) return Complex.nan();
    if (other.isZero) return Complex.infinity();
    if (this == 0) return Complex.zero();
    if (other.isInfinite) return Complex.zero();

    // Normal case - use the formula (a)/(c+di) = (ac)/(c²+d²) - (ad)/(c²+d²)i
    final denominator =
        other.real * other.real + other.imaginary * other.imaginary;
    return Complex(
      (this * other.real) / denominator,
      (-this * other.imaginary) / denominator,
    );
  }

  /// Raises this number to the power of a complex number.
  ///
  /// Example:
  /// ```dart
  /// 2 ^ Complex(3, 0)  // 8.0 + 0.0i
  /// ```
  Complex operator ^(Complex other) {
    // Convert this num to a Complex and use its pow method
    return Complex(this).pow(other);
  }

  /// Compares this number with a complex number (magnitude comparison)
  bool operator >(Complex other) => abs() > other.abs();

  /// Compares this number with a complex number (magnitude comparison)
  bool operator >=(Complex other) => abs() >= other.abs();

  /// Compares this number with a complex number (magnitude comparison)
  bool operator <(Complex other) => abs() < other.abs();

  /// Compares this number with a complex number (magnitude comparison)
  bool operator <=(Complex other) => abs() <= other.abs();

  Complex get c => Complex(this, 0);

  /// {@macro ComplexX_real}
  Complex get real => Complex(this);

  /// {@macro ComplexX_real}
  Complex get re => Complex(this);

  /// {@macro ComplexX_imag}
  Complex get imag => Complex(0, this);

  /// {@macro ComplexX_imag}
  Complex get im => Complex(0, this);

  /// Enables syntax like: 3i or 4i
  /// Returns a new imaginary number with this number as coefficient
  Complex get i => Complex(0, this);

  /// Enables syntax like: 3j or 4j
  /// Returns a new imaginary number with this number as coefficient
  Complex get j => Complex(0, this);
}
