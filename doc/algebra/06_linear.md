# Linear Systems Module

Solving linear systems of equations Ax = b using various methods.

---

## Table of Contents

1. [Overview](#overview)
2. [Direct Methods](#direct-methods)
3. [Iterative Methods](#iterative-methods)
4. [Using Decompositions](#using-decompositions)

---

## Overview

Solve linear systems of the form **Ax = b** where:

- **A** is a matrix of coefficients
- **x** is the unknown vector
- **b** is the result vector

```dart
import 'package:advance_math/advance_math.dart';

Matrix A = Matrix([
  [4, 1, -1],
  [1, 4, -1],
  [-1, -1, 4]
]);

Matrix b = Matrix([
  [6],
  [25],
  [14]
]);

// Solve using decomposition (recommended)
var x = A.decomposition.solve(b);
print(x.round());
// Output:
// ┌ 1 ┐
// │ 7 │
// └ 6 ┘
```

---

## Direct Methods

### Cramer's Rule

Best for small systems (n ≤ 4):

```dart
Matrix result = LinearSystemSolvers.cramersRule(A, b);
print(result.round());
// ┌ 1 ┐
// │ 7 │
// └ 6 ┘
```

### Inverse Matrix Method

```dart
Matrix result = LinearSystemSolvers.inverseMatrix(A, b);
print(result.round());
```

### Gauss Elimination

```dart
Matrix result = LinearSystemSolvers.gaussElimination(A, b);
print(result.round());
```

### Gauss-Jordan Elimination

Produces the reduced row echelon form:

```dart
Matrix result = LinearSystemSolvers.gaussJordanElimination(A, b);
print(result.round());
```

### Montante's Method (Bareiss Algorithm)

Avoids floating-point errors for integer matrices:

```dart
Matrix result = LinearSystemSolvers.bareissAlgorithm(A, b);
print(result.round());
```

### Least Squares

Best for overdetermined systems (more equations than unknowns):

```dart
Matrix result = LinearSystemSolvers.leastSquares(A, b);
print(result.round());
```

### Gram-Schmidt

Uses orthogonalization:

```dart
Matrix result = LinearSystemSolvers.gramSchmidt(A, b);
print(result.round());
```

---

## Iterative Methods

For large systems, especially sparse matrices.

### Jacobi Method

```dart
Matrix result = LinearSystemSolvers.jacobi(
  A, b,
  maxIterations: 1000,
  tolerance: 1e-10
);
print(result.round());
```

### Gauss-Seidel Method

Generally faster convergence than Jacobi:

```dart
Matrix result = LinearSystemSolvers.gaussSeidel(
  A, b,
  maxIterations: 1000,
  tolerance: 1e-10
);
print(result.round());
```

### Successive Over-Relaxation (SOR)

Accelerated Gauss-Seidel:

```dart
Matrix result = LinearSystemSolvers.sor(
  A, b,
  omega: 1.5,  // Relaxation factor (1 < ω < 2)
  maxIterations: 1000,
  tolerance: 1e-10
);
```

### Conjugate Gradient

For symmetric positive-definite matrices:

```dart
Matrix result = LinearSystemSolvers.conjugateGradient(
  A, b,
  maxIterations: 1000,
  tolerance: 1e-10
);
```

---

## Using Decompositions

### Solve via Decomposition

```dart
// Using the default decomposition method
var x = A.decomposition.solve(b);

// Specify method
var x2 = A.decomposition.solve(b, method: DecompositionMethod.lu);
```

### LU Decomposition

```dart
var lu = A.decomposition.luDecompositionDoolittle();
var x = lu.solve(b);
print(x.round());
```

### QR Decomposition

```dart
var qr = A.decomposition.qrDecompositionGramSchmidt();
var x = qr.solve(b);
print(x.round());
```

### Cholesky Decomposition

For symmetric positive-definite matrices:

```dart
var chol = A.decomposition.choleskyDecomposition();
var x = chol.solve(b);
print(x.round());
```

### SVD

For ill-conditioned or rank-deficient systems:

```dart
var svd = A.decomposition.singularValueDecomposition();
var x = svd.solve(b);
print(x.round());
```

---

## Ridge Regression

For ill-conditioned matrices, add L2 regularization:

```dart
Matrix x = LinearSystemSolvers.ridgeRegression(A, b, 0.01);
print(x.round());
```

**Parameters:**

- `alpha`: Regularization strength (larger = more regularization)

---

## Method Comparison

| Method             | Best For                       | Complexity |
| ------------------ | ------------------------------ | ---------- |
| Cramer's Rule      | Small systems (n ≤ 4)          | O(n! · n)  |
| Gauss Elimination  | General square systems         | O(n³)      |
| Gauss-Jordan       | When inverse needed            | O(n³)      |
| LU Decomposition   | Multiple right-hand sides      | O(n³)      |
| QR Decomposition   | Overdetermined systems         | O(n³)      |
| Cholesky           | Symmetric positive-definite    | O(n³/3)    |
| Jacobi             | Large sparse systems           | O(n² · k)  |
| Gauss-Seidel       | Large sparse systems           | O(n² · k)  |
| Conjugate Gradient | SPD sparse systems             | O(n² · k)  |
| SVD                | Ill-conditioned/rank-deficient | O(n³)      |

_k = number of iterations for iterative methods_

---

## Example: Complete Workflow

```dart
import 'package:advance_math/advance_math.dart';

void main() {
  // Define the system
  Matrix A = Matrix([
    [4, 1, -1],
    [1, 4, -1],
    [-1, -1, 4]
  ]);

  Matrix b = Matrix.fromList([
    [6],
    [25],
    [14]
  ]);

  // Check matrix properties
  print('Determinant: ${A.determinant()}');
  print('Is singular: ${A.isSingularMatrix()}');
  print('Condition number: ${A.conditionNumber()}');

  // Solve using different methods
  var xCramer = LinearSystemSolvers.cramersRule(A, b);
  var xGauss = LinearSystemSolvers.gaussElimination(A, b);
  var xLU = A.decomposition.luDecompositionDoolittle().solve(b);
  var xQR = A.decomposition.qrDecompositionGramSchmidt().solve(b);

  print('Cramer: ${xCramer.round().flatten()}');
  print('Gauss: ${xGauss.round().flatten()}');
  print('LU: ${xLU.round().flatten()}');
  print('QR: ${xQR.round().flatten()}');

  // Verify solution
  print('A * x = ${(A * xLU).round().flatten()}');
  print('b = ${b.flatten()}');
}
```

---

## Error Handling

```dart
// Singular matrix (no unique solution)
Matrix singular = Matrix([
  [1, 2],
  [2, 4]  // Row 2 = 2 × Row 1
]);

try {
  var x = LinearSystemSolvers.inverseMatrix(singular, b);
} catch (e) {
  print('Matrix is singular: $e');
}

// Use pseudoinverse for singular/non-square matrices
var xPinv = singular.pseudoInverse() * b;
```

---

## Related Tests

- [`test/matrix_linear_equation_test.dart`](../../test/matrix_linear_equation_test.dart)
- [`test/linear_equation_test.dart`](../../test/linear_equation_test.dart)

## Related Documentation

- [Matrix](04_matrix.md) - Matrix decompositions
- [Nonlinear](07_nonlinear.md) - Nonlinear solvers
- [Expression](03_expression.md) - System of equations solving
