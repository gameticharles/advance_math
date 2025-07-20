part of '../../geometry.dart';

/// Represents a Circle in a 2D space.
///
/// A Circle is defined by its center [Point] and a [radius].
///
/// Example:
/// ```dart
/// var center = Point(0, 0);
/// var circle = Circle(center:center, 5);
/// print(circle.area()); // Expected output: 78.53981633974483
/// print(circle.circumference); // Expected output: 31.41592653589793
/// print(circle.isPointInside(Point(3, 4))); // Expected output: true
/// ```
class Circle extends PlaneGeometry {
  /// Center [Point] of the Circle.
  Point center;

  /// Radius of the Circle.
  num radius;

  /// Central Angle of the Circle in radians.
  Angle? centralAngle;

  /// Constructs a Circle with a [center] Point and a [radius].
  /// Primary constructor for the Circle class.
  ///
  /// Requires a radius and optionally a center point.
  Circle(this.radius, {Point? center})
      : center = center ?? Point(0, 0),
        super("Circle");

  /// Named constructor to create a Circle from various parameters.
  ///
  /// You can specify exactly one of the following parameters:
  /// - radius: Radius of the circle.
  /// - diameter: Diameter of the circle.
  /// - area: Area of the circle.
  /// - perimeter: Perimeter (circumference) of the circle.
  /// - distanceFromCenterToChord: Distance from the center to the chord.
  /// - areaOfSegment: Area of the segment.
  /// - chordLength: Length of the chord.
  /// - areaOfSector: Area of the sector.
  /// - arcLength: Length of the arc.
  /// - centralAngle: Central angle in radians.
  ///
  /// If multiple parameters are provided, precedence is given to `radius`,
  /// then to the first valid parameter in the order specified above.
  Circle.from({
    num? radius,
    num? diameter,
    num? area,
    num? perimeter,
    num? distanceFromCenterToChord,
    num? areaOfSegment,
    num? chordLength,
    num? areaOfSector,
    num? arcLength,
    Angle? centralAngle,
    Point? center,
  })  : radius = radius ??
            getRadiusFromPart(
              diameter: diameter,
              area: area,
              perimeter: perimeter,
            ) ??
            getRadiusFromSection(
              distanceFromCenterToChord: distanceFromCenterToChord,
              areaOfSegment: areaOfSegment,
              chordLength: chordLength,
              areaOfSector: areaOfSector,
              arcLength: arcLength,
              centralAngle: centralAngle,
            ),
        center = center ?? Point(0, 0),
        super("Circle") {
    this.centralAngle = centralAngle ??
        getCentralAngle(
          this.radius,
          distanceFromCenterToChord: distanceFromCenterToChord,
          areaOfSegment: areaOfSegment,
          chordLength: chordLength,
          areaOfSector: areaOfSector,
          arcLength: arcLength,
        );
  }

  /// Returns a string representation of the Circle.
  @override
  String toString() {
    return 'Circle(center: $center, radius: $radius)';
  }

  /// Calculates and returns the area of the Circle.
  @override
  double area() {
    return pi * radius * radius;
  }

  /// Calculates and returns the circumference of the Circle.
  double get circumference => 2 * pi * radius;

  /// Gets the perimeter (circumference) of the circle.
  @override
  double perimeter() => circumference;

  /// Gets the diameter of the circle.
  double get diameter => radius * 2;

  /// Calculates the length of an arc given a central angle.
  double get arcLength => radius.toDouble() * centralAngle!.rad;

  /// Calculates the area of a sector given a central angle.
  double get sectorArea => 0.5 * radius * radius * centralAngle!.rad;

  /// Calculates the length of a chord given a central angle in radians.
  double get chordLength {
    return 2.0 * radius * sin(centralAngle!.rad / 2);
  }

  /// Calculates the area of a segment given a central angle in radians.
  double get segmentArea {
    double triangleArea = 0.5 * radius * radius * centralAngle!.sin();
    return sectorArea - triangleArea;
  }

  /// Calculates the distance from the center to the chord given a central angle in radians.
  double get distanceFromCenterToChord =>
      radius.toDouble() * cos(centralAngle!.rad / 2);

