part of '../geometry.dart';

/**
  Plane (2D) Geometries
    Circle
    Ellipse
    Annulus
    Triangle
      Equilateral Triangle
      Isosceles Triangle
      Scalene Triangle
      Right Triangle
    Quadrilateral
      Square
      Rectangle
      Rhombus
      Parallelogram
      Trapezoid
    Polygon
      Regular Polygon (e.g., pentagon, hexagon)
      Irregular Polygon
 */

/// An abstract class representing a 2D geometric shape.
abstract class PlaneGeometry extends Geometry {
  /// Constructor for the PlaneGeometry class.
  ///
  /// Takes a [name] parameter to identify the shape.
  PlaneGeometry(String name) : super(name);

  /// Calculates the area of the 2D geometric shape.
  ///
  /// This method must be implemented by subclasses to provide
  /// the specific area calculation for the shape.
  @override
  num area();

  /// Calculates the perimeter of the 2D geometric shape.
  ///
  /// This method must be implemented by subclasses to provide
  /// the specific perimeter calculation for the shape.
  @override
  num perimeter();
}
