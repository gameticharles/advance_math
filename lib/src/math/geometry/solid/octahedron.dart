part of '../geometry.dart';

/// A class representing a regular octahedron in 3D space.
///
/// A regular octahedron is a Platonic solid with 8 equilateral
/// triangular faces, 12 edges, and 6 vertices. It can be thought
/// of as two square pyramids joined at their bases.
///
/// Properties:
/// - Edge: a
/// - Volume = (√2/3)a³
/// - Surface Area = 2√3 × a²
/// - Height = a√2
///
/// Example:
/// ```dart
/// var octa = Octahedron(edge: 6);
/// print('Volume: ${octa.volume()}');
/// ```
class Octahedron extends SolidGeometry {
  /// The center point of the octahedron.
  Point center;

  /// Edge length.
  double edge;

  /// Creates a regular octahedron with specified edge length.
  ///
  /// [edge] must be positive.
  /// [center] defaults to (0, 0, 0).
  Octahedron({required this.edge, Point? center})
      : center = center ?? Point(0, 0, 0),
        super('Octahedron') {
    if (edge <= 0) {
      throw ArgumentError('Edge must be positive, got: $edge');
    }
  }

  /// Creates an octahedron from volume.
  ///
  /// Calculates edge from: a = ∛(3V / √2)
  ///
  /// Example:
  /// ```dart
  /// var octa = Octahedron.fromVolume(volume: 50);
  /// ```
  factory Octahedron.fromVolume({required double volume, Point? center}) {
    if (volume <= 0) throw ArgumentError('Volume must be positive');

    // V = (√2/3)a³, so a³ = 3V/√2
    double edge = pow(3 * volume / sqrt(2), 1 / 3).toDouble();
    return Octahedron(edge: edge, center: center);
  }

  /// Creates an octahedron from surface area.
  ///
  /// Calculates edge from: a = √(A / (2√3))
  ///
  /// Example:
  /// ```dart
  /// var octa = Octahedron.fromSurfaceArea(surfaceArea: 100);
  /// ```
  factory Octahedron.fromSurfaceArea(
      {required double surfaceArea, Point? center}) {
    if (surfaceArea <= 0) throw ArgumentError('Surface area must be positive');

    // A = 2√3 × a², so a = √(A / (2√3))
    double edge = sqrt(surfaceArea / (2 * sqrt(3)));
    return Octahedron(edge: edge, center: center);
  }

  /// Creates an octahedron from inradius.
  ///
  /// Calculates edge from: a = inradius × √6
  ///
  /// Example:
  /// ```dart
  /// var octa = Octahedron.fromInradius(inradius: 2);
  /// ```
  factory Octahedron.fromInradius({required double inradius, Point? center}) {
    if (inradius <= 0) throw ArgumentError('Inradius must be positive');

    double edge = inradius * sqrt(6);
    return Octahedron(edge: edge, center: center);
  }

  /// Creates an octahedron from circumradius.
  ///
  /// Calculates edge from: a = circumradius × √2
  ///
  /// Example:
  /// ```dart
  /// var octa = Octahedron.fromCircumradius(circumradius: 3);
  /// ```
  factory Octahedron.fromCircumradius(
      {required double circumradius, Point? center}) {
    if (circumradius <= 0) throw ArgumentError('Circumradius must be positive');

    double edge = circumradius * sqrt(2);
    return Octahedron(edge: edge, center: center);
  }

  /// Gets the height of the octahedron.
  ///
  /// Height = a√2
  double get height => edge * sqrt(2);

  /// Gets the inradius (radius of inscribed sphere).
  double get inRadius => edge * sqrt(6) / 6;

  /// Gets the circumradius (radius of circumscribed sphere).
  double get circumRadius => edge * sqrt(2) / 2;

  /// Calculates the volume of the octahedron.
  ///
  /// Volume = (√2/3)a³
  @override
  double volume() {
    return (sqrt(2) / 3) * pow(edge, 3);
  }

  /// Calculates the surface area of the octahedron.
  ///
  /// Surface Area = 2√3 × a²
  @override
  double surfaceArea() {
    return 2 * sqrt(3) * edge * edge;
  }

  @override
  double area() => surfaceArea();

  @override
  String toString() {
    return 'Octahedron(edge: $edge, volume: ${volume()})';
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
