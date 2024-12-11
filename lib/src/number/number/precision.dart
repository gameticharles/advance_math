// ignore_for_file: unnecessary_null_comparison, unnecessary_cast

import 'dart:math';
import 'dart:typed_data';
import 'double.dart';
import 'integer.dart';
import 'number.dart';
import 'number_exception.dart';
import 'real.dart';
import '../util/jenkins_hash.dart';

/// The default precision of a `Precision`.
/// The default value is 50.
/// This can be changed by setting the global variable `decimalPrecision`.
int decimalPrecision = 50;

/// `Precision` represents an arbitrary precision number.
///
/// It can be used anywhere a `Real` `Number` is used.
///
/// Arbitrary precision can be used to combat the effects of cumulative rounding errors in circumstances
/// where those errors can be significant.
///
/// This class enables arbitrary precision calculations in both Dart and when transpiled to JavaScript by
/// representing numbers as digits that stay within the limitations of the underlying number system.
///
/// In JavaScript the maximum value of a number, because they are 64-bit floating
/// point values, is 2^53, or 9007199254740992, and the maximum number of significant digits as a result is 16.
///
class Precision extends Real {
  /// Constructs an arbitrary precision number from a string or num.
  ///
  /// The precision can be limited by providing the maximum number of significant digits
  /// (default is 100).
  ///
  /// Examples:
  ///     Precision('12')
  ///     Precision('0.1234')
  ///     Precision('-12.345')
  ///     Precision('1.23456789e-6', sigDigits: 4)
  ///     Precision(12)
  ///     Precision(12.123456789)
  ///
  Precision(dynamic value, {int? sigDigits}) {
    _precision = sigDigits ?? decimalPrecision;
    var str = '';
    if (value is num) {
      if (value.isNaN || value.isInfinite) {
        throw Exception('Precision value must be a valid finite number');
      }
      str = value != null ? value.toString() : '';
      value = value.toString();
    } else {
      str = value.toLowerCase().trim();
    }

    if (str.startsWith('-')) _neg = true;
    final decimalPointIndex = str.indexOf('.');
    final eIndex = str.indexOf('e');

    if (decimalPointIndex != -1) {
      _power = eIndex != -1
          ? -(eIndex - decimalPointIndex - 1)
          : -(str.length - decimalPointIndex - 1);
    }
    if (eIndex != -1) {
      _power += int.parse(str.substring(eIndex + 1));
    }
    final endParseIndex = eIndex != -1 ? eIndex - 1 : value.length - 1;
    var char = '';
    var decimalPoint = false;
    for (var index = endParseIndex; index > -1; index--) {
      char = str[index];

      // Ignore one decimal.
      if (char == '.') {
        if (!decimalPoint) {
          decimalPoint = true;
          continue;
        } else {
          throw Exception(
              'Precision cannot parse a string with multiple decimal points');
        }
      }

      // Ignore sign character at start
      if (char == '-' || char == '+' && index == 0) break;
      _digits.add(Digit.char(char));
    }

    _trimLeadingZeros();
    _limitPrecision();
  }

  /// Constructs a Precision number, applying the values found in map [m].
  /// See `toJson` for the expected format.
  factory Precision.fromMap(Map<String, String>? m) {
    if (m == null) return Precision.zero;
    return Precision(m['decimal'] ?? '0');
  }

  /// Creates a arbitrary precision number directly from digits.
  ///
  /// [digits] must be ordered from least significant to most.
  ///
  /// [power] sets the offset of the decimal point, if any (defaults to 0).  For example,
  /// a power of -2 means that the decimal point is located between the second and third digits.
  /// A power of +2 means that two zeroes are implied before the least significant digit (that is, the number is
  /// one hundred times greater than the number specified by the digits).
  ///
  /// For a negative number set [neg] to true.
  ///
  /// The default precision is 1000 significant digits.
  Precision.raw(List<Digit> digits,
      {int power = 0, bool neg = false, int? sigDigits}) {
    _precision = sigDigits ?? decimalPrecision;
    if (digits.isNotEmpty) {
      _digits.addAll(digits);
    } else {
      _digits.add(Digit.zero);
    }
    _power = power;
    _neg = neg;
    _precision = sigDigits ?? decimalPrecision;

    _trimLeadingZeros();
    _limitPrecision();

    // Avoid negative zero.
    if (_neg && _digits.length == 1 && _digits.first == Digit.zero) {
      _neg = false;
    }
  }

