import '../../math/basic/math.dart';
import '../number.dart';

/// Represents a fraction number.
///
/// A fraction is a number expressed as the quotient of two quantities,
/// a numerator and a denominator.
///
/// Example:
/// ```dart
/// final half = Fraction(1, 2);
/// print(half);  // Outputs: 1/2
/// ```
class Fraction extends Double {
  /// Constructs a fraction from a numerator and a denominator.
  ///
  /// The [numerator] is the number above the line in a common fraction.
  /// The [denominator] is the number below the line in a common fraction.
  /// The default value of [denominator] is 1.
  ///
  /// Throws [ArgumentError] if the denominator is zero.
  Fraction(this.numerator, [this.denominator = 1])
      : super(numerator / denominator);

  /// Constructs a fraction from a whole number and a ratio.
  ///
  /// For example, `Fraction.mixed(2, 3, 4)` would represent the fraction
  /// "2 3/4".
  Fraction.mixed(int whole, int numer, this.denominator)
      : numerator = numer + (whole * denominator),
        super((whole * denominator + numer) / denominator);

  /// The number above the line in a common fraction.
  final int numerator;

  /// The number below the line in a common fraction.
  final int denominator;

  /// Returns the whole number part of the fraction.
  int get whole {
    var result = numerator ~/ denominator;
    return result == 0 ? 1 : result;
  }

  /// Attempts to parse a [Fraction] from a string representation.
  ///
  /// Supports mixed numbers, simple fractions, and whole numbers.
  ///
  /// Returns `null` if the input string cannot be parsed into a fraction.
  ///
  /// Examples:
  /// ```dart
  /// Fraction.tryParse('1/5'); // Returns: 1/5
  /// Fraction.tryParse('2 4/7'); // Returns: 2 4/7
  /// Fraction.tryParse('3'); // Returns: 3/1
  /// Fraction.tryParse(''); // Returns: null
  /// ```
  static Fraction? tryParse(String input) {
    // Trim any leading or trailing white space
    input = input.trim();

    // Check if the input is empty
    if (input.isEmpty) {
      return null;
    }

    // Pattern for a whole number and fraction combination (e.g., "2 4/7")
    final mixedPattern = RegExp(r'^(\d+)\s+(\d+)/(\d+)$');
    // Pattern for a simple fraction (e.g., "1/5")
    final simplePattern = RegExp(r'^(\d+)/(\d+)$');
    // Pattern for a whole number (e.g., "3")
    final wholePattern = RegExp(r'^(\d+)$');

    if (mixedPattern.hasMatch(input)) {
      final match = mixedPattern.firstMatch(input)!;
      final whole = int.parse(match[1]!);
      final numer = int.parse(match[2]!);
      final denom = int.parse(match[3]!);
      return Fraction.mixed(whole, numer, denom);
    } else if (simplePattern.hasMatch(input)) {
      final match = simplePattern.firstMatch(input)!;
      final numer = int.parse(match[1]!);
      final denom = int.parse(match[2]!);
      return Fraction(numer, denom);
    } else if (wholePattern.hasMatch(input)) {
      final whole = int.parse(input);
      return Fraction(whole);
    } else {
      return null;
    }
  }

  /// Simplifies the fraction to its simplest form.
  ///
  /// For example, the fraction 4/8 would be simplified to 1/2.
  Number simplify() {
    num gcdValue = gcd([numerator, denominator]);
    return Number.simplifyType(
        Fraction(numerator ~/ gcdValue, denominator ~/ gcdValue));
  }

  // Returns the inverse of the fraction.
  Fraction inverse() {
    if (numerator == 0) {
      throw Exception(
          'Cannot compute the inverse of a fraction with a numerator of zero.');
    }
    return Fraction(denominator, numerator);
  }

  /// Checks if the fraction is a whole number.
  bool isWhole() {
    return numerator % denominator == 0;
  }

  /// Checks if the fraction is improper.
  bool isImproper() {
    return numerator >= denominator;
  }

  /// Checks if the fraction is proper.
  bool isProper() {
    return numerator < denominator;
  }

  /// Converts the fraction to its string representation.
  ///
  /// If the fraction represents a mixed number (e.g., "2 4/7"),
  /// it will be returned in that form.
  @override
  String toString([bool asFraction = false]) {
    return numerator > denominator
        ? "$whole ${numerator % denominator}/$denominator"
        : "$numerator/$denominator";
  }
}