  /// Calculates the central angle (in radians) given various parameters.
  ///
  /// Specify exactly one of the following parameters:
  /// - distanceFromCenterToChord: Distance from the center to the chord.
  /// - areaOfSegment: Area of the segment.
  /// - chordLength: Length of the chord.
  /// - areaOfSector: Area of the sector.
  /// - arcLength: Length of the arc.
  ///
  /// Returns the central angle in radians.
  static Angle? getCentralAngle(
    num radius, {
    num? distanceFromCenterToChord,
    num? areaOfSegment,
    num? chordLength,
    num? areaOfSector,
    num? arcLength,
  }) {
    num phi = 0.0;

    if (distanceFromCenterToChord != null) {
      phi = 2 * acos(distanceFromCenterToChord / radius);
    } else if (areaOfSegment != null) {
      num theta = 2 * acos(1 - (areaOfSegment / radius) / radius);
      phi = theta;
    } else if (chordLength != null) {
      phi = 2 * asin(chordLength / (2 * radius));
    } else if (areaOfSector != null) {
      phi = (2 * areaOfSector) / (radius * radius);
    } else if (arcLength != null) {
      phi = arcLength / radius;
    } else {
      // throw ArgumentError('Exactly one parameter must be provided.');
      return null;
    }

    return Angle(deg: phi);
  }

  /// Calculates the radius of a circle given a section parameter.
  ///
  /// Specify exactly one of the following parameters:
  /// - distanceFromCenterToChord: Distance from the center to the chord.
  /// - areaOfSegment: Area of the segment.
  /// - chordLength: Length of the chord.
  /// - areaOfSector: Area of the sector.
  /// - arcLength: Length of the arc.
  /// - centralAngle: Central angle.
  ///
  /// Returns the radius of the circle.
  static num getRadiusFromSection({
    num? distanceFromCenterToChord,
    num? areaOfSegment,
    num? chordLength,
    num? areaOfSector,
    num? arcLength,
    Angle? centralAngle,
  }) {
    if (distanceFromCenterToChord != null && centralAngle != null) {
      return distanceFromCenterToChord / acos(centralAngle / 2);
    } else if (areaOfSegment != null && centralAngle != null) {
      return sqrt(2 * areaOfSegment / centralAngle.rad);
    } else if (chordLength != null && centralAngle != null) {
      return chordLength / (2 * sin(centralAngle / 2));
    } else if (areaOfSector != null && centralAngle != null) {
      return sqrt(areaOfSector / (0.5 * centralAngle.rad));
    } else if (arcLength != null && centralAngle != null) {
      return arcLength / centralAngle.rad;
    } else {
      throw ArgumentError(
          'Exactly one parameter must be provided along with centralAngle.');
    }
  }

  /// Calculates the radius of a circle given a part parameter.
  ///
  /// Specify exactly one of the following parameters:
  /// - diameter: Diameter of the circle.
  /// - area: Area of the circle.
  /// - perimeter: Perimeter (circumference) of the circle.
  ///
  /// Returns the radius of the circle.
  static num? getRadiusFromPart({
    num? diameter,
    num? area,
    num? perimeter,
  }) {
    if (diameter != null) {
      return diameter / 2;
    } else if (area != null) {
      return sqrt(area / pi);
    } else if (perimeter != null) {
      return perimeter / (2 * pi);
    } else {
      return null;
      // throw ArgumentError('Exactly one parameter must be provided.');
    }
  }

  /// Checks if a [point] lies inside the Circle.
  bool isPointInside(Point point) {
    return center.distanceTo(point) <= radius;
  }

  /// Scales the Circle by a [factor].
  void scale(double factor) {
    radius *= factor;
  }

  /// Moves the Circle by [dx] and [dy].
  void move(double dx, double dy) {
    center.translate(dx, dy);
  }