  /// Zero as a Precision number.
  static final Precision zero = Precision(0);

  /// One as a Precision number.
  static final Precision one = Precision(1);

  /// Ten as a Precision.
  static final Precision ten = Precision(10);

  /// One hundred as a Precision.
  static final Precision hundred = Precision(100);

  /// One thousand as a Precision.
  static final Precision thousand = Precision(1000);

  /// Infinity as a Precision.
  static final Precision infinity = Precision(double.infinity);

  /// Negative infinity as a Precision.
  static final Precision negInfinity = Precision(double.negativeInfinity);

  /// Not a number as a Double.
  // ignore: constant_identifier_names
  static final Precision nan = Precision(double.nan);

  /// The digits of the arbitrary precision number are represented as a list of Digit objects,
  /// lowest significant digit to most significant digit.
  final List<Digit> _digits = <Digit>[];

  /// The offset of the decimal point.
  int get power => _power;
  int _power = 0;

  /// Flag for negative values.
  bool _neg = false;

  /// Optional precision cutoff (maximum number of significant digits allowed).
  int get precision => _precision;
  int _precision = decimalPrecision;
  set precision(int? sigDigits) {
    _precision = sigDigits ?? decimalPrecision;
    decimalPrecision = _precision;
    _limitPrecision();
  }

  /// Returns a copy of the internal digits list, from least significant to most.
  List<Digit> get digits => List<Digit>.from(_digits);

  /// If the specified precision is lower than the number of digits,
  /// truncates the digits and adjusts the power accordingly.
  /// Rounds the least significant digit based on the
  /// most significant truncated digit.
  void _limitPrecision() {
    if (_digits.length > _precision) {
      final numCull = _digits.length - _precision;
      var roundUp = false;

      // Round based on the digit one past the max precision
      for (var i = numCull - 1; i >= 0; i--) {
        final d = _digits.removeAt(i);
        if (i == numCull && d.toInt() > 4) roundUp = true;
      }
      _power += numCull;

      if (roundUp) {
        if (_digits[0] == Digit.nine) {
        } else {
          _digits[0] = Digit.list[_digits[0].toInt() + 1];
        }
      }
    }
  }

  /// Returns the digit at [place], where place is with respect to the decimal number system
  /// (that is, place 1 is tens, place 2 is hundreds, place -3 is thousandths, etc).
  ///
  /// Therefore place is not a direct index into the digits list; power must be taken into account first.
  ///
  Digit digitAtPlace(int place) {
    final index = place - power;
    if (index > -1 && index < _digits.length) {
      return _digits[index];
    } else {
      return Digit.zero;
    }
  }

  /// Returns true if the stored value can be represented exactly as an integer.
  @override
  bool get isInteger {
    if (_power >= 0) return true;

    // Check for case where decimal portion is equal to 0
    for (final d in digits.sublist(0, min(digits.length, _power.abs()))) {
      if (d != Digit.zero) return false;
    }
    return true;
  }

  @override
  bool get isNegative => _neg;

  @override
  int toInt() {
    if (_power >= 0) return int.parse(toString());
    return toDouble().round();
  }

  @override
  double toDouble() => double.parse(toString());

  /// Return only the decimal portion as a Precision number.
  ///
  /// For example, Precision value 123.4567 will return Precision value
  /// 0.4567.  An integer value will return [zero].
  Precision get decimalPortion {
    if (isInteger) return Precision.zero;
    return Precision.raw(digits.sublist(0, _power.abs())..add(Digit.zero),
        power: _power, neg: _neg);
  }

  @override
  num get value => isInteger ? toInt() : toDouble();

  /// Negation operator.
  @override
  Precision operator -() => this == Precision.zero
      ? Precision('0')
      : Precision.raw(digits, power: _power, neg: !_neg, sigDigits: precision);

