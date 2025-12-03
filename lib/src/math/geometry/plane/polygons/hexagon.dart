part of '../../geometry.dart';

/// A class representing a regular hexagon in 2D space.
///
/// A regular hexagon is a polygon with 6 equal sides and 6 equal angles.
///
/// Properties:
/// - 6 sides, all equal length
/// - Interior angle: 120° (2π/3 radians)
/// - Exterior angle: 60° (π/3 radians)
/// - Area = (3√3/2) × side² = 2.598... × side²
/// - Can be divided into 6 equilateral triangles
///
/// Example:
/// ```dart
/// var hexagon = Hexagon.from(side: 4.0);
/// print('Area: ${hexagon.area()}');
/// print('Perimeter: ${hexagon.perimeter()}');
/// ```
class Hexagon extends Polygon {
  /// Creates a regular hexagon with the specified side length.
  ///
  /// [side] is the length of each of the 6 equal sides.
  /// [center] is the optional center point (defaults to origin).
  ///
  /// Throws [ArgumentError] if side is not positive.
  Hexagon(double side, {Point? center}) : super(numSides: 6, sideLength: side) {
    if (side <= 0) {
      throw ArgumentError('Side length must be positive, got: $side');
    }

    // Generate vertices in a regular pattern
    Point centerPoint = center ?? Point(0, 0);
    double radius = side; // For a regular hexagon, circumradius = side

    List<Point> generatedVertices = [];
    for (int i = 0; i < 6; i++) {
      double angle = (2 * pi * i) / 6 - pi / 2; // Start from top
      double x = centerPoint.x + radius * cos(angle);
      double y = centerPoint.y + radius * sin(angle);
      generatedVertices.add(Point(x, y));
    }

    vertices = generatedVertices;
  }

  /// Named constructor following the pattern in existing code.
  factory Hexagon.from({required double side, Point? center}) {
    return Hexagon(side, center: center);
  }

  /// Creates a hexagon from its area.
  ///
  /// Calculates side from: side = √(2A / (3√3))
  factory Hexagon.fromArea({required double area, Point? center}) {
    if (area <= 0) throw ArgumentError('Area must be positive');
    double side = sqrt((2 * area) / (3 * sqrt(3)));
    return Hexagon(side, center: center);
  }

  /// Creates a hexagon from its perimeter.
  ///
  /// Calculates side = perimeter / 6
  factory Hexagon.fromPerimeter({required double perimeter, Point? center}) {
    if (perimeter <= 0) throw ArgumentError('Perimeter must be positive');
    return Hexagon(perimeter / 6, center: center);
  }

  /// Creates a hexagon from its circumradius.
  ///
  /// For a regular hexagon, circumradius = side
  factory Hexagon.fromCircumradius(
      {required double circumradius, Point? center}) {
    if (circumradius <= 0) throw ArgumentError('Circumradius must be positive');
    return Hexagon(circumradius, center: center);
  }

  /// Creates a hexagon from its inradius (apothem).
  ///
  /// Calculates side = (2/√3) × inradius
  factory Hexagon.fromInradius({required double inradius, Point? center}) {
    if (inradius <= 0) throw ArgumentError('Inradius must be positive');
    double side = (2 / sqrt(3)) * inradius;
    return Hexagon(side, center: center);
  }

  /// Gets the side length of the hexagon.
  double get side => sideLength!;

  /// Gets the interior angle of the hexagon (120°).
  Angle get interiorAngle => Angle(deg: 120);

  /// Gets the exterior angle of the hexagon (60°).
  Angle get exteriorAngle => Angle(deg: 60);

  /// Gets the circumradius (radius of circumscribed circle).
  ///
  /// For a regular hexagon: circumradius = side
  double get circumRadius => side;

  /// Gets the inradius (radius of inscribed circle).
  ///
  /// inradius = (√3/2) × side
  double get inRadius => (sqrt(3) / 2) * side;

  /// Gets the diagonal (long diagonal connecting opposite vertices).
  ///
  /// long diagonal = 2 × side
  double get longDiagonal => 2 * side;

  /// Gets the short diagonal (connecting vertices separated by one vertex).
  ///
  /// short diagonal = √3 × side
  double get shortDiagonal => sqrt(3) * side;

  /// Gets the apothem (distance from center to midpoint of a side).
  ///
  /// For a regular polygon, apothem = inRadius.
  double get apothem => inRadius;

  /// Gets the sum of interior angles.
  ///
  /// Sum = (n - 2) × 180° = 720°
  double get sumInteriorAngles => 720;

  /// Calculates the area of the hexagon.
  ///
  /// Area = (3√3/2) × side²
  double area() {
    return (3 * sqrt(3) / 2) * side * side;
  }

  /// Calculates the perimeter of the hexagon.
  ///
  /// Perimeter = 6 × side
  @override
  double perimeter() {
    return 6 * side;
  }

  @override
  String toString() {
    return 'Hexagon(side: $side, area: ${area()}, perimeter: ${perimeter()})';
  }
}
