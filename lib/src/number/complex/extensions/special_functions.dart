part of '../complex.dart';

/// A collection of special mathematical functions for [Complex]
///
/// This extension provides implementations of advanced mathematical functions
/// including the Gamma function, error functions, and related special functions.
extension ComplexSpecialFunctionsX<T extends Complex> on T {
  // ============================================================
  // Lanczos coefficients for gamma function approximation
  // ============================================================

  /// Lanczos coefficients for the gamma function approximation (g=7)
  static const List<double> _lanczosCoefficients = [
    0.99999999999980993,
    676.5203681218851,
    -1259.1392167224028,
    771.32342877765313,
    -176.61502916214059,
    12.507343278686905,
    -0.13857109526572012,
    9.9843695780195716e-6,
    1.5056327351493116e-7,
  ];

  /// The Lanczos g parameter
  static const double _lanczosG = 7.0;

  // ============================================================
  // Gamma and related functions
  // ============================================================

  /// ## Gamma Function
  ///
  /// Computes the [gamma function](http://mathworld.wolfram.com/GammaFunction.html)
  /// for this complex number using the Lanczos approximation.
  ///
  /// The gamma function extends the factorial function to complex numbers:
  ///
  ///     Γ(n) = (n-1)! for positive integers
  ///     Γ(z+1) = z * Γ(z) for all z
  ///
  /// Returns [Complex.nan] if the input is NaN.
  /// Returns [Complex.infinity] for non-positive integers (poles).
  ///
  /// Example:
  /// ```dart
  /// var z = Complex(4, 0);
  /// var result = z.gamma();
  /// print(result); // Output: 6 + 0i (since Γ(4) = 3! = 6)
  ///
  /// var z2 = Complex(0.5, 0);
  /// var result2 = z2.gamma();
  /// print(result2); // Output: ~1.772 + 0i (√π)
  /// ```
  Complex gamma() {
    if (isNaN) return Complex.nan();

    // Handle special cases for non-positive integers (poles)
    if (real <= 0 && imaginary == 0 && real.truncateToDouble() == real) {
      return Complex.infinity();
    }

    // Use reflection formula for Re(z) < 0.5
    if (real < 0.5) {
      // Γ(z) = π / (sin(πz) * Γ(1-z))
      final piZ = Complex(math.pi, 0) * this;
      final sinPiZ = piZ.sin();
      final oneMinusZ = Complex(1, 0) - this;
      final gammaOneMinusZ = oneMinusZ.gamma();
      return Complex(math.pi, 0) / (sinPiZ * gammaOneMinusZ);
    }

    // Lanczos approximation for Re(z) >= 0.5
    final zMinusOne = this - Complex(1, 0);

    // Compute the sum
    Complex sum = Complex(_lanczosCoefficients[0], 0);
    for (int i = 1; i < _lanczosCoefficients.length; i++) {
      sum = sum +
          Complex(_lanczosCoefficients[i], 0) /
              (zMinusOne + Complex(i.toDouble(), 0));
    }

    // Compute t = z - 1 + g + 0.5
    final t = zMinusOne + Complex(_lanczosG + 0.5, 0);

    // Compute result = sqrt(2π) * t^(z-0.5) * e^(-t) * sum
    final sqrt2Pi = Complex(math.sqrt(2.0 * math.pi), 0);
    final tPower = t.pow(zMinusOne + Complex(0.5, 0));
    final expNegT = (-t).exp();

    return sqrt2Pi * tPower * expNegT * sum;
  }

