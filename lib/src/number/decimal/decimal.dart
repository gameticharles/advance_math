part of 'rational.dart';

class Decimal implements Comparable<Decimal> {
  final Rational _rational;

  /// Constructs a [Decimal] from a [dynamic] value.
  ///
  /// The [value] parameter can be of type [num], [BigInt], [int], [String], or [Rational].
  /// If the [value] is a [num], it must be a valid finite number. If the [value] is a [String],
  /// it must not be empty.
  ///
  /// The [sigDigits] parameter is an optional integer that specifies the number of significant
  /// digits to use when constructing the [Decimal]. If not provided, the global precision
  /// set by [Decimal.setPrecision] will be used.
  ///
  /// Throws an [Exception] if the [value] is of an invalid type or does not meet the
  /// requirements for a valid [Decimal] value.
  Decimal(dynamic value, {int? sigDigits}) : _rational = _parseValue(value) {
    setPrecision(sigDigits ?? decimalPrecision);

    if (value is num) {
      if (value.isNaN || value.isInfinite) {
        throw Exception('Decimal value must be a valid finite number');
      }
    } else if (value is String) {
      final str = value.toLowerCase().trim();
      if (str.isEmpty) {
        throw Exception('String value cannot be empty');
      }
    } else if (!(value is BigInt || value is Rational || value is Decimal)) {
      throw Exception('Invalid type for decimal value');
    }
  }

  static Rational _parseValue(dynamic value) {
    if (value is Decimal) {
      return value._rational;
    } else if (value is Rational) {
      return value;
    } else if (value is BigInt) {
      return Rational(value, BigInt.one);
    } else if (value is int) {
      return Rational.fromInt(value);
    } else if (value is double) {
      // // Handle double directly to avoid circular dependency
      // if (value.isNaN) return Rational.nan;
      // if (value.isInfinite) {
      //   return value.isNegative ? Rational.negativeInfinity : Rational.infinity;
      // }

      // Convert double to string and parse
      return Rational.parse(value.toString());
    } else if (value is String) {
      return Rational.parse(value);
    } else {
      throw Exception('Invalid type for decimal value');
    }
  }

  /// Sets the global precision for Decimal operations.
  ///
  /// The [precision] parameter must be an integer greater than or equal to 1.
  /// If a value less than 1 is provided, an [ArgumentError] will be thrown.
  /// The [decimalPrecision] global variable will be set to the provided [precision] value.
  static void setPrecision(int precision) {
    if (precision < 1) {
      throw ArgumentError("Precision must be at least 1");
    }
    decimalPrecision = precision;
  }

  // /// Internal constructor that creates a Decimal directly from a Rational
  // /// without additional validation to avoid infinite recursion
  // Decimal._fromRational(Rational rational, {int? precision})
  //     : _rational = rational {
  //   setPrecision(precision ?? decimalPrecision);
  // }

  /// Creates a new [Decimal] instance from the provided [BigInt] value.
  ///
  /// This factory method converts the [BigInt] value to a [Rational] and then
  /// to a [Decimal] instance.
  factory Decimal.fromBigInt(BigInt value) => value.toRational().toDecimal();

  /// Creates a new [Decimal] instance from the provided [int] value.
  ///
  /// This factory method converts the [int] value to a [BigInt] and then
  /// creates a [Decimal] instance from the [BigInt] using the [Decimal.fromBigInt]
  /// factory method.
  factory Decimal.fromInt(int value) => Decimal.fromBigInt(BigInt.from(value));

  /// Creates a new [Decimal] instance from the provided [String] source.
  ///
  /// This factory method parses the [String] source using [Rational.parse] and
  /// then converts the resulting [Rational] to a [Decimal] instance.
  factory Decimal.parse(String source) => Rational.parse(source).toDecimal();

  /// Creates a new [Decimal] instance from the provided JSON [String] value.
  ///
  /// This factory method parses the JSON [String] value using [Decimal.parse] and
  /// returns the resulting [Decimal] instance.
  factory Decimal.fromJson(String value) => Decimal.parse(value);

  /// Zero as a Decimal number.
  static final Decimal zero = Decimal(0);

  /// One as a Decimal number.
  static final Decimal one = Decimal(1);

  /// Ten as a Decimal.
  static final Decimal ten = Decimal(10);

  /// One hundred as a Decimal.
  static final Decimal hundred = Decimal(100);

  /// One thousand as a Decimal.
  static final Decimal thousand = Decimal(1000);

  /// Infinity as a Decimal.
  static final Decimal infinity = Decimal(double.infinity);

  /// Negative infinity as a Decimal.
  static final Decimal negInfinity = Decimal(double.negativeInfinity);

  /// Not a number as a Double.
  // ignore: constant_identifier_names
  static final Decimal nan = Decimal(double.nan);

  /// Returns the underlying [Rational] representation of this [Decimal] instance.
  Rational toRational() => _rational;

  /// Returns `true` if this [Decimal] represents an integer value, `false` otherwise.
  bool get isInteger => _rational.isInteger;

  /// Returns the inverse of the underlying [Rational] representation of this [Decimal] instance.
  Rational get inverse => _rational.inverse;

  /// Returns the precision of this [Decimal] instance, which is the total number of
  /// digits in the number, including both the integer and fractional parts.
  int get precision {
    final value = abs();
    return value.scale + value.toBigInt().toString().length;
  }

