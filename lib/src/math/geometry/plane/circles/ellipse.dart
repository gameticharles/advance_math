part of '../../geometry.dart';

/// A class representing an ellipse in 2D space.
class Ellipse extends PlaneGeometry {
  double semiMajorAxis;
  double semiMinorAxis;
  Point center;

  /// Constructs an Ellipse with a given semi-major axis, semi-minor axis, and optionally a center point.
  ///
  /// Requires semi-major and semi-minor axes, and optionally a center point.
  Ellipse(this.semiMajorAxis, this.semiMinorAxis, {Point? center})
      : center = center ?? Point(0, 0),
        super("Ellipse");

  /// Named constructor to create an Ellipse from various parameters.
  ///
  /// You can specify exactly one of the following sets of parameters:
  /// - semiMajorAxis and semiMinorAxis
  /// - radiusX and radiusY
  /// - area
  /// - perimeter
  /// - focusDistance and sumOfDistances
  factory Ellipse.from({
    double? semiMajorAxis,
    double? semiMinorAxis,
    double? radiusX,
    double? radiusY,
    double? area,
    double? perimeter,
    double? focusDistance,
    double? sumOfDistances,
    Point? center,
  }) {
    double a = 0;
    double b = 0;

    if (semiMajorAxis != null && semiMinorAxis != null) {
      a = semiMajorAxis;
      b = semiMinorAxis;
    } else if (radiusX != null && radiusY != null) {
      a = radiusX > radiusY ? radiusX : radiusY;
      b = radiusX < radiusY ? radiusX : radiusY;
    } else if (focusDistance != null && sumOfDistances != null) {
      a = sumOfDistances / 2.0;
      double c = focusDistance;
      if (a < c) {
        throw ArgumentError('Sum of distances (2a) must be greater than twice the focal distance (2c).');
      }
      b = dmath.sqrt(a * a - c * c);
    } else if (area != null) {
      if (semiMajorAxis != null) {
        a = semiMajorAxis;
        b = area / (pi * a);
      } else if (semiMinorAxis != null) {
        b = semiMinorAxis;
        a = area / (pi * b);
      } else {
        // Assume circle
        a = dmath.sqrt(area / pi);
        b = a;
      }
    } else if (perimeter != null) {
      if (semiMajorAxis != null) {
        a = semiMajorAxis;
        // Ramanujan approximation: P ≈ pi * (a + b) * (1 + 3h / (10 + sqrt(4 - 3h)))
        // We can solve for b numerically. Since b <= a, we search in [0, a].
        double low = 0;
        double high = a;
        for (int i = 0; i < 100; i++) {
          double mid = (low + high) / 2;
          double h = ((a - mid) * (a - mid)) / ((a + mid) * (a + mid));
          double pApprox = pi * (a + mid) * (1 + (3 * h) / (10 + dmath.sqrt(4 - 3 * h)));
          if (pApprox < perimeter) {
            low = mid;
          } else {
            high = mid;
          }
        }
        b = (low + high) / 2;
      } else if (semiMinorAxis != null) {
        b = semiMinorAxis;
        // We can solve for a numerically. Since a >= b, search in [b, b * 1e5] (generous upper bound).
        double low = b;
        double high = b * 100000;
        for (int i = 0; i < 100; i++) {
          double mid = (low + high) / 2;
          double h = ((mid - b) * (mid - b)) / ((mid + b) * (mid + b));
          double pApprox = pi * (mid + b) * (1 + (3 * h) / (10 + dmath.sqrt(4 - 3 * h)));
          if (pApprox < perimeter) {
            low = mid;
          } else {
            high = mid;
          }
        }
        a = (low + high) / 2;
      } else {
        // Assume circle
        a = perimeter / (2 * pi);
        b = a;
      }
    } else {
      throw ArgumentError('Not enough information provided to define an Ellipse.');
    }

    return Ellipse(a, b, center: center);
  }

  @override
  double area() {
    return pi * semiMajorAxis * semiMinorAxis;
  }

