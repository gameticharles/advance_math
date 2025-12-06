part of '../complex.dart';

/// A collection for trigonometric for [Complex]
extension ComplexTrigonometricX<T extends Complex> on T {
  /// ## Sine
  ///
  /// Compute the [sine](http://mathworld.wolfram.com/Sine.html)
  /// of this complex number.
  ///
  /// Implements the formula:
  ///
  ///     sin(a + bi) = sin(a)cosh(b) - cos(a)sinh(b)i
  ///
  /// where the (real) functions on the right-hand side are
  /// [math.sin], [math.cos], [math.cosh] and [math.sinh].
  ///
  /// Returns [Complex.nan] if either real or imaginary part of the
  /// input argument is `NaN`.
  ///
  /// Infinite values in real or imaginary parts of the input may result in
  /// infinite or `NaN` values returned in parts of the result.
  ///
  /// Examples:
  ///
  ///     sin(1 ± INFINITY i) = 1 ± INFINITY i
  ///     sin(±INFINITY + i) = NaN + NaN i
  ///     sin(±INFINITY ± INFINITY i) = NaN + NaN i
  Complex sin() {
    if (isNaN) {
      return Complex.nan();
    }
    final realPart = math.sin(real) * math.cosh(imaginary);
    final imagPart = math.cos(real) * math.sinh(imaginary);
    return Complex(realPart, imagPart);
  }

  /// ## Cosine
  ///
  /// Compute the [cosine](http://mathworld.wolfram.com/Cosine.html)
  /// of this complex number.
  ///
  /// Implements the formula:
  ///
  ///     cos(a + bi) = cos(a)cosh(b) - sin(a)sinh(b)i
  ///
  /// where the (real) functions on the right-hand side are
  /// [math.sin], [math.cos], [math.cosh] and [math.sinh].
  ///
  /// Returns [Complex.nan] if either real or imaginary part of the
  /// input argument is `NaN`.
  ///
  /// Infinite values in real or imaginary parts of the input may result in
  /// infinite or `NaN` values returned in parts of the result.
  ///
  /// Examples:
  ///
  ///     cos(1 ± INFINITY i) = 1 ∓ INFINITY i
  ///     cos(±INFINITY + i) = NaN + NaN i
  ///     cos(±INFINITY ± INFINITY i) = NaN + NaN i
  Complex cos() {
    if (isNaN) return Complex.nan();

    final realPart = math.cos(real) * math.cosh(imaginary);
    final imagPart = -math.sin(real) * math.sinh(imaginary);
    return Complex(realPart, imagPart);
  }

  /// ## Tangent
  ///
  /// Compute the [tangent](http://mathworld.wolfram.com/Tangent.html)
  /// of this complex number.
  ///
  /// Implements the formula:
  ///
  ///     tan(a + bi) = sin(2a)/(cos(2a)+cosh(2b)) + [sinh(2b)/(cos(2a)+cosh(2b))]i
  ///
  /// where the (real) functions on the right-hand side are
  /// [math.sin], [math.cos], [math.cosh] and [math.sinh].
  ///
  /// Returns [Complex.nan] if either real or imaginary part of the
  /// input argument is `NaN`.
  ///
  /// Infinite (or critical) values in real or imaginary parts of the input may
  /// result in infinite or `NaN` values returned in parts of the result.
  ///
  /// Examples:
  ///
  ///     tan(a ± INFINITY i) = 0 ± i
  ///     tan(±INFINITY + bi) = NaN + NaN i
  ///     tan(±INFINITY ± INFINITY i) = NaN + NaN i
  ///     tan(±π/2 + 0 i) = ±INFINITY + NaN i
  Complex tan() {
    if (isNaN || real.isInfinite) {
      return Complex.nan();
    }
    if (imaginary > 20.0) {
      return Complex(0.0, 1.0);
    }
    if (imaginary < -20.0) {
      return Complex(0.0, -1.0);
    }

    final real2 = 2.0 * real;
    final imaginary2 = 2.0 * imaginary;
    final d = math.cos(real2) + math.cosh(imaginary2);

    return Complex(math.sin(real2) / d, math.sinh(imaginary2) / d);
  }

  /// ## Arcsine
  ///
  /// Compute the [inverse sine](http://mathworld.wolfram.com/InverseSine.html)
  /// of this complex number.
  ///
  /// Implements the formula:
  ///
  ///     asin(z) = -i (log(sqrt(1 - z^2) + iz))
  ///
  /// Returns [Complex.nan] if either real or imaginary part of the
  /// input argument is `NaN` or infinite.
  Complex acos() {
    if (isNaN) return Complex.nan();
    return (this + (sqrt1z() * Complex.i())).log() * (-Complex.i());
  }

  /// ## Arccosine
  ///
  /// Compute the [inverse cosine](http://mathworld.wolfram.com/InverseCosine.html)
  /// of this complex number.
  ///
  /// Implements the formula:
  ///
  ///     acos(z) = -i (log(z + i (sqrt(1 - z^2))))
  ///
  /// Returns [Complex.nan] if either real or imaginary part of the
  /// input argument is `NaN` or infinite.
  Complex asin() {
    if (isNaN) return Complex.nan();
    return (sqrt1z() + (this * Complex.i())).log() * -Complex.i();
  }

  /// ## Arctangent
  ///
  /// Compute the [inverse tangent](http://mathworld.wolfram.com/InverseTangent.html)
  /// of this complex number.
  ///
  /// Implements the formula:
  ///
  ///     atan(z) = (i/2) log((i + z)/(i - z))
  ///
  /// Returns [Complex.nan] if either real or imaginary part of the
  /// input argument is `NaN` or infinite.
  Complex atan() {
    if (isNaN) return Complex.nan();

    return ((this + Complex.i()) / (Complex.i() - this)).log() * 0.5.imag;
  }

