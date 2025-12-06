part of '../../geometry.dart';

/// A class representing a regular pentagon in 2D space.
///
/// A regular pentagon is a polygon with 5 equal sides and 5 equal angles.
///
/// Properties:
/// - 5 sides, all equal length
/// - Interior angle: 108° (3π/5 radians)
/// - Exterior angle: 72° (2π/5 radians)
/// - Area = (1/4)√(25 + 10√5) × side²
///
/// Example:
/// ```dart
/// var pentagon = Pentagon.from(side: 5.0);
/// print('Area: ${pentagon.area()}');
/// print('Perimeter: ${pentagon.perimeter()}');
/// ```
class Pentagon extends Polygon {
  /// Creates a regular pentagon with the specified side length.
  ///
  /// [side] is the length of each of the 5 equal sides.
  /// [center] is the optional center point (defaults to origin).
  ///
  /// Throws [ArgumentError] if side is not positive.
  Pentagon(double side, {Point? center})
      : super(numSides: 5, sideLength: side) {
    if (side <= 0) {
      throw ArgumentError('Side length must be positive, got: $side');
    }

    // Generate vertices in a regular pattern
    Point centerPoint = center ?? Point(0, 0);
    double radius = side / (2 * sin(pi / 5)); // Circumradius

    List<Point> generatedVertices = [];
    for (int i = 0; i < 5; i++) {
      double angle = (2 * pi * i) / 5 - pi / 2; // Start from top
      double x = centerPoint.x + radius * cos(angle);
      double y = centerPoint.y + radius * sin(angle);
      generatedVertices.add(Point(x, y));
    }

    vertices = generatedVertices;
  }

  /// Named constructor following the pattern in existing code.
  factory Pentagon.from({required double side, Point? center}) {
    return Pentagon(side, center: center);
  }

  /// Creates a pentagon from its area.
  ///
  /// Calculates side from: side = √(4A / √(25 + 10√5))
  factory Pentagon.fromArea({required double area, Point? center}) {
    if (area <= 0) throw ArgumentError('Area must be positive');
    double side = sqrt(4 * area / sqrt(25 + 10 * sqrt(5)));
    return Pentagon(side, center: center);
  }

  /// Creates a pentagon from its perimeter.
  ///
  /// Calculates side = perimeter / 5
  factory Pentagon.fromPerimeter({required double perimeter, Point? center}) {
    if (perimeter <= 0) throw ArgumentError('Perimeter must be positive');
    return Pentagon(perimeter / 5, center: center);
  }

  /// Creates a pentagon from its circumradius.
  ///
  /// Calculates side = 2R × sin(π/5)
  factory Pentagon.fromCircumradius(
      {required double circumradius, Point? center}) {
    if (circumradius <= 0) throw ArgumentError('Circumradius must be positive');
    double side = 2 * circumradius * sin(pi / 5);
    return Pentagon(side, center: center);
  }

  /// Creates a pentagon from its inradius (apothem).
  ///
  /// Calculates side = 2r × tan(π/5)
  factory Pentagon.fromInradius({required double inradius, Point? center}) {
    if (inradius <= 0) throw ArgumentError('Inradius must be positive');
    double side = 2 * inradius * tan(pi / 5);
    return Pentagon(side, center: center);
  }

  /// Gets the side length of the pentagon.
  double get side => sideLength!;

  /// Gets the short diagonal length of the pentagon.
  ///
  /// For a regular pentagon, short diagonal = φ × side, where φ is the golden ratio.
  /// Or, short diagonal = 2 * side * cos(pi/5)
  double get shortDiagonal => 2 * side * cos(pi / 5);

  /// Gets the interior angle of the pentagon (108°).
  Angle get interiorAngle => Angle(deg: 108);

  /// Gets the exterior angle of the pentagon (72°).
  Angle get exteriorAngle => Angle(deg: 72);

  /// Gets the circumradius (radius of circumscribed circle).
  ///
  /// circumradius = side / (2 × sin(π/5))
  double get circumRadius => side / (2 * sin(pi / 5));

  /// Gets the inradius (radius of inscribed circle).
  ///
  /// inradius = side / (2 × tan(π/5))
  double get inRadius => side / (2 * tan(pi / 5));

  /// Gets the apothem (distance from center to midpoint of a side).
  ///
  /// For a regular polygon, apothem = inRadius.
  double get apothem => inRadius;

  /// Gets the sum of interior angles.
  ///
  /// Sum = (n - 2) × 180° = 540°
  double get sumInteriorAngles => 540;

  /// Calculates the area of the pentagon.
  ///
  /// Area = (1/4)√(25 + 10√5) × side²
  @override
  double area() {
    return 0.25 * sqrt(25 + 10 * sqrt(5)) * side * side;
  }

  /// Calculates the perimeter of the pentagon.
  ///
  /// Perimeter = 5 × side
  @override
  double perimeter() {
    return 5 * side;
  }

  @override
  String toString() {
    return 'Pentagon(side: $side, area: ${area()}, perimeter: ${perimeter()})';
  }
}
