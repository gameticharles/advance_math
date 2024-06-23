part of '../geometry.dart';

/// A class representing a polygon, which can be used to compute various properties
/// such as area, perimeter, interior and exterior angles, as well as to check
/// whether a point is inside the polygon.
///
/// The class can handle both regular and irregular polygons, defined by either
/// their vertices or the number of sides and side length.
///
/// Parameters:
/// -----------
/// vertices : List<Tuple<int, int>>, optional
///     A list of (x, y) coordinates defining the vertices of the polygon.
///     If not provided, the polygon will be assumed to be regular, and
///     the number of sides and side length must be given.
/// num_sides : int, optional
///     The number of sides in the polygon. Required if vertices are not provided.
/// side_length : double, optional
///     The length of each side of the polygon. Required for regular polygons.
///
/// Attributes:
/// -----------
/// vertices : List<Tuple<int, int>>
///     A list containing the (x, y) coordinates of the polygon vertices.
/// sides : List<double>
///     A list containing the lengths of the polygon sides.
/// num_sides : int
///     The number of sides in the polygon.
/// side_length : double
///     The length of each side of the polygon (if the polygon is regular).
///
/// Example:
/// --------
/// ```dart
/// List<Point> vertices = [Point(0, 0), Point(2, 0), Point(1, 2)];
/// Polygon polygon = Polygon(vertices: vertices);
/// print("Number of sides: ${polygon.numSides}"); // 6
/// ```
class Polygon {
  List<Point>? vertices;
  List<num>? sides;
  int? numSides;
  double? sideLength;

  Polygon({this.vertices, this.numSides, this.sideLength}) {
    if (vertices != null) {
      numSides = vertices!.length;
    }

    if (sideLength != null) {
      sideLength = sideLength;
      sides = List.generate(numSides!, (index) => sideLength!);
    }
  }

  /// Scale the polygon by a given factor.
  ///
  /// Parameters:
  /// -----------
  /// factor : double
  ///     The scaling factor to be applied to the polygon.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// double factor = 2.0;
  /// polygon.scale(factor);
  /// ```
  void scale(double factor) {
    // Scale vertices
    if (vertices != null) {
      vertices = vertices!.map((pt) => pt * factor).toList();
    }

    // Scale sides
    if (sides != null) {
      sides = sides!.map((side) => side * factor).toList();
    }

    // Scale sideLength
    if (sideLength != null) {
      sideLength = sideLength! * factor;
    }
  }

  /// Translate the polygon by a given displacement.

  /// Parameters:
  /// -----------
  /// dx : double
  ///     The amount of displacement along the x-axis.
  /// dy : double
  ///     The amount of displacement along the y-axis.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// double dx = 2.0;
  /// double dy = 1.0;
  /// polygon.translate(dx, dy);
  /// ```
  void translate(double dx, double dy) {
    if (vertices == null) {
      throw ArgumentError("Vertices is null, you can not translate.");
    }
    vertices = vertices!.map((pt) => pt.translate(dx, dy)).toList();
  }

  /// Determine if a point is inside the polygon.
  ///
  /// This method uses the ray casting algorithm to check if a point is inside the polygon.
  /// It casts a ray from the point horizontally to the right and counts the number of
  /// intersections with the polygon's edges. If the number of intersections is odd,
  /// the point is inside the polygon; if it's even, the point is outside.
  ///
  /// Parameters:
  /// -----------
  /// x : double
  ///     The x-coordinate of the point to be tested.
  /// y : double
  ///     The y-coordinate of the point to be tested.
  ///
  /// Returns:
  /// --------
  /// bool
  ///     True if the point is inside the polygon, False otherwise.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// List<Tuple<double, double>> vertices = [(0, 0), (2, 0), (1, 2)];
  /// Polygon polygon = Polygon(vertices: vertices);
  /// bool isInside = polygon.isPointInsidePolygon(Point(1, 1));
  /// print("Is the point ($x, $y) inside the polygon? $isInside");
  /// ```
  bool isPointInsidePolygon(Point point) {
    int n = vertices!.length;
    bool inside = false;
    Point p1 = vertices![0];
    double xinters = 0;

    for (int i = 1; i <= n; i++) {
      Point p2 = vertices![i % n];
      if (point.y > min(p1[1], p2[1])) {
        if (point.y <= max(p1[1], p2[1])) {
          if (point.x <= max(p1[0], p2[0])) {
            if (p1[1] != p2[1]) {
              xinters =
                  (point.y - p1[1]) * (p2[0] - p1[0]) / (p2[1] - p1[1]) + p1[0];
            }
            if (p1[0] == p2[0] || point.x <= xinters) {
              inside = !inside;
            }
          }
        }
      }
      p1 = p2;
    }
    return inside;
  }

