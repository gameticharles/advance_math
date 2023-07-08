part of algebra;

/// Concrete implementation of [Polynomial] that represents a first degree
/// polynomial equation in the form _ax + b = 0_.
///
/// This equation has exactly 1 solution, which can be real or complex.
class Linear extends Polynomial {
  Linear({
    Number a = Integer.one,
    Number b = Integer.zero,
  }) : super([a, b]);

  Linear.num({
    num a = 1,
    num b = 0,
  }) : super([numToNumber(a), numToNumber(b)]);

  Linear.fromList(List<Number> coefficients) : super(coefficients) {
    if (coefficients.length != 2) {
      throw ArgumentError('The input list must contain exactly 2 elements.');
    }
  }

  @override
  Number discriminant() => Complex.fromReal(1);

  @override
  List<Number> roots() => [-b / a];

  /// The first coefficient of the equation in the form _f(x) = ab + b_.
  Number get a => coefficients.first;

  /// The second coefficient of the equation in the form _f(x) = ab + b_.
  Number get b => coefficients[1];

  Linear copyWith({
    Complex? a,
    Complex? b,
  }) =>
      Linear(
        a: a ?? this.a,
        b: b ?? this.b,
      );
}
