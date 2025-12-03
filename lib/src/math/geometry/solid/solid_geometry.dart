part of '../geometry.dart';

/**
  Solid (3D) Geometries
    Sphere
    Ellipsoid
    Polyhedron
      Tetrahedron
      Cube (Hexahedron)
      Octahedron
      Dodecahedron
      Icosahedron
    Prism
      Rectangular Prism (Cuboid)
      Triangular Prism
      Hexagonal Prism
    Pyramid
      Square Pyramid
      Triangular Pyramid
    Cylinder
    Cone
    Torus
 */

/// An abstract class representing a 3D geometric shape.
abstract class SolidGeometry extends Geometry {
  /// Constructor for the SolidGeometry class.
  ///
  /// Takes a [name] parameter to identify the shape.
  SolidGeometry(super.name);

  /// Calculates the volume of the 3D geometric shape.
  ///
  /// This method must be implemented by subclasses to provide
  /// the specific volume calculation for the shape.
  double volume();

  /// Calculates the surface area of the 3D geometric shape.
  ///
  /// This method must be implemented by subclasses to provide
  /// the specific surface area calculation for the shape.
  double surfaceArea();

  /// Calculates the axis-aligned bounding box (AABB) of the 3D shape.
  ///
  /// Returns a [BoundingBox3D] that fully contains the shape.
  /// The bounding box is aligned with the coordinate axes.
  ///
  /// This method must be implemented by subclasses.
  BoundingBox3D boundingBox();

  /// Calculates the perimeter of the 3D geometric shape.
  ///
  /// For solid geometries, this method is not applicable and will
  /// throw an [UnimplementedError] by default.
  @override
  double perimeter() =>
      throw UnimplementedError('Solid geometries do not have a perimeter');
}
