part of geometry;

/// Class `Point3D` represents a point in two or three-dimensional space.
/// The point coordinates are represented by `x`, `y` and `z`.
///
/// The `Point` class supports a wide variety of operations such as basic arithmetic operations,
/// transformation operations (like rotation and scaling), distance and angle calculations,
/// conversion to/from polar coordinates, and geometric operations related to lines, triangles,
/// circles, and polygons.
class Point3D {
  /// The x-coordinate of the point.
  num x;

  /// The y-coordinate of the point.
  num y;

  /// The z-coordinate of the point.
  num z;

  /// Constructor for creating a new `Point`.
  ///
  /// `x` and `y` are the x and y-coordinates of the point.
  /// `z` is the z-coordinate of the point.
  ///
  /// Example:
  /// ```dart
  /// var p1 = Point(1, 2, 3);  // 3D point
  /// ```
  Point3D(this.x, this.y, this.z) : super();

  /// Creates a 3D point at the origin of the coordinate system.
  ///
  /// Example:
  /// ``` dart
  /// var p = Point3D.origin; // creates a 3D point (0, 0, 0)
  static Point3D get origin {
    return Point3D(0, 0, 0);
  }

  /// Creates a 3D point and sets the coordinates of the point given spherical
  /// coordinates `r`, `theta`, and `phi`.
  ///
  /// `r` is the radius, `theta` is the angle in the xy-plane (in radians),
  /// and `phi` is the angle from the z-axis (in radians).
  ///
  /// Example:
  /// ```dart
  /// var p = Point3D.fromSphericalCoordinates(5, radians(53.13), radians(30));
  /// print(p); // Output: Point(1.50, 1.999997320371271, 4.330127018922194)
  /// ```
  factory Point3D.fromSphericalCoordinates(num r, num theta, num phi) {
    var x = r * sin(phi) * cos(theta);
    var y = r * sin(phi) * sin(theta);
    var z = r * cos(phi);
    return Point3D(x, y, z);
  }

  /// Constructs a new `Point` from a list of numbers.
  ///
  /// The list should contain 3 numbers. If it contains 2 numbers, they will be used as the `x`, `y` and `z` coordinates.
  /// If the list contains any other number of elements, an exception will be thrown.
  ///
  /// Example:
  /// ```dart
  /// var point3D = Point3D.fromList([3, 4, 5]);
  /// print(point3D); // Output: Point(3, 4, 5)
  /// ```
  ///
  /// Throws an [ArgumentError] if `coords` contains fewer or more than 3 numbers.
  factory Point3D.fromList(List<num> coords) {
    if (coords.length < 3 || coords.length > 3) {
      throw ArgumentError('List must contain 3 numbers.');
    }
    var x = coords[0];
    var y = coords[1];
    var z = coords[2];

    return Point3D(x, y, z);
  }

  /// Converts this `3DPoint` to a list of numbers, which can be used to represent it as a vector3.
  ///
  ///
  /// Example:
  /// ```dart
  /// var point3D = Point3D(3, 4, 5);
  /// print(point3D.toVector()); // Output: [3, 4, 5]
  /// ```
  ///
  /// Returns a Vector3 with 3 numbers.
  Vector3 toVector() => Vector3(x, y, z);

  /// Converts the point's coordinates to a list of numbers.
  ///
  /// Example:
  /// ```
  /// var point = Point(3, 4, 5);
  /// print(point.toList()); // Output: [3, 4, 5]
  /// ```
  ///
  /// Returns a list containing `x`, `y`, and `z`.
  List<num> toList() {
    return [x, y, z];
  }

  /// A custom `toString` method for better readability.
  ///
  /// Example:
  /// ```dart
  /// var p = Point(1, 2, 3);
  /// print(p);  // Output: Point(1, 2, 3)
  /// ```
  @override
  String toString() => 'Point3D($x, $y, $z)';

