# Algebra Module

Comprehensive algebra functionality including matrices, vectors, expressions, calculus, and equation solving.

---

## Module Index

| Document                             | Description                                          |
| ------------------------------------ | ---------------------------------------------------- |
| [Bases](01_bases.md)                 | Number base conversion utilities (binary, hex, etc.) |
| [Calculus](02_calculus.md)           | Differentiation, integration, Taylor series, limits  |
| [Expression](03_expression.md)       | Symbolic expressions, parsing, evaluation            |
| [Matrix](04_matrix.md)               | Matrix operations, decompositions, properties        |
| [Vector](05_vector.md)               | Vector operations, products, geometry                |
| [Linear](06_linear.md)               | Linear system solvers (Ax = b)                       |
| [Nonlinear](07_nonlinear.md)         | Root finding and optimization                        |
| [Least Squares](08_least_squares.md) | Least squares fitting and statistics                 |

---

## Quick Reference

### Matrix Operations

```dart
import 'package:advance_math/advance_math.dart';

var A = Matrix([[1, 2], [3, 4]]);
var B = Matrix([[5, 6], [7, 8]]);

// Arithmetic
var sum = A + B;
var prod = A * B;
var inv = A.inverse();
var det = A.determinant();

// Decompositions
var lu = A.decomposition.luDecompositionDoolittle();
var qr = A.decomposition.qrDecompositionGramSchmidt();
var svd = A.decomposition.singularValueDecomposition();
```

### Vector Operations

```dart
var a = Vector([1, 2, 3]);
var b = Vector([4, 5, 6]);

var dot = a.dot(b);      // Dot product
var cross = a.cross(b);  // Cross product
var norm = a.normalize(); // Unit vector
```

### Symbolic Expressions

```dart
var x = Variable('x');
var expr = (x ^ ex(2)) + ex(3) * x + ex(1);

// Evaluate
var result = expr.evaluate({'x': 2});  // 11

// Differentiate
var deriv = expr.differentiate();  // 2x + 3

// Parse from string
var parsed = Expression.parse('sin(x) + cos(x)');
```

### Solving Linear Systems

```dart
Matrix A = Matrix([[1, 2], [3, 4]]);
Matrix b = Matrix([[5], [11]]);

// Using decomposition
var x = A.decomposition.solve(b);

// Using direct methods
var x2 = LinearSystemSolvers.gaussElimination(A, b);
```

### Root Finding

```dart
double f(double x) => x * x - 4;

var root = RootFinding.brent(f, 0, 3);
print(root);  // 2.0
```

### Optimization

```dart
double f(List<num> x) => x[0] * x[0] + x[1] * x[1];
List<num> grad(List<num> x) => [2 * x[0], 2 * x[1]];

var result = Optimization.gradientDescent(f, grad, [5.0, 3.0]);
print(result.solution);  // [0, 0]
```

### Calculus

```dart
var x = Variable('x');
var f = Sin(x) * x;

// Differentiate
var df = f.differentiate();

// Integrate
var integral = f.integrate();
```

### Base Conversion

```dart
// Binary to hexadecimal
String hex = Bases.convert("1011", 2, 16);  // "B"

// Decimal to binary
String bin = Bases.decimalToBinary("255");  // "11111111"
```

---

## Class Overview

| Class                     | Description                     |
| ------------------------- | ------------------------------- |
| `Matrix`                  | Dense matrix operations         |
| `Vector`                  | Mathematical vectors            |
| `ColumnMatrix`            | n×1 column matrix               |
| `RowMatrix`               | 1×n row matrix                  |
| `DiagonalMatrix`          | Diagonal matrix                 |
| `SparseMatrix`            | Memory-efficient sparse storage |
| `Expression`              | Symbolic expression base        |
| `Variable`                | Symbolic variable               |
| `Literal`                 | Constant value                  |
| `Polynomial`              | Single-variable polynomial      |
| `MultiVariablePolynomial` | Multi-variable polynomial       |
| `RationalFunction`        | Ratio of polynomials            |
| `LinearSystemSolvers`     | System solving methods          |
| `RootFinding`             | Root finding algorithms         |
| `Optimization`            | Optimization algorithms         |
| `BaseLeastSquares`        | Least squares fitting           |
| `Limit`                   | Limit computation               |
| `Bases`                   | Base conversion utilities       |

---

## Decomposition Summary

| Decomposition | Method                    | Use Case                     |
| ------------- | ------------------------- | ---------------------------- |
| LU            | Doolittle, Crout, Gauss   | General square systems       |
| QR            | Gram-Schmidt, Householder | Least squares                |
| LQ            | —                         | Underdetermined systems      |
| Cholesky      | —                         | Symmetric positive-definite  |
| Eigenvalue    | —                         | Modal analysis               |
| SVD           | —                         | Rank-deficient, conditioning |
| Schur         | —                         | Matrix functions             |

---

## Related Tests

- [`test/expression/`](../../test/expression/) - Expression tests
- [`test/calculus/`](../../test/calculus/) - Calculus tests
- [`test/nonlinear/`](../../test/nonlinear/) - Root finding and optimization tests
- [`test/matrix_decomposition_test.dart`](../../test/matrix_decomposition_test.dart)
- [`test/matrix_linear_equation_test.dart`](../../test/matrix_linear_equation_test.dart)

## Related Documentation

- [Main Algebra](../01_algebra.md) - Overview of algebra module
- [Basic Math](../02_basic_math.md) - Core math functions
- [Numbers](../05_numbers.md) - Decimal and Rational types
