# Bases Module

Number base conversion utilities for working with different numeral systems (binary, octal, decimal, hexadecimal, and beyond).

---

## Overview

The `Bases` class provides utilities for converting numbers between various bases, ranging from base 2 (binary) to base 64.

---

## Bases Class

### Methods Overview

| Method            | Description                          |
| ----------------- | ------------------------------------ |
| `toDecimal`       | Convert from any base to decimal     |
| `fromDecimal`     | Convert from decimal to any base     |
| `convert`         | Convert between any two bases        |
| `rangeInBase`     | Generate number range in target base |
| `binaryToDecimal` | Binary → Decimal                     |
| `decimalToBinary` | Decimal → Binary                     |
| `hexToDecimal`    | Hexadecimal → Decimal                |
| `decimalToHex`    | Decimal → Hexadecimal                |
| `octalToDecimal`  | Octal → Decimal                      |
| `decimalToOctal`  | Decimal → Octal                      |
| `isValidForBase`  | Validate characters for base         |

---

## Basic Usage

```dart
import 'package:advance_math/advance_math.dart';

// Convert binary to decimal
String result = Bases.binaryToDecimal("1011");
print(result);  // "11"

// Convert decimal to binary
String binary = Bases.decimalToBinary("11");
print(binary);  // "1011"

// Convert hexadecimal to decimal
String dec = Bases.hexToDecimal("A");
print(dec);  // "10"

// Convert decimal to hexadecimal
String hex = Bases.decimalToHex("255");
print(hex);  // "FF"

// Convert octal to decimal
String octalDec = Bases.octalToDecimal("17");
print(octalDec);  // "15"

// Convert decimal to octal
String octal = Bases.decimalToOctal("15");
print(octal);  // "17"
```

---

## General Conversion

### `convert(value, sourceBase, targetBase)`

Convert between any two bases (2-64):

```dart
// Binary to hexadecimal
String result = Bases.convert("1011", 2, 16);
print(result);  // "B"

// Hexadecimal to binary
String bin = Bases.convert("FF", 16, 2);
print(bin);  // "11111111"

// Base 8 to base 5
String base5 = Bases.convert("17", 8, 5);
print(base5);  // "30"
```

### `toDecimal(value, sourceBase)`

Convert any base to decimal (integer):

```dart
int result = Bases.toDecimal("A", 16);
print(result);  // 10

int binary = Bases.toDecimal("1011", 2);
print(binary);  // 11

int octal = Bases.toDecimal("17", 8);
print(octal);  // 15
```

### `fromDecimal(value, targetBase, {padLength})`

Convert decimal integer to target base:

```dart
String hex = Bases.fromDecimal(255, 16);
print(hex);  // "FF"

String binary = Bases.fromDecimal(10, 2);
print(binary);  // "1010"

// With padding
String padded = Bases.fromDecimal(5, 2, padLength: 8);
print(padded);  // "00000101"
```

---

## Range Generation

### `rangeInBase(start, stop, targetBase)`

Generate a list of numbers in the specified base:

```dart
List<String> range = Bases.rangeInBase(4, 20, 5);
print(range);  // ["4", "10", "11", "12", "13", "14", "20", ...]

List<String> binary = Bases.rangeInBase(0, 16, 2);
print(binary);  // ["0", "1", "10", "11", "100", "101", ...]
```

---

## Validation

### `isValidForBase(value, base)`

Check if a string contains only valid characters for the specified base:

```dart
bool valid = Bases.isValidForBase("1A", 16);
print(valid);    // true

bool invalid = Bases.isValidForBase("1G", 16);
print(invalid);  // false

bool binary = Bases.isValidForBase("1010", 2);
print(binary);   // true

bool wrongBinary = Bases.isValidForBase("1012", 2);
print(wrongBinary);  // false (2 is not valid in base 2)
```

---

## Supported Characters

The `Bases` class supports bases 2 through 64 using the following character set:

| Range | Characters                   |
| ----- | ---------------------------- |
| 0-9   | `0123456789`                 |
| 10-35 | `ABCDEFGHIJKLMNOPQRSTUVWXYZ` |
| 36-61 | `abcdefghijklmnopqrstuvwxyz` |
| 62-63 | `+/`                         |

---

## Error Handling

```dart
// Invalid characters throw ArgumentError
try {
  Bases.toDecimal("1G", 16);  // 'G' is not valid in base 16
} catch (e) {
  print(e);  // ArgumentError: Invalid characters for base 16
}

// Invalid base range throws ArgumentError
try {
  Bases.convert("123", 67, 10);  // Base 67 is out of range
} catch (e) {
  print(e);  // ArgumentError: Base must be between 2 and 64
}
```

---

## String Extension

The bases module also provides extensions for working with numbers:

```dart
// Using extension methods
int value = 255;
String hex = value.toBase(16);  // "FF"

String binaryStr = "1011";
int decimal = binaryStr.fromBase(2);  // 11
```

---

## Related Tests

- [`test/bases.dart`](../../test/bases.dart) - Number base conversion tests

## Related Documentation

- [Algebra Index](00_index.md) - Module overview
- [Expression](03_expression.md) - Expressions and parsing
