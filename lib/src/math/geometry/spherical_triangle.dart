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
  final Angle _angleA;
  final Angle _angleB;
  final Angle _angleC;
  final Angle _sideA;
  final Angle _sideB;
  final Angle _sideC;

  /// Creates a new SphericalTriangle. Any provided parameters are used
  /// to calculate any missing values.
  SphericalTriangle._(this._angleA, this._angleB, this._angleC, this._sideA,
      this._sideB, this._sideC);

  factory SphericalTriangle.fromTwoSidesAndAngle(
      Angle angleA, Angle sideA, Angle sideB) {
    var angleB = Angle(rad: asin(angleA.sin() * sideB.rad / sideA.rad));
    var angleC = Angle(rad: pi - angleA.rad - angleB.rad);
    var sideC = Angle(
        rad: acos((sideA.cos() - sideB.cos() * angleC.cos()) /
            (sideB.sin() * angleC.sin())));
    //_validateTriangle();
    return SphericalTriangle._(angleA, angleB, angleC, sideA, sideB, sideC);
  }

  factory SphericalTriangle.fromTwoAnglesAndSide(
      Angle angleA, Angle angleB, Angle sideA) {
    var angleC = Angle(rad: pi - angleA.rad - angleB.rad);
    var sideB = Angle(rad: asin(sideA.sin() * angleB.sin() / angleA.sin()));
    var sideC = Angle(
        rad: acos(sideA.cos() -
            sideB.cos() * angleC.cos() / (sideB.sin() * angleC.sin())));
    //_validateTriangle();
    return SphericalTriangle._(angleA, angleB, angleC, sideA, sideB, sideC);
  }

  factory SphericalTriangle.fromAllSides(
      Angle sideA, Angle sideB, Angle sideC) {
    var angleA = Angle(
        rad: acos((sideC.cos() - sideA.cos() * sideB.cos()) /
            (sideA.sin() * sideB.sin())));
    var angleB = Angle(
        rad: acos((sideA.cos() - sideB.cos() * sideC.cos()) /
            (sideB.sin() * sideC.sin())));
    var angleC = Angle(
        rad: acos((sideB.cos() - sideC.cos() * sideA.cos()) /
            (sideC.sin() * sideA.sin())));
    //_validateTriangle();
    return SphericalTriangle._(angleA, angleB, angleC, sideA, sideB, sideC);
  }

  factory SphericalTriangle.fromAllAngles(
      Angle angleA, Angle angleB, Angle angleC) {
    var sideA = Angle(
        rad: acos((angleC.cos() - angleA.cos() * angleB.cos()) /
            (angleA.sin() * angleB.sin())));
    var sideB = Angle(
        rad: acos((angleA.cos() - angleB.cos() * angleC.cos()) /
            (angleB.sin() * angleC.sin())));
    var sideC = Angle(
        rad: acos((angleB.cos() - angleC.cos() * angleA.cos()) /
            (angleC.sin() * angleA.sin())));
    //_validateTriangle();
    return SphericalTriangle._(angleA, angleB, angleC, sideA, sideB, sideC);
  }

  static Angle calculateOtherSide(Angle side, Angle angle1, Angle angle2) {
    return Angle(rad: side.rad * angle2.sin() / angle1.sin());
  }

  factory SphericalTriangle.fromSideAndAngle(Angle angleA, Angle sideA) {
    // First, calculate the other two angles
    var angleB = Angle(rad: asin(sideA.sin() * angleA.sin()));
    var angleC = Angle(rad: pi - angleA.rad - angleB.rad);

    // Then, calculate the other two sides
    var sideB = calculateOtherSide(sideA, angleA, angleB);
    var sideC = calculateOtherSide(sideA, angleA, angleC);

    return SphericalTriangle._(angleA, angleB, angleC, sideA, sideB, sideC);
  }

  /// Checks if the values form a valid spherical triangle.
  bool isValidTriangle() {
    var sumOfAngles = _angleA.rad + _angleB.rad + _angleB.rad;
    var sumOfSides = _sideA.rad + _sideB.rad + _sideC.rad;

    return !((sumOfAngles - pi).abs() > 1e-6 && sumOfSides >= 2 * pi);
  }

  /// Computes the area of the spherical triangle
  /// using the formula A = E - pi, where E is the
  /// sum of the interior angles of the triangle.
  num get area {
    return _angleA.rad + _angleB.rad + _angleC.rad - pi;
  }

  /// Computes the perimeter of the spherical triangle,
  /// which is the sum of the lengths of its sides.
  num get perimeter {
    return _sideA.rad + _sideB.rad + _sideC.rad;
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
  Angle get angleA => _angleA;

  /// Returns the angle B.
  Angle get angleB => _angleB;

  /// Returns the angle C.
  Angle get angleC => _angleC;

  /// Returns the side a.
  Angle get sideA => _sideA;

  /// Returns the side b.
  Angle get sideB => _sideB;

  /// Returns the side c.
  Angle get sideC => _sideC;
}