  /// Determine if the polygon is convex.
  ///
  /// A polygon is convex if all its interior angles are less than or equal to 180 degrees.
  /// This method calculates the sum of the angles between consecutive edges and checks if
  /// the sum is greater than zero.
  ///
  /// Returns:
  /// --------
  /// bool
  ///     True if the polygon is convex, False otherwise.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// List<Tuple<double, double>> vertices = [(0, 0), (5, 0), (5, 5), (0, 5)];
  /// Polygon polygon = Polygon(vertices: vertices);
  /// bool convex = polygon.isConvex();
  /// print("Is the polygon convex? $convex");
  /// ```
  bool isConvex() {
    if (vertices == null || numSides == null) {
      throw ArgumentError("Vertices or number of sides is null.");
    }

    double angleSum = 0.0;
    for (int i = 0; i < numSides!; i++) {
      Point prevVertex =
          vertices![(i - 1 + vertices!.length) % vertices!.length];
      Point currentVertex = vertices![i];
      Point nextVertex = vertices![(i + 1) % numSides!];

      angleSum += _angleBetween(
        Point(prevVertex.x - currentVertex.x, prevVertex.y - currentVertex.y),
        Point(nextVertex.x - currentVertex.x, nextVertex.y - currentVertex.y),
      );
    }

    return angleSum > 0;
  }

  /// Calculate the angle between two vectors.

  /// This is a private method used internally by the class to calculate the angle between
  /// two vectors v1 and v2. The method uses the dot product and the norms of the vectors
  /// to find the cosine of the angle, and then applies arccos to get the angle in radians.

  /// Parameters:
  /// -----------
  /// v1 : List<double>
  ///     The first vector.
  /// v2 : List<double>
  ///     The second vector.

  /// Returns:
  /// --------
  /// double
  ///     The angle between v1 and v2 in radians.

  /// Example:
  /// --------
  /// This method is not meant to be called directly by users, but it is used internally
  /// by other methods like `isConvex`.
  static double _angleBetween(Point v1, Point v2) {
    double cosAngle = v1.dot(v2) / (v1.magnitude * v2.magnitude);

    // Dart's acos function returns NaN for values out of range,
    //so we need to clamp cosAngle manually
    cosAngle = cosAngle.clamp(-1.0, 1.0);
    return acos(cosAngle);
  }

  /// Calculate the angle between two sides of the polygon.
  ///
  /// This method finds the angle between the sides specified by indices i and j.
  /// The indices are taken modulo the number of sides, so they can be negative or larger than the number of sides.
  ///
  /// Parameters:
  /// -----------
  /// i : int
  ///     The index of the first side.
  /// j : int
  ///     The index of the second side.
  ///
  /// Returns:
  /// --------
  /// double
  ///     The angle between the two sides in radians.
  ///
  /// Raises:
  /// -------
  /// ArgumentError
  ///     If the indices i and j are equal.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// Polygon polygon = Polygon(vertices: [(0, 0), (1, 0), (1, 1), (0, 1)]);
  /// double angle = polygon.angleBetweenSides(0, 2);
  /// ```
  double angleBetweenSides(int i, int j) {
    if (vertices == null || numSides == null) {
      throw ArgumentError("Vertices or number of sides is null.");
    }

    if (i == j) {
      throw ArgumentError("Indices must be different.");
    }

    i %= numSides!;
    j %= numSides!;
    Point v1 = (vertices![i] - vertices![(i - 1) % numSides!]);
    Point v2 = (vertices![j] - vertices![(j - 1) % numSides!]);

    return _angleBetween(v1, v2);
  }

  /// Calculate the distance between two line segments.
  ///
  /// This is a private method used internally by the class to calculate the shortest distance between two line segments.
  /// It first calculates the distance between each endpoint of one line segment and the other line segment.
  /// It then takes the minimum distance among these four distances.
  ///
  /// Parameters:
  /// -----------
  /// p1 : List<double>
  ///     The first endpoint of the first line segment.
  /// p2 : List<double>
  ///     The second endpoint of the first line segment.
  /// q1 : List<double>
  ///     The first endpoint of the second line segment.
  /// q2 : List<double>
  ///     The second endpoint of the second line segment.
  ///
  /// Returns:
  /// --------
  /// double
  ///     The shortest distance between the two line segments.

