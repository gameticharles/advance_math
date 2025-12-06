part of '../../geometry.dart';

/// A class representing a circular arc in 2D space.
///
/// An arc is the curved portion of a circle between two points.
///
/// Properties:
/// - Radius
/// - Central angle or arc length
/// - Arc length = θ × r
/// - Chord length = 2r × sin(θ/2)
/// - Height (sagitta) = r - √(r² - (chord/2)²)
///
/// Example:
/// ```dart
/// var arc = Arc.from(radius: 5.0, centralAngle: Angle(deg: 90));
/// print('Arc Length: ${arc.length}');
/// print('Chord Length: ${arc.chordLength}');
/// ```
class Arc {
  num _radius;
  Angle centralAngle;
  Point center;
  num startAngle;

  /// The radius of the circle from which the arc is taken
  num get radius => _radius;
  set radius(num value) {
    if (value <= 0) {
      throw ArgumentError('Radius must be positive, got: $value');
    }
    _radius = value;
  }

  /// Creates an arc with the specified radius and central angle.
  ///
  /// [radius] must be positive.
  /// [centralAngle] is the angle subtended by the arc.
  /// [center] is the optional center point (defaults to origin).
  /// [startAngle] is the starting angle in radians (default: 0).
  ///
  /// Throws [ArgumentError] if radius is not positive.
  Arc(double radius, this.centralAngle,
      {Point? center, double this.startAngle = 0.0})
      : _radius = radius,
        center = center ?? Point(0, 0) {
    if (radius <= 0) {
      throw ArgumentError('Radius must be positive, got: $radius');
    }
  }

  /// Named constructor following existing pattern.
  factory Arc.from({
    required double radius,
    required Angle centralAngle,
    Point? center,
    double startAngle = 0.0,
  }) {
    return Arc(radius, centralAngle, center: center, startAngle: startAngle);
  }

  /// Creates an arc from radius and arc length.
  ///
  /// The central angle is calculated as: θ = arcLength / radius
  ///
  /// Throws [ArgumentError] if parameters are invalid.
  Arc.fromLength(double radius, double arcLength,
      {Point? center, double this.startAngle = 0.0})
      : _radius = radius,
        centralAngle = Angle(rad: arcLength / radius),
        center = center ?? Point(0, 0) {
    if (radius <= 0 || arcLength <= 0) {
      throw ArgumentError(
          'Radius and arc length must be positive. Got radius: $radius, arcLength: $arcLength');
    }
  }

  /// Creates an arc from radius and chord length.
  ///
  /// The central angle is calculated as: θ = 2 × arcsin(chord / (2r))
  ///
  /// Throws [ArgumentError] if parameters are invalid.
  Arc.fromChord(double radius, double chordLength,
      {Point? center, double this.startAngle = 0.0})
      : _radius = radius,
        centralAngle = Angle(rad: 2 * asin(chordLength / (2 * radius))),
        center = center ?? Point(0, 0) {
    if (radius <= 0 || chordLength <= 0) {
      throw ArgumentError(
          'Radius and chord length must be positive. Got radius: $radius, chordLength: $chordLength');
    }
    if (chordLength > 2 * radius) {
      throw ArgumentError(
          'Chord length cannot exceed diameter. Got chordLength: $chordLength, diameter: ${2 * radius}');
    }
  }

  /// Creates an arc passing through two points with a given radius.
  ///
  /// [start] and [end] are the endpoints of the arc.
  /// [radius] is the radius of the circle.
  /// The arc is chosen to be the shorter of the two possible arcs.
  ///
  /// Throws [ArgumentError] if parameters are invalid.
  Arc.fromPoints(Point start, Point end, double radius,
      {double this.startAngle = 0.0})
      : _radius = radius,
        centralAngle = Angle(rad: 0),
        center = Point(0, 0) {
    double distance = start.distanceTo(end);
    if (distance > 2 * radius) {
      throw ArgumentError(
          'Distance between points exceeds diameter. Distance: $distance, diameter: ${2 * radius}');
    }

    // Calculate center point (midpoint perpendicular to chord)
    Point midpoint = start.midpointTo(end);
    num halfChord = distance / 2;
    num distanceToCenter = sqrt(radius * radius - halfChord * halfChord);

    // Direction perpendicular to the chord
    num dx = end.x - start.x;
    num dy = end.y - start.y;
    num perpX = (-dy / distance).toDouble();
    num perpY = (dx / distance).toDouble();

    center = Point(
      midpoint.x + perpX * distanceToCenter,
      midpoint.y + perpY * distanceToCenter,
    );

    // Calculate central angle
    centralAngle = Angle(rad: 2 * asin(halfChord / radius));

    // Calculate start angle
    startAngle = atan2(start.y - center.y, start.x - center.x);
  }

