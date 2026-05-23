part of '../geometry.dart';

/// A class representing a hemisphere (half of a sphere) in 3D space.
///
/// A hemisphere is a 3D geometric shape bounded by a circular base and a spherical cap.
class Hemisphere extends SolidGeometry {
  /// The center of the circular base.
  final Point center;

  /// The radius of the hemisphere.
  final double radius;

  /// Creates a hemisphere with the specified radius and base center.
  Hemisphere(this.radius, {Point? center})
      : center = center ?? Point(0, 0, 0),
        super('Hemisphere') {
    if (radius <= 0) {
      throw ArgumentError('Radius must be positive, got: $radius');
    }
  }

  /// Calculates the volume of the hemisphere.
  ///
  /// Volume = (2/3) × π × r³
  @override
  double volume() {
    return (2.0 / 3.0) * pi * dmath.pow(radius, 3);
  }

  /// Calculates the total surface area of the hemisphere.
  ///
  /// Total Surface Area = Curved Surface Area + Base Area = 3 × π × r²
  @override
  double surfaceArea() {
    return 3.0 * pi * radius * radius;
  }

  /// Calculates the curved (dome) surface area of the hemisphere.
  ///
  /// Curved Area = 2 × π × r²
  double curvedSurfaceArea() {
    return 2.0 * pi * radius * radius;
  }

  /// Calculates the area of the circular base.
  ///
  /// Base Area = π × r²
  double baseArea() {
    return pi * radius * radius;
  }

  @override
  double area() => surfaceArea();

  @override
  BoundingBox3D boundingBox() {
    return BoundingBox3D(
      Point(center.x - radius, center.y - radius, center.z!),
      Point(center.x + radius, center.y + radius, center.z! + radius),
    );
  }

  @override
  String toString() {
    return 'Hemisphere(center: $center, radius: $radius, volume: ${volume()}, surfaceArea: ${surfaceArea()})';
  }
}