  /// Addition operator.
  @override
  Precision operator +(dynamic addend) {
    final decimalAddend = toDecimal(addend);

    // Divert to subtraction if signs are not the same
    if (_neg != decimalAddend._neg) {
      if (_neg) return decimalAddend - (-this);
      return this - (-decimalAddend);
    }

    final placeExtents = determinePlaceExtents(this, decimalAddend);
    final sum = <Digit>[];
    var carry = 0;
    var temp = 0;
    for (var place = placeExtents[0]; place <= placeExtents[1]; place++) {
      final d1 = digitAtPlace(place);
      final d2 = decimalAddend.digitAtPlace(place);
      temp = (d1 + d2) + carry;
      if (temp < 10) {
        sum.add(Digit.list[temp]);
        carry = 0;
      } else {
        sum.add(Digit.list[temp - 10]);
        carry = 1;
      }
    }

    if (carry == 1) sum.add(Digit.one);

    return Precision.raw(sum,
        power: placeExtents[0],
        neg: _neg,
        sigDigits: max(_precision, decimalAddend.precision));
  }

  /// Subtraction operator.
  @override
  Precision operator -(dynamic subtrahend) {
    final decimalSubtrahend = toDecimal(subtrahend);

    // Divert to addition if signs are different
    if (_neg != decimalSubtrahend._neg) {
      if (_neg) return -(decimalSubtrahend + (-this));
      return this + (-decimalSubtrahend);
    }

    // Flip operation if subtrahend is greater
    if (decimalSubtrahend.abs() > abs()) return -(decimalSubtrahend - this);

    // Subtrahend is lesser; safe to borrow
    final placeExtents = determinePlaceExtents(this, decimalSubtrahend);
    final diff = <Digit>[];
    var borrow = 0;
    var temp = 0;
    for (var place = placeExtents[0]; place <= placeExtents[1]; place++) {
      final d1 = digitAtPlace(place);
      final d2 = decimalSubtrahend.digitAtPlace(place);
      temp = (d1 - d2) + borrow;
      if (temp < 0) {
        diff.add(Digit.list[10 + temp]);
        borrow = -1;
      } else {
        diff.add(Digit.list[temp]);
        borrow = 0;
      }
    }

    return Precision.raw(diff,
        power: placeExtents[0],
        neg: _neg,
        sigDigits: max(_precision, decimalSubtrahend.precision));
  }

  /// Multiplication operator.
  @override
  Precision operator *(dynamic multiplier) {
    final decimalMultiplier = toDecimal(multiplier);

    var product = Precision.zero;
    var intermediateProduct = <Digit>[];
    final combinedPower = _power + decimalMultiplier._power;
    var carry = 0;
    var temp = 0;
    var offset = 0;
    for (var p1 = decimalMultiplier._power;
        p1 < decimalMultiplier._power + decimalMultiplier._digits.length;
        p1++) {
      final d1Int = decimalMultiplier.digitAtPlace(p1).toInt();
      intermediateProduct = <Digit>[];
      for (var p2 = _power; p2 < _power + _digits.length; p2++) {
        final d2 = digitAtPlace(p2);
        temp = (d1Int * d2.toInt()) + carry;

        if (temp < 10) {
          intermediateProduct.add(Digit.list[temp]);
          carry = 0;
        } else {
          carry = temp ~/ 10;
          intermediateProduct.add(Digit.list[temp - (carry * 10)]);
        }
      }
      if (carry != 0) {
        intermediateProduct.add(Digit.list[carry]);
        carry = 0;
      }

      for (var i = 0; i < offset; i++) {
        intermediateProduct.insert(0, Digit.zero);
      }
      product += Precision.raw(intermediateProduct,
          sigDigits: max(_precision, decimalMultiplier.precision) + 2);
      offset += 1;
    }

    return Precision.raw(product._digits,
        power: combinedPower,
        neg: _neg != decimalMultiplier._neg && product != Precision.zero,
        sigDigits: max(_precision, decimalMultiplier.precision) + 2);
  }

