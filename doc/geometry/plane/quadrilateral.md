# Quadrilaterals

This document covers various specific types of quadrilaterals, including squares, rectangles, trapezoids, and parallelograms. Each class typically extends `PlaneGeometry` (an abstract class, providing `name` property and abstract `area()` and `perimeter()` methods) and provides methods for calculating area, perimeter, and other shape-specific properties.

## Table of Contents
- [Square](#square)
  - [Overview](#square-overview)
  - [Constructors](#square-constructors)
  - [Properties](#square-properties)
  - [Methods](#square-methods)
- [Rectangle](#rectangle)
  - [Overview](#rectangle-overview)
  - [Constructors](#rectangle-constructors)
  - [Properties](#rectangle-properties)
  - [Methods](#rectangle-methods)
- [Trapezoid](#trapezoid)
  - [Overview](#trapezoid-overview)
  - [Constructors](#trapezoid-constructors)
  - [Properties](#trapezoid-properties)
  - [Methods](#trapezoid-methods)
  - [IsoscelesTrapezoid](#isoscelestrapezoid)
  - [RightTrapezoid](#righttrapezoid)
- [Parallelogram](#parallelogram)
  - [Overview](#parallelogram-overview)
  - [Constructors](#parallelogram-constructors)
  - [Properties](#parallelogram-properties)
  - [Methods](#parallelogram-methods)
- [Rhombus](#rhombus)
  - [Overview](#rhombus-overview)

---

## Square
*(Documentation for the `Square` class from `lib/src/math/geometry/plane/quadrilateral/square.dart`)*

### Square Overview
A `Square` is a regular quadrilateral, meaning it has four equal sides and four equal 90-degree angles (π/2 radians). It is a specific type of rectangle and a specific type of rhombus. It inherits from `PlaneGeometry`.

### Square Constructors

#### `Square(num side)`
-   **Signature:** `Square(this.side)`
-   **Description:** Creates a `Square` with a given `side` length.
-   **Parameters:**
    -   `side: num`: The length of each side of the square.
-   **Dart Code Example:**
    ```dart
    final square = Square(10);
    print('Side: ${square.side}, Area: ${square.area()}, Perimeter: ${square.perimeter()}');
    // Output: Side: 10, Area: 100, Perimeter: 40
    ```

#### `Square.from({num? side, num? diagonal, num? perimeter, num? area, num? inRadius, num? circumRadius})`
-   **Signature:** `Square.from({num? side, num? diagonal, ...})`
-   **Description:** Factory constructor. Creates a `Square` from exactly one of the provided geometric parameters. The side length is calculated based on the given parameter.
-   **Parameters (provide exactly one):**
    -   `side: num?`: Side length.
    -   `diagonal: num?`: Diagonal length. `side = diagonal / sqrt(2)`.
    -   `perimeter: num?`: Perimeter. `side = perimeter / 4`.
    -   `area: num?`: Area. `side = sqrt(area)`.
    -   `inRadius: num?`: Inscribed circle radius (apothem). `side = 2 * inRadius`.
    -   `circumRadius: num?`: Circumscribed circle radius. `side = (2 * circumRadius) / sqrt(2)`.
-   **Throws:** `ArgumentError` if zero or more than one parameter is provided.
-   **Dart Code Example:**
    ```dart
    // import 'dart:math'; // For sqrt
    final squareFromDiagonal = Square.from(diagonal: 10 * sqrt(2)); // side will be 10
    print('From diagonal: side = ${squareFromDiagonal.side}'); // Output: 10.0

    final squareFromArea = Square.from(area: 25); // side will be 5
    print('From area: side = ${squareFromArea.side}'); // Output: 5.0
    ```

### Square Properties
-   **`side: num`**: The length of a side of the square.
-   **`name: String`**: Inherited from `PlaneGeometry`, value is "Square".
-   **`inRadius: num` (getter)**: Radius of the inscribed circle (apothem). Calculated as `side / 2`.
-   **`circumRadius: num` (getter)**: Radius of the circumscribed circle. Calculated as `(side * sqrt(2)) / 2`.

    ```dart
    final sq = Square(6);
    print('Side: ${sq.side}');             // Output: 6
    print('Inradius: ${sq.inRadius}');       // Output: 3.0
    print('Circumradius: ${sq.circumRadius.toStringAsFixed(2)}'); // Output: 4.24
    ```

### Square Methods
-   **`area() -> num`**: Calculates the area of the square (`side * side`).
-   **`perimeter() -> num`**: Calculates the perimeter of the square (`4 * side`).
-   **`diagonal() -> num`**: Calculates the length of the square's diagonal (`side * sqrt(2)`).
-   **`angleBetweenDiagonals() -> Angle`**: Calculates the angle between the diagonals. For a square, this is always π/4 radians (45 degrees). The method returns an `Angle` object conceptually representing this value (e.g., `Angle(rad: atan(1))`). *(Note: `Angle` class details are assumed as its source was not available.)*
    ```dart
    final sq = Square(5);
    print('Area: ${sq.area()}');             // Output: 25
    print('Perimeter: ${sq.perimeter()}');       // Output: 20
    print('Diagonal: ${sq.diagonal().toStringAsFixed(2)}'); // Output: 7.07
    // Assuming Angle class with a .deg getter:
    // Angle angle = sq.angleBetweenDiagonals();
    // print('Angle between diagonals (degrees): ${angle.deg}'); // Conceptual Output: 45.0
    // Actual value in radians from atan(1) is pi/4.
    print('Angle (radians): ${atan(1)}'); // Output: 0.7853981633974483 (pi/4)
    ```

---

## Rectangle
*(Documentation for the `Rectangle` class from `lib/src/math/geometry/plane/quadrilateral/rectangle.dart`)*

### Rectangle Overview
A `Rectangle` is a quadrilateral with four right angles (90 degrees or π/2 radians). Opposite sides are equal in length and parallel. It inherits from `PlaneGeometry`.

### Rectangle Constructors

#### `Rectangle(num length, num width)`
-   **Signature:** `Rectangle(this.length, this.width)`
-   **Description:** Creates a `Rectangle` with given `length` and `width`.
-   **Dart Code Example:**
    ```dart
    final rect = Rectangle(10, 5);
    print('Rectangle: L=${rect.length}, W=${rect.width}'); // Output: Rectangle: L=10, W=5
    ```

#### `Rectangle.from({num? length, num? width, num? diagonal, num? perimeter, num? area})`
-   **Signature:** `Rectangle.from({num? length, ...})`
-   **Description:** Factory constructor. Creates a `Rectangle` from exactly two provided parameters, calculating the others.
-   **Parameters (provide exactly two):**
    -   `length: num?`
    -   `width: num?`
    -   `diagonal: num?`
    -   `perimeter: num?`
    -   `area: num?`
-   **Throws:** `ArgumentError` if parameters are insufficient or over-specified leading to ambiguity.
-   **Dart Code Example:**
    ```dart
    // import 'dart:math'; // For sqrt
    final r1 = Rectangle.from(diagonal: 5, width: 3); // length will be sqrt(5^2 - 3^2) = 4
    print('r1: L=${r1.length}, W=${r1.width}'); // Output: r1: L=4.0, W=3

    final r2 = Rectangle.from(perimeter: 30, length: 10); // 2*(10+W)=30 => 10+W=15 => W=5
    print('r2: L=${r2.length}, W=${r2.width}'); // Output: r2: L=10, W=5.0
    ```

### Rectangle Properties
-   **`length: num`**: The length of the rectangle.
-   **`width: num`**: The width of the rectangle.
-   **`name: String`**: Inherited, value is "Rectangle".

### Rectangle Methods
-   **`area() -> num`**: Returns `length * width`.
-   **`perimeter() -> num`**: Returns `2 * (length + width)`.
-   **`diagonal() -> double`**: Returns `sqrt(length² + width²)`.
-   **`perimeterRatio() -> double`**: Calculates `perimeter() / (2 * diagonal())`.
-   **`aspectRatio() -> double`**: Returns the ratio of the shorter side to the longer side, or 1 if it's a square (`min(length, width) / max(length, width)`).
-   **`anglesBetweenDiagonals() -> ({Angle a, Angle b})`**: Returns a record containing the two unique angles (as `Angle` objects, in radians) formed by the intersection of the diagonals: `a = atan(width/length)`, `b = atan(length/width)`. *(Conceptual: `Angle` class)*
    ```dart
    final rect = Rectangle(4, 3);
    print('Area: ${rect.area()}');             // Output: 12
    print('Perimeter: ${rect.perimeter()}');       // Output: 14
    print('Diagonal: ${rect.diagonal()}');         // Output: 5.0
    print('Aspect Ratio: ${rect.aspectRatio()}');    // Output: 0.75 (3/4)
    // final diagAngles = rect.anglesBetweenDiagonals();
    // print('Diag Angle A (rad): ${diagAngles.a.rad}'); // Conceptual: atan(3/4) ~ 0.6435 rad
    // print('Diag Angle B (rad): ${diagAngles.b.rad}'); // Conceptual: atan(4/3) ~ 0.9273 rad
    ```

---

## Trapezoid
*(Documentation for `Trapezoid` and its subclasses from `lib/src/math/geometry/plane/quadrilateral/trapezoid.dart`)*

### Trapezoid Overview
A `Trapezoid` (or trapezium) is a quadrilateral with at least one pair of parallel sides (called bases). Inherits from `PlaneGeometry`.

### Trapezoid Constructors

#### `Trapezoid(num base1, num base2, num side1, num side2, num height)`
-   **Signature:** `Trapezoid(this.base1, this.base2, this.side1, this.side2, this.height)`
-   **Description:** Creates a `Trapezoid` from its two parallel `base1`, `base2`, two non-parallel `side1`, `side2`, and perpendicular `height`.
-   **Dart Code Example:**
    ```dart
    final trap = Trapezoid(10, 6, 5, 5, 4); // Defines an isosceles trapezoid
    print('Area: ${trap.area()}'); // Output: 32.0
    ```

#### `Trapezoid.from({num? base1, num? base2, num? side1, num? side2, num? height})`
-   **Signature:** `Trapezoid.from({...})`
-   **Description:** Factory constructor. Creates a `Trapezoid`. The source code's logic for this factory constructor is complex; it generally expects three parameters to define the trapezoid, but the combinations are specific and may involve assumptions. For predictable behavior, providing all five direct parameters to the main constructor is recommended, or using the specialized type constructors (`IsoscelesTrapezoid`, `RightTrapezoid`).
-   **Throws:** `ArgumentError` if parameters are insufficient for its internal derivation logic.

### Trapezoid Properties
-   **`base1, base2: num`**: Lengths of the parallel bases.
-   **`side1, side2: num`**: Lengths of the non-parallel sides.
-   **`height: num`**: Perpendicular distance between bases.
-   **`name: String`**: Inherited, value is "Trapezoid".

### Trapezoid Methods
-   **`area() -> double`**: Returns `(height / 2) * (base1 + base2)`.
-   **`perimeter() -> double`**: Returns `base1 + base2 + side1 + side2`.
-   **`median() -> double`**: Length of the median: `(base1 + base2) / 2`.
-   **`sideLengthB(double angleAlpha, double angleBeta) -> double`**: Calculates `base2` (assuming `this.base1` is 'a' in formula) using `this.base1 - height * (1/tan(angleAlpha) + 1/tan(angleBeta))`. Angles are in radians. *This method seems to recalculate a base, which is unusual given bases are constructor parameters.*
-   **`sideLengthC(double angleAlpha) -> double`**: Calculates a non-parallel side length (e.g., `side1`) using `height / sin(angleAlpha)`.
-   **`sideLengthD(double angleBeta) -> double`**: Calculates the other non-parallel side length (e.g., `side2`) using `height / sin(angleBeta)`.
-   **`diagonals() -> List<double>`**: Calculates lengths of the two diagonals.
-   **`angles() -> List<double>`**: Calculates the four interior angles in radians.
    ```dart
    final t = Trapezoid(10, 6, 5, 5, 4); // Isosceles
    print('Area: ${t.area()}');       // Output: 32.0
    print('Median: ${t.median()}');     // Output: 8.0
    // Example angles for an isosceles trapezoid with b1=10, b2=6, sides=5, h=4:
    // The horizontal projection of non-parallel side is (10-6)/2 = 2.
    // Base angles: acos(2/5) approx 1.159 rad (66.4 deg)
    // Other angles: pi - acos(2/5) approx 1.982 rad (113.6 deg)
    // print('Angles (rad): ${t.angles().map((r) => r.toStringAsFixed(2)).toList()}');
    ```

### IsoscelesTrapezoid
-   **Overview:** A `Trapezoid` where the non-parallel sides are equal. Extends `Trapezoid`.
-   **Constructors:**
    -   `IsoscelesTrapezoid(num base1, num base2, num side, num height)`: `side` is the length of the equal non-parallel sides.
    -   `IsoscelesTrapezoid.from({num? base1, num? base2, num? side, num? height})`: Named constructor delegating to `Trapezoid.from` by setting `side1` and `side2` to the provided `side`.

### RightTrapezoid
-   **Overview:** A `Trapezoid` where one of the non-parallel sides is perpendicular to the bases (its length is equal to the `height`). Extends `Trapezoid`.
-   **Constructors:**
    -   `RightTrapezoid(num base1, num base2, num side, num height)`: `side` is the length of the non-perpendicular (slant) non-parallel side. `height` is used for the perpendicular side (`side2` in the base `Trapezoid` constructor).
    -   `RightTrapezoid.from({num? base1, num? base2, num? side, num? height})`: Named constructor.

---

## Parallelogram
*(Documentation for `Parallelogram` from `lib/src/math/geometry/plane/quadrilateral/parallelogram.dart`)*

### Parallelogram Overview
A `Parallelogram` is a quadrilateral with two pairs of parallel sides. Opposite sides are equal in length, and opposite angles are equal. Inherits from `PlaneGeometry`.

### Parallelogram Constructors

#### `Parallelogram(num base, num side, {num? height1, num? height2, num? angle1, num? angle2})`
-   **Signature:** `Parallelogram(this.base, this.side, {this.height1, ..., this.angle1, ...})`
-   **Description:** Creates a `Parallelogram`. Requires `base` length, adjacent `side` length. Additionally, one of the following must be provided:
    -   `height1`: Height perpendicular to `base`. If provided, `angle1` (angle between `base` and `side`) is calculated.
    -   `angle1`: Angle (in radians) between `base` and `side`. If provided, `height1` is calculated.
    The other height (`height2`, perpendicular to `side`) and angle (`angle2`, supplementary to `angle1`) are derived if possible from the initial set.
-   **Throws:** `ArgumentError` if neither `height1` nor `angle1` is provided (or if other combinations are insufficient for full definition by the `.from` constructor).
-   **Dart Code Example:**
    ```dart
    // import 'dart:math'; // For pi, sin, asin, cos
    final paraAngle = Parallelogram(10, 7, angle1: pi/6); // angle1 = 30 degrees (0.5236 rad)
    // height1 = 7 * sin(pi/6) = 7 * 0.5 = 3.5
    print('H1: ${paraAngle.height1?.toStringAsFixed(1)}, Angle1 (rad): ${paraAngle.angle1?.toStringAsFixed(2)}');
    // Output: H1: 3.5, Angle1 (rad): 0.52

    final paraHeight = Parallelogram(10, 7, height1: 3.5);
    // angle1 = asin(3.5/7.0) = asin(0.5) = pi/6 rad
    print('Angle1 (rad): ${paraHeight.angle1?.toStringAsFixed(2)}'); 
    // Output: Angle1 (rad): 0.52
    ```

#### `Parallelogram.from({...})` (Named Constructor)
-   **Description:** Factory constructor for creating a `Parallelogram` from various combinations of parameters like `base`, `side`, `height1`, `height2`, `angle1`, `angle2`, `area`, `perimeter`. The internal logic attempts to derive the necessary `base`, `side`, `height1`, and `angle1` from the provided set. Requires a valid combination of parameters (typically three) to define the parallelogram.
-   **Throws:** `ArgumentError` if parameters are insufficient or lead to ambiguity.

### Parallelogram Properties
-   **`base: num`**: Length of one side.
-   **`side: num`**: Length of the adjacent side.
-   **`height1: num?`**: Height perpendicular to `base`.
-   **`height2: num?`**: Height perpendicular to `side`.
-   **`angle1: num?`**: Angle (in radians) between `base` and `side`.
-   **`angle2: num?`**: The other interior angle (in radians), `pi - angle1`.
-   **`name: String`**: Inherited, value is "Parallelogram".

### Parallelogram Methods
-   **`area() -> double`**: Returns `base * side * sin(angle1!)`.
-   **`perimeter() -> double`**: Returns `2 * (base + side)`.
-   **`diagonal1() -> double`**: Length of one diagonal, using `angle1`. Formula: `sqrt(base² + side² - 2*base*side*cos(angle1!))`.
-   **`diagonal2() -> double`**: Length of the other diagonal, using `angle2 = pi - angle1!`.
-   **`angles() -> ({Angle a, Angle b})`**: Returns a record of the two unique interior angles (as `Angle` objects, in radians). `a` is `angle1`, `b` is `pi - angle1`. *(Conceptual: `Angle` class)*
-   **`anglesBetweenDiagonals() -> ({Angle a, Angle b})`**: Returns angles (as `Angle` objects, radians) formed by the intersection of the diagonals. *(Conceptual: `Angle` class)*
-   **`verifyDiagonalsCorrelation() -> bool`**: Checks if the sum of the squares of the diagonals equals the sum of the squares of all four sides: `D₁² + D₂² == 2*(base² + side²)`.
    ```dart
    final p = Parallelogram(8, 5, angle1: pi/3); // base=8, side=5, angle1=60 deg
    print('Area: ${p.area().toStringAsFixed(2)}'); // 8 * 5 * sin(60deg) = 40 * sqrt(3)/2 ~ 34.64
    print('Perimeter: ${p.perimeter()}');     // 2 * (8+5) = 26
    print('Diagonal1: ${p.diagonal1().toStringAsFixed(2)}'); // sqrt(64+25 - 2*8*5*cos(60)) = sqrt(89 - 40) = sqrt(49) = 7.00
    print('Diagonal2: ${p.diagonal2().toStringAsFixed(2)}'); // angle2=120deg, cos(120)=-0.5. sqrt(89 - 80*(-0.5)) = sqrt(129) ~ 11.36
    print(p.verifyDiagonalsCorrelation()); // Output: true (49 + 129 = 178; 2*(64+25) = 2*89 = 178)
    ```

---

## Rhombus
*(Source file `lib/src/math/geometry/plane/quadrilateral/rhombus.dart` was empty.)*

### Rhombus Overview
A `Rhombus` is a parallelogram where all four sides are of equal length. Its diagonals are perpendicular bisectors of each other and also bisect the interior angles. It would typically extend `Parallelogram` or `PlaneGeometry`.

*(Since the source file is empty, the following sections are conceptual placeholders based on common properties and methods for a Rhombus class. Actual implementation may vary.)*

### Rhombus Constructors (Conceptual)
-   **`Rhombus({required num side, Angle? angleA, num? diagonal1, num? diagonal2})`**
    -   From `side` and one interior `angleA` (as `Angle` object).
    -   From two `diagonal1` (p) and `diagonal2` (q). Side `s = sqrt((d1/2)² + (d2/2)²)`.
-   **`Rhombus.fromAreaAndAngle(num area, Angle angleA)`**
-   **`Rhombus.fromPerimeterAndAngle(num perimeter, Angle angleA)`**

### Rhombus Properties (Conceptual)
-   **`side: num`**: Length of a side.
-   **`angleA: Angle`**, **`angleB: Angle`**: The two unique interior angles (`angleB = pi - angleA.rad`).
-   **`diagonal1: num (p)`**, **`diagonal2: num (q)`**: Lengths of the diagonals.
-   **`height: num`**: Perpendicular distance between opposite sides (`side * sin(angleA.rad)`).
-   **`inRadius: num`**: Radius of the inscribed circle (`(d1 * d2) / (4 * side)` or `height / 2`).

### Rhombus Methods (Conceptual)
-   **`area() -> num`**: Calculates area (e.g., `(diagonal1 * diagonal2) / 2` or `side² * sin(angleA.rad)`).
-   **`perimeter() -> num`**: Calculates perimeter (`4 * side`).
-   Methods to calculate diagonals from side/angle or vice-versa.

---
