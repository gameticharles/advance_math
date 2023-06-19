part of geometry;

class Circle {
  Point center;
  double radius;

  Circle(this.center, this.radius);

  @override
  String toString() {
    return 'Circle(center: $center, radius: $radius)';
  }

  num area() {
    return pi * pow(radius, 2);
  }

  double circumference() {
    return 2 * pi * radius;
  }

  bool isPointInside(Point point) {
    return center.distanceTo(point) <= radius;
  }

  void scale(double factor) {
    radius *= factor;
  }

  void move(double dx, double dy) {
    center.translate(dx, dy);
  }

  double arcLength(Point point1, Point point2, {String direction = 'ccw'}) {
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

  List<Line> tangentLines(Point point) {
    if (isPointInside(point)) {
      throw ArgumentError("The point must be outside the circle.");
    }
    var pointToCenter = point - center;
    var distance = Line(point, center).length();
    var angle = acos(radius / distance);
    var lineAngle = atan2(pointToCenter.y, pointToCenter.x);
    var angle1 = lineAngle - angle;
    var angle2 = lineAngle + angle;

    Point endpoint1 = Point(
        point.x + distance * cos(angle1), point.y + distance * sin(angle1));
    Point endpoint2 = Point(
        point.x + distance * cos(angle2), point.y + distance * sin(angle2));

    return [Line(point, endpoint1), Line(point, endpoint2)];
  }

  List<Circle> tangentCircles(double radius, Point pointOnCircle) {
    if (!isPointInside(pointOnCircle)) {
      throw ArgumentError("The point must be on the circle.");
    }
    var midpoint = center.midpointTo(pointOnCircle);
    var circle = Circle(midpoint, radius);
    var tangentLines = circle.tangentLines(center);

    var tangentCircles = <Circle>[];
    for (var line in tangentLines) {
      var pointOnLine = line.pointAtDistance(circle.center, radius);
      tangentCircles.add(Circle(pointOnLine, radius));
    }
    return tangentCircles;
  }

  double sectorArea(Point point1, Point point2, {String direction = 'ccw'}) {
    var arcLen = arcLength(point1, point2, direction: direction);
    var angle = arcLen / radius;
    return 0.5 * pow(radius, 2) * (angle - sin(angle));
  }

  bool isIntersecting(Circle otherCircle) {
    return center.distanceTo(otherCircle.center) <=
        (radius + otherCircle.radius);
  }

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
      var line = Line(Point(p.x + dx * r1, p.y + dy * r1),
          Point(p.x + dx * r2, p.y + dy * r2));
      result.add(line);
    }

    return result;
  }

  static Circle fromBoundaryPoints(List<Point> boundaryPoints) {
    if (boundaryPoints.isEmpty) {
      return Circle(Point(0, 0), 0);
    } else if (boundaryPoints.length == 1) {
      return Circle(boundaryPoints[0], 0);
    } else if (boundaryPoints.length == 2) {
      var center = boundaryPoints[0].midpointTo(boundaryPoints[1]);
      var radius = boundaryPoints[0].distanceTo(center);
      return Circle(center, radius);
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

      return Circle(center, radius);
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

  static Circle enclosingCircle(List<List<double>> points) {
    var pList = points.map((p) => Point(p[0], p[1])).toList();
    pList.shuffle();
    return _welzlAlgorithm(pList, []);
  }
}
