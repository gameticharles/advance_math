part of '../../geometry.dart';

/// A class representing a sector of an annulus (a ring-like sector).
///
/// An annulus sector is bounded by two concentric circular arcs of different radii and two radial boundaries.
class AnnulusSector extends PlaneGeometry {
  /// The inner radius of the annulus sector.
  final double innerRadius;

  /// The outer radius of the annulus sector.
  final double outerRadius;

  /// The central angle of the sector in radians.
  final Angle centralAngle;

  /// Center point of the annulus sector.
  final Point center;

  /// Constructs an AnnulusSector with given inner and outer radii and a central angle.
  AnnulusSector({
    required double innerRadius,
    required double outerRadius,
    required this.centralAngle,
    Point? center,
  })  : innerRadius = innerRadius,
        outerRadius = outerRadius,
        center = center ?? Point(0, 0),
        super("AnnulusSector") {
    if (innerRadius < 0 || outerRadius < 0) {
      throw ArgumentError('Radii must be non-negative.');
    }
    if (innerRadius >= outerRadius) {
      throw ArgumentError('Inner radius must be less than outer radius.');
    }
  }

  /// Calculates the area of the Annulus Sector.
  ///
  /// Formula: centralAngle * (outerRadius^2 - innerRadius^2) / 2
  @override
  double area() {
    return centralAngle.rad *
        (outerRadius * outerRadius - innerRadius * innerRadius) /
        2;
  }

  /// Calculates the perimeter of the Annulus Sector.
  ///
  /// Formula: centralAngle * (outerRadius + innerRadius) + 2 * (outerRadius - innerRadius)
  @override
  double perimeter() {
    return centralAngle.rad * (outerRadius + innerRadius) +
        2.0 * (outerRadius - innerRadius);
  }

  /// Calculates the breadth (width) of the annulus sector.
  double get width => outerRadius - innerRadius;

  /// Returns the length of the outer circular arc.
  double get exteriorArcLength => centralAngle.rad * outerRadius;

  /// Returns the length of the inner circular arc.
  double get interiorArcLength => centralAngle.rad * innerRadius;

  @override
  String toString() {
    return 'AnnulusSector(innerRadius: $innerRadius, outerRadius: $outerRadius, angle: ${centralAngle.rad} rad, area: ${area()}, perimeter: ${perimeter()})';
  }
}
