part of geometry;

// Todo: use the angle instance for the angle calculations

class Triangle {
  num? a, b, c;
  Angle? angleA, angleB, angleC;
  Point? A, B, C;

  Triangle(
      {this.a,
      this.b,
      this.c,
      this.angleA,
      this.angleB,
      this.angleC,
      this.A,
      this.B,
      this.C}) {
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

  double _distance(Point p1, Point p2) {
    return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2));
  }

  Angle _angleFromSides(num a, num b, num c) {
    return Angle(rad: acos((pow(a, 2) + pow(b, 2) - pow(c, 2)) / (2 * a * b)));
  }

  static double heronFormula(double a, double b, double c) {
    double s = (a + b + c) / 2;
    return sqrt(s * (s - a) * (s - b) * (s - c));
  }

  static double trigonometricFormula(double a, double b, double angleC) {
    num angleCRad = toRadians(angleC);
    return 0.5 * a * b * sin(angleCRad);
  }

  static double baseHeightFormula(double base, double height) {
    return 0.5 * base * height;
  }

  static double coordinatesFormula(List<Point> coords) {
    num x1 = coords[0].x, y1 = coords[0].y;
    num x2 = coords[1].x, y2 = coords[1].y;
    num x3 = coords[2].x, y3 = coords[2].y;
    return (x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2)).abs() / 2;
  }

  double heron() {
    if (a == null || b == null || c == null) {
      throw Exception(
          "All sides (a, b, and c) must be provided to use Heron's formula.");
    }
    double s = (a! + b! + c!) / 2;
    return sqrt(s * (s - a!) * (s - b!) * (s - c!));
  }

  double trigonometric() {
    if (a == null || b == null || angleC == null) {
      throw Exception(
          "Sides a, b and the angle between them (angleC) are required for the trigonometric formula.");
    }

    return 0.5 * a! * b! * angleC!.sin();
  }

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

  double area({String method = 'heron'}) {
    if (a == null || b == null || c == null) {
      throw Exception("Sides a, b and c are required to calculate area.");
    }
    if (method == 'heron') {
      double s = (a! + b! + c!) / 2;
      return sqrt(s * (s - a!) * (s - b!) * (s - c!));
    } else if (method == 'sine' && angleC != null) {
      return 0.5 * a! * b! * angleC!.sin();
    } else {
      throw Exception("Invalid method. Must be either 'heron' or 'sine'.");
    }
  }

  List<Point> calculateOtherCoordinates() {
    if (A == null || B == null || a == null || b == null || angleC == null) {
      throw Exception(
          "Point A, B, side a, b and angleC are required to calculate other coordinates.");
    }

    C = Point(B!.x + a! * angleC!.cos(), B!.y + a! * angleC!.sin());
    return [A!, B!, C!];
  }

  List<Point> calculateMissingCoordinates() {
    if (A == null || B == null || C == null) {
      return calculateOtherCoordinates();
    } else {
      throw Exception("All points (A, B, C) are already known.");
    }
  }
}
