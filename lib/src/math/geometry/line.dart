part of 'geometry.dart';

// Todo: constructors for gradients , intercepts , x or y, etc

/// A class representing a line in a 2-dimensional space.
///
/// The line is defined by two distinct points, or by gradient and intercept,
/// or by a point and a gradient, or by an x-coordinate, a gradient and an intercept.
///
/// Examples:
/// ```dart
/// var line1 = Line(p1: Point(1, 1), p2: Point(2, 2));
/// print(line1); // Output: Line(Point(1.0, 1.0), Point(2.0, 2.0))
///
/// var line2 = Line(gradient: 1, intercept: 0);
/// print(line2); // Output: Line(Point(0.0, 0.0), Point(1.0, 1.0))
///
/// var line3 = Line(gradient: 2.0, intercept: 2.0, x: 3.0);
/// print(line3); // Output: Line(Point(3.0, 8.0), Point(4.0, 10.0))
///
/// var line4 = Line(y: 1.0, gradient: 2.0, intercept: 3.0);
/// print(line4); // Output: Line(Point(-1.0, 1.0), Point(0.0, 3.0))
///
/// var line5 = Line(y: 1.0, gradient: -0.5, intercept: 7.0);
/// print(line5); // Output: Line(Point(-12.0, 1.0), Point(-11.0, 5.5))
///
/// var line6 = Line(y: 1.0, gradient: 2.0, x: 1.0);
/// print(line6); // Output: Line(Point(1.0, 1.0), Point(2.0, 3.0))
///
/// ```
class Line {
  /// The first point defining the line.
  final Point point1;

  /// The second point defining the line.
  final Point point2;

  /// Gradient of the line (if defined).
  final num? _gradient;

  /// Y-intercept of the line (if defined).
  final num? _intercept;

  /// Private constructor used by the factory constructor.
  Line._(this.point1, this.point2, [this._gradient, this._intercept]);

  /// Factory constructor to create a Line instance.
  ///
  /// Supports several forms of input to define a line: two points, a gradient and intercept, a gradient and an x-coordinate, or a gradient, a y-coordinate, and an intercept.
  ///
  /// Throws an [ArgumentError] if provided parameters are insufficient to define a distinct line.
  factory Line(
      {Point? p1,
      Point? p2,
      num? y,
      num? gradient = 0,
      num? intercept = 0,
      num? x}) {
    if (p1 != null && p2 != null) {
      if (p1 == p2) {
        throw ArgumentError("The two points must be distinct.");
      }
      return Line._(p1, p2);
    }
    if (gradient != null && intercept != null && x != null) {
      num y1 = gradient * x + intercept;
      num y2 = gradient * (x + 1) + intercept;
      return Line._(Point(x, y1), Point(x + 1, y2), gradient, intercept);
    }
    if (y != null && gradient != null && intercept != null) {
      num x1 = (y - intercept) / gradient;
      num x2 = ((y + 1) - intercept) / gradient;
      return Line._(Point(x1, y), Point(x2, y + 1), gradient, intercept);
    }
    if (y != null && gradient != null && x != null) {
      num intercept = y - gradient * x;
      num y2 = gradient * (x + 1) + intercept;
      return Line._(Point(x, y), Point(x + 1, y2), gradient, intercept);
    }
    if (gradient != null && intercept != null) {
      num y1 = intercept;
      num y2 = gradient + intercept;
      return Line._(Point(0, y1), Point(1, y2), gradient, intercept);
    }
    throw ArgumentError(
        'Provided parameters are not sufficient to define a distinct line.');
  }

  @override
  String toString() {
    return 'Line($point1, $point2)';
  }

  /// Returns the two points defining the line.
  List<Point> toList() {
    return [point1, point2];
  }

  /// Returns the length of the line.
  ///
  /// This is calculated as the distance between [point1] and [point2].
  ///
  /// Example:
  /// ```dart
  /// var p1 = Point(1, 1);
  /// var p2 = Point(2, 2);
  /// var line = Line(p1, p2);
  /// print(line.length()); // Output: 1.4142135623730951
  /// ```
  num length() {
    return point1.distanceTo(point2);
  }

  /// Returns the slope of the line.
  ///
  /// This is calculated as the vertical difference divided by the horizontal difference between [point1] and [point2].
  ///
  /// Example:
  /// ```dart
  /// var p1 = Point(1, 1);
  /// var p2 = Point(2, 2);
  /// var line = Line(p1, p2);
  /// print(line.slope()); // Output: 1.0
  /// ```
  num slope() {
    return _gradient ?? (point2.y - point1.y) / (point2.x - point1.x);
  }

