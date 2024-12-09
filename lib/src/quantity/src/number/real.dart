import 'dart:math';
import 'complex.dart';
import 'double.dart';
import 'imaginary.dart';
import 'integer.dart';
import 'number.dart';
import 'decimal.dart';

/// Provides a common handle for all Real Numbers.
abstract class Real extends Number {
  /// The default constructor.
  Real();

  /// Creates a constant real number.
  const Real.constant() : super.constant();

  /// Constructs a instance using the value for property `d` (decimal) or `i` (integer) in Map [m].
  factory Real.fromMap(Map<String, dynamic>? m) =>
      m?.containsKey('d') == true || m?.containsKey('i') == true
          ? Number.fromMap(m) as Real
          : Integer.zero;

  /// All Real subclasses must be able to provide their value as a [dart:core] [num].
  num get value;

  @override
  int toInt();

  @override
  double toDouble();

  @override
  bool get isInfinite =>
      value == double.infinity || value == double.negativeInfinity;

  @override
  bool get isNaN => identical(value, double.nan);

  @override
  bool get isNegative => value < 0;

  /// Negation operator.
  @override
  Real operator -();

  /// Addition operator.
  ///
  /// [addend] is expected to be a `num` or `Number`.  If it is not it is assumed to be 0.
  ///
  @override
  Number operator +(dynamic addend) {
    if (addend is num) return Double((value + addend).toDouble());
    if (addend is Decimal) return addend + this;
    if (addend is Real) return Double((value + addend.value).toDouble());
    if (addend is Complex) {
      return Complex.num(Double(addend.real.toDouble() + value), addend.imag);
    }
    if (addend is Imaginary) return Complex.num(this, addend);
    return this;
  }

  @override
  Number operator -(dynamic subtrahend) {
    if (subtrahend is num) return Double((value - subtrahend).toDouble());
    if (subtrahend is Decimal) return (-subtrahend) + this;
    if (subtrahend is Real) {
      return Double((value - subtrahend.value).toDouble());
    }
    if (subtrahend is Complex) {
      return Complex.num(
          Double((value - subtrahend.real.value).toDouble()), -subtrahend.imag);
    }
    if (subtrahend is Imaginary) return Complex.num(this, -subtrahend);
    return this;
  }

  @override
  Number operator *(dynamic multiplicand) {
    if (multiplicand is num) {
      if (multiplicand.isNaN) return Double.NaN;
      final product = multiplicand * value;
      if (product == product.truncate()) return Integer(product.truncate());
      return Double(product.toDouble());
    }
    if (multiplicand is Decimal) return multiplicand * this;
    if (multiplicand is Real) {
      if (multiplicand.isNaN) return Double.NaN;
      return Number.simplifyType(this * multiplicand.value);
    }
    if (multiplicand is Complex) {
      if (multiplicand.real.isNaN || multiplicand.imag.value.isNaN) {
        return Double.NaN;
      }
      return Number.simplifyType(Complex.num(multiplicand.real * value as Real,
          Imaginary(multiplicand.imag.value * value)));
    }
    if (multiplicand is Imaginary) {
      return Number.simplifyType(Imaginary(multiplicand.value * value));
    }

    // Treat multiplier as 0
    return Integer.zero;
  }

  @override
  Number operator /(dynamic divisor) {
    if (divisor is num) {
      if (divisor.isNaN) return Double.NaN;
      if (divisor == 0) {
        return value == 0
            ? Double.NaN
            : value > 0
                ? Double.infinity
                : Double.negInfinity;
      }
      final num quotient = value / divisor;
      return quotient.toInt() == quotient
          ? Integer(quotient.toInt())
          : Double(quotient.toDouble());
    }
    if (divisor is Decimal) return (Decimal(value)) / divisor;
    if (divisor is Real) {
      if (divisor.isNaN) return Double.NaN;
      if (divisor.value == 0) {
        return value == 0
            ? Double.NaN
            : value > 0
                ? Double.infinity
                : Double.negInfinity;
      }
      final num quotient = value / divisor.value;
      return quotient.toInt() == quotient
          ? Integer(quotient.toInt())
          : Double(quotient.toDouble());
    }
    if (divisor is Complex) {
      // (a + 0i) / (c + di) = (ac - adi) / (c^2 + d^2)
      if (divisor.real.isNaN || divisor.imag.value.isNaN) return Double.NaN;
      final c2d2 = (divisor.real ^ 2.0) + (divisor.imaginary.value ^ 2.0);
      final aOverc2d2 = this / c2d2;
      return Complex.num(aOverc2d2 * divisor.real as Real,
          Imaginary(aOverc2d2 * divisor.imaginary.value * -1.0));
    }
    if (divisor is Imaginary) {
      if (divisor.value.isNaN) return Imaginary(Double.NaN);
      if (value == 0 && divisor.value.value == 0) return Imaginary(Double.NaN);
      return Imaginary(-this / divisor.value);
    }

    // Treat divisor as 0.
    return value > 0 ? Double.infinity : Double.negInfinity;
  }

