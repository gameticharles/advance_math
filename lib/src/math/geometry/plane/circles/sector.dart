part of '../../geometry.dart';

/// A class representing a circular sector (pie slice) in 2D space.
///
/// A sector is a region of a circle bounded by two radii and an arc.
///
/// Properties:
/// - Radius
/// - Central angle
/// - Area = (θ/2) × r²
/// - Arc length = θ × r
/// - Perimeter = 2r + arc length
///
/// Example:
/// ```dart
/// var sector = Sector.from(radius: 5.0, centralAngle: Angle(deg: 60));
/// print('Area: ${sector.area()}'); // Area of sector
/// print('Arc Length: ${sector.arcLength}');
/// ```
class Sector extends PlaneGeometry {
  num _radius;
  Angle centralAngle;
  Point center;

  /// The radius of the circle from which the sector is taken
  num get radius => _radius;
  set radius(num value) {
    if (value <= 0) {
      throw ArgumentError('Radius must be positive, got: $value');
    }
    _radius = value;
  }

  /// Creates a sector with the specified radius and central angle.
  ///
  /// [radius] must be positive.
  /// [centralAngle] is the angle of the sector.
  /// [center] is the optional center point (defaults to origin).
  ///
  /// Throws [ArgumentError] if radius is not positive.
  Sector(num radius, this.centralAngle, {Point? center})
      : _radius = radius,
        center = center ?? Point(0, 0),
        super('Sector') {
    if (radius <= 0) {
      throw ArgumentError('Radius must be positive, got: $radius');
    }
  }

  /// Named constructor following existing pattern.
  ///
  /// Creates a sector with specified [radius] and [centralAngle].
  factory Sector.from(
      {required num radius, required Angle centralAngle, Point? center}) {
    return Sector(radius, centralAngle, center: center);
  }

  /// Creates a sector from radius and arc length.
  ///
  /// The central angle is calculated as: θ = arcLength / radius
  ///
  /// Throws [ArgumentError] if radius or arcLength is not positive.
  Sector.fromArcLength(num radius, num arcLength, {Point? center})
      : _radius = radius,
        centralAngle = Angle(rad: arcLength / radius),
        center = center ?? Point(0, 0),
        super('Sector') {
    if (radius <= 0 || arcLength <= 0) {
      throw ArgumentError(
          'Radius and arc length must be positive. Got radius: $radius, arcLength: $arcLength');
    }
  }

  /// Creates a sector from radius and area.
  ///
  /// The central angle is calculated as: θ = 2 × area / r²
  ///
  /// Throws [ArgumentError] if radius or area is not positive.
  Sector.fromArea(num radius, num area, {Point? center})
      : _radius = radius,
        centralAngle = Angle(rad: (2 * area) / (radius * radius)),
        center = center ?? Point(0, 0),
        super('Sector') {
    if (radius <= 0 || area <= 0) {
      throw ArgumentError(
          'Radius and area must be positive. Got radius: $radius, area: $area');
    }
  }

  /// Gets the arc length of the sector.
  ///
  /// Arc length = θ × r
  num get arcLength => centralAngle.rad * _radius;

  /// Calculates the area of the sector.
  ///
  /// Area = (θ/2) × r²
  @override
  num area() {
    return 0.5 * centralAngle.rad * _radius * _radius;
  }

  /// Calculates the perimeter of the sector.
  ///
  /// Perimeter = 2r + arc length
  @override
  num perimeter() {
    return 2 * _radius + arcLength;
  }

  /// Gets the chord length (straight line connecting the arc endpoints).
  ///
  /// Chord = 2r × sin(θ/2)
  num get chordLength => 2 * _radius * sin(centralAngle.rad / 2);

  /// Gets the height (sagitta) of the arc.
  ///
  /// Height = r × (1 - cos(θ/2))
  num get height => _radius * (1 - cos(centralAngle.rad / 2));

  /// Checks if a point is inside the sector.
  ///
  /// A point is inside if:
  /// 1. Its distance from center ≤ radius
  /// 2. Its angle from the starting radius ≤ central angle
  bool contains(Point point) {
    // Optimization: Check distance squared first to avoid sqrt
    num dx = point.x - center.x;
    num dy = point.y - center.y;
    num distSq = dx * dx + dy * dy;

    if (distSq > _radius * _radius) return false;
    if (distSq == 0) return true; // Center is always inside

    // For simplicity, assume sector starts at angle 0 relative to X-axis
    // If the sector has a rotation, we would need to adjust.
    // Assuming standard position (0 to centralAngle):
    double pointAngle = atan2(dy, dx);
    if (pointAngle < 0) pointAngle += 2 * pi;

    return pointAngle <= centralAngle.rad;
  }

  /// Calculates the bounding box of the sector.
  ///
  /// Returns a list of 4 points defining the rectangle [min, max].
  List<Point> boundingBox() {
    num minX = center.x;
    num maxX = center.x;
    num minY = center.y;
    num maxY = center.y;

    // Add endpoints of the arc
    // Start point (angle 0)
    Point p1 = Point(center.x + _radius, center.y);
    // End point (angle centralAngle)
    Point p2 = Point(center.x + _radius * cos(centralAngle.rad),
        center.y + _radius * sin(centralAngle.rad));

    List<Point> pointsToCheck = [p1, p2];

    // Check extreme points (0, 90, 180, 270) if they are within the angle
    num endAngle = centralAngle.rad;
    if (endAngle >= pi / 2) {
      pointsToCheck.add(Point(center.x, center.y + _radius)); // Top
    }
    if (endAngle >= pi) {
      pointsToCheck.add(Point(center.x - _radius, center.y)); // Left
    }
    if (endAngle >= 3 * pi / 2) {
      pointsToCheck.add(Point(center.x, center.y - _radius)); // Bottom
    }

    // Also include center for sector
    pointsToCheck.add(center);

    for (var p in pointsToCheck) {
      minX = min(minX, p.x);
      maxX = max(maxX, p.x);
      minY = min(minY, p.y);
      maxY = max(maxY, p.y);
    }

    return [
      Point(minX, minY),
      Point(maxX, minY),
      Point(maxX, maxY),
      Point(minX, maxY)
    ];
  }

  @override
  String toString() {
    return 'Sector(radius: $_radius, centralAngle: ${centralAngle.deg}°, area: ${area()})';
  }
}
