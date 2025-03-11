part of '../complex.dart';

extension ComplexOperationX<T extends Complex> on T {

  // Operations with Complex and num types
  Complex operator +(Object other) {
    if (other is Complex) {
      if (isNaN || other.isNaN) return Complex.nan();
      return Complex(real + other.real, imaginary + other.imaginary);
    }
    if (other is num) return this + Complex(other, 0);
    throw ArgumentError('Invalid type for addition: ${other.runtimeType}');
  }

  Complex operator -(Object other) {
    if (other is Complex) {
      if (isNaN || other.isNaN) return Complex.nan();
      return Complex(real - other.real, imaginary - other.imaginary);
    }
    if (other is num) return this - Complex(other, 0);
    throw ArgumentError('Invalid type for subtraction: ${other.runtimeType}');
  }

  Complex operator *(Object other) {
    if (other is Complex) {
      // Special cases handling for infinity and NaN
      if (isNaN || other.isNaN) return Complex.nan();

      // Handle infinity cases
      if (isInfinite || other.isInfinite) {
        // 0 * inf = NaN
        if ((real == 0 && imaginary == 0) ||
            (other.real == 0 && other.imaginary == 0)) {
          return Complex.nan();
        }

        // Preserve sign information for real components
        final sign = real.sign * other.real.sign;
        return Complex(sign * double.infinity, sign * double.infinity);
      }

      // Normal multiplication
      return Complex(
        real * other.real - imaginary * other.imaginary,
        real * other.imaginary + imaginary * other.real,
      );
    }
    if (other is num) {
      if (other.isNaN) return Complex.nan();
      if (other.isInfinite) {
        if (isZero) return Complex.nan();
        return Complex(
          real.sign * other.sign * double.infinity,
          imaginary.sign * other.sign * double.infinity,
        );
      }
      return Complex(real * other, imaginary * other);
    }
    throw ArgumentError(
        'Invalid type for multiplication: ${other.runtimeType}');
  }

  Complex operator /(Object other) {
    if (other is Complex) {
      // Special cases for NaN and infinity
      if (isNaN || other.isNaN) return Complex.nan();

      // 0/0, inf/inf give NaN
      if (other.isZero) return isZero ? Complex.nan() : Complex.infinity();
      if (isInfinite && other.isInfinite) return Complex.nan();

      // Normal case
      final denominator =
          other.real * other.real + other.imaginary * other.imaginary;
      return Complex(
        (real * other.real + imaginary * other.imaginary) / denominator,
        (imaginary * other.real - real * other.imaginary) / denominator,
      );
    } else if (other is num) {
      // Special cases
      if (other.isNaN) return Complex.nan();
      if (other == 0) return isZero ? Complex.nan() : Complex.infinity();
      if (other.isInfinite) return Complex.zero();

      // Normal case
      return Complex(real / other, imaginary / other);
    }
    throw ArgumentError('Invalid type for division: ${other.runtimeType}');
  }

  ///  The truncating division operator.
  Complex operator ~/(dynamic divisor) {
    if (divisor != 0) {
      if (divisor is num) {
        return Complex(real ~/ divisor, imaginary ~/ divisor);
      }

      if (divisor is Complex) {
        // (a + bi) / (c + di) = (ac + bd) / (c^2 + d^2) + i * (bc - ad) / (c^2 + d^2)
        final c2d2 = (divisor.real * divisor.real) +
            (divisor.imaginary * divisor.imaginary);
        return Complex(
            ((real * divisor.real + imaginary * divisor.imaginary) / c2d2)
                .truncate(),
            ((imaginary * divisor.real - real * divisor.imaginary) / c2d2)
                .truncate());
      }
    }

    // Treat divisor as 0
    return Complex(real < 0 ? double.negativeInfinity : double.infinity,
        imaginary < 0 ? double.negativeInfinity : double.infinity);
  }

  /// The modulo operator (not supported).
  Complex operator %(dynamic divisor) {
    var modulus = magnitude;
    if (divisor is num) {
      var remainder = modulus % divisor;
      return Complex.polar(remainder, phase);
    } else if (divisor is Complex) {
      var otherModulus = divisor.magnitude;
      var remainder = modulus % otherModulus;
      return Complex.polar(remainder, phase);
    }
    return this % divisor;

    // throw const NumberException(
    //       'The number library does not support raising a complex number to an imaginary power');
  }

  Complex operator -() => Complex(-real, -imaginary);

