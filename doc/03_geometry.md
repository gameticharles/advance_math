# Geometry Module

Comprehensive 2D and 3D geometry classes for points, lines, shapes, and solid geometry.

---

## Table of Contents

1. [Points](#points)
2. [Lines](#lines)
3. [Circles](#circles)
4. [Triangles](#triangles)
5. [Quadrilaterals](#quadrilaterals)
6. [Regular Polygons](#regular-polygons)
7. [Ellipse & Annulus](#ellipse--annulus)
8. [Solid Geometry](#solid-geometry)
9. [Utility Functions](#utility-functions)

---

## Points

### Point (2D/3D)

```dart
import 'package:advance_math/advance_math.dart';

// 2D Point
Point p1 = Point(3, 4);
print(p1.x);          // 3
print(p1.y);          // 4
print(p1.is2DPoint);  // true

// 3D Point
Point p2 = Point(1, 2, 3);
print(p2.z);          // 3
print(p2.is3DPoint);  // true

// From polar coordinates
var polar = Point.fromPolarCoordinates(5, radians(53.13));
print(polar);  // Point(3.0, 4.0)

// From spherical coordinates
var spherical = Point.fromSphericalCoordinates(5, radians(53.13), radians(30));
print(spherical);  // Point(1.5, 2.0, 4.33)
```

### Point3D

```dart
Point3D p = Point3D(3, 4, 2);
print(p.x);  // 3
print(p.y);  // 4
print(p.z);  // 2
```

### Point Operations

```dart
var p1 = Point(3, 4);
var p2 = Point(6, 8);

// Distance
print(p1.distanceTo(p2));     // 5.0

// Midpoint
print(p1.midpointTo(p2));     // Point(4.5, 6.0)

// Slope
print(p1.slopeTo(p2));        // 1.333...

// Arithmetic
print(p1 + p2);               // Point(9, 12)
print(p1 - p2);               // Point(-3, -4)
print(p1 * 2);                // Point(6, 8)
print(p1 / 2);                // Point(1.5, 2)

// Bearing (azimuth)
print(p1.bearingTo(p2));              // Bearing angle
print(p1.bearingTo(p2, isXAxis: false)); // From Y-axis

// Rotation
var origin = Point(1, 0);
var rotated = Point(2, 0).rotateBy(Angle.radians(pi / 2), origin);
print(rotated);  // Point(1, 1)

// Transformations
var p = Point(1, 2, 3);
print(p.move(1, -1, 2));      // Point(2, 1, 5)
print(p.scale(2));            // Point(2, 4, 6)
print(p.reflect(Point(0, 0, 0))); // Point(-1, -2, -3)

// Collinearity check
var a = Point(1, 1);
var b = Point(2, 2);
var c = Point(3, 3);
print(a.isCollinear(b, c));   // true
```

---

## Lines

```dart
// From two points
var line1 = Line(p1: Point(1, 1), p2: Point(2, 2));
print(line1);

// From gradient and intercept (y = mx + b)
var line2 = Line(gradient: 1, intercept: 0);

// Properties
print(line1.gradient);        // Slope
print(line1.intercept);       // Y-intercept
print(line1.length);          // Distance between p1 and p2

// Operations
print(line1.isParallelTo(line2));
print(line1.isPerpendicularTo(line2));
print(line1.intersectionWith(line2));  // Intersection point
```

---

## Circles

```dart
var centralAngle = Angle(deg: 45);
var circle = Circle.from(radius: 5, centralAngle: centralAngle);

// Properties
print('Radius: ${circle.radius}');
print('Diameter: ${circle.diameter}');
print('Area: ${circle.area()}');
print('Perimeter: ${circle.perimeter()}');

// Sector and Segment
print('Arc Length: ${circle.arcLength}');
print('Chord Length: ${circle.chordLength}');
print('Sector Area: ${circle.sectorArea}');
print('Segment Area: ${circle.segmentArea}');
print('Distance from Center to Chord: ${circle.distanceFromCenterToChord}');
```

---

## Triangles

### General Triangle

```dart
var tri = Triangle(a: 3, b: 4, c: 5);

// Basic properties
print('Area: ${tri.area()}');
print('Perimeter: ${tri.perimeter()}');
print('Semi-Perimeter: ${tri.s}');

// Circle properties
print('Circumradius: ${tri.circumCircleRadius}');
print('Inradius: ${tri.inCircleRadius}');

// Heights
print('Height A: ${tri.heightA}');
print('Height B: ${tri.heightB}');
print('Height C: ${tri.heightC}');

// Medians
print('Median A: ${tri.medianA}');
print('Median B: ${tri.medianB}');
print('Median C: ${tri.medianC}');

// Angles
print('Angle A: ${tri.angleA}');
print('Angle B: ${tri.angleB}');
print('Angle C: ${tri.angleC}');
```

### Specialized Triangles

```dart
// Equilateral Triangle
var equilateral = EquilateralTriangle.from(side: 6.0);
print('Side: ${equilateral.side}');
print('Area: ${equilateral.area()}');
print('Height: ${equilateral.height}');

// Isosceles Triangle
var isosceles = IsoscelesTriangle.from(equalSide: 5.0, base: 6.0);
print('Equal Side: ${isosceles.equalSide}');
print('Base: ${isosceles.baseLength}');
print('Height to Base: ${isosceles.heightToBase}');
print('Apex Angle: ${isosceles.apexAngle.deg}°');
print('Base Angle: ${isosceles.baseAngle.deg}°');

// Scalene Triangle
var scalene = ScaleneTriangle.from(a: 3.0, b: 4.0, c: 5.0);
print('Is Acute: ${scalene.isAcute()}');
print('Is Obtuse: ${scalene.isObtuse()}');

// Right Triangle
var rightTri = RightTriangle.from(leg1: 3.0, leg2: 4.0);
print('Leg 1: ${rightTri.leg1}');
print('Leg 2: ${rightTri.leg2}');
print('Hypotenuse: ${rightTri.hypotenuse}');
print('Is Pythagorean Triple: ${rightTri.isPythagoreanTriple()}');
```

---

## Quadrilaterals

### Rectangle

```dart
Rectangle rectangle = Rectangle.from(length: 5, width: 3);
print('Area: ${rectangle.area()}');
print('Perimeter: ${rectangle.perimeter()}');
print('Diagonal: ${rectangle.diagonal()}');
print('Aspect Ratio: ${rectangle.aspectRatio()}');
print('Perimeter Ratio: ${rectangle.perimeterRatio()}');
print('Angles Between Diagonals: ${rectangle.anglesBetweenDiagonals()}');
```

### Square

```dart
Square square = Square.from(side: 5);
print('Area: ${square.area()}');
print('Perimeter: ${square.perimeter()}');
print('Diagonal: ${square.diagonal()}');
print('InRadius: ${square.inRadius}');
print('CircumRadius: ${square.circumRadius}');
```

### Rhombus

```dart
// From side and angle
var rhombus1 = Rhombus.from(side: 5.0, angle: Angle(deg: 60));
print('Diagonal 1: ${rhombus1.diagonal1}');
print('Diagonal 2: ${rhombus1.diagonal2}');
print('Area: ${rhombus1.area()}');

// From diagonals
var rhombus2 = Rhombus.fromDiagonals(6.0, 8.0);
print('Side: ${rhombus2.side}');
print('Is Square: ${rhombus2.isSquare()}');
```

### Parallelogram

```dart
var parallelogram = Parallelogram(5, 3, angle1: pi / 4);
print('Base: ${parallelogram.base}');
print('Side: ${parallelogram.side}');
print('Area: ${parallelogram.area()}');
print('Perimeter: ${parallelogram.perimeter()}');
print('Height 1: ${parallelogram.height1}');
print('Height 2: ${parallelogram.height2}');
print('Diagonal 1: ${parallelogram.diagonal1()}');
print('Diagonal 2: ${parallelogram.diagonal2()}');
print('Angles: ${parallelogram.angles()}');
```

### Trapezoid

```dart
var trapezoid = Trapezoid.from(base1: 7, base2: 5, height: 6);
print('Base 1: ${trapezoid.base1}');
print('Base 2: ${trapezoid.base2}');
print('Height: ${trapezoid.height}');
print('Area: ${trapezoid.area()}');
print('Perimeter: ${trapezoid.perimeter()}');
print('Diagonals: ${trapezoid.diagonals()}');
print('Angles: ${trapezoid.angles()}');
```

---

## Regular Polygons

### Pentagon

```dart
var pentagon = Pentagon.from(side: 4.0);
print('Number of Sides: ${pentagon.numSides}');
print('Interior Angle: ${pentagon.interiorAngle.deg}°');
print('Exterior Angle: ${pentagon.exteriorAngle.deg}°');
print('Area: ${pentagon.area()}');
print('Perimeter: ${pentagon.perimeter()}');
print('Circumradius: ${pentagon.circumRadius}');
print('Inradius: ${pentagon.inRadius}');
```

### Hexagon

```dart
var hexagon = Hexagon.from(side: 4.0);
print('Interior Angle: ${hexagon.interiorAngle.deg}°');
print('Area: ${hexagon.area()}');
print('Long Diagonal: ${hexagon.longDiagonal}');
print('Short Diagonal: ${hexagon.shortDiagonal}');
```

### Heptagon, Octagon, etc.

```dart
var heptagon = Heptagon.from(side: 5.0);
print('Interior Angle: ${heptagon.interiorAngle.deg}°');

var octagon = Octagon.from(side: 5.0);
print('Interior Angle: ${octagon.interiorAngle.deg}°');
```

### General Polygon

```dart
var polygon = Polygon(vertices: [
  Point(591.40, 591.40),
  Point(652.40, 542.70),
  Point(783.50, 529.00),
  Point(896.20, 612.80),
  Point(810.90, 713.40),
  Point(685.90, 756.00),
  Point(562.50, 632.60)
]);

// Area calculation methods
print(polygon.shoelace());     // Shoelace formula
print(polygon.trapezoidal());  // Trapezoidal method
```

---

## Ellipse & Annulus

### Ellipse

```dart
var ellipse = Ellipse(5, 3, center: Point(2, 2));
print('Semi-major Axis: ${ellipse.semiMajorAxis}');
print('Semi-minor Axis: ${ellipse.semiMinorAxis}');
print('Area: ${ellipse.area()}');
print('Perimeter: ${ellipse.perimeter()}');

// Advanced properties
print('Eccentricity: ${ellipse.eccentricity()}');
print('Foci: ${ellipse.foci()}');
print('Focal Distance: ${ellipse.focalDistance()}');
print('Directrices: ${ellipse.directrices()}');
print('Latus Rectum: ${ellipse.latusRectum()}');

// Curvature at angle
double theta = pi / 4;
print('Curvature at θ=$theta: ${ellipse.curvature(theta)}');

// Arc length
print('Arc length from 0 to π/2: ${ellipse.arcLength(0, pi / 2)}');

// Distance from point
Point p = Point(7, 2);
print('Distance from $p: ${ellipse.distanceFromPoint(p)}');
```

### Annulus (Ring)

```dart
var annulus = Annulus.from(
  width: 6,
  center: Point(2, 2),
  centralAngle: Angle(deg: 30),
  sectorPerimeter: 50,
  sectorArea: 50,
);

print('Outer Radius: ${annulus.outerRadius}');
print('Inner Radius: ${annulus.innerRadius}');
print('Mean Radius: ${annulus.meanRadius}');
print('Width: ${annulus.width}');
print('Area: ${annulus.area()}');
print('Perimeter: ${annulus.perimeter()}');

// Sector properties
print('Sector Area: ${annulus.sectorArea}');
print('Sector Perimeter: ${annulus.sectorPerimeter}');
print('Sector Diagonal: ${annulus.sectorDiagonal}');
```

---

## Solid Geometry

### Sphere

```dart
var sphere = Sphere(5.0);
print('Volume: ${sphere.volume()}');
print('Surface Area: ${sphere.surfaceArea()}');
```

### Cylinder

```dart
var cylinder = Cylinder(radius: 3, height: 5);
print('Volume: ${cylinder.volume()}');
print('Surface Area: ${cylinder.surfaceArea()}');
print('Lateral Area: ${cylinder.lateralSurfaceArea()}');
```

### Cone

```dart
var cone = Cone(radius: 3, height: 4);
print('Slant Height: ${cone.slantHeight}');
print('Volume: ${cone.volume()}');
print('Surface Area: ${cone.surfaceArea()}');
```

### Rectangular Prism

```dart
var prism = RectangularPrism(length: 2, width: 3, height: 4);
print('Volume: ${prism.volume()}');
print('Surface Area: ${prism.surfaceArea()}');
print('Diagonal: ${prism.diagonal}');
```

### Cube

```dart
Point centerPoint = Point(1, 2, 3);
Cube cube = Cube(5.0, center: centerPoint);

// Alternative constructors
Cube fromVolume = Cube.fromVolume(125, center: centerPoint);
Cube fromSurface = Cube.fromSurfaceArea(150, center: centerPoint);

print('Volume: ${cube.volume()}');
print('Surface Area: ${cube.surfaceArea()}');

// Structural elements
print('Vertices:');
cube.vertices().forEach((v) => print('  $v'));

print('Edges:');
cube.edges().forEach((e) => print('  $e'));

print('Space Diagonals:');
cube.spaceDiagonals().forEach((d) => print('  $d'));
```

---

## Utility Functions

### Closest Pair

```dart
List<Point> points = [
  Point(1, 1),
  Point(3, 3),
  Point(7, 7),
  Point(2, 7),
  Point(2, -7),
];

List<Point> closest = GeoUtils.closestPair(points);
print("Closest pair: (${closest[0]}) and (${closest[1]})");
```

---

## Related Tests

- [`test/geometry/`](../test/geometry/) - Geometry class tests

## Related Documentation

- [Algebra](01_algebra.md) - Vector operations used in geometry
- [Basic Math](02_basic_math.md) - Trigonometric functions
- [Quantity](06_quantity.md) - Angle and length units

### Core Geometric Types

- [Points (`./geometry/point.md`)](./geometry/point.md) - Documentation for 2D and 3D points.
- [Lines (`./geometry/line.md`)](./geometry/line.md) - Documentation for lines.
- [Pi Constants & Utilities (`./geometry/pi_constants.md`)](./geometry/pi_constants.md) - Pi-related values and angle conversions.

### Plane Geometry

- [Overview of Plane Geometry (`./geometry/plane/plane.md`)]](./geometry/plane/plane.md) - Documentation for `Plane` and `PlaneGeometry`.
- [Triangles (`./geometry/plane/triangle.md`)]](./geometry/plane/triangle.md) - Covers `Triangle`, `SphericalTriangle`, and area calculation utilities.
- [Quadrilaterals (`./geometry/plane/quadrilateral.md`)]](./geometry/plane/quadrilateral.md) - Covers `Square`, `Rectangle`, `Trapezoid`, `Parallelogram`, `Rhombus`.
- [Polygons (`./geometry/plane/polygon.md`)]](./geometry/plane/polygon.md) - General polygon representation.
- [Circles and Ellipses (`./geometry/plane/circle_ellipse.md`)]](./geometry/plane/circle_ellipse.md) - Covers `Circle`, `Ellipse`, `Annulus`, `ErrorEllipse`.

### Solid Geometry

- [Overview of Solid Geometry (`./geometry/solid/solid.md`)]](./geometry/solid/solid.md) - Documentation for `SolidGeometry`.
- [Cube (`./geometry/solid/cube.md`)]](./geometry/solid/cube.md) - Documentation for the `Cube` shape.

### Utilities

- [Geometric Utilities (`./geometry/utils.md`)]](./geometry/utils.md) - Utility functions for geometric operations.
