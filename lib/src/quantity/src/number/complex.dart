import '../../../math/basic/math.dart' as math;
import '../../number.dart';

/// Complex numbers have both a real and an imaginary part.
class Complex extends Number {
  /// Constructs a instance from real and imaginary coefficients
  /// such as (num, double, int).
  Complex(num realValue, num imagValue)
      : real = realValue is int
            ? Integer(realValue)
            : Double.constant(realValue.toDouble()),
        imaginary = Imaginary.constant(imagValue is int
            ? Integer(imagValue)
            : Double(imagValue.toDouble()));

  /// Constructs a instance.
  Complex.num(this.real, this.imaginary);

  /// Constructs a constant Complex number.
  const Complex.constant(this.real, this.imaginary) : super.constant();

  /// Constructs a instance, applying the values in map [m].
  /// See `toJson` for the expected format.
  Complex.fromMap(Map<String, Map<String, dynamic>>? m)
      : real = (m?.containsKey('real') == true)
            ? Real.fromMap(m?['real'])
            : Double.zero,
        imaginary = m?.containsKey('real') ?? false
            ? Imaginary.constant(Real.fromMap(m?['imag']))
            : const Imaginary.constant(Integer.zero);

  /// Constructs a complex number from the given polar coordinates.
  ///
  /// The `r` argument represents the magnitude of the number and
  /// the `theta` argument represents the angle in radians.
  ///
  /// ```dart
  /// var z = Complex.fromPolar(2, pi / 2);
  ///
  /// print(z); // Output: 1.2246467991473532e-16 + 2.0i
  /// ```
  Complex.fromPolar(num r, num theta)
      : real = Double(r * math.cos(theta) as double),
        imaginary = Imaginary(Double(r * math.sin(theta) as double));

  /// Factory constructor to create a Complex number from a real number only.
  /// The imaginary part will be 0.
  Complex.fromReal(num realValue)
      : real = Double(realValue.toDouble()),
        imaginary = Imaginary(0);

  /// Factory constructor to create a Complex number from a real number only.
  /// The real part will be 0.
  Complex.fromImaginary(num imaginaryValue)
      : real = Double(0),
        imaginary = Imaginary(imaginaryValue);

  /// Creates a complex number from [Fraction] objects.
  factory Complex.fromFraction(Fraction real, Fraction imaginary) =>
      Complex(real.toDouble(), imaginary.toDouble());

  /// Creates a complex number having only the real part expressed as a
  /// [Fraction] object.
  ///
  /// The imaginary part is set to 0i.
  factory Complex.fromRealFraction(Fraction real) =>
      Complex(real.toDouble(), 0);

  /// Creates a complex number having only the imaginary part expressed as a
  /// [Fraction] object.
  ///
  /// The real part is set to 0.
  factory Complex.fromImaginaryFraction(Fraction imaginary) =>
      Complex(0, imaginary.toDouble());

  /// Parses a complex number from the given string.
  ///
  /// The string must be in the format "a + bi" or "a - bi", where
  /// a is the real part and b is the imaginary part.
  ///
  /// ```dart
  /// var z = Complex.parse('2 + 2i');
  ///
  /// print(z); // Output: 2 + 2i
  /// ```
  factory Complex.parse(String s) {
    // Simple parsing implementation, assuming input format a +/- bi
    final hasPlus = s.contains('+');
    final parts = s.split(hasPlus ? '+' : '-');
    final real = Double.parse(parts[0].trim());
    final imaginary =
        Imaginary(Double.parse(parts[1].trim().replaceFirst('i', '')));
    return Complex.num(real, hasPlus ? imaginary : -imaginary);
  }

  /// Computes the complex n-th root of this object. The returned root is the
  /// one with the smallest positive argument.
  factory Complex.nthRootFromValue(double x, int n) {
    if (x >= 0) {
      return Complex(math.pow(x, 1.0 / n), 0);
    } else {
      return Complex(math.pow(-x, 1.0 / n), 0);
    }
  }

  /// Constructs a complex number that represents zero.
  Complex.zero()
      : real = Double.zero,
        imaginary = Imaginary(0);

  /// Constructs a complex number that represents one.
  Complex.one()
      : real = Double(1),
        imaginary = Imaginary(0);