  /// ## Log Gamma Function
  ///
  /// Computes the natural logarithm of the [gamma function](http://mathworld.wolfram.com/LogGammaFunction.html)
  /// for this complex number.
  ///
  /// This is useful for large values where the gamma function would overflow,
  /// and for computing ratios of gamma functions.
  ///
  /// Returns [Complex.nan] if the input is NaN.
  ///
  /// Example:
  /// ```dart
  /// var z = Complex(100, 0);
  /// var result = z.lnGamma();
  /// print(result); // Output: large positive real number
  /// ```
  Complex lnGamma() {
    if (isNaN) return Complex.nan();

    // Handle non-positive integers (poles)
    if (real <= 0 && imaginary == 0 && real.truncateToDouble() == real) {
      return Complex.infinity();
    }

    // Use reflection formula for Re(z) < 0.5
    if (real < 0.5) {
      // ln(Γ(z)) = ln(π) - ln(sin(πz)) - ln(Γ(1-z))
      final piZ = Complex(math.pi, 0) * this;
      final lnSinPiZ = piZ.sin().log();
      final oneMinusZ = Complex(1, 0) - this;
      final lnGammaOneMinusZ = oneMinusZ.lnGamma();
      return Complex(math.log(math.pi), 0) - lnSinPiZ - lnGammaOneMinusZ;
    }

    // Lanczos approximation for Re(z) >= 0.5
    final zMinusOne = this - Complex(1, 0);

    // Compute the sum
    Complex sum = Complex(_lanczosCoefficients[0], 0);
    for (int i = 1; i < _lanczosCoefficients.length; i++) {
      sum = sum +
          Complex(_lanczosCoefficients[i], 0) /
              (zMinusOne + Complex(i.toDouble(), 0));
    }

    // Compute t = z - 1 + g + 0.5
    final t = zMinusOne + Complex(_lanczosG + 0.5, 0);

    // Compute result = 0.5*ln(2π) + (z-0.5)*ln(t) - t + ln(sum)
    final halfLn2Pi = Complex(0.5 * math.log(2.0 * math.pi), 0);
    final lnT = t.log();
    final lnSum = sum.log();

    return halfLn2Pi + (zMinusOne + Complex(0.5, 0)) * lnT - t + lnSum;
  }

  /// ## Digamma Function (Psi Function)
  ///
  /// Computes the [digamma function](http://mathworld.wolfram.com/DigammaFunction.html)
  /// for this complex number.
  ///
  /// The digamma function is defined as the logarithmic derivative of the gamma function:
  ///
  ///     ψ(z) = d/dz[ln(Γ(z))] = Γ'(z) / Γ(z)
  ///
  /// Returns [Complex.nan] if the input is NaN.
  ///
  /// Example:
  /// ```dart
  /// var z = Complex(1, 0);
  /// var result = z.digamma();
  /// print(result); // Output: ~-0.5772 + 0i (negative Euler-Mascheroni constant)
  /// ```
  Complex digamma() {
    if (isNaN) return Complex.nan();

    // Handle non-positive integers (poles)
    if (real <= 0 && imaginary == 0 && real.truncateToDouble() == real) {
      return Complex.infinity();
    }

    // Use reflection formula for Re(z) < 0.5
    if (real < 0.5) {
      // ψ(z) = ψ(1-z) - π*cot(πz)
      final piZ = Complex(math.pi, 0) * this;
      final cotPiZ = piZ.cot();
      final oneMinusZ = Complex(1, 0) - this;
      return oneMinusZ.digamma() - Complex(math.pi, 0) * cotPiZ;
    }

    // Asymptotic expansion for large values
    Complex z = this;
    Complex result = Complex.zero();

    // Use recurrence relation to shift z to a larger value
    while (z.abs() < 6) {
      result = result - (~z);
      z = z + Complex(1, 0);
    }

    // Asymptotic expansion for large |z|
    // ψ(z) ≈ ln(z) - 1/(2z) - 1/(12z²) + 1/(120z⁴) - 1/(252z⁶) + ...
    result = result + z.log();
    result = result - (~z) * Complex(0.5, 0);

    final z2 = z * z;
    final z4 = z2 * z2;
    final z6 = z4 * z2;

    result = result - (~z2) / Complex(12, 0);
    result = result + (~z4) / Complex(120, 0);
    result = result - (~z6) / Complex(252, 0);

    return result;
  }

  // ============================================================
  // Error functions
  // ============================================================

