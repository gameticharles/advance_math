part of '../complex.dart';

extension ComplexOperationX<T extends Complex> on T {
  /// Computes the n-th roots of the complex number represented by this object.
  ///
  /// By default, returns the principal n-th root (the one with the smallest positive argument).
  /// If [allRoots] is set to true, returns a list containing all n complex numbers
  /// that are the n-th roots of this complex number.
  ///
  /// The method handles:
  /// * Positive and negative values of n (negative n returns the reciprocal of the nth root)
  /// * Special cases (NaN, infinity, zero)
  /// * All possible roots when allRoots is true
  ///
  /// If `n` is zero, returns 1 for the principal root or [1] for all roots.
  /// If this complex number is zero and n is positive, returns zero.
  /// If this complex number is zero and n is negative, throws an ArgumentError.
  ///
  /// Examples:
  /// ```dart
  /// // Get the principal cube root of 8
  /// var principal = Complex(8, 0).nthRoot(3);
  /// print(principal); // Output: 2 + 0i
  ///
  /// // Get all cube roots of 8
  /// var allRoots = Complex(8, 0).nthRoot(3, allRoots: true);
  /// print(allRoots); // Output: [2 + 0i, -1 + 1.732i, -1 - 1.732i]
  ///
  /// // Get the principal square root of -1
  /// var i = Complex(-1, 0).nthRoot(2);
  /// print(i); // Output: 0 + 1i
  ///
  /// // Get all square roots of -1
  /// var bothRoots = Complex(-1, 0).nthRoot(2, allRoots: true);
  /// print(bothRoots); // Output: [0 + 1i, 0 - 1i]
  ///
  /// // Get the reciprocal of the square root (negative exponent)
  /// var recipRoot = Complex(4, 0).nthRoot(-2);
  /// print(recipRoot); // Output: 0.5 + 0i
  ///
  /// // Handle zero case
  /// var zeroRoot = Complex(0, 0).nthRoot(3);
  /// print(zeroRoot); // Output: 0 + 0i
  ///
  /// // Handle n = 0 case
  /// var zeroExponent = Complex(5, 5).nthRoot(0);
  /// print(zeroExponent); // Output: 1 + 0i
  /// ```
  dynamic nthRoot(num n, {bool allRoots = false}) {
    // Handle n = 0 case
    if (n == 0) {
      return allRoots ? [Complex.one()] : Complex.one();
    }

    // Handle special cases
    if (isNaN) {
      return allRoots ? [Complex.nan()] : Complex.nan();
    } else if (isInfinite) {
      return allRoots ? [Complex.infinity()] : Complex.infinity();
    }

    // Handle zero case
    if (isZero) {
      if (n > 0) {
        return allRoots ? [Complex.zero()] : Complex.zero();
      } else {
        throw ArgumentError("Cannot compute negative power of zero");
      }
    }

    // Check if we need to compute the reciprocal (negative n)
    bool isNegativeN = n < 0;
    int absN = isNegativeN ? -n.toInt() : n.toInt();

    // Compute the magnitude of the result
    final nthRootOfAbs = math.pow(abs(), 1.0 / absN);

    // Compute the argument (phase) for the principal root
    final baseAngle = argument;
    final normalizedAngle =
        baseAngle < 0 ? baseAngle + (2 * math.pi) : baseAngle;
    final nthPhi = normalizedAngle / absN;

    // For all roots, we need to compute each root with a different angle
    if (allRoots) {
      final slice = 2 * math.pi / absN;
      var roots = List<Complex>.generate(absN, (k) {
        final angle = nthPhi + k * slice;
        final root = Complex.polar(nthRootOfAbs, angle);

        // If n is negative, return the reciprocal
        return isNegativeN ? ~root : root;
      });

      return roots;
    } else {
      // Return only the principal root
      final principalRoot = Complex.polar(nthRootOfAbs, nthPhi);

      // If n is negative, return the reciprocal
      return isNegativeN ? ~principalRoot : principalRoot;
    }
  }

  /// Returns a new complex number representing this number raised to the power of [exponent].
  ///
  /// This is an alias for [pow], and supports both real and complex exponents.
  ///
  /// Example:
  /// ```dart
  /// var z = Complex(2, 3);
  /// var z_power = z.power(2); // Equivalent to z.pow(2)
  /// print(z_power); // Output: -5 + 12i
  /// ```
  Complex power(dynamic exponent) => pow(exponent);

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
  Complex pow(dynamic x) {
    if (x is num) {
      if (x == 0) return Complex.one();
      if (x == 1) return this;
      if (imaginary == 0 && !real.isNaN && !x.isNaN) {
        return Complex(math.pow(real, x), 0);
      }
      return (log() * x).exp();
    } else if (x is Complex) {
      if (x.isZero) return Complex.one();
      if (x.isOne) return this;
      if (x.imaginary == 0 && !x.real.isNaN) {
        return pow(x.real);
      }
      return (log() * x).exp();
    }
    throw ArgumentError('Invalid exponent type: ${x.runtimeType}');
  }

