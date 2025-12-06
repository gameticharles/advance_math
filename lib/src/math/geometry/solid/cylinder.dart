part of '../geometry.dart';

/// A class representing a cylinder in 3D space.
///
/// A cylinder is a solid geometric figure with straight parallel sides and a circular or oval cross section.
/// This implementation assumes a right circular cylinder.
///
/// Properties:
/// - Radius (of the base)
/// - Height
/// - Volume = π × r² × h
/// - Surface Area = 2πr(r + h)
/// - Lateral Surface Area = 2πrh
///
/// Example:
/// ```dart
/// var cylinder = Cylinder(radius: 3.0, height: 5.0);
/// print('Volume: ${cylinder.volume()}');
/// ```
class Cylinder extends SolidGeometry {
  /// The center point of the base of the cylinder.
  Point center;

  /// The radius of the base.
  double radius;

  /// The height of the cylinder.
  double height;

  /// Creates a cylinder with specified radius and height.
  ///
  /// [radius] and [height] must be positive.
  /// [center] defaults to (0, 0, 0).
  Cylinder({required this.radius, required this.height, Point? center})
      : center = center ?? Point(0, 0, 0),
        super('Cylinder') {
    if (radius <= 0 || height <= 0) {
      throw ArgumentError(
          'Radius and height must be positive. Got radius: $radius, height: $height');
    }
  }

  /// Creates a cylinder from volume and radius.
  ///
  /// h = V / (πr²)
  Cylinder.fromVolumeAndRadius(
      {required double volume, required this.radius, Point? center})
      : center = center ?? Point(0, 0, 0),
        height = volume / (pi * radius * radius),
        super('Cylinder') {
    if (volume <= 0 || radius <= 0) {
      throw ArgumentError('Volume and radius must be positive');
    }
  }

  /// Calculates the volume of the cylinder.
  ///
  /// Volume = π × r² × h
  @override
  double volume() {
    return pi * radius * radius * height;
  }

  /// Calculates the total surface area of the cylinder.
  ///
  /// Surface Area = 2πr(r + h)
  @override
  double surfaceArea() {
    return 2 * pi * radius * (radius + height);
  }

  /// Calculates the lateral surface area (side area only).
  ///
  /// Lateral Area = 2πrh
  double lateralSurfaceArea() {
    return 2 * pi * radius * height;
  }

  @override
  double area() => surfaceArea();

  @override
  String toString() {
    return 'Cylinder(center: $center, radius: $radius, height: $height, volume: ${volume()})';
  }

  @override
  BoundingBox3D boundingBox() {
    return BoundingBox3D(
      Point(center.x - radius, center.y - radius, center.z! - height / 2),
      Point(center.x + radius, center.y + radius, center.z! + height / 2),
    );
  }
}