  /// Division operator.
  @override
  Precision operator /(dynamic divisor) {
    var decimalDivisor = toDecimal(divisor);

    final negResult = _neg != decimalDivisor._neg;

    if (decimalDivisor == Precision.zero) {
      if (this == Precision.zero) return Precision.nan;
      return negResult ? Precision.negInfinity : Precision.infinity;
    }
    if (decimalDivisor == Precision(1)) return this;

    // Use the absolute value of the divisor from here
    decimalDivisor = decimalDivisor.abs();

    // Shift of decimal place
    var shift = 0;
    if (decimalDivisor._power < 0) {
      shift = -decimalDivisor._power;

      // Convert divisor to integer
      decimalDivisor = Precision.raw(decimalDivisor.digits);
    }

    // Long division algorithm
    final divisorDigits = decimalDivisor._digits.length;
    //int remainder = 0;
    final result = <Digit>[];
    var digitCursor = _digits.length - 1;
    var temp = <Digit>[];
    while (result.length < _precision) {
      // If into bonus digits and remainder is 0, done
      if (digitCursor < 0) {
        if (Precision.raw(temp) == Precision.zero) {
          break;
        }
      }

      // Process next digit
      temp.insert(0, digitCursor >= 0 ? _digits[digitCursor] : Digit.zero);
      if (digitCursor < 0) shift--;
      if (temp.length >= divisorDigits) {
        final p = Precision.raw(temp);
        if (p >= decimalDivisor) {
          // Find the highest multiple of the divisor that is less than p
          for (var i = 9; i > -1; i--) {
            if (i == 0) {
              result.insert(0, Digit.zero);
              break;
            }

            final prod = decimalDivisor * i;
            if (prod <= p) {
              result.insert(0, Digit.list[i]);

              // Remainder is temp
              temp = List<Digit>.from((p - prod)._digits);

              break;
            }
          }
        } else {
          result.insert(0, Digit.zero);
        }
      }
      digitCursor--;
    }

    return Precision.raw(result,
        power: power + shift,
        neg: negResult,
        sigDigits: max(_precision, decimalDivisor.precision));
  }

  /// Truncating division operator.
  @override
  Number operator ~/(dynamic divisor) => (this / divisor).truncate();

  /// Modulo operator.
  @override
  Number operator %(dynamic divisor) => remainder(divisor).abs();

  /// Equals operator.
  @override
  // ignore: non_nullable_equals_parameter
  bool operator ==(dynamic other) {
    if (other is double && (other.isNaN || other.isInfinite)) return false;
    final p2 = toDecimal(other);
    if (_neg != p2._neg) return false;
    final placeExtents = determinePlaceExtents(this, p2);
    for (var place = placeExtents[0]; place <= placeExtents[1]; place++) {
      if (digitAtPlace(place) != p2.digitAtPlace(place)) return false;
    }
    return true;
  }

  /// If an integer value, returns the same hash as an [int] with the same value.
  /// If not an integer value, uses the hashing utility from the quiver package to
  /// create a high quality hash based on the digits, sign and power.
  @override
  int get hashCode {
    if (isInteger) return toInt().hashCode;
    return hashObjects(List<Object>.from(_digits)
      ..add(_neg)
      ..add(_power));
  }

  /// Less than operator.
  @override
  bool operator <(dynamic other) {
    final p2 = toDecimal(other);
    if (_neg && !p2._neg) return true;
    if (!_neg && p2._neg) return false;
    final result = !_neg || !p2._neg;
    final placeExtents = determinePlaceExtents(this, p2);
    for (var place = placeExtents[1]; place >= placeExtents[0]; place--) {
      final d1 = digitAtPlace(place);
      final d2 = p2.digitAtPlace(place);
      if (d1 < d2) return result;
      if (d1 > d2) return !result;
    }
    return false;
  }

  /// Less than or equals operator.
  @override
  bool operator <=(dynamic other) => !(this > other);

  /// Greater than operator.
  @override
  bool operator >(dynamic other) {
    var p2 = toDecimal(other);
    if (_neg && !p2._neg) return false;
    if (!_neg && p2._neg) return true;
    final result = !_neg || !p2._neg;
    final placeExtents = determinePlaceExtents(this, p2);
    for (var place = placeExtents[1]; place >= placeExtents[0]; place--) {
      final d1 = digitAtPlace(place);
      final d2 = p2.digitAtPlace(place);
      if (d1 > d2) return result;
      if (d1 < d2) return !result;
    }
    return false;
  }