  /// Example:
  /// --------
  /// This method is not meant to be called directly by users, but it is used internally by other methods.
  static double _lineSegmentDistance(Point p1, Point p2, Point q1, Point q2) {
    double pointToLineDistance(Point p, Point q1, Point q2) {
      double t = ((p.x - q1.x) * (q2.x - q1.x) + (p.y - q1.y) * (q2.y - q1.y)) /
          ((q2.x - q1.x) * (q2.x - q1.x) + (q2.y - q1.y) * (q2.y - q1.y));
      if (t >= 0 && t <= 1) {
        return (p.distanceTo(
            Point(q1.x + t * (q2.x - q1.x), q1.y + t * (q2.y - q1.y))));
      }
      return min(p.distanceTo(q1), p.distanceTo(q2));
    }

    return min(
      min(pointToLineDistance(p1, q1, q2), pointToLineDistance(p2, q1, q2)),
      min(pointToLineDistance(q1, p1, p2), pointToLineDistance(q2, p1, p2)),
    );
  }

  /// Calculate the minimum distance between two polygons.
  ///
  /// Parameters:
  /// -----------
  /// otherPolygon : Polygon
  ///     The other polygon to calculate the distance to.
  ///
  /// Returns:
  /// --------
  /// double
  ///     The minimum distance between the two polygons.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// Polygon otherPolygon = ... // Create or obtain the other polygon
  /// double distance = polygon.distanceToPolygon(otherPolygon);
  /// ```
  double distanceToPolygon(Polygon otherPolygon) {
    double minDistance = double.infinity;
    for (var i = 0; i < numSides!; i++) {
      for (var j = 0; j < otherPolygon.numSides!; j++) {
        double distance = _lineSegmentDistance(
          vertices![i],
          vertices![(i + 1) % numSides!],
          otherPolygon.vertices![j],
          otherPolygon.vertices![(j + 1) % otherPolygon.numSides!],
        );
        minDistance = min(minDistance, distance);
      }
    }
    return minDistance;
  }

  /// Find the nearest point on the polygon to a given point.
  ///
  /// Parameters:
  /// -----------
  /// point : List<double>
  ///     The coordinates of the point.
  ///
  /// Returns:
  /// --------
  /// List<double>
  ///     The coordinates of the nearest point on the polygon to the given point.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// Point point = ... // Create or obtain the point
  /// Point nearestPoint = polygon.nearestPointOnPolygon(point);
  /// ```
  Point nearestPointOnPolygon(Point point) {
    if (vertices == null || numSides == null) {
      throw ArgumentError("Vertices or number of sides is null.");
    }

    num minDistance = double.infinity;
    Point nearestPoint = Point(0, 0);

    for (int i = 0; i < numSides!; i++) {
      int j = (i + 1) % numSides!;
      Point p1 = vertices![i];
      Point p2 = vertices![j];

      double t = (point - p1).dot(p2 - p1) / pow((p2 - p1).magnitude, 2);

      Point candidatePoint;
      if (0 <= t && t <= 1) {
        candidatePoint =
            Point(p1.x + t * (p2.x - p1.x), p1.y + t * (p2.y - p1.y));
      } else {
        candidatePoint = point;
      }

      num distance = (point - candidatePoint).magnitude;
      if (distance < minDistance) {
        minDistance = distance;
        nearestPoint = candidatePoint;
      }
    }
    return nearestPoint;
  }

  /// Calculate the bounding box of the polygon.
  ///
  /// The bounding box is the smallest rectangle that contains the polygon. It is defined by the minimum and maximum
  /// coordinates along each axis (x, y).
  ///
  /// Returns:
  /// --------
  /// List<List<double>>
  ///     The bounding box of the polygon as a list of four points, each represented by [x, y] coordinates.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// List<Point> boundingBox = polygon.boundingBox();
  /// ```
  List<Point> boundingBox() {
    if (vertices == null) {
      throw ArgumentError("Vertices is null.");
    }

    num minX = vertices![0].x, minY = vertices![0].y;
    num maxX = vertices![0].x, maxY = vertices![0].y;

    for (Point point in vertices!) {
      minX = min(minX, point.x);
      minY = min(minY, point.y);
      maxX = max(maxX, point.x);
      maxY = max(maxY, point.y);
    }

    return [
      Point(minX, minY),
      Point(maxX, minY),
      Point(maxX, maxY),
      Point(minX, maxY)
    ];
  }

