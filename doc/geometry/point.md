# Points (2D and 3D)

This document covers the `Point` (typically 2D, but can be 3D) and `Point3D` classes, which are fundamental for representing locations in geometric space.

## Table of Contents
- [Point Class (`point.dart`)](#point-class)
  - [Overview](#point-overview)
  - [Constructors](#point-constructors)
  - [Properties](#point-properties)
  - [Methods](#point-methods)
  - [Operators](#point-operators)
- [Point3D Class (`point3d.dart`)](#point3d-class)
  - [Overview](#point3d-overview)
  - [Constructors](#point3d-constructors)
  - [Properties](#point3d-properties)
  - [Methods](#point3d-methods)
  - [Operators](#point3d-operators)
  - [Static Methods](#point3d-static-methods)

---

## Point Class (`point.dart`)

### Point Overview
The `Point` class is a fundamental component of the `geometry` module, used to represent a location in a two-dimensional (2D) or three-dimensional (3D) Cartesian coordinate system. It stores the coordinates as `x`, `y`, and optionally `z`. If the `z` coordinate is provided and not null, the point is considered 3D; otherwise, it's 2D.

This class serves as a versatile tool for various geometric computations and representations. It provides:
- Constructors to create points from coordinates, lists, or via geometric transformations (polar, spherical).
- Properties to access its coordinates (`x`, `y`, `z`).
- A rich set of methods for geometric operations, including distance calculations, transformations (rotation, translation, scaling, reflection), angle computations, and checks for collinearity or position relative to other shapes.
- Overloaded operators for basic arithmetic (addition, subtraction, scalar multiplication/division) and equality comparison.

The `Point` class can be used to define vertices of shapes, positions of objects in space, or any other application requiring spatial coordinate representation. It extends `Vector`, indicating it can also be treated as a vector from the origin (the `Vector` superclass is initialized with `[x,y]`).

### Point Constructors

#### `Point(num x, num y, [num? z])`
-   **Signature:** `Point(this.x, this.y, [this.z])`
-   **Description:** Creates a new `Point` with the given coordinates.
-   **Parameters:**
    -   `x: num`: The x-coordinate.
    -   `y: num`: The y-coordinate.
    -   `z: num?` (optional): The z-coordinate. If provided and not null, the point is 3D; otherwise, it's 2D.
-   **Dart Code Example:**
    ```dart
    final p2D = Point(1, 2);
    print(p2D); // Output: Point(1, 2)

    final p3D = Point(1, 2, 3);
    print(p3D); // Output: Point(1, 2, 3)
    ```

#### `factory Point.origin([bool is3DPoint = true])`
-   **Signature:** `factory Point.origin([bool is3DPoint = true])`
-   **Description:** Creates a point at the origin (0,0 for 2D, 0,0,0 for 3D).
-   **Parameters:**
    -   `is3DPoint: bool` (optional): If `true` (default), creates a 3D point `Point(0,0,0)`. If `false`, creates a 2D point `Point(0,0)`.
-   **Dart Code Example:**
    ```dart
    final origin3D = Point.origin();
    print(origin3D); // Output: Point(0, 0, 0)

    final origin2D = Point.origin(is3DPoint: false);
    print(origin2D); // Output: Point(0, 0)
    ```

#### `factory Point.fromList(List<num> coords)`
-   **Signature:** `factory Point.fromList(List<num> coords)`
-   **Description:** Constructs a new `Point` from a list of numbers.
-   **Parameters:**
    -   `coords: List<num>`: A list containing 2 or 3 numbers. If 2 numbers, `z` will be `null` (2D point). If 3 numbers, they are `x`, `y`, `z`.
-   **Throws:** `ArgumentError` if the list does not contain 2 or 3 numbers.
-   **Dart Code Example:**
    ```dart
    final pFromList2D = Point.fromList([3, 4]);
    print(pFromList2D); // Output: Point(3, 4)

    final pFromList3D = Point.fromList([3, 4, 5]);
    print(pFromList3D); // Output: Point(3, 4, 5)
    ```

#### `factory Point.fromPolarCoordinates(num r, num theta, [Point? origin])`
-   **Signature:** `factory Point.fromPolarCoordinates(num r, num theta, [Point? origin])`
-   **Description:** Creates a 2D point from polar coordinates `(r, theta)`.
-   **Parameters:**
    -   `r: num`: The radial distance from the `origin`.
    -   `theta: num`: The angle in radians from the positive x-axis, counter-clockwise.
    -   `origin: Point?` (optional): The reference point for the polar coordinates. Defaults to `Point(0,0)`. The new point's coordinates are `origin.x + r*cos(theta)` and `origin.y + r*sin(theta)`.
-   **Dart Code Example:**
    ```dart
    // For pi/2 radians (90 degrees) and r=5 from origin(0,0)
    final pPolar1 = Point.fromPolarCoordinates(5, pi / 2);
    print(pPolar1); // Output: Point(3.061616997868383e-16, 5.0) (approximately Point(0,5))

    // From origin (1,1), r=2, angle=0 radians
    final pPolar2 = Point.fromPolarCoordinates(2, 0, Point(1,1));
    print(pPolar2); // Output: Point(3.0, 1.0)
    ```

#### `factory Point.fromSphericalCoordinates(num r, num theta, num phi)`
-   **Signature:** `factory Point.fromSphericalCoordinates(num r, num theta, num phi)`
-   **Description:** Creates a 3D point from spherical coordinates `(r, theta, phi)`.
-   **Parameters:**
    -   `r: num`: The radial distance from the origin (radius).
    -   `theta: num`: The azimuthal angle in radians (angle in the xy-plane from the x-axis, typically `0 <= theta < 2π`). Corresponds to longitude.
    -   `phi: num`: The polar (or inclination) angle in radians (angle from the positive z-axis, typically `0 <= phi <= π`). Corresponds to colatitude.
-   **Conversion Formula Used:**
    `x = r * sin(phi) * cos(theta)`
    `y = r * sin(phi) * sin(theta)`
    `z = r * cos(phi)`
-   **Dart Code Example:**
    ```dart
    // r=5, theta=pi/2 (azimuthal), phi=pi/2 (polar)
    final pSpherical = Point.fromSphericalCoordinates(5, pi / 2, pi / 2);
    // Expected: x=0, y=5, z=0
    print('x: ${pSpherical.x.toStringAsFixed(1)}, y: ${pSpherical.y.toStringAsFixed(1)}, z: ${pSpherical.z?.toStringAsFixed(1)}');
    // Output: x: 0.0, y: 5.0, z: 0.0 (approx.)
    ```

### Point Properties
-   **`x: num`**: The x-coordinate. Mutable.
-   **`y: num`**: The y-coordinate. Mutable.
-   **`z: num?`**: The z-coordinate. Mutable. `null` for 2D points.
    ```dart
    final p = Point(1, 2, 3);
    p.x = 10;
    print('x: ${p.x}, y: ${p.y}, z: ${p.z}'); // Output: x: 10, y: 2, z: 3
    ```

### Point Methods
-   **`is3DPoint() -> bool`**: Returns `true` if `z` is not `null`.
-   **`toVector() -> Vector`**: Converts to `Vector2` (if 2D) or `Vector3` (if 3D).
-   **`rotate(Angle angle) -> Point`**: (2D rotation) Returns new `Point` rotated around origin by `angle.rad`. Z unchanged. *(Conceptual: `Angle` class details not fully available from current sources).*
    ```dart
    // Assuming Angle class instance: final angle90 = Angle(rad: pi/2);
    print(Point(1,0).rotate(Angle(rad: pi/2))); // Approx. Point(0,1)
    ```
-   **`rotateBy(Angle angle, [Point? origin]) -> Point`**: (2D rotation) Modifies point in place, rotating around `origin` (or `Point(0,0)`) by `angle.rad`. Returns self. Z unchanged. *(Conceptual: `Angle` class details not fully available).*
-   **`distanceTo(Point otherPoint) -> double`**: Euclidean distance. Handles 2D/3D.
-   **`midpointTo(Point otherPoint) -> Point`**: Midpoint. Handles 2D/3D.
-   **`move(num dx, num dy, [num? dz]) -> Point`**: Returns new translated `Point`. Same as `translate`.
-   **`scale(num factor) -> Point`**: Returns new `Point` scaled from origin.
-   **`reflect([Point? origin]) -> Point`**: Returns new `Point` reflected through `origin` (or `Point(0,0)`).
-   **`angleBetween(Point otherPoint) -> Angle`**: (2D) Angle of line segment to `otherPoint` w.r.t positive x-axis. Returns `Angle` object. *(Conceptual: `Angle` class details not fully available).*
-   **`translate(num dx, num dy, [num? dz]) -> Point`**: Returns new translated `Point`. Same as `move`.
-   **`polarCoordinates() -> (num r, Angle theta)`**: (2D) Converts to polar. `theta` as `Angle` object. Throws if 3D. *(Conceptual: `Angle` class details not fully available).*
-   **`slopeTo(Point otherPoint) -> double`**: (2D) Slope of line to `otherPoint`. `double.infinity` for vertical.
-   **`isCollinear(Point a, Point b) -> bool`**: Checks if `this`, `a`, `b` are collinear.
-   **`distanceToLine(Point linePoint1, Point linePoint2) -> double`**: (2D) Shortest distance to line.
-   **`bearingTo(Point point, {bool isXAxis = true}) -> Angle`**: (2D) Bearing to `point`. `isXAxis=true` (default) for angle from positive X-axis (East, CCW positive). `isXAxis=false` for angle from positive Y-axis (North, CW positive). Returns `Angle` object. *(Conceptual: `Angle` class details not fully available).*
    ```dart
    final pOrigin = Point(0,0);
    final pNE = Point(1,1);
    // Angle angleX = pOrigin.bearingTo(pNE); print(angleX.deg); // Conceptual output: 45.0
    // Angle angleY = pOrigin.bearingTo(pNE, isXAxis: false); print(angleY.deg); // Conceptual output: 45.0
    ```
-   **`distanceToCircle(Point center, double radius) -> double`**: (2D) Shortest distance to circle boundary (0 if inside/on).
-   **`distanceToPolyline(List<Point> polyline) -> double`**: (2D) Shortest distance to polyline.
-   **`interpolate(Point point1, Point point2) -> Point`**: Linear interpolation: `point1 + this.x * (point2 - point1)`. `this.x` is the ratio `t`.
-   **`triangleArea(Point point1, Point point2) -> double`**: (2D) Area of triangle formed by `this`, `point1`, `point2`.
-   **`isInsidePolygon(List<Point> polygon, [double tolerance = 1e-10]) -> bool`**: (2D) True if point is inside or on boundary of CCW `polygon`.
-   **`isOnLineSegment(Point pointA, Point pointB, [double tolerance = 1e-10]) -> bool`**: (2D) True if point is on segment `[pointA, pointB]`.

### Point Operators
-   **`operator -(Point other) -> Point`**: Subtracts coordinates. Result is 2D if either point is 2D.
-   **`operator +(Point other) -> Point`**: Adds coordinates. Result is 2D if either point is 2D.
-   **`operator *(num scalar) -> Point`**: Scales coordinates by `scalar`.
-   **`operator /(num scalar) -> Point`**: Divides coordinates by `scalar`. Throws `ArgumentError` if `scalar` is 0.
-   **`operator ==(Object other) -> bool`**: True if `other` is `Point` and `x,y,z` are equal (null `z` matches null `z`).
    ```dart
    final p1 = Point(1,2,3);
    final p2 = Point(0.5, 1, 1);
    print(p1 - p2);   // Output: Point(0.5, 1.0, 2.0)
    print(p1 * 2);    // Output: Point(2.0, 4.0, 6.0)
    ```

---

## Point3D Class (`point3d.dart`)
*(Documentation for `Point3D` from `lib/src/math/geometry/point3d.dart`)*

### Point3D Overview
The `Point3D` class specifically represents a point in a three-dimensional Cartesian coordinate system, with `x`, `y`, and `z` coordinates. Unlike the general `Point` class, `Point3D` instances are always 3D. It provides methods and operators tailored for 3D geometric operations.

### Point3D Constructors

#### `Point3D(num x, num y, num z)`
-   **Signature:** `Point3D(this.x, this.y, this.z)`
-   **Description:** Creates a new `Point3D` with the given `x`, `y`, and `z` coordinates.
-   **Dart Code Example:**
    ```dart
    final p = Point3D(1.5, -2.0, 7.8);
    print(p); // Output: Point3D(1.5, -2.0, 7.8)
    ```

#### `static Point3D get origin`
-   **Signature:** `static Point3D get origin`
-   **Description:** A static getter that returns a `Point3D` at the origin `(0,0,0)`.
-   **Dart Code Example:**
    ```dart
    final center = Point3D.origin;
    print(center); // Output: Point3D(0, 0, 0)
    ```

#### `factory Point3D.fromList(List<num> coords)`
-   **Signature:** `factory Point3D.fromList(List<num> coords)`
-   **Description:** Constructs a new `Point3D` from a list of three numbers representing `x`, `y`, and `z`.
-   **Parameters:**
    -   `coords: List<num>`: A list containing exactly 3 numbers for x, y, and z coordinates.
-   **Throws:** `ArgumentError` if the list does not contain exactly 3 numbers.
-   **Dart Code Example:**
    ```dart
    final pList = Point3D.fromList([10, 20, -5]);
    print(pList); // Output: Point3D(10, 20, -5)
    ```

#### `factory Point3D.fromSphericalCoordinates(num r, num theta, num phi)`
-   **Signature:** `factory Point3D.fromSphericalCoordinates(num r, num theta, num phi)`
-   **Description:** Creates a 3D point from spherical coordinates.
-   **Parameters:**
    -   `r: num`: The radial distance from the origin (radius).
    -   `theta: num`: The azimuthal angle in radians (angle in the xy-plane from the x-axis).
    -   `phi: num`: The polar (or inclination) angle in radians (angle from the positive z-axis).
-   **Conversion Formula Used:**
    `x = r * sin(phi) * cos(theta)`
    `y = r * sin(phi) * sin(theta)`
    `z = r * cos(phi)`
-   **Dart Code Example:**
    ```dart
    // r=1, theta=pi/4 (45 deg), phi=pi/4 (45 deg)
    // x = 1 * sin(pi/4) * cos(pi/4) = (1/√2)*(1/√2) = 0.5
    // y = 1 * sin(pi/4) * sin(pi/4) = (1/√2)*(1/√2) = 0.5
    // z = 1 * cos(pi/4) = 1/√2 approx 0.707
    final pSphere = Point3D.fromSphericalCoordinates(1, pi / 4, pi / 4);
    print(pSphere); // Output: Point3D(0.500..., 0.500..., 0.707...)
    ```

### Point3D Properties
-   **`x: num`**: The x-coordinate. Mutable.
-   **`y: num`**: The y-coordinate. Mutable.
-   **`z: num`**: The z-coordinate. Mutable.
    ```dart
    final p = Point3D(1, 2, 3);
    p.z = 10;
    print('x: ${p.x}, y: ${p.y}, z: ${p.z}'); // Output: x: 1, y: 2, z: 10
    ```

### Point3D Methods
-   **`toVector() -> Vector3`**: Converts this `Point3D` to a `Vector3`.
-   **`toList() -> List<num>`**: Returns a list `[x, y, z]`.
-   **`rotate(Angle angle) -> Point3D`**: Rotates the point around the Z-AXIS by `angle.rad` counter-clockwise. X and Y coordinates are updated. Z remains unchanged. *(Conceptual: `Angle` class details not fully available).*
    ```dart
    // Assuming Angle class instance: final angle90 = Angle(rad: pi/2);
    print(Point3D(1,0,5).rotate(Angle(rad: pi/2))); // Approx. Point3D(0,1,5)
    ```
-   **`rotateBy(num angle, [Point3D? origin]) -> Point3D`**: Rotates the point around the Z-AXIS passing through `origin` (or world origin if null) by `angle` (in radians). Modifies the point in place and returns self.
-   **`distanceTo(Point3D otherPoint) -> double`**: Euclidean distance in 3D.
-   **`midpointTo(Point3D otherPoint) -> Point3D`**: Midpoint in 3D.
-   **`move(num dx, num dy, num dz) -> Point3D`**: Returns new translated `Point3D`. Same as `translate`.
-   **`scale(num factor) -> Point3D`**: Returns new `Point3D` scaled from origin.
-   **`reflect([Point3D? origin]) -> Point3D`**: Returns new `Point3D` reflected through `origin` (or world origin).
-   **`angleBetween(Point3D otherPoint) -> Angle`**: (2D projection on XY plane) Angle of line segment to `otherPoint` w.r.t positive x-axis. Returns `Angle` object. *(Conceptual: `Angle` class details not fully available).*
-   **`translate(num dx, num dy, num dz) -> Point3D`**: Returns new translated `Point3D`. Same as `move`.
-   **`slopeTo(Point otherPoint) -> double`**: (2D projection on XY plane) Slope of line to `otherPoint`.
-   **`isCollinear(Point3D a, Point3D b) -> bool`**: (2D projection on XY plane) Checks if `this`, `a`, `b` are collinear on the XY plane.
-   **`distanceToLine(Point3D linePoint1, Point3D linePoint2) -> double`**: (2D projection on XY plane) Shortest distance to line on XY plane.
-   **`bearingTo(Point3D point) -> Angle`**: (2D projection on XY plane) Bearing to `point` relative to positive X-axis. Returns `Angle`. *(Conceptual: `Angle` class details not fully available).*
-   **`distanceToCircle(Point3D center, double radius) -> double`**: (2D projection on XY plane) Shortest distance to circle boundary.
-   **`distanceToPolyline(List<Point3D> polyline) -> double`**: (2D projection on XY plane) Shortest distance to polyline.
-   **`interpolate(Point3D point1, Point3D point2) -> Point3D`**: Linear interpolation: `point1 + this.x * (point2 - point1)`. `this.x` is the ratio `t`. (Interpolates x, y, and z).
-   **`triangleArea(Point3D point1, Point3D point2) -> double`**: (2D projection on XY plane) Area of triangle.
-   **`isInsidePolygon(List<Point3D> polygon, [double tolerance = 1e-10]) -> bool`**: (2D projection on XY plane) True if point is inside or on boundary of CCW `polygon`.
-   **`isOnLineSegment(Point3D pointA, Point3D pointB, [double tolerance = 1e-10]) -> bool`**: (2D projection on XY plane) True if point is on segment.

### Point3D Operators
-   **`operator -(Point3D other) -> Point3D`**: Subtracts coordinates.
-   **`operator +(Point3D other) -> Point3D`**: Adds coordinates.
-   **`operator *(num scalar) -> Point3D`**: Scales coordinates by `scalar`.
-   **`operator /(num scalar) -> Point3D`**: Divides coordinates by `scalar`. Throws `ArgumentError` if `scalar` is 0.
-   **`operator ==(Object other) -> bool`**: True if `other` is `Point3D` and `x,y,z` are equal.
    ```dart
    final p1 = Point3D(1,2,3);
    final p2 = Point3D(0.5, 1, 1);
    print(p1 - p2);   // Output: Point3D(0.5, 1.0, 2.0)
    print(p1 * 2);    // Output: Point3D(2.0, 4.0, 6.0)
    ```

### Point3D Static Methods
-   **`static Point3D get origin`**: Returns `Point3D(0,0,0)`. (Also a constructor).

---
