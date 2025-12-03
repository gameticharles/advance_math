part of '../../expression.dart';

/// Concrete implementation of [Polynomial] that represents a fourth degree
/// polynomial equation in the form _ax^4 + bx^3 + cx^2 + dx + e = 0_.
///
/// This equation has 4 solutions, which can be combined as follows:
///
///  - 2 distinct real roots and 2 complex conjugate roots
///  - 4 real roots and 0 complex roots
///  - 0 real roots and 4 complex conjugate roots
///  - Multiple roots which can be all equal or paired (complex or real)
///
/// The above cases depend on the value of the discriminant.
class Quartic extends Polynomial {
  /// These are examples of quartic equations, where the coefficient with the
  /// highest degree goes first:
  ///
  /// ```dart
  /// // f(x) = -x^4 - 8x^3 - 1
  /// final eq = Quartic(
  ///   a: Complex.fromReal(-1),
  ///   b: Complex.fromReal(-8),
  ///   e: Complex.fromReal(-1),
  /// );
  ///
  /// // f(x) = ix^4 - ix^2 + 6
  /// final eq = Quartic(
  ///   a: Complex.fromImaginary(1),
  ///   c: Complex.fromImaginary(-1),
  ///   e: Complex.fromReal(6),
  /// );
  /// ```
  ///
  /// Use this constructor if you have complex coefficients. If no [Complex]
  /// values are required, then consider using [Quartic.realEquation] for a
  /// less verbose syntax.
  Quartic({
    dynamic a = 1,
    dynamic b = 0,
    dynamic c = 0,
    dynamic d = 0,
    dynamic e = 0,
    Variable? variable,
  }) : super([a, b, c, d, e], variable: variable);

  /// This is an example of a quartic equations, where the coefficient with the
  /// highest degree goes first:
  ///
  /// ```dart
  /// // f(x) = -x^4 - 8x^3 - 1
  /// final eq = Quartic.realEquation(
  ///   a: Complex.fromReal(-1),
  ///   b: Complex.fromReal(-8),
  ///   e: Complex.fromReal(-1),
  /// );
  /// ```
  ///
  /// If the coefficients of your polynomial contain complex numbers, consider
  /// using the [Quartic.new] constructor instead.
  /// If the coefficients of your polynomial contain complex numbers, consider
  /// using the [Quartic.new] constructor instead.
  Quartic.num({
    num a = 1,
    num b = 0,
    num c = 0,
    num d = 0,
    num e = 0,
    Variable? variable,
  }) : super([
          Literal(Complex(a)),
          Literal(Complex(b)),
          Literal(Complex(c)),
          Literal(Complex(d)),
          Literal(Complex(e))
        ], variable: variable);

  Quartic.fromList(List<dynamic> coefficients, {Variable? variable})
      : super(coefficients, variable: variable) {
    if (coefficients.length != 5) {
      throw ArgumentError('The input list must contain exactly 5 elements.');
    }
  }

  @override
  Expression discriminant() {
    final k = (b * b * c * c * d * d) -
        (d * d * d * b * b * b * Literal(4)) -
        (d * d * c * c * c * a * Literal(4)) +
        (d * d * d * c * b * a * Literal(18)) -
        (d * d * d * d * a * a * Literal(27)) +
        (e * e * e * a * a * a * Literal(256));

    final p = e *
        ((c * c * c * b * b * Literal(-4)) +
            (b * b * b * c * d * Literal(18)) +
            (c * c * c * c * a * Literal(16)) -
            (d * c * c * b * a * Literal(80)) -
            (d * d * b * b * a * Literal(6)) +
            (d * d * a * a * c * Literal(144)));

    final r = (e * e) *
        (b * b * b * b * Literal(-27) +
            b * b * c * a * Literal(144) -
            a * a * c * c * Literal(128) -
            d * b * a * a * Literal(192));

    return k + p + r;
  }

  @override
  List<Expression> roots() {
    final fb = b / a;
    final fc = c / a;
    final fd = d / a;
    final fe = e / a;

    final q1 = (fc * fc) - (fb * fd * Literal(3)) + (fe * Literal(12));
    final q2 = (Pow(fc, Literal(3)) * Literal(2)) -
        (fb * fc * fd * Literal(9)) +
        (Pow(fd, Literal(2)) * Literal(27)) +
        (Pow(fb, Literal(2)) * fe * Literal(27)) -
        (fc * fe * Literal(72));
    final q3 = (fb * fc * Literal(8)) -
        (fd * Literal(16)) -
        (Pow(fb, Literal(3)) * Literal(2));
    final q4 = (Pow(fb, Literal(2)) * Literal(3)) - (fc * Literal(8));

    var temp = (q2 * q2 / Literal(4)) - (Pow(q1, Literal(3)));
    final q5 =
        Pow(Pow(temp, Literal(0.5)) + (q2 / Literal(2)), Literal(1.0 / 3.0));
    final q6 = ((q1 / q5) + q5) / Literal(3);
    temp = (q4 / Literal(12)) + q6;
    final q7 = Pow(temp, Literal(0.5)) * Literal(2);
    temp = ((q4 * Literal(4)) / Literal(6)) - (q6 * Literal(4)) - (q3 / q7);

    final solutions = [
      (-fb - q7 - Pow(temp, Literal(0.5))) / Literal(4),
      (-fb - q7 + Pow(temp, Literal(0.5))) / Literal(4),
    ];

    temp = ((q4 * Literal(4)) / Literal(6)) - (q6 * Literal(4)) + (q3 / q7);

    solutions
      ..add((-fb + q7 - Pow(temp, Literal(0.5))) / Literal(4))
      ..add((-fb + q7 + Pow(temp, Literal(0.5))) / Literal(4));

    return solutions;
  }

  /// The first coefficient of the equation in the form
  /// _f(x) = ax^4 + bx^3 + cx^2 + dx + e = 0_
  Expression get a => coefficients.first;

  /// The second coefficient of the equation in the form
  /// _f(x) = ax^4 + bx^3 + cx^2 + dx + e = 0_
  Expression get b => coefficients[1];

  /// The third coefficient of the equation in the form
  /// _f(x) = ax^4 + bx^3 + cx^2 + dx + e = 0_
  Expression get c => coefficients[2];

  /// The fourth coefficient of the equation in the form
  /// _f(x) = ax^4 + bx^3 + cx^2 + dx + e = 0_
  Expression get d => coefficients[3];

  /// The fifth coefficient of the equation in the form
  /// _f(x) = ax^4 + bx^3 + cx^2 + dx + e = 0_
  Expression get e => coefficients[4];

  Quartic copyWith({
    Expression? a,
    Expression? b,
    Expression? c,
    Expression? d,
    Expression? e,
    Variable? variable,
  }) =>
      Quartic(
        a: a ?? this.a,
        b: b ?? this.b,
        c: c ?? this.c,
        d: d ?? this.d,
        e: e ?? this.e,
        variable: variable ?? this.variable,
      );

  @override
  Expression expand() {
    return this;
  }
}
