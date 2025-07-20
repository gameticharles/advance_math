part of '../complex.dart';

/// A collection of hyperbolic functions for [Complex]
extension ComplexHyperbolicX<T extends Complex> on T {
  /// Returns a new Complex number representing the hyperbolic sine of this number.
  ///
  /// Compute the [hyperbolic sine](http://mathworld.wolfram.com/HyperbolicSine.html)
  /// of this complex number.
  ///
  /// Implements the formula:
  ///
  ///     sinh(a + bi) = sinh(a)cos(b)) + cosh(a)sin(b)i
  ///
  /// where the (real) functions on the right-hand side are
  /// [math.sin], [math.cos], [math.cosh] and [math.sinh].
  ///
  /// Returns [nan] if either real or imaginary part of the
  /// input argument is `NaN`.
  ///
  /// Infinite values in real or imaginary parts of the input may result in
  /// infinite or NaN values returned in parts of the result.
  ///
  /// Examples:
  ///
  ///     sinh(1 ± INFINITY i) = NaN + NaN i
  ///     sinh(±INFINITY + i) = ± INFINITY + INFINITY i
  ///     sinh(±INFINITY ± INFINITY i) = NaN + NaN i
  ///
  /// ```dart
  /// var z = Complex(0, 0);
  /// var z_sinh = z.sinh();
  ///
  /// print(z_sinh); // Output: 0.0 + 0.0i
  /// ```
  Complex sinh() {
    if (isNaN) return Complex.nan();

    final realPart = math.sinh(real) * math.cos(imaginary);
    final imag = math.cosh(real) * math.sin(imaginary);
    return Complex(realPart, imag);
  }

  /// ## Hyperbolic cosine
  /// Returns a new Complex number representing the hyperbolic cosine of this number.
  ///
  /// Compute the [hyperbolic cosine](http://mathworld.wolfram.com/HyperbolicCosine.html)
  /// of this complex number.
  ///
  /// Implements the formula:
  ///
  ///     cosh(a + bi) = cosh(a)cos(b) + sinh(a)sin(b)i
  ///
  /// where the (real) functions on the right-hand side are
  /// [math.sin], [math.cos], [math.cosh] and [math.sinh].
  ///
  /// Returns [nan] if either real or imaginary part of the
  /// input argument is `NaN`.
  ///
  /// Infinite values in real or imaginary parts of the input may result in
  /// infinite or NaN values returned in parts of the result.
  ///
  /// Examples:
  ///
  ///     cosh(1 ± INFINITY i) = NaN + NaN i
  ///     cosh(±INFINITY + i) = INFINITY ± INFINITY i
  ///     cosh±INFINITY &plusmn; INFINITY i) = NaN + NaN i
  ///
  /// Code:
  /// ```dart
  /// var z = Complex(0, 0);
  /// var z_cosh = z.cosh();
  ///
  /// print(z_cosh); // Output: 1.0 + 0.0i
  /// ```
  Complex cosh() {
    if (isNaN) {
      return Complex.nan();
    }
    final realPart = math.cosh(real) * math.cos(imaginary);
    final imag = math.sinh(real) * math.sin(imaginary);
    return Complex(realPart, imag);
  }

  /// ## Hyperbolic tangent
  /// Returns a new Complex number representing the hyperbolic tangent of this number.
  ///
  /// Compute the [hyperbolic tangent](http://mathworld.wolfram.com/HyperbolicTangent.html)
  /// of this complex number.
  ///
  /// Implements the formula:
  ///
  ///     tan(a + bi) = sinh(2a)/(cosh(2a)+cos(2b)) + [sin(2b)/(cosh(2a)+cos(2b))]i
  ///
  /// where the (real) functions on the right-hand side are
  /// [math.sin], [math.cos], [math.cosh] and [math.sinh].
  ///
  /// Returns [nan] if either real or imaginary part of the
  /// input argument is `NaN`.
  ///
  /// Infinite values in real or imaginary parts of the input may result in
  /// infinite or NaN values returned in parts of the result.
  ///
  /// Examples:
  ///
  ///     tanh(a ± INFINITY i) = NaN + NaN i
  ///     tanh(±INFINITY + bi) = ±1 + 0 i
  ///     tanh(±INFINITY ± INFINITY i) = NaN + NaN i
  ///     tanh(0 + (π/2)i) = NaN + INFINITY i
  ///
  /// Code:
  /// ```dart
  /// var z = Complex(0, 0);
  /// var z_tanh = z.tanh();
  ///
  /// print(z_tanh); // Output: 0.0 + 0.0i
  /// ```
  // Complex tanh() => sinh() / cosh();
  Complex tanh() {
    if (isNaN || imaginary.isInfinite || real.isInfinite) {
      return Complex.nan();
    }

    // Handle infinities: tanh(inf + bi) = ±1 + 0i, tanh(a + inf i) = NaN + NaN i
    if (real.isInfinite) {
      if (real > 0) return Complex.one();
      if (real < 0) return Complex(-1.0, 0.0);
    }

    // Use the optimized formula for regular values
    final real2 = 2.0 * real;
    final imaginary2 = 2.0 * imaginary;
    final d = math.cosh(real2) + math.cos(imaginary2);

    // If denominator is zero, result is infinite in imaginary part
    if (d == 0.0) {
      return Complex(double.nan, math.sin(imaginary2).sign * double.infinity);
    }

    return Complex(math.sinh(real2) / d, math.sin(imaginary2) / d);
  }

  /// Returns the inverse hyperbolic sine
  Complex asinh() {
    return (this + (this * this + Complex.one()).sqrt()).log();
  }

  /// Returns the inverse hyperbolic cosine
  Complex acosh() {
    return (this + ((this + Complex.one()) * (this - Complex.one())).sqrt())
        .log();
  }

  /// Returns the inverse hyperbolic tangent
  Complex atanh() {
    return ((Complex.one() + this) / (Complex.one() - this)).log() *
        Complex(0.5);
  }
}
