part of algebra;

/// Concrete implementation of [Algebraic] that represents a constant value
/// `a`. It can be either real or complex.
///
/// For example:
///
///   - f(x) = 5
///   - f(x) = 3 + 6i
///
/// In the context of a polynomial with one variable, the non-zero constant
/// function is a polynomial of degree 0.
final class Constant extends Polynomial {
  /// The only coefficient of the polynomial is represented by a [Complex]
  /// number [a].
  Constant({
    Number a = Integer.zero,
  }) : super([a]);

  /// The only coefficient of the polynomial is represented by a [double]
  /// (real) number [a].
  Constant.num({
    num a = 1,
  }) : super([numToNumber(a)]);

  @override
  Number discriminant() => Complex(double.nan, double.nan);

  @override
  List<Number> roots() => const [];

  /// The constant coefficient.
  Number get a => coefficients.first;

  Constant copyWith({Complex? a}) => Constant(a: a ?? this.a);
}
