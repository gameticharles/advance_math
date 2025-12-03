import 'package:advance_math/advance_math.dart';
part 'decimal.dart';

final _i0 = BigInt.zero;
final _i1 = BigInt.one;
// final _r0 = Rational.zero;
// final _r5 = Rational.fromInt(5);
final _r10 = Rational.fromInt(10);
final _im1 = BigInt.from(-1);

// final _i2 = BigInt.two;
// final _i5 = BigInt.from(5);

final _pattern = RegExp(
    r'^([+-]?(\d+\s+\d+/\d+|\d+/\d+|\d+|\d*\.\d+)([eE][+-]?\d+)?|\.\d+([eE][+-]?\d+)?)$');

/// Returns the greatest common divisor of two [BigInt] values.
///
/// This is a more efficient implementation using the binary GCD algorithm.
BigInt gcdBinary(BigInt u, BigInt v) {
  if (u == _i0) return v;
  if (v == _i0) return u;

  int shift = 0;
  while (((u | v) & _i1) == _i0) {
    u = u >> 1;
    v = v >> 1;
    shift++;
  }

  while ((u & _i1) == _i0) {
    u = u >> 1;
  }

  do {
    while ((v & _i1) == _i0) {
      v = v >> 1;
    }

    if (u > v) {
      final t = v;
      v = u;
      u = t;
    }
    v = v - u;

    // Add missing factor removal after subtraction
    while ((v & _i1) == _i0 && v != _i0) {
      v = v >> 1;
    }
  } while (v != _i0);

  return u << shift;
}

/// Calculates the Greatest Common Divisor (GCD) using the Euclidean algorithm.
///
/// This is used to simplify fractions to their canonical form.
BigInt _gcd(BigInt a, BigInt b) {
  while (b != _i0) {
    final t = b;
    b = a % b;
    a = t;
  }
  return a;
}

// ==========================================
// RATIONAL CLASS DOCUMENTATION
// ==========================================

/// A number that can be expressed as a fraction of two integers, a [numerator]
/// and a non-zero [denominator].
///
/// This class is highly optimized for performance ("Hot Path" execution) while
/// remaining robust enough to handle [Infinity], [NaN], and arbitrary precision.
///
/// ### Features:
/// * **Arbitrary Precision:** Uses [BigInt] to prevent overflows.
/// * **Performance:** Operators utilize a "Fast Path" to skip complex checks for standard finite numbers.
/// * **Special Values:** Supports `Infinity` (x/0), `-Infinity` (-x/0), and `NaN` (0/0).
/// * **Canonical Form:** Fractions are always stored in simplified form (e.g., 2/4 is stored as 1/2).
class Rational implements Comparable<Rational> {
  /// The numerator of the fraction.
  final BigInt numerator;

  /// The denominator of the fraction.
  ///
  /// * If [denominator] is 1, the number is an integer.
  /// * If [denominator] is 0, the number is Infinite or NaN.
  final BigInt denominator;

  // --- Constructors ---

  /// Canonical constructor.
  ///
  /// This constructor assumes the inputs are already simplified (GCD calculated)
  /// and signs are normalized. It bypasses all validation checks for maximum speed.
  const Rational._(this.numerator, this.denominator);

  /// The Rational number 0.
  static final Rational zero = Rational._(_i0, _i1);

  /// The Rational number 1.
  static final Rational one = Rational._(_i1, _i1);

  /// Represents Positive Infinity (+∞).
  /// Internally stored as `1 / 0`.
  static final Rational infinity = Rational._(_i1, _i0);

  /// Represents Negative Infinity (-∞).
  /// Internally stored as `-1 / 0`.
  static final Rational negativeInfinity = Rational._(_im1, _i0);

  /// Represents Not-a-Number (NaN).
  /// Internally stored as `0 / 0`.
  static final Rational nan = Rational._(_i0, _i0);

  // --- Factory ---

  /// Creates a [Rational] from a [numerator] and an optional [denominator].
  ///
  /// This is the main entry point for creating rationals. It handles:
  /// 1.  **Type Conversion:** Accepts [int], [BigInt], [double], [String], or [Rational].
  /// 2.  **Simplification:** Divides numerator and denominator by their GCD.
  /// 3.  **Sign Normalization:** Ensures the denominator is non-negative.
  /// 4.  **Special Values:** correctly handles division by zero.
  ///
  /// ```dart
  /// Rational(1, 2); // 1/2
  /// Rational(2, 4); // 1/2 (Simplified)
  /// Rational(1, 0); // Infinity
  /// ```
  factory Rational(dynamic numerator, [dynamic denominator]) {
    // 1. FAST RETURN: If inputs are already simple, return immediately.
    if (numerator is Rational && denominator == null) return numerator;
    if (numerator is int && denominator == null) {
      return Rational.fromInt(numerator);
    }
    if (numerator is BigInt && denominator == null) {
      return Rational._(numerator, _i1);
    }

    numerator ??= 0;
    denominator ??= 1;

    // Helper to normalize input types to Rational
    Rational toRat(dynamic val) {
      if (val is Rational) return val;
      if (val is int) return Rational.fromInt(val);
      if (val is BigInt) return Rational._(val, _i1);
      if (val is double) return Rational.parse(val.toString());
      if (val is String) return Rational.parse(val);
      if (val is Decimal) return val._rational;
      throw ArgumentError('Invalid type: ${val.runtimeType}');
    }

    final Rational n = toRat(numerator);
    final Rational d = toRat(denominator);

    // 2. CHECK FOR SPECIAL VALUES (Denominator == 0)
    // If input is already special, propagate it.
    if (n.denominator == _i0 || d.denominator == _i0) {
      if (n.isNaN || d.isNaN) return nan; // NaN dominates

      // Handle division by zero or Infinity ops
      if (d.isInfinite) {
        // x / Inf = 0
        if (n.isInfinite) return nan; // Inf / Inf = NaN
        return zero;
      }
      if (n.isInfinite) {
        // Inf / x = Inf
        return ((n.sign > 0) == (d.sign > 0)) ? infinity : negativeInfinity;
      }

      // Logic for explicit zero denominator input (e.g. Rational(1, 0))
      if (d.numerator == _i0) {
        if (n.numerator == _i0) return nan;
        return ((n.sign > 0) == (d.sign > 0)) ? infinity : negativeInfinity;
      }
    }

    // 3. HOT PATH MATH
    // Perform standard cross-multiplication
    BigInt num = n.numerator * d.denominator;
    BigInt den = n.denominator * d.numerator;

    // Handle overflow resulting in zero denominator
    if (den == _i0) {
      if (num == _i0) return nan;
      return (n.sign * d.sign >= 0) ? infinity : negativeInfinity;
    }

    // Normalize signs (denominator should be positive)
    if (den < _i0) {
      num = -num;
      den = -den;
    }

    // Simplify using GCD
    final gcd = _gcd(num.abs(), den);
    return Rational._(num ~/ gcd, den ~/ gcd);
  }

  /// Creates a [Rational] from an integer.
  factory Rational.fromInt(int numerator, [int denominator = 1]) =>
      Rational._(BigInt.from(numerator), BigInt.from(denominator));

  /// Creates a [Rational] from a double.
  ///
  /// Note: This converts the double to a string first to avoid precision issues
  /// inherent in IEEE 754 floating point numbers.
  factory Rational.fromDouble(double value) => Rational.parse(value.toString());