  /// Calculate the area of the polygon using the Shoelace Formula (also known as Gauss's area formula).
  ///
  /// The Shoelace Formula is a simple and efficient method for calculating the area of a polygon
  /// when its vertices are known. It is particularly well-suited for planar polygons with ordered vertices.
  ///
  /// formula:
  /// A = (1/2) * |Σ(i=1 to n-1)[(xi * yi+1) + (xn * y1)] - Σ(i=1 to n-1)[(xi+1 * yi) + (x1 * yn)]|
  ///
  /// Returns:
  /// --------
  /// double
  ///     The area of the polygon.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// List<Tuple<int, int>> vertices = [(0, 0), (2, 0), (1, 2)];
  /// Polygon polygon = Polygon(vertices: vertices);
  /// double area = polygon.shoelace();
  /// print("Area of the polygon: ${area.toStringAsFixed(6)}");
  /// ```
  double shoelace() {
    var x = vertices!.map((vertex) => vertex.x).toList();
    var y = vertices!.map((vertex) => vertex.y).toList();

    var sum1 = 0.0, sum2 = 0.0;
    for (var i = 0; i < vertices!.length - 1; i++) {
      sum1 += x[i] * y[i + 1];
      sum2 += y[i] * x[i + 1];
    }
    sum1 += x.last * y.first;
    sum2 += y.last * x.first;

    return 0.5 * (sum1 - sum2).abs();
  }

  /// Calculate the area of the polygon using Green's Theorem.
  ///
  /// Green's Theorem relates a line integral around a simple closed curve to a double integral
  /// over the plane region it encloses. In the context of a polygon, Green's Theorem can be
  /// used to compute the area by considering the vertices of the polygon.
  ///
  /// formula:
  /// A = (1/2) * |Σ(i=1 to n-1)[(xi * dyi+1) - (xi+1 * dyi)] + (xn * dy1) - (x1 * dyn)|
  ///
  /// Returns:
  /// --------
  /// double
  ///     The area of the polygon.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// List<Tuple<int, int>> vertices = [(0, 0), (2, 0), (1, 2)];
  /// Polygon polygon = Polygon(vertices: vertices);
  /// double area = polygon.greensTheorem();
  /// print("Area of the polygon: ${area.toStringAsFixed(6)}");
  /// ```
  double greensTheorem() {
    List<num> x = vertices!.map((vertex) => vertex.x).toList();
    List<num> y = vertices!.map((vertex) => vertex.y).toList();
    double area = 0.0;

    for (int i = 0; i < vertices!.length - 1; i++) {
      area += (x[i] * y[i + 1]) - (x[i + 1] * y[i]);
    }
    // the following line completes the loop by connecting the last vertex to the first
    area += (x.last * y.first) - (x.first * y.last);

    return 0.5 * area.abs();
  }

  /// Calculate the area of a triangle given its vertices.
  ///
  /// This method uses the determinant of a matrix formed by the coordinates of the triangle's vertices
  /// to compute the area. It can be used as a helper function for other area calculation methods.
  ///
  /// Parameters:
  /// -----------
  /// a, b, c : Tuple<double, double> or array-like
  ///     The coordinates (x, y) of the triangle's vertices.
  ///
  /// Returns:
  /// --------
  /// double
  ///     The area of the triangle.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// Tuple<double, double> a = Tuple<double, double>(0, 0);
  /// Tuple<double, double> b = Tuple<double, double>(2, 0);
  /// Tuple<double, double> c = Tuple<double, double>(1, 2);
  /// double area = Polygon.triangleArea(a, b, c);
  /// print("Area of the triangle: ${area.toStringAsFixed(6)}");
  /// ```
  double _triangleArea(Point a, Point b, Point c) {
    return 0.5 *
        ((a.x * (b.y - c.y)) + (b.x * (c.y - a.y)) + (c.x * (a.y - b.y))).abs();
  }

  /// Calculate the area of the polygon using triangulation.
  ///
  /// Triangulation is a technique that divides a polygon into a set of non-overlapping triangles.
  /// The area of the polygon can be computed by summing the areas of all the triangles.
  /// This method assumes the polygon is simple and non-self-intersecting.
  ///
  /// For a simple polygon, break it into triangles and sum their areas. For a triangle with
  /// vertices A(x1, y1), B(x2, y2), and C(x3, y3), the area can be computed using the cross-product method:
  /// Area = (1/2) * |(x1(y2 - y3) + x2(y3 - y1) + x3(y1 - y2))|
  ///
  /// Returns:
  /// --------
  /// double
  ///     The area of the polygon.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// List<Tuple<int, int>> vertices = [(0, 0), (2, 0), (1, 2)];
  /// Polygon polygon = Polygon(vertices: vertices);
  /// double area = polygon.triangulation();
  /// print("Area of the polygon: ${area.toStringAsFixed(6)}");
  /// ```
  double triangulation() {
    double area = 0.0;
    for (int i = 2; i < vertices!.length; i++) {
      area += _triangleArea(vertices![0], vertices![i - 1], vertices![i]);
    }
    return area;
  }

