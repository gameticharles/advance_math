part of geometry;

/// Represents a spherical triangle, defined by its three angles (A, B, C)
/// and the lengths of the three sides opposite those angles (a, b, c).
///
/// All values are in radians.
///
/// The class provides automatic calculation of missing values if enough
/// information is provided (at least one angle-side pair). If not enough
/// information is provided, it throws an [ArgumentError].
///
/// If you change one of the values after object creation, all dependent
/// values are automatically recalculated.
///
/// Example usage:
///
/// ```dart
/// // Define a spherical triangle with one angle-side pair
/// var triangle = SphericalTriangle.fromSideAndAngle(pi / 3, pi / 2);
///
/// // Angles
/// print(triangle.angleA);
/// print(triangle.angleB);
/// print(triangle.angleC);
/// // Sides
/// print(triangle.sideA);
/// print(triangle.sideB);
/// print(triangle.sideC);
/// ```
class SphericalTriangle {
  final double _angleA;
  final double _angleB;
  final double _angleC;
  final double _sideA;
  final double _sideB;
  final double _sideC;

  /// Creates a new SphericalTriangle. Any provided parameters are used
  /// to calculate any missing values.
  SphericalTriangle._(this._angleA, this._angleB, this._angleC, this._sideA,
      this._sideB, this._sideC);

  factory SphericalTriangle.fromTwoSidesAndAngle(
      double angleA, double sideA, double sideB) {
    var angleB = asin(sin(angleA) * sideB / sideA);
    var angleC = pi - angleA - angleB;
    var sideC = acos(
        (cos(sideA) - cos(sideB) * cos(angleC)) / (sin(sideB) * sin(angleC)));
    //_validateTriangle();
    return SphericalTriangle._(angleA, angleB, angleC, sideA, sideB, sideC);
  }

  factory SphericalTriangle.fromTwoAnglesAndSide(
      double angleA, double angleB, double sideA) {
    var angleC = pi - angleA - angleB;
    var sideB = asin(sin(sideA) * sin(angleB) / sin(angleA));
    var sideC = acos(
        cos(sideA) - cos(sideB) * cos(angleC) / (sin(sideB) * sin(angleC)));
    //_validateTriangle();
    return SphericalTriangle._(angleA, angleB, angleC, sideA, sideB, sideC);
  }

  factory SphericalTriangle.fromAllSides(
      double sideA, double sideB, double sideC) {
    var angleA = acos(
        (cos(sideC) - cos(sideA) * cos(sideB)) / (sin(sideA) * sin(sideB)));
    var angleB = acos(
        (cos(sideA) - cos(sideB) * cos(sideC)) / (sin(sideB) * sin(sideC)));
    var angleC = acos(
        (cos(sideB) - cos(sideC) * cos(sideA)) / (sin(sideC) * sin(sideA)));
    //_validateTriangle();
    return SphericalTriangle._(angleA, angleB, angleC, sideA, sideB, sideC);
  }

  factory SphericalTriangle.fromAllAngles(
      double angleA, double angleB, double angleC) {
    var sideA = acos((cos(angleC) - cos(angleA) * cos(angleB)) /
        (sin(angleA) * sin(angleB)));
    var sideB = acos((cos(angleA) - cos(angleB) * cos(angleC)) /
        (sin(angleB) * sin(angleC)));
    var sideC = acos((cos(angleB) - cos(angleC) * cos(angleA)) /
        (sin(angleC) * sin(angleA)));
    //_validateTriangle();
    return SphericalTriangle._(angleA, angleB, angleC, sideA, sideB, sideC);
  }

  static double calculateOtherSide(double angle1, double angle2, double side) {
    return side * sin(angle2) / sin(angle1);
  }

  factory SphericalTriangle.fromSideAndAngle(double angleA, double sideA) {
    // First, calculate the other two angles
    var angleB = asin(sin(sideA) * sin(angleA));
    var angleC = pi - angleA - angleB;

    // Then, calculate the other two sides
    var sideB = calculateOtherSide(sideA, angleA, angleB);
    var sideC = calculateOtherSide(sideA, angleA, angleC);

    return SphericalTriangle._(angleA, angleB, angleC, sideA, sideB, sideC);
  }

  /// Checks if the values form a valid spherical triangle.
  bool isValidTriangle() {
    var sumOfAngles = _angleA + _angleB + _sideC;
    var sumOfSides = _sideA + _sideB + _sideC;

    return !((sumOfAngles - pi).abs() > 1e-6 && sumOfSides >= 2 * pi);
  }

  /// Computes the area of the spherical triangle
  /// using the formula A = E - pi, where E is the
  /// sum of the interior angles of the triangle.
  double get area {
    return _angleA + _angleB + _angleC - pi;
  }

  /// Computes the perimeter of the spherical triangle,
  /// which is the sum of the lengths of its sides.
  double get perimeter {
    return _sideA + _sideB + _sideC;
  }

  /// as a percentage of the surface area of a unit sphere.
  double get areaPercentage {
    return (area / (4 * pi)) * 100;
  }

  /// Computes the perimeter of the spherical triangle,
  /// as a percentage of the circumference of a unit sphere.
  double get perimeterPercentage {
    return (perimeter / (2 * pi)) * 100;
  }

  /// Returns the angle A.
  num get angleA => _angleA;

  /// Returns the angle B.
  num get angleB => _angleB;

  /// Returns the angle C.
  num get angleC => _angleC;

  /// Returns the side a.
  num get sideA => _sideA;

  /// Returns the side b.
  num get sideB => _sideB;

  /// Returns the side c.
  num get sideC => _sideC;
}