  /// Constructs a complex number that represents the imaginary unit i.
  Complex.i()
      : real = Double.zero,
        imaginary = Imaginary(1);

  /// Constructs a complex number that represents nan.
  Complex.nan()
      : real = Double.NaN,
        imaginary = Imaginary(Double.NaN);

  /// Constructs a complex number that represents infinity.
  Complex.infinity()
      : real = Double.infinity,
        imaginary = Imaginary(Double.infinity);

  /// Constructs a complex number representing "e + 0.0i"
  Complex.e()
      : real = Double(math.e),
        imaginary = Imaginary(0);

  /// The real number component of the complex number.
  final Real real;

  /// The imaginary number component of the complex number.
  final Imaginary imaginary;

  /// [imag] is a convenient getter for the [imaginary] value
  Imaginary get imag => imaginary;

  /// Returns the conjugate of this Complex number (the sign of the imaginary component is flipped).
  Complex get conjugate => Complex.num(real, Imaginary(imaginary.value * -1.0));

  /// Complex modulus represents the magnitude of this complex number in the complex plane.
  /// Synonymous with abs().
  Number get complexModulus {
    final num value = math.sqrt(real.value * real.value +
        imaginary.value.value * imaginary.value.value);
    return value.toInt() == value
        ? Integer(value.toInt())
        : Double(value.toDouble());
  }

  /// Complex norm is synonymous with complex modulus and abs().
  Number get complexNorm => complexModulus;

  /// Returns the absolute square of this Complex number.
  Number get absoluteSquare => complexModulus ^ 2;

  /// In radians.
  Double get complexArgument =>
      Double(math.atan2(imaginary.value.value, real.value));

  /// Phase is synonymous with complex argument.
  Double get phase => complexArgument;

  /// Returns the magnitude (or absolute value) of the complex number.
  ///
  /// ```dart
  /// var z = Complex(3, 4);
  ///
  /// print(z.magnitude); // Output: 5.0
  /// ```
  Number get magnitude => complexModulus;

  /// Returns the angle (or argument or phase) in radians of the complex number.
  ///
  /// ```dart
  /// var z = Complex(1, 1);
  ///
  /// print(z.angle); // Output: 0.7853981633974483
  /// ```
  Double get angle => complexArgument;

  /// Returns the angle (or argument or phase) in radians of the complex number.
  ///
  /// ```dart
  /// var z = Complex(1, 1);
  ///
  /// print(z.angle); // Output: 0.7853981633974483
  /// ```
  Double get argument => angle;

  @override
  bool get isInfinite =>
      real.value == double.infinity || real.value == double.negativeInfinity;

  @override
  bool get isNaN => real.value.isNaN;

  /// Whether the real part of this complex number is negative.
  @override
  bool get isNegative => real.value < 0;

  /// Whether the real part of this complex number is an integer.
  @override
  bool get isInteger => (imaginary.toDouble() == 0) && real.isInteger;

  /// Checks whether the complex number is zero.
  bool get isZero => real == Integer(0) && imaginary == Imaginary(0);

  /// The sign of the current object is changed and the result is returned in a
  /// new [Complex] instance.
  Complex get negate => Complex.num(-real, -imaginary);

  /// Returns the real part of this complex number as a double.
  @override
  double toDouble() => real.toDouble();

  /// Returns the real part of this complex number as an integer.
  @override
  int toInt() => real.toInt();

  @override
  int get hashCode {
    if (imaginary.value.toDouble() == 0) {
      if (real is Decimal) return real.hashCode;
      return Decimal(real.toDouble()).hashCode;
    } else {
      if (real.toDouble() == 0) {
        return hashObjects(<Object>[0, imaginary.value]);
      }
      return hashObjects(<Object>[real, imaginary.value]);
    }
  }

  Complex copyWith({
    num? real,
    num? imaginary,
  }) =>
      Complex(
        real ?? this.real.value,
        imaginary ?? this.imaginary.value.value,
      );

  @override
  // ignore: non_nullable_equals_parameter
  bool operator ==(dynamic obj) {
    if (obj is num) return real.value == obj && imaginary.value.value == 0.0;
    if (obj is Complex) return real == obj.real && imaginary == obj.imaginary;
    if (obj is Imaginary) return real.value == 0.0 && imaginary == obj;
    if (obj is Real) return obj == real && imaginary.value.value == 0.0;
    return false;
  }

