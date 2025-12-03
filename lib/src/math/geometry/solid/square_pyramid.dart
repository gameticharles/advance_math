part of '../geometry.dart';

/// A class representing a square pyramid in 3D space.
///
/// A square pyramid has a square base and four triangular faces
/// that meet at a common apex point.
///
/// Properties:
/// - Base side length: a
/// - Height: h
/// - Slant height: s = √(h² + (a/2)²)
/// - Volume = (1/3)a²h
/// - Surface Area = a² + 2a×s
///
/// Example:
/// ```dart
/// var pyramid = SquarePyramid(baseSide: 4, height: 3);
/// print('Slant Height: ${pyramid.slantHeight}');
/// ```
class SquarePyramid extends SolidGeometry {
  /// The center point of the base.
  Point center;

  /// Side length of the square base.
  double baseSide;

  /// Height from base to apex.
  double height;

  /// Creates a square pyramid with specified base side and height.
  ///
  /// [baseSide] and [height] must be positive.
  /// [center] defaults to (0, 0, 0).
  SquarePyramid({required this.baseSide, required this.height, Point? center})
      : center = center ?? Point(0, 0, 0),
        super('SquarePyramid') {
    if (baseSide <= 0 || height <= 0) {
      throw ArgumentError(
          'Base side and height must be positive. Got baseSide: $baseSide, height: $height');
    }
  }

  /// Creates a square pyramid from volume and base side.
  ///
  /// Calculates height from: h = 3V / a²
  ///
  /// Example:
  /// ```dart
  /// var pyramid = SquarePyramid.fromVolumeAndBase(volume: 48, baseSide: 6);
  /// ```
  factory SquarePyramid.fromVolumeAndBase({
    required double volume,
    required double baseSide,
    Point? center,
  }) {
    if (volume <= 0) throw ArgumentError('Volume must be positive');
    if (baseSide <= 0) throw ArgumentError('Base side must be positive');

    double height = (3 * volume) / (baseSide * baseSide);
    return SquarePyramid(baseSide: baseSide, height: height, center: center);
  }

  /// Creates a square pyramid from volume and height.
  ///
  /// Calculates base side from: a = √(3V / h)
  ///
  /// Example:
  /// ```dart
  /// var pyramid = SquarePyramid.fromVolumeAndHeight(volume: 48, height: 4);
  /// ```
  factory SquarePyramid.fromVolumeAndHeight({
    required double volume,
    required double height,
    Point? center,
  }) {
    if (volume <= 0) throw ArgumentError('Volume must be positive');
    if (height <= 0) throw ArgumentError('Height must be positive');

    double baseSide = sqrt((3 * volume) / height);
    return SquarePyramid(baseSide: baseSide, height: height, center: center);
  }

  /// Creates a square pyramid from base side and slant height.
  ///
  /// Calculates height from: h = √(s² - (a/2)²)
  ///
  /// Example:
  /// ```dart
  /// var pyramid = SquarePyramid.fromSlantHeight(baseSide: 6, slantHeight: 5);
  /// ```
  factory SquarePyramid.fromSlantHeight({
    required double baseSide,
    required double slantHeight,
    Point? center,
  }) {
    if (baseSide <= 0) throw ArgumentError('Base side must be positive');
    if (slantHeight <= 0) throw ArgumentError('Slant height must be positive');

    double halfBase = baseSide / 2;
    if (slantHeight <= halfBase) {
      throw ArgumentError(
          'Slant height must be greater than half the base side. Got slantHeight: $slantHeight, baseSide/2: $halfBase');
    }

    double height = sqrt(slantHeight * slantHeight - halfBase * halfBase);
    return SquarePyramid(baseSide: baseSide, height: height, center: center);
  }

  /// Gets the slant height of the pyramid.
  ///
  /// s = √(h² + (a/2)²)
  double get slantHeight =>
      sqrt(height * height + (baseSide / 2) * (baseSide / 2));

  /// Calculates the volume of the square pyramid.
  ///
  /// Volume = (1/3)a²h
  @override
  double volume() {
    return (1 / 3) * baseSide * baseSide * height;
  }

  /// Calculates the surface area of the square pyramid.
  ///
  /// Surface Area = a² + 2a×s (base area + lateral area)
  @override
  double surfaceArea() {
    return baseSide * baseSide + 2 * baseSide * slantHeight;
  }

  /// Gets the lateral surface area (triangular faces only).
  double get lateralSurfaceArea => 2 * baseSide * slantHeight;

  @override
  double area() => surfaceArea();

  @override
  String toString() {
    return 'SquarePyramid(baseSide: $baseSide, height: $height, slantHeight: $slantHeight, volume: ${volume()})';
  }

  @override
  BoundingBox3D boundingBox() {
    double halfBase = baseSide / 2;
    return BoundingBox3D(
      Point(center.x - halfBase, center.y - halfBase, center.z!),
      Point(center.x + halfBase, center.y + halfBase, center.z! + height),
    );
  }
}
