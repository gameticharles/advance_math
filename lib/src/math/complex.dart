library complex;

import '/src/math/basic/math.dart' as math;

/// A class representing a complex number with real and imaginary parts.
///
/// The Complex class can perform complex number operations such as addition,
/// subtraction, multiplication, division and also advanced operations such as
/// power, square root, exponential, logarithm, sine, cosine, etc.
///
/// Each complex number is represented with real and imaginary parts.
///
/// Example:
/// ```
/// var z1 = Complex(3, 2); // 3 + 2i
/// var z2 = Complex(1, -1); // 1 - i
///
/// // Conjugate
/// var z1_conj = z1.conjugate(); // 3 - 2i
///
/// // String representation
/// print(z1); // 3 + 2i
/// print(z2); // 1 - i
/// print(z1_conj); // 3 - 2i
///
/// var sum = z1 + z2;
///
/// print(sum); // Output: 4 + i
/// ```
class Complex {
  /// The real part of the complex number.
  final num real;

  /// The imaginary part of the complex number.
  final num imaginary;

  /// Constructs a complex number with the given real and imaginary parts.
  Complex(this.real, this.imaginary);

  /// Constructs a complex number that represents zero.
  Complex.zero() : this(0, 0);

  /// Constructs a complex number that represents one.
  Complex.one() : this(1, 0);

  /// Constructs a complex number that represents the imaginary unit i.
  Complex.i() : this(0, 1);

  /// Constructs a complex number that represents nan.
  Complex.nan() : this(double.nan, double.nan);

  /// Constructs a complex number that represents infinity.
  Complex.infinity() : this(double.infinity, double.infinity);

  /// Constructs a complex number representing "e + 0.0i"
  Complex.e() : this(math.e, 0);

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
      : this(r * math.cos(theta), r * math.sin(theta));

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
  static Complex parse(String s) {
    // Simple parsing implementation, assuming input format a +/- bi
    final hasPlus = s.contains('+');
    final parts = s.split(hasPlus ? '+' : '-');
    final real = num.parse(parts[0].trim());
    final imaginary = num.parse(parts[1].trim().replaceFirst('i', ''));
    return Complex(real, hasPlus ? imaginary : -imaginary);
  }

  /// Returns the complex conjugate of this complex number.
  ///
  /// The complex conjugate of a complex number is the number with the same real part
  /// and the negated imaginary part.
  ///
  /// ```dart
  /// var z = Complex(3, 2);
  /// var z_conj = z.conjugate();
  ///
  /// print(z_conj); // Output: 3 - 2i
  /// ```
  Complex conjugate() => Complex(real, -imaginary);