  @override
  Number operator +(dynamic addend) {
    if (addend is Complex) {
      return Number.simplifyType(Complex.num(real + addend.real as Real,
          Imaginary(imaginary.value + addend.imaginary.value)));
    }
    if (addend is Imaginary) {
      return Number.simplifyType(
          Complex.num(real, Imaginary(imaginary.value + addend.value)));
    }
    if (addend is Real) {
      return Number.simplifyType(Complex.num(real + addend as Real, imaginary));
    }
    if (addend is num) {
      return Number.simplifyType(Complex.num(real + addend as Real, imaginary));
    }

    // Treat addend as zero.
    return Number.simplifyType(this);
  }

  @override
  Complex operator -() => Complex.num(-real, -imaginary);

  @override
  Number operator -(dynamic subtrahend) {
    if (subtrahend is Complex) {
      return Number.simplifyType(Complex.num(
          real - subtrahend.real.value as Real,
          Imaginary(imaginary.value - subtrahend.imaginary.value)));
    }
    if (subtrahend is Imaginary) {
      return Number.simplifyType(
          Complex.num(real, Imaginary(imaginary.value - subtrahend.value)));
    }
    if (subtrahend is num) {
      return Number.simplifyType(
          Complex.num(real - subtrahend as Real, imaginary));
    }
    if (subtrahend is Real) {
      return Number.simplifyType(
          Complex.num(real - subtrahend as Real, imaginary));
    }

    return Number.simplifyType(this);
  }

  @override
  Number operator *(dynamic multiplicand) {
    // i * i = -1
    if (multiplicand is num) {
      return Number.simplifyType(Complex.num(real * multiplicand as Real,
          Imaginary(imaginary.value * multiplicand)));
    }
    if (multiplicand is Real) {
      return Number.simplifyType(Complex.num(multiplicand * real as Real,
          Imaginary(multiplicand * imaginary.value)));
    }
    if (multiplicand is Imaginary) {
      // (0+bi)(c+di)=(-bd)+i(bc)
      return Number.simplifyType(Complex.num(
          imaginary.value * multiplicand.value * -1 as Real,
          Imaginary(multiplicand.value * real)));
    }
    if (multiplicand is Complex) {
      // (a+bi)(c+di)=(ac-bd)+i(ad+bc)
      return Number.simplifyType(Complex.num(
          real * multiplicand.real -
              imaginary.value * multiplicand.imaginary.value as Real,
          Imaginary(real * multiplicand.imaginary.value +
              imaginary.value * multiplicand.real)));
    }

    // Treat multiplier as zero
    return Number.simplifyType(Integer.zero);
  }

  @override
  Number operator /(dynamic divisor) {
    if (divisor is num) {
      return Number.simplifyType(Complex.num(
          real / divisor as Real, Imaginary(imaginary.value / divisor)));
    }
    if (divisor is Real) {
      return Number.simplifyType(Complex.num(real / divisor.value as Real,
          Imaginary(imaginary.value / divisor.value)));
    }
    if (divisor is Imaginary) {
      return Number.simplifyType(Complex.num(
          imaginary.value / divisor.value as Real,
          Imaginary(-real / divisor.value)));
    }
    if (divisor is Complex) {
      // (a + bi) / (c + di) = (ac + bd) / (c^2 + d^2) + i * (bc - ad) / (c^2 + d^2)
      final c2d2 = (divisor.real ^ 2.0) + (divisor.imaginary.value ^ 2.0);
      return Number.simplifyType(Complex.num(
          (real * divisor.real + imaginary.value * divisor.imaginary.value) /
              c2d2 as Real,
          Imaginary((imaginary.value * divisor.real -
                  real * divisor.imaginary.value) /
              c2d2)));
    }

    // Treat divisor as 0
    return Number.simplifyType(Complex.num(
        real < 0 ? Double.negInfinity : Double.infinity,
        imaginary < 0
            ? Imaginary(Double.negInfinity)
            : Imaginary(Double.infinity)));
  }

