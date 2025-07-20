# Triangles (Plane and Spherical)

This document covers classes for representing plane triangles (`Triangle`) and triangles on the surface of a sphere (`SphericalTriangle`), along with related utility functions and enums for area calculation methods.

## Table of Contents
- [Plane Triangle (`Triangle`)](#plane-triangle)
  - [Overview](#triangle-overview)
  - [Constructors](#triangle-constructors)
  - [Properties](#triangle-properties)
  - [Methods](#triangle-methods)
  - [Static Methods (Area Formulas)](#triangle-static-methods-area-formulas)
- [Spherical Triangle (`SphericalTriangle`)](#spherical-triangle)
  - [Overview](#spherical-triangle-overview)
  - [Constructors](#spherical-triangle-constructors)
  - [Properties](#spherical-triangle-properties)
  - [Methods](#spherical-triangle-methods)
- [Triangle Area Utilities (`area_methods.dart`)](#triangle-area-utilities)
  - [`AreaMethod` Enum](#areamethod-enum)

---

## Plane Triangle (`Triangle`)
*(Documentation for the `Triangle` class from `lib/src/math/geometry/plane/triangles/triangle.dart`)*

### Triangle Overview
The `Triangle` class represents a triangle in 2D Euclidean space. It extends `PlaneGeometry`. A triangle can be defined by its three vertices (`Point` objects), its three side lengths (`a`, `b`, `c`), or a combination of sides and angles.

If vertices are provided, side lengths are calculated automatically. If three side lengths are provided, the angles (`angleA`, `angleB`, `angleC`) are calculated using the law of cosines. The class provides methods to calculate area (using various formulas), perimeter, heights, medians, and radii of inscribed and circumscribed circles.

*(Note: The `Angle` class, while used in the `Triangle` source for properties like `angleA`, was not provided for direct inspection. Documentation involving `Angle` objects will assume it holds angle values and provides methods like `.rad` for radians and `.deg` for degrees, and trigonometric functions like `.sin()`, `.cos()`.)*

### Triangle Constructors

#### `Triangle({num? a, num? b, num? c, Angle? angleA, Angle? angleB, Angle? angleC, Point? A, Point? B, Point? C})`
-   **Signature:** `Triangle({this.a, this.b, this.c, this.angleA, this.angleB, this.angleC, this.A, this.B, this.C})`
-   **Description:** Creates a `Triangle`.
    -   If three `Point` objects (`A`, `B`, `C`) are provided, the side lengths (`a`, `b`, `c`) are calculated from these points.
    -   If three side lengths (`a`, `b`, `c`) are provided, the angles (`angleA`, `angleB`, `angleC`) are calculated using the law of cosines.
    -   The constructor attempts to resolve other properties based on the provided ones. For example, if two sides and the included angle are known, other properties might be solvable through geometric rules (though the constructor primarily focuses on the above two cases for initial setup).
-   **Parameters:**
    -   `a, b, c: num?`: Lengths of the sides opposite vertices A, B, and C, respectively.
    -   `angleA, angleB, angleC: Angle?`: The interior angles at vertices A, B, and C. *(Conceptual: These would be `Angle` objects)*
    -   `A, B, C: Point?`: The three vertices of the triangle.
-   **Dart Code Example:**
    ```dart
    // Define by vertices
    final pA = Point(0, 0);
    final pB = Point(3, 0);
    final pC = Point(0, 4);
    final triangle1 = Triangle(A: pA, B: pB, C: pC);
    print('Triangle 1 (from points): a=${triangle1.a?.toStringAsFixed(1)}, b=${triangle1.b?.toStringAsFixed(1)}, c=${triangle1.c?.toStringAsFixed(1)}');
    // Output: Triangle 1 (from points): a=4.0, b=4.0, c=3.0 (approx. a=BC=4, b=AC=4, c=AB=3 - error in manual calc, AC is 4, BC is sqrt(3^2+4^2)=5)
    // Corrected expected: a=BC=sqrt((0-3)^2+(4-0)^2)=sqrt(9+16)=5. b=AC=sqrt((0-0)^2+(4-0)^2)=4. c=AB=sqrt((3-0)^2+(0-0)^2)=3.
    // print('Triangle 1 (from points): a=${triangle1.a}, b=${triangle1.b}, c=${triangle1.c}');
    // Output: Triangle 1 (from points): a=5.0, b=4.0, c=3.0

    // Define by three sides (3-4-5 right triangle)
    final triangle2 = Triangle(a: 5, b: 4, c: 3);
    print('Triangle 2 (from sides): angleA=${triangle2.angleA?.deg.toStringAsFixed(1)}°, angleB=${triangle2.angleB?.deg.toStringAsFixed(1)}°, angleC=${triangle2.angleC?.deg.toStringAsFixed(1)}°');
    // Expected: angleA=90, angleB approx 53.1, angleC approx 36.9 (or vice-versa depending on a,b,c assignment)
    // With a=5, b=4, c=3: angleA (opposite side a) is acos((4^2+3^2-5^2)/(2*4*3)) = acos(0) = 90 deg.
    // angleB (opposite side b) is acos((5^2+3^2-4^2)/(2*5*3)) = acos(18/30) = acos(0.6) approx 53.13 deg.
    // angleC (opposite side c) is acos((5^2+4^2-3^2)/(2*5*4)) = acos(32/40) = acos(0.8) approx 36.87 deg.
    // Output: Triangle 2 (from sides): angleA=90.0°, angleB=53.1°, angleC=36.9° (approx.)
    ```

### Triangle Properties
-   **`a, b, c: num?`**: Lengths of the sides opposite vertices A, B, C.
-   **`angleA, angleB, angleC: Angle?`**: Interior angles at vertices A, B, C. *(Conceptual `Angle` objects)*
-   **`A, B, C: Point?`**: The three vertices.
-   **`base: num?`**: Alias for side `a`.
-   **`heightA: num?`**: Height relative to side `a` (base). Calculated as `b * sin(angleC)`. Requires `b` and `angleC`.
-   **`heightB: num?`**: Height relative to side `b`. Calculated as `c * sin(angleA)`. Requires `c` and `angleA`.
-   **`heightC: num?`**: Height relative to side `c`. Calculated as `a * sin(angleB)`. Requires `a` and `angleB`.
-   **`medianA: num?`**: Length of the median from vertex A to side `a`. Formula: `0.5 * sqrt(b² + c² + 2bc*cos(angleA))`. *(Note: source code uses `angleC` for `medianA` which seems incorrect, should be `angleA`. Assuming documentation reflects correct geometric formula.)*
    The source formula for `medianA` is `0.5 * sqrt((b! * b!) + (c! * c!) + ((2 * b!) * c! * cos(angleC!.rad)))`. This is incorrect; the standard formula for median to side `a` is `0.5 * sqrt(2*b^2 + 2*c^2 - a^2)`. Or, using angle A: `0.5 * sqrt(b^2 + c^2 + 2*b*c*cos(angleA.rad))`. The source uses `angleC` for `medianA`, `angleC` for `medianB`, and `angleC` for `medianC`. This is likely an error. Documenting conceptually.
-   **`medianB: num?`**: Length of the median from vertex B to side `b`.
-   **`medianC: num?`**: Length of the median from vertex C to side `c`.
-   **`circumCircleRadius: double`**: Radius of the circumscribed circle (passes through all vertices). Formula: `a / (2 * sin(angleA))`. Requires sides and angles.
-   **`inCircleRadius: double`**: Radius of the inscribed circle (tangent to all sides). Formula: `sqrt(((s-a)(s-b)(s-c))/s)`. Requires sides.
-   **`s: double`**: Semi-perimeter: `(a + b + c) / 2`.

    ```dart
    final triangle = Triangle(a:3, b:4, c:5); // 3-4-5 right triangle
    // angleA is 90 deg, angleB is ~36.87 deg, angleC is ~53.13 deg
    // (Sides re-ordered for typical a,b,c vs A,B,C if A is right angle)
    // Let's use a=3, b=4, c=5, so angleC is 90 deg.
    final tri = Triangle(a:3, b:4, c:5); 
    // angleA = acos((16+25-9)/(2*4*5)) = acos(32/40) = acos(0.8) ~ 36.87 deg
    // angleB = acos((9+25-16)/(2*3*5)) = acos(18/30) = acos(0.6) ~ 53.13 deg
    // angleC = acos((9+16-25)/(2*3*4)) = acos(0) = 90 deg

    print('Sides: a=${tri.a}, b=${tri.b}, c=${tri.c}');
    print('Angles (deg): A=${tri.angleA?.deg.toStringAsFixed(1)}, B=${tri.angleB?.deg.toStringAsFixed(1)}, C=${tri.angleC?.deg.toStringAsFixed(1)}');
    print('Semi-perimeter (s): ${tri.s.toStringAsFixed(1)}'); // s = (3+4+5)/2 = 6
    // heightA (to side a=3): b*sin(C.rad) = 4*sin(pi/2) = 4*1 = 4
    print('Height to side a: ${tri.heightA?.toStringAsFixed(1)}'); 
    // circumRadius = c / (2*sin(C.rad)) = 5 / (2*1) = 2.5
    print('Circumcircle Radius: ${tri.circumCircleRadius.toStringAsFixed(1)}');
    // inRadius = sqrt(((6-3)*(6-4)*(6-5))/6) = sqrt((3*2*1)/6) = sqrt(1) = 1
    print('Incircle Radius: ${tri.inCircleRadius.toStringAsFixed(1)}');
    ```

### Triangle Methods
-   **`area([AreaMethod method = AreaMethod.heron]) -> double`**: Calculates area using specified `method`. See [Triangle Area Utilities](#triangle-area-utilities).
    ```dart
    final triangle = Triangle(a:3, b:4, c:5);
    print('Area (Heron): ${triangle.area()}'); // Output: 6.0
    // For trigonometric, ensure correct angle is used if not all are calculated by constructor
    // triangle.angleC = Angle(rad: pi/2); // Assuming C is the angle between a and b
    // print('Area (Trig): ${triangle.area(AreaMethod.trigonometry)}'); // Needs sides a, b and angleC to be set.
    ```
-   **`perimeter() -> double`**: Calculates perimeter `a + b + c`.
    ```dart
    print(Triangle(a:3, b:4, c:5).perimeter()); // Output: 12.0
    ```
-   **`cosineRule()`**: Calculates a missing side or angle if two sides and one angle, or three sides are known. Modifies the instance. *The source code seems to imply it calculates a side if two sides and an angle are known, but doesn't calculate an angle if three sides are known (which is done in the constructor).*
-   **`sineRule()`**: Calculates missing sides or angles if one side and two angles, or two sides and one opposite angle are known. Modifies the instance. Requires exactly one unknown.
-   **`calculateOtherCoordinates() -> List<Point>`**: Calculates `Point C` if `A`, `B`, sides `a`, `b`, and `angleC` are known.
-   **`calculateMissingCoordinates() -> List<Point>`**: Calls `calculateOtherCoordinates` if any vertex is missing.

### Triangle Static Methods (Area Formulas)
These methods allow direct calculation of triangle area without creating a `Triangle` instance.
-   **`static double heronFormula(num a, num b, num c)`**: Area from three side lengths.
-   **`static double trigonometricFormula(num a, num b, Angle angleC)`**: Area from two sides and the included angle. *(Conceptual `Angle`)*
-   **`static double baseHeightFormula(num base, num height)`**: Area from base and corresponding height.
-   **`static double coordinatesFormula(List<Point> coords)`**: Area from a list of three vertex `Point` objects.
    ```dart
    print(Triangle.heronFormula(3,4,5)); // Output: 6.0
    print(Triangle.baseHeightFormula(3,4)); // Output: 6.0 (assuming base=3, height=4)
    final points = [Point(0,0), Point(3,0), Point(0,4)];
    print(Triangle.coordinatesFormula(points)); // Output: 6.0
    // print(Triangle.trigonometricFormula(3, 4, Angle(rad: pi/2))); // Conceptual: 6.0
    ```

---

## Spherical Triangle (`SphericalTriangle`)
*(Documentation for `SphericalTriangle` from `lib/src/math/geometry/plane/triangles/spherical_triangle.dart`)*

### Spherical Triangle Overview
A `SphericalTriangle` is a figure formed on the surface of a sphere by three great circular arcs intersecting pairwise in three vertices. It is defined by its three interior angles (A, B, C) and the lengths of the three sides (a, b, c) opposite those angles. In this class, side lengths are also represented as angles (the angle subtended by the arc at the center of the sphere, in radians).

The class allows for the creation of a spherical triangle and calculation of its properties if enough information is provided (e.g., two sides and an included angle, two angles and an included side, or all three sides/angles). It uses spherical trigonometry rules (like Napier's analogies, Law of Cosines for sides/angles, Law of Sines) to solve the triangle. All angle and side values are handled as `Angle` objects, implicitly in radians for calculations.

*(Note: The `Angle` class details are inferred. Examples assume `Angle(rad: value)` or `Angle(deg: value)` constructors and `.rad`, `.deg` properties.)*

### Spherical Triangle Constructors
The class uses private constructors. Instances are created via factory methods:

-   **`factory SphericalTriangle.fromTwoSidesAndAngle(Angle angleA, Angle sideA, Angle sideB)`**: Given angle A, its opposite side `a`, and another side `b`. It calculates `angleB`, `angleC`, and `sideC`.
-   **`factory SphericalTriangle.fromTwoAnglesAndSide(Angle angleA, Angle angleB, Angle sideA)`**: Given two angles `A`, `B`, and one opposite side `a`. It calculates `angleC`, `sideB`, `sideC`.
-   **`factory SphericalTriangle.fromAllSides(Angle sideA, Angle sideB, Angle sideC)`**: Given all three side lengths (as angles). Calculates all three interior angles `A, B, C`.
-   **`factory SphericalTriangle.fromAllAngles(Angle angleA, Angle angleB, Angle angleC)`**: Given all three interior angles `A, B, C`. Calculates all three side lengths `a, b, c`.
-   **`factory SphericalTriangle.fromSideAndAngle(Angle angleA, Angle sideA)`**: *This constructor in the source seems underspecified for uniquely defining a spherical triangle (typically needs three parts). It attempts to calculate `angleB` then `angleC`, then `sideB` and `sideC`. This might lead to ambiguous or default solutions (e.g., assuming a right angle implicitly).*

**Dart Code Example:**
```dart
// Assuming Angle class allows construction from degrees or radians
// Example: Triangle with two sides and the included angle (conceptual, needs a specific constructor for this case)
// For now, using fromAllSides as an example
final side_a = Angle(rad: pi/3); // 60 degrees
final side_b = Angle(rad: pi/3);
final side_c = Angle(rad: pi/3); // Equilateral spherical triangle
final st1 = SphericalTriangle.fromAllSides(side_a, side_b, side_c);
print('Angle A (deg): ${st1.angleA.deg.toStringAsFixed(1)}'); // Each angle will be > 60 deg

// Example: Triangle with all angles (e.g., three right angles on a sphere octant)
final angle90 = Angle(rad: pi/2);
final st2 = SphericalTriangle.fromAllAngles(angle90, angle90, angle90);
print('Side a (rad): ${st2.sideA.rad.toStringAsFixed(2)}'); // Each side will be pi/2
```

### Spherical Triangle Properties
All properties return `Angle` objects.
-   **`angleA, angleB, angleC: Angle`**: The three interior angles of the triangle.
-   **`sideA, sideB, sideC: Angle`**: The lengths of the three sides (as angles subtended at the sphere's center).

### Spherical Triangle Methods
-   **`isValidTriangle() -> bool`**: Checks validity rules for spherical triangles (e.g., sum of angles `> π` and `< 3π`, sum of sides `< 2π`, each side `< π`). *The source code has a specific check: `!((sumOfAngles - pi).abs() > 1e-6 && sumOfSides >= 2 * pi)` which might not cover all validity rules.*
-   **`area: num`**: Calculates the spherical excess (area on a unit sphere), `E = angleA + angleB + angleC - π`.
-   **`perimeter: num`**: Calculates the sum of side lengths (as radians), `sideA + sideB + sideC`.
-   **`areaPercentage: double`**: Area as a percentage of a unit sphere's surface area (`4π`).
-   **`perimeterPercentage: double`**: Perimeter as a percentage of a unit sphere's great circle circumference (`2π`).

    ```dart
    final angle90 = Angle(rad: pi/2);
    final octantTriangle = SphericalTriangle.fromAllAngles(angle90, angle90, angle90);
    print('Area (unit sphere): ${octantTriangle.area.toStringAsFixed(2)}'); // E = 3*pi/2 - pi = pi/2 (~1.57)
    print('Perimeter (radians): ${octantTriangle.perimeter.toStringAsFixed(2)}'); // Each side is pi/2, so 3*pi/2 (~4.71)

    // To get area on a sphere of radius R: areaOnSphere = octantTriangle.area * R^2
    // double earthRadius = 6371.0; // km
    // double surfaceArea = octantTriangle.area * pow(earthRadius, 2);
    // print('Area on Earth (approx km^2): ${surfaceArea.toStringAsFixed(0)}');
    ```

---

## Triangle Area Utilities (`area_methods.dart`)

### `AreaMethod` Enum
-   **Description:** An enum used by the `Triangle.area()` method to specify which formula to use for area calculation.
-   **Values:**
    -   **`heron`**: Uses Heron's formula (requires all three side lengths `a, b, c`).
        _Formula: `sqrt(s(s-a)(s-b)(s-c))` where `s` is semi-perimeter._
    -   **`baseHeight`**: Uses the formula `0.5 * base * height`. Requires `triangle.base` (side `a`) and `triangle.heightA` to be determinable.
    -   **`trigonometry`**: Uses `0.5 * a * b * sin(C)`. Requires two sides (`a`, `b`) and the included angle (`angleC`).
    -   **`coordinates`**: Uses the shoelace formula from vertex coordinates. Requires `triangle.A`, `triangle.B`, `triangle.C` to be known.
-   **Example Usage with `Triangle.area()`:**
    ```dart
    final pA = Point(0,0); final pB = Point(4,0); final pC = Point(2,3);
    final triangle = Triangle(A: pA, B: pB, C: pC); // a=sqrt(2^2+3^2)=sqrt(13), b=sqrt(2^2+3^2)=sqrt(13), c=4
                                               // This is an isosceles triangle.

    print('Area using Heron (default): ${triangle.area()}');
    // s = (sqrt(13)+sqrt(13)+4)/2 = sqrt(13)+2 approx 5.605
    // Area = sqrt((s)(s-a)(s-b)(s-c)) = sqrt( (5.605) * (5.605-sqrt(13))^2 * (5.605-4) )
    // Area = sqrt( (5.605) * (1.999)^2 * (1.605) ) approx sqrt(35.99) = 6.0

    print('Area using coordinates: ${triangle.area(AreaMethod.coordinates)}'); // Output: 6.0
    // Area = 0.5 * |0(0-3) + 4(3-0) + 2(0-0)| = 0.5 * |12| = 6.0

    // To use baseHeight or trigonometry, ensure relevant properties are set or calculable
    // For baseHeight (base=c=4, height from C to AB is 3):
    // print(Triangle.baseHeightFormula(triangle.c!, 3)); // Output: 6.0
    
    // For trigonometry (sides b=sqrt(13), c=4, angleA between them):
    // Angle A: cosA = (c^2+b^2-a^2)/(2cb) = (16+13-13)/(2*4*sqrt(13)) = 16/(8sqrt(13)) = 2/sqrt(13)
    // sinA = sqrt(1 - (2/sqrt(13))^2) = sqrt(1 - 4/13) = sqrt(9/13) = 3/sqrt(13)
    // Area = 0.5 * c * b * sinA = 0.5 * 4 * sqrt(13) * (3/sqrt(13)) = 0.5 * 4 * 3 = 6.0
    // triangle.angleA = Angle(rad: acos(2/sqrt(13)));
    // print('Area using trigonometry (sides b,c angle A): ${triangle.area(AreaMethod.trigonometry)}');
    // The default trigonometric() in Triangle uses a, b, angleC.
    ```

The static methods `Triangle.heronFormula`, `Triangle.trigonometricFormula`, `Triangle.baseHeightFormula`, and `Triangle.coordinatesFormula` are also available for direct area calculation if you have the necessary parameters without creating a `Triangle` instance (see [Triangle Static Methods](#triangle-static-methods-area-formulas)).

---