  /// Power operator.
  @override
  Number operator ^(dynamic exponent) {
    if (toDouble() == 0) {
      if (exponent == 0) return Double.NaN;
      return Precision.zero;
    }
    if (exponent == null || exponent == 0) return Integer.one;
    if (exponent == 1) return this;
    if (exponent is int || (exponent is Number && exponent.isInteger)) {
      final exp = exponent is int ? exponent : (exponent as Number).toInt();
      if (exp > 0) {
        var p = this;
        for (var i = 1; i < exp; i++) {
          p = p * this;
        }
        return p;
      } else {
        final recip = reciprocal();
        if (recip is! Precision) return recip;
        var p = recip as Precision;
        for (var i = -1; i > exp; i--) {
          final n = p / this;
          p = n as Precision;
        }
        return p;
      }
    } else {
      throw NumberException(
          'Precision power of an arbitrary precision number not supported');
    }
  }

  /// Converts a num, Number or String into a Precision object.
  Precision toDecimal(dynamic obj) {
    if (obj is Precision) return obj;
    if (obj is num) return Precision(obj);
    if (obj is Number) return Precision(obj.toDouble());
    return Precision('$obj');
  }

  /// Greater than or equals operator.
  @override
  bool operator >=(dynamic other) => !(this < other);

  /// Support [dart:json] stringify.
  ///
  /// Map Contents:
  ///     'decimal' : string representation of the number
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{'decimal': toString()};

  @override
  String toString() {
    final buf = StringBuffer();
    if (_neg) buf.write('-');
    _digits.reversed.forEach(buf.write);

    if (_power > 0) {
      //if (_power > 3) {
      //  buf.write('e${_power}');
      //} else {
      // Add zeroes
      for (var i = 0; i <= _power; i++) {
        buf.write('0');
      }
      // }
    } else if (_power < 0) {
      if (_power.abs() < _digits.length) {
        // Insert decimal point
        final str = buf.toString();
        buf.clear();
        var splitIndex = _digits.length + _power;
        if (_neg) splitIndex++;
        buf
          ..write(str.substring(0, splitIndex))
          ..write('.')
          ..write(str.substring(splitIndex));
      } else {
        buf.write('e$_power');
      }
    }

    return buf.toString();
  }

  @override
  Precision abs() {
    if (_neg) {
      return Precision.raw(digits,
          power: _power, neg: false, sigDigits: _precision);
    }
    return this;
  }

  @override
  Precision ceil() {
    if (isInteger) return this;
    final truncated = truncate();
    return truncated.isNegative ? truncated : truncated + Precision.one;
  }

  @override
  Precision clamp(dynamic lowerLimit, dynamic upperLimit) {
    if (this < lowerLimit) return toDecimal(lowerLimit);
    if (this > upperLimit) return toDecimal(upperLimit);
    return this;
  }

  @override
  Precision floor() {
    if (isInteger) return this;
    final truncated = truncate();
    return truncated.isNegative ? truncated - Precision.one : truncated;
  }

  @override
  Number reciprocal() => Precision.one / this;

  @override
  Precision remainder(dynamic divisor) => this - ((this ~/ divisor) * divisor);

  /// Returns the Precision integer value closest to this Precision value.
  /// Rounds away from zero when there is no closest integer:
  /// (3.5).round() == 4 and (-3.5).round() == -4.
  @override
  Precision round() {
    if (isInteger) return this;
    final absPower = power.abs();
    final tenths = _digits[absPower - 1];
    if (tenths.toInt() > 4) {
      // Round away from 0
      if (isNegative) {
        return Precision.raw(digits.sublist(absPower), power: 0, neg: true) -
            toDecimal(1);
      }
      return Precision.raw(digits.sublist(absPower),
              power: 0, neg: false, sigDigits: _precision) +
          toDecimal(1);
    } else {
      // Round toward 0
      return Precision.raw(digits.sublist(absPower),
          power: 0, neg: _neg, sigDigits: _precision);
    }
  }

  @override
  Precision pow(num exponent) {
    if (this == Precision.zero) {
      if (Precision(exponent) == Precision.zero) {
        throw ArgumentError('0^0 is undefined');
      }
      return Precision.zero;
    }

    if (Precision(exponent) == Precision.zero) {
      return Precision.one;
    } else if (Precision(exponent).isInteger) {
      var exp = exponent.toInt();
      Precision result = Precision.one;
      Precision factor = this;

      while (exp > 0) {
        if (exp % 2 == 1) {
          result *= factor;
        }
        factor *= factor;
        exp ~/= 2;
      }

      return result;
    } else {
      return (Precision(exponent) * ln()).exp();
    }
  }

