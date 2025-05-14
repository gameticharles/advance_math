part of 'complex.dart';

/// The imaginary unit 'i' (where i² = -1)
/// This can be used in expressions like: 2 + 3*i
final Imaginary i = Imaginary(1);

/// The imaginary unit 'j' (where j² = -1)
/// Common in engineering notation, equivalent to 'i'
/// This can be used in expressions like: 2 + 3*j
final Imaginary j = Imaginary(1);

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
    if (other is Imaginary) return coefficient == other.coefficient;
    if (other is Complex) return other.real == 0.0 && coefficient == other.imaginary;
    if (other is num) return coefficient == 0.0 && other == 0.0;
    return false;
  }

  @override
  int get hashCode {
    if (coefficient == 0) return 0.hashCode;
    return hashObjects(<Object>[0, coefficient]);
  }

  /// Returns the conjugate of this imaginary number (sign of coefficient flipped).
  @override
  Imaginary get conjugate => Imaginary(-coefficient);

  /// Returns the magnitude of this imaginary number (absolute value of coefficient).
  @override
  num abs() => coefficient.abs();

  /// The complex modulus is the absolute value of this Imaginary number.
  num get complexModulus => coefficient.abs();

  /// The complex argument, or phase, of this imaginary number in radians.
  num get complexArgument => coefficient < 0 ? -math.pi / 2.0 : math.pi / 2.0;

  /// The phase is synonymous with the complex argument.
  num get phase => complexArgument;

  /// If [obj] is an [Imaginary] number then the comparison is made in the imaginary dimension.
  /// For all other types of numbers the comparison is made in the real dimension, so this [Imaginary] number
  /// is regarded as zero.
  @override
  bool operator >(dynamic obj) {
    if (obj is num) return 0 > obj;
    if (obj is Imaginary) return coefficient > obj.coefficient;
    if (obj is Complex) return 0 > obj.real;
    // treat obj as zero
    return false;
  }

  @override
  bool operator >=(dynamic obj) {
    // Check for equality.
    if ((obj is Imaginary || obj is Complex) && this == obj) return true;
    if (obj is num) return obj <= 0;
    return this > obj;
  }

  @override
  bool operator <(dynamic obj) => !(this >= obj);

  @override
  bool operator <=(dynamic obj) => !(this > obj);

  /// The integer ceiling of a purely imaginary number is always zero.
  @override
  num ceil() => 0;

  /// The integer floor of a purely imaginary number is always zero.
  @override
  int floor() => 0;

  /// The nearest integer of a purely imaginary number is always zero.
  @override
  int round() => 0;

  /// The integer resulting from truncation of a purely imaginary number is always zero.
  @override
  int truncate() => 0;

  /// Support [dart:convert] json.
  ///
  /// Map Contents:
  ///     'imag' : coefficient value
  ///
  /// Example:
  ///     {'imag': 456.7}
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{'imag': coefficient};

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