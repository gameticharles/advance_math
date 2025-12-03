part of '../geometry.dart';

/// A class representing a cube in 3D space.
class Cube extends SolidGeometry {
  /// The center point of the cube.
  Point center;

  /// The length of each side of the cube.
  double sideLength;

  /// Constructor for the Cube class.
  ///
  /// Takes a [sideLength] and an optional [center] point.
  /// If no center is provided, it defaults to (0, 0, 0).
  Cube(this.sideLength, {Point? center})
      : center = center ?? Point(0, 0, 0),
        super("Cube");

  /// Constructor for the Cube class from volume.
  ///
  /// Takes a [volume] and an optional [center] point.
  /// If no center is provided, it defaults to (0, 0, 0).
  Cube.fromVolume(double volume, {Point? center})
      : center = center ?? Point(0, 0, 0),
        sideLength = pow(volume, 1 / 3).toDouble(),
        super("Cube");

  /// Constructor for the Cube class from surface area.
  ///
  /// Takes a [surfaceArea] and an optional [center] point.
  /// If no center is provided, it defaults to (0, 0, 0).
  Cube.fromSurfaceArea(double surfaceArea, {Point? center})
      : center = center ?? Point(0, 0, 0),
        sideLength = sqrt(surfaceArea / 6).toDouble(),
        super("Cube");

  @override
  double volume() {
    return sideLength * sideLength * sideLength;
  }

  @override
  double surfaceArea() {
    return 6 * sideLength * sideLength;
  }

  @override
  double area() => surfaceArea();

  /// Calculates and returns the vertices of the cube.
  ///
  /// The vertices are calculated based on the center and side length.
  List<Point> vertices() {
    double halfSide = sideLength / 2;
    List<Point> vertices = [];

    // Generate vertices based on the center and side length
    vertices.add(
        Point(center.x + halfSide, center.y + halfSide, center.z! + halfSide));
    vertices.add(
        Point(center.x + halfSide, center.y + halfSide, center.z! - halfSide));
    vertices.add(
        Point(center.x + halfSide, center.y - halfSide, center.z! + halfSide));
    vertices.add(
        Point(center.x + halfSide, center.y - halfSide, center.z! - halfSide));
    vertices.add(
        Point(center.x - halfSide, center.y + halfSide, center.z! + halfSide));
    vertices.add(
        Point(center.x - halfSide, center.y + halfSide, center.z! - halfSide));
    vertices.add(
        Point(center.x - halfSide, center.y - halfSide, center.z! + halfSide));
    vertices.add(
        Point(center.x - halfSide, center.y - halfSide, center.z! - halfSide));

    return vertices;
  }

  /// Calculates and returns the edges of the cube.
  ///
  /// The edges are calculated based on the vertices of the cube.
  List<Line> edges() {
    List<Point> verts = vertices();
    List<Line> edges = [];

    edges.add(Line(p1: verts[0], p2: verts[1]));
    edges.add(Line(p1: verts[0], p2: verts[2]));
    edges.add(Line(p1: verts[0], p2: verts[4]));
    edges.add(Line(p1: verts[1], p2: verts[3]));
    edges.add(Line(p1: verts[1], p2: verts[5]));
    edges.add(Line(p1: verts[2], p2: verts[3]));
    edges.add(Line(p1: verts[2], p2: verts[6]));
    edges.add(Line(p1: verts[3], p2: verts[7]));
    edges.add(Line(p1: verts[4], p2: verts[5]));
    edges.add(Line(p1: verts[4], p2: verts[6]));
    edges.add(Line(p1: verts[5], p2: verts[7]));
    edges.add(Line(p1: verts[6], p2: verts[7]));

    return edges;
  }

  /// Calculates and returns the space diagonals of the cube.
  ///
  /// The space diagonals are calculated based on the vertices of the cube.
  List<Line> spaceDiagonals() {
    List<Point> verts = vertices();
    List<Line> diagonals = [];

    // Define space diagonals based on vertices
    diagonals.add(Line(p1: verts[0], p2: verts[7]));
    diagonals.add(Line(p1: verts[1], p2: verts[6]));
    diagonals.add(Line(p1: verts[2], p2: verts[5]));
    diagonals.add(Line(p1: verts[3], p2: verts[4]));

    return diagonals;
  }

  @override
  BoundingBox3D boundingBox() {
    double halfSide = sideLength / 2;
    return BoundingBox3D(
      Point(center.x - halfSide, center.y - halfSide, center.z! - halfSide),
      Point(center.x + halfSide, center.y + halfSide, center.z! + halfSide),
    );
  }
}
