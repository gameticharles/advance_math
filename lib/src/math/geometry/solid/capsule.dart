part of '../geometry.dart';

/// A class representing a capsule (a cylinder capped with two hemispheres) in 3D space.
class Capsule extends SolidGeometry {
  /// The center point of the capsule.
  final Point center;

  /// The radius of the cylindrical portion and hemispherical caps.
  final double radius;

  /// The height of the cylindrical portion (excluding caps).
  final double cylinderHeight;

  /// Creates a capsule with the specified radius, cylinder height, and center.
  Capsule(this.radius, this.cylinderHeight, {Point? center})
      : center = center ?? Point(0, 0, 0),
        super('Capsule') {
    if (radius <= 0) {
      throw ArgumentError('Radius must be positive, got: $radius');
    }
    if (cylinderHeight <= 0) {
      throw ArgumentError(
          'Cylinder height must be positive, got: $cylinderHeight');
    }
  }

  /// Calculates the volume of the capsule.
  ///
  /// Volume = Volume of Cylinder + Volume of Sphere = π × r² × h + (4/3) × π × r³
  @override
  double volume() {
    return pi * radius * radius * cylinderHeight +
        (4.0 / 3.0) * pi * dmath.pow(radius, 3);
  }

  /// Calculates the total surface area of the capsule.
  ///
  /// Surface Area = Lateral Area of Cylinder + Surface Area of Sphere = 2 × π × r × h + 4 × π × r²
  @override
  double surfaceArea() {
    return 2.0 * pi * radius * cylinderHeight + 4.0 * pi * radius * radius;
  }

  @override
  double area() => surfaceArea();

  /// Calculates the total height of the capsule (including hemispherical caps).
  double get totalHeight => cylinderHeight + 2 * radius;

  @override
  BoundingBox3D boundingBox() {
    final halfHeight = cylinderHeight / 2.0;
    final totalReach = halfHeight + radius;
    return BoundingBox3D(
      Point(center.x - radius, center.y - radius, center.z! - totalReach),
      Point(center.x + radius, center.y + radius, center.z! + totalReach),
    );
  }

  @override
  String toString() {
    return 'Capsule(center: $center, radius: $radius, cylinderHeight: $cylinderHeight, totalHeight: $totalHeight, volume: ${volume()}, surfaceArea: ${surfaceArea()})';
  }
}
