part of '../../geometry.dart';

/// A class representing a rhombus (diamond shape) in 2D space.
///
/// A rhombus is a quadrilateral with all four sides of equal length.
/// Opposite angles are equal, and the diagonals bisect each other at right angles.
///
/// Properties:
/// - All four sides are equal
/// - Opposite angles are equal
/// - Diagonals bisect each other at 90°
/// - Area = side × height or (1/2) × diagonal1 × diagonal2
/// - Perimeter = 4 × side
///
/// Example:
/// ```dart
/// var rhombus = Rhombus.from(side: 5.0, angle: Angle(deg: 60));
/// print('Area: ${rhombus.area()}');
/// var rhombus2 = Rhombus.fromDiagonals(6.0, 8.0);
/// print('Side: ${rhombus2.side}'); // 5.0
/// ```
class Rhombus extends PlaneGeometry {
  /// The length of each side of the rhombus
  double? side;

  /// The first angle of the rhombus (in radians)
  Angle? angle1;

  /// The second angle of the rhombus (in radians)
  /// Equal to 180° - angle1
  Angle? angle2;

  /// The first diagonal of the rhombus
  double? diagonal1;

  /// The second diagonal of the rhombus
  double? diagonal2;

  /// The height of the rhombus (perpendicular distance between parallel sides)
  double? _height;

  /// Creates a rhombus from a side length and one angle.
  ///
  /// The other angle is automatically calculated as 180° - angle1.
  /// The diagonals are calculated using the law of cosines.
  ///
  /// Throws [ArgumentError] if side is not positive or angle is invalid.
  Rhombus(this.side, {Angle? angle}) : super('Rhombus') {
    if (side! <= 0) {
      throw ArgumentError('Side length must be positive, got: $side');
    }
    if (angle != null) {
      if (angle.deg <= 0 || angle.deg >= 180) {
        throw ArgumentError(
            'Angle must be between 0 and 180 degrees, got: ${angle.deg}°');
      }
      angle1 = angle;
      angle2 = Angle(deg: 180 - angle.deg);

      // Calculate diagonals using the formula:
      // d1 = 2 * side * sin(angle1/2)
      // d2 = 2 * side * cos(angle1/2)
      diagonal1 = 2 * side! * sin(angle1!.rad / 2);
      diagonal2 = 2 * side! * cos(angle1!.rad / 2);

      // Calculate height
      _height = side! * sin(angle1!.rad);
    }
  }

  /// Creates a rhombus from its two diagonals.
  ///
  /// The side length is calculated using the formula:
  /// side = √((d1/2)² + (d2/2)²)
  ///
  /// Throws [ArgumentError] if any diagonal is not positive.
  Rhombus.fromDiagonals(double d1, double d2) : super('Rhombus') {
    if (d1 <= 0 || d2 <= 0) {
      throw ArgumentError('Diagonals must be positive. Got d1: $d1, d2: $d2');
    }
    diagonal1 = d1;
    diagonal2 = d2;

    // Calculate side using Pythagorean theorem (diagonals bisect each other)
    side = sqrt((d1 / 2) * (d1 / 2) + (d2 / 2) * (d2 / 2));

    // Calculate angles using arctangent
    double halfAngle1 = atan(d1 / d2);
    angle1 = Angle(rad: 2 * halfAngle1);
    angle2 = Angle(deg: 180 - angle1!.deg);

    // Calculate height
    _height = (d1 * d2) / (2 * side!);
  }

  /// Creates a rhombus from its vertices.
  ///
  /// Validates that all four sides are equal.
  ///
  /// Throws [ArgumentError] if:
  /// - Less than 4 vertices are provided
  /// - The sides are not all equal
  Rhombus.fromVertices(List<Point> vertices) : super('Rhombus') {
    if (vertices.length != 4) {
      throw ArgumentError(
          'Rhombus must have exactly 4 vertices, got: ${vertices.length}');
    }

    // Calculate all four sides
    double side1 = vertices[0].distanceTo(vertices[1]);
    double side2 = vertices[1].distanceTo(vertices[2]);
    double side3 = vertices[2].distanceTo(vertices[3]);
    double side4 = vertices[3].distanceTo(vertices[0]);

    const tolerance = 1e-10;
    if ((side1 - side2).abs() > tolerance ||
        (side2 - side3).abs() > tolerance ||
        (side3 - side4).abs() > tolerance) {
      throw ArgumentError(
          'All sides must be equal for a rhombus. Got: $side1, $side2, $side3, $side4');
    }

    side = side1;

    // Calculate diagonals
    diagonal1 = vertices[0].distanceTo(vertices[2]);
    diagonal2 = vertices[1].distanceTo(vertices[3]);

    // Calculate angles
    double halfAngle1 = atan(diagonal1! / diagonal2!);
    angle1 = Angle(rad: 2 * halfAngle1);
    angle2 = Angle(deg: 180 - angle1!.deg);

    // Calculate height
    _height = (diagonal1! * diagonal2!) / (2 * side!);
  }

  /// Named constructor following the pattern in existing code.
  ///
  /// Creates a rhombus with [side] and optional [angle].
  factory Rhombus.from({required double side, Angle? angle}) {
    return Rhombus(side, angle: angle);
  }

  /// Gets the height of the rhombus.
  ///
  /// The height is the perpendicular distance between parallel sides.
  double get height {
    if (_height != null) return _height!;
    if (angle1 != null && side != null) {
      return side! * sin(angle1!.rad);
    }
    throw StateError('Cannot calculate height: insufficient data');
  }

  /// Calculates the area of the rhombus.
  ///
  /// Uses the formula: Area = (1/2) × d1 × d2
  /// If diagonals are not available, uses: Area = side × height
  @override
  double area() {
    if (diagonal1 != null && diagonal2 != null) {
      return 0.5 * diagonal1! * diagonal2!;
    } else if (side != null && angle1 != null) {
      return side! * height;
    }
    throw StateError('Cannot calculate area: insufficient data');
  }

  /// Calculates the perimeter of the rhombus.
  ///
  /// Perimeter = 4 × side
  @override
  double perimeter() {
    if (side == null) {
      throw StateError('Cannot calculate perimeter: side length is not set');
    }
    return 4 * side!;
  }

  /// Gets the inradius (radius of the inscribed circle).
  ///
  /// For a rhombus: inradius = (d1 × d2) / (4 × side)
  double get inRadius {
    if (diagonal1 != null && diagonal2 != null && side != null) {
      return (diagonal1! * diagonal2!) / (4 * side!);
    }
    return height / 2;
  }

  /// Checks if this rhombus is actually a square.
  ///
  /// Returns true if both angles are 90 degrees (or equivalently, both diagonals are equal).
  bool isSquare() {
    const tolerance = 1e-10;
    if (angle1 != null) {
      return (angle1!.deg - 90).abs() < tolerance;
    }
    if (diagonal1 != null && diagonal2 != null) {
      return (diagonal1! - diagonal2!).abs() < tolerance;
    }
    return false;
  }

  @override
  String toString() {
    return 'Rhombus(side: $side, angle1: ${angle1?.deg}°, angle2: ${angle2?.deg}°, diagonals: [$diagonal1, $diagonal2], area: ${area()})';
  }
}
