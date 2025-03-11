import '../../math/basic/math.dart' as math;
import 'package:advance_math/src/number/util/jenkins_hash.dart';

part 'extensions/num.dart';
part 'extensions/trigonometric.dart';
part 'extensions/hyperbolic.dart';
part 'extensions/operations.dart';

/// A class representing complex numbers in the form a + bi, where a is the real part
/// and b is the imaginary part.
///
/// Complex numbers are numbers that can be expressed in the form a + bi, where
/// a and b are real numbers, and i is the imaginary unit, satisfying i² = −1.
///
/// This class provides:
/// * Basic arithmetic operations (+, -, *, /)
/// * Trigonometric operations (sin, cos, tan, etc.)
/// * Exponential and logarithmic functions
/// * Conversion between different formats (polar, exponential)
/// * Special values handling (infinity, NaN)
///
/// Example:
/// ```dart
/// // Create a complex number
/// var z1 = Complex(2, 3);  // 2 + 3i
/// var z2 = Complex.parse('1 + i');  // 1 + i
///
/// // Perform operations
/// var sum = z1 + z2;  // 3 + 4i
/// var product = z1 * z2;  // -1 + 5i
///
/// // Convert to different formats
/// print(z1.toPolarString());  // Shows polar form
/// print(z1.toExponentialString());  // Shows exponential form
/// ```
class Complex extends Object {
  /// The real part of the complex number
  final num real;

  /// The imaginary part of the complex number
  final num imaginary;

  /// Creates a complex number from real and imaginary parts.
  ///
  /// The [realValue] represents the real part and [imaginaryValue] represents
  /// the coefficient of the imaginary part (defaults to 0).
  ///
  /// Both parameters can be:
  /// * num (int or double)
  /// * String (will be parsed)
  /// * Complex (will be resolved)
  ///
  /// Example:
  /// ```dart
  /// var z1 = Complex(2, 3);      // 2 + 3i
  /// var z2 = Complex('1 + i');   // 1 + i
  /// var z3 = Complex(z1, z2);    // Complex combination
  /// ```
  Complex(dynamic realValue, [dynamic imaginaryValue = 0])
      : real = _resolveReal(realValue, imaginaryValue),
        imaginary = _resolveImaginary(realValue, imaginaryValue);

  static num _resolveReal(dynamic real, dynamic imag) {
    if (real is String && imag is String) {
      final parsedReal = _parseComponent(real);
      final parsedImag = _parseComponent(imag);
      return parsedReal.real - parsedImag.imaginary;
    }
    if (real is String) {
      // Special cases for pure imaginary
      if (real == 'i' || real == '-i') return 0;
      final parsed = _parseComponent(real);
      return parsed.real;
    }
    final realPart = real is Complex ? real.real : real as num;
    final imagImag = imag is Complex 
        ? imag.imaginary 
        : (imag is String ? _parseComponent(imag).imaginary : 0);
    return realPart - imagImag;
  }

  static num _resolveImaginary(dynamic real, dynamic imag) {
    if (real is String && imag is String) {
      final parsedReal = _parseComponent(real);
      final parsedImag = _parseComponent(imag);
      return parsedReal.imaginary + parsedImag.real;
    }
    if (real is String) {
      // Special cases for pure imaginary
      if (real == 'i') return 1;
      if (real == '-i') return -1;
      final parsed = _parseComponent(real);
      return parsed.imaginary;
    }
    final realImag = real is Complex ? real.imaginary : 0;
    final imagPart = imag is Complex 
        ? imag.real 
        : (imag is String ? _parseComponent(imag).real : imag as num);
    return realImag + imagPart;
  }

