part of '../geometry.dart';

/// A class representing a regular icosahedron in 3D space.
///
/// A regular icosahedron is a Platonic solid with 20 equilateral
/// triangular faces, 30 edges, and 12 vertices.
///
/// Properties:
/// - Edge: a
/// - Volume = (5(3 + √5)/12)a³
/// - Surface Area = 5√3 × a²
///
/// Example:
/// ```dart
/// var icosa = Icosahedron(edge: 5);
/// print('Volume: ${icosa.volume()}');
/// ```
class Icosahedron extends SolidGeometry {
  /// The center point of the icosahedron.
  Point center;

  /// Edge length.
  double edge;

  /// Creates a regular icosahedron with specified edge length.
  ///
  /// [edge] must be positive.
  /// [center] defaults to (0, 0, 0).
  Icosahedron({required this.edge, Point? center})
      : center = center ?? Point(0, 0, 0),
        super('Icosahedron') {
    if (edge <= 0) {
      throw ArgumentError('Edge must be positive, got: $edge');
    }
  }

  /// Creates an icosahedron from volume.
  ///
  /// Calculates edge from: a = ∛(12V / (5(3 + √5)))
  ///
  /// Example:
  /// ```dart
  /// var icosa = Icosahedron.fromVolume(volume: 80);
  /// ```
  factory Icosahedron.fromVolume({required double volume, Point? center}) {
    if (volume <= 0) throw ArgumentError('Volume must be positive');

    // V = (5(3 + √5)/12)a³, so a³ = 12V / (5(3 + √5))
    double edge = pow(12 * volume / (5 * (3 + sqrt(5))), 1 / 3).toDouble();
    return Icosahedron(edge: edge, center: center);
  }

  /// Creates an icosahedron from surface area.
  ///
  /// Calculates edge from: a = √(A / (5√3))
  ///
  /// Example:
  /// ```dart
  /// var icosa = Icosahedron.fromSurfaceArea(surfaceArea: 120);
  /// ```
  factory Icosahedron.fromSurfaceArea(
      {required double surfaceArea, Point? center}) {
    if (surfaceArea <= 0) throw ArgumentError('Surface area must be positive');

    // A = 5√3 × a², so a = √(A / (5√3))
    double edge = sqrt(surfaceArea / (5 * sqrt(3)));
    return Icosahedron(edge: edge, center: center);
  }

  /// Golden ratio constant (φ = (1 + √5)/2).
  static const double phi = 1.618033988749895;

  /// Gets the inradius (radius of inscribed sphere).
  double get inRadius => edge * phi * phi / (2 * sqrt(3));

  /// Gets the circumradius (radius of circumscribed sphere).
  double get circumRadius => edge * phi / (2 * sin(2 * pi / 5));

  /// Calculates the volume of the icosahedron.
  ///
  /// Volume = (5(3 + √5)/12)a³
  @override
  double volume() {
    return (5 * (3 + sqrt(5)) / 12) * pow(edge, 3);
  }

  /// Calculates the surface area of the icosahedron.
  ///
  /// Surface Area = 5√3 × a²
  @override
  double surfaceArea() {
    return 5 * sqrt(3) * edge * edge;
  }

  @override
  double area() => surfaceArea();

  @override
  String toString() {
    return 'Icosahedron(edge: $edge, volume: ${volume()})';
  }

  @override
  BoundingBox3D boundingBox() {
    return BoundingBox3D(
      Point(center.x - circumRadius, center.y - circumRadius,
          center.z! - circumRadius),
      Point(center.x + circumRadius, center.y + circumRadius,
          center.z! + circumRadius),
    );
  }
}
