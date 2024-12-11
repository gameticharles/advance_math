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

void main() {
  List<Point> points = [
    Point(1, 1),
    Point(3, 3),
    Point(7, 7),
    Point(2, 7),
    Point(2, -7),
  ];

  List<Point> closest = GeoUtils.closestPair(points);

  if (closest.isNotEmpty) {
    print("Closest pair of points:");
    print("(${closest[0]}) and (${closest[1]})");
  } else {
    print("No valid closest pair found.");
  }

  printLine("Circle");
  circle();

  printLine("Ellipse");
  ellipse();

  printLine("Annulus");
  annulus();

  printLine("Triangle");
  triangle();

  printLine("Rectangle");
  rectangle();

  printLine("Square");
  square();

  printLine("Trapezoid");
  trapezoid();

  printLine("Parallelogram");
  parallelogram();
}

void triangle() {
  var tri = Triangle(a: 3, b: 4, c: 5);

  print('Area: ${tri.area()}');
  print('Perimeter: ${tri.perimeter()}');
  print('Semi-Perimeter: ${tri.s}');

  print('Circum Circle Radius: ${tri.circumCircleRadius}');
  print('inCircle Radius: ${tri.inCircleRadius}');

  print('Side A: ${tri.a}');
  print('Side B: ${tri.b}');
  print('Side C: ${tri.c}');

  print('Median A: ${tri.medianA}');
  print('Median B: ${tri.medianB}');
  print('Median C: ${tri.medianC}');

  print('Height A: ${tri.heightA}');
  print('Height B: ${tri.heightB}');
  print('Height C: ${tri.heightC}');

  print('Height 1: ${tri.height1}');
  print('Height 2: ${tri.height2}');
  print('Height 3: ${tri.height3}');

  print('Angle A: ${tri.angleA}');
  print('Angle B: ${tri.angleB}');
  print('Angle C: ${tri.angleC}');
}

void circle() {
  pi;
  var centralAngle = Angle(deg: 45); // 45 degrees in radians
  var circle = Circle.from(radius: 5, centralAngle: centralAngle);
  print('Radius: ${circle.radius}');
  print('Diameter: ${circle.diameter}');
  print('Area: ${circle.area()}');
  print('Perimeter: ${circle.perimeter()}');

  print('Arc Length: ${circle.arcLength}');
  print('Chord Length: ${circle.chordLength}');
  print('Area of Sector: ${circle.sectorArea}');
  print('Area of Segment: ${circle.segmentArea}');
  print('Distance from Center to Chord: ${circle.distanceFromCenterToChord}');
}

void ellipse() {
  var ellipse = Ellipse.from(semiMajorAxis: 6, semiMinorAxis: 5);
  print('Semi-major Axis: ${ellipse.semiMajorAxis}');
  print('Semi-minor Axis: ${ellipse.semiMinorAxis}');
  print('Area: ${ellipse.area()}');
  print('Perimeter: ${ellipse.perimeter()}');
  print('Foci: ${ellipse.foci()}');
  print('Eccentricity: ${ellipse.eccentricity()}');
  print('Directrices: ${ellipse.directrices()}');
  print('Latus Rectum: ${ellipse.latusRectum()}');
  print('');

  // Example 1: Create an ellipse with given semi-major and semi-minor axes
  Ellipse ellipse1 = Ellipse(5, 3, center: Point(2, 2));
  print(ellipse1);
  print('Area: ${ellipse1.area()}');
  print('Perimeter: ${ellipse1.perimeter()}');
  print('Eccentricity: ${ellipse1.eccentricity()}');

  double theta = pi / 4; // 45 degrees
  print('Curvature at theta = $theta: ${ellipse1.curvature(theta)}');
  print('Equation of the ellipse: ${ellipse1.equation()}');

  // Example 2: Calculate the distance from a point to the ellipse
  Point p = Point(7, 2);
  print('Distance from point $p to ellipse1: ${ellipse1.distanceFromPoint(p)}');

  // Example 3: Calculate the arc length between two angles
  double theta1 = 0;
  double theta2 = pi / 2;
  print(
      'Arc length of ellipse1 from $theta1 to $theta2: ${ellipse1.arcLength(theta1, theta2)}');
  print('');
  print(
      'Distance from Center to Foci(Focal Distance): ${ellipse1.focalDistance()}');
  print('Distance between the two Foci: ${ellipse1.distanceBetweenFoci()}');

  print('Foci: ${ellipse1.foci()}');
  print('Vertexes: ${ellipse1.vertexes()}');
  print('Co-Vertexes: ${ellipse1.coVertexes()}');

  print('Directrices: ${ellipse1.directrices()}');
  print('Domain: ${ellipse1.domain()}');
  print('Range: ${ellipse1.range()}');
  print('Latus Rectum: ${ellipse1.latusRectum()}');
  print('Latus Rectum Points: ${ellipse1.latusRectumPoints()}');
}