  /// Parses a complex number from the given string.
  ///
  /// The string must be in the format "a + bi" or "a - bi", where
  /// a is the real part and b is the imaginary part.
  ///
  /// ```dart
  /// var z = Complex.parse('2 + 2i');
  ///
  /// print(z); // Output: 2 + 2i
  ///
  /// Complex c4 = Complex.parse('-5 - 6i'); // -5-6i
  /// print(Complex.parse('7+0i'));     // 7
  /// print(Complex.parse('-7+5i'));    // -7
  /// print(Complex.parse('7'));        // 7
  /// print(Complex.parse('-7'));       // -7
  /// print(Complex.parse('0.5'));      // 0.5
  /// print(Complex.parse('-0.5'));     // -0.5
  /// print(Complex.parse('0.5i'));     // 0.5i
  /// print(Complex.parse('-0.5i'));    // -0.5i
  /// print(Complex.parse('0.5+0.5i')); // 0.5 + 0.5i
  /// print(Complex.parse('i'));        // 1i
  /// print(Complex.parse('-i'));       // -1i
  factory Complex.parse(String s) {
    return _parseComponent(s);
  }

  static Complex _parseComponent(String s) {
    // Replace mathematical constants and handle special cases first
    s = s
        .replaceAll(' ', '')
        .toLowerCase()
        // Handle mathematical constants with coefficients
        .replaceAllMapped(RegExp(r'(\d*\.?\d*)(π|pi)'), (m) {
          final coef = m.group(1)?.isEmpty ?? true ? '1' : m.group(1)!;
          return (double.parse(coef) * math.pi).toString();
        })
        .replaceAllMapped(RegExp(r'(?<![\d.])e(?!\d)'), (m) => math.e.toString())
        // Handle square roots
        .replaceAllMapped(RegExp(r'√(\d+(?:\.\d+)?)'), (match) {
          final number = double.parse(match.group(1)!);
          return '${math.sqrt(number)}';
        });

    // Handle pure imaginary cases
    if (s == 'i') return Complex(0, 1);
    if (s == '-i') return Complex(0, -1);

    // Split into real and imaginary components, preserving scientific notation
    final parts = s.split(RegExp(r'(?<![eE])(?<![eE][+-])(?=[+-])'));
    num real = 0;
    num imaginary = 0;

    for (final part in parts) {
      if (part.isEmpty) continue;

      if (part.contains('i')) {
        imaginary += _parseNumber(part.replaceAll('i', ''));
      } else {
        real += _parseNumber(part);
      }
    }

    return Complex(real, imaginary);
  }


  static num _parseNumber(String s) {
    if (s.isEmpty || s == '+') return 1;
    if (s == '-') return -1;

    // Handle fractions
    if (s.contains('/')) {
      final parts = s.split('/');
      if (parts.length == 2) {
        final num = _parseNumber(parts[0]);
        final den = _parseNumber(parts[1]);
        return num / den;
      }
    }

    // Handle scientific notation with optional sign after 'e'
    final scientificMatch = RegExp(r'^([+-]?\d*\.?\d+)(?:[eE]([+-]?\d+))?$').firstMatch(s);
    if (scientificMatch != null) {
      final base = double.parse(scientificMatch.group(1)!);
      final exp = scientificMatch.group(2);
      if (exp != null) {
        return base * math.pow(10, int.parse(exp));
      }
      return base;
    }

    // If all else fails, try direct parsing
    try {
      return num.parse(s);
    } catch (_) {
      throw FormatException('Invalid number format: $s');
    }
  }

  const Complex.constant(this.real, this.imaginary);

  Complex.fromReal(this.real) : imaginary = 0;
  Complex.fromImaginary(this.imaginary) : real = 0;

  /// Creates a random complex number within specified bounds.
  ///
  /// Parameters:
  /// * [minReal] - minimum value for real part (default: -1)
  /// * [maxReal] - maximum value for real part (default: 1)
  /// * [minImag] - minimum value for imaginary part (default: -1)
  /// * [maxImag] - maximum value for imaginary part (default: 1)
  ///
  /// Example:
  /// ```dart
  /// var z = Complex.random();  // Random complex number in unit square
  /// var z2 = Complex.random(minReal: 0, maxReal: 10);  // Custom bounds
  /// ```
  factory Complex.random({num minReal = -1, num maxReal = 1, 
                        num minImag = -1, num maxImag = 1}) {
    final random = math.Random();
    final real = minReal + (maxReal - minReal) * random.nextDouble();
    final imag = minImag + (maxImag - minImag) * random.nextDouble();
    return Complex(real, imag);
  }

