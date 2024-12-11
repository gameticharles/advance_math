import 'dart:math';
import 'complex.dart';
import 'double.dart';
import 'integer.dart';
import 'number.dart';
import 'real.dart';
import '../util/jenkins_hash.dart';

/// Represents an imaginary number, defined as a number whose square is negative one.
///
/// An imaginary number is usually displayed as a value followed by small letter 'i'.
/// 'i' squared is defined as -1 (or equivalently, the square root of -1 is defined as 'i').
class Imaginary extends Number {
  /// Constructs a instance.
  Imaginary(dynamic val)
      : value = (val is num)
            ? ((val is int) ? Integer(val) : Double(val as double))
            : (val is Real)
                ? val
                : Double.zero;

  /// Constructs a constant Imaginary number.
  const Imaginary.constant(this.value) : super.constant();

  /// Constructs a instance, applying the values in map [m].
  factory Imaginary.fromMap(Map<String, Map<String, dynamic>>? m) =>
      (m?.containsKey('imag') == true)
          ? Imaginary.fromMap(m?['imag'] as Map<String, Map<String, dynamic>>)
          : const Imaginary.constant(Integer.zero);

  /// The value of the imaginary component as a Real number.
  final Real value;

  num get getValue => value.value;

  /// Always returns zero.
  @override
  double toDouble() => 0;

  /// Always returns zero.
  @override
  int toInt() => 0;

  /// Returns a Complex number equivalent to this Imaginary number.
  Complex toComplex() => Complex.num(
      Integer(0),
      Imaginary(
          value.isInteger ? Integer(value.toInt()) : Double(value.toDouble())));

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

  @override
  // ignore: non_nullable_equals_parameter
  bool operator ==(dynamic obj) {
    if (obj is Imaginary) return value == obj.value;
    if (obj is Complex) return obj.real.value == 0.0 && this == obj.imaginary;
    if (obj is Real || obj is num) return value.toDouble() == 0.0 && obj == 0.0;

    return false;
  }

  @override
  int get hashCode {
    if (value.toDouble() == 0) return 0.hashCode;
    return hashObjects(<Object>[0, value]);
  }

  @override
  Number operator +(dynamic addend) {
    if (addend is Imaginary) {
      return Number.simplifyType(Imaginary(value + addend.value));
    }
    if (addend is Complex) {
      return Number.simplifyType(
          Complex.num(addend.real, Imaginary(value + addend.imag.value)));
    }
    if (addend is Real) return Number.simplifyType(Complex.num(addend, this));
    if (addend is num) {
      return Number.simplifyType(Complex.num(Double(addend.toDouble()), this));
    }
    return this;
  }

  @override
  Imaginary operator -() => Imaginary(-value);

  @override
  Number operator -(dynamic subtrahend) {
    if (subtrahend is num) {
      return Number.simplifyType(Complex.num(
          subtrahend is int
              ? Integer(-subtrahend)
              : Double(-subtrahend as double),
          this));
    }
    if (subtrahend is Real) {
      return Number.simplifyType(Complex.num(-subtrahend, this));
    }
    if (subtrahend is Complex) {
      return Number.simplifyType(Complex.num(
          -subtrahend.real, this - subtrahend.imaginary as Imaginary));
    }
    if (subtrahend is Imaginary) {
      return Number.simplifyType(Imaginary(value - subtrahend.value));
    }

    return this;
  }

  @override
  Number operator *(dynamic multiplicand) {
    // i * i = -1
    if (multiplicand is Imaginary) {
      return Number.simplifyType(value * multiplicand.value * -1);
    }
    if (multiplicand is num) {
      return Number.simplifyType(Imaginary(value * multiplicand));
    }
    if (multiplicand is Real) {
      return Number.simplifyType(Imaginary(multiplicand * value));
    }
    if (multiplicand is Complex) {
      // ai * (b + ci) = -ac + abi
      final real = value * multiplicand.imag.value.toDouble() * -1.0 as Real;
      final imag = value * multiplicand.real as Real;
      if (imag.toDouble() == 0) return Number.simplifyType(real);
      if (real.toDouble() == 0) return Number.simplifyType(Imaginary(imag));
      return Number.simplifyType(Complex.num(real, Imaginary(imag)));
    }

    return Imaginary(0);
  }

  @override
  Number operator /(dynamic divisor) {
    if (divisor is num) return Number.simplifyType(Imaginary(value / divisor));
    if (divisor is Real) return Number.simplifyType(Imaginary(value / divisor));
    if (divisor is Imaginary) return Number.simplifyType(value / divisor.value);
    if (divisor is Complex) {
      // (a + bi) / (c + di) = (ac + bd) / (c^2 + d^2) + i * (bc - ad) / (c^2 + d^2)
      // for a = 0 => bi / (c + di) = bd / (c^2 + d^2) + i * bc / (c^2 + d^2)
      if (divisor.real.isNaN || divisor.imag.isNaN) {
        return Complex.num(Double.NaN, Imaginary(Double.NaN));
      }
      if (divisor.real.value == 0 && divisor.imag.value.value == 0) {
        if (value.value == 0) {
          return Complex.num(Double.NaN, Imaginary(Double.NaN));
        }
        if (value.isNegative) {
          return Complex.num(Double.negInfinity, Imaginary(Double.negInfinity));
        }
        return Complex.num(Double.infinity, Imaginary(Double.infinity));
      }
      final bOverc2d2 =
          value / ((divisor.real ^ 2.0) + (divisor.imaginary.value ^ 2.0));
      return Number.simplifyType(Complex.num(
          bOverc2d2 * divisor.imaginary.value as Real,
          Imaginary(bOverc2d2 * divisor.real)));
    }

    // Treat divisor as 0.
    return value.isNegative
        ? Imaginary(Double.negInfinity)
        : Imaginary(Double.infinity);
  }

