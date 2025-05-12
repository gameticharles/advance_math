part of 'math.dart';

/// Returns the base-10 logarithm of a number.
///
/// Example 1:
/// ```dart
/// print(log10(100));  // Output: 2.0
/// ```
///
/// Example 2:
/// ```dart
/// print(log10(Complex(1, 2))); // Output: 0.3494850021680094 + 0.480828578784234i
/// ```
dynamic log10(dynamic x) {
  if (x is num || x is Decimal) {
    num nx = x is! num ? (x as Decimal).toDouble(): x;
    return math.log(nx) / math.ln10;
  } else if (x is Complex || x is Imaginary) {
    Complex nx = x is Complex ? x : Complex(0, x);
    Complex lnZ =
        Complex(math.log(nx.magnitude), nx.argument);
    return lnZ / math.log(10);
  } else {
    throw ArgumentError('Input should be either num or Complex');
  }
}

/// Returns the logarithm (base `b`) of `x`.
///
/// If `b` is null, then it returns the natural logarithm of a number.
///
/// Throws an [ArgumentError] if `x` or `b` is less than or equal to 0.
///
/// Example 1:
/// ```dart
/// print(log(100, 10)); // prints: 2.0
/// ```
///
/// Example 2:
/// ```dart
/// print(log(math.e));  // Output: 1.0
/// ```
dynamic log(dynamic x, [dynamic b]) {
  if (x is num || x is Decimal) {
    num nx = x is! num ? (x as Decimal).toDouble() : x;
    if (nx <= 0 || (b != null && b <= 0)) {
      throw ArgumentError('Invalid input for log: n and b must be > 0');
    }
    return b != null ? math.log(nx) / math.log(b) : math.log(nx);
  } else if (x is Complex || x is Imaginary) {
    Complex nx = x is Complex ? x : Complex(0, x);
    Complex lnZ =
        Complex(math.log(nx.magnitude), nx.argument);
    if (b == null) {
      return lnZ;
    } else if (b is num) {
      if (b <= 0) {
        throw ArgumentError('Invalid input for log: b must be > 0');
      }
      return lnZ / math.log(b);
    } else if (b is Complex) {
      return lnZ / log(b);
    } else {
      throw ArgumentError('Invalid base type for log');
    }
  } else {
    throw ArgumentError('Input should be either num or Complex');
  }
}

/// Returns the logarithm of a number to a given base.
/// The logarithm to base b of x is equal to the value y such that b to the power of y is equal to x.
///
/// Example:
/// ```dart
/// print(logBase(10, 100));  // Output: 2.0
/// print(logBase(2, 8));  // Output: 3.0
/// print(logBase(2, 32));  // Output: 5.0
/// ```
///
/// Example 2:
/// ```dart
/// print(logBase(10, Complex(1, 2)));  // Output: 0.3494850021680094 + 0.480828578784234i
/// print(logBase(Complex(2, 2), 2));  // Output: 0.4244610654378757 - 0.32063506912468864i
/// print(logBase(Complex(2, 2), Complex(1, 2)));  // Output: 1.004927367132127 + 0.30573651908857313i
/// ```
dynamic logBase(dynamic base, dynamic x) {
  if ((base is num ||
          base is Decimal) &&
      x is num) {
    num nBase = base is! num ? (base as Decimal).toDouble() : base;
    return math.log(x) / math.log(nBase);
  } else if (base is Complex ||
      x is Complex ||
      base is Imaginary ||
      x is Imaginary) {
    Complex cBase = base is Complex
        ? base
        : base is Imaginary
            ? Complex(0, base)
            : Complex(base, 0);
    Complex cx = x is Complex
        ? x
        : x is Imaginary
            ? Complex(0, x)
            : Complex(x, 0);

    Complex lnBase =
        Complex(math.log(cBase.magnitude), cBase.argument);
    Complex lnX =
        Complex(math.log(cx.magnitude), cx.argument);

    return lnX / lnBase;
  } else {
    throw ArgumentError('Inputs should be either num or Complex');
  }
}
