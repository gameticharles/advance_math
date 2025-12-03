part of '../geometry.dart';

/// A class representing a hexagonal prism in 3D space.
///
/// A hexagonal prism has two parallel regular hexagonal bases and
/// six rectangular lateral faces.
///
/// Properties:
/// - Base side: a
/// - Height: h
/// - Base area = (3√3/2)a²
/// - Volume = (3√3/2)a² × h
/// - Surface Area = 3√3a² + 6ah
///
/// Example:
/// ```dart
/// var prism = HexagonalPrism(baseSide: 4, height: 10);
/// print('Volume: ${prism.volume()}');
/// ```
class HexagonalPrism extends SolidGeometry {
  /// The center point of the base.
  Point center;

  /// Side length of the regular hexagonal base.
  double baseSide;

  /// Height (distance between two bases).
  double height;

  /// Creates a hexagonal prism with specified base side and height.
  ///
  /// [baseSide] and [height] must be positive.
  /// [center] defaults to (0, 0, 0).
  HexagonalPrism({required this.baseSide, required this.height, Point? center})
      : center = center ?? Point(0, 0, 0),
        super('HexagonalPrism') {
    if (baseSide <= 0 || height <= 0) {
      throw ArgumentError(
          'Base side and height must be positive. Got baseSide: $baseSide, height: $height');
    }
  }

  /// Creates a hexagonal prism from volume and base side.
  ///
  /// Calculates height from: h = V / baseArea where baseArea = (3√3/2)a²
  ///
  /// Example:
  /// ```dart
  /// var prism = HexagonalPrism.fromVolume(volume: 100, baseSide: 3);
  /// ```
  factory HexagonalPrism.fromVolume({
    required double volume,
    required double baseSide,
    Point? center,
  }) {
    if (volume <= 0) throw ArgumentError('Volume must be positive');
    if (baseSide <= 0) throw ArgumentError('Base side must be positive');

    double baseArea = (3 * sqrt(3) / 2) * baseSide * baseSide;
    double height = volume / baseArea;
    return HexagonalPrism(baseSide: baseSide, height: height, center: center);
  }

  /// Creates a hexagonal prism from volume and height.
  ///
  /// Calculates base side from: a = √(2V / (3√3 × h))
  ///
  /// Example:
  /// ```dart
  /// var prism = HexagonalPrism.fromVolumeAndHeight(volume: 100, height: 8);
  /// ```
  factory HexagonalPrism.fromVolumeAndHeight({
    required double volume,
    required double height,
    Point? center,
  }) {
    if (volume <= 0) throw ArgumentError('Volume must be positive');
    if (height <= 0) throw ArgumentError('Height must be positive');

    double baseSide = sqrt((2 * volume) / (3 * sqrt(3) * height));
    return HexagonalPrism(baseSide: baseSide, height: height, center: center);
  }

  /// Creates a hexagonal prism from surface area and base side.
  ///
  /// Calculates height from: h = (A - 3√3a²) / (6a)
  ///
  /// Example:
  /// ```dart
  /// var prism = HexagonalPrism.fromSurfaceArea(surfaceArea: 150, baseSide: 3);
  /// ```
  factory HexagonalPrism.fromSurfaceArea({
    required double surfaceArea,
    required double baseSide,
    Point? center,
  }) {
    if (surfaceArea <= 0) throw ArgumentError('Surface area must be positive');
    if (baseSide <= 0) throw ArgumentError('Base side must be positive');

    double baseArea = (3 * sqrt(3) / 2) * baseSide * baseSide;
    double height = (surfaceArea - 2 * baseArea) / (6 * baseSide);

    if (height <= 0) {
      throw ArgumentError(
          'Invalid combination: surface area too small for given base side');
    }

    return HexagonalPrism(baseSide: baseSide, height: height, center: center);
  }

  /// Calculates the area of the hexagonal base.
  ///
  /// Base area = (3√3/2)a²
  double get baseArea => (3 * sqrt(3) / 2) * baseSide * baseSide;

  /// Gets the perimeter of the hexagonal base.
  double get basePerimeter => 6 * baseSide;

  /// Calculates the volume of the hexagonal prism.
  ///
  /// Volume = (3√3/2)a² × h
  @override
  double volume() {
    return baseArea * height;
  }

  /// Calculates the surface area of the hexagonal prism.
  ///
  /// Surface Area = 2 × baseArea + perimeter × h = 3√3a² + 6ah
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
    return 'HexagonalPrism(baseSide: $baseSide, height: $height, volume: ${volume()})';
  }

  @override
  BoundingBox3D boundingBox() {
    // For a regular hexagon, circumradius = side
    double circumRadius = baseSide;
    return BoundingBox3D(
      Point(center.x - circumRadius, center.y - circumRadius,
          center.z! - height / 2),
      Point(center.x + circumRadius, center.y + circumRadius,
          center.z! + height / 2),
    );
  }
}
