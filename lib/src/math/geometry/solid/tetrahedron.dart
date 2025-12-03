part of '../geometry.dart';

/// A class representing a tetrahedron (triangular pyramid) in 3D space.
///
/// A tetrahedron has a triangular base and three triangular faces
/// that meet at a common apex point. A regular tetrahedron has
/// all edges of equal length.
///
/// Properties (Regular Tetrahedron):
/// - Edge: a
/// - Volume = a³/(6√2)
/// - Surface Area = √3 × a²
/// - Height = a√(2/3)
///
/// Example:
/// ```dart
/// var tetra = Tetrahedron.regular(edge: 6);
/// print('Volume: ${tetra.volume()}');
/// ```
class Tetrahedron extends SolidGeometry {
  /// The center point of the base.
  Point center;

  /// Edge length (for regular tetrahedron).
  double? edge;

  /// Base area (for general tetrahedron).
  double? baseArea;

  /// Height from base to apex.
  double height;

  /// Private constructor.
  Tetrahedron._({
    required this.height,
    this.edge,
    this.baseArea,
    Point? center,
  })  : center = center ?? Point(0, 0, 0),
        super('Tetrahedron') {
    if (height <= 0) {
      throw ArgumentError('Height must be positive, got: $height');
    }
    if (edge != null && edge! <= 0) {
      throw ArgumentError('Edge must be positive, got: $edge');
    }
    if (baseArea != null && baseArea! <= 0) {
      throw ArgumentError('Base area must be positive, got: $baseArea');
    }
  }

  /// Creates a regular tetrahedron with all edges of equal length.
  factory Tetrahedron.regular({required double edge, Point? center}) {
    double height = edge * sqrt(2.0 / 3.0);
    return Tetrahedron._(
      edge: edge,
      height: height,
      center: center,
    );
  }

  /// Creates a general tetrahedron from base area and height.
  factory Tetrahedron.fromBaseAndHeight({
    required double baseArea,
    required double height,
    Point? center,
  }) {
    return Tetrahedron._(
      baseArea: baseArea,
      height: height,
      center: center,
    );
  }

  /// Creates a regular tetrahedron from volume.
  ///
  /// Calculates edge from: a = ∛(6√2 × V)
  ///
  /// Example:
  /// ```dart
  /// var tetra = Tetrahedron.fromVolume(volume: 50);
  /// ```
  factory Tetrahedron.fromVolume({
    required double volume,
    Point? center,
  }) {
    if (volume <= 0) throw ArgumentError('Volume must be positive');

    // V = a³/(6√2), so a³ = 6√2 × V
    double edge = pow(6 * sqrt(2) * volume, 1 / 3).toDouble();
    return Tetrahedron.regular(edge: edge, center: center);
  }

  /// Creates a regular tetrahedron from surface area.
  ///
  /// Calculates edge from: a = √(A / √3)
  ///
  /// Example:
  /// ```dart
  /// var tetra = Tetrahedron.fromSurfaceArea(surfaceArea: 100);
  /// ```
  factory Tetrahedron.fromSurfaceArea({
    required double surfaceArea,
    Point? center,
  }) {
    if (surfaceArea <= 0) throw ArgumentError('Surface area must be positive');

    // A = √3 × a², so a = √(A / √3)
    double edge = sqrt(surfaceArea / sqrt(3));
    return Tetrahedron.regular(edge: edge, center: center);
  }

  /// Calculates the volume of the tetrahedron.
  ///
  /// For regular: Volume = a³/(6√2)
  /// For general: Volume = (1/3) × baseArea × height
  @override
  double volume() {
    if (edge != null) {
      // Regular tetrahedron
      return pow(edge!, 3) / (6 * sqrt(2));
    } else if (baseArea != null) {
      // General tetrahedron
      return (1 / 3) * baseArea! * height;
    }
    throw StateError('Tetrahedron must have either edge or baseArea defined');
  }

  /// Calculates the surface area of the tetrahedron.
  ///
  /// For regular: Surface Area = √3 × a²
  @override
  double surfaceArea() {
    if (edge != null) {
      // Regular tetrahedron
      return sqrt(3) * edge! * edge!;
    }
    throw StateError('Surface area calculation requires edge length');
  }

  @override
  double area() => surfaceArea();

  @override
  String toString() {
    if (edge != null) {
      return 'Tetrahedron(edge: $edge, height: $height, volume: ${volume()})';
    }
    return 'Tetrahedron(baseArea: $baseArea, height: $height, volume: ${volume()})';
  }

  @override
  BoundingBox3D boundingBox() {
    if (edge != null) {
      // For regular tetrahedron, use circumradius
      double circumR = edge! * sqrt(6) / 4;
      return BoundingBox3D(
        Point(center.x - circumR, center.y - circumR, center.z! - circumR),
        Point(center.x + circumR, center.y + circumR, center.z! + circumR),
      );
    } else {
      // For general tetrahedron, approximate from base area and height
      double baseRadius = sqrt(baseArea! / pi);
      return BoundingBox3D(
        Point(center.x - baseRadius, center.y - baseRadius, center.z!),
        Point(center.x + baseRadius, center.y + baseRadius, center.z! + height),
      );
    }
  }
}