  /// Returns the y-intercept of the line.
  ///
  /// This is the y-coordinate where the line intersects with the y-axis.
  ///
  /// Example:
  /// ```dart
  /// var p1 = Point(1, 1);
  /// var p2 = Point(2, 2);
  /// var line = Line(p1, p2);
  /// print(line.intercept()); // Output: 0.0
  /// ```
  num intercept() {
    return _intercept ?? point1.y - slope() * point1.x;
  }

  /// Returns the midpoint of the line.
  ///
  /// This is the point that divides the line into two equal segments.
  ///
  /// Example:
  /// ```dart
  /// var p1 = Point(1, 1);
  /// var p2 = Point(2, 2);
  /// var line = Line(p1, p2);
  /// print(line.midpoint()); // Output: Point(1.5, 1.5)
  /// ```
  Point midpoint() {
    return point1.midpointTo(point2);
  }

  /// Checks if a point is on the line.
  ///
  /// This is determined by checking if the point is collinear with [point1] and [point2] and if the sum of the distances from the point to [point1] and [point2] equals the length of the line.
  ///
  /// Example:
  /// ```dart
  /// var p1 = Point(1, 1);
  /// var p2 = Point(2, 2);
  /// var line = Line(p1, p2);
  /// var point = Point(1.5, 1.5);
  /// print(line.containsPoint(point)); // Output: true
  /// ```
  bool containsPoint(Point point) {
    return point.isCollinear(point1, point2) &&
        (point1.distanceTo(point) + point2.distanceTo(point)).abs() - length() <
            1e-10;
  }

  /// Returns the line that bisects this line perpendicular.
  ///
  /// This line crosses through the midpoint of this line and forms a 90 degree angle.
  ///
  /// Example:
  /// ```dart
  /// var p1 = Point(1, 1);
  /// var p2 = Point(2, 2);
  /// var line = Line(p1, p2);
  /// print(line.perpendicularBisector()); // Output: Line(Point(1.5, 1.5), Point(2.5, 1.5))
  /// ```
  Line perpendicularBisector() {
    var midpoint = this.midpoint();
    if (point2.x == point1.x) {
      return Line(p1: midpoint, p2: Point(midpoint.x + 1, midpoint.y));
    }
    var newSlope = -1 / slope();
    var newIntercept = midpoint.y - newSlope * midpoint.x;
    return Line(
        p1: midpoint,
        p2: Point(midpoint.x + 1, newSlope * (midpoint.x + 1) + newIntercept));
  }

  /// Returns the angle between this line and another line.
  ///
  /// The angle is calculated using the tangent of the angles that each line makes with the x-axis.
  ///
  /// Example:
  /// ```dart
  /// var p1 = Point(1, 1);
  /// var p2 = Point(2, 2);
  /// var line1 = Line(p1, p2);
  /// var p3 = Point(3, 3);
  /// var p4 = Point(4, 4);
  /// var line2 = Line(p3, p4);
  /// print(line1.angleBetween(line2)); // Output: 0.0
  /// ```
  double angleBetween(Line otherLine) {
    var tanAngle =
        ((slope() - otherLine.slope()) / (1 + slope() * otherLine.slope()))
            .abs();
    return toDegrees(atan(tanAngle));
  }

  /// Returns a point on the line at a specific distance from another point on the line.
  ///
  /// Throws an [ArgumentError] if the initial point is not on the line.
  ///
  /// Example:
  /// ```dart
  /// var p1 = Point(1, 1);
  /// var p2 = Point(2, 2);
  /// var line = Line(p1, p2);
  /// var point = Point(1.5, 1.5);
  /// print(line.pointAtDistance(point, 1.0)); // Output: Point(2.0, 2.0)
  /// ```
  Point pointAtDistance(Point point, double distance) {
    if (!containsPoint(point)) {
      throw ArgumentError("The given point must be on the line.");
    }
    var ratio = distance / length();
    var x = point.x + ratio * (point2.x - point1.x);
    var y = point.y + ratio * (point2.y - point1.y);
    return Point(x, y);
  }

