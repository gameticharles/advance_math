part of '../../expression.dart';

/// A class that represents a quadratic equation that
/// implementation of [Polynomial] that represents a second degree
/// polynomial equation in the form _ax^2 + bx + c = 0_.
///
/// The coefficients a, b, and c are numbers, and a cannot be 0.
///
/// This equation has exactly 2 roots, both real or both complex, depending
/// on the value of the discriminant.
///
/// The solutions of the equation are given by the formula:
/// _x = [-b ± sqrt(b^2 - 4ac)] / 2a_
///
/// Example:
/// ```dart
/// var quadratic = Quadratic(1, -3, 2);
/// print(quadratic.roots()); // Output: [2.0, 1.0]
/// print(quadratic.vertex()); // Output: Point(1.5, -1.0)
/// ```
class Quadratic extends Polynomial {
  /// Constructs a quadratic equation with coefficients [a], [b], and [c].
  Quadratic({
    Number a = Integer.one,
    Number b = Integer.zero,
    Number c = Integer.zero,
  }) : super([a, b, c]);

  /// Constructs a quadratic equation with coefficients [a], [b], and [c].
  Quadratic.num({num a = 1, num b = 0, num c = 0})
      : super([numToNumber(a), numToNumber(b), numToNumber(c)]);

  Quadratic.fromList(List<Number> coefficients) : super(coefficients) {
    if (coefficients.length != 3) {
      throw ArgumentError('The input list must contain exactly 3 elements.');
    }
  }

  /// The first coefficient of the equation in the form
  /// _f(x) = ax^2 + bx + c = 0_
  Number get a => coefficients.first;

  /// The second coefficient of the equation in the form
  /// _f(x) = ax^2 + bx + c = 0_
  Number get b => coefficients[1];

  /// The third coefficient of the equation in the form
  /// _f(x) = ax^2 + bx + c = 0_
  Number get c => coefficients[2];

  /// Returns the discriminant of the quadratic equation, which is b^2 - 4ac.
  @override
  Number discriminant() => (b * b) - Complex.fromReal(4) * a * c;

  /// Returns the roots of the quadratic equation as a list.
  ///
  /// If the discriminant is less than zero, the roots are complex and are returned as a list of complex numbers.
  /// If the discriminant is zero, there is one real root, which is returned as a list with one number.
  /// If the discriminant is greater than zero, there are two real roots, which are returned as a list with two numbers.
  @override
  List<Number> roots() {
    final disc = discriminant();
    final twoA = Complex.fromReal(2) * a;

    return <Number>[(-b + disc.sqrt()) / twoA, (-b - disc.sqrt()) / twoA];
  }

  /// Returns the vertex of the quadratic equation as a [Point].
  ///
  /// The vertex is the point that represents the minimum or maximum of the quadratic Polynomial.
  Point vertex() {
    var x = -b / (a * 2);
    var y = c - b * b / (a * 4);
    return Point(numberToNum(x), numberToNum(y));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Quadratic && a == other.a && b == other.b && c == other.c;

  @override
  int get hashCode => a.hashCode ^ b.hashCode ^ c.hashCode;

  /// Evaluates the quadratic equation at the given x.
  ///
  /// Example:
  /// ```dart
  /// var quad = Quadratic(2, -3, -2);
  /// print(quad.evaluate(2)); // Output: 2
  /// ```
  // num evaluate(num x) {
  //   return a * x * x + b * x + c;
  // }

  /// Returns the sum of the roots of the quadratic equation.
  ///
  /// Example:
  /// ```dart
  /// var quad = Quadratic(2, -3, -2);
  /// print(quad.sumOfRoots()); // Output: 1.5
  /// ```
  Number sumOfRoots() {
    return -b / a;
  }

  /// Returns the product of the roots of the quadratic equation.
  ///
  /// Example:
  /// ```dart
  /// var quad = Quadratic(2, -3, -2);
  /// print(quad.productOfRoots()); // Output: -1
  /// ```
  Number productOfRoots() {
    return c / a;
  }

  /// Returns the direction of opening of the parabola represented by the quadratic equation.
  ///
  /// Example:
  /// ```dart
  /// var quad = Quadratic(2, -3, -2);
  /// print(quad.directionOfOpening()); // Output: "Upwards"
  /// var quad2 = Quadratic(-2, -3, -2);
  /// print(quad2.directionOfOpening()); // Output: "Downwards"
  /// ```
  String directionOfOpening() {
    if (a > 0) {
      return "Upwards";
    } else if (a < 0) {
      return "Downwards";
    }
    return "Not a parabola";
  }

  @override
  Expression expand() {
    return this;
  }
}
