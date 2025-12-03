part of '../geometry.dart';

/// A class representing a triangular prism in 3D space.
///
/// A triangular prism has two parallel triangular bases and
/// three rectangular lateral faces.
///
/// Properties:
/// - Base triangle with sides a, b, c
/// - Height (distance between bases): h
/// - Volume = baseArea × h
/// - Surface Area = 2 × baseArea + perimeter × h
///
/// Example:
/// ```dart
/// var prism = TriangularPrism(baseSides: [3, 4, 5], height: 10);
/// print('Volume: ${prism.volume()}');
/// ```
class TriangularPrism extends SolidGeometry {
  /// The center point of the base.
  Point center;

  /// Sides of the triangular base.
  List<double> baseSides;

  /// Height (distance between two bases).
  double height;

  /// Creates a triangular prism with specified base and height.
  ///
  /// [baseSides] must have exactly 3 positive values.
  /// [height] must be positive.
  /// [center] defaults to (0, 0, 0).
  TriangularPrism(
      {required this.baseSides, required this.height, Point? center})
      : center = center ?? Point(0, 0, 0),
        super('TriangularPrism') {
    if (baseSides.length != 3) {
      throw ArgumentError(
          'Base must have exactly 3 sides, got: ${baseSides.length}');
    }
    if (baseSides.any((side) => side <= 0)) {
      throw ArgumentError('All base sides must be positive');
    }
    if (height <= 0) {
      throw ArgumentError('Height must be positive, got: $height');
    }
    // Verify triangle inequality
    if (baseSides[0] + baseSides[1] <= baseSides[2] ||
        baseSides[0] + baseSides[2] <= baseSides[1] ||
        baseSides[1] + baseSides[2] <= baseSides[0]) {
      throw ArgumentError('Sides do not form a valid triangle: $baseSides');
    }
  }

  /// Creates an equilateral triangular prism.
  factory TriangularPrism.equilateral({
    required double side,
    required double height,
    Point? center,
  }) {
    return TriangularPrism(
      baseSides: [side, side, side],
      height: height,
      center: center,
    );
  }

  /// Creates an equilateral triangular prism from volume and side.
  ///
  /// Calculates height from: h = V / baseArea where baseArea = (√3/4)side²
  ///
  /// Example:
  /// ```dart
  /// var prism = TriangularPrism.fromVolumeEquilateral(volume: 50, side: 4);
  /// ```
  factory TriangularPrism.fromVolumeEquilateral({
    required double volume,
    required double side,
    Point? center,
  }) {
    if (volume <= 0) throw ArgumentError('Volume must be positive');
    if (side <= 0) throw ArgumentError('Side must be positive');

    double baseArea = (sqrt(3) / 4) * side * side;
    double height = volume / baseArea;
    return TriangularPrism.equilateral(
        side: side, height: height, center: center);
  }

  /// Creates an equilateral triangular prism from volume and height.
  ///
  /// Calculates side from: side = √(4V / (√3 × h))
  ///
  /// Example:
  /// ```dart
  /// var prism = TriangularPrism.fromVolumeEquilateralAndHeight(volume: 50, height: 10);
  /// ```
  factory TriangularPrism.fromVolumeEquilateralAndHeight({
    required double volume,
    required double height,
    Point? center,
  }) {
    if (volume <= 0) throw ArgumentError('Volume must be positive');
    if (height <= 0) throw ArgumentError('Height must be positive');

    double side = sqrt((4 * volume) / (sqrt(3) * height));
    return TriangularPrism.equilateral(
        side: side, height: height, center: center);
  }

  /// Calculates the area of the triangular base using Heron's formula.
  double get baseArea {
    double a = baseSides[0];
    double b = baseSides[1];
    double c = baseSides[2];
    double s = (a + b + c) / 2; // semi-perimeter
    return sqrt(s * (s - a) * (s - b) * (s - c));
  }

  /// Gets the perimeter of the triangular base.
  double get basePerimeter => baseSides[0] + baseSides[1] + baseSides[2];

  /// Calculates the volume of the triangular prism.
  ///
  /// Volume = baseArea × h
  @override
  double volume() {
    return baseArea * height;
  }

  /// Calculates the surface area of the triangular prism.
  ///
  /// Surface Area = 2 × baseArea + perimeter × h
  @override
  double surfaceArea() {
    return 2 * baseArea + basePerimeter * height;
  }

  /// Gets the lateral surface area (rectangular faces only).
  double get lateralSurfaceArea => basePerimeter * height;

  @override
  double area() => surfaceArea();

  @override
  String toString() {
    return 'TriangularPrism(baseSides: $baseSides, height: $height, volume: ${volume()})';
  }

  @override
  BoundingBox3D boundingBox() {
    // Use maximum side for conservative bounding
    double maxSide = baseSides.reduce((a, b) => a > b ? a : b);
    double radius = maxSide / sqrt(3);
    return BoundingBox3D(
      Point(center.x - radius, center.y - radius, center.z! - height / 2),
      Point(center.x + radius, center.y + radius, center.z! + height / 2),
    );
  }
}