  /// Overrides the subtraction (-) operator.
  ///
  /// Subtracts the x, y, and z coordinates of `other` point from the coordinates
  /// of this point.
  ///
  /// Example:
  /// ```dart
  /// var point1 = Point3D(2, 2, 2);
  /// var point2 = Point3D(1, 1, 1);
  /// print(point1 - point2); // Output: Point3D(1.0, 1.0, 1.0)
  /// ```
  ///
  /// Returns a new `Point3D`.
  Point3D operator -(Point3D other) =>
      Point3D(x - other.x, y - other.y, z - other.z);

  /// Overrides the addition (+) operator.
  ///
  /// Adds the x, y, and z coordinates of `other` point to the coordinates
  /// of this point.
  ///
  /// Example:
  /// ```dart
  /// var point1 = Point3D(2, 2, 2);
  /// var point2 = Point3D(1, 1, 1);
  /// print(point1 - point2); // Output: Point3D(3.0, 3.0, 3.0)
  /// ```
  ///
  /// Returns a new `Point3D`.
  Point3D operator +(Point3D other) =>
      Point3D(x + other.x, y + other.y, z + other.z);

  /// Overrides the multiplication (*) operator.
  ///
  /// Multiplies the x, y, and z coordinates of this point by `scalar`.
  ///
  /// Example:
  /// ```dart
  /// var point = Point3D(2, 3, 4);
  /// print(point * 2); // Output: Point3D(4.0, 6.0, 8.0)
  /// ```
  ///
  /// Returns a new `Point3D`.
  Point3D operator *(num scalar) => Point3D(x * scalar, y * scalar, z * scalar);

  /// Overrides the division (/) operator.
  ///
  /// Divides the x, y, and z coordinates of this point by `scalar`.
  /// If `scalar` is zero, throws an [ArgumentError].
  ///
  /// Example:
  /// ```dart
  /// var point = Point3D(4, 6, 8);
  /// print(point / 2); // Output: Point3D(2.0, 3.0, 4.0)
  /// ```
  ///
  /// Returns a new `Point3D`.
  Point3D operator /(num scalar) {
    if (scalar == 0) throw ArgumentError('Cannot divide by zero.');
    return Point3D(x / scalar, y / scalar, z / scalar);
  }

  /// Overloads the == (equality) operator.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return (other is Point3D) && x == other.x && y == other.y && z == other.z;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ (z.hashCode);

  /// Rotates the point around the origin (0, 0, 0) by a given `angle` (in radians).
  ///
  /// The rotation is performed counterclockwise.
  ///
  /// Example:
  /// ```
  /// var point = Point3D(1, 0, 0);
  /// Angle angle = Angle.radians(math.pi / 2)
  /// var rotated = point.rotate(angle);
  /// print(rotated); // Output: Point3D(0, 1, 0)
  /// ```
  ///
  /// Returns a new `Point3D` instance representing the rotated point.
  Point3D rotate(Angle angle) {
    var cosAngle = cos(angle.rad);
    var sinAngle = sin(angle.rad);
    var xRotated = x * cosAngle - y * sinAngle;
    var yRotated = x * sinAngle + y * cosAngle;
    return Point3D(xRotated, yRotated, z);
  }

  /// Rotates the point around a given `origin` by a specific `angle (in radians).
  ///
  /// The rotation is performed counterclockwise.
  /// If no origin is provided, the rotation is performed around the origin (0, 0, 0).
  ///
  /// Example:
  /// ```
  /// var point = Point3D(2, 0, 0);
  /// var origin = Point3D(1, 0, 0);
  /// Angle angle = Angle.radians(math.pi / 2)
  /// var rotated = point.rotateBy(angle, origin);
  /// print(rotated); // Output: Point3D(1, 1, 0)
  /// ```
  ///
  /// Returns a new `Point3D` instance representing the rotated point.
  Point3D rotateBy(num angle, [Point3D? origin]) {
    origin = origin ?? Point3D.origin;

    var cosAngle = cos(angle);
    var sinAngle = sin(angle);

    var translatedX = x - origin.x;
    var translatedY = y - origin.y;

    var rotatedX = translatedX * cosAngle - translatedY * sinAngle;
    var rotatedY = translatedX * sinAngle + translatedY * cosAngle;

    x = rotatedX + origin.x;
    y = rotatedY + origin.y;

    return Point3D(x, y, z);
  }

