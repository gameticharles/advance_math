part of '../../geometry.dart';

/// A class representing a regular octagon in 2D space.
///
/// A regular octagon is a polygon with 8 equal sides and 8 equal angles.
///
/// Properties:
/// - 8 sides, all equal length
/// - Interior angle: 135° (3π/4 radians)
/// - Exterior angle: 45° (π/4 radians)
/// - Area = 2(1 + √2) × side² ≈ 4.828... × side²
///
/// Example:
/// ```dart
/// var octagon = Octagon.from(side: 5.0);
/// print('Area: ${octagon.area()}');
/// print('Perimeter: ${octagon.perimeter()}');
/// ```
class Octagon extends Polygon {
  /// Creates a regular octagon with the specified side length.
  ///
  /// [side] is the length of each of the 8 equal sides.
  /// [center] is the optional center point (defaults to origin).
  ///
  /// Throws [ArgumentError] if side is not positive.
  Octagon(double side, {Point? center}) : super(numSides: 8, sideLength: side) {
    if (side <= 0) {
      throw ArgumentError('Side length must be positive, got: $side');
    }

    // Generate vertices in a regular pattern
    Point centerPoint = center ?? Point(0, 0);
    double radius = side / (2 * sin(pi / 8)); // Circumradius

    List<Point> generatedVertices = [];
    for (int i = 0; i < 8; i++) {
      double angle = (2 * pi * i) / 8 - pi / 2; // Start from top
      double x = centerPoint.x + radius * cos(angle);
      double y = centerPoint.y + radius * sin(angle);
      generatedVertices.add(Point(x, y));
    }

    vertices = generatedVertices;
  }

  /// Named constructor following the pattern in existing code.
  factory Octagon.from({required double side, Point? center}) {
    return Octagon(side, center: center);
  }

  /// Creates an octagon from its area.
  factory Octagon.fromArea({required double area, Point? center}) {
    if (area <= 0) throw ArgumentError('Area must be positive');
    double side = sqrt(area / (2 * (1 + sqrt(2))));
    return Octagon(side, center: center);
  }

  /// Creates an octagon from its perimeter.
  factory Octagon.fromPerimeter({required double perimeter, Point? center}) {
    if (perimeter <= 0) throw ArgumentError('Perimeter must be positive');
    return Octagon(perimeter / 8, center: center);
  }

  /// Creates an octagon from its circumradius.
  factory Octagon.fromCircumradius(
      {required double circumradius, Point? center}) {
    if (circumradius <= 0) throw ArgumentError('Circumradius must be positive');
    double side = 2 * circumradius * sin(pi / 8);
    return Octagon(side, center: center);
  }

  /// Creates an octagon from its inradius (apothem).
  factory Octagon.fromInradius({required double inradius, Point? center}) {
    if (inradius <= 0) throw ArgumentError('Inradius must be positive');
    double side = 2 * inradius * tan(pi / 8);
    return Octagon(side, center: center);
  }

  /// Gets the side length of the octagon.
  double get side => sideLength!;

  /// Gets the interior angle of the octagon (135°).
  Angle get interiorAngle => Angle(deg: 135);

  /// Gets the exterior angle of the octagon (45°).
  Angle get exteriorAngle => Angle(deg: 45);

  /// Gets the circumradius (radius of circumscribed circle).
  ///
  /// circumradius = side / (2 × sin(π/8))
  double get circumRadius => side / (2 * sin(pi / 8));

  /// Gets the inradius (radius of inscribed circle).
  ///
  /// inradius = side / (2 × tan(π/8)) = side × (1 + √2) / 2
  double get inRadius => side * (1 + sqrt(2)) / 2;

  /// Gets the apothem (distance from center to midpoint of a side).
  ///
  /// For a regular polygon, apothem = inRadius.
  double get apothem => inRadius;

  /// Gets the sum of interior angles.
  ///
  /// Sum = (n - 2) × 180° = 1080°
  double get sumInteriorAngles => 1080;

  /// Calculates the area of the octagon.
  ///
  /// Area = 2(1 + √2) × side²
  @override
  double area() {
    return 2 * (1 + sqrt(2)) * side * side;
  }

  /// Calculates the perimeter of the octagon.
  ///
  /// Perimeter = 8 × side
  @override
  double perimeter() {
    return 8 * side;
  }

  @override
  String toString() {
    return 'Octagon(side: $side, area: ${area()}, perimeter: ${perimeter()})';
  }
}
