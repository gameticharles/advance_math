part of '../../expression.dart';

/// Concrete implementation of [Polynomial] that represents a first degree
/// polynomial equation in the form _ax + b = 0_.
///
/// This equation has exactly 1 solution, which can be real or complex.
class Linear extends Polynomial {
  Linear({
    dynamic a = 1,
    dynamic b = 0,
  }) : super([a, b]);

  Linear.num({
    num a = 1,
    num b = 0,
  }) : super([a, b]);

  Linear.fromList(List<dynamic> coefficients) : super(coefficients) {
    if (coefficients.length != 2) {
      throw ArgumentError('The input list must contain exactly 2 elements.');
    }
  }

  @override
  dynamic discriminant() => 1;

  @override
  List<dynamic> roots() => [-b / a];

  /// The first coefficient of the equation in the form _f(x) = ab + b_.
  dynamic get a => coefficients.first.simplify();

  /// The second coefficient of the equation in the form _f(x) = ab + b_.
  dynamic get b => coefficients[1].simplify();

  Linear copyWith({
    Complex? a,
    Complex? b,
  }) =>
      Linear(
        a: a ?? this.a,
        b: b ?? this.b,
      );

  @override
  Expression expand() {
    return this;
  }
}
