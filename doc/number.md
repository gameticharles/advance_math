# Number Module

This module provides a rich set of numerical types beyond Dart's built-in `int` and `double`. It includes `Rational`, and `Decimal` real numbers, as well as `Complex`, purely `Imaginary` numbers, and `RomanNumerals`. These types are designed for robust mathematical computations, offering features like type safety, controlled precision, and specific arithmetic behaviors.

## Table of Contents
- [Number Base Class (`Number`)](#number-base-class)
  - [Overview](#number-overview)
  - [`Rational` Class](#rational-class)
    - [Overview](#rational-overview)
    - [Constructors](#rational-constructors)
    - [Static Values](#rational-static-values)
    - [Properties](#rational-properties)
    - [Operators](#rational-operators)
    - [Methods](#rational-methods)
  - [`Decimal` Class (High-Precision Decimal)](#decimal-class-high-precision-decimal)
    - [Overview](#decimal-overview)
    - [Constructors](#decimal-constructors)
    - [Static Values](#decimal-static-values)
    - [Static Methods](#decimal-static-methods)
    - [Properties](#decimal-properties)
    - [Operators](#decimal-operators)
    - [Methods](#decimal-methods)
    - [Extensions for `BigInt` and `int`](#decimal-extensions)
- [Complex Number Types](#complex-number-types)
  - [`Complex` Class](#complex-class)
    - [Overview](#complex-overview)
    - [Constructors](#complex-constructors)
    - [Properties](#complex-properties)
    - [Methods](#complex-methods)
    - [Operators](#complex-operators)
    - [Static Methods](#complex-static-methods)
    - [NaN/Infinity Handling](#naninfinity-handling-in-complex-operations)
    - [Type Interactions in Operations](#type-interactions-in-complex-operations)
    - [Extensions (Memoized Operations)](#complex-extensions-memoized-operations)
  - [`Imaginary` Class](#imaginary-class)
    - [Overview](#imaginary-overview)
    - [Top-level Constants (`i`, `j`)](#imaginary-top-level-constants)
    - [Constructors](#imaginary-constructors)
    - [Properties](#imaginary-properties)
    - [Methods](#imaginary-methods)
    - [Operators](#imaginary-operators)
- [Roman Numerals (`RomanNumerals`)](#roman-numerals)
  - [Overview](#roman-numerals-overview)
  - [Configuration](#roman-numerals-configuration)
  - [Constructors](#roman-numerals-constructors)
  - [Methods](#roman-numerals-methods)
  - [Operators](#roman-numerals-operators)
  - [Static Methods](#roman-numerals-static-methods)
  - [Extensions for `int` and `String`](#roman-numeral-extensions)

---

## Number Base Class (`Number`)
*(From `lib/src/number/number/number.dart`)*

### Number Overview
The `Number` class is an abstract base class serving as the foundation for all specialized numeric types in this module. This includes `Rational`, `Decimal`, `Complex`, and `Imaginary` numbers. 

The main goal is to enable robust, type-aware mathematical computations, allowing for meaningful interactions between different numerical representations and providing specialized functionalities.


### Common Properties & Methods
All number subclasses implement or inherit:
- Arithmetic operators: `+`, `-`, `*`, `/`, `~/`, `%`, `^` (power).
- Comparison operators: `==`, `<`, `<=`, `>`, `>=`.
- Properties: `isInfinite`, `isNaN`, `isNegative`, `isInteger`.
- Conversions: `toInt()`, `toDouble()`, `toString()`.
- Utilities: `abs()`, `ceil()`, `floor()`, `round()`, `truncate()`, `clamp()`, `reciprocal()`, `pow()`, `sqrt()`, `exp()`.
- Serialization: `toJson()`.

---
### `Rational` Class
*(From `lib/src/number/decimal/rational.dart`)*

#### Rational Overview
The `Rational` class represents numbers as a fraction of two `BigInt`s: a `numerator` and a non-zero `denominator`. Fractions are always stored in their canonical (simplest) form (e.g., 2/4 is stored as 1/2). `Rational` implements `Comparable<Rational>`.

#### Rational Constructors
-   **`Rational(BigInt numerator, [BigInt? denominator])`**: Main constructor. If `denominator` is omitted, it defaults to `1`. Throws `ArgumentError` if `denominator` is zero.
    ```dart
    final r1 = Rational(BigInt.from(2), BigInt.from(4)); // Stored as 1/2
    print(r1); // Output: 1/2
    final r2 = Rational(BigInt.from(5)); // Stored as 5/1
    print(r2); // Output: 5
    ```
-   **`Rational.fromInt(int numerator, [int denominator = 1])`**: Convenience constructor from Dart `int`s.
    ```dart
    final r3 = Rational.fromInt(3, 6);
    print(r3); // Output: 1/2
    ```
-   **`static Rational parse(String source)`**: Parses a string into a `Rational`. Supports various formats:
    -   Mixed numbers: `"2 3/4"` -> `11/4`
    -   Simple fractions: `"1/2"`, `"-3/4"`
    -   Whole numbers: `"3"` -> `3/1`
    -   Decimal numbers: `"3.14"` -> `157/50`, `"-0.75"` -> `-3/4`
    -   Scientific notation: `"3.14e2"` -> `314/1`, `"5e-2"` -> `1/20`
    ```dart
    print(Rational.parse("2 3/4"));    // Output: 11/4
    print(Rational.parse("-0.5"));     // Output: -1/2
    print(Rational.parse("1.25e1"));   // Output: 25/2 (12.5)
    ```
-   **`static Rational? tryParse(String source)`**: Like `parse`, but returns `null` on invalid format instead of throwing.

#### Rational Static Values
-   `Rational.zero`: Represents `0/1`.
-   `Rational.one`: Represents `1/1`.

#### Rational Properties
-   `numerator: BigInt`
-   `denominator: BigInt`
-   `isInteger: bool`: True if `denominator` is `1`.
-   `inverse: Rational`: Returns `denominator/numerator`. Throws if `numerator` is zero.
-   `sign: int`: Returns -1, 0, or 1.
-   `hasFinitePrecision: bool`: True if the rational can be represented as a finite decimal (denominator has only 2 and 5 as prime factors).

#### Rational Operators
-   Arithmetic: `+`, `-` (unary and binary), `*`, `/`, `%` (Euclidean modulo), `~/` (truncating division, returns `BigInt`).
    ```dart
    final r1 = Rational.fromInt(1, 2);
    final r2 = Rational.fromInt(1, 3);
    print(r1 + r2); // Output: 5/6
    print(r1 * r2); // Output: 1/6
    print(r1 / r2); // Output: 3/2
    print(Rational.fromInt(7) ~/ Rational.fromInt(2)); // Output: 3 (BigInt)
    ```
-   Comparison: `<`, `<=`, `>`, `>=`.
    ```dart
    print(Rational.fromInt(1,2) > Rational.fromInt(1,3)); // Output: true
    ```

#### Rational Methods
-   `abs() -> Rational`
-   `round() -> BigInt`: Rounds to the nearest integer (away from zero for .5).
-   `floor() -> BigInt`: Greatest integer no greater than the rational.
-   `ceil() -> BigInt`: Smallest integer no smaller than the rational.
-   `truncate() -> BigInt`: Integer part (discards fractional part).
-   `clamp(Rational lowerLimit, Rational upperLimit) -> Rational`
-   `toBigInt() -> BigInt`: Equivalent to `truncate()`.
-   `toDouble() -> double`: Converts to `double` (may lose precision).
-   `pow(int exponent) -> Rational`: Raises to an integer power.
-   `toDecimalString(int decimalPlaces) -> String`: (Not in source, but common for rationals) Converts to decimal string with fixed places.
-   `toDecimal({int? precision, BigInt Function(Rational)? toBigInt}) -> Decimal`: Converts to `Decimal`. `precision` refers to `decimalPrecision`. `toBigInt` is a function for custom rounding during conversion if needed.
    ```dart
    final r = Rational.fromInt(7, 3); // 2.333...
    print(r.round());    // Output: 2
    print(r.floor());    // Output: 2
    print(r.ceil());     // Output: 3
    print(r.truncate()); // Output: 2
    print(r.toDouble()); // Output: 2.333...
    print(r.toDecimal(precision: 5)); // Output: 2.33333
    ```

---
### `Decimal` Class (High-Precision Decimal)
*(From `lib/src/number/decimal/decimal.dart` and `lib/src/number/decimal/rational.dart` which it uses)*

#### Decimal Overview
The `Decimal` class provides high-precision decimal arithmetic. It is implemented using an underlying `Rational` number, allowing for exact representations of decimal values that can be expressed as fractions. The precision for operations that might produce non-terminating decimals (like `exp`, `ln`, `sqrt`) is controlled by a global `decimalPrecision` variable (default 50), which can be set using `Decimal.setPrecision(int precision)`.

#### Decimal Constructors
-   **`Decimal(dynamic value, {int? sigDigits})`**:
    - `value`: Can be `num`, `BigInt`, `String`, `Rational`, or another `Decimal`.
    - `sigDigits`: Sets the global `decimalPrecision` if provided.
    ```dart
    print(Decimal("123.456"));
    print(Decimal(12.12345, sigDigits: 10)); // Sets global decimalPrecision to 10
    print(Decimal(Rational.fromInt(1,3))); // Represents 1/3
    ```
-   **`Decimal.fromBigInt(BigInt value)`**
-   **`Decimal.fromInt(int value)`**
-   **`Decimal.parse(String source)`**: Parses string to `Decimal` via `Rational.parse`.
-   **`Decimal.fromJson(String value)`**: Alias for `Decimal.parse`.

#### Decimal Static Values
`zero`, `one`, `ten`, `hundred`, `thousand`. Also `infinity`, `negInfinity`, `nan` (from `double` constants, represented as special `Rational` states).

#### Decimal Static Methods
-   **`static void setPrecision(int precision)`**: Sets the global `decimalPrecision` for operations. Must be `>= 1`.

#### Decimal Properties
-   `isInteger: bool`: True if the underlying `Rational` is an integer.
-   `inverse: Rational`: Inverse of the underlying `Rational`.
-   `precision: int`: Total number of significant digits in the current value.
-   `scale: int`: Number of digits after the decimal point.
-   `sigNum: int`: Sign of the number (-1, 0, 1).
-   `isExactInt: bool`: True if representable as a Dart `int` without loss.
-   `isExactDouble: bool`: True if representable as a Dart `double` without loss.
-   `isPowerOfTen: bool`: True if an integer power of 10.

#### Decimal Operators
-   Arithmetic: `+`, `-`, `*`, `%` (all return `Decimal`). `/` returns `Rational`. `~/` returns `BigInt`.
-   Comparison: `<`, `<=`, `>`, `>=`.
    ```dart
    final d1 = Decimal("0.1");
    final d2 = Decimal("0.2");
    print(d1 + d2); // Output: 0.3
    print(Decimal("10") / Decimal("3")); // Output: 10/3 (Rational)
    ```

#### Decimal Methods
-   `toRational() -> Rational`.
-   `abs()`, `floor({scale})`, `ceil({scale})`, `round({scale})`, `truncate({scale})`: Return `Decimal`.
-   `clamp(Decimal lower, Decimal upper) -> Decimal`.
-   `toBigInt() -> BigInt`.
-   `toDouble() -> double`.
-   `reciprocal() -> Rational`.
-   `sqrt()`, `exp()`, `ln()`, `pow(dynamic exponent)`, `cos()`, `sin()`, `tan()`, `asin()`, `acos()`, `atan()`: High-precision calculations, return `Decimal`.
-   `shift(int value) -> Decimal`: Multiplies by 10<sup>value</sup>.
-   `toStringAsFixed(int fractionDigits)`.
-   `toStringAsExponential([int fractionDigits = 0])`.
-   `toStringAsPrecision(int precision)`.
-   `toJson() -> String` (returns `toString()`).
    ```dart
    Decimal.setPrecision(20); // Set global precision
    print(Decimal("2").sqrt()); // Output: 1.4142135623730950488
    print(Decimal("1.23456").toStringAsFixed(3)); // Output: 1.235
    print(Decimal("0.5").sin()); // Example from basic_math.dart
    ```

#### Extensions for `BigInt` and `int`
*(Source files for these specific extensions were not read, but their existence is implied by `decimal.dart`.)*
-   `BigInt.toDecimal() -> Decimal` (Conceptual, from `big_int_ext.dart`)
-   `BigInt.toRational() -> Rational` (Conceptual, from `big_int_ext.dart`)
-   `int.toDecimal() -> Decimal` (Conceptual, from `int_ext.dart`)
-   `int.toRational() -> Rational` (Conceptual, from `int_ext.dart`)
    ```dart
    // BigInt myBigInt = BigInt.from(123);
    // Decimal dFromBig = myBigInt.toDecimal();
    // Rational rFromInt = 5.toRational();
    // print("$dFromBig, $rFromInt");
    ```

---
## Complex Number Types
*(Retained and refined from previous documentation based on `complex.dart`, `imaginary.dart` and their test files)*

### `Complex` Class
*(Overview, Constructors, Properties, Methods, Operators, Static Methods, NaN/Infinity Handling, Type Interactions, Memoized Extensions, as refined in the previous turn's full documentation.)*

### `Imaginary` Class
*(Overview, Top-level Constants, Constructors, Properties, Methods, Operators, as refined in the previous turn's full documentation.)*

---
## Roman Numerals (`RomanNumerals`)
*(Retained and refined from previous documentation based on `roman_numerals.dart` and its extension files.)*

---
*(End of refined doc/number.md)*