  ///  The truncating division operator.
  @override
  Number operator ~/(dynamic divisor) {
    if (divisor != 0) {
      if (divisor is num) {
        return Number.simplifyType(Complex.num(
            real ~/ divisor as Real, Imaginary(imaginary.value ~/ divisor)));
      }
      if (divisor is Imaginary) {
        return Number.simplifyType(Complex.num(
            imaginary.value ~/ divisor.value as Real,
            Imaginary(-real ~/ divisor.value)));
      }
      if (divisor is Real) {
        return Number.simplifyType(Complex.num(
            real ~/ divisor as Real, Imaginary(imaginary.value ~/ divisor)));
      }
      if (divisor is Complex) {
        // (a + bi) / (c + di) = (ac + bd) / (c^2 + d^2) + i * (bc - ad) / (c^2 + d^2)
        final c2d2 = (divisor.real ^ 2.0) + (divisor.imaginary.value ^ 2.0);
        return Number.simplifyType(Complex.num(
            ((real * divisor.real + imaginary * divisor.imaginary) / c2d2)
                .truncate() as Real,
            Imaginary(
                ((imaginary * divisor.real - real * divisor.imaginary) / c2d2)
                    .truncate())));
      }
    }

    // Treat divisor as 0
    return Number.simplifyType(Complex.num(
        real < 0 ? Double.negInfinity : Double.infinity,
        imaginary < 0
            ? Imaginary(Double.negInfinity)
            : Imaginary(Double.infinity)));
  }

  /// The modulo operator (not supported).
  @override
  Number operator %(dynamic divisor) {
    var modulus = magnitude;
    if (divisor is num) {
      var remainder = modulus % divisor;
      return Complex.fromPolar(numberToNum(remainder), numberToNum(phase));
    } else if (divisor is Complex) {
      var otherModulus = divisor.magnitude;
      var remainder = modulus % otherModulus;
      return Complex.fromPolar(numberToNum(remainder), numberToNum(phase));
    }
    return this % divisor;

    // throw const NumberException(
    //       'The number library does not support raising a complex number to an imaginary power');
  }

  /// The power operator (note: NOT bitwise XOR).
  /// In order to provide a convenient power operator for all [Number]s, the number library
  /// overrides the caret operator.  In Dart the caret operator is ordinarily used
  /// for bitwise XOR operations on [int]s.
  @override
  Number operator ^(dynamic exponent) {
    if (exponent is num) {
      return pow(exponent);
    } else if (exponent is Real) {
      return pow(Complex.num(exponent, Imaginary(0)));
    } else if (exponent is Complex) {
      return pow(exponent);
    } else if (exponent is Imaginary) {
      return pow(Complex.num(Double.zero, exponent));
    }

    return Double.one;
  }

  /// Returns true if the real component of this Complex number is greater than [obj].
  /// The imaginary part of this complex number is ignored.
  @override
  bool operator >(dynamic obj) => real > obj;

  /// Returns true if the real component of this Complex number is greater
  /// than or equal to [obj].
  /// The imaginary part of this complex number is ignored.
  @override
  bool operator >=(dynamic obj) => real >= obj;

  /// Returns true if the real component of this Complex number is
  /// less than [obj].
  /// The imaginary part of this complex number is ignored.
  @override
  bool operator <(dynamic obj) => real < obj;

  /// Returns true if the real component of this Complex number is
  /// less than or equal to [obj].
  /// The imaginary part of this complex number is ignored.
  @override
  bool operator <=(dynamic obj) => real <= obj;

  /// Returns a new complex number representing this number raised to the power of [exponent].
  ///
  /// Example:1
  /// ```dart
  /// var z = Complex(2, 3);
  /// var z_power = z.pow(2);
  ///
  /// print(z_power); // Output: -5 + 12i
  /// ```
  ///
  /// Example:2
  /// ```dart
  /// var z = Complex(1, 2);
  /// var z_power = z.pow(Complex(2, 1));
  ///
  /// print(z_power); // Output: -1.6401010184280038 + 0.202050398556709i
  /// ```
  @override
  Number pow(dynamic exponent) {
    if (exponent is num) {
      final r = math.pow(magnitude.toDouble(), exponent);
      final theta = angle * exponent;
      return Number.simplifyType(Complex.fromPolar(r, theta.toDouble()));
    }

    if (exponent is Complex) {
      exponent = exponent;
    } else if (exponent is Imaginary) {
      exponent = Complex.num(Double.zero, exponent);
    } else if (exponent is Real) {
      exponent = Complex.num(exponent, Imaginary(0));
    }

    var r = magnitude;
    var theta = phase;
    var realExp = exponent.real;
    var imagExp = exponent.imaginary;

    num newR = math.pow(numberToNum(r), realExp.value) *
        math.exp(-(imagExp.getValue) * theta.value);
    num newTheta = realExp.value * theta.value +
        imagExp.getValue * math.log(numberToNum(r));

    num newReal = newR * math.cos(newTheta);
    num newImaginary = newR * math.sin(newTheta);

    return Number.simplifyType(Complex(newReal, newImaginary));
  }