  /// ## Error Function
  ///
  /// Computes the [error function](http://mathworld.wolfram.com/Erf.html)
  /// for this complex number.
  ///
  /// The error function is defined as:
  ///
  ///     erf(z) = (2/√π) ∫₀ᶻ e^(-t²) dt
  ///
  /// This implementation uses a series expansion for small |z|
  /// and an asymptotic expansion for large |z|.
  ///
  /// Returns [Complex.nan] if the input is NaN.
  ///
  /// Example:
  /// ```dart
  /// var z = Complex(1, 0);
  /// var result = z.erf();
  /// print(result); // Output: ~0.8427 + 0i
  /// ```
  Complex erf() {
    if (isNaN) return Complex.nan();
    if (isZero) return Complex.zero();

    // For small |z|, use the Taylor series expansion
    // erf(z) = (2/√π) * Σ ((-1)^n * z^(2n+1)) / (n! * (2n+1))
    if (abs() < 4.0) {
      final twoOverSqrtPi = Complex(2.0 / math.sqrt(math.pi), 0);
      Complex sum = Complex.zero();
      Complex term = this; // z^1 / 1
      sum = sum + term;

      final zSquared = this * this;

      for (int n = 1; n < 100; n++) {
        term = term * (-zSquared) / Complex(n.toDouble(), 0);
        final nextTerm = term / Complex((2 * n + 1).toDouble(), 0);
        sum = sum + nextTerm;
        if (nextTerm.abs() < 1e-15 * sum.abs()) break;
      }

      return twoOverSqrtPi * sum;
    }

    // For large |z|, use the relation erf(z) = 1 - erfc(z)
    return Complex(1, 0) - erfc();
  }

  /// ## Complementary Error Function
  ///
  /// Computes the [complementary error function](http://mathworld.wolfram.com/Erfc.html)
  /// for this complex number.
  ///
  /// The complementary error function is defined as:
  ///
  ///     erfc(z) = 1 - erf(z) = (2/√π) ∫ᶻ^∞ e^(-t²) dt
  ///
  /// Returns [Complex.nan] if the input is NaN.
  ///
  /// Example:
  /// ```dart
  /// var z = Complex(1, 0);
  /// var result = z.erfc();
  /// print(result); // Output: ~0.1573 + 0i
  /// ```
  Complex erfc() {
    if (isNaN) return Complex.nan();
    if (isZero) return Complex(1, 0);

    // For small |z|, use erfc(z) = 1 - erf(z)
    if (abs() < 4.0) {
      return Complex(1, 0) - _erfTaylor();
    }

    // For large |z| with Re(z) > 0, use continued fraction expansion
    if (real > 0) {
      return _erfcAsymptotic();
    }

    // For Re(z) < 0, use reflection formula: erfc(-z) = 2 - erfc(z)
    return Complex(2, 0) - (-this).erfc();
  }

  /// Taylor series for erf (used internally)
  Complex _erfTaylor() {
    final twoOverSqrtPi = Complex(2.0 / math.sqrt(math.pi), 0);
    Complex sum = Complex.zero();
    Complex term = this;
    sum = sum + term;

    final zSquared = this * this;

    for (int n = 1; n < 100; n++) {
      term = term * (-zSquared) / Complex(n.toDouble(), 0);
      final nextTerm = term / Complex((2 * n + 1).toDouble(), 0);
      sum = sum + nextTerm;
      if (nextTerm.abs() < 1e-15 * sum.abs()) break;
    }

    return twoOverSqrtPi * sum;
  }

  /// Asymptotic expansion for erfc (used internally)
  Complex _erfcAsymptotic() {
    // erfc(z) ≈ (e^(-z²) / (z√π)) * Σ ((-1)^n * (2n-1)!! / (2z²)^n)
    final zSquared = this * this;
    final expNegZSquared = (-zSquared).exp();
    final prefactor = expNegZSquared / (this * Complex(math.sqrt(math.pi), 0));

    Complex sum = Complex(1, 0);
    Complex term = Complex(1, 0);
    final twoZSquared = zSquared * Complex(2, 0);

    for (int n = 1; n <= 20; n++) {
      term = term * Complex(-(2 * n - 1).toDouble(), 0) / twoZSquared;
      sum = sum + term;
      if (term.abs() < 1e-15 * sum.abs()) break;
    }

    return prefactor * sum;
  }
  // ============================================================
  // Beta and Zeta functions
  // ============================================================

