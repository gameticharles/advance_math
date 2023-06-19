import 'dart:math' as math;

import 'complex.dart';
import 'double.dart';
import 'imaginary.dart';
import 'integer.dart';
import 'precise.dart';
import 'real.dart';

/// The abstract base class for all Number types.
abstract class Number implements Comparable<dynamic> {
  /// The default constructor.
  Number();

  /// Supports const constructors in concrete classes.
  const Number.constant();

  /// Detect the type of Number by inspecting map contents and create it.
  /// Recognized formats are:
  ///     {'i': int value}
  ///     {'d': double value}
  ///     {'pd': arbitrary precision string}
  ///     {'real': {i or d map}, 'imag': {i or d map}}
  ///     {'imag': {i or d map}}
  ///
  /// If the map contents are not recognized [Integer.zero] will be returned.
  factory Number.fromMap(Map<String, dynamic>? m) {
    if (m == null) return Integer.zero;
    if (m.containsKey('d') && m['d'] is num) {
      return Double.fromMap(m as Map<String, num>);
    }
    if (m.containsKey('i') && m['i'] is int) {
      return Integer.fromMap(m as Map<String, int>);
    }
    if (m.containsKey('precise') && m['precise'] is Map<String, String>) {
      return Precise.fromMap(m as Map<String, String>);
    }
    if (m.containsKey('real') && m is Map<String, Map<String, dynamic>>) {
      return Complex.fromMap(m);
    }
    if (m.containsKey('imag') && m is Map<String, Map<String, dynamic>>) {
      return Imaginary.fromMap(m);
    }
    return Integer.zero;
  }

  // Abstract operators

  /// Two Numbers will be equal when the represented values are equal,
  /// even if the Number subtypes are different.
  @override
  bool operator ==(dynamic obj);

  /// The hash codes for two Numbers will be equal when the represented values are equal,
  /// even if the Number subtypes are different.
  ///
  /// Additionally, Numbers having integer values will have the same hashCode as
  /// the corresponding dart:core `int`.
  @override
  int get hashCode;

  /// Returns the sum of this Number and a Number or num.  This Number is unaffected.
  Number operator +(dynamic addend);

  /// Returns the negative of this Number.  This Number is unaffected.
  Number operator -();

  /// Returns the difference of this Number and the [subtrahend] (a Number or num).
  /// This Number is unaffected.
  Number operator -(dynamic subtrahend);

  /// Returns the product of this Number and the [multiplicand] (a Number or num).
  /// This Number is unaffected.
  Number operator *(dynamic multiplicand);

  /// Returns the quotient of this Number divided by the [divisor] (a Number or num).
  /// This Number is unaffected.
  Number operator /(dynamic divisor);

  /// Returns the quotient of this Number divided by the [divisor] (a Number or num)
  /// truncated to an Integer.  This Number is unaffected.
  Number operator ~/(dynamic divisor);

  /// Returns the remainder after division of this Number by [divisor] (a Number or num).
  Number operator %(dynamic divisor);

  /// Returns this Number raised to the power of [exponent] (a Number or num).
  /// This Number is unaffected.
  Number operator ^(dynamic exponent);

  /// Returns whether the value of this Number is greater than the value of obj (a Number or num).
  bool operator >(dynamic obj);

  /// Returns whether the value of this Number is greater than or equal to the value of obj (a Number or num).
  bool operator >=(dynamic obj);

  /// Returns whether the value of this Number is less than the value of obj (a Number or num).
  bool operator <(dynamic obj);

  /// Returns whether the value of this Number is less than or equal to the value of obj (a Number or num).
  bool operator <=(dynamic obj);

  // Mirror num's abstract properties.

  /// Whether this Number represents a finite value.
  bool get isFinite => !isInfinite;

  /// Whether this Number represents infinity.
  bool get isInfinite;

  /// Whether this Number represents a value .
  bool get isNaN;

  /// Whether this number is less than zero.
  bool get isNegative;

  ///
  /// This method shifts the decimal point [decimalPlaces] places to the right,
  /// rounds to the nearest integer, and then shifts the decimal point back to the
  /// left by the same amount. The default value of [decimalPlaces] is `0`.
  ///
  /// Returns the rounded [value].
  Number roundTo([int decimalPlaces = 0]) {
    if (decimalPlaces == 0) {
      return round();
    } else {
      return (this * math.pow(10, decimalPlaces)).round() /
          math.pow(10, decimalPlaces);
    }
  }