  /// Returns a new complex number representing the square root of this number.
  ///
  /// ```dart
  /// var z = Complex(4, 0);
  /// var z_sqrt = z.sqrt();
  ///
  /// print(z_sqrt); // Output: 2.0 + 0.0i
  /// ```
  @override
  Number sqrt() => pow(0.5);

  /// Returns a new complex number representing the exponential of this number.
  ///
  /// ```dart
  /// var z = Complex(1, pi);
  /// var z_exp = z.exp();
  ///
  /// print(z_exp); // Output: -1.0 + 1.2246467991473532e-16i
  /// ```
  @override
  Complex exp() {
    final r = math.exp(real.value);
    return Complex(
        r * math.cos(imaginary.getValue), r * math.sin(imaginary.getValue));
  }

  /// Returns a new complex number representing the natural logarithm (base e) of this number.
  ///
  /// ```dart
  /// var z = Complex.num(exp(1), 0);
  /// var z_ln = z.ln();
  ///
  /// print(z_ln); // Output: 1.0 + 0.0i
  /// ```
  Complex ln() {
    return Complex(math.log(magnitude.toDouble()), angle.value);
  }

  /// Returns a new Complex number representing the hyperbolic sine of this number.
  ///
  /// ```dart
  /// var z = Complex.num(0, 0);
  /// var z_sinh = z.sinh();
  ///
  /// print(z_sinh); // Output: 0.0 + 0.0i
  /// ```
  Complex sinh() => Complex(
      math.sinh(real.value) * math.cos(imaginary.getValue),
      math.cosh(real.value) * math.sin(imaginary.getValue));

  /// Returns a new Complex number representing the hyperbolic cosine of this number.
  ///
  /// ```dart
  /// var z = Complex.num(0, 0);
  /// var z_cosh = z.cosh();
  ///
  /// print(z_cosh); // Output: 1.0 + 0.0i
  /// ```
  Complex cosh() => Complex(
      math.cosh(real.value) * math.cos(imaginary.getValue),
      math.sinh(real.value) * math.sin(imaginary.getValue));

  /// Returns a new Complex number representing the hyperbolic tangent of this number.
  ///
  /// ```dart
  /// var z = Complex.num(0, 0);
  /// var z_tanh = z.tanh();
  ///
  /// print(z_tanh); // Output: 0.0 + 0.0i
  /// ```
  Number tanh() => sinh() / cosh();

  // /// Returns a new Complex number representing the hyperbolic tangent
  // Number cot() => Integer(1) / tan();

  /// The absolute value of a Complex number is its distance from zero in the
  /// Complex number space (e.g., the absolute value of 3 + 4i = 5).  The absolute
  /// value is always a real number.  Synonymous with [complexModulus].
  @override
  Number abs() => complexModulus;

  /// Returns the ceiling of the real portion of this complex number.
  @override
  Number ceil() => real.ceil();

  /// Returns a Complex number whose real portion has been clamped to within [lowerLimit] and
  /// [upperLimit] and whose imaginary portion is the same as the imaginary value in this Complex number.
  @override
  Number clamp(dynamic lowerLimit, dynamic upperLimit) {
    final clampedReal = real.clamp(lowerLimit, upperLimit) as Real;
    if (clampedReal.toDouble() == 0) {
      return imaginary.value.toDouble() == 0 ? Integer.zero : imaginary;
    }
    return Complex.num(clampedReal, imaginary);
  }

  /// Returns the floor of the real portion of this complex number.
  @override
  Number floor() => real.floor();

  /// Returns the integer closest to the real portion of this complex number.
  @override
  Number round() => real.round();

  /// Returns the real portion of this complex number, truncated to an Integer.
  @override
  Number truncate() => real.truncate();

