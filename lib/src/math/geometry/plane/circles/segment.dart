part of '../../geometry.dart';

/// A class representing a circular segment in 2D space.
///
/// A segment is the region between a chord and the arc it cuts off.
///
/// Properties:
/// - Radius
/// - Central angle, chord length, or height
/// - Area = (r²/2) × (θ - sin(θ))
/// - Arc length = θ × r
/// - Chord length = 2r × sin(θ/2)
/// - Height (sagitta) = r × (1 - cos(θ/2))
///
/// Example:
/// ```dart
/// var segment = Segment.from(radius: 5.0, centralAngle: Angle(deg: 60));
/// print('Area: ${segment.area()}');
/// print('Chord Length: ${segment.chordLength}');
/// ```
class Segment extends PlaneGeometry {
  num _radius;
  Angle _centralAngle;
  Point _center;

  /// The radius of the circle from which the segment is taken
  num get radius => _radius;
  set radius(num value) {
    if (value <= 0) {
      throw ArgumentError('Radius must be positive, got: $value');
    }
    _radius = value;
  }

  /// The central angle of the segment
  Angle get centralAngle => _centralAngle;
  set centralAngle(Angle value) {
    _centralAngle = value;
  }

  /// The center point of the circle
  Point get center => _center;
  set center(Point value) {
    _center = value;
  }

  /// Creates a segment with the specified radius and central angle.
  ///
  /// [radius] must be positive.
  /// [centralAngle] is the angle subtended by the arc.
  /// [center] is the optional center point (defaults to origin).
  ///
  /// Throws [ArgumentError] if radius is not positive.
  Segment(num radius, Angle centralAngle, {Point? center})
      : _radius = radius,
        _centralAngle = centralAngle,
        _center = center ?? Point(0, 0),
        super('Segment') {
    if (radius <= 0) {
      throw ArgumentError('Radius must be positive, got: $radius');
    }
  }

  /// Named constructor following existing pattern.
  factory Segment.from(
      {required num radius, required Angle centralAngle, Point? center}) {
    return Segment(radius, centralAngle, center: center);
  }

  /// Creates a segment from radius and chord length.
  ///
  /// The central angle is calculated as: θ = 2 × arcsin(chord / (2r))
  ///
  /// Throws [ArgumentError] if parameters are invalid.
  Segment.fromChord(num radius, num chordLength, {Point? center})
      : _radius = radius,
        _centralAngle = Angle(rad: 2 * asin(chordLength / (2 * radius))),
        _center = center ?? Point(0, 0),
        super('Segment') {
    if (radius <= 0 || chordLength <= 0) {
      throw ArgumentError(
          'Radius and chord length must be positive. Got radius: $radius, chordLength: $chordLength');
    }
    if (chordLength > 2 * radius) {
      throw ArgumentError(
          'Chord length cannot exceed diameter. Got chordLength: $chordLength, diameter: ${2 * radius}');
    }
  }

  /// Creates a segment from radius and height (sagitta).
  ///
  /// The central angle is calculated as: θ = 2 × arccos((r - h) / r)
  ///
  /// Throws [ArgumentError] if parameters are invalid.
  Segment.fromHeight(num radius, num height, {Point? center})
      : _radius = radius,
        _centralAngle = Angle(rad: 2 * acos((radius - height) / radius)),
        _center = center ?? Point(0, 0),
        super('Segment') {
    if (radius <= 0 || height <= 0) {
      throw ArgumentError(
          'Radius and height must be positive. Got radius: $radius, height: $height');
    }
    if (height > radius) {
      throw ArgumentError(
          'Height cannot exceed radius for a segment. Got height: $height, radius: $radius');
    }
  }

  /// Gets the arc length of the segment.
  ///
  /// Arc length = θ × r
  num get arcLength => _centralAngle.rad * _radius;

  /// Gets the chord length (straight line across the segment).
  ///
  /// Chord = 2r × sin(θ/2)
  num get chordLength => 2 * _radius * sin(_centralAngle.rad / 2);

  /// Gets the height (sagitta) of the segment.
  ///
  /// Height = r × (1 - cos(θ/2))
  num get height => _radius * (1 - cos(_centralAngle.rad / 2));

  /// Calculates the area of the segment.
  ///
  /// Area = (r²/2) × (θ - sin(θ))
  @override
  double area() {
    return (_radius * _radius / 2) *
        (_centralAngle.rad - sin(_centralAngle.rad));
  }

  /// Calculates the perimeter of the segment.
  ///
  /// Perimeter = arc length + chord length
  @override
  num perimeter() {
    return arcLength + chordLength;
  }

  /// Gets the area of the corresponding sector.
  ///
  /// Sector area = (θ/2) × r²
  num get sectorArea => 0.5 * _centralAngle.rad * _radius * _radius;

  /// Gets the area of the triangle formed by the two radii and chord.
  ///
  /// Triangle area = (r²/2) × sin(θ)
  num get triangleArea => (_radius * _radius / 2) * sin(_centralAngle.rad);

  /// Calculates the bounding box of the segment.
  List<Point> boundingBox() {
    num minX = double.infinity;
    num maxX = double.negativeInfinity;
    num minY = double.infinity;
    num maxY = double.negativeInfinity;

    // Endpoints of the chord/arc
    Point p1 = Point(_center.x + _radius, _center.y);
    Point p2 = Point(_center.x + _radius * cos(_centralAngle.rad),
        _center.y + _radius * sin(_centralAngle.rad));

    List<Point> pointsToCheck = [p1, p2];

    // Check extreme points of the arc
    num endAngle = _centralAngle.rad;
    if (endAngle >= pi / 2) {
      pointsToCheck.add(Point(_center.x, _center.y + _radius));
    }
    if (endAngle >= pi) {
      pointsToCheck.add(Point(_center.x - _radius, _center.y));
    }
    if (endAngle >= 3 * pi / 2) {
      pointsToCheck.add(Point(_center.x, _center.y - _radius));
    }

    // Note: Center is NOT necessarily part of the segment bounding box unless the segment is > semicircle
    // But for a segment, the boundary is the arc + chord.
    // The chord is a straight line between p1 and p2.
    // The bounding box is determined by p1, p2 and any arc extremes between them.

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
    return 'Segment(radius: $_radius, centralAngle: ${_centralAngle.deg}°, area: ${area()}, chordLength: $chordLength)';
  }
}
