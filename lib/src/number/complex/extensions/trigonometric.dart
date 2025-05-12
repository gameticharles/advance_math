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
  /// Returns [nan] if either real or imaginary part of the
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
  /// Returns [nan] if either real or imaginary part of the
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
  /// Returns [nan] if either real or imaginary part of the
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
  /// Returns [nan] if either real or imaginary part of the
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
  /// Returns [nan] if either real or imaginary part of the
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
  /// Returns [nan] if either real or imaginary part of the
  /// input argument is `NaN` or infinite.
  Complex atan() {
    if (isNaN) return Complex.nan();

    return ((this + Complex.i()) / (Complex.i() - this)).log() * 0.5.imag;
  }
}