  /// Returns the scale of this [Decimal] instance, which is the number of digits
  /// to the right of the decimal point.
  int get scale {
    var i = 0;
    var x = _rational;
    while (!x.isInteger) {
      i++;
      x *= _r10;
    }
    return i;
  }

  @override
  bool operator ==(Object other) =>
      other is Decimal && _rational == other._rational;

  @override
  int get hashCode => _rational.hashCode;

  @override
  String toString() {
    if (_rational.isInteger) return _rational.toString();
    var value = toStringAsFixed(scale);
    while (
        value.contains('.') && (value.endsWith('0') || value.endsWith('.'))) {
      value = value.substring(0, value.length - 1);
    }
    return value;
  }

  /// Returns the string representation of this [Decimal] instance, which can be used for JSON serialization.
  String toJson() => toString();

  @override
  int compareTo(Decimal other) => _rational.compareTo(other._rational);

  Decimal operator +(Decimal other) => Decimal(_rational + other._rational);
  Decimal operator -(Decimal other) => Decimal(_rational - other._rational);
  Decimal operator *(Decimal other) => Decimal(_rational * other._rational);
  Decimal operator %(Decimal other) => Decimal(_rational % other._rational);
  Rational operator /(Decimal other) => _rational / other._rational;

  BigInt operator ~/(Decimal other) => _rational ~/ other._rational;

  Decimal operator -() => (-_rational).toDecimal();

  /// Returns the remainder of dividing this [Decimal] by the provided [other] [Decimal].
  ///
  /// The remainder is calculated using the underlying [Rational] representation of the [Decimal] values.
  Decimal remainder(Decimal other) =>
      (_rational.remainder(other._rational)).toDecimal();

  bool operator <(Decimal other) => _rational < other._rational;
  bool operator <=(Decimal other) => _rational <= other._rational;
  bool operator >(Decimal other) => _rational > other._rational;
  bool operator >=(Decimal other) => _rational >= other._rational;

  /// Returns the absolute value of this [Decimal] instance.
  ///
  /// The absolute value is calculated by taking the absolute value of the underlying [Rational] representation
  /// and converting it back to a [Decimal].
  Decimal abs() => _rational.abs().toDecimal();

  /// Returns the sign of the underlying [Rational] representation of this [Decimal] instance.
  ///
  /// The sign is an integer value that indicates the sign of the [Decimal] value:
  /// - 0 if the [Decimal] is zero
  /// - -1 if the [Decimal] is negative
  /// - 1 if the [Decimal] is positive
  int get sigNum => _rational.sign;

  /// Returns true if this [Decimal] can be exactly represented as an [int].
  bool get isExactInt => isInteger && _rational.numerator.bitLength <= 63;

  /// Returns true if this [Decimal] can be exactly represented as a [double].
  bool get isExactDouble {
    if (isInteger) {
      // Integers up to 2^53 can be exactly represented as double
      return _rational.numerator.abs() <= BigInt.from(9007199254740992); // 2^53
    }

    // Check if denominator is a power of 2 (can be exactly represented in binary)
    var den = _rational.denominator;
    while (den > BigInt.one && den.isEven) {
      den = den >> 1;
    }

    return den == BigInt.one &&
        _rational.numerator.abs() <= BigInt.from(9007199254740992); // 2^53
  }

  /// Optimized method to check if this Decimal is a power of 10
  bool isPowerOfTen() {
    if (!isInteger || this <= Decimal.zero) return false;

    final str = toBigInt().toString();
    return str[0] == '1' && str.substring(1).split('').every((c) => c == '0');
  }

  /// Returns a new [Decimal] instance with the current value rounded down to the specified [scale].
  ///
  /// The [scale] parameter specifies the number of decimal places to round to. If [scale] is 0, the
  /// value is rounded down to the nearest integer.
  Decimal floor({int scale = 0}) => _scaleAndApply(scale, (e) => e.floor());

  /// Returns a new [Decimal] instance with the current value rounded up to the specified [scale].
  ///
  /// The [scale] parameter specifies the number of decimal places to round to. If [scale] is 0, the
  /// value is rounded up to the nearest integer.
  Decimal ceil({int scale = 0}) => _scaleAndApply(scale, (e) => e.ceil());

  /// Returns a new [Decimal] instance with the current value rounded to the specified [scale].
  ///
  /// The [scale] parameter specifies the number of decimal places to round to. If [scale] is 0, the
  /// value is rounded to the nearest integer.
  Decimal round({int scale = 0}) => _scaleAndApply(scale, (e) => e.round());

  /// Returns the current [Decimal] value as a [BigInt].
  ///
  /// The underlying [Rational] representation of the [Decimal] is converted to a [BigInt].
  BigInt toBigInt() => _rational.toBigInt();

  /// Returns the current [Decimal] value as a [double].
  ///
  /// The underlying [Rational] representation of the [Decimal] is converted to a [double].
  double toDouble() => _rational.toDouble();

  /// Returns the reciprocal of the current [Decimal] value.
  ///
  /// The reciprocal is calculated using the underlying [Rational] representation of the [Decimal] value.
  Rational reciprocal() => inverse;

  /// Truncates precision of internal rational to avoid explosion during infinite series
  Decimal _limitPrecision([int? extraGuardDigits]) {
    return _rational.toDecimal(
        precision: decimalPrecision + (extraGuardDigits ?? 5));
  }

