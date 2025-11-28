import '../../math/basic/math.dart' as math;
import '../number.dart';

/// The default precision of a `Precision`.
/// The default value is 50.
/// This can be changed by setting the global variable `decimalPrecision`.
int decimalPrecision = 50;

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
      return Precision.fromMap(m as Map<String, String>);
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
  // ignore: non_nullable_equals_parameter
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
  /// Returns the rounded value.
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
    if (n is Integer || n is Precision) return n;
    if (n is Double) return n.isInteger ? Integer(n.toInt()) : n;
    if (n is Imaginary) {
      if (n.value is Precision) return n;
      if (n.value.toDouble() == 0) return Integer(0);
      if (n.value.isInteger && n.value is Double) {
        return Imaginary(Integer(n.value.toInt()));
      }
      return n;
    }
    if (n is Complex) {
      final realZero = n.real.value == 0 &&
          (n.real is! Precision || n.real == Precision.zero);
      final imagZero = n.imag.value.value.toDouble() == 0 &&
          (n.imag.value is! Precision || n.imag.value == Precision.zero);
      if (realZero) {
        if (imagZero) return simplifyType(n.real);
        return Imaginary(simplifyType(n.imag.value));
      } else if (imagZero) {
        return simplifyType(n.real);
      } else {
        final simpleReal = simplifyType(n.real) as Real;
        final simpleImag = simplifyType(n.imag.value);
        if (identical(simpleReal, n.real) &&
            identical(simpleImag, n.imag.value)) {
          return n;
        }
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

  /// Find the square root of the number
  Number pow(num exponent) {
    if (this is Integer ||
        this is Precision ||
        this is Double ||
        this is Real) {
      return numToNumber(math.pow(numberToNum(this), exponent));
    } else if (this is Imaginary) {
      return Complex.num(Integer.zero, this as Imaginary).pow(exponent);
    } else {
      return (this as Complex).pow(exponent);
    }
  }

  /// Find the square root of the number
  Number sqrt() {
    if (this is Integer ||
        this is Precision ||
        this is Double ||
        this is Real) {
      var re = math.sqrt(numberToNum(this));
      return re is num ? numToNumber(re) : re;
    } else if (this is Imaginary) {
      return Complex.num(Integer.zero, this as Imaginary).sqrt();
    } else {
      return (this as Complex).sqrt();
    }
  }

  /// Get the nth root of the number
  dynamic nthRoot(double nth, {bool allRoots = false}) {
    Complex complex = Complex.zero();
    if (this is Integer ||
        this is Precision ||
        this is Double ||
        this is Real) {
      complex = Complex.fromReal(numberToNum(this));
    }
    if (this is Imaginary) {
      complex = Complex.num(Integer.zero, this as Imaginary);
    }
    if (this is Complex) {
      complex = this as Complex;
    }
    //Return all the complex numbers of the nth root
    if (allRoots) {
      var roots = <Complex>[];
      for (var k = 0; k < nth; k++) {
        var r = math.pow(abs().toDouble(), 1 / nth);
        var theta = (complex.phase.value + 2 * math.pi * k) / nth;
        roots.add(Complex(r * math.cos(theta), r * math.sin(theta)));
      }
      return roots;
    }

    // return the ony smallest positive complex number
    var isNegativeNth = nth < 0;
    var n = isNegativeNth ? -nth : nth;

    var a = 0.0;
    var b = 0.0;

    if (n == 0) {
      a = 1;
    } else {
      var length = math.pow(abs().toDouble(), 1.0 / n) as double;
      var angle =
          complex.phase < 0 ? complex.phase + (2 * math.pi) : complex.phase;
      angle /= n;
      a = length * math.cos(angle.toDouble());
      b = length * math.sin(angle.toDouble());
    }

    if (isNegativeNth) {
      final den = a * a + b * b;
      a /= den;
      b = -b / den;
    }

    return Complex(a, b);
  }

  /// Returns the natural exponentiation of a number.
  Number exp() {
    if (this is Integer ||
        this is Precision ||
        this is Double ||
        this is Real) {
      return math.exp(numberToNum(this));
    } else if (this is Imaginary) {
      return Complex.num(Integer.zero, this as Imaginary).exp();
    } else {
      return Complex(this).exp();
    }
  }

  /// Returns the fractional type of the value
  Fraction asFraction() {
    var v = toFraction();
    return Fraction(v[0], v[1]);
  }

  /// Converts the double to a mixed fraction represented as a list of integers where the first element is the whole number,
  /// the second is the numerator of the fractional part, and the third is the denominator of the fractional part.
  /// Example:
  /// ```
  /// double number = 1.666666666;
  /// List<int> mixedFraction = number.toMixedFraction();
  /// print(mixedFraction);  // Outputs: [1, 2, 3]
  /// ```
  List<int> toMixedFraction() {
    var fraction = toFraction();
    int whole = fraction[0] ~/ fraction[1];
    int numerator = fraction[0] % fraction[1];
    int denominator = fraction[1];

    // Return mixed fraction if whole part exists, else simple fraction
    return whole != 0
        ? [whole, numerator, denominator]
        : [numerator, denominator];
  }

  /// Approximates the double as a simple fraction with the numerator and denominator as elements of a list.
  /// Example:
  /// ```
  /// double number = 0.666666666;
  /// List<int> fraction = number.toFraction();
  /// print(fraction);  // Outputs: [2, 3]
  /// ```
  List<int> toFraction([int precision = 64]) {
    double error = 1.0 / (precision * precision);
    double x = toDouble();
    int sign = (x < 0) ? -1 : 1;
    x = x.abs();

    // The integer part of the decimal.
    int integerPart = x.floor();
    x -= integerPart;

    // If x is now zero, the fraction is [this, 1].
    if (x < error) return [sign * integerPart, 1];

    // The lower fraction is 0/1.
    int lowerN = 0;
    int lowerD = 1;

    // The upper fraction is 1/1.
    int upperN = 1;
    int upperD = 1;

    while (true) {
      // The middle fraction is (lower_n + upper_n) / (lower_d + upper_d).
      int middleN = lowerN + upperN;
      int middleD = lowerD + upperD;

      // If x + error < middle, middle is our new upper.
      if (middleD * (x + error) < middleN) {
        upperN = middleN;
        upperD = middleD;
      }
      // Else If middle < x - error, middle is our new lower.
      else if (middleN < (x - error) * middleD) {
        lowerN = middleN;
        lowerD = middleD;
      }
      // Else middle is our best fraction.
      else {
        return [(sign * integerPart * middleD) + (sign * middleN), middleD];
      }
    }
  }

  /// Returns a string representation of the double as a simple fraction.
  /// Example:
  /// ```
  /// double number = 0.666666666;
  /// String fraction = number.toFractionString();
  /// print(fraction);  // Outputs: "2/3"
  /// ```
  String toFractionString() {
    var fraction = toFraction();
    if (fraction[1] == 1 || fraction[0] == fraction[1]) {
      return "${fraction[0]}";
    } else {
      return "${fraction[0]}/${fraction[1]}";
    }
  }

  /// Returns a string representation of the double as a mixed fraction.
  /// Example:
  /// ```
  /// double number = 1.666666666;
  /// String mixedFraction = number.toMixedFractionString();
  /// print(mixedFraction);  // Outputs: "1(2/3)"
  /// ```
  String toMixedFractionString() {
    var mixedFraction = toMixedFraction();
    if (mixedFraction[1] == 0) {
      return "${mixedFraction[0]}";
    } else if (mixedFraction[0] == 0) {
      return "${mixedFraction[1]}/${mixedFraction[2]}";
    } else {
      return "${mixedFraction[0]}(${mixedFraction[1]}/${mixedFraction[2]})";
    }
  }
}