void annulus() {
  var area = 84;
  var width = 5;
  // Example usage for innerRadius
  var innerRadius = Annulus.computeInnerRadius(
    //outerRadius: 6,
    //sectorInteriorCircumference: 4.5,
    //centralAngle: pi / 4,
    area: area,
    width: width,
  );

  print('Inner Radius: $innerRadius');

  var outerRadius = Annulus.computeOuterRadius(
    // innerRadius: 3,
    // sectorExteriorCircumference: 4.5,
    // centralAngle: pi / 4,
    area: area,
    width: width,
  );
  print('Outer Radius: $outerRadius');

  var phi1 = Annulus.computeCentralAngle(
    innerRadius: innerRadius,
    outerRadius: outerRadius,
    //sectorExteriorCircumference: 4.5,
    area: area,
    sectorArea: 21 / 7,
  );
  print('Central Angle (phi): $phi1');
  print("");
  var annulus = Annulus.from(
    // area: 50,
    // perimeter: 50,
    width: 6,
    center: Point(2, 2),
    // outerRadius: 5,
    // innerRadius: 3,
    centralAngle: Angle(deg: 30),
    sectorPerimeter: 50,
    sectorArea: 50,
  );
  print(annulus);

  print('Outer Radius Circle: ${annulus.outerRadius}');
  print('Inner Radius Circle: ${annulus.innerRadius}');
  print('Annulus Mean Radius: ${annulus.meanRadius}');
  print('Annulus Mean Diameter: ${annulus.meanDiameter}');
  print('Annulus Exterior Diameter: ${annulus.exteriorDiameter}');
  print('Annulus Interior Diameter: ${annulus.interiorDiameter}');
  print("");
  print('Central Angle: ${annulus.centralAngle}');
  print('Annulus Width: ${annulus.width}');
  print('Annulus Area: ${annulus.area()}');
  print('Annulus Perimeter: ${annulus.perimeter()}');
  print("");
  print('Interior Circumference: ${annulus.interiorCircumference}');
  print('Exterior Circumference: ${annulus.exteriorCircumference}');
  print("");
  print('Sector Area: ${annulus.sectorArea}');
  print('Sector Perimeter: ${annulus.sectorPerimeter}');
  print(
      'Sector Exterior Circumference: ${annulus.sectorExteriorCircumference}');
  print(
      'Sector Interior Circumference: ${annulus.sectorInteriorCircumference}');
  print('Sector Diagonal: ${annulus.sectorDiagonal}');
}

void rectangle() {
  // Example for Rectangle
  Rectangle rectangle = Rectangle.from(length: 5, width: 3);
  print('Rectangle Area: ${rectangle.area()}');
  print('Rectangle Perimeter: ${rectangle.perimeter()}');
  print('Rectangle Diagonal: ${rectangle.diagonal()}');
  print('Perimeter Ratio: ${rectangle.perimeterRatio()}');
  print('Aspect Ratio: ${rectangle.aspectRatio()}');
  print('Angles Between Diagonal: ${rectangle.anglesBetweenDiagonals()}');
}

void square() {
  // Example for Square
  Square square = Square.from(side: 5);
  print('Square Area: ${square.area()}');
  print('Square Perimeter: ${square.perimeter()}');
  print('Square Diagonal: ${square.diagonal()}');
  print('Angle Between Diagonal: ${square.angleBetweenDiagonals()}');
  print('InRadius: ${square.inRadius}');
  print('CircumRadius: ${square.circumRadius}');
}