  /// Calculates the square root of the current [Decimal] value.
  ///
  /// If the current [Decimal] value is negative, an [ArgumentError] is thrown as the square root
  /// of a negative number is undefined.
  ///
  /// If the current [Decimal] value is zero or one, the method returns zero or one respectively.
  ///
  /// The square root is calculated by Newton-Raphson method for square root calculation,
  /// which converges quadratically and is ideal for high precision.
  ///
  /// Returns the square root of the current [Decimal] value.
  Decimal sqrt() {
    if (this < Decimal.zero) {
      throw ArgumentError('Square root of a negative number is not defined.');
    }
    if (this == Decimal.zero || this == Decimal.one) {
      return this;
    }

    Rational guess = this / Decimal.fromInt(2); // Initial guess: N / 2
    Rational prevGuess = Rational.zero;
    final tolerance = Rational.parse('1e-$decimalPrecision');

    while ((guess - prevGuess).abs() > tolerance) {
      prevGuess = guess;
      guess =
          Decimal(guess + (_rational / guess), sigDigits: decimalPrecision) /
              Decimal.fromInt(2);
    }

    return guess.toDecimal(precision: decimalPrecision);
  }

  /// Calculates the exponential function (e^x) of the current [Decimal] value.
  ///
  /// The exponential function is calculated using a series expansion, summing up the terms up to the
  /// precision specified by the [decimalPrecision] field.
  ///
  /// Returns the exponential function of the current [Decimal] value.
  Decimal exp() {
    // if (_rational.isNegativeInfinity) return Decimal.zero;
    // if (_rational.isInfinite) return Decimal.infinity;
    // if (_rational.isNaN) return Decimal.nan;
    final x = this;

    // Inner function to compute a range using binary splitting
    Decimal expRange(int a, int b) {
      if (a == b) {
        // Base case: Compute single term
        Decimal fact = Decimal.one;
        for (int i = 1; i <= a; i++) {
          fact *= Decimal.fromInt(i);
        }
        return (x.pow(a) / fact).toDecimal(precision: decimalPrecision);
      }

      // Recursive case: Split range
      int m = (a + b) ~/ 2;
      return expRange(a, m) + expRange(m + 1, b);
    }

    // Determine the number of terms to calculate
    int terms = (decimalPrecision * 2.302585) ~/
            (x.abs() + Decimal.one).ln().toDouble() +
        10;

    // Use binary splitting to compute the series sum
    return expRange(0, terms);
  }

  /// Calculates the natural logarithm (ln) of the current [Decimal] value.
  ///
  /// If the current [Decimal] value is less than or equal to zero, an [ArgumentError] is thrown
  /// as the natural logarithm is undefined for non-positive values.
  ///
  /// The natural logarithm is calculated using a series expansion, summing up the terms up to the
  /// precision specified by the [decimalPrecision] field.
  ///
  /// Returns the natural logarithm of the current [Decimal] value.
  /// Calculates the natural logarithm (ln) of the current [Decimal] value.
  Decimal ln() {
    if (this <= zero) {
      throw ArgumentError('ln(x) is undefined for x <= 0');
    }
    if (this == one) return zero;

    // 1. Get ln(2)
    // For standard precision, use a constant to speed things up significantly.
    // If user requested very high precision (>30), calculate it dynamically.
    Decimal ln2;
    if (decimalPrecision <= 30) {
      ln2 = Decimal.parse("0.69314718055994530941723212145817656807550013436026"
          .substring(0, decimalPrecision + 2));
    } else {
      // Use the _lnRaw helper from the previous solution
      ln2 = Decimal.parse("2")._lnRaw();
    }

    // 2. Range Reduction: x = m * 2^k
    // We reduce 'x' to the range [1, 2) by dividing/multiplying by 2
    // This makes the series converge much faster.
    Rational xRat = _rational;
    int k = 0;

    // Fast reduction using Rational math
    while (xRat >= Rational.fromInt(2)) {
      xRat /= Rational.fromInt(2);
      k++;
    }
    while (xRat < Rational.one) {
      xRat *= Rational.fromInt(2);
      k--;
    }

    // 3. Series Expansion: ln(x) = ln((1+y)/(1-y)) where y = (x-1)/(x+1)
    // This series converges faster than standard Taylor series.
    // xRat is now in [1, 2), so y will be small.
    Decimal xNormalized = Decimal(xRat);
    Decimal y = ((xNormalized - one) / (xNormalized + one))
        .toDecimal(precision: decimalPrecision + 2);
    Decimal y2 = (y * y)._limitPrecision(); // Rounding prevents explosion

    Decimal sum = zero;
    Decimal term = y; // First term (numerator part)
    Decimal num = y; // Keeps track of y^1, y^3, y^5...
    int n = 1;

    // Limit based on precision
    final limit =
        Rational(BigInt.one, BigInt.from(10).pow(decimalPrecision + 2));

    while (term.abs().toRational() > limit) {
      // term = num / n
      term =
          (num / Decimal.fromInt(n)).toDecimal(precision: decimalPrecision + 2);
      sum += term;

      // Prepare next numerator: num * y^2
      // CRITICAL: We limit precision here. If we don't, Rational size explodes.
      num = (num * y2)._limitPrecision(0);
      n += 2;

      // Safety break
      if (n > decimalPrecision * 100) break;
    }

    // Result = 2 * sum + k * ln(2)
    Decimal result = (sum * Decimal.fromInt(2)) + (Decimal.fromInt(k) * ln2);

    return result._limitPrecision(0);
  }