  /// Computes the Euclidean distance between this point and another.
  ///
  /// The Euclidean distance in 3D space is returned.
  ///
  /// Example:
  /// ```
  /// var point1 = Point3D(1, 2, 3);
  /// var point2 = Point3D(4, 5, 6);
  /// print(point1.distanceTo(point2)); // Output: 5.196152422706632
  /// ```
  ///
  /// Returns the distance as a `double`.
  double distanceTo(Point3D otherPoint) {
    var dx = otherPoint.x - x;
    var dy = otherPoint.y - y;
    var dz = otherPoint.z - z;
    return sqrt(dx * dx + dy * dy + dz * dz);
  }

  /// Computes the midpoint between this point and another.
  ///
  /// Example:
  /// ```
  /// var point1 = Point3D(1, 2, 3);
  /// var point2 = Point3D(4, 5, 6);
  /// print(point1.midpointTo(point2)); // Output: Point3D(2.5, 3.5, 4.5)
  /// ```
  ///
  /// Returns a new `Point3D` representing the midpoint.
  Point3D midpointTo(Point3D otherPoint) {
    var mx = (x + otherPoint.x) / 2;
    var my = (y + otherPoint.y) / 2;
    var mz = (z + otherPoint.z) / 2;
    return Point3D(mx, my, mz);
  }

  /// Moves the point by a given delta along each axis.
  ///
  /// Example:
  /// ```
  /// var point = Point3D(1, 2, 3);
  /// point.move(1, -1, 2);
  /// print(point); // Output: Point3D(2, 1, 5)
  /// ```
  Point3D move(num dx, num dy, num dz) {
    var xNew = x + dx;
    var yNew = y + dy;
    var zNew = z + dz;

    return Point3D(xNew, yNew, zNew);
  }

  /// Scales the point by a given factor.
  ///
  /// If the point is 3-dimensional (i.e., `z` is not `null`),
  /// it is scaled along the z-axis as well.
  ///
  /// Example:
  /// ```
  /// var point = Point3D(1, 2, 3);
  /// print(point.scale(2)); // Output: Point3D(2, 4, 6)
  /// ```
  Point3D scale(num factor) {
    var xNew = x * factor;
    var yNew = y * factor;
    var zNew = z * factor;

    return Point3D(xNew, yNew, zNew);
  }

  /// Reflects the point through the given `origin`.
  ///
  /// If `origin` is not given, reflects through the origin `(0, 0, 0)`,
  /// the reflection is computed in 3D space
  ///
  /// Example:
  /// ```dart
  /// var point = Point3D(1, 2, 3);
  /// var origin = Point3D(0, 0, 0);
  /// print(point.reflect(origin)); // Output: Point3D(-1, -2, -3)
  /// ```
  ///
  /// Returns a new `Point3D` representing the reflection.
  Point3D reflect([Point3D? origin]) {
    origin = origin ?? Point3D.origin;

    var rx = 2 * origin.x - x;
    var ry = 2 * origin.y - y;
    var rz = 2 * origin.z - z;
    return Point3D(rx, ry, rz);
  }

  /// Calculates the angle (in radians) between this point and another,
  /// considering the line between them as the hypotenuse of a right triangle.
  ///
  /// If either point is 3-dimensional, only the x and y
  /// coordinates are used in the calculation.
  ///
  /// Example:
  /// ```dart
  /// var point1 = Point3D(1, 1, 0);
  /// var point2 = Point3D(4, 5, 0);
  /// Angle angle = point1.angleBetween(point2));
  /// print(angle.deg); // Output: 53.13010235415598
  /// ```
  ///
  /// Returns the angle as a `double`.
  Angle angleBetween(Point3D otherPoint) {
    var dx = otherPoint.x - x;
    var dy = otherPoint.y - y;
    return Angle(rad: atan2(dy, dx));
  }