  /// Calculates the arc length between [point1] and [point2].
  /// Direction of arc is determined by [direction] which can be 'ccw' for counter clockwise or 'cw' for clockwise.
  double arcLengthBetween(Point point1, Point point2,
      {String direction = 'ccw'}) {
    if (!isPointInside(point1) || !isPointInside(point2)) {
      throw ArgumentError("Both points must lie on the circle.");
    }
    var angle1 = atan2(point1.y - center.y, point1.x - center.x);
    var angle2 = atan2(point2.y - center.y, point2.x - center.x);
    var arcAngle = 0.0;
    if (direction == 'ccw') {
      if (angle2 <= angle1) {
        angle2 += 2 * pi;
      }
      arcAngle = angle2 - angle1;
    } else if (direction == 'cw') {
      if (angle1 <= angle2) {
        angle1 += 2 * pi;
      }
      arcAngle = angle1 - angle2;
    } else {
      throw ArgumentError("Direction must be either 'ccw' or 'cw'.");
    }
    return radius * arcAngle;
  }

  /// Returns a List of tangent Lines from a [point] outside the Circle.
  List<Line> tangentLines(Point point) {
    if (isPointInside(point)) {
      throw ArgumentError("The point must be outside the circle.");
    }
    var pointToCenter = point - center;
    var distance = Line(p1: point, p2: center).length();
    var angle = acos(radius / distance);
    var lineAngle = atan2(pointToCenter.y, pointToCenter.x);
    var angle1 = lineAngle - angle;
    var angle2 = lineAngle + angle;

    Point endpoint1 = Point(
        point.x + distance * cos(angle1), point.y + distance * sin(angle1));
    Point endpoint2 = Point(
        point.x + distance * cos(angle2), point.y + distance * sin(angle2));

    return [Line(p1: point, p2: endpoint1), Line(p1: point, p2: endpoint2)];
  }

  /// Returns a List of Circles that are tangent to this Circle and a [pointOnCircle] with a given [radius].
  List<Circle> tangentCircles(double radius, Point pointOnCircle) {
    if (!isPointInside(pointOnCircle)) {
      throw ArgumentError("The point must be on the circle.");
    }
    var midpoint = center.midpointTo(pointOnCircle);
    var circle = Circle(radius, center: midpoint);
    var tangentLines = circle.tangentLines(center);

    var tangentCircles = <Circle>[];
    for (var line in tangentLines) {
      var pointOnLine = line.pointAtDistance(circle.center, radius);
      tangentCircles.add(Circle(radius, center: pointOnLine));
    }
    return tangentCircles;
  }

  /// Calculates the area of the sector formed by [point1] and [point2] on the Circle.
  double areaOfSectorBetween(Point point1, Point point2,
      {String direction = 'ccw'}) {
    var arcLen = arcLengthBetween(point1, point2, direction: direction);
    var angle = arcLen / radius;
    return 0.5 * pow(radius, 2) * (angle - sin(angle));
  }

  /// Checks if this Circle intersects with [otherCircle].
  bool isIntersecting(Circle otherCircle) {
    return center.distanceTo(otherCircle.center) <=
        (radius + otherCircle.radius);
  }

  /// Returns a List of intersection points with [otherCircle].
  List<Point?> intersectionPoints(Circle otherCircle) {
    if (!isIntersecting(otherCircle)) {
      return [null, null];
    }

    var d = center.distanceTo(otherCircle.center);
    var a = (pow(radius, 2) - pow(otherCircle.radius, 2) + pow(d, 2)) / (2 * d);
    var h = sqrt(pow(radius, 2) - pow(a, 2));

    var centerToOther = otherCircle.center - center;
    var p = center + centerToOther.scale(a / d);

    var rotatedCenterToOther = centerToOther.rotate(angle90);
    var p1 = p + rotatedCenterToOther.scale(h / d);
    var p2 = p - rotatedCenterToOther.scale(h / d);

    return [p1, p2];
  }