  // Raw LN computation without range reduction
  // Uses the series: ln(x) = 2 * (y + y^3/3 + y^5/5 + ...) where y = (x-1)/(x+1)
  Decimal _lnRaw() {
    if (this <= zero) throw ArgumentError('ln(x) undefined for x <= 0');
    if (this == one) return zero;

    // y = (x - 1) / (x + 1)
    Decimal y = ((this - one) / (this + one))
        .toDecimal(precision: decimalPrecision + 2);

    // We limit precision on y2 to prevent explosion in the loop
    Decimal y2 = (y * y)._limitPrecision();

    Decimal sum = zero;
    Decimal num = y; // Represents y^(odd)
    Decimal term = y; // Represents term to add
    int n = 1; // 1, 3, 5, 7...

    // Convergence limit: 10^(-precision - 2) for extra safety buffer
    final limit =
        Rational(BigInt.one, BigInt.from(10).pow(decimalPrecision + 2));

    while (term.abs().toRational() > limit) {
      // term = numerator / n
      term =
          (num / Decimal.fromInt(n)).toDecimal(precision: decimalPrecision + 2);
      sum += term;

      // Prepare for next iteration
      // num = num * y^2 (advances power by 2: y^1 -> y^3 -> y^5)
      // CRITICAL: Rounding here prevents the Rational denominator from exploding
      num = (num * y2)._limitPrecision();
      n += 2;

      // Safety break to prevent infinite loops on extremely high precision requests
      if (n > decimalPrecision * 100) break;
    }

    return (sum * Decimal.fromInt(2))._limitPrecision(0);
  }

  /// Calculates the power of the current [Decimal] value raised to the given exponent.
  ///
  /// If the current [Decimal] value is zero and the exponent is zero, an [ArgumentError] is thrown.
  /// If the current [Decimal] value is zero and the exponent is non-zero, the result is zero.
  /// If the exponent is zero, the result is one.
  /// If the exponent is an integer (either [Decimal] or [int]), the result is calculated using an efficient algorithm.
  /// If the exponent is a non-integer [Decimal], the result is calculated using the formula: `exp(exponent * ln(this))`.
  Decimal pow(dynamic exponent) {
    if (this == Decimal.zero) {
      if (exponent == Decimal.zero) {
        throw ArgumentError('0^0 is undefined');
      }
      return Decimal.zero;
    }

    if (exponent == Decimal.zero || (exponent is num && exponent == 0)) {
      return Decimal.one;
    }

    // Handle integer exponents efficiently
    if ((exponent is Decimal && exponent.isInteger) || exponent is int) {
      var exp = (exponent is Decimal && exponent.isInteger)
          ? exponent.toBigInt().toInt()
          : exponent;
      Rational result = Rational.one;
      Rational factor = _rational;

      while (exp > 0) {
        if (exp % 2 == 1) {
          result *= factor;
        }
        factor *= factor;
        exp ~/= 2;
      }

      return result.toDecimal(precision: decimalPrecision);
    } else {
      // 2. General Case: x^y = exp(y * ln(x))
      var expValue = exponent is Decimal ? exponent : Decimal(exponent);
      return (expValue * ln()).exp()._limitPrecision(0);
    }
  }

  /// Calculates the cosine of the current [Decimal] value.
  ///
  /// This method uses a series expansion to compute the cosine value.
  /// The series expansion is calculated up to the precision specified
  /// by the [decimalPrecision] field.
  ///
  /// Returns the cosine of the current [Decimal] value.
  Decimal cos() {
    // // Handle special cases
    // if (_rational.isNaN) return Decimal.nan;
    // if (_rational.isInfinite) return Decimal.nan;

    int i = 0;
    Decimal lasts = Decimal.zero;
    Decimal s = Decimal.one;
    Decimal fact = Decimal.one;
    Decimal num = Decimal.one;
    Decimal sign = Decimal.one;

    while (s != lasts) {
      lasts = s;
      i += 2;
      fact *= Decimal.fromInt(i) * Decimal.fromInt(i - 1);
      num *= this * this;
      sign *= Decimal.fromInt(-1);
      s += (num / fact).toDecimal(precision: decimalPrecision) * sign;
    }

    return s;
  }

  /// Calculates the sine of the current [Decimal] value.
  ///
  /// This method uses a series expansion to compute the sine value.
  /// The series expansion is calculated up to the precision specified
  /// by the [decimalPrecision] field.
  ///
  /// Returns the sine of the current [Decimal] value.
  Decimal sin() {
    // // Handle special cases
    // if (_rational.isNaN) return Decimal.nan;
    // if (_rational.isInfinite) return Decimal.nan;

    int i = 1;
    Decimal lasts = Decimal.zero;
    Decimal s = this;
    Decimal fact = Decimal.one;
    Decimal num = this;
    Decimal sign = Decimal.one;

    while (s != lasts) {
      lasts = s;
      i += 2;
      fact *= Decimal.fromInt(i) * Decimal.fromInt(i - 1);
      num *= this * this;
      sign *= Decimal.fromInt(-1);
      s += (num / fact).toDecimal(precision: decimalPrecision) * sign;
    }

    return s;
  }

  /// Calculates the tangent of the current [Decimal] value.
  ///
  /// This method computes the tangent by dividing the sine of the value
  /// by the cosine of the value. The result is returned as a [Decimal]
  /// with the precision specified by the [decimalPrecision] field.
  Decimal tan() {
    return (sin() / cos()).toDecimal(precision: decimalPrecision);
  }