  /// Returns minus one, zero or plus one depending on the sign and numerical value of the number.
  /// Returns minus one if the number is less than zero, plus one if the number is greater than zero,
  /// and zero if the number is equal to zero. Returns NaN if the number is NaN.
  /// Returns an `int` if this Number's value is an integer, a `double` otherwise.
  num get sign {
    if (isNaN) return double.nan;
    if (isNegative) return isInteger ? -1 : -1.0;
    if (toDouble() == 0) return isInteger ? 0 : 0.0;
    return isInteger ? 1 : 1.0;
  }

  /// Returns the Number equivalent to [n] having the simplest type that can
  /// represent the value (in order):  Integer, Double, Imaginary, or Complex.
  /// If [n] is already the most simple type possible, then it will be returned directly.
  /// Precise Numbers always remain Precise.
  static Number simplifyType(Number n) {
    if (n is Integer || n is Precise) return n;
    if (n is Double) return n.isInteger ? Integer(n.toInt()) : n;
    if (n is Imaginary) {
      if (n.value is Precise) return n;
      if (n.value.toDouble() == 0) return Integer(0);
      if (n.value.isInteger && n.value is Double) {
        return Imaginary(Integer(n.value.toInt()));
      }
      return n;
    }
    if (n is Complex) {
      final realZero =
          n.real.value == 0 && (n.real is! Precise || n.real == Precise.zero);
      final imagZero = n.imag.value.value.toDouble() == 0 &&
          (n.imag.value is! Precise || n.imag.value == Precise.zero);
      if (realZero) {
        if (imagZero) return simplifyType(n.real);
        return Imaginary(simplifyType(n.imag.value));
      } else if (imagZero) {
        return simplifyType(n.real);
      } else {
        final simpleReal = simplifyType(n.real) as Real;
        final simpleImag = simplifyType(n.imag.value);
        if (identical(simpleReal, n.real) &&
            identical(simpleImag, n.imag.value)) return n;
        return Complex.num(simpleReal, Imaginary(simpleImag));
      }
    }

    return n;
  }

  // Mirror num's abstract methods.

  /// Returns the absolute value of this Number.
  Number abs();

  /// Returns the least Number having integer components no smaller than this Number.
  Number ceil();

  /// Returns this num clamped to be in the range lowerLimit-upperLimit.
  /// The comparison is done using compareTo and therefore takes -0.0 into account.
  /// This also implies that double.NAN is treated as the maximal double value.
  /// `lowerLimit` and `upperLimit` are expected to be `num` or `Number' objects.
  Number clamp(dynamic lowerLimit, dynamic upperLimit);

  /// Returns the greatest Number with an integer value no greater than this Number.
  /// If this is not finite (NaN or infinity), throws an UnsupportedError.
  Number floor();

  /// Returns the remainder of the truncating division of this Number by `divisor`.
  /// The result r of this operation satisfies: this == (this ~/ other) * other + r.
  /// As a consequence the remainder r has the same sign as the [operator /(divisor)].
  Number remainder(dynamic divisor);

  /// Returns the integer Number closest to this Number.
  /// Rounds away from zero when there is no closest integer:
  /// (3.5).round() == 4 and (-3.5).round() == -4.
  /// If this is not finite (NaN or infinity), throws an UnsupportedError.
  Number round();

  /// Converts this Number to a `dart:core int`.
  int toInt();

  /// Converts this Number to a `dart:core double`.
  double toDouble();

  /// Returns a truncated value.
  Number truncate();

  // Add some of our own.

  /// Returns the Number that is the reciprocal of this Number.
  /// This Number is unaffected.
  Number reciprocal();

  /// Subclasses must support dart:json for stringify.
  Map<String, dynamic> toJson();

  /// True if the Number represents an integer value.
  /// Note that the Number does not have to be of type
  /// Integer for this to be true.
  bool get isInteger;

  /// Compares this Number to another Number by comparing values.
  /// [n2] is expected to be a num or Number.  If it is not it will
  /// be considered to have a value of 0.
  @override
  int compareTo(dynamic n2) {
    if (n2 is Number) return Comparable.compare(toDouble(), n2.toDouble());
    if (n2 is num) return Comparable.compare(toDouble(), n2);

    // If n2 is not a num or Number, treat it as a zero
    return Comparable.compare(toDouble(), 0);
  }
}