  @override
  double perimeter() {
    // Approximate perimeter using Ramanujan's formula for ellipse perimeter approximation
    double h =
        ((semiMajorAxis - semiMinorAxis) * (semiMajorAxis - semiMinorAxis)) /
            ((semiMajorAxis + semiMinorAxis) * (semiMajorAxis + semiMinorAxis));
    return pi *
        (semiMajorAxis + semiMinorAxis) *
        (1 + (3 * h) / (10 + dmath.sqrt(4 - 3 * h)));
  }

  /// Calculates the linear eccentricity (focal distance) of the ellipse.
  ///
  /// The distance from the center of the ellipse to either of the two foci.
  /// This value is calculated as the square root of the difference between the
  /// squares of the semi-major axis and semi-minor axis.
  double focalDistance() {
    return dmath.sqrt(semiMajorAxis * semiMajorAxis - semiMinorAxis * semiMinorAxis);
  }

  /// Calculates the distance between the two foci of the ellipse.
  ///
  /// The distance between the two fixed points inside the ellipse.
  /// This value is calculated as twice the focal distance.
  double distanceBetweenFoci() {
    return 2 * focalDistance();
  }

  /// Calculates the foci of the ellipse.
  /// The two fixed points inside the ellipse.
  ///
  /// The distance from the coordinate center on the major-axis—both
  /// directions—to the elliptical focal points.
  ///
  /// Use the foci distance plus the pin and string method to draw an
  /// ellipse on paper or on a job site.
  List<Point> foci() {
    var c = focalDistance();
    return [Point(center.x - c, center.y), Point(center.x + c, center.y)];
  }

  /// Returns the first and second vertexes as points along the major axis.
  ///
  /// The first is the point (h-a, k) while
  /// the second (h+a, k) along the major axis.
  ///
  /// The vertexes is the point where the ellipse intersects the x-axis.
  List<Point> vertexes() {
    return [
      Point(center.x - semiMajorAxis, center.y),
      Point(center.x + semiMajorAxis, center.y)
    ];
  }

  /// Returns the first and second co-vertex along the minor axis.
  ///
  /// The first is the point (h, k-b) while
  /// the second (h, k+b) along the minor axis.
  ///
  /// The co-vertexes is the point where the ellipse intersects the y-axis.
  List<Point> coVertexes() {
    return [
      Point(center.x, center.y - semiMinorAxis),
      Point(center.x, center.y + semiMinorAxis)
    ];
  }

  /// Calculates the eccentricity of the ellipse.
  ///
  /// A measure of how much the ellipse deviates from being a circle.
  double eccentricity() {
    return dmath.sqrt(
        1 - (semiMinorAxis * semiMinorAxis) / (semiMajorAxis * semiMajorAxis));
  }

  /// Calculates the directrices of the ellipse.
  ///
  /// A line such that the ratio of the distance of any point
  /// on the ellipse to the focus and the distance to the
  /// directrix is constant.
  List<double> directrices() {
    double e = eccentricity();
    return [center.x - semiMajorAxis / e, center.x + semiMajorAxis / e];
  }

  /// Calculates the latus rectum of the ellipse.
  ///
  /// A chord of the ellipse passing through a focus
  /// and perpendicular to the major axis.
  double latusRectum() {
    return 2 * (semiMinorAxis * semiMinorAxis) / semiMajorAxis;
  }

  /// Returns the latus rectum endpoints.
  ///
  /// The latus rectum is a chord of the ellipse passing
  /// through a focus and perpendicular to the major axis.
  ///
  /// This method returns the four endpoints of the latus rectum.
  List<Point> latusRectumPoints() {
    double c = focalDistance();
    return [
      Point(center.x - c, center.y - latusRectum() / 2),
      Point(center.x - c, center.y + latusRectum() / 2),
      Point(center.x + c, center.y - latusRectum() / 2),
      Point(center.x + c, center.y + latusRectum() / 2)
    ];
  }

  /// Returns the domain of the ellipse.
  ///
  /// The domain of the ellipse is is represented as a
  /// `Domain` (center.x - semiMajorAxis, center.x + semiMajorAxis)
  /// with minX and maxX coordinates..
  Domain domain() {
    return Domain(center.x - semiMajorAxis, center.y + semiMinorAxis);
  }

  /// Returns the range of the ellipse along the minor axis.
  ///
  /// The range is the point (center.y - semiMinorAxis, center.y + semiMinorAxis).
  Range range() {
    return Range(center.y - semiMinorAxis, center.y + semiMinorAxis);
  }