  /// Parses [source] as a fraction literal and returns its value as [Rational].
  ///
  /// The [source] can be in various formats including:
  /// - Mixed numbers (e.g., "2 3/4")
  /// - Simple fractions (e.g., "1/2")
  /// - Whole numbers (e.g., "3")
  /// - Decimal numbers (e.g., "3.14")
  /// - Negative decimals (e.g., "-3.14")
  /// - Scientific notation (e.g., "+3.14e+10")
  /// - Decimals without leading digit (e.g., ".5")
  /// - Scientific notation with negative exponent (e.g., "5e-2")
  ///
  /// Throws a [FormatException] if the [source] is not in a valid format.
  static Rational parse(String source) {
    if (source == 'NaN') return nan;
    if (source == 'Infinity' || source == '+Infinity') return infinity;
    if (source == '-Infinity') return negativeInfinity;

    try {
      final match = _pattern.firstMatch(source);
      if (match == null) {
        throw FormatException('$source is not a valid format');
      }

      final group2 = match.group(2); // Main number part
      final group3 =
          match.group(3); // Scientific notation part (e.g., e+10 or e-2)

      var numerator = BigInt.zero;
      var denominator = BigInt.one;

      // Check if the number is negative
      bool isNegative = source.startsWith('-');

      if (group2 != null) {
        // Handle mixed numbers (e.g., "-2 3/4")
        if (group2.contains(' ')) {
          final parts = group2.split(' ');
          final whole = BigInt.parse(parts[0]);
          final fractionParts = parts[1].split('/');
          final numeratorPart = BigInt.parse(fractionParts[0]);
          final denominatorPart = BigInt.parse(fractionParts[1]);
          numerator = (whole.abs() * denominatorPart + numeratorPart) *
              (isNegative ? BigInt.from(-1) : BigInt.one);
          denominator = denominatorPart;
        }
        // Handle fractions (e.g., "-3/4")
        else if (group2.contains('/')) {
          final fractionParts = group2.split('/');
          numerator = BigInt.parse(fractionParts[0]);
          denominator = BigInt.parse(fractionParts[1]);
          if (isNegative && numerator > BigInt.zero) {
            numerator = -numerator;
          }
        }
        // Handle decimal numbers (e.g., "-0.75")
        else if (group2.contains('.')) {
          final decimalParts = group2.split('.');
          numerator = BigInt.parse(decimalParts[0] + decimalParts[1]);
          denominator = BigInt.from(10).pow(decimalParts[1].length);
          if (isNegative && numerator > BigInt.zero) {
            numerator = -numerator;
          }
        }
        // Handle whole numbers (e.g., "-3")
        else {
          numerator = BigInt.parse(group2);
          if (isNegative && numerator > BigInt.zero) {
            numerator = -numerator;
          }
        }
      }

      // Handle scientific notation (e.g., "3.14e2" or "-3.14e-2")
      if (group3 != null) {
        var exponent = int.parse(group3.substring(1));
        if (exponent > 0) {
          numerator *= BigInt.from(10).pow(exponent);
        }
        if (exponent < 0) {
          denominator *= BigInt.from(10).pow(exponent.abs());
        }
      }

      return Rational(numerator, denominator);
    } catch (_) {
      return nan;
    }
  }

  /// Parses [source] as a decimal literal and returns its value as [Rational].
  ///
  /// As [parse] except that this method returns null if the input is not
  /// valid
  static Rational? tryParse(String source) {
    try {
      return parse(source);
    } catch (_) {
      return null;
    }
  }

  // --- Properties ---

  /// Returns `true` if the denominator is 1 (and the number is finite).
  bool get isInteger => denominator == _i1 && !isInfinite && !isNaN;

  /// Returns `true` if the value is Positive or Negative Infinity.
  bool get isInfinite => isPositiveInfinity || isNegativeInfinity;

  /// Returns `true` if the value is Positive Infinity.
  bool get isPositiveInfinity => denominator == _i0 && numerator > _i0;

  /// Returns `true` if the value is Negative Infinity.
  bool get isNegativeInfinity => denominator == _i0 && numerator < _i0;

  /// Returns `true` if the value is Not-a-Number (0/0).
  bool get isNaN => denominator == _i0 && numerator == _i0;

  /// Returns `true` if the fraction represents a whole number (e.g. 4/2).
  bool isWhole() {
    return numerator % denominator == BigInt.zero;
  }

  /// Returns `true` if the numerator is greater than or equal to the denominator.
  bool isImproper() {
    return numerator >= denominator;
  }

  /// Returns `true` if the numerator is smaller than the denominator.
  bool isProper() {
    return numerator < denominator;
  }

  /// Returns true if this instance stores the original unsimplified numerator/denominator.
  /// (Always false in the lean version).
  bool get hasOriginalForm => false;

  /// Returns the numerator.
  BigInt get originalNumerator => numerator;

  /// Returns the denominator.
  BigInt get originalDenominator => denominator;

  /// Returns the inverse (reciprocal) of this rational (denominator / numerator).
  Rational get inverse => Rational(denominator, numerator);

  /// Returns the sign of the number (-1, 0, or 1).
  int get sign {
    if (isNaN) return 0;
    return numerator.sign;
  }

  // --- OPERATORS (HOT PATH OPTIMIZED) ---

  /// Adds [other] to this rational.
  ///
  /// **Optimization:** This operator checks if both numbers are standard finite
  /// rationals first ("Hot Path"). If so, it calculates the result immediately
  /// without overhead. Special values (NaN/Inf) are handled in the fallback path.
  dynamic operator +(dynamic other) {
    if (other is Rational) {
      // FAST PATH: Standard Finite Math
      if (denominator != _i0 && other.denominator != _i0) {
        final num =
            numerator * other.denominator + other.numerator * denominator;
        final den = denominator * other.denominator;
        final gcd = _gcd(num.abs(), den);
        return Rational._(num ~/ gcd, den ~/ gcd);
      }
      // SLOW PATH: Special values (NaN/Inf)
      if (isNaN || other.isNaN) return nan;
      if (isInfinite) {
        if (other.isInfinite && sign != other.sign) {
          return nan; // Inf + -Inf = NaN
        }
        return this;
      }
      return other;
    }
    return this + Rational(other);
  }

  /// Subtracts [other] from this rational.
  ///
  /// Uses "Hot Path" optimization for standard numbers.
  dynamic operator -(dynamic other) {
    if (other is Rational) {
      // FAST PATH
      if (denominator != _i0 && other.denominator != _i0) {
        final num =
            numerator * other.denominator - other.numerator * denominator;
        final den = denominator * other.denominator;
        final gcd = _gcd(num.abs(), den);
        return Rational._(num ~/ gcd, den ~/ gcd);
      }
      // SLOW PATH
      if (isNaN || other.isNaN) return nan;
      if (isInfinite) {
        if (other.isInfinite && sign == other.sign) {
          return nan; // Inf - Inf = NaN
        }
        return this;
      }
      return other.isPositiveInfinity ? negativeInfinity : infinity;
    }
    return this - Rational(other);
  }

  /// Multiplies this rational by [other].
  ///
  /// Uses "Hot Path" optimization for standard numbers.
  dynamic operator *(dynamic other) {
    if (other is Rational) {
      // FAST PATH
      if (denominator != _i0 && other.denominator != _i0) {
        final num = numerator * other.numerator;
        final den = denominator * other.denominator;
        if (num == _i0) return zero;
        final gcd = _gcd(num.abs(), den);
        return Rational._(num ~/ gcd, den ~/ gcd);
      }
      // SLOW PATH
      if (isNaN || other.isNaN) return nan;
      if (isInfinite || other.isInfinite) {
        if (numerator == _i0 || other.numerator == _i0) {
          return nan; // 0 * Inf = NaN
        }
        return (sign == other.sign) ? infinity : negativeInfinity;
      }
    }
    return this * Rational(other);
  }

  /// Divides this rational by [other].
  ///
  /// Uses "Hot Path" optimization for standard numbers.
  dynamic operator /(dynamic other) {
    if (other is Rational) {
      // FAST PATH
      if (denominator != _i0 &&
          other.denominator != _i0 &&
          other.numerator != _i0) {
        final num = numerator * other.denominator;
        final den = denominator * other.numerator;

        if (den < _i0) {
          final gcd = _gcd(num.abs(), den.abs());
          return Rational._(-(num ~/ gcd), -(den ~/ gcd));
        } else {
          final gcd = _gcd(num.abs(), den);
          return Rational._(num ~/ gcd, den ~/ gcd);
        }
      }
      // SLOW PATH
      if (isNaN || other.isNaN) return nan;
      if (other.numerator == _i0 && !other.isInfinite) {
        // Div by 0
        if (numerator == _i0) return nan;
        return sign < 0 ? negativeInfinity : infinity;
      }
      if (isInfinite) {
        if (other.isInfinite) return nan;
        return (sign == other.sign) ? infinity : negativeInfinity;
      }
      if (other.isInfinite) return zero;
    }
    return this / Rational(other);
  }

  /// Calculates the Euclidean modulo.
  dynamic operator %(dynamic other) {
    if (other is Rational) {
      if (isNaN || other.isNaN || isInfinite || other.numerator == _i0) {
        return nan;
      }
      if (other.isInfinite) return this;
      final Rational div = Rational((this / other).truncate());
      return this - (div * other);
    }
    return this % Rational(other);
  }

  /// Performs truncating integer division.
  dynamic operator ~/(dynamic other) => (this / other).truncate();

  // --- Utilities ---

  /// Negates the rational number.
  Rational operator -() {
    if (isNaN) return nan;
    return Rational._(-numerator, denominator);
  }

  /// Returns the absolute value.
  Rational abs() => sign < 0 ? -this : this;

  /// Returns true if the number is negative.
  bool get isNegative => sign < 0;

