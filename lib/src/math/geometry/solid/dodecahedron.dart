part of '../geometry.dart';

/// A class representing a regular dodecahedron in 3D space.
///
/// A regular dodecahedron is a Platonic solid with 12 regular
/// pentagonal faces, 30 edges, and 20 vertices.
///
/// Properties:
/// - Edge: a
/// - Volume = ((15 + 7√5)/4)a³
/// - Surface Area = 3√(25 + 10√5) × a²
///
/// Example:
/// ```dart
/// var dodeca = Dodecahedron(edge: 4);
/// print('Volume: ${dodeca.volume()}');
/// ```
class Dodecahedron extends SolidGeometry {
  /// The center point of the dodecahedron.
  Point center;

  /// Edge length.
  double edge;

  /// Creates a regular dodecahedron with specified edge length.
  ///
  /// [edge] must be positive.
  /// [center] defaults to (0, 0, 0).
  Dodecahedron({required this.edge, Point? center})
      : center = center ?? Point(0, 0, 0),
        super('Dodecahedron') {
    if (edge <= 0) {
      throw ArgumentError('Edge must be positive, got: $edge');
    }
  }

  /// Creates a dodecahedron from volume.
  ///
  /// Calculates edge from: a = ∛(4V / (15 + 7√5))
  ///
  /// Example:
  /// ```dart
  /// var dodeca = Dodecahedron.fromVolume(volume: 100);
  /// ```
  factory Dodecahedron.fromVolume({required double volume, Point? center}) {
    if (volume <= 0) throw ArgumentError('Volume must be positive');

    // V = ((15 + 7√5)/4)a³, so a³ = 4V / (15 + 7√5)
    double edge = pow(4 * volume / (15 + 7 * sqrt(5)), 1 / 3).toDouble();
    return Dodecahedron(edge: edge, center: center);
  }

  /// Creates a dodecahedron from surface area.
  ///
  /// Calculates edge from: a = √(A / (3√(25 + 10√5)))
  ///
  /// Example:
  /// ```dart
  /// var dodeca = Dodecahedron.fromSurfaceArea(surfaceArea: 150);
  /// ```
  factory Dodecahedron.fromSurfaceArea(
      {required double surfaceArea, Point? center}) {
    if (surfaceArea <= 0) throw ArgumentError('Surface area must be positive');

    // A = 3√(25 + 10√5) × a², so a = √(A / (3√(25 + 10√5)))
    double edge = sqrt(surfaceArea / (3 * sqrt(25 + 10 * sqrt(5))));
    return Dodecahedron(edge: edge, center: center);
  }

  /// Golden ratio constant (φ = (1 + √5)/2).
  static const double phi = 1.618033988749895;

  /// Gets the inradius (radius of inscribed sphere).
  double get inRadius => edge * phi * sqrt(3) / 2;

  /// Gets the circumradius (radius of circumscribed sphere).
  double get circumRadius => edge * phi * sqrt(3) / 2 * sqrt((3 + sqrt(5)) / 2);

  /// Calculates the volume of the dodecahedron.
  ///
  /// Volume = ((15 + 7√5)/4)a³
  @override
  double volume() {
    return ((15 + 7 * sqrt(5)) / 4) * pow(edge, 3);
  }

  /// Calculates the surface area of the dodecahedron.
  ///
  /// Surface Area = 3√(25 + 10√5) × a²
  @override
  double surfaceArea() {
    return 3 * sqrt(25 + 10 * sqrt(5)) * edge * edge;
  }

  @override
  double area() => surfaceArea();

  @override
  String toString() {
    return 'Dodecahedron(edge: $edge, volume: ${volume()})';
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