  /// Calculates the distance from a point to the ellipse.
  ///
  /// The shortest distance from a given point to the ellipse.
  double distanceFromPoint(Point p) {
    num x0 = p.x - center.x;
    num y0 = p.y - center.y;
    double distance = dmath.sqrt((x0 * x0) / (semiMajorAxis * semiMajorAxis) +
        (y0 * y0) / (semiMinorAxis * semiMinorAxis));
    return distance - 1;
  }

  /// Calculates the arc length of the ellipse from angle theta1 to angle theta2.
  ///
  /// The length of a segment of the ellipse's perimeter.
  ///
  /// [n] is the number of intervals for numerical integration.
  /// [method] is the numerical integration method ('simpson' or 'trapezoidal').
  double arcLength(double theta1, double theta2,
      {int n = 1000, String method = 'simpson'}) {
    double h = (theta2 - theta1) / n;
    double sum = 0.0;

    switch (method) {
      case 'simpson':
        // Simpson's rule for numerical integration
        for (int i = 0; i <= n; i++) {
          double theta = theta1 + i * h;
          double r = dmath.sqrt(
              (semiMajorAxis * semiMajorAxis) * dmath.cos(theta) * dmath.cos(theta) +
                  (semiMinorAxis * semiMinorAxis) * dmath.sin(theta) * dmath.sin(theta));
          sum += i % 2 == 0 ? 2 * r : 4 * r;
        }
        sum -=
            (dmath.sqrt((semiMajorAxis * semiMajorAxis) * dmath.cos(theta1) * dmath.cos(theta1) +
                        (semiMinorAxis * semiMinorAxis) *
                            dmath.sin(theta1) *
                            dmath.sin(theta1)) +
                    dmath.sqrt((semiMajorAxis * semiMajorAxis) *
                            dmath.cos(theta2) *
                            dmath.cos(theta2) +
                        (semiMinorAxis * semiMinorAxis) *
                            dmath.sin(theta2) *
                            dmath.sin(theta2))) /
                2;
        return sum * h / 3;
      case 'trapezoidal':
        // Trapezoidal rule for numerical integration
        for (int i = 1; i < n; i++) {
          double theta = theta1 + i * h;
          double r = dmath.sqrt(
              (semiMajorAxis * semiMajorAxis) * dmath.cos(theta) * dmath.cos(theta) +
                  (semiMinorAxis * semiMinorAxis) * dmath.sin(theta) * dmath.sin(theta));
          sum += 2 * r;
        }
        sum += dmath.sqrt((semiMajorAxis * semiMajorAxis) *
                    dmath.cos(theta1) *
                    dmath.cos(theta1) +
                (semiMinorAxis * semiMinorAxis) * dmath.sin(theta1) * dmath.sin(theta1)) +
            dmath.sqrt((semiMajorAxis * semiMajorAxis) * dmath.cos(theta2) * dmath.cos(theta2) +
                (semiMinorAxis * semiMinorAxis) * dmath.sin(theta2) * dmath.sin(theta2));
        return sum * h / 2;
      default:
        throw ArgumentError('Unsupported integration method: $method');
    }
  }

  /// Calculates the curvature at a given angle [theta] on the ellipse.
  double curvature(double theta) {
    double a = semiMajorAxis;
    double b = semiMinorAxis;
    return (a * b) /
        dmath.pow((b * b * dmath.cos(theta) * dmath.cos(theta) + a * a * dmath.sin(theta) * dmath.sin(theta)),
            1.5);
  }

  /// Returns the standard equation of the ellipse as a string.
  ///
  /// '((x - $h)^2 / $a^2) + ((y - $k)^2 / $b^2) = 1'
  /// where (h,k) is the center, `a` and `b` are the lengths of the semi-major and the semi-minor axes.
  String equation() {
    num h = center.x;
    num k = center.y;
    double a = semiMajorAxis;
    double b = semiMinorAxis;
    return '((x - $h)^2 / $a^2) + ((y - $k)^2 / $b^2) = 1';
  }

  @override
  String toString() {
    return 'Ellipse(semiMajorAxis: $semiMajorAxis, semiMinorAxis: $semiMinorAxis, center: $center)';
  }
}