  /// The truncating division operator.
  @override
  Number operator ~/(dynamic divisor) {
    if (divisor == 0) {
      return value < 0
          ? Imaginary(Double.negInfinity)
          : Imaginary(Double.infinity);
    }
    if (divisor is num) return Number.simplifyType(Imaginary(value ~/ divisor));
    if (divisor is Imaginary) {
      return Number.simplifyType(value ~/ divisor.value);
    }
    if (divisor is Real) {
      return Number.simplifyType(Imaginary(value ~/ divisor.value));
    }
    if (divisor is Complex) {
      // (a + bi) / (c + di) = (ac + bd) / (c^2 + d^2) + i * (bc - ad) / (c^2 + d^2)
      // for a = 0 => bi / (c + di) = bd / (c^2 + d^2) + i * bc / (c^2 + d^2)
      final bOverc2d2 =
          value / (divisor.real ^ 2.0) + (divisor.imaginary.value ^ 2.0);
      return Number.simplifyType(Complex.num(
          (bOverc2d2 * divisor.real).truncate() as Real,
          Imaginary((bOverc2d2 * divisor.imaginary.value * -1.0).truncate())));
    }

    // Treat divisor as 0.
    return value < 0
        ? Imaginary(Double.negInfinity)
        : Imaginary(Double.infinity);
  }

  /// The modulo operator (not supported).
  @override
  Number operator %(dynamic divisor) => toComplex() % divisor;

  /// The power operator (note: NOT bitwise XOR).
  ///
  /// In order to provide a convenient power operator for all [Number]s, the number library
  /// overrides the caret operator.  In Dart the caret operator is ordinarily used
  /// for bitwise XOR operations on [int]s.  The Integer class provides the `bitwiseXor` method
  /// as a substitute.
  @override
  Number operator ^(dynamic exponent) => toComplex() ^ exponent;

  /// The complex modulus is the absolute value of this Imaginary number.
  Number get complexModulus => value.abs();

  /// The complex argument, or phase, of this imaginary number in radians.
  num get complexArgument => value < 0 ? -pi / 2.0 : pi / 2.0;

  /// The phase is synonymous with the complex argument.
  num get phase => complexArgument;

  /// If [obj] is an [Imaginary] number then the comparison is made in the imaginary dimension (for example,
  /// 5i > 3i is true).
  ///
  /// For all other types of numbers the comparison is made in the real dimension, so this [Imaginary] number
  /// is regarded as zero.
  @override
  bool operator >(dynamic obj) {
    if (obj is num) return 0 > obj;
    if (obj is Real) return 0 > obj.value;
    if (obj is Imaginary) return value > obj.value;
    if (obj is Complex) return 0 > obj.real.value;

    // treat obj as zero
    return false;
  }

  @override
  bool operator >=(dynamic obj) {
    // Check for equality.
    if ((obj is Imaginary || obj is Complex) && this == obj) return true;
    if (obj is Real) return obj <= 0;
    if (obj is num) return obj <= 0;

    return this > obj;
  }

  @override
  bool operator <(dynamic obj) => !(this >= obj);

  @override
  bool operator <=(dynamic obj) => !(this > obj);

  /// The absolute value of a Complex number is its distance from zero in the
  /// Complex number space (e.g., the absolute value of 0 + 4i = 4).  The absolute
  /// value is always a real number.
  @override
  Number abs() => value.isInteger
      ? Integer(value.abs().toInt())
      : Double(value.abs().toDouble());

  /// The integer ceiling of a purely imaginary number is always zero.
  @override
  Number ceil() => Integer.zero;

  /// Clamps the real portion of a complex number having this imaginary value.
  @override
  Number clamp(dynamic lowerLimit, dynamic upperLimit) => Number.simplifyType(
      Complex.num(Integer(0), this).clamp(lowerLimit, upperLimit));

  /// The integer floor of a purely imaginary number is always zero.
  @override
  Number floor() => Integer.zero;

  /// The nearest integer of a purely imaginary number is always zero.
  @override
  Number round() => Integer.zero;

  /// The integer resulting from truncation of a purely imaginary number is always zero.
  @override
  Number truncate() => Integer.zero;

  @override
  Number reciprocal() {
    if (value == Integer(0)) return Imaginary(Double.NaN);
    return Integer.one / this;
  }

  /// The real remainder will always be zero.
  @override
  Number remainder(dynamic divisor) => Integer.zero;

  /// Support [dart:convert] json.
  ///
  /// Map Contents:
  ///     'imag' : toJson map of value
  ///
  /// Example:
  ///     {'imag':{'d':456.7}}
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{'imag': value.toJson()};

  @override
  String toString() => '${value}i';
}