  /// Gets the arc length.
  ///
  /// Arc length = θ × r
  num get length => centralAngle.rad * _radius;

  /// Gets the chord length (straight line connecting arc endpoints).
  ///
  /// Chord = 2r × sin(θ/2)
  num get chordLength => 2 * _radius * sin(centralAngle.rad / 2);

  /// Gets the height (sagitta) of the arc.
  ///
  /// Sagitta = r - √(r² - (chord/2)²) = r × (1 - cos(θ/2))
  num get sagitta => _radius * (1 - cos(centralAngle.rad / 2));

  /// Gets the start point of the arc.
  Point get startPoint {
    return Point(
      center.x + _radius * cos(startAngle),
      center.y + _radius * sin(startAngle),
    );
  }

  /// Gets the end point of the arc.
  Point get endPoint {
    num endAngle = startAngle + centralAngle.rad;
    return Point(
      center.x + _radius * cos(endAngle),
      center.y + _radius * sin(endAngle),
    );
  }

  /// Gets the midpoint of the arc.
  Point get midpoint {
    num midAngle = startAngle + centralAngle.rad / 2;
    return Point(
      center.x + _radius * cos(midAngle),
      center.y + _radius * sin(midAngle),
    );
  }

  /// Gets a point on the arc at parametric position t ∈ [0, 1].
  ///
  /// t = 0 gives the start point, t = 1 gives the end point.
  Point pointAt(num t) {
    if (t < 0 || t > 1) {
      throw ArgumentError('Parameter t must be in range [0, 1], got: $t');
    }
    num angle = startAngle + t * centralAngle.rad;
    return Point(
      center.x + _radius * cos(angle),
      center.y + _radius * sin(angle),
    );
  }

  /// Gets the tangent vector at parametric position t ∈ [0, 1].
  ///
  /// The tangent vector is perpendicular to the radius at that point.
  Point tangentAt(double t) {
    if (t < 0 || t > 1) {
      throw ArgumentError('Parameter t must be in range [0, 1], got: $t');
    }
    double angle = startAngle + t * centralAngle.rad;
    // Tangent is perpendicular to radius, so rotate by 90°
    return Point(
      -_radius * sin(angle),
      _radius * cos(angle),
    );
  }

  /// Calculates the bounding box of the arc.
  List<Point> boundingBox() {
    num minX = double.infinity;
    num maxX = double.negativeInfinity;
    num minY = double.infinity;
    num maxY = double.negativeInfinity;

    List<Point> pointsToCheck = [startPoint, endPoint];

    // Check extreme points if they fall within the arc's angular range
    // Normalize angles to [0, 2pi) for comparison
    num start = startAngle % (2 * pi);
    if (start < 0) start += 2 * pi;

    num end = (start + centralAngle.rad);
    // Note: end can be > 2pi, which is fine for range checking

    // Helper to check if an angle is within [start, end]
    bool isAngleInArc(double angle) {
      // Normalize angle to be just after start
      double a = angle;
      if (a < start) a += 2 * pi;
      return a <= end;
    }

    // Check 0, pi/2, pi, 3pi/2
    if (isAngleInArc(0) || isAngleInArc(2 * pi)) {
      pointsToCheck.add(Point(center.x + _radius, center.y));
    }
    if (isAngleInArc(pi / 2)) {
      pointsToCheck.add(Point(center.x, center.y + _radius));
    }
    if (isAngleInArc(pi)) {
      pointsToCheck.add(Point(center.x - _radius, center.y));
    }
    if (isAngleInArc(3 * pi / 2)) {
      pointsToCheck.add(Point(center.x, center.y - _radius));
    }

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
    return 'Arc(radius: $_radius, centralAngle: ${centralAngle.deg}°, length: $length)';
  }
}