  /// The truncating division operator.
  /// When dividing by an [Imaginary] or [Complex] number, the result will contain an imaginary component.
  /// The imaginary component is *not* truncated; only the real portion of the result is truncated.
  @override
  Number operator ~/(dynamic divisor) {
    if (divisor == 0) return Double.infinity;
    if (divisor is num) return Integer(value ~/ divisor);
    if (divisor is Decimal) return (Decimal(value) / divisor).truncate();
    if (divisor is Real) return Integer(value ~/ divisor.value);
    if (divisor is Complex) {
      // (a + 0i) / (c + di) = (ac - adi) / (c^2 + d^2)
      final c2d2 = (divisor.real ^ 2.0) + (divisor.imaginary.value ^ 2.0);
      final aOverc2d2 = this / c2d2;
      return Complex.num((aOverc2d2 * divisor.real).truncate() as Real,
          Imaginary(aOverc2d2 * divisor.imaginary.value * -1.0));
    }
    if (divisor is Imaginary) {
      return Imaginary(((this / divisor.value) * -1).truncate());
    }

    // Treat divisor as 0
    return Double.infinity;
  }

  /// The modulo operator.
  /// [Imaginary] and [Complex] divisors are nor supported and will throw an Exception.
  @override
  Number operator %(dynamic divisor) {
    if (divisor is num) return Double((value % divisor).toDouble());
    if (divisor is Real) return Double((value % divisor.value).toDouble());
    if (divisor is Complex || divisor is Imaginary) {
      throw Exception(
          'Unsupported operation (% with imaginary or complex divisor)');
    }
    // Treat divisor as 0
    return Double.NaN;
  }

  /// The power operator (note: NOT bitwise XOR).
  ///
  /// In order to provide a convenient power operator for all [Number]s, the number library
  /// overrides the caret operator.  In Dart the caret operator is ordinarily used
  /// for bitwise XOR operations on [int]s.  The [Integer] class provides the `bitwiseXor` method
  /// as a substitute.
  @override
  Number operator ^(dynamic exponent) {
    if (exponent is num) {
      final raised = pow(value, exponent);
      if (raised.toInt() == raised) return Integer(raised.toInt());
      return Double(raised as double);
    }
    if (exponent is Decimal) return (Decimal(value)) ^ exponent;
    if (exponent is Real) {
      final raised = pow(value, exponent.value);
      if (raised.toInt() == raised) return Integer(raised.toInt());
      return Double(raised.toDouble());
    }
    if (exponent is Complex) {
      // a^(b+ic) = a^b * ( cos(c * ln(a)) + i * sin(c * ln(a)) )
      final coeff = this ^ exponent.real;
      final clna = (exponent.imaginary.value * log(value)).toDouble();
      return Complex.num(
          coeff * cos(clna) as Real, Imaginary(coeff * sin(clna)));
    }
    if (exponent is Imaginary) {
      // a^(ic) = cos(c * ln(a)) + i * sin(c * ln(a))
      final clna = (exponent.value * log(value)).toDouble();
      return Complex.num(cos(clna) as Real, Imaginary(sin(clna)));
    }
    return Double.one;
  }

  @override
  bool operator >(dynamic obj) {
    if (obj is num) return value > obj;
    if (obj is Decimal) return Decimal(value) > obj;
    if (obj is Real) return value > obj.value;
    if (obj is Imaginary) return value > 0;
    if (obj is Complex) return this > obj.real;
    return this > 0;
  }

  @override
  bool operator >=(dynamic obj) => this == obj || this > obj;

  @override
  bool operator <(dynamic obj) => !(this >= obj);

  @override
  bool operator <=(dynamic obj) => !(this > obj);

  @override
  Number abs() => value >= 0
      ? this
      : value is int
          ? Integer(value.abs().toInt())
          : Double(value.abs().toDouble());

  @override
  Number ceil() => Integer(value.ceil());

  @override
  Number floor() => Integer(value.floor());

  @override
  Number round() => Integer(value.round());

  @override
  Number truncate() => Integer(value.truncate());

  @override
  Number reciprocal() {
    if (value == 0) return Double.NaN;
    final num flipped = 1.0 / value;
    return flipped.toInt() == flipped
        ? Integer(flipped.toInt())
        : Double(flipped.toDouble());
  }

  @override
  Number remainder(dynamic divisor) {
    final div = divisor is num
        ? divisor
        : divisor is Number
            ? divisor.toDouble()
            : 0;
    final rem = value.remainder(div);
    if (rem is int) return Integer(rem);
    return Double(rem.toDouble());
  }

  @override
  String toString() => '$value';
}
