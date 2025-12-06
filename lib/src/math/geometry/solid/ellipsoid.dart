part of '../geometry.dart';

/// A class representing an ellipsoid in 3D space.
///
/// An ellipsoid is a quadric surface that is a generalization of a sphere.
/// It has three semi-axes of different lengths.
///
/// Properties:
/// - Semi-axes: a, b, c
/// - Volume = (4/3)πabc
/// - Surface Area: Complex (using Knud Thomsen approximation)
///
/// Example:
/// ```dart
/// var ellipsoid = Ellipsoid(a: 5, b: 4, c: 3);
/// print('Volume: ${ellipsoid.volume()}');
/// ```
class Ellipsoid extends SolidGeometry {
  /// The center point of the ellipsoid.
  Point center;

  /// Semi-axis along x-axis.
  double a;

  /// Semi-axis along y-axis.
  double b;

  /// Semi-axis along z-axis.
  double c;

  /// Creates an ellipsoid with specified semi-axes.
  ///
  /// [a], [b], and [c] must be positive.
  /// [center] defaults to (0, 0, 0).
  Ellipsoid({required this.a, required this.b, required this.c, Point? center})
      : center = center ?? Point(0, 0, 0),
        super('Ellipsoid') {
    if (a <= 0 || b <= 0 || c <= 0) {
      throw ArgumentError(
          'Semi-axes must be positive. Got a: $a, b: $b, c: $c');
    }
  }

  /// Creates a sphere (special case of ellipsoid where a = b = c).
  factory Ellipsoid.sphere(double radius, {Point? center}) {
    return Ellipsoid(a: radius, b: radius, c: radius, center: center);
  }

  /// Creates an ellipsoid from volume and two semi-axes.
  ///
  /// Calculates c from: c = 3V / (4πab)
  ///
  /// Example:
  /// ```dart
  /// var ellipsoid = Ellipsoid.fromVolume(volume: 100, a: 5, b: 4);
  /// ```
  factory Ellipsoid.fromVolume({
    required double volume,
    required double a,
    required double b,
    Point? center,
  }) {
    if (volume <= 0) throw ArgumentError('Volume must be positive');
    if (a <= 0 || b <= 0) throw ArgumentError('Semi-axes must be positive');

    double c = (3 * volume) / (4 * pi * a * b);
    return Ellipsoid(a: a, b: b, c: c, center: center);
  }

  /// Creates an ellipsoid from volume and axis ratios.
  ///
  /// If a:b = ratioAB and a:c = ratioAC, solves for a, b, c.
  /// Volume = (4/3)πabc where b = a/ratioAB and c = a/ratioAC
  ///
  /// Example:
  /// ```dart
  /// var ellipsoid = Ellipsoid.fromVolumeAndRatios(
  ///   volume: 100,
  ///   ratioAB: 1.25,  // a is 1.25x larger than b
  ///   ratioAC: 1.5,   // a is 1.5x larger than c
  /// );
  /// ```
  factory Ellipsoid.fromVolumeAndRatios({
    required double volume,
    double ratioAB = 1.0,
    double ratioAC = 1.0,
    Point? center,
  }) {
    if (volume <= 0) throw ArgumentError('Volume must be positive');
    if (ratioAB <= 0 || ratioAC <= 0) {
      throw ArgumentError('Ratios must be positive');
    }

    // V = (4/3)π × a × (a/ratioAB) × (a/ratioAC) = (4/3)π × a³/(ratioAB × ratioAC)
    // a³ = 3V × ratioAB × ratioAC / (4π)
    double a = pow(3 * volume * ratioAB * ratioAC / (4 * pi), 1 / 3).toDouble();
    double b = a / ratioAB;
    double c = a / ratioAC;

    return Ellipsoid(a: a, b: b, c: c, center: center);
  }

  /// Calculates the volume of the ellipsoid.
  ///
  /// Volume = (4/3)πabc
  @override
  double volume() {
    return (4 / 3) * pi * a * b * c;
  }

  /// Calculates the surface area of the ellipsoid.
  ///
  /// Uses Knud Thomsen's approximation formula:
  /// S ≈ 4π[(a^p×b^p + a^p×c^p + b^p×c^p)/3]^(1/p) where p ≈ 1.6075
  @override
  double surfaceArea() {
    const double p = 1.6075;
    double ap = pow(a, p).toDouble();
    double bp = pow(b, p).toDouble();
    double cp = pow(c, p).toDouble();

    return 4 * pi * pow((ap * bp + ap * cp + bp * cp) / 3, 1 / p);
  }

  @override
  double area() => surfaceArea();

  @override
  String toString() {
    return 'Ellipsoid(a: $a, b: $b, c: $c, volume: ${volume()})';
  }

  @override
  BoundingBox3D boundingBox() {
    return BoundingBox3D(
      Point(center.x - a, center.y - b, center.z! - c),
      Point(center.x + a, center.y + b, center.z! + c),
    );
  }
}
