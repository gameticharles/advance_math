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

part 'plane/polygon.dart';

part 'plane/triangles/spherical_triangle.dart';
part 'plane/triangles/triangle.dart';
part 'plane/triangles/area_methods.dart';

part 'plane/quadrilateral/square.dart';
part 'plane/quadrilateral/rectangle.dart';
part 'plane/quadrilateral/trapezoid.dart';
part 'plane/quadrilateral/parallelogram.dart';
part 'plane/quadrilateral/rhombus.dart';

// Solid Geometry
part 'solid/solid_geometry.dart';

part 'solid/cube.dart';

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
