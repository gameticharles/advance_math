import 'double.dart';

/// A convenient way to represent fractional numbers.
class Fraction extends Double {
  /// Constructs a fraction from a numerator and denominator.
  Fraction(this.numerator, this.denominator) : super(numerator / denominator);

  /// Constructs a fraction from a whole number and a ratio (for example, 12 3/4).
  Fraction.mixed(int whole, int numer, this.denominator)
      : numerator = numer + (whole * denominator),
        super((whole * denominator + numer) / denominator);

  /// The number above the line in a common fraction.
  final int numerator;

  /// The number below the line in a common fraction.
  final int denominator;
}