  /// Returns the remainder from dividing this [Rational] by [other].
  Rational remainder(Rational other) {
    // Handle special values
    if (isNaN || other.isNaN) return Rational.nan;
    if (isInfinite) return Rational.nan;
    if (other.isInfinite) return this;
    if (other.numerator == _i0) return Rational.nan;

    // Normal remainder for finite values
    return this - Rational(this ~/ other) * other;
  }

  /// Truncates the number to a BigInt (removes the fractional part).
  BigInt truncate() {
    if (denominator == _i0) throw UnsupportedError("NaN/Inf");
    return numerator ~/ denominator;
  }

  /// Rounds the number to the nearest integer.
  ///
  /// Rounds half-up (e.g. 0.5 rounds to 1).
  dynamic round() {
    if (denominator == _i0) return this;
    final abs = this.abs();
    final rem = abs.numerator % abs.denominator;
    var val = abs.truncate();
    if (rem * BigInt.two >= abs.denominator) val += _i1;
    return sign < 0 ? -val : val;
  }

  /// Returns the square of this rational number.
  Rational square() => this * this;

  /// Returns the cube of this rational number.
  Rational cube() => this * this * this;

  /// Converts to [BigInt] via truncation.
  BigInt toBigInt() => truncate();

  /// Converts to [double].
  ///
  /// Warning: Precision may be lost for very large or small numbers.
  double toDouble() {
    // Handle special cases
    if (isNaN) return double.nan;
    if (isPositiveInfinity) return double.infinity;
    if (isNegativeInfinity) return double.negativeInfinity;

    // Handle special cases to avoid precision loss
    if (numerator == _i0) return 0.0;
    if (denominator == _i1) return numerator.toDouble();

    // Check for overflow potential before dividing
    if (numerator.abs() > BigInt.from(1 << 53) ||
        denominator > BigInt.from(1 << 53)) {
      // Use logarithmic scaling for very large numbers
      final numDigits = numerator.abs().toString().length;
      final denDigits = denominator.toString().length;

      if (numDigits > 15 || denDigits > 15) {
        final scale = BigInt.from(10).pow(numDigits - 1);
        final scaledNum = numerator ~/ scale;
        final result = scaledNum.toDouble() / (denominator ~/ scale).toDouble();
        return result * (numerator.isNegative ? -1 : 1);
      }
    }

    return numerator / denominator;
  }

  /// Calculates this rational raised to the power of [exponent].
  ///
  /// [exponent] must be an integer.
  Rational pow(int exponent) {
    if (isNaN) return nan;
    if (exponent == 0) return one;
    if (isInfinite) {
      if (exponent > 0) {
        return (exponent.isEven || isPositiveInfinity)
            ? infinity
            : negativeInfinity;
      }
      return zero;
    }
    if (exponent < 0) return inverse.pow(-exponent);
    return Rational._(numerator.pow(exponent), denominator.pow(exponent));
  }

  /// Clamps this value between [lower] and [upper].
  Rational clamp(Rational lower, Rational upper) =>
      this < lower ? lower : (this > upper ? upper : this);

  /// Returns the greatest [BigInt] value no greater than this [Rational].
  dynamic floor() =>
      isInteger ? truncate() : (sign < 0 ? truncate() - _i1 : truncate());

  /// Returns the least [BigInt] value that is no smaller than this [Rational].
  dynamic ceil() =>
      isInteger ? truncate() : (sign < 0 ? truncate() : truncate() + _i1);

  // --- Comparisons ---

  @override
  int compareTo(Rational other) {
    if (isNaN || other.isNaN) return 0;
    if (isInfinite) {
      if (other.isInfinite) return (sign == other.sign) ? 0 : sign;
      return sign;
    }
    if (other.isInfinite) return -other.sign;

    // Cross-multiply optimization to avoid division
    return (numerator * other.denominator)
        .compareTo(other.numerator * denominator);
  }

  bool operator <(dynamic other) =>
      compareTo(other is Rational ? other : Rational(other)) < 0;
  bool operator <=(dynamic other) =>
      compareTo(other is Rational ? other : Rational(other)) <= 0;
  bool operator >(dynamic other) =>
      compareTo(other is Rational ? other : Rational(other)) > 0;
  bool operator >=(dynamic other) =>
      compareTo(other is Rational ? other : Rational(other)) >= 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Rational && compareTo(other) == 0;
  }

  @override
  int get hashCode => Object.hash(numerator, denominator);

  @override
  String toString({bool useOriginalForm = false}) {
    if (isNaN) return 'NaN';
    if (isPositiveInfinity) return 'Infinity';
    if (isNegativeInfinity) return '-Infinity';
    if (useOriginalForm && hasOriginalForm) {
      return '$originalNumerator/$originalDenominator';
    }
    if (denominator == _i1) return '$numerator';
    return '$numerator/$denominator';
  }

  /// Checks if the Rational has a finite decimal representation.
  ///
  /// Returns `true` if the denominator (in simplest form) only contains
  /// prime factors of 2 and 5.
  bool get hasFinitePrecision {
    if (isInteger) return true;
    if (denominator == _i0) return false;
    var d = denominator;
    while (d.isEven) {
      d >>= 1; // Fast divide by 2
    }
    while (d % BigInt.from(5) == _i0) {
      d ~/= BigInt.from(5);
    }
    return d == _i1;
  }
}