  /// The remainder method operates on the real portion of this Complex number only.
  @override
  Number remainder(dynamic divisor) => real.remainder(divisor);

  @override
  Number reciprocal() {
    // (a - bi) / (a^2 + b^2)
    final a2b2 = math.pow(real.value, 2) + math.pow(imaginary.value.value, 2);
    return Complex.num(real / a2b2 as Real, Imaginary(imaginary.value / -a2b2));
  }

  /// Support [dart:json] stringify.
  ///
  /// Map Contents:
  ///     'real' : toJson map of real number
  ///     'imag' : toJson map of imaginary number
  ///
  /// Example:
  ///     {'real':{'i':5},'imag':{'d':3.3}}
  ///
  @override
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'real': real.toJson(), 'imag': imaginary.toJson()};

  @override
  String toString({bool asFraction = false, int? fractionDigits}) =>
      _convertToString(asFraction: asFraction, fractionDigits: fractionDigits);

  /// Prints the real and the imaginary parts of this [Complex] object with
  /// [fractionDigits] decimal digits. The output produced by this method is the
  /// same that would result in calling `toStringAsFixed` on a [double]:
  ///
  /// ```dart
  /// final example = Complex(5.123, 8.123);
  ///
  /// // Calling 'toStringAsFixed' on the `Complex` instance
  /// print(example.toStringAsFixed(1)); // 5.1 + 8.1i
  ///
  /// // The same result but with 'toStringAsFixed' calls on the single [double]
  /// // values of the complex value
  /// final real = example.real.toStringAsFixed(1);
  /// final imag = example.imaginary.toStringAsFixed(1);
  ///
  /// print("$real + $imag"); // 5.1 + 8.1i
  /// ```
  String toStringAsFixed(int fractionDigits) =>
      _convertToString(fractionDigits: fractionDigits);

  /// Prints the real and the imaginary parts of the complex number as fractions
  /// with the best possible approximation.
  String toStringAsFraction() => _convertToString(asFraction: true);

  /// Prints the complex number with opening and closing parenthesis in case the
  /// complex number had both real and imaginary part.
  String toStringWithParenthesis() {
    if (real == Integer(0)) {
      return '${_fixZero(imaginary.getValue)}i';
    }

    if (imaginary == Imaginary(0)) {
      return _fixZero(real.value);
    }

    return '($this)';
  }

  /// When a value is a whole number, it's printed without the fractional part.
  /// For example, `_fixZero(5.0)` returns `"5"`.
  String _fixZero(num value) {
    if (value % 1 < 0) {
      return '${value.truncate()}';
    }

    return '$value';
  }

  /// Converts this complex number into a string. If [asFraction] is `true` then
  /// the real and the imaginary part are converted into fractions.
  ///
  /// If you define `asFraction = true` and assign `fractionDigits` together,
  /// then `fractionDigit` takes precedence and ignores the `asFraction` value.
  String _convertToString({
    bool asFraction = false,
    int? fractionDigits,
  }) {
    String realPart;
    String imaginaryPart;
    var newImag = imaginary;

    // Clean up the the output
    if (imaginary.getValue.abs() < 1e-8) {
      newImag = Imaginary(0);
    }

    if (fractionDigits != null) {
      realPart = real.value.toStringAsFixed(fractionDigits);
      imaginaryPart = '${newImag.getValue.toStringAsFixed(fractionDigits)}i';
    } else if (asFraction) {
      realPart = real.toFractionString();
      imaginaryPart = '${newImag.value.toFractionString()}i';
    } else {
      realPart = _fixZero(real.value);
      imaginaryPart = '${_fixZero(newImag.getValue)}i';
    }

    String imaginaryPartAbs = imaginaryPart;
    if (imaginary.value < 0) {
      imaginaryPartAbs = '${_fixZero(newImag.getValue.abs())}i';
    }

    if (real == Double(0) && newImag == Imaginary(0)) {
      return '0';
    }
    if (real == Double(0)) {
      return imaginaryPart;
    }
    if (newImag == Imaginary(0)) {
      return realPart;
    }

    return imaginary < Imaginary(0)
        ? '$realPart - ${newImag.getValue.abs() == 1 ? 'i' : imaginaryPartAbs}'
        : '$realPart + ${newImag.getValue.abs() == 1 ? 'i' : imaginaryPart}';
  }
}
