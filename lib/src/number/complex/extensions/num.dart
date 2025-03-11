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
  Complex operator +(Complex other) => Complex(this, 0) + other;
  Complex operator -(Complex other) => Complex(this, 0) - other;
  Complex operator *(Complex other) => Complex(this, 0) * other;
  Complex operator /(Complex other) => Complex(this, 0) / other;
  Complex get c => Complex(this, 0);

  /// {@macro ComplexerX_real}
  Complex get real => Complex(toDouble());

  /// {@macro ComplexerX_real}
  Complex get re => Complex(toDouble());

  /// {@macro ComplexerX_imag}
  Complex get imag => Complex(0, toDouble());

  /// {@macro ComplexerX_imag}
  Complex get im => Complex(0, toDouble());
}