  // Reciprocal operator
  Complex operator ~() {
    if (real == 0 && imaginary == 0) {
      return Complex(double.infinity, double.infinity);
    }
    if (isNaN) return Complex(double.nan, double.nan);
    if (isInfinite) return Complex(0, 0);

    final denominator = real * real + imaginary * imaginary;
    return Complex(real / denominator, -imaginary / denominator);
  }

  /// The power operator (note: NOT bitwise XOR).
  /// In order to provide a convenient power operator for all [Number]s, the number library
  /// overrides the caret operator.  In Dart the caret operator is ordinarily used
  /// for bitwise XOR operations on [int]s.
  Complex operator ^(dynamic exponent) {
    if (exponent is num || exponent is Complex) {
      return pow(exponent);
    }

    return Complex.one();
  }

  /// Returns true if the real component of this Complex number is greater than [obj].
  /// The imaginary part of this complex number is ignored.
  bool operator >(dynamic obj) => real > obj;

  /// Returns true if the real component of this Complex number is greater
  /// than or equal to [obj].
  /// The imaginary part of this complex number is ignored.
  bool operator >=(dynamic obj) => real >= obj;

  /// Returns true if the real component of this Complex number is
  /// less than [obj].
  /// The imaginary part of this complex number is ignored.
  bool operator <(dynamic obj) => real < obj;

  /// Returns true if the real component of this Complex number is
  /// less than or equal to [obj].
  /// The imaginary part of this complex number is ignored.
  bool operator <=(dynamic obj) => real <= obj;



  /// Computes the n-th roots of the complex number represented by this object.
  ///
  /// The returned list contains the n complex numbers that are the n-th roots of
  /// this complex number. The roots are ordered such that the first root has the
  /// smallest positive argument.
  ///
  /// If `n` is non-positive, an `ArgumentError` is thrown. If this complex number
  /// is NaN or infinite, a list containing a single NaN or infinite complex
  /// number is returned, respectively.
  List<Complex> nthRoot(int n) {
    if (n <= 0) {
      throw ArgumentError("Can't compute nth root for negative n");
    }

    if (isNaN) {
      return [Complex.nan()];
    } else if (isInfinite) {
      return [Complex.infinity()];
    }

    // nth root of abs -- faster / more accurate to use a solver here?
    final nthRootOfAbs = math.pow(abs(), 1.0 / n);

    // Compute nth roots of complex number with k = 0, 1, ... n-1
    final nthPhi = argument / n;
    final slice = 2 * math.pi / n;
    var innerPart = nthPhi;
    return List.generate(n, (_) {
      final c = Complex.polar(nthRootOfAbs, innerPart);
      innerPart += slice;
      return c;
    });
  }

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
  Complex pow(dynamic exponent) {

    // if (exponent is int) {
    //   if (exponent == 0) return Complex.one();
    //   if (exponent < 0) return ~(this ^ (-exponent));
      
    //   var result = Complex.one();
    //   var base = this;
    //   var exp = exponent;
      
    //   while (exp > 0) {
    //     if (exp & 1 == 1) result *= base;
    //     base *= base;
    //     exp >>= 1;
    //   }
    //   return result;
    // }

    // For real (num) exponents, use a simplified polar approach.
    if (exponent is num) {
      final baseVal = magnitude;
      // If the base is nearly zero (use an epsilon threshold)
      if (baseVal.abs() < 1e-15) {
        if (exponent > 0) return Complex(0, 0);
        throw ArgumentError(
            "0 raised to a non-positive exponent is undefined.");
      }
      final r = math.pow(baseVal, exponent);
      final theta = angle * exponent;
      return Complex.polar(r, theta.toDouble());
    }

    final baseVal = magnitude;
    // Check for near-zero base using a small epsilon
    if (baseVal.abs() < 1e-15) {
      if (exponent.real.value > 0) return Complex(0, 0);
      throw ArgumentError("0 raised to a non-positive exponent is undefined.");
    }

    // For complex exponents, use the formula: z^w = e^(w * log(z))
    final theta = phase;
    final realExp = exponent.real;
    final imagExp = exponent.imaginary;

    // Compute new magnitude and angle using polar exponentiation:
    //   z^w = (r e^(i theta))^w = r^(realExp) * e^(-imagExp * theta)
    //         * e^(i (realExp * theta + imagExp * log(r)))
    num newR = math.pow(baseVal, realExp.value) *
        math.exp(-(imagExp.getValue) * theta.value);
    num newTheta =
        realExp.value * theta.value + imagExp.getValue * math.log(baseVal);

    // If the computed intermediate values are non-finite, signal an error.
    if (!newR.isFinite || !newTheta.isFinite) {
      throw ArgumentError(
          "Result of exponentiation is non-finite (Infinity or NaN).");
    }

    num newReal = newR * math.cos(newTheta);
    num newImaginary = newR * math.sin(newTheta);

    if (!newReal.isFinite || !newImaginary.isFinite) {
      throw ArgumentError(
          "Result of exponentiation is non-finite (Infinity or NaN).");
    }

    return Complex(newReal, newImaginary);
  }