  /// Calculates the arc sine (inverse sine) of the current [Decimal] value.
  ///
  /// The result is in radians and will be in the range `[-π/2, π/2]`.
  /// Throws an [ArgumentError] if the value is outside the range `[-1, 1]`.
  Decimal asin() {
    if (this < Decimal.fromInt(-1) || this > Decimal.fromInt(1)) {
      throw ArgumentError('asin(x) is only defined for x in the range [-1, 1]');
    }

    // Use the series expansion: asin(x) = x + (1/2)(x^3/3) + (1·3/2·4)(x^5/5) + ...
    if (abs() < (Rational.one / Rational.fromInt(2)).toDecimal()) {
      Rational result = toRational();
      Rational term = toRational();
      Rational x2 = _rational * _rational;

      for (int n = 1; n < decimalPrecision * 2; n++) {
        term =
            term * x2 * (Rational.fromInt(2 * n - 1) / Rational.fromInt(2 * n));
        Rational nextTerm = term / Decimal.fromInt(2 * n + 1).toRational();
        result += nextTerm;

        // Check for convergence
        if (nextTerm.abs() <
            Decimal.parse('1e-$decimalPrecision').toRational()) {
          break;
        }
      }

      return result.toDecimal(precision: decimalPrecision);
    } else {
      // For values close to 1 or -1, use the identity: asin(x) = π/2 - asin(sqrt(1-x²))
      Decimal pi2 = Decimal.parse("1.5707963267948966192313216916398");
      Decimal sign =
          this < Decimal.zero ? Decimal.fromInt(-1) : Decimal.fromInt(1);
      return sign * (pi2 - (Decimal.one - this * this).sqrt().asin());
    }
  }

  /// Calculates the arc cosine (inverse cosine) of the current [Decimal] value.
  ///
  /// The result is in radians and will be in the range `[0, π]`.
  /// Throws an [ArgumentError] if the value is outside the range `[-1, 1]`.
  Decimal acos() {
    if (this < Decimal.fromInt(-1) || this > Decimal.fromInt(1)) {
      throw ArgumentError('acos(x) is only defined for x in the range [-1, 1]');
    }

    // Use the identity: acos(x) = π/2 - asin(x)
    Decimal pi2 = Decimal.parse("1.5707963267948966192313216916398");
    return pi2 - asin();
  }

  /// Calculates the arc tangent (inverse tangent) of the current [Decimal] value.
  ///
  /// The result is in radians and will be in the range `[-π/2, π/2]`.
  Decimal atan() {
    // Use the series expansion for small values
    if (abs() < Decimal.one) {
      Rational result = toRational();
      Decimal term = this;
      Decimal x2 = this * this;

      for (int n = 1; n < decimalPrecision * 2; n++) {
        term = -term * x2;
        var nextTerm = term / Decimal.fromInt(2 * n + 1);
        result += nextTerm;

        // Check for convergence
        if (nextTerm.abs() <
            Decimal.parse('1e-$decimalPrecision').toRational()) {
          break;
        }
      }

      return result.toDecimal(precision: decimalPrecision);
    } else {
      // For larger values, use the identity: atan(x) = π/2 - atan(1/x) for x > 0
      // or atan(x) = -π/2 - atan(1/x) for x < 0
      Decimal pi2 = Decimal.parse("1.5707963267948966192313216916398");
      if (this > Decimal.zero) {
        return pi2 - (Decimal.one / this).toDecimal().atan();
      } else {
        return -pi2 - (Decimal.one / this).toDecimal()
          ..atan();
      }
    }
  }

  Decimal _scaleAndApply(int scale, BigInt Function(Rational) f) {
    final scaleFactor = ten.pow(scale.toDecimal()).toRational();
    return Decimal(f(_rational * scaleFactor).toRational() / scaleFactor);
  }

  /// Truncates the current [Decimal] value to the specified [scale].
  ///
  /// The [scale] parameter specifies the number of decimal places to keep.
  /// The value is truncated (not rounded) to the specified number of decimal places.
  /// For example, `Decimal(3.14159).truncate(scale: 2)` would return `Decimal(3.14)`.
  Decimal truncate({int scale = 0}) =>
      _scaleAndApply(scale, (e) => e.truncate());

  /// Shifts the current [Decimal] value by the specified [value].
  ///
  /// This method multiplies the current [Decimal] value by 10 raised to the power
  /// of the [value] parameter. This effectively shifts the decimal point of the
  /// [Decimal] value to the left or right, depending on whether the [value] is
  /// positive or negative.
  ///
  /// For example, `Decimal(12.34).shift(2)` would return `Decimal(1234.0)`, and
  /// `Decimal(12.34).shift(-2)` would return `Decimal(0.1234)`.
  Decimal shift(int value) => this * ten.pow(value.toDecimal());
  Decimal clamp(Decimal lowerLimit, Decimal upperLimit) =>
      _rational.clamp(lowerLimit._rational, upperLimit._rational).toDecimal();

  /// Converts the current [Decimal] value to a string representation with a fixed number of fraction digits.
  ///
  /// The [fractionDigits] parameter specifies the number of decimal places to include in the output string.
  /// If [fractionDigits] is 0, the output will be the integer part of the [Decimal] value.
  /// The value is rounded (not truncated) to the specified number of decimal places.
  /// For example, `Decimal(3.14159).toStringAsFixed(2)` would return `"3.14"`.
  String toStringAsFixed(int fractionDigits) {
    assert(fractionDigits >= 0);
    if (fractionDigits == 0) return round().toBigInt().toString();
    final value = round(scale: fractionDigits);
    final intPart = value.toBigInt().abs();
    final decimalPart =
        (one + value.abs() - intPart.toDecimal()).shift(fractionDigits);
    return '${value < zero ? '-' : ''}$intPart.${decimalPart.toString().substring(1)}';
  }

