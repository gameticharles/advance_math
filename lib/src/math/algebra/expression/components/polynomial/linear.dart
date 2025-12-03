part of '../../expression.dart';

/// Concrete implementation of [Polynomial] that represents a first degree
/// polynomial equation in the form _ax + b = 0_.
///
/// This equation has exactly 1 solution, which can be real or complex.
class Linear extends Polynomial {
  Linear({
    dynamic a = 1,
    dynamic b = 0,
    Variable? variable,
  }) : super([a, b], variable: variable);

  Linear.num({
    num a = 1,
    num b = 0,
    Variable? variable,
  }) : super([Literal(Complex(a)), Literal(Complex(b))], variable: variable);

  Linear.fromList(List<dynamic> coefficients, {Variable? variable})
      : super(coefficients, variable: variable) {
    if (coefficients.length != 2) {
      throw ArgumentError('The input list must contain exactly 2 elements.');
    }
  }

  @override
  Expression discriminant() => Literal(1);

  @override
  List<Expression> roots() => [-b / a];

  /// The first coefficient of the equation in the form _f(x) = ab + b_.
  Expression get a => coefficients.first;

  /// The second coefficient of the equation in the form _f(x) = ab + b_.
  Expression get b => coefficients[1];

  Linear copyWith({
    Expression? a,
    Expression? b,
    Variable? variable,
  }) =>
      Linear(
        a: a ?? this.a,
        b: b ?? this.b,
        variable: variable ?? this.variable,
      );

  @override
  Expression expand() {
    return this;
  }
}
