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
  Complex acos() {
    if (isNaN) return Complex.nan();
    return (this + (sqrt1z() * Complex.i())).log() * (-Complex.i());

    // // acos(z) = pi/2 - asin(z)
    // final asinVal = asin();
    // return Complex(dmath.pi / 2 - asinVal.real, -asinVal.imaginary);
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
  ///
  Complex asin() {
    if (isNaN) return Complex.nan();
    return (sqrt1z() + (this * Complex.i())).log() * -Complex.i();

    // // 1. Calculate 1 - z^2
    // // z^2 = (x^2 - y^2) + i(2xy)
    // // 1 - z^2 = (1 - x^2 + y^2) - i(2xy)
    // final x2 = real * real;
    // final y2 = imaginary * imaginary;
    // final oneMinusZ2Real = 1.0 - x2 + y2;
    // final oneMinusZ2Imag = -2.0 * real * imaginary;

    // // 2. Calculate sqrt(1 - z^2)
    // // Robust local sqrt implementation
    // double sr, si;
    // if (oneMinusZ2Real.isNaN || oneMinusZ2Imag.isNaN) {
    //   sr = double.nan;
    //   si = double.nan;
    // } else {
    //   // Avoid overflow/underflow
    //   final absReal = oneMinusZ2Real.abs();
    //   final absImag = oneMinusZ2Imag.abs();
    //   double w;
    //   if (absReal >= absImag) {
    //     // |oneMinusZ2Real| >= |oneMinusZ2Imag|
    //     final ratio = oneMinusZ2Imag / oneMinusZ2Real;
    //     w = dmath.sqrt(absReal) *
    //         dmath.sqrt((1 + dmath.sqrt(1 + ratio * ratio)) / 2);
    //   } else {
    //     final ratio = oneMinusZ2Real / oneMinusZ2Imag;
    //     w = dmath.sqrt(absImag) *
    //         dmath.sqrt((ratio.abs() + dmath.sqrt(1 + ratio * ratio)) / 2);
    //   }

    //   if (oneMinusZ2Real >= 0) {
    //     sr = w;
    //     si = oneMinusZ2Imag / (2 * w);
    //   } else {
    //     si = (oneMinusZ2Imag >= 0) ? w : -w;
    //     sr = oneMinusZ2Imag / (2 * si);
    //   }
    // }

    // // 3. Calculate iz = -y + ix
    // final izReal = -imaginary;
    // final izImag = real;

    // // 4. Calculate iz + sqrt(1 - z^2)
    // final sumReal = izReal + sr;
    // final sumImag = izImag + si;

    // // 5. Calculate log(sum)
    // // log(w) = log|w| + i*arg(w)
    // // Robust hypot
    // double sumAbs;
    // final absSumReal = sumReal.abs();
    // final absSumImag = sumImag.abs();
    // if (absSumReal > absSumImag) {
    //   final r = absSumImag / absSumReal;
    //   sumAbs = absSumReal * dmath.sqrt(1 + r * r);
    // } else if (absSumImag == 0) {
    //   sumAbs = 0;
    // } else {
    //   final r = absSumReal / absSumImag;
    //   sumAbs = absSumImag * dmath.sqrt(1 + r * r);
    // }

    // final logReal = dmath.log(sumAbs);
    // final logImag = dmath.atan2(sumImag, sumReal);

    // // 6. Calculate -i * log(sum) = -i * (lr + i*li) = -i*lr + li = li - i*lr
    // return Complex(logImag, -logReal);
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

    //  // 1. Calculate i + z = (x) + i(1+y)
    // final nReal = real;
    // final nImag = 1.0 + imaginary;

    // // 2. Calculate i - z = (-x) + i(1-y)
    // final dReal = -real;
    // final dImag = 1.0 - imaginary;

    // // 3. Divide n / d
    // // (a+bi)/(c+di) = (ac+bd)/(c^2+d^2) + i(bc-ad)/(c^2+d^2)
    // final denom = dReal * dReal + dImag * dImag;
    // final qReal = (nReal * dReal + nImag * dImag) / denom;
    // final qImag = (nImag * dReal - nReal * dImag) / denom;

    // // 4. log(q)
    // // Robust hypot for log abs
    // double qAbs;
    // final absQReal = qReal.abs();
    // final absQImag = qImag.abs();
    // if (absQReal > absQImag) {
    //   final r = absQImag / absQReal;
    //   qAbs = absQReal * dmath.sqrt(1 + r * r);
    // } else if (absQImag == 0) {
    //   qAbs = 0;
    // } else {
    //   final r = absQReal / absQImag;
    //   qAbs = absQImag * dmath.sqrt(1 + r * r);
    // }

    // final logReal = dmath.log(qAbs);
    // final logImag = dmath.atan2(qImag, qReal);

    // // 5. Multiply by i/2 = 0 + 0.5i
    // // (lr + i*li) * 0.5i = 0.5i*lr - 0.5*li
    // // = -0.5*li + i(0.5*lr)
    // return Complex(-0.5 * logImag, 0.5 * logReal);
  }

  // ============================================================
  // Alias methods for inverse trigonometric functions
  // ============================================================

  /// Alias for [asin]. Computes the inverse sine of this complex number.
  Complex arcsin() => asin();

  /// Alias for [acos]. Computes the i snverse cosine of this complex number.
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
