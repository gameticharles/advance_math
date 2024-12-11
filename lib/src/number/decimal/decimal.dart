import '../number.dart';

final _i0 = BigInt.zero;
final _i1 = BigInt.one;
final _i2 = BigInt.two;
final _i5 = BigInt.from(5);
final _r10 = Rational.fromInt(10);

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
  Decimal(dynamic value, {int? sigDigits})
      : _rational = _parseValue(value.toString()),
        assert(_parseValue(value).hasFinitePrecision) {
    if (value is num) {
      if (value.isNaN || value.isInfinite) {
        throw Exception('Decimal value must be a valid finite number');
      }
    } else if (value is String) {
      final str = value.toLowerCase().trim();
      if (str.isEmpty) {
        throw Exception('String value cannot be empty');
      }
    } else if (!(value is BigInt || value is Rational)) {
      throw Exception('Invalid type for decimal value');
    }
  }

  static Rational _parseValue(dynamic value) {
    if (value is num) {
      return Rational.parse(value.toString());
    } else if (value is BigInt) {
      return value.toRational();
    } else if (value is int) {
      return BigInt.from(value).toRational();
    } else if (value is String) {
      return Rational.parse(value.toLowerCase().trim());
    } else if (value is Rational) {
      return value;
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

  Decimal operator +(Decimal other) =>
      (_rational + other._rational).toDecimal();
  Decimal operator -(Decimal other) =>
      (_rational - other._rational).toDecimal();
  Decimal operator *(Decimal other) =>
      (_rational * other._rational).toDecimal();
  Decimal operator %(Decimal other) =>
      (_rational % other._rational).toDecimal();
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
      guess = (guess + (_rational / guess))
              .toDecimal(precision: decimalPrecision + 10) /
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
    if (this == Decimal.zero) return Decimal.one;

    final x = this;

    // Inner function to compute a range using binary splitting
    Decimal expRange(int a, int b) {
      if (a == b) {
        // Base case: Compute single term
        Decimal fact = Decimal.one;
        for (int i = 1; i <= a; i++) fact *= Decimal.fromInt(i);
        return (x.pow(a) / fact).toDecimal(precision: decimalPrecision + 10);
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
  Decimal ln() {
    if (this <= Decimal.zero) {
      throw ArgumentError('ln(x) is undefined for x <= 0');
    }

    // Dynamically compute ln(2) to the desired precision
    Rational computeLn2(int precision) {
      Rational t = Rational.parse('1/3'); // Use t = 1/3 for faster convergence
      Rational term = t;
      Rational sum = Rational.zero;
      int n = 1;

      while (term.abs() > Rational.parse('1e-$decimalPrecision')) {
        sum += term / Rational.fromInt(n);
        term *= t * t;
        n += 2;
      }

      return sum * Rational.fromInt(2);
    }

    // Dynamically compute ln(2)
    final ln2 = computeLn2(decimalPrecision + 10);

    Rational x = _rational;
    int exponent = 0;

    // Normalize x to the range [1, 2)
    while (x >= Rational.fromInt(2)) {
      x /= Rational.fromInt(2);
      exponent++;
    }
    while (x < Rational.one) {
      x *= Rational.fromInt(2);
      exponent--;
    }

    // Use the series ln((1 + t) / (1 - t)) = 2 * (t + t^3 / 3 + t^5 / 5 + ...)
    Rational t = (x - Rational.one) / (x + Rational.one);
    Rational term = t;
    Rational sum = Rational.zero;
    int n = 1;

    // Calculate the series with better convergence
    while (term.abs() > Rational.parse('1e-$decimalPrecision')) {
      sum += term / Rational.fromInt(n);
      term *= t * t;
      n += 2;
    }

    // Combine the results
    return (Rational.fromInt(exponent) * ln2 + sum * Rational.fromInt(2))
        .toDecimal(precision: decimalPrecision);
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

    if (exponent == Decimal.zero) {
      return Decimal.one;
    } else if ((exponent is Decimal && exponent.isInteger) || exponent is int) {
      var exp = (exponent is Decimal && exponent.isInteger)
          ? exponent.toBigInt().toInt()
          : exponent;
      Decimal result = Decimal.one;
      Decimal factor = this;

      while (exp > 0) {
        if (exp % 2 == 1) {
          result *= factor;
        }
        factor *= factor;
        exp ~/= 2;
      }

      return result;
    } else {
      var exp = exponent is Decimal ? exponent : Decimal(exponent);
      return (exp * ln()).exp();
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

  Decimal _scaleAndApply(int scale, BigInt Function(Rational) f) {
    final scaleFactor = ten.pow(scale.toDecimal()).toRational();
    return (f(_rational * scaleFactor).toRational() / scaleFactor).toDecimal();
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

extension RationalExt on Rational {
  /// Converts the current [Rational] value to a [Decimal] with the specified precision.
  ///
  /// If the [Rational] has a finite precision, it is directly converted to a [Decimal].
  /// Otherwise, the [Rational] is scaled by the specified [precision] and converted to a [Decimal].
  ///
  /// The optional [toBigInt] parameter allows customizing the conversion from [Rational] to [BigInt].
  /// If not provided, the default behavior is to truncate the [Rational] value.
  Decimal toDecimal({
    int? precision,
    BigInt Function(Rational)? toBigInt,
  }) {
    var prec = precision ?? decimalPrecision;
    if (hasFinitePrecision) {
      return Decimal(this);
    }
    final scaleFactor = _r10.pow(prec);
    toBigInt ??= (value) => value.truncate();
    return Decimal(toBigInt(this * scaleFactor).toRational() / scaleFactor);
  }

  /// Checks whether the current [Rational] value has a finite precision.
  ///
  /// This is determined by checking whether the denominator of the [Rational] is a power of 2 and 5.
  /// If the denominator is a power of 2 and 5, then the [Rational] has a finite precision.
  bool get hasFinitePrecision {
    var den = denominator;
    while (den % _i5 == _i0) {
      den = den ~/ _i5;
    }
    while (den % _i2 == _i0) {
      den = den ~/ _i2;
    }
    return den == _i1;
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