  /// Calculates the intersecting area with [otherCircle].
  double intersectingArea(Circle otherCircle) {
    if (otherCircle.runtimeType != Circle) {
      throw ArgumentError("The argument must be a Circle object.");
    }

    var d = center.distanceTo(otherCircle.center);
    if (d >= radius + otherCircle.radius) {
      return 0.0;
    }
    if (d <= (radius - otherCircle.radius).abs()) {
      return min(area(), otherCircle.area()).toDouble();
    }

    var r1 = radius;
    var r2 = otherCircle.radius;
    var alpha = 2 * acos((pow(r1, 2) + pow(d, 2) - pow(r2, 2)) / (2 * r1 * d));
    var beta = 2 * acos((pow(r2, 2) + pow(d, 2) - pow(r1, 2)) / (2 * r2 * d));
    var sectorArea1 = 0.5 * pow(r1, 2) * (alpha - sin(alpha));
    var sectorArea2 = 0.5 * pow(r2, 2) * (beta - sin(beta));
    return sectorArea1 + sectorArea2;
  }

  /// Returns a List of common tangent Lines with [otherCircle].
  List<Line> commonTangents(Circle otherCircle) {
    var d = center.distanceTo(otherCircle.center);
    if (d == 0) {
      return [];
    }

    var r1 = radius, r2 = otherCircle.radius;
    var a = (r1 - r2) / d;
    var b = sqrt(1 - pow(a, 2));
    var p = (otherCircle.center - center) * a + center;
    var directions = [
      [b, -a],
      [-b, a]
    ];

    List<Line> result = [];
    for (var i = 0; i < directions.length; i++) {
      var dx = directions[i][0];
      var dy = directions[i][1];
      var line = Line(
          p1: Point(p.x + dx * r1, p.y + dy * r1),
          p2: Point(p.x + dx * r2, p.y + dy * r2));
      result.add(line);
    }

    return result;
  }

  /// Constructs a Circle from a List of boundary [Point]s.
  static Circle fromBoundaryPoints(List<Point> boundaryPoints) {
    if (boundaryPoints.isEmpty) {
      return Circle(center: Point(0, 0), 0);
    } else if (boundaryPoints.length == 1) {
      return Circle(center: boundaryPoints[0], 0);
    } else if (boundaryPoints.length == 2) {
      var center = boundaryPoints[0].midpointTo(boundaryPoints[1]);
      var radius = boundaryPoints[0].distanceTo(center);
      return Circle(center: center, radius);
    } else {
      // length == 3
      var p1 = boundaryPoints[0];
      var p2 = boundaryPoints[1];
      var p3 = boundaryPoints[2];

      // Circumcenter formula
      var D = 2 *
          (p1.x * (p2.y - p3.y) + p2.x * (p3.y - p1.y) + p3.x * (p1.y - p2.y));
      var ux = (pow(p1.x, 2) +
              pow(p1.y, 2) * (p2.y - p3.y) +
              pow(p2.x, 2) +
              pow(p2.y, 2) * (p3.y - p1.y) +
              pow(p3.x, 2) +
              pow(p3.y, 2) * (p1.y - p2.y)) /
          D;
      var uy = (pow(p1.x, 2) +
              pow(p1.y, 2) * (p3.x - p2.x) +
              pow(p2.x, 2) +
              pow(p2.y, 2) * (p1.x - p3.x) +
              pow(p3.x, 2) +
              pow(p3.y, 2) * (p2.x - p1.x)) /
          D;
      var center = Point(ux, uy);
      var radius = p1.distanceTo(center);

      return Circle(center: center, radius);
    }
  }

  static Circle _welzlAlgorithm(
      List<Point> points, List<Point> boundaryPoints) {
    if (boundaryPoints.length == 3 || points.isEmpty) {
      return Circle.fromBoundaryPoints(boundaryPoints);
    }

    var index = Random().nextInt(points.length);
    var point = points[index];
    points.removeAt(index);
    var circle = _welzlAlgorithm(points, boundaryPoints);

    if (!circle.isPointInside(point)) {
      boundaryPoints.add(point);
      circle = _welzlAlgorithm(points, boundaryPoints);
      boundaryPoints.removeLast();
    }

    points.add(point);
    return circle;
  }

  /// Encloses a given List of [points] with a Circle.
  static Circle enclosingCircle(List<List<double>> points) {
    var pList = points.map((p) => Point(p[0], p[1])).toList();
    pList.shuffle();
    return _welzlAlgorithm(pList, []);
  }
}
