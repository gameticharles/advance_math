part of '../geometry.dart';

/// A class that represents a plane in a three-dimensional space.
/// Each instance of this class is defined by a [Point] and a normal [Vector].
///
/// ```dart
/// var point = Point(1, 2, 3);
/// var normal = Vector(1, 0, 0);
/// var plane = Plane(point, normal);
/// print(plane);  // Output: Plane(point: Point(1, 2, 3), normal: Vector(1, 0, 0))
/// ```
class Plane {
  final Point point;
  final Vector3 normal;

  /// Creates a new instance of the [Plane] class.
  ///
  /// Takes a [Point] and a normal [Vector] as parameters.
  Plane(this.point, this.normal);

  // static Plane fromPointAndDirection(Point point, Vector3 direction) {
  //   assert(direction.isNotEmpty && direction.direction != 180);

  //   if (abs(point.x) < 0.5 || abs(point.y) < 0.5) {
  //     throw ArgumentError(
  //         'The given point $point must be at least ${0.5} away from the origin');
  //   }

  //   double distanceFromOrigin = point.distanceToSqrt(origin: Point.origin());
  //   Vector unitDirection = direction.normalize().scale(distanceFromOrigin);

  //   return Plane(point, unitDirection);
  // }

  @override
  String toString() {
    return 'Plane(point: $point, normal: $normal)';
  }

  bool get isValid => point.distanceTo(Point.origin()) > 0;

  /// Creates a line perpendicular to this plane, passing through [pivot].
  ///
  /// Example:
  /// ```dart
  /// var point = Point(1, 2, 3);
  /// var normal = Vector3(1, 0, 0);
  /// var plane = Plane(point, normal);
  /// var pivot = Point(2, 3, 4);
  /// var perpendicularLine = plane.perpendicularLine(pivot);
  /// print(perpendicularLine);  // Output: Line(Point(2, 3, 4), Vector(1, 0, 0))
  /// ```
  Line perpendicularLine(Point pivot) {
    return Line(p1: pivot, p2: normal.toPoint() + pivot);
  }

  /// Creates a line parallel to this plane.
  ///
  /// The line will pass through the specified [throughPoint] if it's given.
  /// If [throughPoint] is `null` or not provided, the line will pass through
  /// the point used to define the plane.
  ///
  /// The line is also made to be parallel to the specified [planeType].
  ///
  /// Example:
  /// ```dart
  /// var point = Point(1, 2, 3);
  /// var normal = Vector3(1, 0, 0);
  /// var plane = Plane(point, normal);
  /// var throughPoint = Point(2, 3, 4);
  /// var parallelLine = plane.parallelLine(throughPoint, PlaneType.xy);
  /// print(parallelLine);  // Output: Line(Point(2, 3, 4), Vector(0, 0, 1))
  /// ```
  Line parallelLine({Point? throughPoint, required PlaneType planeType}) {
    throughPoint ??= point;

    switch (planeType) {
      case PlaneType.xy:
        return Line(p1: throughPoint, p2: throughPoint + Point(0, 0, 1));
      case PlaneType.xz:
        return Line(p1: throughPoint, p2: throughPoint + Point(0, 1, 0));
      case PlaneType.yz:
        return Line(p1: throughPoint, p2: throughPoint + Point(1, 0, 0));
      default:
        throw ArgumentError('Invalid PlaneType provided.');
    }
  }

  // double distanceFrom(Plane other) {
  //   return _pointDistanceFromOther(point, other.point);
  // }

  // double _pointDistanceFromOther(Point p1, Point p2) {
  //   return p1.distanceToLine(p2, point);
  // }

  /// Checks if the [Plane] contains a [Point].
  ///
  /// Returns `true` if the [Point] lies on the plane, and `false` otherwise.
  bool containsPoint(Point other) {
    Vector differenceVector = (other - point).toVector();
    return normal.dot(differenceVector).abs() < 1e-10;
  }

  /// Creates a new plane parallel to this plane, passing through [other].
  ///
  /// Example:
  /// ```dart
  /// var point = Point(1, 2, 3);
  /// var normal = Vector(1, 0, 0);
  /// var plane = Plane(point, normal);
  /// var otherPoint = Point(1, 3, 4);
  /// var newPlane = plane.parallelThroughPoint(otherPoint);
  /// print(newPlane);  // Output: Plane(point: Point(1, 3, 4), normal: Vector(1, 0, 0))
  /// ```
  Plane parallelThroughPoint(Point other) {
    return Plane(other, normal);
  }

