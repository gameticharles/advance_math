part of '../../expression.dart';

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
    dynamic a = 0,
  }) : super([a]);

  /// The only coefficient of the polynomial is represented by a [double]
  /// (real) number [a].
  Constant.num({
    num a = 1,
  }) : super([a]);

  @override
  dynamic discriminant() => Complex(double.nan, double.nan);

  @override
  List<dynamic> roots() => const [];

  /// The constant coefficient.
  dynamic get a => coefficients.first.simplify();

  Constant copyWith({Complex? a}) => Constant(a: a ?? this.a);

  @override
  Expression expand() {
    return this;
  }
}
