part of '../../geometry.dart';

/// A class representing a regular heptagon (septagon) in 2D space.
///
/// A regular heptagon is a polygon with 7 equal sides and 7 equal angles.
///
/// Properties:
/// - 7 sides, all equal length
/// - Interior angle ≈ 128.571° (5π/7 radians)
/// - Exterior angle ≈ 51.429° (2π/7 radians)
/// - Area = (7/4) × side² × cot(π/7)
///
/// Example:
/// ```dart
/// var heptagon = Heptagon.from(side: 5.0);
/// print('Area: ${heptagon.area()}');
/// print('Perimeter: ${heptagon.perimeter()}');
/// ```
class Heptagon extends Polygon {
  /// Creates a regular heptagon with the specified side length.
  ///
  /// [side] is the length of each of the 7 equal sides.
  /// [center] is the optional center point (defaults to origin).
  ///
  /// Throws [ArgumentError] if side is not positive.
  Heptagon(double side, {Point? center})
      : super(numSides: 7, sideLength: side) {
    if (side <= 0) {
      throw ArgumentError('Side length must be positive, got: $side');
    }

    // Generate vertices in a regular pattern
    Point centerPoint = center ?? Point(0, 0);
    double radius = side / (2 * sin(pi / 7)); // Circumradius

    List<Point> generatedVertices = [];
    for (int i = 0; i < 7; i++) {
      double angle = (2 * pi * i) / 7 - pi / 2; // Start from top
      double x = centerPoint.x + radius * cos(angle);
      double y = centerPoint.y + radius * sin(angle);
      generatedVertices.add(Point(x, y));
    }

    vertices = generatedVertices;
  }

  /// Named constructor following the pattern in existing code.
  factory Heptagon.from({required double side, Point? center}) {
    return Heptagon(side, center: center);
  }

  /// Creates a heptagon from its area.
  factory Heptagon.fromArea({required double area, Point? center}) {
    if (area <= 0) throw ArgumentError('Area must be positive');
    double side = sqrt((4 * area) / (7 * (1 / tan(pi / 7))));
    return Heptagon(side, center: center);
  }

  /// Creates a heptagon from its perimeter.
  factory Heptagon.fromPerimeter({required double perimeter, Point? center}) {
    if (perimeter <= 0) throw ArgumentError('Perimeter must be positive');
    return Heptagon(perimeter / 7, center: center);
  }

  /// Creates a heptagon from its circumradius.
  factory Heptagon.fromCircumradius(
      {required double circumradius, Point? center}) {
    if (circumradius <= 0) throw ArgumentError('Circumradius must be positive');
    double side = 2 * circumradius * sin(pi / 7);
    return Heptagon(side, center: center);
  }

  /// Creates a heptagon from its inradius (apothem).
  factory Heptagon.fromInradius({required double inradius, Point? center}) {
    if (inradius <= 0) throw ArgumentError('Inradius must be positive');
    double side = 2 * inradius * tan(pi / 7);
    return Heptagon(side, center: center);
  }

  /// Gets the side length of the heptagon.
  double get side => sideLength!;

  /// Gets the interior angle of the heptagon (≈ 128.571°).
  Angle get interiorAngle => Angle(rad: 5 * pi / 7);

  /// Gets the exterior angle of the heptagon (≈ 51.429°).
  Angle get exteriorAngle => Angle(rad: 2 * pi / 7);

  /// Gets the circumradius (radius of circumscribed circle).
  ///
  /// circumradius = side / (2 × sin(π/7))
  double get circumRadius => side / (2 * sin(pi / 7));

  /// Gets the inradius (radius of inscribed circle).
  ///
  /// inradius = side / (2 × tan(π/7))
  double get inRadius => side / (2 * tan(pi / 7));

  /// Gets the apothem (distance from center to midpoint of a side).
  ///
  /// For a regular polygon, apothem = inRadius.
  double get apothem => inRadius;

  /// Gets the sum of interior angles.
  ///
  /// Sum = (n - 2) × 180° = 900°
  double get sumInteriorAngles => 900;

  /// Calculates the area of the heptagon.
  ///
  /// Area = (7/4) × side² × cot(π/7)
  double area() {
    return (7 / 4) * side * side * (1 / tan(pi / 7));
  }

  /// Calculates the perimeter of the heptagon.
  ///
  /// Perimeter = 7 × side
  @override
  double perimeter() {
    return 7 * side;
  }

  @override
  String toString() {
    return 'Heptagon(side: $side, area: ${area()}, perimeter: ${perimeter()})';
  }
}
