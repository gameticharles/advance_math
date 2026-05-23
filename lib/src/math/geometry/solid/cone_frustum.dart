part of '../geometry.dart';

/// A class representing a frustum of a cone (a truncated cone) in 3D space.
class ConeFrustum extends SolidGeometry {
  /// The center of the bottom base circle.
  final Point center;

  /// The radius of the bottom circular base.
  final double baseRadius;

  /// The radius of the top circular base.
  final double topRadius;

  /// The height of the frustum.
  final double height;

  /// Creates a frustum of a cone with specified base radius, top radius, height, and optional center of bottom base.
  ConeFrustum(this.baseRadius, this.topRadius, this.height, {Point? center})
      : center = center ?? Point(0, 0, 0),
        super('ConeFrustum') {
    if (baseRadius <= 0) {
      throw ArgumentError('Base radius must be positive, got: $baseRadius');
    }
    if (topRadius <= 0) {
      throw ArgumentError('Top radius must be positive, got: $topRadius');
    }
    if (height <= 0) {
      throw ArgumentError('Height must be positive, got: $height');
    }
  }

  /// Calculates the slant height of the frustum.
  ///
  /// Slant Height = √(height² + (baseRadius - topRadius)²)
  double get slantHeight {
    final diff = baseRadius - topRadius;
    return dmath.sqrt(height * height + diff * diff);
  }

  /// Calculates the volume of the frustum of a cone.
  ///
  /// Volume = (1/3) × π × h × (R² + R×r + r²)
  @override
  double volume() {
    return (1.0 / 3.0) * pi * height * (baseRadius * baseRadius + baseRadius * topRadius + topRadius * topRadius);
  }

  /// Calculates the total surface area of the frustum of a cone.
  ///
  /// Surface Area = Lateral Area + Bottom Base Area + Top Base Area
  /// Lateral Area = π × s × (R + r)
  @override
  double surfaceArea() {
    final lateralArea = pi * slantHeight * (baseRadius + topRadius);
    final bottomArea = pi * baseRadius * baseRadius;
    final topArea = pi * topRadius * topRadius;
    return lateralArea + bottomArea + topArea;
  }

  /// Calculates the lateral (curved) surface area of the frustum of a cone.
  double lateralSurfaceArea() {
    return pi * slantHeight * (baseRadius + topRadius);
  }

  @override
  double area() => surfaceArea();

  @override
  BoundingBox3D boundingBox() {
    final maxRadius = dmath.max(baseRadius, topRadius);
    return BoundingBox3D(
      Point(center.x - maxRadius, center.y - maxRadius, center.z!),
      Point(center.x + maxRadius, center.y + maxRadius, center.z! + height),
    );
  }

  @override
  String toString() {
    return 'ConeFrustum(center: $center, baseRadius: $baseRadius, topRadius: $topRadius, height: $height, slantHeight: $slantHeight, volume: ${volume()}, surfaceArea: ${surfaceArea()})';
  }
}