  /// Translates the point by the given amounts `dx`, `dy`, and `dz`.
  ///
  /// Example:
  /// ```dart
  /// var p = Point3d(3, 4, 5);
  /// p.translate(1, 2, 3);
  /// print(p); // Output: Point3D(4, 6, 8)
  /// ```
  Point3D translate(num dx, num dy, num dz) {
    var xNew = x + dx;
    var yNew = y + dy;
    var zNew = z + dz;

    return Point3D(xNew, yNew, zNew);
  }

  /// Calculates the slope of the line formed by this point and another.
  ///
  /// If the line is vertical (i.e., the x-coordinates of both points are the same),
  /// returns `double.infinity`.
  ///
  /// Example:
  /// ```dart
  /// var point1 = Point(2, 3);
  /// var point2 = Point(5, 11);
  /// print(point1.slopeTo(point2)); // Output: 2.6666666666666665
  /// ```
  ///
  /// Returns the slope as a `double`.
  double slopeTo(Point otherPoint) {
    var dy = otherPoint.y - y;
    var dx = otherPoint.x - x;
    if (dx == 0) {
      return double.infinity; // Vertical line: slope is undefined
    }
    return dy / dx;
  }

  /// Checks if this point is collinear with two other points.
  ///
  /// Example:
  /// ```dart
  /// var point1 = Point(1, 1, 1);
  /// var point2 = Point(2, 2, 2);
  /// var point3 = Point(3, 3, 3);
  /// print(point1.isCollinear(point2, point3)); // Output: true
  /// ```
  ///
  /// Returns `true` if the points are collinear, and `false` otherwise.
  bool isCollinear(Point3D a, Point3D b) {
    return (b.y - a.y) * (b.x - x) == (b.y - y) * (b.x - a.x);
  }

  /// Calculates the shortest distance from this point to a line defined by two points.
  ///
  /// Example:
  /// ```dart
  /// var point = Point(1, 1);
  /// var linePoint1 = Point(0, 0);
  /// var linePoint2 = Point(0, 2);
  /// print(point.distanceToLine(linePoint1, linePoint2)); // Output: 1.0
  /// ```
  ///
  /// Returns the distance as a `double`.
  double distanceToLine(Point3D linePoint1, Point3D linePoint2) {
    var num = ((linePoint2.y - linePoint1.y) * x -
            (linePoint2.x - linePoint1.x) * y +
            linePoint2.x * linePoint1.y -
            linePoint2.y * linePoint1.x)
        .abs();
    var den = sqrt(pow(linePoint2.y - linePoint1.y, 2) +
        pow(linePoint2.x - linePoint1.x, 2));
    return num / den;
  }

  /// Computes the bearing from this point to another point.
  /// The bearing is the angle (in degrees) between the line from this point to
  /// the other point and the line from this point to the eastward direction, measured
  /// clockwise from north.
  ///
  /// Example:
  /// ```dart
  /// var point1 = Point(0, 0, 0);
  /// var point2 = Point(1, 1, 0);
  /// Angle bearing = point1.bearingTo(point2);
  /// print(bearing.deg); // Output: 45.0
  /// ```
  ///
  /// Returns the bearing as a `double`.
  Angle bearingTo(Point3D point) {
    var angle = Angle.atan2(point.y - y, point.x - x);
    //var bearing = (toDegrees(angle) % 360 + 360) % 360;
    return angle;
  }

  /// Calculates the shortest distance from this point to a circle.
  /// If this point is inside the circle, the distance is 0.
  ///
  /// Example:
  /// ```dart
  /// var point = Point(1, 1);
  /// var center = Point(0, 0);
  /// var radius = 0.5;
  /// print(point.distanceToCircle(center, radius)); // Output: 0.9142135623730951
  /// ```
  ///
  /// Returns the distance as a `double`.
  double distanceToCircle(Point3D center, double radius) {
    var distanceToCenter = distanceTo(center);
    return max(0, distanceToCenter - radius);
  }