  /// Calculates the angle between this [Plane] and [other] in degrees.
  ///
  /// Example:
  /// ```dart
  /// var point1 = Point(1, 2, 3);
  /// var normal1 = Vector(1, 0, 0);
  /// var plane1 = Plane(point1, normal1);
  ///
  /// var point2 = Point(2, 3, 4);
  /// var normal2 = Vector(0, 1, 0);
  /// var plane2 = Plane(point2, normal2);
  ///
  /// Angle angle = plane1.angleBetween(plane2);
  /// print(angle.deg);  // Output: 90.0
  /// ```
  Angle angleBetween(Plane other) {
    double dotProduct = normal.dot(other.normal);
    num productOfMagnitudes = normal.magnitude * other.normal.magnitude;
    return Angle(rad: acos(dotProduct / productOfMagnitudes));
  }

  /// Finds the line of intersection between this [Plane] and [other].
  ///
  /// Returns `null` if the planes are parallel (and therefore do not intersect).
  Line? intersectionWithPlane(Plane other) {
    Vector direction = normal.cross(other.normal);
    if (direction.magnitude < 1e-10) return null; // The planes are parallel

    // Solve the system of linear equations
    // normal1 . X = normal1 . point1
    // normal2 . X = normal2 . point2
    // to find a point X on the line of intersection.
    num D = -normal.dot(point.toVector());
    num E = -other.normal.dot(other.point.toVector());
    num denominator = normal.z * other.normal.x - normal.x * other.normal.z;

    if (denominator.abs() < 1e-10) {
      // The direction vector of the line of intersection is parallel to the yz-plane.
      denominator = normal.z * other.normal.y - normal.y * other.normal.z;
      double x = (E * normal.z - D * other.normal.z) / denominator;
      return Line(
          p1: Point(x, 0, 0),
          p2: Point(x, 0, 0) + Point.fromList(direction.toList()));
    } else {
      double y = (D * other.normal.x - E * normal.x) / denominator;
      return Line(
          p1: Point(0, y, 0),
          p2: Point(0, y, 0) + Point.fromList(direction.toList()));
    }
  }

  /// Checks if this [Plane] is parallel to [other].
  ///
  /// Returns `true` if the planes are parallel, and `false` otherwise.
  bool isParallelTo(Plane other) {
    return normal.isParallelTo(other.normal);
  }

  /// Checks if this [Plane] is perpendicular to [other].
  ///
  /// Returns `true` if the planes are perpendicular, and `false` otherwise.
  bool isPerpendicularTo(Plane other) {
    return normal.isPerpendicularTo(other.normal);
  }

  ///Returns the magnitude (or norm) of the normal.
  ///
  /// This is equivalent to the Euclidean length of the vector.
  num magnitude() {
    return normal.magnitude;
  }

  Vector scaleBy(double scalar) {
    return normal.scale(scalar);
  }

  Line parallelToOrigin() {
    return getPerpendicularLine(Point.origin());
  }

  Line perpendicularToOrigin() {
    return getPerpendicularLine(Point.origin());
  }

  /// Gets the perpendicular line to this plane passing through the given point.
  ///
  /// Returns a line object representing the perpendicular line.
  Line getPerpendicularLine(Point point) {
    // Get the direction vector of the perpendicular line.
    Vector directionVector = normal.cross(Vector3(0, 1, 0));

    // Create a line object from the direction vector.
    return Line(
        p1: point, p2: point + Point.fromList(directionVector.toList()));
  }

  /// Calculates the shortest (perpendicular) distance from a point in space to the plane.
  double distanceToPoint(Point other) {
    return (normal.dot((other - point).toVector())).abs();
  }

  /// Given a point in space, this method finds the point that is the reflection of the given point through the plane.
  Point reflectionOfPoint(Point other) {
    Vector pVector = (other - point).toVector();
    Vector3 reflectionVector = pVector - normal.scale(2 * normal.dot(pVector));
    return point + reflectionVector.toPoint();
  }

  /// Finds the intersection point between a line and the plane. If the line is parallel to the plane and doesn't intersect, it returns `null`.
  Point? intersectionWithLine(Line line) {
    Point lineVector = line.point2 - line.point1;
    double denominator = normal.dot(lineVector.toVector());

    if (denominator.abs() < 1e-10) {
      // The line is parallel to the plane
      return null;
    }

    double t =
        normal.dot(point.toVector() - line.point1.toVector()) / denominator;
    return line.point1 + lineVector.scale(t);
  }

  /// Finds the orthogonal projection of a given point onto the plane.
  Point projectionOfPoint(Point other) {
    Vector pVector = (other - point).toVector();
    Vector3 projectionVector = pVector - normal.scale(normal.dot(pVector));
    return point + projectionVector.toPoint();
  }

  // /// Rotates the plane by a given quaternion `q`.
  // Plane rotate(Quaternion q) {
  //   Vector3 newNormal = normal.rotate(q);
  //   return Plane(point, newNormal);
  // }

  /// Translates the plane by a given vector `v`.
  Plane translate(Vector3 v) {
    return Plane(point + v.toPoint(), normal);
  }
}

/// Define an enumeration for the XY-plane, XZ-plane, and YZ-plane
enum PlaneType { xy, xz, yz }