  /// Returns a new complex number representing the square root of this number.
  ///
  /// ```dart
  /// var z = Complex(4, 0);
  /// var z_sqrt = z.sqrt();
  ///
  /// print(z_sqrt); // Output: 2.0 + 0.0i
  /// ```
  Complex sqrt() => pow(0.5);

  Complex sqrt1z() {
    final a = (Complex.one() - (this * this)).sqrt();
    return a;
  }

  /// Returns a new complex number representing the exponential of this number.
  ///
  /// ```dart
  /// var z = Complex(1, pi);
  /// var z_exp = z.exp();
  ///
  /// print(z_exp); // Output: -1.0 + 1.2246467991473532e-16i
  /// ```
  Complex exp() {
    if (isNaN) return Complex.nan();
    final r = math.exp(real);
    return Complex(r * math.cos(imaginary), r * math.sin(imaginary));
  }

  /// Returns a new complex number representing the natural logarithm (base e) of this number.
  ///
  /// ```dart
  /// var z = Complex(exp(1), 0);
  /// var z_ln = z.ln();
  ///
  /// print(z_ln); // Output: 1.0 + 0.0i
  /// ```
  Complex ln() {
    return Complex(math.log(magnitude), angle);
  }

  num abs() {
    if (real.isNaN || imaginary.isNaN) return double.nan;
    if (real.isInfinite || imaginary.isInfinite) return double.infinity;

    // Handle potential overflow in a more robust way
    final a = real.abs();
    final b = imaginary.abs();
    if (a == 0) return b;
    if (b == 0) return a;

    // if (a > b) {
    //   final r = b / a;
    //   return a * math.sqrt(1 + r * r);
    // } else {
    //   final r = a / b;
    //   return b * math.sqrt(1 + r * r);
    // }

    final value = math.sqrt(real * real + imaginary * imaginary) as num;
    return value.toInt() == value ? value.toInt() : value.toDouble();
  }

  /// Calculates the natural logarithm of the complex number.
  ///
  /// If the complex number is NaN, this method returns NaN.
  /// Otherwise, it returns a new [Complex] number with the real part set to the natural logarithm of the modulus, and the imaginary part set to the angle (or argument) of the complex number.
  Complex log() {
    if (isNaN) return Complex.nan();
    return Complex(math.log(abs()), math.atan2(imaginary, real));
  }

  /// Returns the distance between two complex numbers in the complex plane
  num distanceTo(Complex other) {
    return (this - other).abs();
  }

  /// Returns true if the complex number lies within a circle
  bool isWithinCircle(Complex center, double radius) {
    return distanceTo(center) <= radius;
  }

  /// Rotates the complex number by theta radians around the origin
  Complex rotate(double theta) {
    return this * Complex(math.cos(theta), math.sin(theta));
  }

  /// Returns the 2x2 matrix representation of this complex number
  List<List<num>> toMatrix() {
    return [
      [real, -imaginary],
      [imaginary, real]
    ];
  }


  /// Returns the ceiling of the real portion of this complex number.
  num ceil() => real.ceil();

  /// Returns a Complex number whose real portion has been clamped to within [lowerLimit] and
  /// [upperLimit] and whose imaginary portion is the same as the imaginary value in this Complex number.
  dynamic clamp(dynamic lowerLimit, dynamic upperLimit) {
    final clampedReal = real.clamp(lowerLimit, upperLimit);
    if (clampedReal.toDouble() == 0) {
      return imaginary == 0 ? 0 : imaginary;
    }
    return Complex(clampedReal, imaginary);
  }

  /// Returns the floor of the real portion of this complex number.
  int floor() => real.floor();

  /// Returns the integer closest to the real portion of this complex number.
  int round() => real.round();

  // Complex round({int decimals = 0}) => Complex(
  //       (real * math.pow(10, decimals)).round() / math.pow(10, decimals),
  //       (imaginary * math.pow(10, decimals)).round() / math.pow(10, decimals),
  //     );

  /// Returns the real portion of this complex number, truncated to an Integer.
  int truncate() => real.truncate();

  /// The remainder method operates on the real portion of this Complex number only.
  num remainder(dynamic divisor) => real.remainder(divisor);

}