  /// Calculate the area of the polygon using the Trapezoidal Rule.
  ///
  /// The Trapezoidal Rule is a numerical integration technique that uses linear
  /// interpolation to approximate the area enclosed by the vertices of the polygon.
  /// In the context of a polygon, the Trapezoidal Rule computes the area by summing
  /// the trapezoidal areas formed by consecutive vertices and the x-axis.
  ///
  /// For a polygon with vertices (x1, y1), (x2, y2), ..., (xn, yn) sorted in counter-clockwise order,
  /// the area can be approximated as:
  /// A = (1/2) * Σ(i=1 to n-1)[(xi + xi+1) * (yi+1 - yi)] + (1/2) * (xn + x1) * (y1 - yn)
  ///
  /// Returns:
  /// --------
  /// double
  ///     The area of the polygon.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// List<Tuple<int, int>> vertices = [(0, 0), (2, 0), (1, 2)];
  /// Polygon polygon = Polygon(vertices: vertices);
  /// double area = polygon.trapezoidalRule();
  /// print("Area of the polygon: ${area.toStringAsFixed(6)}");
  /// ```
  double trapezoidal() {
    double area = 0.0;
    for (int i = 0; i < vertices!.length - 1; i++) {
      area += (vertices![i].x + vertices![i + 1].x) *
          (vertices![i + 1].y - vertices![i].y);
    }
    area += (vertices!.last.x + vertices!.first.x) *
        (vertices!.first.y - vertices!.last.y);
    return 0.5 * area.abs();
  }

  /// Calculate the area of the polygon using the Monte Carlo method.
  ///
  /// The Monte Carlo method is a statistical technique that uses random sampling to approximate
  /// the area of a polygon. This method generates a series of random points within the bounding
  /// rectangle of the polygon and calculates the ratio of points inside the polygon to the total
  /// number of points. This ratio is then used to estimate the area of the polygon.
  ///
  /// Parameters:
  /// -----------
  /// num_points : int, optional, default: 10000
  ///     The number of random points to generate for the Monte Carlo method.
  ///     Increasing the number of points can improve the accuracy of the approximation
  ///     but also increases the computation time.
  ///
  /// Returns:
  /// --------
  /// double
  ///     The approximate area of the polygon.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// List<Tuple<int, int>> vertices = [(0, 0), (2, 0), (1, 2)];
  /// Polygon polygon = Polygon(vertices: vertices);
  /// double area = polygon.monteCarlo(numPoints: 10000);
  /// print("Area of the polygon (Monte Carlo approximation): ${area.toStringAsFixed(6)}");
  /// ```
  double monteCarlo({int numPoints = 10000}) {
    var random = Random();

    var x = vertices!.map((vertex) => vertex.x).toList();
    var y = vertices!.map((vertex) => vertex.y).toList();

    var minX = x.reduce(min);
    var maxX = x.reduce(max);
    var minY = y.reduce(min);
    var maxY = y.reduce(max);

    var insidePoints = 0;
    for (var i = 0; i < numPoints; i++) {
      var randomX = minX + random.nextDouble() * (maxX - minX);
      var randomY = minY + random.nextDouble() * (maxY - minY);
      if (isPointInsidePolygon(Point(randomX, randomY))) {
        insidePoints++;
      }
    }

    var rectangleArea = (maxX - minX) * (maxY - minY);
    return (insidePoints / numPoints) * rectangleArea;
  }

  /// Approximate the definite integral of a function using Simpson's Rule.
  ///
  /// Simpson's Rule is a numerical integration technique that uses quadratic
  /// polynomials to approximate the area under the curve of a function.
  ///
  /// Parameters:
  /// -----------
  /// func : Function(double) => double
  ///     The function to be integrated. It should accept a single argument (a scalar or a NumPy array)
  ///     and return the corresponding function value(s).
  /// a : double
  ///     The lower limit of integration.
  /// b : double
  ///     The upper limit of integration.
  /// n : int
  ///     The number of subintervals to divide the integration range. Must be an even number.
  ///     A higher value of n increases the accuracy of the approximation but also increases the computation time.
  ///
  /// Returns:
  /// --------
  /// double
  ///     The approximate value of the definite integral of the function over the specified range.
  ///
  /// Raises:
  /// -------
  /// ArgumentError
  ///     If n is not an even number.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// double parabola(double x) {
  ///   return x * x;
  /// }
  ///
  /// double a = 0;
  /// double b = 2;
  /// int n = 100;
  /// double area = simpsonsRule(parabola, a, b, n);
  /// print("Approximate area under the curve y = x^2 between x = $a and x = $b: ${area.toStringAsFixed(6)}");
  /// ```
  static double simpsonsRule(
      double Function(double x) func, double a, double b, int n) {
    if (n % 2 != 0) {
      throw ArgumentError("n must be an even number.");
    }

    double h = (b - a) / n;
    List<double> x = List<double>.generate(n + 1, (i) => a + i * h);
    List<double> y = x.map(func).toList();

    double result = y[0] +
        y.last +
        4 *
            y
                .getRange(1, y.length - 1)
                .where((i) => i % 2 == 0)
                .toList()
                .sum() +
        2 * y.getRange(2, y.length - 2).where((i) => i % 2 != 0).toList().sum();
    result *= h / 3;

    return result;
  }