  // ============================================================
  // Alias methods for inverse trigonometric functions
  // ============================================================

  /// Alias for [asin]. Computes the inverse sine of this complex number.
  Complex arcsin() => asin();

  /// Alias for [acos]. Computes the inverse cosine of this complex number.
  Complex arccos() => acos();

  /// Alias for [atan]. Computes the inverse tangent of this complex number.
  Complex arctan() => atan();

  // ============================================================
  // Reciprocal trigonometric functions
  // ============================================================

  /// ## Secant
  ///
  /// Compute the [secant](http://mathworld.wolfram.com/Secant.html)
  /// of this complex number.
  ///
  /// Implements the formula:
  ///
  ///     sec(z) = 1 / cos(z)
  ///
  /// Returns [Complex.nan] if either real or imaginary part of the
  /// input argument is `NaN`.
  ///
  /// Example:
  /// ```dart
  /// var z = Complex(0, 0);
  /// var z_sec = z.sec();
  /// print(z_sec); // Output: 1 + 0i
  /// ```
  Complex sec() {
    if (isNaN) return Complex.nan();
    final cosZ = cos();
    if (cosZ.isZero) return Complex.infinity();
    return ~cosZ;
  }

  /// ## Cosecant
  ///
  /// Compute the [cosecant](http://mathworld.wolfram.com/Cosecant.html)
  /// of this complex number.
  ///
  /// Implements the formula:
  ///
  ///     csc(z) = 1 / sin(z)
  ///
  /// Returns [Complex.nan] if either real or imaginary part of the
  /// input argument is `NaN`.
  ///
  /// Example:
  /// ```dart
  /// var z = Complex(math.pi / 2, 0);
  /// var z_csc = z.csc();
  /// print(z_csc); // Output: 1 + 0i
  /// ```
  Complex csc() {
    if (isNaN) return Complex.nan();
    final sinZ = sin();
    if (sinZ.isZero) return Complex.infinity();
    return ~sinZ;
  }

  /// ## Cotangent
  ///
  /// Compute the [cotangent](http://mathworld.wolfram.com/Cotangent.html)
  /// of this complex number.
  ///
  /// Implements the formula:
  ///
  ///     cot(z) = 1 / tan(z) = cos(z) / sin(z)
  ///
  /// Returns [Complex.nan] if either real or imaginary part of the
  /// input argument is `NaN`.
  ///
  /// Example:
  /// ```dart
  /// var z = Complex(math.pi / 4, 0);
  /// var z_cot = z.cot();
  /// print(z_cot); // Output: ~1 + 0i
  /// ```
  Complex cot() {
    if (isNaN) return Complex.nan();
    final sinZ = sin();
    if (sinZ.isZero) return Complex.infinity();
    return cos() / sinZ;
  }

  // ============================================================
  // Inverse reciprocal trigonometric functions
  // ============================================================

  /// ## Inverse Secant (Arcsecant)
  ///
  /// Compute the [inverse secant](http://mathworld.wolfram.com/InverseSecant.html)
  /// of this complex number.
  ///
  /// Implements the formula:
  ///
  ///     asec(z) = acos(1/z)
  ///
  /// Returns [Complex.nan] if either real or imaginary part of the
  /// input argument is `NaN`.
  ///
  /// Example:
  /// ```dart
  /// var z = Complex(2, 0);
  /// var z_asec = z.asec();
  /// print(z_asec); // Output: π/3 + 0i
  /// ```
  Complex asec() {
    if (isNaN) return Complex.nan();
    if (isZero) return Complex.infinity();
    return (~this).acos();
  }

  /// Alias for [asec]. Computes the inverse secant of this complex number.
  Complex arcsec() => asec();

  /// ## Inverse Cosecant (Arccosecant)
  ///
  /// Compute the [inverse cosecant](http://mathworld.wolfram.com/InverseCosecant.html)
  /// of this complex number.
  ///
  /// Implements the formula:
  ///
  ///     acsc(z) = asin(1/z)
  ///
  /// Returns [Complex.nan] if either real or imaginary part of the
  /// input argument is `NaN`.
  ///
  /// Example:
  /// ```dart
  /// var z = Complex(2, 0);
  /// var z_acsc = z.acsc();
  /// print(z_acsc); // Output: π/6 + 0i
  /// ```
  Complex acsc() {
    if (isNaN) return Complex.nan();
    if (isZero) return Complex.infinity();
    return (~this).asin();
  }

  /// Alias for [acsc]. Computes the inverse cosecant of this complex number.
  Complex arccsc() => acsc();

  /// ## Inverse Cotangent (Arccotangent)
  ///
  /// Compute the [inverse cotangent](http://mathworld.wolfram.com/InverseCotangent.html)
  /// of this complex number.
  ///
  /// Implements the formula:
  ///
  ///     acot(z) = atan(1/z)
  ///
  /// Returns [Complex.nan] if either real or imaginary part of the
  /// input argument is `NaN`.
  ///
  /// Example:
  /// ```dart
  /// var z = Complex(1, 0);
  /// var z_acot = z.acot();
  /// print(z_acot); // Output: π/4 + 0i
  /// ```
  Complex acot() {
    if (isNaN) return Complex.nan();
    if (isZero) return Complex(math.pi / 2, 0);
    return (~this).atan();
  }

  /// Alias for [acot]. Computes the inverse cotangent of this complex number.
  Complex arccot() => acot();
}
