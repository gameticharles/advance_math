part of '../../expression.dart';

/// Concrete implementation of [Polynomial] that represents a third degree
/// polynomial equation in the form `ax^3 + bx^2 + cx + d = 0`.
///
/// This equation has 3 solutions, which can be combined as follows:
///
///  - 3 distinct real roots and 0 complex roots
///  - 3 real roots (some of them are equal) and 0 complex roots
///  - 1 real root and 2 complex conjugate roots
///
/// The above cases depend on the value of the discriminant.
class Cubic extends Polynomial {
  Cubic({
    dynamic a = 1,
    dynamic b = 0,
    dynamic c = 0,
    dynamic d = 0,
  }) : super([a, b, c, d]);

  /// Constructs a quadratic equation with coefficients [a], [b], and [c].
  Cubic.num({num a = 1, num b = 0, num c = 0, num d = 0})
      : super([a, b, c, d]);

  Cubic.fromList(List<dynamic> coefficients) : super(coefficients) {
    if (coefficients.length != 4) {
      throw ArgumentError('The input list must contain exactly 4 elements.');
    }
  }

  @override
  dynamic discriminant() {
    final p1 = c * c * b * b;
    final p2 = d * b * b * b * Complex.fromReal(4);
    final p3 = c * c * c * a * Complex.fromReal(4);
    final p4 = a * b * c * d * Complex.fromReal(18);
    final p5 = d * d * a * a * Complex.fromReal(27);

    return p1 - p2 - p3 + p4 - p5;
  }

  @override
  List<dynamic> roots() {
    var two = Complex.fromReal(2);
    var three = Complex.fromReal(3);
    final sigma = Complex(-1 / 2, 1 / 2 * sqrt(3));

    final d0 = b * b - a * c * three;
    final d1 = (two * pow(b.toDouble(), 3)) -
        (a * b * c * Complex.fromReal(9)) +
        (a * a * d * Complex.fromReal(27));
    final sqrtD = (discriminant() * a * a * Complex.fromReal(-27)).sqrt();
    final C = ((d1 + sqrtD) / two).nthRoot(3);
    final constTerm = Complex.fromReal(-1) / (a * three);

    return <dynamic>[
      constTerm * (b + C + (d0 / C)),
      constTerm * (b + (C * sigma) + (d0 / (C * sigma))),
      constTerm * (b + (C * sigma.pow(2)) + (d0 / (C * sigma.pow(2)))),
    ];
  }

  /// The first coefficient of the equation in the form
  /// _f(x) = ax^3 + bx^2 + cx + d = 0_
  dynamic get a => coefficients.first.simplify();

  /// The second coefficient of the equation in the form
  /// _f(x) = ax^3 + bx^2 + cx + d = 0_
  dynamic get b => coefficients[1].simplify();

  /// The third coefficient of the equation in the form
  /// _f(x) = ax^3 + bx^2 + cx + d = 0_
  dynamic get c => coefficients[2].simplify();

  /// The fourth coefficient of the equation in the form
  /// _f(x) = ax^3 + bx^2 + cx + d = 0_
  dynamic get d => coefficients[3].simplify();

  /// {@macro algebraic_deep_copy}
  Cubic copyWith({
    dynamic a,
    dynamic b,
    dynamic c,
    dynamic d,
  }) =>
      Cubic(
        a: a ?? this.a,
        b: b ?? this.b,
        c: c ?? this.c,
        d: d ?? this.d,
      );

  @override
  Expression expand() {
    return this;
  }
}
