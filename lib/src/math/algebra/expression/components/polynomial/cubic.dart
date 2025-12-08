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
    Variable? variable,
  }) : super([a, b, c, d], variable: variable);

  /// Constructs a quadratic equation with coefficients [a], [b], and [c].
  Cubic.num({
    num a = 1,
    num b = 0,
    num c = 0,
    num d = 0,
    Variable? variable,
  }) : super([
          Literal(Complex(a)),
          Literal(Complex(b)),
          Literal(Complex(c)),
          Literal(Complex(d))
        ], variable: variable);

  Cubic.fromList(List<dynamic> coefficients, {Variable? variable})
      : super(coefficients, variable: variable) {
    if (coefficients.length != 4) {
      throw ArgumentError('The input list must contain exactly 4 elements.');
    }
  }

  @override
  Expression discriminant() {
    final p1 = c * c * b * b;
    final p2 = d * b * b * b * Literal(4);
    final p3 = c * c * c * a * Literal(4);
    final p4 = a * b * c * d * Literal(18);
    final p5 = d * d * a * a * Literal(27);

    return p1 - p2 - p3 + p4 - p5;
  }

  @override
  List<Expression> roots() {
    var two = Literal(2);
    var three = Literal(3);
    // sigma = -1/2 + i*sqrt(3)/2
    final sigma = Literal(Complex(-0.5, 0.5 * sqrt(3)));

    final d0 = b * b - a * c * three;

    final d1 = (two * Pow(b, three)) -
        (a * b * c * Literal(9)) +
        (a * a * d * Literal(27));

    // Check for triple root case (d0 = 0 and d1 = 0)
    bool d0Zero = false;
    bool d1Zero = false;

    if (d0 is Literal && d0.value == 0) {
      d0Zero = true;
    } else if (d0.evaluate() == 0 ||
        (d0.evaluate() is Complex &&
            (d0.evaluate() as Complex).abs() < 1e-10)) {
      d0Zero = true;
    }

    if (d1 is Literal && d1.value == 0) {
      d1Zero = true;
    } else if (d1.evaluate() == 0 ||
        (d1.evaluate() is Complex &&
            (d1.evaluate() as Complex).abs() < 1e-10)) {
      d1Zero = true;
    }

    if (d0Zero && d1Zero) {
      // x = -b / (3a)
      final root = (Literal(0) - b) / (a * three);
      return [root, root, root];
    }

    // sqrtD = sqrt(-27 * a^2 * discriminant)
    final sqrtD = Pow(discriminant() * a * a * Literal(-27), Literal(0.5));

    // C = ((d1 + sqrtD) / 2)^(1/3)
    Expression C = Pow((d1 + sqrtD) / two, Literal(1.0 / 3.0));

    // Check for C being zero (to avoid division by zero)
    // If C is zero, it implies d0 is also zero (triple root case)
    try {
      bool isZero = false;
      if (C is Literal) {
        if (C.value == 0) isZero = true;
        if (C.value is Complex && (C.value as Complex) == Complex.zero()) {
          isZero = true;
        }
      }

      if (!isZero) {
        final cVal = C.evaluate();
        if (cVal is num && cVal == 0) isZero = true;
        if (cVal is Complex && cVal.abs().real < 1e-10) isZero = true;
      }

      if (isZero) {
        // C is zero, so we use the handling for triple root
        // x = -b / (3a)
        final root = (Literal(0) - b) / (a * three);
        return [root, root, root];
      }
    } catch (e) {
      // Evaluation might fail for generic variables, proceed with standard formula
      // but risky.
    }

    final constTerm = Literal(-1) / (a * three);

    return <Expression>[
      constTerm * (b + C + (d0 / C)),
      constTerm * (b + (C * sigma) + (d0 / (C * sigma))),
      constTerm * (b + (C * Pow(sigma, two)) + (d0 / (C * Pow(sigma, two)))),
    ];
  }

  /// The first coefficient of the equation in the form
  /// _f(x) = ax^3 + bx^2 + cx + d = 0_
  Expression get a => coefficients.first;

  /// The second coefficient of the equation in the form
  /// _f(x) = ax^3 + bx^2 + cx + d = 0_
  Expression get b => coefficients[1];

  /// The third coefficient of the equation in the form
  /// _f(x) = ax^3 + bx^2 + cx + d = 0_
  Expression get c => coefficients[2];

  /// The fourth coefficient of the equation in the form
  /// _f(x) = ax^3 + bx^2 + cx + d = 0_
  Expression get d => coefficients[3];

  /// Creates a deep copy of the object with optional new values.
  Cubic copyWith({
    Expression? a,
    Expression? b,
    Expression? c,
    Expression? d,
    Variable? variable,
  }) =>
      Cubic(
        a: a ?? this.a,
        b: b ?? this.b,
        c: c ?? this.c,
        d: d ?? this.d,
        variable: variable ?? this.variable,
      );

  @override
  Expression expand() {
    return this;
  }
}