  /// Converts the current [Decimal] value to a string representation in exponential notation.
  ///
  /// The optional [fractionDigits] parameter specifies the number of decimal places to include in the
  /// mantissa of the exponential notation. If [fractionDigits] is 0, the mantissa will be rounded to
  /// an integer value.
  ///
  /// The exponential notation will be in the form `"[-]d.dddde[+|-]dd"`, where the mantissa is
  /// rounded to the specified number of decimal places.
  ///
  /// For example:
  /// - `Decimal(12.34).toStringAsExponential()` => `"1.234e+01"`
  /// - `Decimal(12.34).toStringAsExponential(1)` => `"1.2e+01"`
  /// - `Decimal(-12.34).toStringAsExponential(2)` => `"-1.23e+01"`
  String toStringAsExponential([int fractionDigits = 0]) {
    assert(fractionDigits >= 0);

    final negative = this < zero;
    var value = abs();
    var eValue = 0;
    while (value < one && value > zero) {
      value *= ten;
      eValue--;
    }
    while (value >= ten) {
      value = (value / ten).toDecimal();
      eValue++;
    }
    value = value.round(scale: fractionDigits);
    if (value == ten) {
      value = (value / ten).toDecimal();
      eValue++;
    }

    return <String>[
      if (negative) '-',
      value.toStringAsFixed(fractionDigits),
      'e',
      if (eValue >= 0) '+',
      '$eValue',
    ].join();
  }

  /// Converts the current [Decimal] value to a string representation with the specified precision.
  ///
  /// The [precision] parameter specifies the number of significant digits to include in the string
  /// representation. If the [Decimal] value is zero, the string will be padded with zeros to the
  /// specified precision.
  ///
  /// For example:
  /// - `Decimal(12.34).toStringAsPrecision(3)` => `"12.3"`
  /// - `Decimal(0.00012).toStringAsPrecision(2)` => `"0.00012"`
  /// - `Decimal(0).toStringAsPrecision(4)` => `"0.0000"`
  String toStringAsPrecision(int precision) {
    assert(precision > 0);

    if (this == zero) {
      return <String>[
        '0',
        if (precision > 1) '.',
        for (var i = 1; i < precision; i++) '0',
      ].join();
    }

    final limit = ten.pow(precision.toDecimal());
    var shift = one;
    final absValue = abs();
    var pad = 0;
    while (absValue * shift < limit) {
      pad++;
      shift *= ten;
    }
    while (absValue * shift >= limit) {
      pad--;
      shift = (shift / ten).toDecimal();
    }
    final value = ((this * shift).round() / shift).toDecimal();
    return pad <= 0 ? value.toString() : value.toStringAsFixed(pad);
  }
}

/// Extensions on [BigInt].
extension BigIntExt on BigInt {
  /// Converts the current [BigInt] to a [Decimal].
  ///
  /// This extension method provides a convenient way to create a [Decimal] instance from a [BigInt].
  Decimal toDecimal() => Decimal.fromBigInt(this);

  /// Converts the current [int] to a [Rational].
  ///
  /// This extension method provides a convenient way to create a [Rational] instance from an [int].
  Rational toRational() => Rational(this);
}

extension IntExt on int {
  Decimal toDecimal() => Decimal.fromInt(this);

  /// This [int] as a [Rational].
  Rational toRational() => Rational.fromInt(this);
}

extension RationalExt on Rational {
  /// Robust conversion to Decimal
  Decimal toDecimal({int? precision, BigInt Function(Rational)? toBigInt}) {
    // 1. Handle special values immediately
    if (isNaN) return Decimal.nan;
    if (isInfinite) {
      return isPositiveInfinity ? Decimal.infinity : Decimal.negInfinity;
    }

    // 2. Exact representation check
    // If the number terminates (e.g. 0.5), convert directly without approximation logic.
    if (hasFinitePrecision) {
      return Decimal(this);
    }

    // 3. Approximation Logic
    // We scale the number up, round it to an integer, and scale it back down.
    var prec = precision ?? decimalPrecision;

    // Calculate the scale factor (10^precision)
    // We use BigInt here directly for the denominator to avoid intermediate object creation
    final scaleFactorBigInt = BigInt.from(10).pow(prec);
    final scaleFactorRational = Rational(scaleFactorBigInt);

    // Default rounding strategy is standard rounding
    toBigInt ??= (value) => value.round();

    // Calculate numerator: (Rational * 10^p).round()
    final bigIntNumerator = toBigInt(this * scaleFactorRational);

    // 4. Construct the result
    // Instead of doing Decimal / Decimal (which returns Rational),
    // we construct the final Rational (numerator/denominator) and wrap it in Decimal.
    return Decimal(Rational(bigIntNumerator, scaleFactorBigInt));
  }
}

//   /// Calculates the arc sine (inverse sine) of the current [Decimal] value.
//   ///
//   /// The result is in radians and will be in the range `[-π/2, π/2]`.
//   /// Throws an [ArgumentError] if the value is outside the range `[-1, 1]`.
//   Decimal asin() {
//     if (this < Decimal.fromInt(-1) || this > Decimal.fromInt(1)) {
//       throw ArgumentError('asin(x) is only defined for x in the range [-1, 1]');
//     }

