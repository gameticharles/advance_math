part of 'math.dart';

// Top-level wrappers for special functions that support both num and Complex.

/// Helper to handle return types: if input was num and result is effectively real, return real.
/// Otherwise return Complex.
dynamic _handleResult(Complex result, bool inputWasNum) {
  if (inputWasNum && result.imaginary.abs() < 1e-15) {
    return result.real;
  }
  return result;
}

/// ## Error Function
///
/// Computes the error function erf(z).
/// Supports [num] and [Complex] inputs.
dynamic erf(dynamic x) {
  if (x is Complex) return x.erf();
  if (x is num) return _handleResult(Complex(x).erf(), true);
  throw ArgumentError('erf requires num or Complex');
}

/// ## Complementary Error Function
///
/// Computes the complementary error function erfc(z) = 1 - erf(z).
/// Supports [num] and [Complex] inputs.
dynamic erfc(dynamic x) {
  if (x is Complex) return x.erfc();
  if (x is num) return _handleResult(Complex(x).erfc(), true);
  throw ArgumentError('erfc requires num or Complex');
}

/// ## Gamma Function
///
/// Computes the Gamma function Γ(z).
/// Supports [num] and [Complex] inputs.
dynamic gamma(dynamic x) {
  if (x is Complex) return x.gamma();
  if (x is num) return _handleResult(Complex(x).gamma(), true);
  throw ArgumentError('gamma requires num or Complex');
}

/// ## Log Gamma Function
///
/// Computes the natural logarithm of the Gamma function ln(Γ(z)).
/// Supports [num] and [Complex] inputs.
dynamic lgamma(dynamic x) {
  if (x is Complex) return x.lnGamma();
  if (x is num) return _handleResult(Complex(x).lnGamma(), true);
  throw ArgumentError('lgamma requires num or Complex');
}

/// ## Digamma Function
///
/// Computes the Digamma function ψ(z) = Γ'(z)/Γ(z).
/// Supports [num] and [Complex] inputs.
dynamic digamma(dynamic x) {
  if (x is Complex) return x.digamma();
  if (x is num) return _handleResult(Complex(x).digamma(), true);
  throw ArgumentError('digamma requires num or Complex');
}

/// ## Beta Function
///
/// Computes the Beta function B(x, y) = Γ(x)Γ(y) / Γ(x+y).
/// Supports [num] and [Complex] inputs.
dynamic beta(dynamic x, dynamic y) {
  Complex cx = x is num ? Complex(x) : (x as Complex);
  Complex cy = y is num ? Complex(y) : (y as Complex);
  Complex res = cx.beta(cy);
  return _handleResult(res, x is num && y is num);
}

/// ## Riemann Zeta Function
///
/// Computes the Riemann Zeta function ζ(s).
/// Supports [num] and [Complex] inputs.
dynamic zeta(dynamic s) {
  if (s is Complex) return s.zeta();
  if (s is num) return _handleResult(Complex(s).zeta(), true);
  throw ArgumentError('zeta requires num or Complex');
}

/// ## Precision expm1
///
/// Computes e^x - 1 with precision for small x.
/// Supports [num] and [Complex] inputs.
dynamic expm1(dynamic x) {
  if (x is Complex) return x.expm1();
  if (x is num) return _handleResult(Complex(x).expm1(), true);
  throw ArgumentError('expm1 requires num or Complex');
}

/// ## Precision log1p
///
/// Computes ln(1 + x) with precision for small x.
/// Supports [num] and [Complex] inputs.
dynamic log1p(dynamic x) {
  if (x is Complex) return x.log1p();
  if (x is num) return _handleResult(Complex(x).log1p(), true);
  throw ArgumentError('log1p requires num or Complex');
}
