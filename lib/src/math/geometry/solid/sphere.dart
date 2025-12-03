part of '../geometry.dart';

/// A class representing a sphere in 3D space.
///
/// A sphere is a set of points in 3D space that are equidistant from a given center point.
///
/// Properties:
/// - Radius
/// - Volume = (4/3) × π × r³
/// - Surface Area = 4 × π × r²
///
/// Example:
/// ```dart
/// var sphere = Sphere(5.0);
/// print('Volume: ${sphere.volume()}');
/// print('Surface Area: ${sphere.surfaceArea()}');
/// ```
class Sphere extends SolidGeometry {
  /// The center point of the sphere.
  Point center;

  /// The radius of the sphere.
  double radius;

  /// Creates a sphere with the specified radius and optional center.
  ///
  /// [radius] must be positive.
  /// [center] defaults to (0, 0, 0).
  Sphere(this.radius, {Point? center})
      : center = center ?? Point(0, 0, 0),
        super('Sphere') {
    if (radius <= 0) {
      throw ArgumentError('Radius must be positive, got: $radius');
    }
  }

  /// Creates a sphere from a given volume.
  ///
  /// r = ∛(3V / 4π)
  Sphere.fromVolume(double volume, {Point? center})
      : center = center ?? Point(0, 0, 0),
        radius = pow((3 * volume) / (4 * pi), 1 / 3).toDouble(),
        super('Sphere') {
    if (volume <= 0) {
      throw ArgumentError('Volume must be positive, got: $volume');
    }
  }

  /// Creates a sphere from a given surface area.
  ///
  /// r = √(A / 4π)
  Sphere.fromSurfaceArea(double surfaceArea, {Point? center})
      : center = center ?? Point(0, 0, 0),
        radius = sqrt(surfaceArea / (4 * pi)),
        super('Sphere') {
    if (surfaceArea <= 0) {
      throw ArgumentError('Surface area must be positive, got: $surfaceArea');
    }
  }

  /// Calculates the volume of the sphere.
  ///
  /// Volume = (4/3) × π × r³
  @override
  double volume() {
    return (4 / 3) * pi * pow(radius, 3);
  }

  /// Calculates the surface area of the sphere.
  ///
  /// Surface Area = 4 × π × r²
  @override
  double surfaceArea() {
    return 4 * pi * pow(radius, 2);
  }

  @override
  double area() => surfaceArea();

  /// Checks if a point is inside the sphere.
  bool contains(Point point) {
    return center.distanceTo(point) <= radius;
  }

  @override
  String toString() {
    return 'Sphere(center: $center, radius: $radius, volume: ${volume()})';
  }

  @override
  BoundingBox3D boundingBox() {
    return BoundingBox3D(
      Point(center.x - radius, center.y - radius, center.z! - radius),
      Point(center.x + radius, center.y + radius, center.z! + radius),
    );
  }
}