  /// Approximate the definite integral of a function using the Trapezoidal Rule.
  ///
  /// The Trapezoidal Rule is a numerical integration technique that uses linear
  /// interpolation to approximate the area under the curve of a function.
  ///
  /// Parameters:
  /// -----------
  /// func : Function(double) => double
  ///     The function to be integrated. It should accept a single argument (a scalar or a NumPy array)
  ///     and return the corresponding function value(s).
  /// a : double
  ///     The lower limit of integration.
  /// b : double
  ///     The upper limit of integration.
  /// n : int
  ///     The number of subintervals to divide the integration range. A higher value of n
  ///     increases the accuracy of the approximation but also increases the computation time.
  ///
  /// Returns:
  /// --------
  /// double
  ///     The approximate value of the definite integral of the function over the specified range.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// double parabola(double x) {
  ///   return x * x;
  /// }
  ///
  /// double a = 0;
  /// double b = 2;
  /// int n = 100;
  /// double area = trapezoidalRule(parabola, a, b, n);
  /// print("Approximate area under the curve y = x^2 between x = $a and x = $b: ${area.toStringAsFixed(6)}");
  /// ```
  static double trapezoidalRule(
      double Function(double x) func, double a, double b, int n) {
    double h = (b - a) / n;
    List<double> x = List<double>.generate(n + 1, (i) => a + i * h);
    List<double> y = x.map(func).toList();

    double result =
        y[0] + y.last + 2 * y.getRange(1, y.length - 1).toList().sum();
    result *= h / 2;

    return result;
  }

  /// Calculate the area of a regular polygon given the number of sides and the side length.
  ///
  /// This method uses the formula for calculating the area of a regular polygon based on its number
  /// of sides and side length. It requires that the polygon is regular, meaning all sides and angles
  /// are equal.
  ///
  /// Returns:
  /// --------
  /// double
  ///     The area of the regular polygon.
  ///
  /// Raises:
  /// -------
  /// ArgumentError
  ///     If the number of sides or side length is not provided.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// int numSides = 6;
  /// double sideLength = 2;
  /// Polygon polygon = Polygon(numSides: numSides, sideLength: sideLength);
  /// double area = polygon.areaPolygon();
  /// print("Area of the regular polygon: ${area.toStringAsFixed(6)}");
  /// ```
  double areaPolygon() {
    if (numSides == null || sideLength == null) {
      throw Exception(
          "Number of sides and side length are required for regular polygon area calculation.");
    }
    return (numSides! * pow(sideLength!, 2)) / (4 * tan(pi / numSides!));
  }

  /// Calculate the perimeter of a polygon.
  ///
  /// For regular polygons, the perimeter is the product of the number of sides and the side length.
  /// For irregular polygons, the perimeter is the sum of the side lengths.
  ///
  /// Returns:
  /// --------
  /// double
  ///     The perimeter of the polygon.
  ///
  /// Raises:
  /// -------
  /// ArgumentError
  ///     If the number of sides or side length is not provided for a regular polygon.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// List<Tuple<double, double>> vertices = [(0, 0), (2, 0), (1, 2)];
  /// Polygon polygon = Polygon(vertices: vertices);
  /// double perimeter = polygon.perimeter();
  /// print("Perimeter of the polygon: ${perimeter.toStringAsFixed(6)}");
  /// ```
  num perimeter() {
    num perimeter = 0;
    if (vertices != null) {
      for (int i = 0; i < numSides!; i++) {
        perimeter += vertices![i].distanceTo(vertices![(i + 1) % numSides!]);
      }
    } else {
      if (sides == null) {
        throw Exception(
            "Number of sides and side length are required for regular polygon perimeter calculation.");
      }
      perimeter = sides!.reduce((value, element) => value + element);
    }
    return perimeter;
  }

