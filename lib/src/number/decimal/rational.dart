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
/// remaining robust enough to handle `[Infinity]`, `[NaN]`, and arbitrary precision.
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
