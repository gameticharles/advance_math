# Polygons

This document covers the `Polygon` class for representing general polygons in 2D space.

## Table of Contents
- [Polygon Class (`polygon.dart`)](#polygon-class)
  - [Overview](#polygon-overview)
  - [Constructors](#polygon-constructors)
  - [Properties](#polygon-properties)
  - [Methods](#polygon-methods)
  - [Static Methods](#polygon-static-methods)
- [RegularPolygon Class (`polygon.dart`)](#regularpolygon-class)
  - [Overview](#regularpolygon-overview)
  - [Constructors](#regularpolygon-constructors)
  - [Methods](#regularpolygon-methods)
- [IrregularPolygon Class (`polygon.dart`)](#irregularpolygon-class)
  - [Overview](#irregularpolygon-overview)
  - [Constructors](#irregularpolygon-constructors)

---

## Polygon Class (`polygon.dart`)
*(Documentation for the `Polygon` class from `lib/src/math/geometry/plane/polygon.dart`)*

### Polygon Overview
The `Polygon` class represents a general polygon in 2D space. It can be defined by a list of `Point` vertices or, for regular polygons, by the number of sides and the length of each side. The class provides methods to calculate area, perimeter, centroid, moment of inertia, and perform operations like scaling, translation, and point containment checks.

This base `Polygon` class can represent both regular and irregular polygons. Specialized subclasses `RegularPolygon` and `IrregularPolygon` also exist.

### Polygon Constructors

#### `Polygon({List<Point>? vertices, int? numSides, double? sideLength})`
-   **Signature:** `Polygon({this.vertices, this.numSides, this.sideLength})`
-   **Description:** Creates a `Polygon`.
    -   If `vertices` (a list of `Point` objects) are provided, `numSides` is determined from the length of this list.
    -   If `numSides` and `sideLength` are provided, it's assumed to be a regular polygon, and the `sides` list is populated with `sideLength` for each side. `vertices` are not automatically computed by this base constructor from `numSides` and `sideLength`.
-   **Parameters:**
    -   `vertices: List<Point>?`: A list of `Point` objects defining the vertices of the polygon in order.
    -   `numSides: int?`: The number of sides in the polygon. Required if `vertices` are not provided (especially for regular polygons).
    -   `sideLength: double?`: The length of each side. Used if constructing a regular polygon without explicit vertices.
-   **Dart Code Example:**
    ```dart
    // Polygon from vertices (irregular)
    final poly1Vertices = [Point(0,0), Point(2,0), Point(2,1), Point(1,2), Point(0,1)];
    final polygon1 = Polygon(vertices: poly1Vertices);
    print('Polygon 1 (from vertices): ${polygon1.numSides} sides');
    // Output: Polygon 1 (from vertices): 5 sides

    // Polygon defined as regular (e.g., a square)
    // Note: This base constructor doesn't compute vertices from numSides/sideLength.
    // For full regular polygon functionality, see RegularPolygon class.
    final polygon2 = Polygon(numSides: 4, sideLength: 10.0);
    print('Polygon 2 (regular definition): ${polygon2.numSides} sides, side length ${polygon2.sideLength}');
    // Output: Polygon 2 (regular definition): 4 sides, side length 10.0
    // polygon2.vertices would be null here.
    ```

### Polygon Properties
-   **`vertices: List<Point>?`**: A list of `Point` objects representing the vertices of the polygon. Can be `null` if not defined by vertices.
-   **`sides: List<num>?`**: A list containing the lengths of the polygon's sides. Calculated from `vertices` if they are provided, or set if `sideLength` is given for a regular polygon.
-   **`numSides: int?`**: The number of sides (and vertices) in the polygon.
-   **`sideLength: double?`**: The length of each side, if the polygon is regular and defined this way.

### Polygon Methods

#### `scale(double factor)`
-   **Description:** Scales the polygon by `factor` relative to its origin (if vertices are defined) or scales `sideLength` and `sides` if defined that way. Modifies the instance.
-   **Example:**
    ```dart
    final poly = Polygon(vertices: [Point(0,0), Point(2,0), Point(1,1)]);
    poly.scale(2.0);
    print(poly.vertices); // Output: [Point(0.0, 0.0), Point(4.0, 0.0), Point(2.0, 2.0)]
    ```

#### `translate(double dx, double dy)`
-   **Description:** Translates the polygon's vertices by `dx` and `dy`. Modifies the instance. Throws `ArgumentError` if `vertices` is null.
-   **Example:**
    ```dart
    final poly = Polygon(vertices: [Point(0,0), Point(1,1)]);
    poly.translate(5, -2);
    print(poly.vertices); // Output: [Point(5.0, -2.0), Point(6.0, -1.0)]
    ```

#### `isPointInsidePolygon(Point point) -> bool`
-   **Description:** Determines if a given `point` is inside the polygon using the ray casting algorithm. Returns `true` if the point is inside, `false` otherwise. Assumes `vertices` are defined.
-   **Example:**
    ```dart
    final square = Polygon(vertices: [Point(0,0), Point(2,0), Point(2,2), Point(0,2)]);
    print(square.isPointInsidePolygon(Point(1,1))); // Output: true
    print(square.isPointInsidePolygon(Point(3,3))); // Output: false
    ```

#### `isConvex() -> bool`
-   **Description:** Determines if the polygon is convex (all interior angles <= 180 degrees). Assumes `vertices` are defined.
-   **Example:**
    ```dart
    final convexPoly = Polygon(vertices: [Point(0,0), Point(2,0), Point(2,1), Point(0,1)]);
    print(convexPoly.isConvex()); // Output: true

    final concavePoly = Polygon(vertices: [Point(0,0), Point(2,0), Point(1,1), Point(2,2), Point(0,2)]);
    print(concavePoly.isConvex()); // Output: false
    ```

#### `angleBetweenSides(int i, int j) -> double`
-   **Description:** Calculates the angle (in radians) between two sides of the polygon, specified by their indices `i` and `j`. Assumes `vertices` are defined.
-   **Throws:** `ArgumentError` if indices are equal or if vertices are null.
-   **Example:**
    ```dart
    final square = Polygon(vertices: [Point(0,0), Point(1,0), Point(1,1), Point(0,1)]);
    // Angle between side 0 (v0-v1) and side 1 (v1-v2)
    // These are perpendicular, so angle is pi/2 or 90 degrees.
    // The method calculates angle between vectors representing sides.
    // print(square.angleBetweenSides(0,1) * 180 / pi); // Output: 90.0 (approx)
    ```
    _Note: The source code's `_angleBetween` uses `v1.dot(v2) / (v1.magnitude * v2.magnitude)`. This calculates the angle between two vectors if they shared a common origin. For polygon interior/exterior angles, a different geometric approach for vertex angles is usually taken._

#### `distanceToPolygon(Polygon otherPolygon) -> double`
-   **Description:** Calculates the minimum distance between this polygon and `otherPolygon`. This is the shortest distance between any pair of line segments from the two polygons. Assumes `vertices` are defined for both.
-   **Example:**
    ```dart
    final poly1 = Polygon(vertices: [Point(0,0), Point(1,0)]);
    final poly2 = Polygon(vertices: [Point(2,0), Point(3,0)]);
    print(poly1.distanceToPolygon(poly2)); // Output: 1.0 (distance between Point(1,0) and Point(2,0))
    ```

#### `nearestPointOnPolygon(Point point) -> Point`
-   **Description:** Finds the point on the boundary of this polygon that is nearest to the given `point`. Assumes `vertices` are defined.
-   **Example:**
    ```dart
    final poly = Polygon(vertices: [Point(0,0), Point(2,0)]); // A line segment
    print(poly.nearestPointOnPolygon(Point(1,1))); // Output: Point(1.0, 0.0)
    print(poly.nearestPointOnPolygon(Point(3,0))); // Output: Point(2.0, 0.0)
    ```

#### `boundingBox() -> List<Point>`
-   **Description:** Calculates the axis-aligned bounding box of the polygon.
-   **Returns:** A `List<Point>` of four points representing the `[minX,minY]`, `[maxX,minY]`, `[maxX,maxY]`, `[minX,maxY]` corners of the bounding box. Assumes `vertices` are defined.
-   **Example:**
    ```dart
    final poly = Polygon(vertices: [Point(1,1), Point(3,1), Point(2,3)]);
    print(poly.boundingBox());
    // Output: [Point(1.0, 1.0), Point(3.0, 1.0), Point(3.0, 3.0), Point(1.0, 3.0)]
    ```

#### Area Calculation Methods
These methods calculate the area of the polygon. They require `vertices` to be defined.
-   **`shoelace() -> double`**: Uses the Shoelace formula (Gauss's area formula).
-   **`greensTheorem() -> double`**: Uses Green's Theorem (similar to shoelace for polygons).
-   **`triangulation() -> double`**: Divides the polygon into triangles from the first vertex and sums their areas. Assumes a simple polygon.
-   **`trapezoidal() -> double`**: Uses the trapezoidal rule by summing areas of trapezoids formed by edges and the x-axis.
-   **`monteCarlo({int numPoints = 10000}) -> double`**: Approximates area using random sampling within the bounding box. `numPoints` controls accuracy.
    ```dart
    final square = Polygon(vertices: [Point(0,0), Point(2,0), Point(2,2), Point(0,2)]);
    print('Area (Shoelace): ${square.shoelace()}');         // Output: 4.0
    print('Area (Green\'s): ${square.greensTheorem()}');    // Output: 4.0
    print('Area (Triangulation): ${square.triangulation()}'); // Output: 4.0
    print('Area (Trapezoidal): ${square.trapezoidal()}');   // Output: 4.0
    print('Area (Monte Carlo): ${square.monteCarlo(numPoints: 50000)}'); // Output: Approx 4.0
    ```

#### `perimeter() -> num`
-   **Description:** Calculates the perimeter of the polygon. If `vertices` are defined, it sums the lengths of the segments. If defined by `numSides` and `sideLength` (regular polygon), it calculates `numSides * sideLength`.
-   **Example:**
    ```dart
    final square = Polygon(vertices: [Point(0,0), Point(2,0), Point(2,2), Point(0,2)]);
    print(square.perimeter()); // Output: 8.0

    final pentagon = Polygon(numSides: 5, sideLength: 3.0);
    print(pentagon.perimeter()); // Output: 15.0
    ```

#### `centroid() -> Point`
-   **Description:** Calculates the geometric centroid (center of mass for uniform density) of the polygon. Assumes `vertices` are defined.
-   **Example:**
    ```dart
    final square = Polygon(vertices: [Point(0,0), Point(2,0), Point(2,2), Point(0,2)]);
    print(square.centroid()); // Output: Point(1.0, 1.0)
    ```

#### `momentOfInertia() -> num`
-   **Description:** Calculates the moment of inertia of the polygon about an axis perpendicular to its plane and passing through its centroid, assuming uniform mass distribution. Assumes `vertices` are defined.
-   **Example:**
    ```dart
    final square = Polygon(vertices: [Point(0,0), Point(2,0), Point(2,2), Point(0,2)]);
    // Formula for a square of side 's' about centroid is (mass * s^2) / 6.
    // This method calculates the geometric part, assuming mass density = 1.
    // Area = 4. For a 2x2 square, Ix = Iy = (2*2^3)/12 = 8/12 = 2/3. Jz = Ix+Iy = 4/3.
    // The source formula seems to be for polar moment of inertia or a specific definition.
    print(square.momentOfInertia()); // Output based on source formula
    ```

#### `sideLengthIrregular(int i) -> num`
-   **Description:** Returns the length of the i-th side of an irregular polygon (segment from `vertices[i]` to `vertices[i+1]`). Assumes `vertices` are defined.
-   **Example:**
    ```dart
    final rect = Polygon(vertices: [Point(0,0), Point(3,0), Point(3,2), Point(0,2)]);
    print(rect.sideLengthIrregular(0)); // Length of side from (0,0) to (3,0). Output: 3.0
    print(rect.sideLengthIrregular(1)); // Length of side from (3,0) to (3,2). Output: 2.0
    ```

#### `getSideLength({num? perimeter, num? area, num? circumradius, num? inradius}) -> double`
-   **Description:** For a **regular polygon** (where `numSides` must be known), calculates the `sideLength` if one of the other geometric properties (`perimeter`, `area`, `circumradius`, `inradius`) is provided. Updates the instance's `sideLength` and `sides` list.
-   **Throws:** `ArgumentError` if `numSides` is null or if none of the optional parameters are provided.
-   **Example:**
    ```dart
    // Create a hexagon definition, then calculate its side length if perimeter is 24
    final hexagon = Polygon(numSides: 6);
    print(hexagon.getSideLength(perimeter: 24)); // Output: 4.0
    print(hexagon.sideLength);                   // Output: 4.0

    // Calculate side length of a square if its area is 25
    final squareDef = Polygon(numSides: 4);
    print(squareDef.getSideLength(area: 25)); // Output: 5.0
    ```

### Polygon Static Methods
-   **`static double _angleBetween(Point v1, Point v2)`**: Private helper.
-   **`static double _lineSegmentDistance(Point p1, Point p2, Point q1, Point q2)`**: Private helper.

---

## RegularPolygon Class (`polygon.dart`)
*(Documentation for `RegularPolygon` which extends `Polygon`)*

### RegularPolygon Overview
The `RegularPolygon` class represents a polygon where all sides are of equal length and all interior angles are equal. It inherits from `Polygon`.

### RegularPolygon Constructors
#### `RegularPolygon({List<Point>? vertices, required int numSides, double? sideLength})`
-   **Signature:** `RegularPolygon({List<Point>? vertices, required int numSides, double? sideLength}) : super(vertices: vertices, numSides: numSides, sideLength: sideLength)`
-   **Description:** Creates a `RegularPolygon`.
    -   If `vertices` are provided, `numSides` must match `vertices.length`. `sideLength` will be calculated (and validated if also provided).
    -   If `numSides` and `sideLength` are provided, these define the regular polygon. `vertices` are not automatically computed by this constructor.
-   **Throws:** `ArgumentError` if `vertices` are provided and `vertices.length != numSides`.
-   **Example:**
    ```dart
    final square = RegularPolygon(numSides: 4, sideLength: 5.0);
    print('Square: ${square.numSides} sides, length ${square.sideLength}');
    // Output: Square: 4 sides, length 5.0

    final triangleVertices = [Point(0,0), Point(1,0), Point(0.5, sqrt(3)/2)]; // Equilateral
    // final eqTriangle = RegularPolygon(vertices: triangleVertices, numSides: 3);
    // print('Equilateral Triangle side: ${eqTriangle.sideLength?.toStringAsFixed(2)}'); // Approx 1.00
    ```
    *(Note: The `sideLength` calculation from vertices in the base `Polygon` might not be triggered if `vertices` is passed here unless `sideLength` is explicitly null. The `RegularPolygon` constructor itself doesn't add logic to calculate `sideLength` from `vertices` if `sideLength` is null, it relies on the base constructor behavior.)*

### RegularPolygon Methods
Inherits methods from `Polygon` (like `areaPolygon`, `perimeter`, `centroid`, etc., which often assume regularity if `sideLength` and `numSides` are set). Adds methods specific to regular polygons:

#### `double interiorAngle()`
-   **Description:** Calculates the measure of each interior angle of the regular polygon in degrees. Formula: `(numSides - 2) * 180 / numSides`.
-   **Returns:** `double`: The interior angle in degrees.
-   **Example:**
    ```dart
    final hexagon = RegularPolygon(numSides: 6);
    print(hexagon.interiorAngle()); // Output: 120.0
    ```

#### `double exteriorAngle()`
-   **Description:** Calculates the measure of each exterior angle of the regular polygon in degrees. Formula: `360 / numSides`.
-   **Returns:** `double`: The exterior angle in degrees.
-   **Example:**
    ```dart
    final octagon = RegularPolygon(numSides: 8);
    print(octagon.exteriorAngle()); // Output: 45.0
    ```

#### `double inradius()`
-   **Description:** Calculates the radius of the inscribed circle (apothem). Requires `sideLength` and `numSides`. Formula: `sideLength / (2 * tan(pi / numSides))`.
-   **Returns:** `double`: The inradius.
-   **Example:**
    ```dart
    final square = RegularPolygon(numSides: 4, sideLength: 10.0);
    print(square.inradius()); // Output: 5.0
    ```

#### `double circumradius()`
-   **Description:** Calculates the radius of the circumscribed circle. Requires `sideLength` and `numSides`. Formula: `sideLength / (2 * sin(pi / numSides))`.
-   **Returns:** `double`: The circumradius.
-   **Example:**
    ```dart
    final hexagon = RegularPolygon(numSides: 6, sideLength: 10.0);
    print(hexagon.circumradius()); // Output: 10.0 (for a hexagon, circumradius equals side length)
    ```

---

## IrregularPolygon Class (`polygon.dart`)
*(Documentation for `IrregularPolygon` which extends `Polygon`)*

### IrregularPolygon Overview
The `IrregularPolygon` class represents a polygon that does not necessarily have equal sides or angles. It primarily relies on its list of `vertices` for its definition and calculations. It inherits most of its functionality from the base `Polygon` class.

### IrregularPolygon Constructors
#### `IrregularPolygon({List<Point>? vertices})`
-   **Signature:** `IrregularPolygon({super.vertices})`
-   **Description:** Creates an `IrregularPolygon` from a list of `vertices`. `numSides` is determined by the length of the `vertices` list.
-   **Parameters:**
    -   `vertices: List<Point>?`: A list of `Point` objects defining the vertices of the polygon in order.
-   **Example:**
    ```dart
    final myShapeVertices = [Point(0,0), Point(3,0), Point(4,2), Point(1,3)];
    final irregularPoly = IrregularPolygon(vertices: myShapeVertices);
    print('Irregular Polygon: ${irregularPoly.numSides} sides');
    // Output: Irregular Polygon: 4 sides
    print('Perimeter: ${irregularPoly.perimeter()}');
    // Calculates perimeter based on distances between these specific vertices.
    ```
The `IrregularPolygon` class does not add new methods beyond those inherited from `Polygon`. Its main purpose is to provide a type that explicitly indicates the polygon is not assumed to be regular. Calculations like `area` (using Shoelace, Green's, etc.), `perimeter`, `centroid`, `momentOfInertia`, `boundingBox`, `isPointInsidePolygon`, `isConvex` will use the provided `vertices`. Methods specific to regular polygons (like `interiorAngle`, `inradius`, `circumradius` if called directly on an `IrregularPolygon` instance without `sideLength` being set) would likely fail or give meaningless results if they rely on a single `sideLength`.

---