  /// Calculate the centroid of a polygon.
  ///
  /// The centroid is the geometric center of a polygon. It is the arithmetic mean of
  /// all the vertices' coordinates.
  ///
  /// Returns:
  /// --------
  /// Tuple<double, double>
  ///     The centroid of the polygon as a tuple of [x, y] coordinates.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// List<Tuple<double, double>> vertices = [(0, 0), (5, 0), (5, 5), (0, 5)];
  /// Polygon polygon = Polygon(vertices: vertices);
  /// Point centroid = polygon.centroid();
  /// print("Centroid of the polygon: $centroid");
  /// ```
  Point centroid() {
    var x = vertices!.map((vertex) => vertex.x).toList();
    var y = vertices!.map((vertex) => vertex.y).toList();

    var centroidX = Vector(x).sum() / numSides!;
    var centroidY = Vector(y).sum() / numSides!;

    return Point(centroidX, centroidY);
  }

  /// Calculate the moment of inertia of a polygon.
  ///
  /// The moment of inertia is a measure of the resistance of an object to rotational motion.
  /// This method calculates the moment of inertia of a polygon about an axis perpendicular
  /// to its plane and passing through its centroid. The method assumes a uniform mass
  /// distribution.
  ///
  /// Returns:
  /// --------
  /// double
  ///     The moment of inertia of the polygon.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// List<Tuple<double, double>> vertices = [(0, 0), (5, 0), (5, 5), (0, 5)];
  /// Polygon polygon = Polygon(vertices: vertices);
  /// double momentOfInertia = polygon.momentOfInertia();
  /// print("Moment of Inertia of the polygon: ${momentOfInertia.toStringAsFixed(2)}");
  /// ```
  num momentOfInertia() {
    var I = 0.0;
    for (var i = 0; i < numSides!; i++) {
      var pi = vertices![i];
      var pj = vertices![(i + 1) % numSides!];
      I += ((pow(pi.x, 2) + pi.x * pj.x + pow(pj.x, 2)) *
              (pi.y * pj.x - pi.x * pj.y)) /
          12;
    }

    return abs(I);
  }

  double sideLengthIrregular(int i) {
    if (vertices == null || numSides == null) {
      throw ArgumentError("Vertices or number of sides is null.");
    }

    int j = (i + 1) % numSides!;
    return vertices![i].distanceTo(vertices![j]);
  }

  /// Calculate the side length of a regular polygon given at least one of the parameters
  /// (perimeter, area, circumradius, inradius).
  ///
  /// Parameters:
  /// -----------
  /// perimeter: double, optional
  ///     The perimeter of the regular polygon.
  /// area: double, optional
  ///     The area of the regular polygon.
  /// circumradius: double, optional
  ///     The radius of the circumscribed circle (circle that passes through all vertices).
  /// inradius: double, optional
  ///     The radius of the inscribed circle (circle tangent to all sides).
  ///
  /// Returns:
  /// --------
  /// double
  ///     The side length of the regular polygon.
  ///
  /// Raises:
  /// -------
  /// ArgumentError
  ///     If none of the parameters (perimeter, area, circumradius, inradius) are provided.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// int numSides = 6;
  /// Polygon polygon = Polygon(numSides: numSides);
  /// double sideLength = polygon.getSideLength(circumradius: 5);
  /// print("Side length of the regular polygon: ${sideLength.toStringAsFixed(2)}");
  /// ```
  double getSideLength(
      {num? perimeter, num? area, num? circumradius, num? inradius}) {
    if (numSides == null) {
      throw ArgumentError("Number of sides is null.");
    }

    if (perimeter != null) {
      sideLength = perimeter / numSides!;
    } else if (area != null) {
      sideLength = sqrt((4 * area) / (numSides! * (1 / tan(pi / numSides!))));
    } else if (circumradius != null) {
      sideLength = 2 * circumradius * sin(pi / numSides!) as double;
    } else if (inradius != null) {
      sideLength = 2 * inradius * tan(pi / numSides!) as double;
    } else {
      throw ArgumentError(
          "At least one of the parameters (perimeter, area, circumradius, inradius) must be provided.");
    }

    // Update the sides attribute
    sides = List.filled(numSides!, sideLength!);

    return sideLength!;
  }

  /// Get the length of an irregular side of the polygon.
  ///
  /// Parameters:
  /// -----------
  /// i : int
  ///     The index of the side.
  ///
  /// Returns:
  /// --------
  /// double
  ///     The length of the specified side.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// int i = ... // Specify the index of the side
  /// double sideLength = polygon.sideLengthIrregular(i);
  /// ```
  num sideLengthOfIrregular(int i) {
    if (vertices == null || numSides == null) {
      throw ArgumentError("Vertices or number of sides is null.");
    }

    int j = (i + 1) % numSides!;
    return (vertices![i] - vertices![j]).magnitude;
  }

  @override
  String toString() {
    return 'Polygon( \nnum_sides=$numSides,\nside_length=$sideLength,\nvertices=$vertices)';
  }
}

