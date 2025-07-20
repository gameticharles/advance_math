# Lines

This document covers the `Line` class, used for representing lines in 2D space.

## Table of Contents
- [Line Class (`line.dart`)](#line-class)
  - [Overview](#line-overview)
  - [Constructors](#line-constructors)
  - [Properties](#line-properties)
  - [Methods](#line-methods)
  - [Operators](#line-operators)
  - [Static Methods](#line-static-methods)

---

## Line Class (`line.dart`)
*(Documentation for the `Line` class from `lib/src/math/geometry/line.dart`)*

### Line Overview
The `Line` class represents a line segment in a 2-dimensional space. A line is defined by two distinct `Point` objects, `point1` and `point2`. The class also provides factory constructors to define a line using other parameters like a gradient and y-intercept, or a point and gradient.

Functionality includes:
- Calculating length, slope, y-intercept, and midpoint.
- Checking if a point lies on the line segment.
- Finding the perpendicular bisector.
- Determining the angle between this line and another line.
- Finding points of intersection.
- Checking for parallelism and perpendicularity with another line.

All points and calculations are assumed to be in 2D space; z-coordinates of `Point` objects are ignored.

### Line Constructors

#### `Line({Point? p1, Point? p2, num? y, num? gradient = 0, num? intercept = 0, num? x})` (Factory Constructor)
-   **Signature:** `factory Line({Point? p1, Point? p2, num? y, num? gradient = 0, num? intercept = 0, num? x})`
-   **Description:** Creates a `Line` instance. The line can be defined in several ways:
    1.  **Two Points:** If `p1` and `p2` are provided. They must be distinct.
    2.  **Gradient, Intercept, and X-coordinate:** If `gradient`, `intercept`, and `x` are provided. Defines a point `(x, gradient*x + intercept)` and another point `(x+1, gradient*(x+1) + intercept)`.
    3.  **Y-coordinate, Gradient, and Intercept:** If `y`, `gradient`, and `intercept` are provided. Calculates two points on the line.
    4.  **Y-coordinate, Gradient, and X-coordinate:** If `y`, `gradient`, and `x` are provided. Defines the point `(x,y)` and calculates the intercept, then finds a second point.
    5.  **Gradient and Intercept:** If `gradient` and `intercept` are provided (and `x`, `y` are null). Defines points `(0, intercept)` and `(1, gradient + intercept)`.
-   **Throws:** `ArgumentError` if the provided parameters are insufficient to define a distinct line or if `p1` and `p2` are identical.
-   **Dart Code Examples:**
    ```dart
    final lineFromPoints = Line(p1: Point(1, 1), p2: Point(3, 5));
    print(lineFromPoints); // Output: Line(Point(1, 1), Point(3, 5))

    // y = 2x + 1, using x=0 for first point
    final lineFromGradIntercept = Line(gradient: 2, intercept: 1);
    print(lineFromGradIntercept); // Output: Line(Point(0.0, 1.0), Point(1.0, 3.0))

    // y = 2x + 1, using x=3 to define a point on the line
    final lineGradInterceptX = Line(gradient: 2, intercept: 1, x: 3);
    print(lineGradInterceptX); // Output: Line(Point(3.0, 7.0), Point(4.0, 9.0))
    
    // Point (x,y) = (2,5) and gradient = 3. Intercept = y - m*x = 5 - 3*2 = -1
    // Line: y = 3x - 1
    final linePointGradient = Line(x: 2, y: 5, gradient: 3);
    print(linePointGradient); // Output: Line(Point(2.0, 5.0), Point(3.0, 8.0))
    ```

### Line Properties
-   **`point1: Point`**: The first point defining the line segment.
-   **`point2: Point`**: The second point defining the line segment.
    *(Note: `_gradient` and `_intercept` are private but their values are accessible via `slope()` and `intercept()` methods if the line was constructed using them.)*

    ```dart
    final p1 = Point(0,0);
    final p2 = Point(4,2);
    final line = Line(p1: p1, p2: p2);
    print(line.point1); // Output: Point(0, 0)
    print(line.point2); // Output: Point(4, 2)
    ```

### Line Methods

#### `List<Point> toList()`
-   **Description:** Returns a list containing the two `Point` objects that define the line.
-   **Returns:** `List<Point>`: `[point1, point2]`.
-   **Example:**
    ```dart
    final line = Line(p1: Point(1,1), p2: Point(2,3));
    print(line.toList()); // Output: [Point(1, 1), Point(2, 3)]
    ```

#### `num length()`
-   **Description:** Calculates the length of the line segment (Euclidean distance between `point1` and `point2`).
-   **Returns:** `num`: The length.
-   **Example:**
    ```dart
    final line = Line(p1: Point(0,0), p2: Point(3,4));
    print(line.length()); // Output: 5.0
    ```

#### `num slope()`
-   **Description:** Calculates the slope of the line. If the line was constructed with a gradient, that gradient is returned. Otherwise, it's calculated as `(point2.y - point1.y) / (point2.x - point1.x)`. Returns `double.infinity` or `double.negativeInfinity` for vertical lines.
-   **Returns:** `num`: The slope.
-   **Example:**
    ```dart
    print(Line(p1: Point(1,1), p2: Point(3,5)).slope()); // Output: 2.0
    print(Line(gradient: -0.5, intercept: 2).slope()); // Output: -0.5
    print(Line(p1: Point(1,1), p2: Point(1,5)).slope()); // Output: Infinity
    ```

#### `num intercept()`
-   **Description:** Calculates the y-intercept of the line (the y-coordinate where the line crosses the y-axis). If the line was constructed with an intercept, that intercept is returned. Otherwise, it's calculated using `point1.y - slope() * point1.x`.
-   **Returns:** `num`: The y-intercept.
-   **Example:**
    ```dart
    print(Line(p1: Point(1,3), p2: Point(2,5)).intercept()); // Slope is 2. Intercept = 3 - 2*1 = 1. Output: 1.0
    print(Line(gradient: 2, intercept: 5).intercept());  // Output: 5
    ```

#### `Point midpoint()`
-   **Description:** Calculates the midpoint of the line segment.
-   **Returns:** `Point`: The midpoint.
-   **Example:**
    ```dart
    final line = Line(p1: Point(0,0), p2: Point(4,6));
    print(line.midpoint()); // Output: Point(2.0, 3.0)
    ```

#### `bool containsPoint(Point point)`
-   **Description:** Checks if the given `point` lies on this line segment. It verifies collinearity and then checks if the sum of distances from the point to `point1` and `point2` equals the line's length (within a small tolerance `1e-10`).
-   **Parameters:**
    -   `point: Point`: The point to check.
-   **Returns:** `bool`: `true` if the point is on the segment, `false` otherwise.
-   **Example:**
    ```dart
    final line = Line(p1: Point(0,0), p2: Point(4,4));
    print(line.containsPoint(Point(2,2)));   // Output: true
    print(line.containsPoint(Point(5,5)));   // Output: false (collinear, but outside segment)
    print(line.containsPoint(Point(1,2)));   // Output: false (not collinear)
    ```

#### `Line perpendicularBisector()`
-   **Description:** Calculates the line that is perpendicular to this line segment and passes through its midpoint.
-   **Returns:** `Line`: The perpendicular bisector.
-   **Example:**
    ```dart
    // Line y = x (slope 1), midpoint (1.5, 1.5)
    final line = Line(p1: Point(1,1), p2: Point(2,2));
    // Perpendicular slope = -1. Perpendicular line: y - 1.5 = -1 * (x - 1.5) => y = -x + 3
    // Point1 of bisector is midpoint (1.5, 1.5).
    // Point2 uses x = midpoint.x + 1 = 2.5. y = -2.5 + 3 = 0.5. So, Point(2.5, 0.5)
    print(line.perpendicularBisector()); // Output: Line(Point(1.5, 1.5), Point(2.5, 0.5))
    ```

#### `double angleBetween(Line otherLine)`
-   **Description:** Calculates the acute angle (in degrees) between this line and `otherLine`. Uses the formula `atan(abs((m2 - m1) / (1 + m1*m2)))`.
-   **Returns:** `double`: The angle in degrees.
-   **Example:**
    ```dart
    final line1 = Line(p1: Point(0,0), p2: Point(1,1)); // Slope = 1 (45 degrees)
    final line2 = Line(p1: Point(0,0), p2: Point(1,0)); // Slope = 0 (0 degrees)
    print(line1.angleBetween(line2)); // Output: 45.0

    final line3 = Line(p1: Point(0,0), p2: Point(0,1)); // Vertical (slope infinity)
    // print(line1.angleBetween(line3)); // May result in issues due to infinite slope handling in formula
    ```

#### `Point pointAtDistance(Point point, double distance)`
-   **Description:** Finds a point on this line at a specified `distance` from a given `point` that must also be on this line. The direction is along the vector from `point1` to `point2`.
-   **Throws:** `ArgumentError` if the initial `point` is not on the line.
-   **Returns:** `Point`: The new point on the line.
-   **Example:**
    ```dart
    final line = Line(p1: Point(0,0), p2: Point(3,4)); // Length 5
    final startPoint = Point(0,0);
    print(line.pointAtDistance(startPoint, 2.5)); // Midpoint. Output: Point(1.5, 2.0)
    print(line.pointAtDistance(startPoint, 5.0));  // Endpoint p2. Output: Point(3.0, 4.0)
    // print(line.pointAtDistance(Point(1,0), 1.0)); // Throws ArgumentError
    ```

#### `Point? intersection(Line otherLine)`
-   **Description:** Calculates the intersection point of this line and `otherLine`.
-   **Returns:** `Point?`: The intersection point, or `null` if the lines are parallel (slopes are equal).
-   **Example:**
    ```dart
    final line1 = Line(p1: Point(0,0), p2: Point(2,2)); // y = x
    final line2 = Line(p1: Point(0,2), p2: Point(2,0)); // y = -x + 2
    // Intersection: x = -x + 2 => 2x = 2 => x = 1. y = 1.
    print(line1.intersection(line2)); // Output: Point(1.0, 1.0)

    final line3 = Line(p1: Point(0,0), p2: Point(1,1)); // y = x
    final line4 = Line(p1: Point(0,1), p2: Point(1,2)); // y = x + 1 (parallel)
    print(line3.intersection(line4)); // Output: null
    ```

#### `bool parallelTo(Line otherLine)`
-   **Description:** Checks if this line is parallel to `otherLine` (slopes are exactly equal).
-   **Returns:** `bool`.
-   **Example:**
    ```dart
    final line1 = Line(gradient: 2, intercept: 1);
    final line2 = Line(gradient: 2, intercept: 5);
    print(line1.parallelTo(line2)); // Output: true
    ```

#### `bool perpendicularTo(Line otherLine)`
-   **Description:** Checks if this line is perpendicular to `otherLine` (product of slopes is -1).
-   **Returns:** `bool`.
-   **Example:**
    ```dart
    final line1 = Line(gradient: 2);
    final line2 = Line(gradient: -0.5);
    print(line1.perpendicularTo(line2)); // Output: true
    ```

#### `bool isParallel(Line otherLine, [double tolerance = 1e-9])`
-   **Description:** Checks if this line is parallel to `otherLine` within a given `tolerance` for slope difference.
-   **Returns:** `bool`.
-   **Example:**
    ```dart
    final line1 = Line(gradient: 1.0000000001);
    final line2 = Line(gradient: 1.0);
    print(line1.isParallel(line2)); // Output: true (with default tolerance)
    ```

#### `bool isPerpendicular(Line otherLine, [double tolerance = 1e-9])`
-   **Description:** Checks if this line is perpendicular to `otherLine` within `tolerance` (i.e., `abs(slope1 * slope2 + 1) < tolerance`).
-   **Returns:** `bool`.
-   **Example:**
    ```dart
    final line1 = Line(gradient: 2.0000000001);
    final line2 = Line(gradient: -0.5);
    print(line1.isPerpendicular(line2)); // Output: true
    ```

#### `double angleWithXAxis()`
-   **Description:** Calculates the angle (in degrees) that this line makes with the positive x-axis. Uses `atan(slope())`.
-   **Returns:** `double`: Angle in degrees.
-   **Example:**
    ```dart
    print(Line(p1: Point(0,0), p2: Point(1,1)).angleWithXAxis()); // Slope 1. Output: 45.0
    print(Line(p1: Point(0,0), p2: Point(1,0)).angleWithXAxis()); // Slope 0. Output: 0.0
    ```

#### `double angleWithOtherLine(Line otherLine)`
-   **Description:** Calculates the acute angle (in degrees) between this line and `otherLine`. Returns 0.0 if parallel.
-   **Returns:** `double`: Angle in degrees.
-   **Example:**
    ```dart
    final line1 = Line(p1:Point(0,0), p2:Point(1,1)); // 45 deg angle with x-axis
    final line2 = Line(p1:Point(0,0), p2:Point(1,0)); // 0 deg angle with x-axis (x-axis itself)
    print(line1.angleWithOtherLine(line2)); // Output: 45.0
    ```

### Line Operators
*(No specific operators like `==` are overridden directly in the `Line` class snippet from `line.dart`. Comparisons would be based on object identity unless implemented in a superclass or extension.)*

### Line Static Methods
*(No static methods are defined directly in the `Line` class snippet from `line.dart`.)*

---
