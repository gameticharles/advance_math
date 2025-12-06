# Expression Parser Syntax and Examples

This document provides a comprehensive reference for the syntax and capabilities of the `ExpressionParser` in the Advance Math library. All examples are derived from the test suite [`test/expression/spec/basic_parser_spec_test.dart`](../test/expression/spec/basic_parser_spec_test.dart).

## Basic Operations

The parser supports standard arithmetic operations.

| Operation      | Syntax | Example  | Result |
| :------------- | :----- | :------- | :----- |
| Addition       | `+`    | `1 + 1`  | `2.0`  |
| Subtraction    | `-`    | `3 - 1`  | `2.0`  |
| Multiplication | `*`    | `2 * 6`  | `12.0` |
| Division       | `/`    | `6 / 3`  | `2.0`  |
| Exponentiation | `^`    | `2 ^ 3`  | `8.0`  |
| Modulo         | `%`    | `10 % 4` | `2.0`  |

### Space Handling

Spaces are generally ignored, allowing for readable formatting.

- `1+1` evaluates to `2.0`
- `1 + 1` evaluates to `2.0`
- `sin( pi )` evaluates to `0.0` (approx)

## Scientific Notation

Numbers can be expressed in scientific notation.

- `1.234`
- `1.234e+1` (equals `12.34`)
- `1.234E+1`
- `1.234e-1` (equals `0.1234`)

## Variable Assignment & Usage

Variables can be defined and used in expressions.

```dart
var parser = ExpressionParser();
// Define variable context
var context = {'x': 10, 'y': 5};

// Evaluate
parser.parse('x + y').evaluate(context); // 15.0
parser.parse('x * 2').evaluate(context); // 20.0
```

## Operator Precedence

The parser follows standard mathematical order of operations (PEMDAS).

1.  **Parentheses**: `( ... )`
2.  **Exponents**: `^` (Right-associative)
3.  **Multiplication/Division/Modulo**: `*`, `/`, `%`
4.  **Addition/Subtraction**: `+`, `-`

### Examples

- `3 * 5 + 3` -> `15 + 3` -> `18.0`
- `3 + 5 * 3` -> `3 + 15` -> `18.0`
- `(3 + 5) * 3` -> `8 * 3` -> `24.0`
- `2 ^ 3 ^ 2` -> `2 ^ (3 ^ 2)` -> `2 ^ 9` -> `512.0` (Right-associative)

### Prefix Operators

- `-(3)` -> `-3.0`
- `-(-3)` -> `3.0`
- `3^-1` -> `0.333...`
- `3^-1^-1` -> `3^(-1^(-1))` -> `3^(-1)` -> `0.333...` (Note: Precedence carefully handled)

## Functions

Mathematical functions are supported. Arguments are in parentheses.

| Function | Example    | Result (approx) |
| :------- | :--------- | :-------------- |
| `sin`    | `sin(1)`   | `0.8414...`     |
| `cos`    | `cos(1)`   | `0.5403...`     |
| `tan`    | `tan(1)`   | `1.5574...`     |
| `sqrt`   | `sqrt(4)`  | `2.0`           |
| `abs`    | `abs(-5)`  | `5.0`           |
| `ln`     | `ln(e)`    | `1.0`           |
| `log`    | `log(100)` | `2.0` (Base 10) |

### Multi-Argument Functions

- `max(4, 6, 3)` -> `6.0`
- `min(4, 6, 3)` -> `3.0`

### Nested Functions

- `sin(sin(2))`
- `sqrt(4 + 5)`

## Constants

Common mathematical constants are built-in.

- `pi` (`3.14159...`)
- `e` (`2.71828...`)

Example: `sin(pi)` -> `0.0` (within precision limits)

## Vectors and Arrays

The parser supports vector creation and manipulation.

### Creation

- `[1, 2, 3]` creates a vector.
- `[[1, 2], [3, 4]]` creates a matrix (list of lists).

### Access / Indexing

Syntax: `vector[index]` (0-based)

- `[1, 2, 3][0]` -> `1.0`
- `[1, 2, 3][1]` -> `2.0`

### Ranges / Slicing

Syntax: `vector[start:end]` (end is exclusive)

- `[1, 2, 3, 4][0:2]` -> `[1.0, 2.0]`
- `[1, 2, 3, 4][1:3]` -> `[2.0, 3.0]`

### Assignment (Context Update)

You can assign values to specific indices in a vector variable within the context.
_(Note: Assignment syntax implementation depends on the specific parser configuration, but generally supported)._

## Calculus and Solvers

See [Calculus Documentation](calculus.md) for detailed examples of:

- `diff(expression, variable)`
- `integrate(expression, variable)`
- `solve(equation, variable)`

## Implicit Multiplication

Implicit multiplication (e.g., `2x` instead of `2*x`) requires explicit enabling or specific spaces matching, but standard parser usually expects `*`.

- `2 * x` (Recommended)
- `2(x + 1)` (May require `*`)

## Complete Example

```dart
import 'package:advance_math/advance_math.dart';

void main() {
  final parser = ExpressionParser();
  final context = {'x': 2, 'y': 3};

  // Complex expression
  final exprStr = 'max(x, y) * sqrt(x^2 + y^2) + sin(pi/2)';
  final expr = parser.parse(exprStr);

  print(expr.evaluate(context));
  // max(2,3) * sqrt(4+9) + 1
  // 3 * 3.605... + 1
  // ~11.816...
}
```