  /// ## Beta Function
  ///
  /// Computes the [Beta function](http://mathworld.wolfram.com/BetaFunction.html)
  /// B(z, w) = Γ(z)Γ(w) / Γ(z+w).
  ///
  /// Example:
  /// ```dart
  /// var z = Complex(1, 0);
  /// var w = Complex(2, 0);
  /// print(z.beta(w)); // Output: 0.5 + 0i
  /// ```
  Complex beta(Complex w) {
    if (isNaN || w.isNaN) return Complex.nan();
    return (gamma() * w.gamma()) / (this + w).gamma();
  }

  /// ## Riemann Zeta Function
  ///
  /// Computes the [Riemann Zeta function](http://mathworld.wolfram.com/RiemannZetaFunction.html)
  /// for this complex number.
  ///
  /// Uses the Alternating Zeta function (Dirichlet Eta function) for Re(s) > 0,
  /// and the functional equation for Re(s) < 0.
  ///
  /// Example:
  /// ```dart
  /// var s = Complex(2, 0);
  /// print(s.zeta()); // Output: ~1.645 + 0i (pi^2/6)
  /// ```
  Complex zeta() {
    if (isNaN) return Complex.nan();
    if (real == 1.0 && imaginary == 0.0) return Complex.infinity();

    // Reflection formula for Re(s) < 0
    // ζ(s) = 2^s * π^(s-1) * sin(πs/2) * Γ(1-s) * ζ(1-s)
    if (real < 0) {
      final s = this;
      final oneMinusS = Complex(1, 0) - s;
      final twoPowS = Complex(2, 0).pow(s);
      final piPowSMinus1 = Complex(math.pi, 0).pow(s - Complex(1, 0));
      final sinPiSOver2 = (Complex(math.pi, 0) * s / Complex(2, 0)).sin();
      final gammaOneMinusS = oneMinusS.gamma();
      final zetaOneMinusS = oneMinusS.zeta();

      return twoPowS *
          piPowSMinus1 *
          sinPiSOver2 *
          gammaOneMinusS *
          zetaOneMinusS;
    }

    // For Re(s) >= 0 (and not 1), use Dirichlet Eta function
    // ζ(s) = η(s) / (1 - 2^(1-s))
    // η(s) = Σ (-1)^(n-1) / n^s
    Complex eta = Complex.zero();
    // 1000 iterations for reasonable precision in this generic implementation
    for (int n = 1; n <= 1000; n++) {
      final sign = (n % 2 == 1) ? 1.0 : -1.0;
      final term = Complex(sign, 0) / Complex(n, 0).pow(this);
      eta = eta + term;
      // Basic convergence check
      if (eta.abs() > 1e-10 && term.abs() < 1e-15 * eta.abs() && n > 20) break;
    }

    final oneMinusTwoPowOneMinusS =
        Complex(1, 0) - Complex(2, 0).pow(Complex(1, 0) - this);
    return eta / oneMinusTwoPowOneMinusS;
  }

  // ============================================================
  // Precision Helper Functions
  // ============================================================

  /// ## expm1
  ///
  /// Computes e^z - 1 with high precision for values of z near zero.
  Complex expm1() {
    if (isNaN) return Complex.nan();
    // If z is small, use Taylor series: z + z^2/2! + z^3/3! ...
    if (abs() < 0.1) {
      Complex sum = Complex.zero();
      Complex term = Complex(1, 0);
      for (int n = 1; n < 20; n++) {
        term = term * this / Complex(n, 0);
        sum = sum + term;
      }
      return sum;
    }
    return exp() - Complex(1, 0);
  }

  /// ## log1p
  ///
  /// Computes natural logarithm of (1 + z) with high precision for values of z near zero.
  Complex log1p() {
    if (isNaN) return Complex.nan();
    // log(1+z). If z is small, use Taylor series: z - z^2/2 + z^3/3 ...
    if (abs() < 0.1) {
      Complex sum = Complex.zero();
      Complex term = this; // z
      sum = sum + term;
      Complex zPow = this;

      for (int n = 2; n < 20; n++) {
        zPow = zPow * this;
        Complex nextTerm = zPow / Complex(n, 0);
        if (n % 2 == 0) {
          sum = sum - nextTerm;
        } else {
          sum = sum + nextTerm;
        }
      }
      return sum;
    }
    return (Complex(1, 0) + this).log();
  }
}