    /// Creates a complex number from a 2x2 matrix
  factory Complex.fromMatrix(List<List<num>> matrix) {
    if (matrix.length != 2 || matrix[0].length != 2) {
      throw ArgumentError('Matrix must be 2x2');
    }
    if (matrix[0][1] != -matrix[1][0]) {
      throw ArgumentError('Invalid complex number matrix');
    }
    return Complex(matrix[0][0], matrix[1][0]);
  }


  /// Constructs a complex number that represents zero.
  Complex.zero()
      : real = 0,
        imaginary = 0;

  /// Constructs a complex number that represents one.
  Complex.one()
      : real = 1,
        imaginary = 0;

  /// Constructs a complex number that represents the imaginary unit i.
  Complex.i()
      : real = 0,
        imaginary = 1;

  /// Constructs a complex number that represents nan.
  Complex.nan()
      : real = double.nan,
        imaginary = double.nan;

  /// Constructs a complex number that represents infinity.
  Complex.infinity()
      : real = double.infinity,
        imaginary = double.infinity;

  /// Constructs a complex number representing "e + 0.0i"
  Complex.e()
      : real = math.e,
        imaginary = 0;

  // Constants
  // static const zero = Complex.constant(0, 0);
  // static const one = Complex.constant(1, 0);
  // static const i = Complex.constant(0, 1);
  // static const nan = Complex.constant(double.nan, double.nan);
  // static const infinity = Complex.constant(double.infinity, double.infinity);
  static const positiveInfinity = Complex.constant(double.infinity, 0);
  static const negativeInfinity = Complex.constant(double.negativeInfinity, 0);
  static const imaginaryInfinity = Complex.constant(0, double.infinity);
  static const imaginaryNegativeInfinity =
      Complex.constant(0, double.negativeInfinity);
  static const imaginaryNaN = Complex.constant(0, double.nan);
  static const realNaN = Complex.constant(double.nan, 0);

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
  Complex.polar(num r, num theta)
      : real = r * math.cos(theta),
        imaginary = r * math.sin(theta);

  /// Computes the complex n-th root of this object. The returned root is the
  /// one with the smallest positive argument.
  factory Complex.nthRootFromValue(double x, int n) {
    if (x >= 0) {
      return Complex(math.pow(x, 1.0 / n), 0);
    } else {
      return Complex(math.pow(-x, 1.0 / n), 0);
    }
  }

  /// Creates a [Complex] number from a JSON map.
  ///
  /// The JSON map should have the following keys:
  /// - 'real': the real part of the complex number
  /// - 'imaginary': the imaginary part of the complex number
  ///
  /// This factory method is useful for deserializing [Complex] numbers from JSON data.
  factory Complex.fromJson(Map<String, dynamic> json) =>
      Complex(json['real'], json['imaginary']);

  /// Converts the complex number to a JSON map.
  Map<String, dynamic> toJson() => {'real': real, 'imaginary': imaginary};

  /// Converts the complex number to its polar representation.
  ///
  /// The returned map contains the following keys:
  /// - 'r': the modulus (magnitude) of the complex number
  /// - 'theta': the argument (angle) of the complex number in radians
  Map<String, num> toPolar() => {
        'r': modulus,
        'theta': argument,
      };

  /// Returns true if this complex number is approximately equal to [other].
  ///
  /// Two complex numbers are considered approximately equal if both their real and
  /// imaginary parts differ by less than [tolerance].
  ///
  /// Example:
  /// ```dart
  /// var z1 = Complex(1.0000001, 2);
  /// var z2 = Complex(1, 2);
  /// print(z1.equals(z2));  // true (with default tolerance)
  /// ```
  bool equals(Complex other, {double tolerance = 1e-10}) =>
      (real - other.real).abs() < tolerance &&
      (imaginary - other.imaginary).abs() < tolerance;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    // If complex can be simplified to a number, compare that way
    if (isSimplifiable) {
      if (other is num) {
        return real == other;
      }
    }

