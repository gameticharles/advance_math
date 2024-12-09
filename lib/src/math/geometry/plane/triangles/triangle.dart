part of '../../geometry.dart';

/// Represents a triangle in 2D space.
class Triangle extends PlaneGeometry {
  /// Side `a` of the triangle
  num? a;

  /// Side `b` of the triangle
  num? b;

  /// Side `c` of the triangle
  num? c;

  /// The angle opposite side `a` of the triangle.
  Angle? angleA;

  /// The angle opposite side `b` of the triangle.
  Angle? angleB;

  /// The angle opposite side `c` of the triangle.
  Angle? angleC;

  /// The point `A` of the triangle.
  Point? A;

  /// The point `B` of the triangle.
  Point? B;

  /// The point `C` of the triangle.
  Point? C;

  /// Creates a new triangle from provided sides, angles, and points.
  ///
  /// If points are provided, the sides are calculated.
  /// If sides are provided, the angles are calculated.
  Triangle(
      {this.a,
      this.b,
      this.c,
      this.angleA,
      this.angleB,
      this.angleC,
      this.A,
      this.B,
      this.C})
      : super("Triangle") {
    if (A != null && B != null && C != null) {
      a = _distance(B!, C!);
      b = _distance(A!, C!);
      c = _distance(A!, B!);
    }
    if (a != null && b != null && c != null) {
      angleA ??= _angleFromSides(b!, c!, a!);
      angleB ??= _angleFromSides(a!, c!, b!);
      angleC ??= _angleFromSides(a!, b!, c!);
    }
  }

  num? get base => a;

  /// The height of side `a` of the triangle.
  num? get heightA {
    if (b == null || angleC == null) {
      throw Exception(
          "Side b and angleC must be known to calculate the height.");
    }
    return b! * sin(angleC!.rad); // Assuming angleC is in radians
  }

  /// The height of side `b` of the triangle.
  num? get heightB {
    if (c == null || angleA == null) {
      throw Exception(
          "Side c and angleA must be known to calculate the height.");
    }
    return c! * sin(angleA!.rad); // Assuming angleC is in radians
  }

  /// The height of side `c` of the triangle
  num? get heightC {
    if (a == null || angleB == null) {
      throw Exception(
          "Side a and angleB must be known to calculate the height.");
    }
    return a! * sin(angleB!.rad); // Assuming angleC is in radians
  }

  /// The median of side `a` of the triangle.
  ///
  /// ma = 1 ⁄ 2×√(b²+c²+2b×c×cos(α))
  num? get medianA {
    if (b == null || c == null || angleC == null) {
      throw Exception(
          "Sides b, c and angleC must be known to calculate the median.");
    }
    return 0.5 *
        sqrt((b! * b!) + (c! * c!) + ((2 * b!) * c! * cos(angleC!.rad)));
  }

  /// The median of side `b` of the triangle.
  ///
  /// mb = 1 ⁄ 2×√(a²+c²+2a×c×cos(β))
  num? get medianB {
    if (a == null || c == null || angleC == null) {
      throw Exception(
          "Sides a, c and angleC must be known to calculate the median.");
    }
    return 0.5 *
        sqrt((a! * a!) + (c! * c!) + ((2 * a!) * c! * cos(angleC!.rad)));
  }

  /// The median of side `c` of the triangle.
  ///
  /// mc = 1 ⁄ 2×√(a²+b²+2a×b×cos(γ))
  num? get medianC {
    if (a == null || b == null || angleC == null) {
      throw Exception(
          "Sides a, b and angleC must be known to calculate the median.");
    }
    return 0.5 *
        sqrt((a! * a!) + (b! * b!) + ((2 * a!) * b! * cos(angleC!.rad)));
  }

  /// Get the circumcircle radius of the triangle.
  ///
  /// The circumcircle is the circle that touches all three sides of the triangle.
  /// ie. the circle that touches all three points of the triangle.
  ///
  /// R  = a ⁄ (2 sin(α))  = b ⁄ (2 sin(β))  = c ⁄ (2 sin(γ))
  ///
  /// Returns the circumcircle radius as a [double].
  ///
  /// If the triangle is degenerate (a triangle with zero area), the radius is infinite.
  double get circumCircleRadius {
    if (a == null || b == null || c == null) {
      throw Exception(
          "All sides must be known to calculate the circumcircle radius.");
    }
    return a! / (2 * sin(angleA!.rad));
  }

  /// Get the incircle radius of the triangle.
  ///
  /// The incircle is the circle that touches all three angles of the triangle.
  /// ie. the circle that touches all three sides of the triangle.
  ///
  /// r  =  √((s−a)(s−b)(s−c) ⁄ s)
  double get inCircleRadius {
    if (a == null || b == null || c == null) {
      throw Exception(
          "All sides must be known to calculate the incircle radius.");
    }
    return sqrt(((s - a!) * (s - b!) * (s - c!)) / s);
  }