  /// Calculates the shortest distance from this point to a polyline, which is a
  /// list of points forming a broken line.
  ///
  /// Example:
  /// ```dart
  /// var point = Point(1, 1);
  /// var polyline = [Point(0, 0), Point(0, 2), Point(2, 2), Point(2, 0)];
  /// print(point.distanceToPolyline(polyline)); // Output: 1.0
  /// ```
  ///
  /// Returns the distance as a `double`.
  double distanceToPolyline(List<Point3D> polyline) {
    var minDistance = double.infinity;
    for (var i = 0; i < polyline.length - 1; i++) {
      var distance = distanceToLine(polyline[i], polyline[i + 1]);
      minDistance = min(minDistance, distance);
    }
    return minDistance;
  }

  /// Interpolates between two points, using this point as the ratio.
  /// If `z` is `null` for any of the points, the resulting point will be 2-dimensional.
  ///
  /// Example:
  /// ```dart
  /// var ratioPoint = Point(0.5, 0);
  /// var point1 = Point(0, 0);
  /// var point2 = Point(2, 2);
  /// print(ratioPoint.interpolate(point1, point2)); // Output: Point(1.0, 1.0)
  /// ```
  ///
  /// Returns a new `Point3D`.
  Point3D interpolate(Point3D point1, Point3D point2) {
    var x = point1.x + this.x * (point2.x - point1.x);
    var y = point1.y + this.x * (point2.y - point1.y);
    var z = point1.z + this.x * (point2.z - point1.z);
    return Point3D(x, y, z);
  }

  /// Calculates the area of the triangle formed by this point and two other points.
  ///
  /// Example:
  /// ```dart
  /// var point1 = Point(0, 0);
  /// var point2 = Point(2, 0);
  /// var point3 = Point(1, 2);
  /// print(point1.triangleArea(point2, point3)); // Output: 2.0
  /// ```
  ///
  /// Returns the area as a `double`.
  double triangleArea(Point3D point1, Point3D point2) {
    var area = 0.5 *
        ((point1.x - x) * (point2.y - y) - (point1.y - y) * (point2.x - x))
            .abs();
    return area;
  }

  /// Checks if this point is inside a polygon or on its boundary.
  /// The polygon is represented by a list of points in counter-clockwise order.
  /// A tolerance value is used to handle floating point inaccuracies.
  ///
  /// Example:
  /// ```dart
  /// var point = Point(1, 1);
  /// var polygon = [Point(0, 0), Point(0, 2), Point(2, 2), Point(2, 0)];
  /// print(point.isInsidePolygon(polygon, 1e-9)); // Output: true
  /// ```
  ///
  /// Returns `true` if the point is inside the polygon or on its boundary, and `false` otherwise.
  bool isInsidePolygon(List<Point3D> polygon, [double tolerance = 1e-10]) {
    var numVertices = polygon.length;
    var j = numVertices - 1;
    var inside = false;

    for (var i = 0; i < numVertices; i++) {
      if (isOnLineSegment(polygon[i], polygon[j], tolerance)) {
        return true; // The point is on the boundary
      }
      if (((polygon[i].y > y) != (polygon[j].y > y)) &&
          (x <
              (polygon[j].x - polygon[i].x) *
                      (y - polygon[i].y) /
                      (polygon[j].y - polygon[i].y) +
                  polygon[i].x)) {
        inside = !inside;
      }
      j = i;
    }
    return inside;
  }

  /// Checks if the point is on a line segment defined by two points.
  /// A tolerance value is used to handle floating point inaccuracies.
  ///
  /// Returns `true` if the point is on the line segment, and `false` otherwise.
  bool isOnLineSegment(Point3D pointA, Point3D pointB,
      [double tolerance = 1e-10]) {
    var crossProduct = (y - pointA.y) * (pointB.x - pointA.x) -
        (x - pointA.x) * (pointB.y - pointA.y);
    if (crossProduct.abs() > tolerance) {
      return false; // The point is not on the line
    }
    var dotProduct = (x - pointA.x) * (pointB.x - pointA.x) +
        (y - pointA.y) * (pointB.y - pointA.y);
    if (dotProduct < 0) {
      return false; // The point is not between the two points of the line segment
    }
    var squaredLength = (pointB.x - pointA.x) * (pointB.x - pointA.x) +
        (pointB.y - pointA.y) * (pointB.y - pointA.y);
    return dotProduct <= squaredLength + tolerance;
  }
}
