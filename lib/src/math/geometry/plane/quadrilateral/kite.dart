part of '../../geometry.dart';

/// A class representing a Kite in 2D space.
///
/// A kite is a quadrilateral with two pairs of equal-length adjacent sides.
///
/// Properties:
/// - Side lengths: two sides of length `a`, two sides of length `b`
/// - Perpendicular diagonals: symmetry diagonal `d1` and transverse diagonal `d2`
/// - Angle `theta` in radians between the unequal sides
class Kite extends PlaneGeometry {
  /// First side length
  final double? a;

  /// Second side length
  final double? b;

  /// Angle in radians between unequal sides
  final double? theta;

  /// Symmetry diagonal (splits equal angles)
  final double? d1;

  /// Transverse diagonal (connects equal-angle vertices)
  final double? d2;

  /// Constructs a Kite with two adjacent side lengths [a] and [b] and the angle [theta] in radians between them.
  Kite({required double a, required double b, required double theta})
      : a = a,
        b = b,
        theta = theta,
        d1 = dmath.sqrt(a * a + b * b - 2 * a * b * dmath.cos(theta)),
        d2 = dmath.sqrt(a * a + b * b - 2 * a * b * dmath.cos(theta)) == 0
            ? 0.0
            : (2 * a * b * dmath.sin(theta)) / dmath.sqrt(a * a + b * b - 2 * a * b * dmath.cos(theta)),
        super("Kite") {
    if (a <= 0 || b <= 0) {
      throw ArgumentError('Side lengths must be positive.');
    }
  }

  /// Constructs a Kite from its perpendicular diagonals [diagonal1] and [diagonal2].
  Kite.fromDiagonals(double diagonal1, double diagonal2)
      : d1 = diagonal1,
        d2 = diagonal2,
        a = null,
        b = null,
        theta = null,
        super("Kite") {
    if (diagonal1 <= 0 || diagonal2 <= 0) {
      throw ArgumentError('Diagonals must be positive.');
    }
  }

  /// Calculates the area of the Kite.
  ///
  /// Formula: 0.5 * d1 * d2
  @override
  double area() {
    if (d1 != null && d2 != null) {
      return 0.5 * d1! * d2!;
    }
    return a! * b! * dmath.sin(theta!);
  }

  /// Calculates the perimeter of the Kite.
  ///
  /// Formula: 2 * (a + b)
  @override
  double perimeter() {
    if (a != null && b != null) {
      return 2.0 * (a! + b!);
    }
    throw StateError('Perimeter cannot be computed from diagonals alone without side lengths.');
  }

  @override
  String toString() {
    if (a != null && b != null) {
      return 'Kite(sides: $a, $b, area: ${area()}, perimeter: ${perimeter()})';
    }
    return 'Kite(diagonals: $d1, $d2, area: ${area()})';
  }
}