  /// Returns the point of intersection between this line and another line.
  ///
  /// Returns `null` if the lines are parallel and thus do not intersect.
  ///
  /// Example:
  /// ```dart
  /// var p1 = Point(1, 1);
  /// var p2 = Point(2, 2);
  /// var line1 = Line(p1, p2);
  /// var p3 = Point(1, 2);
  /// var p4 = Point(2, 1);
  /// var line2 = Line(p3, p4);
  /// print(line1.intersection(line2)); // Output: Point(1.5, 1.5)
  /// ```
  Point? intersection(Line otherLine) {
    if (slope() == otherLine.slope()) {
      return null;
    }
    var x =
        (otherLine.intercept() - intercept()) / (slope() - otherLine.slope());
    var y = slope() * x + intercept();
    return Point(x, y);
  }

  /// Checks if this line is parallel to another line.
  ///
  /// This is determined by comparing the slopes of the two lines.
  ///
  /// Example:
  /// ```dart
  /// var p1 = Point(0, 0);
  /// var p2 = Point(1, 1);
  /// var line1 = Line(p1, p2);
  /// var p3 = Point(1, 0);
  /// var p4 = Point(2, 1);
  /// var line2 = Line(p3, p4);
  /// print(line1.parallelTo(line2)); // Output: true
  /// ```
  bool parallelTo(Line otherLine) {
    return slope() == otherLine.slope();
  }

  /// Checks if this line is perpendicular to another line.
  ///
  /// This is determined by checking if the product of the slopes of the two lines is -1.
  ///
  /// Example:
  /// ```dart
  /// var p1 = Point(0, 0);
  /// var p2 = Point(1, 1);
  /// var line1 = Line(p1, p2);
  /// var p3 = Point(0, 1);
  /// var p4 = Point(1, 0);
  /// var line2 = Line(p3, p4);
  /// print(line1.perpendicularTo(line2)); // Output: true
  /// ```
  bool perpendicularTo(Line otherLine) {
    return slope() * otherLine.slope() == -1;
  }

  /// Checks if this line is parallel to another line within a certain tolerance.
  ///
  /// This is determined by comparing the absolute difference of the slopes of the two lines with the tolerance.
  ///
  /// Example:
  /// ```dart
  /// var p1 = Point(0, 0);
  /// var p2 = Point(1, 1);
  /// var line1 = Line(p1, p2);
  /// var p3 = Point(1, 0);
  /// var p4 = Point(2, 1.00000001);
  /// var line2 = Line(p3, p4);
  /// print(line1.isParallel(line2, 1e-7)); // Output: true
  /// ```
  bool isParallel(Line otherLine, [double tolerance = 1e-9]) {
    return (slope() - otherLine.slope()).abs() < tolerance;
  }

  /// Checks if this line is perpendicular to another line within a certain tolerance.
  ///
  /// This is determined by comparing the absolute sum of the product of the slopes of the two lines and 1 with the tolerance.
  ///
  /// Example:
  /// ```dart
  /// var p1 = Point(0, 0);
  /// var p2 = Point(1, 1);
  /// var line1 = Line(p1, p2);
  /// var p3 = Point(0, 1);
  /// var p4 = Point(1, -0.99999999);
  /// var line2 = Line(p3, p4);
  /// print(line1.isPerpendicular(line2, 1e-7)); // Output: true
  /// ```
  bool isPerpendicular(Line otherLine, [double tolerance = 1e-9]) {
    return (slope() * otherLine.slope() + 1).abs() < tolerance;
  }

  /// Returns the angle that this line makes with the x-axis.
  ///
  /// This is calculated using the arc tangent of the slope of the line.
  ///
  /// Example:
  /// ```dart
  /// var p1 = Point(0, 0);
  /// var p2 = Point(1, 1);
  /// var line = Line(p1, p2);
  /// print(line.angleWithXAxis()); // Output: 45.0
  /// ```
  double angleWithXAxis() {
    return toDegrees(atan(slope()));
  }

  /// Returns the angle between this line and another line.
  ///
  /// This is calculated using the arc tangent of the difference of the slopes divided by 1 plus the product of the slopes.
  ///
  /// Example:
  /// ```dart
  /// var p1 = Point(0, 0);
  /// var p2 = Point(1, 1);
  /// var line1 = Line(p1, p2);
  /// var p3 = Point(1, 0);
  /// var p4 = Point(2, -1);
  /// var line2 = Line(p3, p4);
  /// print(line1.angleWithAnotherLine(line2)); // Output: 90.0
  /// ```
  double angleWithOtherLine(Line otherLine) {
    if (isParallel(otherLine)) {
      return 0.0;
    }
    var angle = (atan(
            (otherLine.slope() - slope()) / (1 + slope() * otherLine.slope())))
        .abs();
    return toDegrees(angle);
  }
}
