part of '../geometry.dart';

/// A class representing a hollow cylinder (cylindrical shell) in 3D space.
class HollowCylinder extends SolidGeometry {
  /// The center of the bottom base circle.
  final Point center;

  /// The outer radius of the cylinder.
  final double outerRadius;

  /// The inner radius of the cylinder.
  final double innerRadius;

  /// The height of the cylinder.
  final double height;

  /// Creates a hollow cylinder with specified outer radius, inner radius, height, and optional center of bottom base.
  HollowCylinder(this.outerRadius, this.innerRadius, this.height,
      {Point? center})
      : center = center ?? Point(0, 0, 0),
        super('HollowCylinder') {
    if (outerRadius <= 0) {
      throw ArgumentError('Outer radius must be positive, got: $outerRadius');
    }
    if (innerRadius < 0) {
      throw ArgumentError(
          'Inner radius must be non-negative, got: $innerRadius');
    }
    if (innerRadius >= outerRadius) {
      throw ArgumentError('Inner radius must be less than outer radius.');
    }
    if (height <= 0) {
      throw ArgumentError('Height must be positive, got: $height');
    }
  }

  /// Calculates the volume of the hollow cylinder.
  ///
  /// Volume = π × h × (R² - r²)
  @override
  double volume() {
    return pi *
        height *
        (outerRadius * outerRadius - innerRadius * innerRadius);
  }

  /// Calculates the total surface area of the hollow cylinder.
  ///
  /// Total Surface Area = Inner Lateral Area + Outer Lateral Area + Top Ring Area + Bottom Ring Area
  /// Formula: 2 × π × (R + r) × h + 2 × π × (R² - r²)
  @override
  double surfaceArea() {
    final lateralArea = 2.0 * pi * (outerRadius + innerRadius) * height;
    final ringArea =
        2.0 * pi * (outerRadius * outerRadius - innerRadius * innerRadius);
    return lateralArea + ringArea;
  }

  /// Calculates the wall thickness of the hollow cylinder.
  double get wallThickness => outerRadius - innerRadius;

  @override
  double area() => surfaceArea();

  @override
  BoundingBox3D boundingBox() {
    return BoundingBox3D(
      Point(center.x - outerRadius, center.y - outerRadius, center.z!),
      Point(center.x + outerRadius, center.y + outerRadius, center.z! + height),
    );
  }

  @override
  String toString() {
    return 'HollowCylinder(center: $center, outerRadius: $outerRadius, innerRadius: $innerRadius, height: $height, volume: ${volume()}, surfaceArea: ${surfaceArea()})';
  }
}