  @override
  Precision exp() {
    int i = 0;
    Precision lasts = Precision.zero;
    Precision s = Precision.one;
    Precision fact = Precision.one;
    Precision num = Precision.one;

    while ((s - lasts).abs() > Precision('1e-$precision')) {
      lasts = s;
      i += 1;
      fact *= Precision(i);
      num *= this;
      s += (num / fact);
    }

    return s;
  }

  Precision ln() {
    if (this <= Precision.zero) {
      throw ArgumentError('ln(x) is undefined for x <= 0');
    }

    Precision sum = Precision.zero;
    Precision term = (this - Precision.one) / (this + Precision.one);
    Precision termSquared = term * term;
    Precision currentTerm = term;

    for (int n = 1; n <= precision; n += 2) {
      sum += currentTerm / Precision(n);
      currentTerm *= termSquared;
    }

    return Precision(2) * sum;
  }

  @override
  Precision sqrt() {
    if (this < 0) {
      throw ArgumentError("Negative value provided: $this");
    }
    if (this == Precision.zero) return Precision.zero;
    if (this == Precision.one) return Precision.one;

    if (this < Precision.zero) {
      throw ArgumentError("Cannot compute square root of a negative number");
    }

    return pow(0.5);
  }

  Precision cos() {
    int i = 0;
    Precision lasts = Precision.zero;
    Precision s = Precision.one;
    Precision fact = Precision.one;
    Precision num = Precision.one;
    Precision sign = Precision.one;

    while (s != lasts) {
      lasts = s;
      i += 2;
      fact *= Precision(i) * Precision(i - 1);
      num *= this * this;
      sign *= Precision(-1);
      s += (num / fact) * sign;
    }

    return s;
  }

  Precision sin() {
    int i = 1;
    Precision lasts = Precision.zero;
    Precision s = this;
    Precision fact = Precision.one;
    Precision num = this;
    Precision sign = Precision.one;

    while (s != lasts) {
      lasts = s;
      i += 2;
      fact *= Precision(i) * Precision(i - 1);
      num *= this * this;
      sign *= Precision(-1);
      s += (num / fact) * sign;
    }

    return s;
  }

  Precision tan() {
    return (sin() / cos());
  }

  @override
  Precision truncate() {
    if (_power >= 0) return Precision(int.parse(toString()));
    if (_power.abs() >= _digits.length) return Precision.zero;
    final newDigits = digits.sublist(_power.abs());
    if (newDigits.last == Digit.zero) return Precision.zero;
    return Precision.raw(newDigits, neg: _neg, power: 0, sigDigits: _precision);
  }

  /// Returns the minimum and maximum place extents for the combination of
  /// two Precision objects, [p1] and [p2].
  static List<int> determinePlaceExtents(Precision p1, Precision p2) => <int>[
        min(p1._power, p2._power),
        max(p1._power + p1._digits.length - 1,
            p2._power + p2._digits.length - 1)
      ];

  /// Remove any most-significant zeros more than one place away from the decimal point.
  void _trimLeadingZeros() {
    while (_digits.length > 1 &&
        _digits.last == Digit.zero &&
        _digits.length > (1 - _power)) {
      _digits.removeLast();
    }
  }

