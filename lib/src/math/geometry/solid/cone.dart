part of '../geometry.dart';

/// A class representing a cone in 3D space.
///
/// A cone is a solid that has a circular base and a single vertex.
/// This implementation assumes a right circular cone.
///
/// Properties:
/// - Radius (of the base)
/// - Height
/// - Slant Height = √(r² + h²)
/// - Volume = (1/3) × π × r² × h
/// - Surface Area = πr(r + s)
///
/// Example:
/// ```dart
/// var cone = Cone(radius: 3.0, height: 4.0);
/// print('Slant Height: ${cone.slantHeight}'); // 5.0
/// print('Volume: ${cone.volume()}');
/// ```
class Cone extends SolidGeometry {
  /// The center point of the base of the cone.
  Point center;

  /// The radius of the base.
  double radius;

  /// The height of the cone.
  double height;

  /// Creates a cone with specified radius and height.
  ///
  /// [radius] and [height] must be positive.
  /// [center] defaults to (0, 0, 0).
  Cone({required this.radius, required this.height, Point? center})
      : center = center ?? Point(0, 0, 0),
        super('Cone') {
    if (radius <= 0 || height <= 0) {
      throw ArgumentError(
          'Radius and height must be positive. Got radius: $radius, height: $height');
    }
  }

  /// Gets the slant height of the cone.
  ///
  /// s = √(r² + h²)
  double get slantHeight => sqrt(radius * radius + height * height);

  /// Calculates the volume of the cone.
  ///
  /// Volume = (1/3) × π × r² × h
  @override
  double volume() {
    return (1 / 3) * pi * radius * radius * height;
  }

  /// Calculates the total surface area of the cone.
  ///
  /// Surface Area = πr(r + s)
  @override
  double surfaceArea() {
    return pi * radius * (radius + slantHeight);
  }

  /// Calculates the lateral surface area (side area only).
  ///
  /// Lateral Area = πrs
  double lateralSurfaceArea() {
    return pi * radius * slantHeight;
  }

  @override
  double area() => surfaceArea();

  @override
  String toString() {
    return 'Cone(radius: $radius, height: $height, volume: ${volume()})';
  }

  @override
  BoundingBox3D boundingBox() {
    return BoundingBox3D(
      Point(center.x - radius, center.y - radius, center.z!),
      Point(center.x + radius, center.y + radius, center.z! + height),
    );
  }
}