void trapezoid() {
  // Example 1: Create a trapezoid using base1, base2, and height
  var trapezoid1 = Trapezoid.from(base1: 5, base2: 3, height: 4);
  print('Trapezoid 1');
  print('Base 1: ${trapezoid1.base1}');
  print('Base 2: ${trapezoid1.base2}');
  print('Side 1: ${trapezoid1.side1}');
  print('Side 2: ${trapezoid1.side2}');
  print('Height: ${trapezoid1.height}');
  print('Area: ${trapezoid1.area()}');
  print('Perimeter: ${trapezoid1.perimeter()}');
  print('Diagonals: ${trapezoid1.diagonals()}');
  print('Angles: ${trapezoid1.angles()}');
}

void parallelogram() {
  // Example for Parallelogram
  // Example 1: Create a parallelogram using base, side, and angle
  var parallelogram1 = Parallelogram(5, 3, angle1: pi / 4);
  print('Parallelogram 1');
  print('Base: ${parallelogram1.base}');
  print('Side: ${parallelogram1.side}');
  print('Area: ${parallelogram1.area()}');
  print('Perimeter: ${parallelogram1.perimeter()}');
  print('Height 1: ${parallelogram1.height1}');
  print('Height 2: ${parallelogram1.height2}');
  print('Diagonal 1: ${parallelogram1.diagonal1()}');
  print('Diagonal 2: ${parallelogram1.diagonal2()}');
  print(
      'Angles between diagonals (radians): ${parallelogram1.anglesBetweenDiagonals()}');
  print('Angles (radians): ${parallelogram1.angles()}');
  print(
      'Diagonals correlation verified: ${parallelogram1.verifyDiagonalsCorrelation()}');
  print('');

  // Example 2: Create a parallelogram using base, side and height
  var parallelogram2 = Parallelogram.from(base: 5, side: 3, height1: 2.12);
  print('Parallelogram 2');
  print('Base: ${parallelogram2.base}');
  print('Side: ${parallelogram2.side}');
  print('Area: ${parallelogram2.area()}');
  print('Height 1: ${parallelogram1.height1}');
  print('Height 2: ${parallelogram1.height2}');
  print('Diagonal 1: ${parallelogram2.diagonal1()}');
  print('Diagonal 2: ${parallelogram2.diagonal2()}');
  print(
      'Angles between diagonals (radians): ${parallelogram2.anglesBetweenDiagonals()}');
  print('Angles (radians): ${parallelogram2.angles()}');
  print(
      'Diagonals correlation verified: ${parallelogram2.verifyDiagonalsCorrelation()}');
  print('');

  // // Example 3: Create a parallelogram using area,side and base
  // var parallelogram3 = Parallelogram.from(area: 15, side: 6, base: 5);
  // print('Parallelogram 3');
  // print('Base: ${parallelogram3.base}');
  // print('Side: ${parallelogram3.side}');
  // print('Angle (radians): ${parallelogram3.angle}');
  // print('Area: ${parallelogram3.area()}');
  // print('Perimeter: ${parallelogram3.perimeter()}');
  // print('Height 1: ${parallelogram3.height1()}');
  // print('Height 2: ${parallelogram3.height2()}');
  // print('Diagonal 1: ${parallelogram3.diagonal1()}');
  // print('Diagonal 2: ${parallelogram3.diagonal2()}');
  // print(
  //     'Angles between diagonals (radians): ${parallelogram3.anglesBetweenDiagonals()}');
  // print('Angles (radians): ${parallelogram3.angles()}');
  // print(
  //     'Diagonals correlation verified: ${parallelogram3.verifyDiagonalsCorrelation()}');
  // print('');

  // Example 4: Create a parallelogram using perimeter and side
  var parallelogram4 = Parallelogram.from(perimeter: 16, side: 3, area: 15);
  print('Parallelogram 4');
  print('Base: ${parallelogram4.base}');
  print('Side: ${parallelogram4.side}');
  print('Area: ${parallelogram4.area()}');
  print('Perimeter: ${parallelogram4.perimeter()}');
  print('Height 1: ${parallelogram4.height1}');
  print('Height 2: ${parallelogram4.height2}');
  print('Diagonal 1: ${parallelogram4.diagonal1()}');
  print('Diagonal 2: ${parallelogram4.diagonal2()}');
  print(
      'Angles between diagonals (radians): ${parallelogram4.anglesBetweenDiagonals()}');
  print('Angles (radians): ${parallelogram4.angles()}');
  print(
      'Diagonals correlation verified: ${parallelogram4.verifyDiagonalsCorrelation()}');
  print('');
}