//     // Use the series expansion: asin(x) = x + (1/2)(x^3/3) + (1·3/2·4)(x^5/5) + ...
//     if (abs() < (Rational.one / Rational.fromInt(2)).toDecimal()) {
//       Rational result = toRational();
//       Rational term = toRational();
//       Rational x2 = toRational() * toDecimal();

//       for (int n = 1; n < decimalPrecision * 2; n++) {
//         term = term * x2 * (Rational.fromInt(2 * n - 1) / Rational.fromInt(2 * n));
//         Rational nextTerm = term / Decimal.fromInt(2 * n + 1).toRational();
//         result += nextTerm;

//         // Check for convergence
//         if (nextTerm.abs() < Decimal.parse('1e-$decimalPrecision').toRational()) {
//           break;
//         }
//       }

//       return result.toDecimal(precision: decimalPrecision);
//     } else {
//       // For values close to 1 or -1, use the identity: asin(x) = π/2 - asin(sqrt(1-x²))
//       Decimal pi2 = Decimal.parse("1.5707963267948966192313216916398");
//       Decimal sign = this < Decimal.zero ? Decimal.fromInt(-1) : Decimal.fromInt(1);
//       return sign * (pi2 - (Decimal.one - this * this).sqrt().asin());
//     }
//   }

//   /// Calculates the arc cosine (inverse cosine) of the current [Decimal] value.
//   ///
//   /// The result is in radians and will be in the range `[0, π]`.
//   /// Throws an [ArgumentError] if the value is outside the range `[-1, 1]`.
//   Decimal acos() {
//     if (this < Decimal.fromInt(-1) || this > Decimal.fromInt(1)) {
//       throw ArgumentError('acos(x) is only defined for x in the range [-1, 1]');
//     }

//     // Use the identity: acos(x) = π/2 - asin(x)
//     Decimal pi2 = Decimal.parse("1.5707963267948966192313216916398");
//     return pi2 - asin();
//   }

//   /// Calculates the arc tangent (inverse tangent) of the current [Decimal] value.
//   ///
//   /// The result is in radians and will be in the range [-π/2, π/2].
//   Decimal atan() {
//     // Use the series expansion for small values
//     if (abs() < Decimal.one) {
//       Rational result = toRational();
//       Decimal term = this;
//       Decimal x2 = this * this;

//       for (int n = 1; n < decimalPrecision * 2; n++) {
//         term = -term * x2;
//         var nextTerm = term / Decimal.fromInt(2 * n + 1);
//         result += nextTerm;

//         // Check for convergence
//         if (nextTerm.abs() < Decimal.parse('1e-$decimalPrecision').toRational()) {
//           break;
//         }
//       }

//       return result.toDecimal(precision: decimalPrecision);
//     } else {
//       // For larger values, use the identity: atan(x) = π/2 - atan(1/x) for x > 0
//       // or atan(x) = -π/2 - atan(1/x) for x < 0
//       Decimal pi2 = Decimal.parse("1.5707963267948966192313216916398");
//       if (this > Decimal.zero) {
//         return pi2 - (Decimal.one / this).toDecimal().atan();
//       } else {
//         return -pi2 - (Decimal.one / this).toDecimal()..atan();
//       }
//     }
//   }

//   /// Converts the current [Decimal] value to a string representation with a fixed number of fraction digits.
//   ///
//   /// The [fractionDigits] parameter specifies the number of decimal places to include in the output string.
//   /// If [fractionDigits] is 0, the output will be the integer part of the [Decimal] value.
//   /// The value is rounded (not truncated) to the specified number of decimal places.
//   /// For example, `Decimal(3.14159).toStringAsFixed(2)` would return `"3.14"`.
//   String toStringAsFixed(int fractionDigits) {
//     assert(fractionDigits >= 0);
//     if (fractionDigits == 0) return roundToScale().toBigInt().toString();
//     final value = roundToScale(scale: fractionDigits);
//     final intPart = value.toBigInt().abs();
//     final decimalPart =
//         (one + value.abs() - intPart.toDecimal()).shift(fractionDigits);
//     return '${value < zero ? '-' : ''}$intPart.${decimalPart.toString().substring(1)}';
//   }

//   /// Converts the current [Decimal] value to a string representation in exponential notation.
//   ///
//   /// The optional [fractionDigits] parameter specifies the number of decimal places to include in the
//   /// mantissa of the exponential notation. If [fractionDigits] is 0, the mantissa will be rounded to
//   /// an integer value.
//   ///
//   /// The exponential notation will be in the form `"[-]d.dddde[+|-]dd"`, where the mantissa is
//   /// rounded to the specified number of decimal places.
//   ///
//   /// For example:
//   /// - `Decimal(12.34).toStringAsExponential()` => `"1.234e+01"`
//   /// - `Decimal(12.34).toStringAsExponential(1)` => `"1.2e+01"`
//   /// - `Decimal(-12.34).toStringAsExponential(2)` => `"-1.23e+01"`
//   String toStringAsExponential([int fractionDigits = 0]) {
//     assert(fractionDigits >= 0);

//     final negative = this < zero;
//     var value = abs();
//     var eValue = 0;
//     while (value < one && value > zero) {
//       value *= ten;
//       eValue--;
//     }
//     while (value >= ten) {
//       value = (value / ten).toDecimal();
//       eValue++;
//     }
//     value = value.roundToScale(scale: fractionDigits);
//     if (value == ten) {
//       value = (value / ten).toDecimal();
//       eValue++;
//     }