  /// Returns a new complex number representing this number raised to the power of [exponent].
  ///
  /// ```dart
  /// var z = Complex(2, 3);
  /// var z_power = z.pow(2);
  ///
  /// print(z_power); // Output: -5 + 12i
  /// ```
  Complex pow(num exponent) {
    final r = math.pow(magnitude, exponent);
    final theta = angle * exponent;
    return Complex.fromPolar(r, theta);
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

  /// Returns a new complex number representing the exponential of this number.
  ///
  /// ```dart
  /// var z = Complex(1, pi);
  /// var z_exp = z.exp();
  ///
  /// print(z_exp); // Output: -1.0 + 1.2246467991473532e-16i
  /// ```
  Complex exp() {
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

  /// Returns a new complex number representing the sine of this number.
  ///
  /// ```dart
  /// var z = Complex(pi / 2, 0);
  /// var z_sin = z.sin();
  ///
  /// print(z_sin); // Output: 1.0 + 0.0i
  /// ```
  Complex sin() {
    return Complex(math.sin(real) * math.cosh(imaginary),
        math.cos(real) * math.sinh(imaginary));
  }

  /// Returns a new complex number representing the cosine of this number.
  ///
  /// ```dart
  /// var z = Complex(0, 0);
  /// var z_cos = z.cos();
  ///
  /// print(z_cos); // Output: 1.0 + 0.0i
  /// ```
  Complex cos() {
    return Complex(math.cos(real) * math.cosh(imaginary),
        -math.sin(real) * math.sinh(imaginary));
  }

  /// Returns a new Complex number representing the hyperbolic sine of this number.
  ///
  /// ```dart
  /// var z = Complex(0, 0);
  /// var z_sinh = z.sinh();
  ///
  /// print(z_sinh); // Output: 0.0 + 0.0i
  /// ```
  Complex sinh() => Complex(math.sinh(real) * math.cos(imaginary),
      math.cosh(real) * math.sin(imaginary));

  /// Returns a new Complex number representing the hyperbolic cosine of this number.
  ///
  /// ```dart
  /// var z = Complex(0, 0);
  /// var z_cosh = z.cosh();
  ///
  /// print(z_cosh); // Output: 1.0 + 0.0i
  /// ```
  Complex cosh() => Complex(math.cosh(real) * math.cos(imaginary),
      math.sinh(real) * math.sin(imaginary));

  /// Returns a new Complex number representing the hyperbolic tangent of this number.
  ///
  /// ```dart
  /// var z = Complex(0, 0);
  /// var z_tanh = z.tanh();
  ///
  /// print(z_tanh); // Output: 0.0 + 0.0i
  /// ```
  Complex tanh() => sinh() / cosh();

  Complex operator +(Complex other) {
    return Complex(real + other.real, imaginary + other.imaginary);
  }

  Complex operator -(Complex other) {
    return Complex(real - other.real, imaginary - other.imaginary);
  }

  Complex operator *(Complex other) {
    return Complex(real * other.real - imaginary * other.imaginary,
        real * other.imaginary + imaginary * other.real);
  }

  Complex operator /(Complex other) {
    num denominator =
        other.real * other.real + other.imaginary * other.imaginary;
    if (denominator == 0) {
      throw Exception("Cannot divide by zero.");
    }
    num newReal =
        (real * other.real + imaginary * other.imaginary) / denominator;
    num newImaginary =
        (imaginary * other.real - real * other.imaginary) / denominator;
    return Complex(newReal, newImaginary);
  }

  Complex operator -() {
    if (isNaN) {
      return Complex.nan();
    }

    return Complex(-real, -imaginary);
  }

  /// Determines if the current complex number is equal to the [other].
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Complex &&
        other.real == real &&
        other.imaginary == imaginary;
  }

  @override
  int get hashCode => real.hashCode ^ imaginary.hashCode;

  /// Returns the magnitude (or absolute value) of the complex number.
  ///
  /// ```dart
  /// var z = Complex(3, 4);
  ///
  /// print(z.magnitude); // Output: 5.0
  /// ```
  num get magnitude => math.sqrt(real * real + imaginary * imaginary);

  /// Returns the angle (or argument or phase) in radians of the complex number.
  ///
  /// ```dart
  /// var z = Complex(1, 1);
  ///
  /// print(z.angle); // Output: 0.7853981633974483
  /// ```
  num get angle => math.atan2(imaginary, real);

  /// Returns true if either the real or imaginary part is Not-a-Number (NaN)
  ///
  /// ```dart
  /// var z = Complex(double.nan, 0);
  ///
  /// print(z.isNaN); // Output: true
  /// ```
  bool get isNaN => real.isNaN || imaginary.isNaN;

  /// Returns true if both the real and imaginary parts are finite (i.e., not NaN and not infinite)
  ///
  /// ```dart
  /// var z = Complex(1, 2);
  ///
  /// print(z.isFinite); // Output: true
  /// ```
  bool get isFinite => !isNaN && real.isFinite && imaginary.isFinite;

  /// Returns true if either the real or imaginary part is infinite
  ///
  /// ```dart
  /// var z = Complex(double.infinity, 0);
  ///
  /// print(z.isInfinite); // Output: true
  /// ```
  bool get isInfinite => !isNaN && (real.isInfinite || imaginary.isInfinite);

  /// Returns the string representation of the complex number.
  ///
  /// The string representation is in the form "a + bi" or "a - bi",
  /// where a is the real part and b is the imaginary part.
  @override
  String toString() {
    if (imaginary >= 0) {
      return '$real + ${imaginary}i';
    } else {
      return '$real - ${-imaginary}i';
    }
  }
}
