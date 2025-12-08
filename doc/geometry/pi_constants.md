# Pi Constants and Angle Utilities

This document covers mathematical constants related to Pi and utility functions for angle conversions and Pi calculations, primarily from `lib/src/math/geometry/pi.dart`.

## Table of Contents

- [Pi-related Constants](#pi-related-constants)
- [Angle Conversion Utilities](#angle-conversion-utilities)
- [Pi Calculation (`PI` Class)](#pi-calculation-pi-class)
  - [Overview](#pi-class-overview)
  - [PiCalcAlgorithm Enum](#picalcalgorithm-enum)
  - [Constructor](#pi-constructor)
  - [Properties](#pi-properties)
  - [Methods](#pi-methods)
  - [PiAlgorithm Base Class](#pialgorithm-base-class)
  - [Specific Pi Algorithms](#specific-pi-algorithms)

---

## Pi-related Constants

_(Note: Standard `pi` from `dart:math` is typically used. This section will document any Pi-related constants defined specifically within `lib/src/math/geometry/pi.dart`. If none are defined directly as top-level constants, this section might remain minimal or refer to `dart:math`.)_

The `dart:math` library provides the fundamental constant `pi`.

- **`pi` (from `dart:math`)**:
  - **Type:** `double`
  - **Value:** Approximately `3.141592653589793`
  - **Description:** The ratio of a circle's circumference to its diameter.

The `lib/src/math/geometry/pi.dart` file itself does not define top-level constants like `tau`, `halfPi`, or `quarterPi`. These can be easily derived from `dart:math.pi`:

```dart
import 'dart:math';

final double tau = 2 * pi;       // Approx. 6.283185307179586
final double halfPi = pi / 2;    // Approx. 1.5707963267948966
final double quarterPi = pi / 4; // Approx. 0.7853981633974483
```

## Angle Conversion Utilities

_(Note: The `Angle` class itself, which might contain these, was not read. These are common utility functions often found alongside Pi constants. If they are top-level in `pi.dart` or a related utility file that was read, they will be documented here. Otherwise, this section is based on common practice.)_

Standard angle conversions are fundamental in geometry. While `pi.dart` focuses on Pi calculation, conversion functions like `degreesToRadians` and `radiansToDegrees` are often used. If not present in `pi.dart`, they might be part of the `Angle` class or another utility.

**Conceptual Example (if these were top-level functions):**

- **`degreesToRadians(double degrees)`**

  - **Signature:** `double degreesToRadians(double degrees)`
  - **Description:** Converts an angle from degrees to radians.
  - **Formula:** `radians = degrees * (pi / 180)`
  - **Dart Code Example:**
    ```dart
    // double radians = degreesToRadians(180.0);
    // print(radians); // Output: 3.141592653589793 (pi)
    ```

- **`radiansToDegrees(double radians)`** - **Signature:** `double radiansToDegrees(double radians)` - **Description:** Converts an angle from radians to degrees. - **Formula:** `degrees = radians * (180 / pi)` - **Dart Code Example:**
  `dart
        // double degrees = radiansToDegrees(pi);
        // print(degrees); // Output: 180.0
        `
  _The `Angle` class (if available and read) would likely encapsulate these conversions or provide direct degree/radian properties._

## Pi Calculation (`PI` Class)

_(Documentation for the `PI` class and related algorithms from `lib/src/math/geometry/pi.dart`)_

### Pi Class Overview

The `PI` class (extends `Decimal`) provides methods for calculating the value of Pi (π) to a specified precision using various algorithms. This is useful for applications requiring a higher precision of Pi than `dart:math.pi` offers. The computed Pi value is stored as a `Decimal` internally, allowing for arbitrary precision.

### `PiCalcAlgorithm` Enum

- **Description:** Specifies the algorithm to be used for calculating Pi.
- **Values:**
  - `GaussLegendre`
  - `Chudnovsky`
  - `BBP` (Bailey–Borwein–Plouffe)
  - `Madhava`
  - `Ramanujan`
  - `NewtonEuler`

### PI Constructor

- **Signature:** `factory PI({PiCalcAlgorithm algorithm = PiCalcAlgorithm.Ramanujan, int? precision})`
- **Description:** Creates a `PI` instance, calculating Pi using the specified `algorithm` to the given `precision` (number of decimal places).
- **Parameters:**
  - `algorithm: PiCalcAlgorithm` (optional): The algorithm to use. Defaults to `PiCalcAlgorithm.Ramanujan`.
  - `precision: int?` (optional): The number of decimal places to compute Pi to. If not provided, it uses the global `decimalPrecision` (defaulting to 50 if not otherwise set via `Decimal.setPrecision()`).
- **Dart Code Example:**

  ```dart
  // Calculate Pi to 30 decimal places using default (Ramanujan) algorithm
  final piDefault = PI(precision: 30);
  print(piDefault.toString()); // Output: 3.141592653589793238462643383279 (approx.)

  // Calculate Pi using Gauss-Legendre algorithm
  final piGauss = PI(algorithm: PiCalcAlgorithm.GaussLegendre, precision: 20);
  print(piGauss.toString()); // Output: 3.14159265358979323846 (approx.)
  ```

### PI Properties

- **`precision: int`**: The number of decimal places to which Pi was computed for this instance.
- **`value: Decimal`**: The computed value of Pi as a `Decimal` object. (Inherited from `Decimal` as `PI extends Decimal`).
- **`timePerDigit: double`**: The average time taken to compute one digit of Pi (in milliseconds), specific to the last calculation.
- **`totalDuration: int`**: The total time taken for the last Pi calculation (in milliseconds).

  ```dart
  final piVal = PI(precision: 15);
  print('Pi Value: ${piVal.value}');
  print('Precision: ${piVal.precision}');
  print('Time per digit (ms): ${piVal.timePerDigit}');
  print('Total duration (ms): ${piVal.totalDuration}');
  ```

### PI Methods

- **`getNthDigit(int n) -> int`**: Retrieves the n-th decimal digit of the computed Pi (where `n=1` is the first digit after "3.").

  - Throws `ArgumentError` if `n` is out of bounds.

  ```dart
  final piVal = PI(precision: 10); // e.g., 3.1415926535
  print(piVal.getNthDigit(1)); // Output: 1
  print(piVal.getNthDigit(10)); // Output: 5
  ```

- **`containsPattern(String pattern) -> bool`**: Checks if a given `pattern` (string of digits) exists in the decimal part of the computed Pi.

  ```dart
  final piVal = PI(precision: 50);
  print(piVal.containsPattern("14159")); // Output: true
  print(piVal.containsPattern("999999")); // Output: (depends on precision, likely false for 50)
  ```

- **`getDigits(int start, int end) -> String`**: Retrieves digits of Pi from `start` to `end` index (inclusive, 1-based for decimal part).

  ```dart
  final piVal = PI(precision: 20); // e.g., 3.14159265358979323846
  print(piVal.getDigits(1, 5)); // Output: 14159
  print(piVal.getDigits(18, 20)); // Output: 846
  ```

- **`compute<T>(Decimal Function(Decimal piValue) func) -> Decimal`**: Applies a user-provided function `func` to the computed `Decimal` value of Pi.

  ```dart
  final piVal = PI(precision: 20);
  // Calculate circumference: 2 * pi * r
  Decimal radius = Decimal("10.0");
  Decimal circumference = piVal.compute((piDecimal) => Decimal("2.0") * piDecimal * radius);
  print(circumference); // Output: 62.8318530717958647692 (approx.)
  ```

- **`countDigitFrequency() -> Map<String, int>`**: Counts the frequency of each digit (0-9) in the decimal part of the computed Pi.

  ```dart
  final piVal = PI(precision: 100); // Compute more digits for meaningful frequency
  Map<String, int> frequencies = piVal.countDigitFrequency();
  print(frequencies); // Output: e.g., {0: 8, 1: 8, 2: 12, ...}
  ```

- **`findPatternIndices(String pattern) -> Map<String, dynamic>`**: Finds all occurrences of `pattern` in the decimal part of Pi.

  - Returns a map: `{"frequency": int, "indices": List<int>}` (indices are 0-based from start of decimal part"../../doc/geometry").

  ```dart
  final piVal = PI(precision: 70); // Pi = 3.141592653589793238462643383279502884197169399375105820974944...
  Map<String, dynamic> occurrences = piVal.findPatternIndices("99");
  print(occurrences); // Output: {frequency: 2, indices: [43, 45]} (approx. indices for 9937, 9375)
                      // Actual pattern "99" starts at index 43 (993) and 45 (399)
  ```

- **`toString() -> String`**: Returns the string representation of Pi (inherited from `Decimal`, uses `toStringAsFixed(precision)` effectively).

### `PiAlgorithm` Base Class

- **Description:** An abstract class defining the interface for Pi calculation algorithms.
- **Properties:**
  - `digits: int`: Target number of decimal places.
  - `digitsPerIteration: double`: An estimate of how many correct digits the algorithm typically produces per iteration (used to estimate total iterations).
  - `startTime: int`, `endTime: int`: Timestamps for performance measurement.
- **Methods:**
  - `Decimal factorial(int n)`: Helper to calculate factorials.
  - `double getTimePerDigit()`: Calculates average time per digit.
  - `int getTotalTime()`: Total calculation time in milliseconds.
  - `Decimal calculate()`: Abstract method to be implemented by specific algorithms.

### Specific Pi Algorithms

The `PI` factory constructor can use one of the following algorithms (subclasses of `PiAlgorithm`):

- **`BBP`**: Bailey–Borwein–Plouffe formula. Known for its ability to calculate distant hexadecimal digits of Pi without calculating preceding ones (though this implementation calculates all digits up to precision).
- **`Madhava`**: Based on the Madhava-Leibniz series, an infinite series for Pi.
- **`Chudnovsky`**: A fast algorithm for calculating a large number of digits of Pi.
- **`GaussLegendre`**: An iterative algorithm known for its quadratic convergence.
- **`Ramanujan`**: Based on series discovered by Srinivasa Ramanujan.
- **`NewtonEuler`**: Likely refers to Newton's method or Euler's contributions to Pi series.

The choice of algorithm can affect performance and memory usage, especially for very high precision. `Ramanujan` is the default.

---