//     return <String>[
//       if (negative) '-',
//       value.toStringAsFixed(fractionDigits),
//       'e',
//       if (eValue >= 0) '+',
//       '$eValue',
//     ].join();
//   }

//   /// Converts the current [Decimal] value to a string representation with the specified precision.
//   ///
//   /// The [precision] parameter specifies the number of significant digits to include in the string
//   /// representation. If the [Decimal] value is zero, the string will be padded with zeros to the
//   /// specified precision.
//   ///
//   /// For example:
//   /// - `Decimal(12.34).toStringAsPrecision(3)` => `"12.3"`
//   /// - `Decimal(0.00012).toStringAsPrecision(2)` => `"0.00012"`
//   /// - `Decimal(0).toStringAsPrecision(4)` => `"0.0000"`
//   String toStringAsPrecision(int precision) {
//     assert(precision > 0);

//     if (this == zero) {
//       return <String>[
//         '0',
//         if (precision > 1) '.',
//         for (var i = 1; i < precision; i++) '0',
//       ].join();
//     }

//     final limit = ten.pow(precision.toDecimal());
//     var shift = one;
//     final absValue = abs();
//     var pad = 0;
//     while (absValue * shift < limit) {
//       pad++;
//       shift *= ten;
//     }
//     while (absValue * shift >= limit) {
//       pad--;
//       shift = (shift / ten).toDecimal();
//     }
//     final value = ((this * shift).roundToScale() / shift).toDecimal();
//     return pad <= 0 ? value.toString() : value.toStringAsFixed(pad);
//   }
// }

// extension RationalExt on Rational {
//   /// Converts the current [Rational] value to a [Decimal] with the specified precision.
//   ///
//   /// If the [Rational] has a finite precision, it is directly converted to a [Decimal].
//   /// Otherwise, the [Rational] is scaled by the specified [precision] and converted to a [Decimal].
//   ///
//   /// The optional [toBigInt] parameter allows customizing the conversion from [Rational] to [BigInt].
//   /// If not provided, the default behavior is to truncate the [Rational] value.
//   Decimal toDecimal({
//     int? precision,
//     BigInt Function(Rational)? toBigInt,
//   }) {
//     var prec = precision ?? decimalPrecision;
//     if (hasFinitePrecision) {
//       return Decimal(this);
//     }
//     final scaleFactor = _r10.pow(prec);
//     toBigInt ??= (value) => value.round();
//     return Decimal(toBigInt(this * scaleFactor).toRational() / scaleFactor);
//   }

//     /// Returns true if this [Rational] has a finite decimal representation.
//   ///
//   /// A rational number has a finite decimal representation if and only if
//   /// its denominator, when expressed in lowest form, has only 2 and 5 as prime factors.
//   bool get hasFinitePrecision {
//     // Quick check for integers
//     if (isInteger) return true;

//     // Quick check for common denominators
//     if (denominator == BigInt.from(2) ||
//         denominator == BigInt.from(4) ||
//         denominator == BigInt.from(5) ||
//         denominator == BigInt.from(8) ||
//         denominator == BigInt.from(10) ||
//         denominator == BigInt.from(16) ||
//         denominator == BigInt.from(20) ||
//         denominator == BigInt.from(25) ||
//         denominator == BigInt.from(40) ||
//         denominator == BigInt.from(50) ||
//         denominator == BigInt.from(100)) {
//       return true;
//     }

//     // For other denominators, check if they only have 2 and 5 as prime factors
//     var d = denominator;

//     // Remove all factors of 2
//     while (d.isEven && d != BigInt.one) {
//       d = d >> 1; // Faster than division
//     }

//     // Remove all factors of 5
//     while (d % BigInt.from(5) == BigInt.zero && d != BigInt.one) {
//       d = d ~/ BigInt.from(5);
//     }

//     // If only 2s and 5s were factors, d should now be 1
//     return d == BigInt.one;
//   }
// }

// /// Extensions on [BigInt].
// extension BigIntExt on BigInt {
//   /// Converts the current [BigInt] to a [Decimal].
//   ///
//   /// This extension method provides a convenient way to create a [Decimal] instance from a [BigInt].
//   Decimal toDecimal() => Decimal.fromBigInt(this);

//   /// Converts the current [int] to a [Rational].
//   ///
//   /// This extension method provides a convenient way to create a [Rational] instance from an [int].
//   Rational toRational() => Rational(this);
// }

// extension NumToDecimalExtension on num {
//   /// Converts this [num] to a [Decimal].
//   Decimal toDecimal() {
//     if (this is int) {
//       return Decimal.fromInt(this as int);
//     } else {
//       return Decimal.fromDouble(toDouble());
//     }
//   }

//   /// Adds this [num] to a [Decimal].
//   Decimal operator +(Decimal other) => toDecimal() + other;

//   /// Subtracts a [Decimal] from this [num].
//   Decimal operator -(Decimal other) => toDecimal() - other;

//   /// Multiplies this [num] by a [Decimal].
//   Decimal operator *(Decimal other) => toDecimal() * other;

//   /// Divides this [num] by a [Decimal].
//   dynamic operator /(Decimal other) => toDecimal() / other;

//   /// Returns the remainder when this [num] is divided by a [Decimal].
//   Decimal operator %(Decimal other) => toDecimal() % other;

//   /// Performs integer division of this [num] by a [Decimal].
//   BigInt operator ~/(Decimal other) => toDecimal() ~/ other;
// }