  /// Returns a new complex number representing the square root of this number.
  ///
  /// ```dart
  /// var z = Complex(4, 0);
  /// var z_sqrt = z.sqrt();
  ///
  /// print(z_sqrt); // Output: 2.0 + 0.0i
  /// ```
  Complex sqrt() {
    // Handle special cases first
    if (isNaN) return Complex.nan();

    // Handle zero case
    if (isZero) return Complex.zero();

    final t = math.sqrt((real.abs() + abs()) / 2.0);
    if (real >= 0.0) {
      return Complex(t, imaginary / (2.0 * t));
    } else {
      final sign = imaginary >= 0 ? 1 : -1;
      return Complex(
        imaginary.abs() / (2.0 * t),
        sign * t,
      );
    }
  }

  Complex sqrt1z() {
    return (Complex.one() - (this * this)).sqrt();
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
    return Complex.polar(r, imaginary);
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
  /// Implements the formula:
  ///
  ///     log(a + bi) = ln(|a + bi|) + arg(a + bi)i
  ///
  /// where ln on the right hand side is [math.log],
  /// `|a + bi|` is the modulus, [abs],  and
  /// `arg(a + bi) = atan2(b, a).
  ///
  /// Special cases:
  /// - If the complex number is NaN, returns NaN
  /// - If the complex number is zero, returns -INFINITY + 0i
  /// - For infinite values, follows the mathematical conventions:
  ///   - log(1 ± INFINITY i) = INFINITY ± (π/2)i
  ///   - log(INFINITY + i) = INFINITY + 0i
  ///   - log(-INFINITY + i) = INFINITY + πi
  ///   - log(INFINITY ± INFINITY i) = INFINITY ± (π/4)i
  ///   - log(-INFINITY ± INFINITY i) = INFINITY ± (3π/4)i
  Complex log() {
    if (isNaN) return Complex.nan();
    // Handle zero case
    if (isZero) return Complex(double.negativeInfinity, 0);
    // Handle other cases
    return Complex(math.log(abs()), argument);
  }

  // ============================================================
  // Logarithmic functions with different bases
  // ============================================================

  /// Calculates the base-10 logarithm of the complex number.
  ///
  /// Implements the formula:
  ///
  ///     log10(z) = log(z) / log(10)
  ///
  /// Where log is the natural logarithm.
  ///
  /// Example:
  /// ```dart
  /// var z = Complex(100, 0);
  /// var z_log10 = z.log10();
  /// print(z_log10); // Output: 2 + 0i
  /// ```
  Complex log10() {
    if (isNaN) return Complex.nan();
    if (isZero) return Complex(double.negativeInfinity, 0);
    return log() / math.log(10);
  }

  /// Calculates the base-2 logarithm of the complex number.
  ///
  /// Implements the formula:
  ///
  ///     log2(z) = log(z) / log(2)
  ///
  /// Where log is the natural logarithm.
  ///
  /// Example:
  /// ```dart
  /// var z = Complex(8, 0);
  /// var z_log2 = z.log2();
  /// print(z_log2); // Output: 3 + 0i
  /// ```
  Complex log2() {
    if (isNaN) return Complex.nan();
    if (isZero) return Complex(double.negativeInfinity, 0);
    return log() / math.ln2;
  }

  /// Calculates the logarithm of the complex number with an arbitrary base.
  ///
  /// Implements the formula:
  ///
  ///     logBase(z, n) = log(z) / log(n)
  ///
  /// Where log is the natural logarithm.
  ///
  /// Example:
  /// ```dart
  /// var z = Complex(27, 0);
  /// var z_log3 = z.logBase(3);
  /// print(z_log3); // Output: 3 + 0i
  /// ```
  Complex logBase(num base) {
    if (isNaN) return Complex.nan();
    if (isZero) return Complex(double.negativeInfinity, 0);
    if (base <= 0 || base == 1) {
      throw ArgumentError('Logarithm base must be positive and not equal to 1');
    }
    return log() / math.log(base);
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

  /// Returns the complex number with both parts ceiled to integers.
  ///
  /// Example:
  /// ```dart
  /// Complex(3.2, 2.1).ceilToComplex()  // 4 + 3i
  /// ```
  Complex ceilToComplex() {
    return Complex(real.ceilToDouble(), imaginary.ceilToDouble());
  }

  /// Returns a Complex number whose real portion has been clamped to within [lowerLimit] and
  /// [upperLimit] and whose imaginary portion is the same as the imaginary value in this Complex number.
  dynamic clamp(dynamic lowerLimit, dynamic upperLimit) {
    return Complex(real.clamp(lowerLimit, upperLimit),
            imaginary.clamp(lowerLimit, upperLimit))
        .simplify();
  }

  /// Returns the floor of the real portion of this complex number.
  int floor() => real.floor();

  /// Returns the complex number with both parts floored to integers.
  ///
  /// Example:
  /// ```dart
  /// Complex(3.7, 2.9).floorToComplex()  // 3 + 2i
  /// ```
  Complex floorToComplex() {
    return Complex(real.floorToDouble(), imaginary.floorToDouble());
  }

  /// Returns the integer closest to the real portion of this complex number.
  int round() {
    // Handle special cases
    if (real.isNaN || real.isInfinite) {
      throw ArgumentError('Cannot convert Infinity or NaN to an integer');
    }
    return real.round();
  }

  /// Returns the rounded value of this complex number.
  ///
  /// When called without parameters, returns the integer closest to the real portion,
  /// simplifying to a num if possible.
  ///
  /// When called with [decimals], returns a new complex number with both parts
  /// rounded to the specified number of decimal places, simplifying if possible.
  ///
  /// Examples:
  /// ```dart
  /// Complex(3.7, 0).roundTo()         // returns 4 (int)
  /// Complex(3.7, 2.9).roundTo()       // returns Complex(4, 3)
  /// Complex(3.14159, 2.71828).roundTo(decimals: 2)  // returns 3.14 + 2.72i
  /// ```
  dynamic roundTo({int? decimals, bool asComplex = true}) {
    if (decimals == null) {
      // Handle special cases for real part
      if (real.isNaN || real.isInfinite) {
        return asComplex
            ? Complex(
                real,
                imaginary.isNaN || imaginary.isInfinite
                    ? imaginary
                    : imaginary.round())
            : real;
      }

      // Handle special cases for imaginary part
      if (imaginary.isNaN || imaginary.isInfinite) {
        return Complex(real.round(), imaginary);
      }

      // Round both parts to integers
      // Return simplified version (num or Complex)
      return asComplex
          ? Complex(real.round(), imaginary.round()).simplify()
          : real.round();
    }

    final factor = math.pow(10, decimals);

    // Handle special cases
    final roundedReal =
        real.isNaN || real.isInfinite ? real : (real * factor).round() / factor;
    final roundedImag = imaginary.isNaN || imaginary.isInfinite
        ? imaginary
        : (imaginary * factor).round() / factor;

    final roundedComplex = Complex(roundedReal, roundedImag);

    // Return simplified version (num or Complex)
    return roundedComplex.simplify();
  }

  /// Returns the real portion of this complex number, truncated to an Integer.
  int truncate() => real.truncate();

  /// Returns the complex number with both parts truncated to integers.
  ///
  /// Example:
  /// ```dart
  /// Complex(3.7, 2.9).truncateToComplex()  // 3 + 2i
  /// ```
  Complex truncateToComplex() {
    return Complex(real.truncateToDouble(), imaginary.truncateToDouble());
  }

  /// The remainder method operates on the real portion of this Complex number only.
  num remainder(dynamic divisor) => real.remainder(divisor);

  /// Returns the distance between this complex number and another in the complex plane.
  ///
  /// Example:
  /// ```dart
  /// Complex(1, 2).distanceTo(Complex(4, 6))  // 5.0
  /// ```
  num distanceTo(Complex other) {
    return (this - other).abs();
  }

  /// Checks if this complex number lies within a circle centered at the given point
  /// with the specified radius.
  ///
  /// Example:
  /// ```dart
  /// Complex(2, 3).isWithinCircle(Complex(0, 0), 5)  // true
  /// ```
  bool isWithinCircle(Complex center, num radius) {
    return distanceTo(center) <= radius;
  }

  /// Returns the minimum of two complex numbers based on their magnitudes.
  ///
  /// Example:
  /// ```dart
  /// Complex.min(Complex(3, 4), Complex(1, 1))  // 1 + 1i
  /// ```
  static Complex min(Complex a, Complex b) {
    return a.abs() <= b.abs() ? a : b;
  }

  /// Returns the maximum of two complex numbers based on their magnitudes.
  ///
  /// Example:
  /// ```dart
  /// Complex.max(Complex(3, 4), Complex(1, 1))  // 3 + 4i
  /// ```
  static Complex max(Complex a, Complex b) {
    return a.abs() >= b.abs() ? a : b;
  }

  /// Linearly interpolates between two complex numbers.
  ///
  /// Example:
  /// ```dart
  /// Complex.lerp(Complex(1, 1), Complex(3, 3), 0.5)  // 2 + 2i
  /// ```
  static Complex lerp(Complex a, Complex b, num t) {
    if (t <= 0) return a;
    if (t >= 1) return b;
    return a + (b - a) * t;
  }

  /// Clamps this complex number's magnitude between the specified minimum and maximum values.
  Complex clampMagnitude(num min, num max) {
    final mag = abs();
    if (mag < min) {
      return normalize() * min;
    } else if (mag > max) {
      return normalize() * max;
    }
    return this as Complex;
  }

  /// Rotates this complex number by the specified angle in radians.
  ///
  /// Uses the polar form to perform the rotation, which is more numerically stable.
  ///
  /// Example:
  /// ```dart
  /// var z = Complex(1, 0);
  /// var rotated = z.rotate(math.pi/2);  // Rotates 90 degrees to 0 + 1i
  /// ```
  Complex rotate(num angleRadians) {
    final mag = abs();
    final newAngle = argument + angleRadians;
    return Complex.polar(mag, newAngle);
  }

  /// Returns a complex number with the same magnitude but opposite phase.
  Complex flipPhase() {
    return Complex.polar(abs(), argument + math.pi);
  }
}