  /// Private helper function to calculate distance between two points.
  double _distance(Point p1, Point p2) {
    return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2));
  }

  /// Private helper function to calculate angle from three sides.
  Angle _angleFromSides(num a, num b, num c) {
    return Angle(rad: acos((pow(a, 2) + pow(b, 2) - pow(c, 2)) / (2 * a * b)));
  }

  ///
  /// Computes the area of a triangle using Heron's formula.
  ///
  /// Heron's formula calculates the area of a triangle when the lengths of all three sides are known.
  /// There is no need for angles to be known.
  ///
  /// The formula is given by: _Area = sqrt[s(s - a)(s - b)(s - c)]_
  /// where s is the semi-perimeter of the triangle given by: _s = (a + b + c) / 2_
  ///
  /// Example usage:
  /// ```dart
  /// var area = Triangle.heronFormula(3, 4, 5);
  /// print(area);  // prints: 6.0
  /// ```
  ///
  /// [a] The length of side a of the triangle.
  /// [b] The length of side b of the triangle.
  /// [c] The length of side c of the triangle.
  /// Returns the area of the triangle.
  ///
  static double heronFormula(num a, num b, num c) {
    double s = (a + b + c) / 2;
    return sqrt(s * (s - a) * (s - b) * (s - c));
  }

  /// Computes the area of a triangle using the trigonometric formula.
  ///
  /// The trigonometric formula calculates the area of a triangle when
  /// the lengths of two sides and the included angle are known.
  ///
  /// The formula is given by: _Area = 0.5 * a * b * sin(angleC)_
  ///
  /// Example usage:
  /// ```dart
  /// var angleC = Angle(deg: 90);
  /// var area = Triangle.trigonometricFormula(3, 4, angleC);
  /// print(area);  // prints: 6.0
  /// ```
  ///
  /// [a] The length of side a of the triangle.
  /// [b] The length of side b of the triangle.
  /// [angleC] The angle included between sides a and b.
  /// Returns the area of the triangle.
  ///
  static double trigonometricFormula(num a, num b, Angle angleC) {
    return 0.5 * a * b * angleC.sin();
  }

  /// Computes the area of a triangle using the base-height formula.
  ///
  /// The base-height formula calculates the area of a triangle when the length of one side (the base) and the perpendicular height from the base to the opposite vertex are known.
  ///
  /// The formula is given by: _Area = 0.5 * base * height_
  ///
  /// Example usage:
  /// ```dart
  /// var area = Triangle.baseHeightFormula(6, 4);
  /// print(area);  // prints: 12.0
  /// ```
  ///
  /// [base] The length of the base of the triangle.
  /// [height] The height from the base to the opposite vertex.
  /// Return the area of the triangle.
  ///
  static double baseHeightFormula(num base, num height) {
    return 0.5 * base * height;
  }

  /// Computes the area of a triangle using the coordinates formula.
  ///
  /// The coordinates formula calculates the area of a triangle when the coordinates of its vertices are known.
  ///
  /// The formula is given by: _Area = 1/2 * |x1(y2 - y3) + x2(y3 - y1) + x3(y1 - y2)|_
  ///
  /// Example usage:
  /// ```dart
  /// var coords = [Point(0, 0), Point(6, 0), Point(3, 4)];
  /// var area = Triangle.coordinatesFormula(coords);
  /// print(area);  // prints: 12.0
  /// ```
  ///
  /// [coords] A list containing the coordinates of the triangle's vertices.
  /// Returns the area of the triangle.
  ///
  static double coordinatesFormula(List<Point> coords) {
    num x1 = coords[0].x, y1 = coords[0].y;
    num x2 = coords[1].x, y2 = coords[1].y;
    num x3 = coords[2].x, y3 = coords[2].y;
    return (x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2)).abs() / 2;
  }

  /// Calculates area using Heron's formula.
  /// Requires all sides to be known.
  double heron() {
    if (a == null || b == null || c == null) {
      throw Exception(
          "All sides (a, b, and c) must be provided to use Heron's formula.");
    }

    return heronFormula(a!, b!, c!);
  }

  /// Calculates area using trigonometric formula.
  /// Requires two sides and the angle between them.
  double trigonometric() {
    if (a == null || b == null || angleC == null) {
      throw Exception(
          "Sides a, b and the angle between them (angleC) are required for the trigonometric formula.");
    }

    return trigonometricFormula(a!, b!, angleC!);
  }

  /// Uses the cosine rule to calculate a missing side or angle.
  /// Requires two known sides and one known angle.
  void cosineRule() {
    if (a != null && b != null && angleC != null) {
      c = sqrt(pow(a!, 2) + pow(b!, 2) - 2 * a! * b! * angleC!.cos());
    } else if (a != null && c != null && angleB != null) {
      b = sqrt(pow(a!, 2) + pow(c!, 2) - 2 * a! * c! * angleB!.cos());
    } else if (b != null && c != null && angleA != null) {
      a = sqrt(pow(b!, 2) + pow(c!, 2) - 2 * b! * c! * angleA!.cos());
    } else {
      throw Exception("Not enough information provided for the cosine rule.");
    }
  }

  /// Uses the sine rule to calculate a missing side or angle. Requires one unknown side or angle.
  void sineRule() {
    int knownSides = [a, b, c].where((element) => element == null).length;
    int knownAngles =
        [angleA, angleB, angleC].where((element) => element == null).length;

    if (knownSides + knownAngles != 1) {
      throw Exception(
          "The sine rule requires exactly one unknown side or angle.");
    }

    if (a != null && angleA != null) {
      double ratio = a! / angleA!.sin();
      if (b == null && angleB != null) {
        b = ratio * angleB!.sin();
      } else if (c == null && angleC != null) {
        c = ratio * angleC!.sin();
      } else if (angleB == null && b != null) {
        angleB = Angle(rad: asin(b! / ratio));
        angleC = Angle(deg: 180 - angleA!.deg - angleB!.deg);
      }
    } else if (b != null && angleB != null) {
      double ratio = b! / angleB!.sin();
      if (a == null && angleA != null) {
        a = ratio * angleA!.sin();
      } else if (c == null && angleC != null) {
        c = ratio * angleC!.sin();
      } else if (angleA == null && a != null) {
        angleA = Angle(rad: asin(a! / ratio));
        angleC = Angle(deg: 180 - angleA!.deg - angleB!.deg);
      }
    } else if (c != null && angleC != null) {
      double ratio = c! / angleC!.sin();
      if (a == null && angleA != null) {
        a = ratio * angleA!.sin();
      } else if (b == null && angleB != null) {
        b = ratio * angleB!.sin();
      } else if (angleA == null && a != null) {
        angleA = Angle(rad: asin(a! / ratio));
        angleB = Angle(deg: 180 - angleA!.deg - angleC!.deg);
      }
    } else {
      throw Exception("Not enough information provided for the sine rule.");
    }
  }

  /// Calculates the area of the triangle using the given method.
  ///
  /// This method allows to compute the area of a triangle using one of the four available methods:
  /// - Heron's formula
  /// - Base-Height formula
  /// - Trigonometry formula
  /// - Coordinates formula
  ///
  /// The choice of the method depends on what information is known about the triangle.
  ///
  /// Example usage:
  /// ```dart
  /// var triangle = Triangle(a: 3, b: 4, c: 5);
  /// print(triangle.area(AreaMethod.heron));  // prints: 6.0
  /// ```
  ///
  /// In the example above, the area of a triangle with side lengths 3, 4, and 5 is calculated using Heron's formula, and the result is 6.0.
  ///
  /// [method] An enumeration value specifying which method to use for calculating the area.
  /// Returns the area of the triangle.
  /// Throws Exception if the method argument is not a valid enumeration value.
  ///
  @override
  double area([AreaMethod method = AreaMethod.heron]) {
    switch (method) {
      case AreaMethod.heron:
        return heron();
      case AreaMethod.baseHeight:
        return baseHeightFormula(base!, heightA!);
      case AreaMethod.trigonometry:
        return trigonometric();
      case AreaMethod.coordinates:
        return coordinatesFormula([A!, B!, C!]);
      default:
        throw Exception("Invalid area calculation method.");
    }
  }

  /// Calculates the perimeter of the triangle.
  ///
  /// The perimeter is the sum of the lengths of all three sides of the triangle.
  ///
  /// Returns the perimeter of the triangle as a [double].
  @override
  double perimeter() {
    return a! + b! + c!.toDouble();
  }

  /// Get the semi-perimeter of a triangle
  double get s => (a! + b! + c!) / 2;

  /// The height of the triangle, which is equal to the length of side b.
  double get height1 => b!.toDouble();

  /// The heightII of the triangle, which is equal to the length of side a.
  double get height2 => a!.toDouble();

  /// The heightIII of the triangle, calculated from the lengths of its sides.
  double get height3 => (2.0 * ((a! * b!) / 2)) / c!;

  /// Calculate the missing coordinates (point C) if points A and B, sides a, b and angleC are given.
  List<Point> calculateOtherCoordinates() {
    if (A == null || B == null || a == null || b == null || angleC == null) {
      throw Exception(
          "Point A, B, side a, b and angleC are required to calculate other coordinates.");
    }

    C = Point(B!.x + a! * angleC!.cos(), B!.y + a! * angleC!.sin());
    return [A!, B!, C!];
  }

  /// Calculate any missing coordinates. If all coordinates are known, it will throw an Exception.
  List<Point> calculateMissingCoordinates() {
    if (A == null || B == null || C == null) {
      return calculateOtherCoordinates();
    } else {
      throw Exception("All points (A, B, C) are already known.");
    }
  }

  @override
  String toString() {
    return 'Triangle(a: $a, b: $b, c: $c, angleA: $angleA, angleB: $angleB, angleC: $angleC, A: $A, B: $B, C: $C)';
  }
}