class RegularPolygon extends Polygon {
  RegularPolygon(
      {List<Point>? vertices, required int numSides, double? sideLength})
      : super(vertices: vertices, numSides: numSides, sideLength: sideLength) {
    if (vertices != null && vertices.length != numSides) {
      throw ArgumentError("Vertices or number of sides must be equal.");
    }
    sides = List.generate(numSides, (index) => sideLength!);
  }

  /// Calculate the interior angle of a regular polygon.
  ///
  /// This method uses the formula for calculating the interior angle of a regular polygon
  /// based on its number of sides. It requires that the polygon is regular, meaning all
  /// sides and angles are equal.
  ///
  /// Returns:
  /// --------
  /// double
  ///     The interior angle of the regular polygon in degrees.
  ///
  /// Raises:
  /// -------
  /// ArgumentError
  ///     If the number of sides is not provided.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// int numSides = 6;
  /// Polygon polygon = Polygon(numSides: numSides);
  /// double interiorAngle = polygon.interiorAngle();
  /// print("Interior angle of the regular polygon: ${interiorAngle.toStringAsFixed(2)}°");
  /// ```
  double interiorAngle() {
    if (numSides == null) {
      throw Exception(
          "Number of sides is required for regular polygon interior angle calculation.");
    }
    return (numSides! - 2) * 180 / numSides!;
  }

  /// Calculate the exterior angle of a regular polygon.
  ///
  /// This method uses the formula for calculating the exterior angle of a regular polygon
  /// based on its number of sides. It requires that the polygon is regular, meaning all
  /// sides and angles are equal.
  ///
  /// Returns:
  /// --------
  /// double
  ///     The exterior angle of the regular polygon in degrees.
  ///
  /// Raises:
  /// -------
  /// ArgumentError
  ///     If the number of sides is not provided.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// int numSides = 6;
  /// Polygon polygon = Polygon(numSides: numSides);
  /// double exteriorAngle = polygon.exteriorAngle();
  /// print("Exterior angle of the regular polygon: ${exteriorAngle.toStringAsFixed(2)}°");
  /// ```
  double exteriorAngle() {
    if (numSides == null) {
      throw Exception(
          "Number of sides is required for regular polygon exterior angle calculation.");
    }
    return 360 / numSides!;
  }

  /// Calculate the inradius of a regular polygon.
  ///
  /// This method uses the formula for calculating the inradius (radius of the inscribed circle)
  /// of a regular polygon based on its number of sides and side length. It requires that the
  /// polygon is regular, meaning all sides and angles are equal.
  ///
  /// Returns:
  /// --------
  /// double
  ///     The inradius of the regular polygon.
  ///
  /// Raises:
  /// -------
  /// ArgumentError
  ///     If the number of sides and side length are not provided.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// int numSides = 6;
  /// double sideLength = 5;
  /// Polygon polygon = Polygon(numSides: numSides, sideLength: sideLength);
  /// double inradius = polygon.inradius();
  /// print("Inradius of the regular polygon: ${inradius.toStringAsFixed(2)}");
  /// ```
  double inradius() {
    if (sides == null) {
      throw Exception(
          "Number of sides and side length are required for regular polygon inradius calculation.");
    }
    return sideLength! / (2 * tan(pi / numSides!));
  }

  /// Calculate the circumradius of a regular polygon.
  ///
  /// This method uses the formula for calculating the circumradius (radius of the circumscribed circle)
  /// of a regular polygon based on its number of sides and side length. It requires that the
  /// polygon is regular, meaning all sides and angles are equal.
  ///
  /// Returns:
  /// --------
  /// double
  ///     The circumradius of the regular polygon.
  ///
  /// Raises:
  /// -------
  /// ArgumentError
  ///     If the number of sides and side length are not provided.
  ///
  /// Example:
  /// --------
  /// ```dart
  /// int numSides = 6;
  /// double sideLength = 5;
  /// Polygon polygon = Polygon(numSides: numSides, sideLength: sideLength);
  /// double circumradius = polygon.circumradius();
  /// print("Circumradius of the regular polygon: ${circumradius.toStringAsFixed(2)}");
  /// ```
  double circumradius() {
    if (sides == null) {
      throw Exception(
          "Number of sides and side length are required for regular polygon circumradius calculation.");
    }
    return sideLength! / (2 * sin(pi / numSides!));
  }
}

class IrregularPolygon extends Polygon {
  IrregularPolygon({List<Point>? vertices}) : super(vertices: vertices);

  // irregular polygon specific methods go here...
  // the above class does not include any irregular polygon specific methods,
  // but if there are any, they should be added here.
}