    if (other is Complex) {
      // Special handling for NaN cases
      if (isNaN && other.isNaN) return true;

      // Regular equality
      return real == other.real && imaginary == other.imaginary;
    }

    // Comparing with a numeric value
    if (other is num) return imaginary == 0 && real == other;
    return false;
  }

    @override
    int get hashCode {
      if (isImaginary) {
        return real.hashCode;
      } else {
        if (real == 0) {
          return hashObjects(<Object>[0, imaginary]);
        }
        return hashObjects(<Object>[real, imaginary]);
      }
    }

  // Properties and utility methods

  /// Returns the conjugate of this Complex number (the sign of the imaginary component is flipped).
  Complex get conjugate => Complex(real, -imaginary);

  num get modulus => abs();

  /// Complex modulus represents the magnitude of this complex number in the complex plane.
  /// Synonymous with abs().
  num get complexModulus {
    final value = math.sqrt(real * real + imaginary * imaginary) as num;
    return value.toInt() == value ? value.toInt() : value.toDouble();
  }

  /// Complex norm is synonymous with complex modulus and abs().
  num get complexNorm => complexModulus;

  /// Returns the absolute square of this Complex number.
  num get absoluteSquare => complexModulus * complexModulus;

  /// In radians.
  dynamic get complexArgument => math.atan2(imaginary, real);

  /// Phase is synonymous with complex argument.
  dynamic get phase => complexArgument;

  /// Returns the magnitude or radius (or absolute value) of the complex number.
  ///
  /// ```dart
  /// var z = Complex(3, 4);
  ///
  /// print(z.magnitude); // Output: 5.0
  /// ```
  dynamic get magnitude => complexModulus;

  /// Returns the magnitude or radius of the complex number.
  ///
  ///
  /// var z = Complex(3, 4);
  ///
  /// print(z.radius); // Output: 5.0
  ///
  dynamic get radius => complexModulus;

  /// Returns the angle (or argument or phase) in radians of the complex number.
  ///
  /// ```dart
  /// var z = Complex(1, 1);
  ///
  /// print(z.angle); // Output: 0.7853981633974483
  /// ```
  dynamic get angle => complexArgument;

  /// Returns the angle (or argument or phase) in radians of the complex number.
  ///
  /// ```dart
  /// var z = Complex(1, 1);
  ///
  /// print(z.angle); // Output: 0.7853981633974483
  /// ```
  dynamic get argument => angle;

  /// Returns the reciprocal of this complex number.
  ///
  /// The reciprocal of a complex number `z = a + bi` is `1/z = a/(a^2 + b^2) - bi/(a^2 + b^2)`.
  Complex get reciprocal => ~this;

  /// Returns `true` if either the real or imaginary part of this complex number is NaN (Not a Number).
  bool get isNaN => real.isNaN || imaginary.isNaN;

  /// Returns `true` if either the real or imaginary part of this complex number is infinite.
  bool get isInfinite => real.isInfinite || imaginary.isInfinite;

  /// Returns `true` if both the real and imaginary parts of this complex number are finite.
  bool get isFinite => real.isFinite && imaginary.isFinite;

  /// Returns `true` if both the real and imaginary parts of this complex number are zero.
  bool get isZero => real == 0 && imaginary == 0;

  // Method to check if this complex number can be simplified to a basic number
  // bool get isSimplifiable => (imaginary.abs() < 1e-15) && !real.isNaN;
  bool get isSimplifiable => imaginary == 0 && !real.isNaN;

  // Method to simplify to int if possible
  dynamic simplify() {
    if (!isSimplifiable) return this;

    // Handle special values first
    if (real.isNaN) return double.nan;
    if (real.isInfinite) {
      return real.isNegative ? double.negativeInfinity : double.infinity;
    }

    // Handle exact integer representation
    if (_isExactInteger(real)) {
      try {
        return real.truncate(); // Use truncate instead of toInt() for safety
      } catch (_) {
        // Fallback for numbers that can't be represented as integers
        return real;
      }
    }

    // Handle decimal representations
    return _safeToDouble(real);
  }

  bool _isExactInteger(num value) {
    if (value.isInfinite || value.isNaN) return false;

    // Check for integer value with multiple validation methods
    return value == value.truncateToDouble() &&
        value == value.roundToDouble() &&
        value.toStringAsExponential().contains('e+0');
  }

  num _safeToDouble(num value) {
    // Handle platform-specific edge cases
    if (value == -0.0) return 0.0; // Normalize negative zero
    if (value.abs() < 1e-15) return 0.0; // Handle microscopic values as zero

    // Handle numbers that lost precision in double representation
    final asInt = value.toInt();
    if (asInt.toDouble() == value) return asInt.toDouble();

    return value;
  }

  // Dynamic value accessor that automatically simplifies
  dynamic get value => simplify();

  bool get isReal => imaginary == 0;
  bool get isImaginary => real == 0;

  double toDouble() {
    if (!isReal) throw StateError('Complex number has non-zero imaginary part');
    return real.toDouble();
  }

  int toInt() {
    if (!isReal) throw StateError('Complex number has non-zero imaginary part');
    if (real != real.roundToDouble()) {
      throw StateError('Complex number has non-integer real part');
    }
    return real.toInt();
  }

  Complex copyWith({
    num? real,
    num? imaginary,
  }) =>
      Complex(
        real ?? this.real,
        imaginary ?? this.imaginary,
      );

  /// When a value is a whole number, it's printed without the fractional part.
  /// For example, `_fixZero(5.0)` returns `"5"`.
  String _fixZero(num value) {
    if (value is int) return value.toString();

    // Handle double values
    final doubleValue = value.toDouble();
    if (doubleValue.isNaN || doubleValue.isInfinite) {
      return doubleValue.toString();
    }

    // Check for integer value with precision tolerance
    if (doubleValue.truncateToDouble() == doubleValue) {
      return doubleValue.truncate().toString();
    }

    // Handle numbers very close to zero
    if (doubleValue.abs() < 1e-12) return '0';

    // Remove trailing .0 for whole numbers
    final stringValue = doubleValue.toString();
    return stringValue.endsWith('.0')
        ? stringValue.substring(0, stringValue.length - 2)
        : stringValue;
  }

  @override
  String toString({bool asFraction = false, int? fractionDigits}) =>
      _convertToString(asFraction: asFraction, fractionDigits: fractionDigits);

  String toStringAsFixed(int fractionDigits) =>
      _convertToString(fractionDigits: fractionDigits);

  String toStringAsFraction() => _convertToString(asFraction: true);

  String _convertToString({bool asFraction = false, int? fractionDigits}) {
    final simplified = simplify();
    if (simplified is num) {
      return _formatSimplifiedNumber(simplified,
          asFraction: asFraction, fractionDigits: fractionDigits);
    }

    if (isNaN || isInfinite) {
      return _formatSpecialCases(
          asFraction: asFraction, fractionDigits: fractionDigits);
    }

    return _formatComplexNumber(
        asFraction: asFraction, fractionDigits: fractionDigits);
  }

  String _formatSimplifiedNumber(num value,
      {bool asFraction = false, int? fractionDigits}) {
    if (value.isNaN) return 'NaN';
    if (value.isInfinite) {
      return value.isNegative ? '-Infinity' : 'Infinity';
    }
    return _formatValue(value,
        asFraction: asFraction, fractionDigits: fractionDigits);
  }

  String _formatSpecialCases({bool asFraction = false, int? fractionDigits}) {
    final realPart = _formatComponent(real,
        isImaginary: false,
        asFraction: asFraction,
        fractionDigits: fractionDigits);
    final imagPart = _formatComponent(imaginary,
        isImaginary: true,
        asFraction: asFraction,
        fractionDigits: fractionDigits);

    if (isReal) return realPart;
    if (isImaginary) return imagPart;

    final sign = imaginary.isNegative ? '-' : '+';
    return '$realPart $sign ${imagPart.replaceFirst('-', '')}';
  }

  String _formatComplexNumber({bool asFraction = false, int? fractionDigits}) {
  // Handle pure imaginary cases
  if (real == 0) {
    if (imaginary == 1) return 'i';
    if (imaginary == -1) return '-i';
    return imaginary > 0 
        ? '${_formatValue(imaginary, asFraction: asFraction, fractionDigits: fractionDigits)}i'
        : '-${_formatValue(imaginary.abs(), asFraction: asFraction, fractionDigits: fractionDigits)}i';
  }

  // Handle pure real cases
  if (imaginary == 0) {
    return _formatValue(real, asFraction: asFraction, fractionDigits: fractionDigits);
  }

  // Handle complex numbers with both parts
  final realFormatted = _formatValue(real, asFraction: asFraction, fractionDigits: fractionDigits);
  final imagValue = imaginary.abs();
  final imagFormatted = imagValue == 1 ? 'i' : '${_formatValue(imagValue, asFraction: asFraction, fractionDigits: fractionDigits)}i';

  final sign = imaginary < 0 ? '-' : '+';
  return '$realFormatted $sign $imagFormatted';
}

  String _formatComponent(num value,
      {required bool isImaginary,
      bool asFraction = false,
      int? fractionDigits}) {
    if (value.isNaN) return isImaginary ? 'NaNi' : 'NaN';
    if (value.isInfinite) {
      final prefix = value.isNegative ? '-' : '';
      return isImaginary ? '${prefix}Infinityi' : '${prefix}Infinity';
    }
    final formattedValue = _formatValue(value,
        asFraction: asFraction, fractionDigits: fractionDigits);
    return isImaginary
        ? _formatImaginary(value, formattedValue)
        : formattedValue;
  }

  String _formatImaginary(num originalValue, String formattedValue) {
    if (originalValue == 1) return 'i';
    if (originalValue == -1) return '-i';
    return '${formattedValue}i';
  }

  String _formatValue(num value,
      {bool asFraction = false, int? fractionDigits}) {
    if (asFraction) return _toFractionString(value.toDouble());
    if (fractionDigits != null) return value.toStringAsFixed(fractionDigits);
    return _fixZero(value);
  }

  String _toFractionString(double value, {double precision = 1e-6}) {
    if (value == 0) return '0';
    bool negative = value < 0;
    value = value.abs();

    int wholePart = value.truncate();
    double fractional = value - wholePart;

    if (fractional < precision) {
      return '${negative ? '-' : ''}$wholePart';
    }

    double a = fractional;
    double h1 = 1, h2 = 0;
    double k1 = 0, k2 = 1;

    for (int i = 0; i < 100; i++) {
      final n = a.floor();
      final aNext = 1 / (a - n);
      final h = n * h1 + h2;
      final k = n * k1 + k2;

      if (a - n < precision) break;

      h2 = h1;
      h1 = h;
      k2 = k1;
      k1 = k;
      a = aNext;
    }

    String result = '';
    if (wholePart != 0) result += '$wholePart ';
    if (k1 == 0) return result.trim();
    result += '${h1.round()}/${k1.round()}';
    return negative ? '-$result' : result;
  }

  /// Prints the complex number with opening and closing parenthesis in case the
  /// complex number had both real and imaginary part.
  String toStringWithParenthesis() {
    if (real == 0) {
      return '${_fixZero(imaginary)}i';
    }

    if (imaginary == 0) {
      return _fixZero(real);
    }

    return '($this)';
  }

  /// Returns the complex number in exponential form
  String toExponentialString() {
    final r = abs();
    final theta = argument;
    return '${r.toStringAsFixed(6)}e^(${theta.toStringAsFixed(6)}i)';
  }

  /// Returns the complex number in polar form
  String toPolarString() {
    final r = abs();
    final theta = argument;
    return '${r.toStringAsFixed(6)}(cos(${theta.toStringAsFixed(6)}) + i⋅sin(${theta.toStringAsFixed(6)}))';
  }
}

class DivisionByZeroError extends Error {}