  /// Converts the decimal number to a string representation with a specified number of decimal places.
  ///
  /// If [precision] is not provided, the decimal number is converted to a string representation without any rounding.
  ///
  /// If [precision] is 0, the decimal number is truncated to an integer and converted to a string.
  ///
  /// If [precision] is negative, an [ArgumentError] is thrown.
  ///
  /// If the decimal number has fewer decimal places than the specified [precision], the string representation is padded with zeros on the right.
  /// If the decimal number has more decimal places than the specified [precision], the string representation is truncated to the specified [precision].
  String toStringAsFixed(int precision) {
    if (precision < 0) {
      throw ArgumentError('The precision must be positive');
    }

    // Convert the Precision to a string representation
    String str = toString();
    int dotIndex = str.indexOf('.');

    // No decimal point found
    if (dotIndex == -1) {
      return str.padRight(str.length + precision + 1, '0');
    }

    // Separate the integral and fractional parts
    String integralPart = str.substring(0, dotIndex);
    String fractionalPart = str.substring(dotIndex + 1);

    // Handle rounding if necessary
    if (fractionalPart.length > precision) {
      // Check if the value after the precision is greater or equal to 5, if so round up
      int roundDigit = int.parse(fractionalPart[precision]);
      fractionalPart = fractionalPart.substring(0, precision);

      if (roundDigit >= 5) {
        // Round up the fractional part
        Precision rounding =
            Precision('${this < 0 ? '-' : ''}0.${'0' * (precision - 1)}1');
        Precision roundedValue =
            Precision('$integralPart.$fractionalPart') + rounding;
        str = roundedValue.toString();
        dotIndex = str.indexOf('.');
        integralPart = str.substring(0, dotIndex);
        fractionalPart = str.substring(dotIndex + 1).padRight(precision, '0');
        return '$integralPart.$fractionalPart';
      }
    } else {
      fractionalPart = fractionalPart.padRight(precision, '0');
    }

    return '$integralPart.$fractionalPart';
  }
}

/// Represents a digit in four bits of a single byte.
/// This wastes four bits but that's a decent trade-off for simplicity and better
/// anyway than the 4+ bytes allocated for a regular int.
class Digit {
  /// Constructs a digit that matches the value of [num].
  Digit(int num) {
    //if (num == null) throw Exception('Digit cannot be constructed with null');
    if (num > 9 || num < 0) {
      throw Exception('Digit must be between 0 and 9, inclusive ($num)');
    }
    value.setUint8(0, num);
  }

  /// Constructs a digit from the character representing the digit.
  factory Digit.char(String digitChar) {
    //if (digitChar == null) throw Exception('Digit cannot be constructed with null character');
    if (digitChar.length != 1) {
      throw Exception('Digit must be constructed with a single character');
    }
    return Digit(digitChar.codeUnitAt(0) - codeUnit0);
  }

  /// The digit 0.
  static final Digit zero = Digit(0);

  /// The digit 1.
  static final Digit one = Digit(1);

  /// The digit 2.
  static final Digit two = Digit(2);

  /// The digit 3.
  static final Digit three = Digit(3);

  /// The digit 4.
  static final Digit four = Digit(4);

  /// The digit 5.
  static final Digit five = Digit(5);

  /// The digit 6.
  static final Digit six = Digit(6);

  /// The digit 7.
  static final Digit seven = Digit(7);

  /// The digit 8.
  static final Digit eight = Digit(8);

  /// The digit 9.
  static final Digit nine = Digit(9);

  /// A list of all the digits, ordered 0 through 9.
  static final List<Digit> list = List<Digit>.unmodifiable(
      <Digit>[zero, one, two, three, four, five, six, seven, eight, nine]);

  /// The  UTF-16 code unit of '0'.
  static final int codeUnit0 = '0'.codeUnitAt(0);

  /// Holds the value of the digit in a single byte.
  final ByteData value = ByteData(1);

  @override
  // ignore: non_nullable_equals_parameter
  bool operator ==(dynamic other) {
    if (other is Digit) return value.getUint8(0) == other.value.getUint8(0);
    if (other is num) return value.getUint8(0) == other;
    if (other is Number) return other.toDouble() == value.getUint8(0);
    return false;
  }

  @override
  int get hashCode => value.getUint8(0);

  /// Adds two digits together, returning the result as an [int].
  int operator +(Digit addend) => toInt() + (addend.toInt());

  /// Subtracts [subtrahend] from this digit, returning the result as an `int`.
  /// The result may be negative.
  int operator -(Digit subtrahend) => toInt() - subtrahend.toInt();

  /// Tests whether this digit is less than [other].
  bool operator <(Digit other) => toInt() < (other.toInt());

  /// Tests whether this digit is greater than [other].
  bool operator >(Digit other) => toInt() > (other.toInt());

  /// Returns the integer equivalent of this digit.
  int toInt() => value.getUint8(0);

  @override
  String toString() => '${toInt()}';
}
