part of 'complex.dart';

/// A specialized class representing purely imaginary numbers (0 + bi).
/// Extends [Complex] and provides optimized operations for imaginary numbers.
class Imaginary extends Complex {
  /// Creates an imaginary number with the given coefficient.
  /// The real part is always 0.
  Imaginary(num coefficient) : super(0, coefficient);

  /// Returns a Complex number equivalent to this Imaginary number.
  Complex toComplex() => Complex(0, coefficient);


  /// The coefficient of the imaginary unit (i).
  num get coefficient => imaginary;

  /// Always returns false as the value in the real dimension is 0.
  /// To find whether the imaginary component is infinite use `value.isInfinite`.
  @override
  bool get isInfinite => false;

  /// Always returns false as the value in the real dimension is 0.
  /// To find whether the imaginary component is NaN use `value.isNaN`.
  @override
  bool get isNaN => false;

  /// Always returns false as the value in the real dimension is 0.
  /// To find whether the imaginary component is negative use `value.isNegative`.
  @override
  bool get isNegative => false;

  /// Always returns true as the value in the real dimension is 0.
  /// To find whether the imaginary component is an integer use `value.isInteger`.
  @override
  bool get isInteger => true;

  /// Returns a new imaginary number with the negated coefficient.
  @override
  Imaginary operator -() => Imaginary(-coefficient);


  @override
  // ignore: non_nullable_equals_parameter
  bool operator ==(dynamic other) {
    if (other is Imaginary) return value == other.value;
    if (other is Complex) return other.real == 0.0 && this == other.imaginary;
    if (other is num) return value.toDouble() == 0.0 && other == 0.0;

    return false;
  }

   @override
  int get hashCode {
    if (value.toDouble() == 0) return 0.hashCode;
    return hashObjects(<Object>[0, value]);
  }

  /// Returns the conjugate of this imaginary number (sign of coefficient flipped).
  @override
  Imaginary get conjugate => Imaginary(-coefficient);

  /// Returns the magnitude of this imaginary number (absolute value of coefficient).
  @override
  num abs() => coefficient.abs();

// Support [dart:convert] json.
  ///
  /// Map Contents:
  ///     'imag' : toJson map of value
  ///
  /// Example:
  ///     {'imag':{'d':456.7}}
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{'imag': value.toJson()};

  /// Returns the exponential form string representation.
  @override
  String toExponentialString() {
    final r = abs();
    return '${r.toStringAsFixed(6)}e^(${coefficient > 0 ? 'π/2' : '-π/2'}i)';
  }

  /// Returns the polar form string representation.
  @override
  String toPolarString() {
    final r = abs();
    final angle = coefficient > 0 ? 'π/2' : '-π/2';
    return '${r.toStringAsFixed(6)}(cos($angle) + i⋅sin($angle))';
  }
}