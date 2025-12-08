# Advance Math Library Documentation

A comprehensive Dart library for mathematical programming, offering expressions, complex numbers, algebra, statistics, angles, geometry, and more.

## Table of Contents

1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Quick Start](#quick-start)
4. [Library Structure](#library-structure)
5. [Module Overview](#module-overview)

---

## Introduction

**Advance Math** is a robust Dart library that enriches mathematical programming with a wide range of features beyond vectors and matrices. It provides functionality for:

- **Complex Numbers** - Full complex arithmetic with trigonometric and special functions
- **Linear Algebra** - Matrices, vectors, decompositions, and linear system solvers
- **Expressions** - Symbolic mathematics with variables, derivatives, and integrals
- **Geometry** - 2D/3D points, lines, polygons, circles, and solid geometry
- **Statistics** - Distributions, hypothesis testing, regression, and time series
- **Quantities & Units** - Physical quantities with unit conversions (SI and more)
- **Utilities** - FFT, interpolation, memoization, and extensions

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  advance_math: ^5.4.2
```

Then run:

```bash
dart pub get
```

---

## Quick Start

```dart
import 'package:advance_math/advance_math.dart';

void main() {
  // Complex numbers
  var z = Complex(3, 4);
  print(z.abs());        // 5.0
  print(z.conjugate());  // 3 - 4i

  // Matrices
  var m = Matrix([
    [1, 2],
    [3, 4]
  ]);
  print(m.determinant()); // -2.0
  print(m.inverse());

  // Expressions
  var x = Variable('x');
  var expr = x.pow(2) + 2 * x + 1;
  print(expr.evaluate({'x': 3})); // 16

  // Geometry
  var p1 = Point(0, 0);
  var p2 = Point(3, 4);
  print(p1.distanceTo(p2)); // 5.0

  // Angles
  var angle = Angle.degrees(45);
  print(angle.sin()); // 0.7071...
}
```

---

## Library Structure

```
advance_math/
├── lib/
│   ├── advance_math.dart          # Main library entry
│   └── src/
│       ├── math/
│       │   ├── algebra/           # Matrix, Vector, Expression, Calculus
│       │   ├── basic/             # Core math functions
│       │   ├── geometry/          # 2D/3D geometry
│       │   ├── statistics/        # Statistical analysis
│       │   └── differential_equations/
│       ├── number/
│       │   ├── complex/           # Complex numbers
│       │   ├── decimal/           # Arbitrary precision decimals
│       │   ├── large_numbers/     # Big integers
│       │   └── roman_numerals/    # Roman numeral support
│       ├── quantity/              # Physical quantities & units
│       ├── interpolate/           # 1D/2D interpolation
│       ├── utils/                 # Extensions, FFT, memoization
│       └── code_translator/       # Morse code, number-to-words
```

---

## Module Overview

| Module         | Description                | Key Classes                                |
| -------------- | -------------------------- | ------------------------------------------ |
| **Algebra**    | Linear algebra operations  | `Matrix`, `Vector`, `Expression`           |
| **Basic Math** | Core functions & constants | `Angle`, logarithms, trigonometry          |
| **Geometry**   | 2D/3D shapes               | `Point`, `Line`, `Polygon`, `Circle`       |
| **Statistics** | Statistical analysis       | `Distribution`, `Regression`, `TimeSeries` |
| **Complex**    | Complex number arithmetic  | `Complex`, `ComplexArray`                  |
| **Quantity**   | Physical units             | `Length`, `Mass`, `Time`, `Temperature`    |
| **Utilities**  | Helper functions           | FFT, Interpolation, Memoization            |

---

## Documentation Files

- [01_algebra.md](01_algebra.md) - Matrix, Vector, Expressions, Calculus
- [02_basic_math.md](02_basic_math.md) - Core math functions, Angle class
- [03_geometry.md](03_geometry.md) - 2D/3D geometry classes
- [04_statistics.md](04_statistics.md) - Statistical analysis
- [05_numbers.md](05_numbers.md) - Complex, Decimal, Rational, Roman numerals, etc.
- [06_quantity.md](06_quantity.md) - Physical quantities and units
- [07_utilities.md](07_utilities.md) - FFT, Interpolation, Extensions
- [08_code_translator.md](08_code_translator.md) - Morse code, number-to-words
- [09_interpolate.md](09_interpolate.md) - Interpolation

---

## Related Tests

- [`test/advance_math_test.dart`](../test/advance_math_test.dart) - Main test file

## Related Documentation

- [Algebra](01_algebra.md) - Matrix, Vector, Expressions
- [Basic Math](02_basic_math.md) or [Core Math](math.md) - Core math functions
- [Geometry](03_geometry.md) - 2D/3D geometry
- [Statistics](04_statistics.md) - Statistical analysis
- [Numbers](05_numbers.md) - Complex, Decimal, Roman numerals
- [Quantity](06_quantity.md) - Physical quantities and units
- [Utilities](07_utilities.md) - FFT, Interpolation, Extensions