/*
/// A number that can be expressed as a fraction of two integers, a [numerator]
/// and a non-zero [denominator].
///
/// This fraction is stored in its canonical form. The canonical form is the
/// rational number expressed in a unique way as an irreducible fraction a/b,
/// where a and b are co-prime integers and b > 0.
///
/// Rational(2, 4) corresponding to 2/4 will be created with its canonical
/// form 1/2. That means Rational(2, 4).numerator will be equal to 1 and
/// Rational(2, 4).denominator equal to 2.
class Rational implements Comparable<Rational> {
  /// Create a new rational number from its [numerator] and a non-zero
  /// [denominator].
  ///
  /// If the [denominator] is omitted then its value will be 1.
  Rational._fromCanonicalForm(this.numerator, this.denominator)
      : assert(denominator > _i0),
        // assert(numerator.abs().gcd(denominator) == _i1);
        assert(_gcd(numerator.abs(), denominator) == _i1);

  /// Create a new rational number from its [numerator] and a non-zero
  /// [denominator].
  ///
  /// If the [denominator] is omitted then its value will be 1.
  factory Rational(BigInt numerator, [BigInt? denominator]) {
    if (denominator == null) return Rational._fromCanonicalForm(numerator, _i1);
    if (denominator == _i0) {
      throw ArgumentError('zero can not be used as denominator');
    }
    if (numerator == _i0) return Rational._fromCanonicalForm(_i0, _i1);
    if (denominator < _i0) {
      numerator = -numerator;
      denominator = -denominator;
    }
    // TODO(a14n): switch back when https://github.com/dart-lang/sdk/issues/46180 is fixed
    // final gcd = numerator.abs().gcd(denominator.abs());
    final gcd = _gcd(numerator.abs(), denominator.abs());
    return Rational._fromCanonicalForm(numerator ~/ gcd, denominator ~/ gcd);
  }

  static BigInt _gcd(BigInt a, BigInt b) {
    while (b != _i0) {
      final t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  /// Create a new rational number from its [numerator] and a non-zero
  /// [denominator].
  ///
  /// If the [denominator] is omitted then its value will be 1.
  factory Rational.fromInt(int numerator, [int denominator = 1]) =>
      Rational(BigInt.from(numerator), BigInt.from(denominator));

  /// The numerator of this rational number.
  final BigInt numerator;

  /// The denominator of this rational number.
  final BigInt denominator;

  /// Parses [source] as a fraction literal and returns its value as [Rational].
  ///
  /// The [source] can be in various formats including:
  /// - Mixed numbers (e.g., "2 3/4")
  /// - Simple fractions (e.g., "1/2")
  /// - Whole numbers (e.g., "3")
  /// - Decimal numbers (e.g., "3.14")
  /// - Negative decimals (e.g., "-3.14")
  /// - Scientific notation (e.g., "+3.14e+10")
  /// - Decimals without leading digit (e.g., ".5")
  /// - Scientific notation with negative exponent (e.g., "5e-2")
  ///
  /// Throws a [FormatException] if the [source] is not in a valid format.
  static Rational parse(String source) {
    final match = _pattern.firstMatch(source);
    if (match == null) {
      throw FormatException('$source is not a valid format');
    }

    final group2 = match.group(2); // Main number part
    final group3 =
        match.group(3); // Scientific notation part (e.g., e+10 or e-2)

    var numerator = BigInt.zero;
    var denominator = BigInt.one;

    // Check if the number is negative
    bool isNegative = source.startsWith('-');

    if (group2 != null) {
      // Handle mixed numbers (e.g., "-2 3/4")
      if (group2.contains(' ')) {
        final parts = group2.split(' ');
        final whole = BigInt.parse(parts[0]);
        final fractionParts = parts[1].split('/');
        final numeratorPart = BigInt.parse(fractionParts[0]);
        final denominatorPart = BigInt.parse(fractionParts[1]);
        numerator = (whole.abs() * denominatorPart + numeratorPart) *
            (isNegative ? BigInt.from(-1) : BigInt.one);
        denominator = denominatorPart;
      }
      // Handle fractions (e.g., "-3/4")
      else if (group2.contains('/')) {
        final fractionParts = group2.split('/');
        numerator = BigInt.parse(fractionParts[0]);
        denominator = BigInt.parse(fractionParts[1]);
        if (isNegative && numerator > BigInt.zero) {
          numerator = -numerator;
        }
      }
      // Handle decimal numbers (e.g., "-0.75")
      else if (group2.contains('.')) {
        final decimalParts = group2.split('.');
        numerator = BigInt.parse(decimalParts[0] + decimalParts[1]);
        denominator = BigInt.from(10).pow(decimalParts[1].length);
        if (isNegative && numerator > BigInt.zero) {
          numerator = -numerator;
        }
      }
      // Handle whole numbers (e.g., "-3")
      else {
        numerator = BigInt.parse(group2);
        if (isNegative && numerator > BigInt.zero) {
          numerator = -numerator;
        }
      }
    }

    // Handle scientific notation (e.g., "3.14e2" or "-3.14e-2")
    if (group3 != null) {
      var exponent = int.parse(group3.substring(1));
      if (exponent > 0) {
        numerator *= BigInt.from(10).pow(exponent);
      }
      if (exponent < 0) {
        denominator *= BigInt.from(10).pow(exponent.abs());
      }
    }

    return Rational(numerator, denominator);
  }

  /// Parses [source] as a decimal literal and returns its value as [Rational].
  ///
  /// As [parse] except that this method returns null if the input is not
  /// valid
  static Rational? tryParse(String source) {
    try {
      return parse(source);
    } on FormatException {
      return null;
    }
  }

  /// The rational number corresponding to `0`.
  static final zero = Rational.fromInt(0);

  /// The rational number corresponding to `1`.
  static final one = Rational.fromInt(1);

  /// Returns `true` if `this` is an integer.
  bool get isInteger => denominator == _i1;

  /// Returns the [Rational] [denominator]/[numerator].
  Rational get inverse => Rational(denominator, numerator);

  @override
  int get hashCode => Object.hash(numerator, denominator);

  @override
  bool operator ==(Object other) =>
      other is Rational &&
      numerator == other.numerator &&
      denominator == other.denominator;

  @override
  String toString() {
    if (numerator == _i0) return '0';
    if (isInteger) {
      return '$numerator';
    } else {
      return '$numerator/$denominator';
    }
  }

  @override
  int compareTo(Rational other) =>
      (numerator * other.denominator).compareTo(other.numerator * denominator);

  /// Addition operator.
  Rational operator +(Rational other) => Rational(
        numerator * other.denominator + other.numerator * denominator,
        denominator * other.denominator,
      );

  /// Subtraction operator.
  Rational operator -(Rational other) => Rational(
        numerator * other.denominator - other.numerator * denominator,
        denominator * other.denominator,
      );

  /// Multiplication operator.
  Rational operator *(Rational other) => Rational(
        numerator * other.numerator,
        denominator * other.denominator,
      );

  /// Euclidean modulo operator.
  ///
  /// See [num.operator%].
  Rational operator %(Rational other) {
    final remainder = this.remainder(other);
    if (remainder == _r0) return _r0;
    return remainder + (_isNegative ? other.abs() : _r0);
  }

  /// Division operator.
  Rational operator /(Rational other) => Rational(
        numerator * other.denominator,
        denominator * other.numerator,
      );

  /// Truncating division operator.
  ///
  /// See [num.operator~/].
  BigInt operator ~/(Rational other) => (this / other).truncate();

  /// Returns the negative value of this rational.
  Rational operator -() => Rational(-numerator, denominator);

  /// Returns the remainder from dividing this [Rational] by [other].
  Rational remainder(Rational other) =>
      this - (this ~/ other).toRational() * other;

  /// Whether this number is numerically smaller than [other].
  bool operator <(Rational other) => compareTo(other) < 0;

  /// Whether this number is numerically smaller than or equal to [other].
  bool operator <=(Rational other) => compareTo(other) <= 0;

  /// Whether this number is numerically greater than [other].
  bool operator >(Rational other) => compareTo(other) > 0;

  /// Whether this number is numerically greater than or equal to [other].
  bool operator >=(Rational other) => compareTo(other) >= 0;

  bool get _isNegative => numerator < _i0;

  /// Returns the absolute value of `this`.
  Rational abs() => _isNegative ? (-this) : this;

  /// The sign function value of `this`.
  ///
  /// E.e. -1, 0 or 1 as the value of this [Rational] is negative, zero or positive.
  int get sign {
    final v = compareTo(_r0);
    if (v < 0) return -1;
    if (v > 0) return 1;
    return 0;
  }

  /// Returns the [BigInt] value closest to this number.
  ///
  /// Rounds away from zero when there is no closest integer:
  /// `(3.5).round() == 4` and `(-3.5).round() == -4`.
  BigInt round() {
    final abs = this.abs();
    final absBy10 = abs * _r10;
    var r = abs.truncate();
    if (absBy10 % _r10 >= _r5) r += _i1;
    return _isNegative ? -r : r;
  }

  /// Returns the greatest [BigInt] value no greater than this [Rational].
  BigInt floor() => isInteger
      ? truncate()
      : _isNegative
          ? (truncate() - _i1)
          : truncate();

  /// Returns the least [BigInt] value that is no smaller than this [Rational].
  BigInt ceil() => isInteger
      ? truncate()
      : _isNegative
          ? truncate()
          : (truncate() + _i1);

  /// The [BigInt] obtained by discarding any fractional digits from `this`.
  BigInt truncate() => numerator ~/ denominator;

  /// Clamps `this` to be in the range [lowerLimit]-[upperLimit].
  Rational clamp(Rational lowerLimit, Rational upperLimit) => this < lowerLimit
      ? lowerLimit
      : this > upperLimit
          ? upperLimit
          : this;

  /// The [BigInt] obtained by discarding any fractional digits from `this`.
  ///
  /// Equivalent to [truncate].
  BigInt toBigInt() => truncate();

  /// Returns `this` as a [double].
  ///
  /// If the number is not representable as a [double], an approximation is
  /// returned. For numerically large integers, the approximation may be
  /// infinite.
  double toDouble() => numerator / denominator;

  /// Returns `this` to the power of [exponent].
  ///
  /// Returns [one] if the [exponent] equals `0`.
  Rational pow(int exponent) => exponent.isNegative
      ? inverse.pow(-exponent)
      : Rational(
          numerator.pow(exponent),
          denominator.pow(exponent),
        );

  /// Converts the current [Rational] value to a [Decimal] with the specified precision.
  ///
  /// If the [Rational] has a finite precision, it is directly converted to a [Decimal].
  /// Otherwise, the [Rational] is scaled by the specified [precision] and converted to a [Decimal].
  ///
  /// The optional [toBigInt] parameter allows customizing the conversion from [Rational] to [BigInt].
  /// If not provided, the default behavior is to truncate the [Rational] value.
  Decimal toDecimal({
    int? precision,
    BigInt Function(Rational)? toBigInt,
  }) {
    var prec = precision ?? decimalPrecision;
    if (hasFinitePrecision) {
      return Decimal(this);
    }
    final scaleFactor = _r10.pow(prec);
    toBigInt ??= (value) => value.round();
    return Decimal(toBigInt(this * scaleFactor).toRational() / scaleFactor);
  }

  /// Returns true if this [Rational] has a finite decimal representation.
  ///
  /// A rational number has a finite decimal representation if and only if
  /// its denominator, when expressed in lowest form, has only 2 and 5 as prime factors.
  bool get hasFinitePrecision {
    // Quick check for integers
    if (isInteger) return true;

    // Quick check for common denominators
    if (denominator == BigInt.from(2) ||
        denominator == BigInt.from(4) ||
        denominator == BigInt.from(5) ||
        denominator == BigInt.from(8) ||
        denominator == BigInt.from(10) ||
        denominator == BigInt.from(16) ||
        denominator == BigInt.from(20) ||
        denominator == BigInt.from(25) ||
        denominator == BigInt.from(40) ||
        denominator == BigInt.from(50) ||
        denominator == BigInt.from(100)) {
      return true;
    }

    // For other denominators, check if they only have 2 and 5 as prime factors
    var d = denominator;

    // Remove all factors of 2
    while (d.isEven && d != BigInt.one) {
      d = d >> 1; // Faster than division
    }

    // Remove all factors of 5
    while (d % BigInt.from(5) == BigInt.zero && d != BigInt.one) {
      d = d ~/ BigInt.from(5);
    }

    // If only 2s and 5s were factors, d should now be 1
    return d == BigInt.one;
  }
}

//============================================

*/

