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
class Complex {
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
    final r = _parseComponent(s);
    return Complex(r.real, r.imaginary);
  }

  /// Computes sqrt(x^2 + y^2) without under/overflow.
  ///
  /// Uses the magnitude (modulo) of [x] and [y].
  static Complex hypot(Complex x, Complex y) {
    var first = x;
    var second = y;

    if (y > x) {
      first = y;
      second = x;
    }

    if (first ==  Complex.zero()) {
      return second;
    }

    final t = second / first;

    return first * ( Complex(1,0) + (t * t));
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
    if (isSimplifiable()) {
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

  /// Compares this complex number with another complex number based on their magnitudes.
  ///
  /// Returns:
  /// - A negative integer if this complex number's magnitude is less than other's magnitude
  /// - Zero if the magnitudes are equal
  /// - A positive integer if this complex number's magnitude is greater than other's magnitude
  ///
  /// Example:
  /// ```dart
  /// Complex(3, 4).compareTo(Complex(1, 2))  // positive (5 > √5)
  /// Complex(1, 1).compareTo(Complex(1, 1))  // zero (√2 = √2)
  /// ```
  int compareTo(Complex other) {
    final thisAbs = abs();
    final otherAbs = other.abs();
    
    if (thisAbs < otherAbs) return -1;
    if (thisAbs > otherAbs) return 1;
    return 0;
  }

  // Properties and utility methods

  /// Returns the conjugate of this Complex number (the sign of the imaginary component is flipped).
  Complex get conjugate => Complex(real, -imaginary);

  num get modulus => abs();

  /// Returns the sign of the complex number.
  /// 
  /// For a complex number z = r * e^(iθ), returns:
  /// - If r = 0: returns 0
  /// - If r > 0: returns 1
  /// - If r < 0: returns -1
  /// 
  /// Example:
  /// ```dart
  /// print(Complex(3, 4).sign);     // 1
  /// print(Complex(-3, -4).sign);   // -1
  /// print(Complex(0, 0).sign);     // 0
  /// ```
  num get sign {
    if (isNaN) return double.nan;
    if (isZero) return 0;
    return real.sign;
  }

  /// Whether the real part of this complex number is negative.
  bool get isNegative => real < 0;

  /// Returns true if this complex number represents an integer value.
  /// 
  /// A complex number is considered an integer if:
  /// 1. Its imaginary part is zero
  /// 2. Its real part is a whole number
  /// 
  /// Example:
  /// ```dart
  /// Complex(2, 0).isInteger      // true
  /// Complex(2.5, 0).isInteger    // false
  /// Complex(2, 1).isInteger      // false
  /// ```
  bool get isInteger => imaginary == 0 && real.truncateToDouble() == real;

  /// The sign of the current object is changed and the result is returned in a
  /// new [Complex] instance.
  Complex get negate => Complex(-real, -imaginary);

  /// Complex modulus represents the magnitude of this complex number in the complex plane.
  /// Synonymous with abs().
  num get complexModulus {
    final value = math.sqrt(real * real + imaginary * imaginary);
    return Complex(value).toNum();
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
  bool isSimplifiable({double relTol = 1e-9, double absTol = 1e-15}) => math.isClose(imaginary.toDouble(), 0.0, relTol: 1e-9, absTol: 1e-15) && 
      !real.isNaN;

  /// Returns the simplified value of this complex number.
  /// 
  /// If the complex number can be simplified to a real number (negligible imaginary part),
  /// returns that number as an int or double. Otherwise, returns the complex number itself.
  /// 
  /// Example:
  /// ```dart
  /// Complex(3, 0).value      // returns 3 (int)
  /// Complex(3.5, 0).value    // returns 3.5 (double)
  /// Complex(3, 4).value      // returns the Complex object
  /// ```
  dynamic get value => simplify();

  /// Returns `true` if this complex number has a zero imaginary part.
  /// 
  /// A complex number is considered real if its imaginary component is exactly zero.
  /// 
  /// Example:
  /// ```dart
  /// Complex(3, 0).isReal     // true
  /// Complex(3, 4).isReal     // false
  /// ```
  bool get isReal => imaginary == 0;

  /// Returns `true` if this complex number has a zero real part.
  /// 
  /// A complex number is considered purely imaginary if its real component is exactly zero.
  /// 
  /// Example:
  /// ```dart
  /// Complex(0, 4).isImaginary    // true
  /// Complex(3, 4).isImaginary    // false
  /// ```
  bool get isImaginary => real == 0;

   /// Returns the complex number with the same phase but unit magnitude.
  ///
  /// Example:
  /// ```dart
  /// Complex(3, 4).normalize()  // 0.6 + 0.8i
  /// ```
  Complex normalize() {
    if (isZero) return Complex.zero();
    if (isNaN) return Complex.nan();
    final mag = abs();
    return Complex(real / mag, imaginary / mag);
  }

  /// Checks if this complex number is approximately equal to zero within the given tolerance.
  ///
  /// Example:
  /// ```dart
  /// Complex(1e-16, 1e-16).isApproximatelyZero()  // true with default tolerance
  /// ```
  bool isApproximatelyZero({double tolerance = 1e-10}) {
    return abs() < tolerance;
  }

  /// Checks if this complex number is approximately equal to another complex number
  /// within the given tolerance for both real and imaginary parts.
  ///
  /// Example:
  /// ```dart
  /// Complex(1.0000001, 2).isApproximatelyEqualTo(Complex(1, 2))  // true with default tolerance
  /// ```
  bool isApproximatelyEqualTo(Complex other, {double tolerance = 1e-10}) {
    return (real - other.real).abs() < tolerance &&
           (imaginary - other.imaginary).abs() < tolerance;
  }

  /// Simplifies this complex number to its most basic form.
  /// 
  /// Returns:
  /// - A `num` (int or double) if the complex number can be simplified to a real number
  /// - The original `Complex` object if it cannot be simplified
  /// 
  /// Uses [isClose] for more robust floating-point comparisons.
  /// [relTol] and [absTol] control the tolerance for considering values as zero.
  /// 
  /// Example:
  /// ```dart
  /// Complex(3, 0).simplify()        // returns 3 (int)
  /// Complex(3.5, 0).simplify()      // returns 3.5 (double)
  /// Complex(3, 1e-16).simplify()    // returns 3 (negligible imaginary part)
  /// Complex(3, 4).simplify()        // returns the Complex object
  /// ```
  dynamic simplify({double relTol = 1e-9, double absTol = 1e-15}) {
    // Check if imaginary part is negligible
    if (!isSimplifiable(relTol: relTol, absTol: absTol)) {
      return this;
    }

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

    /// Converts this complex number to a double.
  /// 
  /// Throws a StateError if the imaginary part is not negligible.
  /// Uses [isClose] for more robust floating-point comparisons.
  /// 
  /// Example:
  /// ```dart
  /// Complex(3.5, 0).toDouble()      // returns 3.5
  /// Complex(3, 1e-16).toDouble()    // returns 3.0 (negligible imaginary part)
  /// Complex(3, 4).toDouble()        // throws StateError
  /// ```
  double toDouble({double relTol = 1e-9, double absTol = 1e-15}) {
    if (!math.isClose(imaginary.toDouble(), 0.0, relTol: relTol, absTol: absTol)) {
      throw StateError('Complex number has non-negligible imaginary part');
    }
    return real.toDouble();
  }

  /// Converts this complex number to an integer.
  /// 
  /// Throws a StateError if:
  /// - The imaginary part is not negligible
  /// - The real part is not close to an integer value
  /// 
  /// Uses [isClose] for more robust floating-point comparisons.
  /// 
  /// Example:
  /// ```dart
  /// Complex(3, 0).toInt()           // returns 3
  /// Complex(3, 1e-16).toInt()       // returns 3 (negligible imaginary part)
  /// Complex(3.5, 0).toInt()         // returns 4 (rounding real part)
  /// Complex(3, 4).toInt()           // throws StateError (non-negligible imaginary part)
  /// ```
  int toInt({double relTol = 1e-9, double absTol = 1e-15}) {
    if (!math.isClose(imaginary.toDouble(), 0.0, relTol: relTol, absTol: absTol)) {
      throw StateError('Complex number has non-negligible imaginary part');
    }
    
    return real.round();
  }

  /// Attempts to convert this complex number to its simplest numeric form.
  /// 
  /// Returns:
  /// - An `int` if the complex number can be simplified to an integer
  /// - A `double` if the complex number can be simplified to a decimal
  /// - The original `Complex` object if it cannot be simplified
  /// 
  /// For complex numbers with non-zero imaginary parts, this method uses the following strategy:
  /// - If imaginary part is negligible, returns the real part
  /// - If real part is negligible, returns the imaginary part
  /// - Otherwise, returns the magnitude with the sign of the real part
  /// 
  /// Example:
  /// ```dart
  /// Complex(3, 0).toNum()        // returns 3 (int)
  /// Complex(3.5, 0).toNum()      // returns 3.5 (double)
  /// Complex(0, 5).toNum()        // returns 5 (int)
  /// Complex(-3, 4).toNum()       // returns -5.0 (double, magnitude with sign)
  /// Complex(3, 1e-16).toNum()    // returns 3 (int, negligible imaginary part)
  /// ```
  dynamic toNum({double relTol = 1e-9, double absTol = 1e-15}) {
    // First check if it's a simple real number
    if (isSimplifiable(relTol: relTol, absTol: absTol)) {
      return simplify(relTol: relTol, absTol: absTol);
    }
    
    // If imaginary part is negligible, return the real part
    if (math.isClose(imaginary.toDouble(), 0.0, relTol: relTol, absTol: absTol)) {
      // Convert to int if it's a whole number
      if (_isExactInteger(real)) {
        return real.toInt();
      }
      return real;
    }
    
    // If real part is negligible, treat as pure imaginary and return the imaginary part
    if (math.isClose(real.toDouble(), 0.0, relTol: relTol, absTol: absTol)) {
      // Convert to int if it's a whole number
      if (_isExactInteger(imaginary)) {
        return imaginary.toInt();
      }
      return imaginary;
    }
    
    // Otherwise, for a full complex number,
    // compute the magnitude and return it with the sign of the real part
    final magnitude = abs();
    final result = real < 0 ? -magnitude : magnitude;
    
    // Convert to int if it's a whole number
    if (_isExactInteger(result)) {
      return result.toInt();
    }
    return result;
  }

  Complex copyWith({
    num? real,
    num? imaginary,
  }) =>
      Complex(
        real ?? this.real,
        imaginary ?? this.imaginary,
      );

    
  // Operations with Complex and num types
  Complex operator +(Object other) {
    if (other is Complex) {
      if (isNaN || other.isNaN) return Complex.nan();
      return Complex(real + other.real, imaginary + other.imaginary);
    }
    if (other is num) return this + Complex(other, 0);
    throw ArgumentError('Invalid type for addition: ${other.runtimeType}');
  }

  Complex operator -(Object other) {
    if (other is Complex) {
      if (isNaN || other.isNaN) return Complex.nan();
      return Complex(real - other.real, imaginary - other.imaginary);
    }
    if (other is num) return this - Complex(other, 0);
    throw ArgumentError('Invalid type for subtraction: ${other.runtimeType}');
  }

  Complex operator *(Object other) {
    if (other is Complex) {
      // Special cases handling for infinity and NaN
      if (isNaN || other.isNaN) return Complex.nan();

      // Handle infinity cases
      if (isInfinite || other.isInfinite) {
        // 0 * inf = NaN
        if ((real == 0 && imaginary == 0) ||
            (other.real == 0 && other.imaginary == 0)) {
          return Complex.nan();
        }

        // Preserve sign information for real components
        final sign = real.sign * other.real.sign;
        return Complex(sign * double.infinity, sign * double.infinity);
      }

      // Normal multiplication
      return Complex(
        real * other.real - imaginary * other.imaginary,
        real * other.imaginary + imaginary * other.real,
      );
    }
    if (other is num) {
      if (other.isNaN) return Complex.nan();
      if (other.isInfinite) {
        if (isZero) return Complex.nan();
        return Complex(
          real.sign * other.sign * double.infinity,
          imaginary.sign * other.sign * double.infinity,
        );
      }
      return Complex(real * other, imaginary * other);
    }
    throw ArgumentError(
        'Invalid type for multiplication: ${other.runtimeType}');
  }

  Complex operator /(Object other) {
    if (other is Complex) {
      // Special cases for NaN and infinity
      if (isNaN || other.isNaN) return Complex.nan();

      // 0/0, inf/inf give NaN
      if (other.isZero) return isZero ? Complex.nan() : Complex.infinity();
      if (isInfinite && other.isInfinite) return Complex.nan();

      // Normal case
      final denominator =
          other.real * other.real + other.imaginary * other.imaginary;
      return Complex(
        (real * other.real + imaginary * other.imaginary) / denominator,
        (imaginary * other.real - real * other.imaginary) / denominator,
      );
    } else if (other is num) {
      // Special cases
      if (other.isNaN) return Complex.nan();
      if (other == 0) return isZero ? Complex.nan() : Complex.infinity();
      if (other.isInfinite) return Complex.zero();

      // Normal case
      return Complex(real / other, imaginary / other);
    }
    throw ArgumentError('Invalid type for division: ${other.runtimeType}');
  }

  ///  The truncating division operator.
  Complex operator ~/(dynamic divisor) {
    if (divisor != 0) {
      if (divisor is num) {
        return Complex(real ~/ divisor, imaginary ~/ divisor);
      }

      if (divisor is Complex) {
        // (a + bi) / (c + di) = (ac + bd) / (c^2 + d^2) + i * (bc - ad) / (c^2 + d^2)
        final c2d2 = (divisor.real * divisor.real) +
            (divisor.imaginary * divisor.imaginary);
        return Complex(
            ((real * divisor.real + imaginary * divisor.imaginary) / c2d2)
                .truncate(),
            ((imaginary * divisor.real - real * divisor.imaginary) / c2d2)
                .truncate());
      }
    }

    // Treat divisor as 0
    return Complex(real < 0 ? double.negativeInfinity : double.infinity,
        imaginary < 0 ? double.negativeInfinity : double.infinity);
  }

  /// The modulo operator (not supported).
  Complex operator %(dynamic divisor) {
    var modulus = magnitude;
    if (divisor is num) {
      var remainder = modulus % divisor;
      return Complex.polar(remainder, phase);
    } else if (divisor is Complex) {
      var otherModulus = divisor.magnitude;
      var remainder = modulus % otherModulus;
      return Complex.polar(remainder, phase);
    }
    return this % divisor;

    // throw const NumberException(
    //       'The number library does not support raising a complex number to an imaginary power');
  }

  Complex operator -() => Complex(-real, -imaginary);

  // Reciprocal operator
  Complex operator ~() {
    if (real == 0 && imaginary == 0) {
      return Complex(double.infinity, double.infinity);
    }
    if (isNaN) return Complex(double.nan, double.nan);
    if (isInfinite) return Complex(0, 0);

    final denominator = real * real + imaginary * imaginary;
    return Complex(real / denominator, -imaginary / denominator);
  }

  /// The power operator (note: NOT bitwise XOR).
  /// In order to provide a convenient power operator for all [Number]s, the number library
  /// overrides the caret operator.  In Dart the caret operator is ordinarily used
  /// for bitwise XOR operations on [int]s.
  Complex operator ^(dynamic exponent) {
    if (exponent is num || exponent is Complex) {
      return pow(exponent);
    }

    return Complex.one();
  }

  /// Returns true if this complex number's magnitude is greater than the magnitude of [obj].
  /// If [obj] is a number, it's treated as a real number (imaginary part = 0).
  ///
  /// Example:
  /// ```dart
  /// Complex(3, 4) > Complex(2, 2)  // true (5 > 2√2)
  /// Complex(3, 4) > 4              // true (5 > 4)
  /// ```
  bool operator >(dynamic obj) {
    if (obj is Complex) return abs() > obj.abs();
    if (obj is num) return abs() > obj.abs();
    throw ArgumentError('Comparison only supported with Complex and num types');
  }

  /// Returns true if this complex number's magnitude is greater than or equal to
  /// the magnitude of [obj].
  /// If [obj] is a number, it's treated as a real number (imaginary part = 0).
  ///
  /// Example:
  /// ```dart
  /// Complex(3, 4) >= Complex(3, 4)  // true (5 = 5)
  /// Complex(3, 4) >= 5              // true (5 = 5)
  /// ```
  bool operator >=(dynamic obj) {
    if (obj is Complex) return abs() >= obj.abs();
    if (obj is num) return abs() >= obj.abs();
    throw ArgumentError('Comparison only supported with Complex and num types');
  }

  /// Returns true if this complex number's magnitude is less than the magnitude of [obj].
  /// If [obj] is a number, it's treated as a real number (imaginary part = 0).
  ///
  /// Example:
  /// ```dart
  /// Complex(1, 1) < Complex(3, 4)  // true (√2 < 5)
  /// Complex(1, 1) < 2              // true (√2 < 2)
  /// ```
  bool operator <(dynamic obj) {
    if (obj is Complex) return abs() < obj.abs();
    if (obj is num) return abs() < obj.abs();
    throw ArgumentError('Comparison only supported with Complex and num types');
  }

  /// Returns true if this complex number's magnitude is less than or equal to
  /// the magnitude of [obj].
  /// If [obj] is a number, it's treated as a real number (imaginary part = 0).
  ///
  /// Example:
  /// ```dart
  /// Complex(1, 1) <= Complex(1, 1)  // true (√2 = √2)
  /// Complex(1, 1) <= 2              // true (√2 < 2)
  /// ```
  bool operator <=(dynamic obj) {
    if (obj is Complex) return abs() <= obj.abs();
    if (obj is num) return abs() <= obj.abs();
    throw ArgumentError('Comparison only supported with Complex and num types');
  }



  /// Computes the n-th roots of the complex number represented by this object.
  ///
  /// The returned list contains the n complex numbers that are the n-th roots of
  /// this complex number. The roots are ordered such that the first root has the
  /// smallest positive argument.
  ///
  /// If `n` is non-positive, an `ArgumentError` is thrown. If this complex number
  /// is NaN or infinite, a list containing a single NaN or infinite complex
  /// number is returned, respectively.
  List<Complex> nthRoot(int n) {
    if (n <= 0) {
      throw ArgumentError("Can't compute nth root for negative n");
    }

    if (isNaN) {
      return [Complex.nan()];
    } else if (isInfinite) {
      return [Complex.infinity()];
    }

    // nth root of abs -- faster / more accurate to use a solver here?
    final nthRootOfAbs = math.pow(abs(), 1.0 / n);

    // Compute nth roots of complex number with k = 0, 1, ... n-1
    final nthPhi = argument / n;
    final slice = 2 * math.pi / n;
    var innerPart = nthPhi;
    return List.generate(n, (_) {
      final c = Complex.polar(nthRootOfAbs, innerPart);
      innerPart += slice;
      return c;
    });
  }

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
  Complex pow(dynamic exponent) {

    // if (exponent is int) {
    //   if (exponent == 0) return Complex.one();
    //   if (exponent < 0) return ~(this ^ (-exponent));
      
    //   var result = Complex.one();
    //   var base = this;
    //   var exp = exponent;
      
    //   while (exp > 0) {
    //     if (exp & 1 == 1) result *= base;
    //     base *= base;
    //     exp >>= 1;
    //   }
    //   return result;
    // }

    // For real (num) exponents, use a simplified polar approach.
    if (exponent is num) {
      final baseVal = magnitude;
      // If the base is nearly zero (use an epsilon threshold)
      if (baseVal.abs() < 1e-15) {
        if (exponent > 0) return Complex(0, 0);
        throw ArgumentError(
            "0 raised to a non-positive exponent is undefined.");
      }
      final r = math.pow(baseVal, exponent);
      final theta = angle * exponent;
      return Complex.polar(r, theta.toDouble());
    }

    final baseVal = magnitude;
    // Check for near-zero base using a small epsilon
    if (baseVal.abs() < 1e-15) {
      if (exponent.real > 0) return Complex(0, 0);
      throw ArgumentError("0 raised to a non-positive exponent is undefined.");
    }

    // For complex exponents, use the formula: z^w = e^(w * log(z))
    final theta = phase;
    final realExp = exponent.real;
    final imagExp = exponent.imaginary;

    // Compute new magnitude and angle using polar exponentiation:
    //   z^w = (r e^(i theta))^w = r^(realExp) * e^(-imagExp * theta)
    //         * e^(i (realExp * theta + imagExp * log(r)))
    num newR = math.pow(baseVal, realExp) *
        math.exp(-(imagExp) * theta);
    num newTheta =
        realExp * theta + imagExp * math.log(baseVal);

    // If the computed intermediate values are non-finite, signal an error.
    if (!newR.isFinite || !newTheta.isFinite) {
      throw ArgumentError(
          "Result of exponentiation is non-finite (Infinity or NaN).");
    }

    num newReal = newR * math.cos(newTheta);
    num newImaginary = newR * math.sin(newTheta);

    if (!newReal.isFinite || !newImaginary.isFinite) {
      throw ArgumentError(
          "Result of exponentiation is non-finite (Infinity or NaN).");
    }

    return Complex(newReal, newImaginary);
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

  Complex sqrt1z() {
    final a = (Complex.one() - (this * this)).sqrt();
    return a;
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
  /// If the complex number is NaN, this method returns NaN.
  /// Otherwise, it returns a new [Complex] number with the real part set to the natural logarithm of the modulus, and the imaginary part set to the angle (or argument) of the complex number.
  Complex log() {
    if (isNaN) return Complex.nan();
    return Complex(math.log(abs()), math.atan2(imaginary, real));
  }

  /// Returns the distance between two complex numbers in the complex plane
  num distanceTo(Complex other) {
    return (this - other).abs();
  }

  /// Returns true if the complex number lies within a circle
  bool isWithinCircle(Complex center, double radius) {
    return distanceTo(center) <= radius;
  }

  /// Rotates the complex number by theta radians around the origin
  Complex rotate(double theta) {
    return this * Complex(math.cos(theta), math.sin(theta));
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
    return Complex(
      real.clamp( lowerLimit, upperLimit),
      imaginary.clamp(lowerLimit, upperLimit)
    ).simplify();
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
  int round() => real.round();

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
      // Round both parts to integers
      // Return simplified version (num or Complex)
      return asComplex ? Complex(real.round(), imaginary.round()).simplify() : real.round();
    }
    
    final factor = math.pow(10, decimals);
    final roundedComplex = Complex(
      (real * factor).round() / factor,
      (imaginary * factor).round() / factor,
    );
    
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
    if (imaginary == 0 || math.isClose(imaginary.toDouble(), 0.0, relTol: 1e-9, absTol: 1e-15)) {
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
