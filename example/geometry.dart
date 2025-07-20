import 'package:advance_math/advance_math.dart';

main() {
  var p = Polygon(vertices: [
    Point(591.40, 591.40),
    Point(652.40, 542.70),
    Point(783.50, 529.00),
    Point(896.20, 612.80),
    Point(810.90, 713.40),
    Point(685.90, 756.00),
    Point(562.50, 632.60)
  ]);

  print(p.shoelace());
  print(p.trapezoidal());

  // Example usage:
  Point centerPoint = Point(1, 2, 3);

  Cube cube1 = Cube(5.0, center: centerPoint);
  Cube cube2 = Cube.fromVolume(125, center: centerPoint);
  Cube cube3 = Cube.fromSurfaceArea(center: centerPoint, 150);

  print('Cube 1:');
  print('Vertices:');
  cube1.vertices().forEach((vertex) => print(vertex));
  print('Edges:');
  cube1.edges().forEach((edge) => print(edge));
  print('Space Diagonals:');
  cube1.spaceDiagonals().forEach((diagonal) => print(diagonal));
  print('Volume: ${cube1.volume()} cubic units');
  print('Surface Area: ${cube1.surfaceArea()} square units');
  print('');

  print('Cube 2:');
  print('Vertices:');
  cube2.vertices().forEach((vertex) => print(vertex));
  print('Edges:');
  cube2.edges().forEach((edge) => print(edge));
  print('Space Diagonals:');
  cube2.spaceDiagonals().forEach((diagonal) => print(diagonal));
  print('Volume: ${cube2.volume()} cubic units');
  print('Surface Area: ${cube2.surfaceArea()} square units');
  print('');

  print('Cube 3:');
  print('Vertices:');
  cube3.vertices().forEach((vertex) => print(vertex));
  print('Edges:');
  cube3.edges().forEach((edge) => print(edge));
  print('Space Diagonals:');
  cube3.spaceDiagonals().forEach((diagonal) => print(diagonal));
  print('Volume: ${cube3.volume()} cubic units');
  print('Surface Area: ${cube3.surfaceArea()} square units');

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
  var trapezoid1 = Trapezoid.from(base1: 7, base2: 5, height: 6);
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