/*
/// A number that can be expressed as a fraction of two integers, a [numerator]
/// and a non-zero [denominator].
///
/// This fraction is stored in its canonical form. The canonical form is the
/// rational number expressed in a unique way as an irreducible fraction a/b,
/// where a and b are co-prime integers and b > 0.
///
/// Rational(2, 4) corresponding to 2/4 will be created with its canonical
/// form 1/2. That means Rational(2, 4).numerator will be equal to 1 and
/// Rational(2, 4).denominator equal to 2.
class Rational implements Comparable<Rational> {
  /// The numerator of this rational number.
  final BigInt numerator;

  /// The denominator of this rational number.
  final BigInt denominator;

  /// The original numerator before simplification (if preserved)
  final BigInt? _originalNumerator;

  /// The original denominator before simplification (if preserved)
  final BigInt? _originalDenominator;

  /// Indicates if this rational represents positive infinity
  final bool _isPositiveInfinity;

  /// Indicates if this rational represents negative infinity
  final bool _isNegativeInfinity;

  /// Indicates if this rational represents NaN (Not a Number)
  final bool _isNaN;

  /// Create a new rational number from its [numerator] and a non-zero
  /// [denominator].
  ///
  /// If the [denominator] is omitted then its value will be 1.
  Rational._fromCanonicalForm(
    this.numerator,
    this.denominator, {
    BigInt? originalNumerator,
    BigInt? originalDenominator,
  })  : _originalNumerator = originalNumerator,
        _originalDenominator = originalDenominator,
        _isPositiveInfinity = false,
        _isNegativeInfinity = false,
        _isNaN = false,
        assert(denominator > _i0),
        // assert(numerator.abs().gcd(denominator) == _i1);
        assert(gcdBinary(numerator.abs(), denominator) == _i1);

  /// Private constructor for special values (infinity, NaN)
  Rational._special({
    required this.numerator,
    required this.denominator,
    required bool isPositiveInfinity,
    required bool isNegativeInfinity,
    required bool isNaN,
  })  : _originalNumerator = null,
        _originalDenominator = null,
        _isPositiveInfinity = isPositiveInfinity,
        _isNegativeInfinity = isNegativeInfinity,
        _isNaN = isNaN;

  /// Returns a rational representing positive infinity.
  static final infinity = Rational._special(
    numerator: _i1,
    denominator: _i0,
    isPositiveInfinity: true,
    isNegativeInfinity: false,
    isNaN: false,
  );

  /// Returns a rational representing negative infinity.
  static final negativeInfinity = Rational._special(
    numerator: -_i1,
    denominator: _i0,
    isPositiveInfinity: false,
    isNegativeInfinity: true,
    isNaN: false,
  );

  /// Returns a rational representing NaN (Not a Number).
  static final nan = Rational._special(
    numerator: _i0,
    denominator: _i0,
    isPositiveInfinity: false,
    isNegativeInfinity: false,
    isNaN: true,
  );

  /// Returns true if this rational represents positive infinity.
  bool get isInfinite => _isPositiveInfinity || _isNegativeInfinity;

  /// Returns true if this rational represents positive infinity.
  bool get isPositiveInfinity => _isPositiveInfinity;

  /// Returns true if this rational represents negative infinity.
  bool get isNegativeInfinity => _isNegativeInfinity;

  /// Returns true if this rational represents NaN (Not a Number).
  bool get isNaN => _isNaN;

  /// Returns true if this rational number has preserved its original unsimplified form
  bool get hasOriginalForm =>
      _originalNumerator != null && _originalDenominator != null;

  /// Returns the original numerator before simplification, or the current numerator if not preserved
  BigInt get originalNumerator => _originalNumerator ?? numerator;

  /// Returns the original denominator before simplification, or the current denominator if not preserved
  BigInt get originalDenominator => _originalDenominator ?? denominator;

  /// Helper method to convert any supported type to Rational
  static Rational _fromAny(dynamic value) {
    if (value is Rational) return value;
    if (value is num) return Rational.fromNum(value);
    if (value is BigInt) return Rational._fromCanonicalForm(value, _i1);
    if (value is Decimal) return value._rational;
    if (value is String) return Rational.parse(value);

    throw ArgumentError('Cannot convert ${value.runtimeType} to Rational');
  }

  // Create a new rational number from its [numerator] and a non-zero
  /// [denominator].
  ///
  /// If the [denominator] is omitted then its value will be 1.
  /// Accepts various types that can be converted to Rational.
  factory Rational(dynamic numerator, [dynamic denominator]) {
    // Handle null values
    numerator ??= 0;
    denominator ??= 1;

    // Handle special cases
    if (numerator is double) {
      if (numerator.isNaN) return Rational.nan;
      if (numerator.isInfinite) {
        return numerator.isNegative
            ? Rational.negativeInfinity
            : Rational.infinity;
      }
    }

    // Special case: if both are null or 0, return zero
    if ((numerator == 0 || numerator == _i0) &&
        (denominator == 1 || denominator == _i1)) {
      return Rational._fromCanonicalForm(_i0, _i1);
    }

    // Convert both numerator and denominator to BigInt if needed
    BigInt? numBigInt;
    BigInt? denBigInt;

    try {
      // Handle numerator
      if (numerator is BigInt) {
        numBigInt = numerator;
      } else if (numerator is Rational) {
        final numRational = numerator;

        // Handle special values
        if (numRational.isNaN) return Rational.nan;
        if (numRational.isInfinite) {
          return numRational.isNegativeInfinity
              ? Rational.negativeInfinity
              : Rational.infinity;
        }

        // If denominator is also provided, handle the division of rationals
        if (denominator != null && denominator != 1) {
          Rational denRational;
          if (denominator is Rational) {
            denRational = denominator;

            // Handle special cases in denominator
            if (denRational.isNaN) return Rational.nan;
            if (denRational.isInfinite) {
              // Infinity / Infinity = NaN
              if (numRational.isInfinite) return Rational.nan;
              // Any finite number / Infinity = 0
              return Rational.zero;
            }
            if (denRational.numerator == _i0) {
              // Any number / 0 = Infinity with appropriate sign
              if (numRational.numerator == _i0) {
                return Rational.nan; // 0/0 = NaN
              }
              return numRational._isNegative != denRational._isNegative
                  ? Rational.negativeInfinity
                  : Rational.infinity;
            }
          } else {
            denRational = _fromAny(denominator);
          }

          // Division of rationals: (a/b) / (c/d) = (a*d) / (b*c)
          numBigInt = numRational.numerator * denRational.denominator;
          denBigInt = numRational.denominator * denRational.numerator;

          // Simplify and return
          if (denBigInt == _i0) {
            if (numBigInt == _i0) return Rational.nan; // 0/0 = NaN
            return numBigInt.isNegative
                ? Rational.negativeInfinity
                : Rational.infinity;
          }
          if (numBigInt == _i0) return Rational._fromCanonicalForm(_i0, _i1);
          if (denBigInt < _i0) {
            numBigInt = -numBigInt;
            denBigInt = -denBigInt;
          }

          final gcd = gcdBinary(numBigInt.abs(), denBigInt.abs());
          return Rational._fromCanonicalForm(
              numBigInt ~/ gcd, denBigInt ~/ gcd);
        }

        return numRational;
      } else {
        // Convert numerator to Rational
        final numRational = _fromAny(numerator);

        // Handle special values
        if (numRational.isNaN) return Rational.nan;
        if (numRational.isInfinite) {
          return numRational.isNegativeInfinity
              ? Rational.negativeInfinity
              : Rational.infinity;
        }

        numBigInt = numRational.numerator;
        denBigInt = numRational.denominator;

        // If denominator is also provided, we need to divide
        if (denominator != null && denominator != 1) {
          final denRational = _fromAny(denominator);

          // Handle special cases in denominator
          if (denRational.isNaN) return Rational.nan;
          if (denRational.isInfinite) {
            return Rational.zero; // finite / infinity = 0
          }
          if (denRational.numerator == _i0) {
            // Any number / 0 = Infinity with appropriate sign
            if (numBigInt == _i0) return Rational.nan; // 0/0 = NaN
            final isNegative =
                (numBigInt.isNegative != denRational.numerator.isNegative);
            return isNegative ? Rational.negativeInfinity : Rational.infinity;
          }

          // Division: (a/b) / (c/d) = (a*d) / (b*c)
          numBigInt = numBigInt * denRational.denominator;
          denBigInt = denBigInt * denRational.numerator;

          // Simplify and return
          if (denBigInt == _i0) {
            if (numBigInt == _i0) return Rational.nan; // 0/0 = NaN
            return numBigInt.isNegative
                ? Rational.negativeInfinity
                : Rational.infinity;
          }
          if (numBigInt == _i0) return Rational._fromCanonicalForm(_i0, _i1);
          if (denBigInt < _i0) {
            numBigInt = -numBigInt;
            denBigInt = -denBigInt;
          }

          final gcd = gcdBinary(numBigInt.abs(), denBigInt.abs());
          return Rational._fromCanonicalForm(
              numBigInt ~/ gcd, denBigInt ~/ gcd);
        }

        return Rational._fromCanonicalForm(numBigInt, denBigInt);
      }

      // Handle denominator if not already set
      if (denominator is BigInt) {
        denBigInt = denominator;
      } else {
        // Convert denominator to Rational
        final denRational = _fromAny(denominator);

        // Handle special cases in denominator
        if (denRational.isNaN) return Rational.nan;
        if (denRational.isInfinite) {
          return Rational.zero; // finite / infinity = 0
        }
        if (denRational.numerator == _i0) {
          // Any number / 0 = Infinity with appropriate sign
          if (numBigInt == _i0) return Rational.nan; // 0/0 = NaN
          final isNegative =
              (numBigInt.isNegative != denRational.numerator.isNegative);
          return isNegative ? Rational.negativeInfinity : Rational.infinity;
        }

        numBigInt = numBigInt * denRational.denominator;
        denBigInt = denRational.numerator;
      }
    } catch (e) {
      throw ArgumentError('Cannot convert arguments to Rational: $e');
    }

    // Standard validation and normalization
    if (denBigInt == _i0) {
      if (numBigInt == _i0) return Rational.nan; // 0/0 = NaN
      return numBigInt.isNegative
          ? Rational.negativeInfinity
          : Rational.infinity;
    }
    if (numBigInt == _i0) return Rational._fromCanonicalForm(_i0, _i1);
    if (denBigInt < _i0) {
      numBigInt = -numBigInt;
      denBigInt = -denBigInt;
    }

    final gcd = gcdBinary(numBigInt.abs(), denBigInt.abs());
    return Rational._fromCanonicalForm(numBigInt ~/ gcd, denBigInt ~/ gcd,
        originalNumerator: numerator is! BigInt
            ? BigInt.from(num.parse(numerator.toString()))
            : numerator,
        originalDenominator: denominator is! BigInt
            ? BigInt.from(num.parse(denominator.toString()))
            : denominator);
  }

  /// Create a new rational number from its [numerator] and a non-zero
  /// [denominator].
  ///
  /// If the [denominator] is omitted then its value will be 1.
  factory Rational.fromInt(int numerator, [int denominator = 1]) =>
      Rational(BigInt.from(numerator), BigInt.from(denominator));

  // Add a method to convert num to Rational directly
  factory Rational.fromDouble(double value, {int precision = 15}) {
    if (value.isInfinite || value.isNaN) {
      throw ArgumentError('Cannot convert $value to Rational');
    }

    // Handle special cases
    if (value == 0.0) return Rational.zero;
    if (value == 1.0) return Rational.one;

    // Handle negative values
    bool isNegative = value < 0;
    double absValue = value.abs();

    // Extract integer and fractional parts
    int intPart = absValue.truncate();
    double fractionalPart = absValue - intPart;

    if (fractionalPart == 0.0) {
      // It's an integer
      return Rational.fromInt(isNegative ? -intPart : intPart);
    }

    // Convert fractional part to rational
    // Use a power of 10 based on precision
    BigInt scaleFactor = BigInt.from(10).pow(precision);
    BigInt scaledValue =
        BigInt.from((fractionalPart * (10.pow(precision)) as num).round());

    // Create the rational for the fractional part
    Rational fractionalRational = Rational(scaledValue, scaleFactor);

    // Add the integer part
    Rational result = Rational.fromInt(intPart) + fractionalRational;

    return isNegative ? -result : result;
  }

  /// Create a new rational number from a [num] value.
  factory Rational.fromNum(num value) {
    if (value is int) {
      return Rational.fromInt(value);
    } else {
      // Handle double with care to preserve precision
      final String str = value.toString();
      return Rational.parse(str);
    }
  }

  /// Parses [source] as a fraction literal and returns its value as [Rational].
  ///
  /// The [source] can be in various formats including:
  /// - Mixed numbers (e.g., "2 3/4")
  /// - Simple fractions (e.g., "1/2")
  /// - Whole numbers (e.g., "3")
  /// - Decimal numbers (e.g., "3.14")
  /// - Negative decimals (e.g., "-3.14")
  /// - Scientific notation (e.g., "+3.14e+10")
  /// - Decimals without leading digit (e.g., ".5")
  /// - Scientific notation with negative exponent (e.g., "5e-2")
  ///
  /// Throws a [FormatException] if the [source] is not in a valid format.
  factory Rational.parse(String source) {
    final match = _pattern.firstMatch(source);
    if (match == null) {
      throw FormatException('$source is not a valid format');
    }

    final group2 = match.group(2); // Main number part
    final group3 =
        match.group(3); // Scientific notation part (e.g., e+10 or e-2)

    var numerator = BigInt.zero;
    var denominator = BigInt.one;

    // Check if the number is negative
    bool isNegative = source.startsWith('-');

    if (group2 != null) {
      // Handle mixed numbers (e.g., "-2 3/4")
      if (group2.contains(' ')) {
        final parts = group2.split(' ');
        final whole = BigInt.parse(parts[0]);
        final fractionParts = parts[1].split('/');
        final numeratorPart = BigInt.parse(fractionParts[0]);
        final denominatorPart = BigInt.parse(fractionParts[1]);
        numerator = (whole.abs() * denominatorPart + numeratorPart) *
            (isNegative ? BigInt.from(-1) : BigInt.one);
        denominator = denominatorPart;
      }
      // Handle fractions (e.g., "-3/4")
      else if (group2.contains('/')) {
        final fractionParts = group2.split('/');
        numerator = BigInt.parse(fractionParts[0]);
        denominator = BigInt.parse(fractionParts[1]);
        if (isNegative && numerator > BigInt.zero) {
          numerator = -numerator;
        }
      }
      // Handle decimal numbers (e.g., "-0.75")
      else if (group2.contains('.')) {
        final decimalParts = group2.split('.');
        numerator = BigInt.parse(decimalParts[0] + decimalParts[1]);
        denominator = BigInt.from(10).pow(decimalParts[1].length);
        if (isNegative && numerator > BigInt.zero) {
          numerator = -numerator;
        }
      }
      // Handle whole numbers (e.g., "-3")
      else {
        numerator = BigInt.parse(group2);
        if (isNegative && numerator > BigInt.zero) {
          numerator = -numerator;
        }
      }
    }

    // Handle scientific notation (e.g., "3.14e2" or "-3.14e-2")
    if (group3 != null) {
      var exponent = int.parse(group3.substring(1));
      if (exponent > 0) {
        numerator *= BigInt.from(10).pow(exponent);
      }
      if (exponent < 0) {
        denominator *= BigInt.from(10).pow(exponent.abs());
      }
    }

    return Rational(numerator, denominator);
  }

  /// Parses [source] as a decimal literal and returns its value as [Rational].
  ///
  /// As [parse] except that this method returns null if the input is not
  /// valid
  static Rational? tryParse(String source) {
    try {
      return Rational.parse(source);
    } on FormatException {
      return null;
    }
  }

  /// The rational number corresponding to `0`.
  static final zero = Rational.fromInt(0);

  /// The rational number corresponding to `1`.
  static final one = Rational.fromInt(1);

  /// Returns `true` if `this` is an integer.
  bool get isInteger => denominator == _i1;

  /// Returns the [Rational] [denominator]/[numerator].
  Rational get inverse => Rational(denominator, numerator);

  @override
  int get hashCode => Object.hash(numerator, denominator);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is Rational) {
      return numerator == other.numerator && denominator == other.denominator;
    }

    try {
      final rational = _fromAny(other);
      return numerator == rational.numerator &&
          denominator == rational.denominator;
    } catch (_) {
      return false;
    }
  }

  /// Returns a string representation of this rational number.
  ///
  /// If [useOriginalForm] is true and the original unsimplified form is available,
  /// it will return the original form. Otherwise, it returns the canonical form.
  ///
  /// Special values like NaN and infinity are represented appropriately.
  @override
  String toString({bool useOriginalForm = false}) {
    // Handle special values first
    if (_isNaN) return 'NaN';
    if (_isPositiveInfinity) return 'Infinity';
    if (_isNegativeInfinity) return '-Infinity';

    // Use original form if requested and available
    if (useOriginalForm && hasOriginalForm) {
      if (originalNumerator == _i0) return '0';
      if (originalDenominator == _i1) {
        return '$originalNumerator';
      } else {
        return '$originalNumerator/$originalDenominator';
      }
    }

    // Use canonical form
    if (numerator == _i0) return '0';
    if (isInteger) {
      return '$numerator';
    } else {
      return '$numerator/$denominator';
    }
  }

  /// Returns a string representation using the original unsimplified form if available
  String toOriginalString() => toString(useOriginalForm: true);

  @override
  int compareTo(Rational other) {
    // Handle special values
    if (_isNaN || other._isNaN) {
      return 0; // NaN is neither greater nor less than anything
    }
    if (_isPositiveInfinity) {
      return other._isPositiveInfinity ? 0 : 1;
    }
    if (_isNegativeInfinity) {
      return other._isNegativeInfinity ? 0 : -1;
    }
    if (other._isPositiveInfinity) return -1;
    if (other._isNegativeInfinity) return 1;

    // Normal comparison for finite values
    return (numerator * other.denominator)
        .compareTo(other.numerator * denominator);
  }

  /// Addition with a [Decimal] value.
  dynamic operator +(dynamic other) {
    if (other is Rational) {
      // Handle special values
      if (_isNaN || other._isNaN) return Rational.nan;
      if (_isPositiveInfinity) {
        return other._isNegativeInfinity ? Rational.nan : Rational.infinity;
      }
      if (_isNegativeInfinity) {
        return other._isPositiveInfinity
            ? Rational.nan
            : Rational.negativeInfinity;
      }
      if (other._isPositiveInfinity) return Rational.infinity;
      if (other._isNegativeInfinity) return Rational.negativeInfinity;

      // Normal addition for finite values
      return Rational(
        numerator * other.denominator + other.numerator * denominator,
        denominator * other.denominator,
      );
    }

    try {
      return this + _fromAny(other);
    } catch (e) {
      throw ArgumentError('Unsupported operand type: ${other.runtimeType}');
    }
  }

  /// Subtraction with a [Decimal] value.
  dynamic operator -(dynamic other) {
    if (other is Rational) {
      // Handle special values
      if (_isNaN || other._isNaN) return Rational.nan;
      if (_isPositiveInfinity) {
        return other._isPositiveInfinity ? Rational.nan : Rational.infinity;
      }
      if (_isNegativeInfinity) {
        return other._isNegativeInfinity
            ? Rational.nan
            : Rational.negativeInfinity;
      }
      if (other._isPositiveInfinity) return Rational.negativeInfinity;
      if (other._isNegativeInfinity) return Rational.infinity;

      // Normal subtraction for finite values
      return Rational(
        numerator * other.denominator - other.numerator * denominator,
        denominator * other.denominator,
      );
    }
    try {
      return this - _fromAny(other);
    } catch (e) {
      throw ArgumentError('Unsupported operand type: ${other.runtimeType}');
    }
  }

  /// Multiplication with a [Decimal] value.
  dynamic operator *(dynamic other) {
    if (other is Rational) {
      // Handle special values
      if (_isNaN || other._isNaN) return Rational.nan;

      // Handle zero cases
      if ((numerator == _i0 && !_isNaN && !isInfinite) ||
          (other.numerator == _i0 && !other._isNaN && !other.isInfinite)) {
        // Special case: 0 * ±∞ = NaN
        if (isInfinite || other.isInfinite) return Rational.nan;
        return Rational.zero;
      }

      // Handle infinity cases
      if (_isPositiveInfinity) {
        return other._isNegative
            ? Rational.negativeInfinity
            : Rational.infinity;
      }
      if (_isNegativeInfinity) {
        return other._isNegative
            ? Rational.infinity
            : Rational.negativeInfinity;
      }
      if (other._isPositiveInfinity) {
        return _isNegative ? Rational.negativeInfinity : Rational.infinity;
      }
      if (other._isNegativeInfinity) {
        return _isNegative ? Rational.infinity : Rational.negativeInfinity;
      }

      // Normal multiplication for finite values
      return Rational(
        numerator * other.numerator,
        denominator * other.denominator,
      );
    }
    try {
      return this * _fromAny(other);
    } catch (e) {
      throw ArgumentError('Unsupported operand type: ${other.runtimeType}');
    }
  }

  /// Division with a [Decimal] value.
  dynamic operator /(dynamic other) {
    if (other is Rational) {
      // Handle special values
      if (_isNaN || other._isNaN) return Rational.nan;

      // Handle division by zero
      if (other.numerator == _i0 && !other.isInfinite) {
        if (numerator == _i0 && !isInfinite) return Rational.nan; // 0/0 = NaN
        return _isNegative ? Rational.negativeInfinity : Rational.infinity;
      }

      // Handle infinity cases
      if (_isPositiveInfinity) {
        if (other.isInfinite) return Rational.nan; // ∞/∞ = NaN
        return other._isNegative
            ? Rational.negativeInfinity
            : Rational.infinity;
      }
      if (_isNegativeInfinity) {
        if (other.isInfinite) return Rational.nan; // -∞/∞ = NaN
        return other._isNegative
            ? Rational.infinity
            : Rational.negativeInfinity;
      }
      if (other._isPositiveInfinity || other._isNegativeInfinity) {
        return Rational.zero; // finite/∞ = 0
      }

      // Normal division for finite values
      return Rational(
        numerator * other.denominator,
        denominator * other.numerator,
      );
    }
    try {
      return this / _fromAny(other);
    } catch (e) {
      throw ArgumentError('Unsupported operand type: ${other.runtimeType}');
    }
  }

  /// Modulo with a [Decimal] value.
  dynamic operator %(dynamic other) {
    if (other is Rational) {
      // Handle special values
      if (_isNaN || other._isNaN) return Rational.nan;
      if (isInfinite) return Rational.nan; // ∞ % anything = NaN
      if (other.isInfinite) return this; // finite % ∞ = finite
      if (other.numerator == _i0) return Rational.nan; // anything % 0 = NaN

      // Normal modulo for finite values
      final remainder = this.remainder(other);
      if (remainder == _r0) return _r0;
      return remainder + (_isNegative && remainder != _r0 ? other.abs() : _r0);
    }
    try {
      return this % _fromAny(other);
    } catch (e) {
      throw ArgumentError('Unsupported operand type: ${other.runtimeType}');
    }
  }

  /// Truncating division with a [Decimal] value.
  dynamic operator ~/(dynamic other) {
    if (other is Rational) {
      // Handle special values
      if (_isNaN || other._isNaN) return Rational.nan;
      if (isInfinite && other.isInfinite) return Rational.nan; // ∞ ~/ ∞ = NaN
      if (isInfinite) {
        return _isPositiveInfinity
            ? Rational.infinity
            : Rational.negativeInfinity;
      }
      if (other.isInfinite) return Rational.zero; // finite ~/ ∞ = 0
      if (other.numerator == _i0) {
        if (numerator == _i0) return Rational.nan; // 0 ~/ 0 = NaN
        return _isNegative ? Rational.negativeInfinity : Rational.infinity;
      }

      // Normal truncating division for finite values
      return (numerator * other.denominator) ~/ (denominator * other.numerator);
    }
    try {
      return this ~/ _fromAny(other);
    } catch (e) {
      throw ArgumentError('Unsupported operand type: ${other.runtimeType}');
    }
  }

  /// Returns the negative value of this rational.
  Rational operator -() {
    if (_isNaN) return Rational.nan;
    if (_isPositiveInfinity) return Rational.negativeInfinity;
    if (_isNegativeInfinity) return Rational.infinity;
    return Rational(-numerator, denominator);
  }

  /// Returns the remainder from dividing this [Rational] by [other].
  Rational remainder(Rational other) {
    // Handle special values
    if (_isNaN || other._isNaN) return Rational.nan;
    if (isInfinite) return Rational.nan;
    if (other.isInfinite) return this;
    if (other.numerator == _i0) return Rational.nan;

    // Normal remainder for finite values
    return this - Rational(this ~/ other) * other;
  }

  /// Whether this number is numerically smaller than [other].
  bool operator <(dynamic other) {
    if (other is Rational) {
      return compareTo(other) < 0;
    }
    try {
      return this < _fromAny(other);
    } catch (e) {
      throw ArgumentError('Unsupported operand type: ${other.runtimeType}');
    }
  }

  /// Whether this number is numerically smaller than or equal to [other].
  bool operator <=(dynamic other) {
    if (other is Rational) {
      return compareTo(other) <= 0;
    }
    try {
      return this <= _fromAny(other);
    } catch (e) {
      throw ArgumentError('Unsupported operand type: ${other.runtimeType}');
    }
  }

  /// Whether this number is numerically greater than [other].
  bool operator >(dynamic other) {
    if (other is Rational) {
      return compareTo(other) > 0;
    }
    try {
      return this > _fromAny(other);
    } catch (e) {
      throw ArgumentError('Unsupported operand type: ${other.runtimeType}');
    }
  }

  /// Whether this number is numerically greater than or equal to [other].
  bool operator >=(dynamic other) {
    if (other is Rational) {
      return compareTo(other) >= 0;
    }

    try {
      return this >= _fromAny(other);
    } catch (e) {
      throw ArgumentError('Unsupported operand type: ${other.runtimeType}');
    }
  }

  bool get _isNegative => numerator < _i0;

  /// Returns the absolute value of `this`.
  Rational abs() => _isNegative ? (-this) : this;

  /// The sign function value of `this`.
  ///
  /// E.e. -1, 0 or 1 as the value of this [Rational] is negative, zero or positive.
  int get sign {
    final v = compareTo(_r0);
    if (v < 0) return -1;
    if (v > 0) return 1;
    return 0;
  }

  /// Checks if the fraction is a whole number.
  bool isWhole() {
    return numerator % denominator == BigInt.zero;
  }

  /// Checks if the fraction is improper.
  bool isImproper() {
    return numerator >= denominator;
  }

  /// Checks if the fraction is proper.
  bool isProper() {
    return numerator < denominator;
  }

  /// Returns the [BigInt] value closest to this number.
  ///
  /// Rounds away from zero when there is no closest integer:
  /// `(3.5).round() == 4` and `(-3.5).round() == -4`.
  dynamic round() {
    final abs = this.abs();
    final absBy10 = abs * _r10;
    var r = abs.truncate();
    if (absBy10 % _r10 >= _r5) r += _i1;
    return _isNegative ? -r : r;
  }

  /// Returns the greatest [BigInt] value no greater than this [Rational].
  dynamic floor() => isInteger
      ? truncate()
      : _isNegative
          ? (truncate() - _i1)
          : truncate();

  /// Returns the least [BigInt] value that is no smaller than this [Rational].
  dynamic ceil() => isInteger
      ? truncate()
      : _isNegative
          ? truncate()
          : (truncate() + _i1);

  /// The [BigInt] obtained by discarding any fractional digits from `this`.
  dynamic truncate() => numerator ~/ denominator;

  /// Clamps `this` to be in the range [lowerLimit]-[upperLimit].
  Rational clamp(Rational lowerLimit, Rational upperLimit) => this < lowerLimit
      ? lowerLimit
      : this > upperLimit
          ? upperLimit
          : this;

  // Returns the square of this rational number.
  Rational square() => this * this;

  /// Optimized method to calculate the cube of this Decimal
  Rational cube() => this * this * this;

  /// The [BigInt] obtained by discarding any fractional digits from `this`.
  ///
  /// Equivalent to [truncate].
  BigInt toBigInt() => truncate();

  /// Returns `this` as a [double].
  ///
  /// If the number is not representable as a [double], an approximation is
  /// returned. For numerically large integers, the approximation may be
  /// infinite.
  double toDouble() {
    // Handle special cases
    if (_isNaN) return double.nan;
    if (_isPositiveInfinity) return double.infinity;
    if (_isNegativeInfinity) return double.negativeInfinity;

    // Handle special cases to avoid precision loss
    if (numerator == _i0) return 0.0;
    if (denominator == _i1) return numerator.toDouble();

    // For large numbers, calculate with care to avoid overflow
    if (numerator.abs() > BigInt.from(1 << 53) ||
        denominator > BigInt.from(1 << 53)) {
      // Use logarithmic division for very large numbers
      final numDigits = numerator.abs().toString().length;
      final denDigits = denominator.toString().length;

      if (numDigits > 15 || denDigits > 15) {
        // Scale down to avoid precision loss
        final scale = BigInt.from(10).pow(numDigits - 1);
        final scaledNum = numerator ~/ scale;
        final result = scaledNum.toDouble() / (denominator ~/ scale).toDouble();
        return result * (numerator.isNegative ? -1 : 1);
      }
    }

    return numerator / denominator;
  }

  /// Returns `this` to the power of [exponent].
  ///
  /// Returns [one] if the [exponent] equals `0`.
  Rational pow(int exponent) => exponent.isNegative
      ? inverse.pow(-exponent)
      : Rational(
          numerator.pow(exponent),
          denominator.pow(exponent),
        );

  /// Returns a decimal string representation with the specified number of decimal places.
  ///
  /// The [decimalPlaces] parameter specifies the number of digits after the decimal point.
  String toDecimalString(int decimalPlaces) {
    assert(decimalPlaces >= 0, 'Decimal places must be non-negative');

    if (isInteger) return numerator.toString();

    final scaleFactor = BigInt.from(10).pow(decimalPlaces);
    final scaledValue = (numerator * scaleFactor) ~/ denominator;
    final intPart = scaledValue ~/ scaleFactor;
    final fracPart = scaledValue.abs() % scaleFactor;

    // Format the fractional part with leading zeros
    final fracString = fracPart.toString().padLeft(decimalPlaces, '0');

    return '$intPart.$fracString';
  }

  // /// Converts the current [Rational] value to a [Decimal] with the specified precision.
  // ///
  // /// If the [Rational] has a finite precision, it is directly converted to a [Decimal].
  // /// Otherwise, the [Rational] is scaled by the specified [precision] and converted to a [Decimal].
  // ///
  // /// The optional [toBigInt] parameter allows customizing the conversion from [Rational] to [BigInt].
  // /// If not provided, the default behavior is to truncate the [Rational] value.
  // Decimal toDecimal({int? precision}) {
  //   // Avoid infinite recursion by directly creating a Decimal with the current Rational
  //   return Decimal._fromRational(this, precision: precision);
  // }

  /// Returns true if this [Rational] has a finite decimal representation.
  ///
  /// A rational number has a finite decimal representation if and only if
  /// its denominator, when expressed in lowest form, has only 2 and 5 as prime factors.
  bool get hasFinitePrecision {
    if (isInteger) return true;

    // Handle infinite values before factorization check
    if (_isPositiveInfinity || _isNegativeInfinity) return false;

    var d = denominator;
    // Factor out all 2s and 5s from denominator
    for (final factor in [BigInt.two, BigInt.from(5)]) {
      while (d % factor == BigInt.zero) {
        d = d ~/ factor;
      }
    }
    return d == BigInt.one;
  }

  /// Returns the number of decimal places needed to represent this [Rational] exactly.
  ///
  /// Returns null if this [Rational] does not have a finite decimal representation.
  int? get detDecimalPrecision {
    if (!hasFinitePrecision) return null;

    var den = denominator;
    int count = 0;

    // Find the maximum power of 10 that divides the denominator
    while (den != _i1) {
      if (den % BigInt.from(2) == _i0) {
        den = den ~/ BigInt.from(2);
        count++;
      } else if (den % BigInt.from(5) == _i0) {
        den = den ~/ BigInt.from(5);
        count++;
      } else {
        // This should not happen if hasFinitePrecision is true
        return null;
      }
    }

    return count;
  }
}
*/

extension NumToRationalExtension on num {
  // /// Converts this [num] to a [Rational].
  Rational toRational() {
    if (isNaN) return Rational.nan;
    if (isInfinite) {
      return this < 0 ? Rational.negativeInfinity : Rational.infinity;
    }
    return Rational(BigInt.from(this));
  }

  /// Adds this [num] to a [Rational].
  Rational operator +(Rational other) => Rational(BigInt.from(this)) + other;

  /// Subtracts a [Rational] from this [num].
  Rational operator -(Rational other) => Rational(BigInt.from(this)) - other;

  /// Multiplies this [num] by a [Rational].
  Rational operator *(Rational other) => Rational(BigInt.from(this)) * other;

  /// Divides this [num] by a [Rational].
  Rational operator /(Rational other) => Rational(BigInt.from(this)) / other;

  /// Returns the remainder when this [num] is divided by a [Rational].
  Rational operator %(Rational other) => Rational(BigInt.from(this)) % other;

  /// Performs integer division of this [num] by a [Rational].
  BigInt operator ~/(Rational other) => Rational(BigInt.from(this)) ~/ other;
}
