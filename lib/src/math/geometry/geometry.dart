library geometry;

import '/advance_math.dart';

// Utils
part 'utils/geo_utils.dart';

// Common
part 'point.dart';
part 'point3d.dart';
part 'line.dart';
part 'pi.dart';

// Plane Geometry
part 'plane/plane_geometry.dart';

part 'plane/plane.dart';

part 'plane/circles/circle.dart';
part 'plane/circles/ellipse.dart';
part 'plane/circles/annulus.dart';
part 'plane/circles/sector.dart';
part 'plane/circles/segment.dart';
part 'plane/circles/arc.dart';
part 'plane/circles/error_ellipse.dart';

part 'plane/polygons/polygon.dart';

part 'plane/triangles/spherical_triangle.dart';
part 'plane/triangles/triangle.dart';
part 'plane/triangles/area_methods.dart';
part 'plane/triangles/equilateral_triangle.dart';
part 'plane/triangles/isosceles_triangle.dart';
part 'plane/triangles/scalene_triangle.dart';
part 'plane/triangles/right_triangle.dart';

part 'plane/quadrilateral/square.dart';
part 'plane/quadrilateral/rectangle.dart';
part 'plane/quadrilateral/trapezoid.dart';
part 'plane/quadrilateral/parallelogram.dart';
part 'plane/quadrilateral/rhombus.dart';

part 'plane/polygons/pentagon.dart';
part 'plane/polygons/hexagon.dart';
part 'plane/polygons/heptagon.dart';
part 'plane/polygons/octagon.dart';

// Solid Geometry
part 'solid/bounding_box_3d.dart';
part 'solid/solid_geometry.dart';

part 'solid/cube.dart';
part 'solid/sphere.dart';
part 'solid/cylinder.dart';
part 'solid/cone.dart';
part 'solid/rectangular_prism.dart';
part 'solid/ellipsoid.dart';
part 'solid/torus.dart';
part 'solid/square_pyramid.dart';
part 'solid/tetrahedron.dart';
part 'solid/triangular_prism.dart';
part 'solid/hexagonal_prism.dart';
part 'solid/octahedron.dart';
part 'solid/dodecahedron.dart';
part 'solid/icosahedron.dart';

/// An abstract class representing a general geometric shape.
abstract class Geometry {
  /// The name of the geometric shape.
  String name;

  /// Constructor for the Geometry class.
  ///
  /// Takes a [name] parameter to identify the shape.
  Geometry(this.name);

  /// Calculates the area of the geometric shape.
  ///
  /// This method should be overridden by subclasses to provide
  /// the specific area calculation for the shape.
  num area();

  /// Calculates the perimeter of the geometric shape.
  ///
  /// This method should be overridden by subclasses to provide
  /// the specific perimeter calculation for the shape.
  /// For solid geometries, this method can be overridden to return zero
  /// or throw an exception.
  num perimeter();
}
