# Algebra Module

The algebra module provides comprehensive linear algebra operations including matrices, vectors, expressions, calculus, and equation solvers.

---

## Table of Contents

1. [Matrix](#matrix)
2. [Vector](#vector)
3. [Expressions](#expressions)
4. [Polynomials](#polynomials)
5. [Decompositions](#decompositions)
6. [Linear System Solvers](#linear-system-solvers)

---

## Matrix

The `Matrix` class provides a full-featured matrix implementation with extensive operations.

### Creating Matrices

```dart
import 'package:advance_math/advance_math.dart';

// From nested lists
var m1 = Matrix([
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9]
]);

// From string notation
var m2 = Matrix("1 2 3; 4 5 6; 7 8 9");

// Special matrices
var identity = Matrix.eye(3);           // 3x3 identity matrix
var zeros = Matrix.zeros(3, 3);         // 3x3 zero matrix
var ones = Matrix.ones(3, 3);           // 3x3 ones matrix
var diagonal = Matrix.diagonal([1, 2, 3]); // Diagonal matrix
var random = Matrix.random(3, 3);       // Random values

// Column and Row matrices
var col = ColumnMatrix([1, 2, 3]);      // 3x1 column vector
var row = RowMatrix([1, 2, 3]);         // 1x3 row vector
```

### Matrix Properties

| Property      | Description                                 |
| ------------- | ------------------------------------------- |
| `rowCount`    | Number of rows                              |
| `columnCount` | Number of columns                           |
| `shape`       | `[rows, columns]` as list                   |
| `isSquare`    | True if rows == columns                     |
| `isSymmetric` | True if M == M^T                            |
| `isDiagonal`  | True if only diagonal elements are non-zero |
| `isIdentity`  | True if identity matrix                     |
| `isSingular`  | True if determinant is 0                    |

```dart
var mat = Matrix([
  [4, 2, 1],
  [16, 4, 1],
  [64, 8, 1]
]);

print('Determinant: ${mat.determinant()}');     // -24.0
print('Trace: ${mat.trace()}');                 // 9.0
print('Rank: ${mat.rank()}');                   // 3
print('Condition number: ${mat.conditionNumber()}');

// Check properties
mat.matrixProperties().forEach((prop) => print(' - $prop'));
// Output:
//  - Square Matrix
//  - Non-Singular Matrix
//  - Full Rank
//  - etc.
```

### Matrix Operations

```dart
var A = Matrix([[1, 2], [3, 4]]);
var B = Matrix([[5, 6], [7, 8]]);

// Arithmetic
var sum = A + B;           // Element-wise addition
var diff = A - B;          // Element-wise subtraction
var prod = A * B;          // Matrix multiplication
var scaled = A * 2;        // Scalar multiplication

// Transpose and inverse
var transpose = A.transpose();
var inverse = A.inverse();
var pseudoInv = A.pseudoInverse();  // For non-square matrices

// Element-wise operations
var elemMult = A.elementMultiply(B);
var elemDiv = A.elementDivide(B);

// Norms
var l1 = A.norm(Norm.manhattan);    // L1 (Manhattan) norm
var l2 = A.norm();                  // L2 (Euclidean) norm
var inf = A.norm(Norm.chebyshev);   // Infinity norm
var fro = A.norm(Norm.frobenius);   // Frobenius norm
```

### Matrix Manipulation

```dart
var m = Matrix([
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9]
]);

// Row/Column access
var row = m.row(0);            // First row as list
var col = m.column(1);         // Second column as list

// Slicing
var subMatrix = m.slice(0, 2, 0, 2);  // Top-left 2x2

// Row echelon forms
var ref = m.rowEchelonForm();
var rref = m.reducedRowEchelonForm();

// Concatenation
var horizontal = A.concatenate(B, axis: 0);  // Side by side
var vertical = A.concatenate(B, axis: 1);    // Stacked

// Remove rows/columns
var noFirstRow = m.removeRow(0);
var noLastCol = m.removeColumn(2);
```

### Statistical Methods

```dart
var data = Matrix([
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9]
]);

print(data.sum());        // Sum of all elements
print(data.mean());       // Mean of all elements
print(data.min());        // Minimum value
print(data.max());        // Maximum value
print(data.variance());   // Variance
print(data.std());        // Standard deviation
```

---

## Vector

The `Vector` class represents mathematical vectors with rich operations.

### Creating Vectors

```dart
// From list
var v1 = Vector([1, 2, 3, 4]);

// From range
var v2 = Vector.range(0, 10, step: 2);  // [0, 2, 4, 6, 8]

// Special vectors
var zeros = Vector.zeros(5);
var ones = Vector.ones(5);
var random = Vector.random(5);
```

### Vector Operations

```dart
var a = Vector([1, 2, 3]);
var b = Vector([4, 5, 6]);

// Arithmetic
var sum = a + b;           // [5, 7, 9]
var diff = a - b;          // [-3, -3, -3]
var scaled = a * 2;        // [2, 4, 6]

// Products
var dot = a.dot(b);        // Dot product: 32
var cross = a.cross(b);    // Cross product (3D only)

// Magnitude and normalization
var magnitude = a.magnitude();    // sqrt(14)
var normalized = a.normalize();   // Unit vector

// Angle between vectors
var angle = a.angleTo(b);         // Returns Angle object
```

---

## Expressions

The expression system supports symbolic mathematics with variables, differentiation, integration, and evaluation.

### Creating Expressions

```dart
// Define variables
Variable x = Variable('x'), y = Variable('y');

// Method 1: Explicit Literal objects
var expr1 = Add(Pow(x, Literal(2)), Literal(1));

// Method 2: Using toExpression() extension
var expr2 = (x ^ 2.toExpression()) + 1.toExpression();

// Method 3: Using ex() helper function
var expr3 = (x ^ ex(2)) + ex(1);

// Parse from string
var parsed = Expression.parse('x^2 + 2*x + 1');
```

### Evaluating Expressions

```dart
var context = {'x': 3.0, 'y': 4.0};

var expr = Expression.parse('6*x + 4');
print(expr.evaluate(context));  // 22.0

// With functions
var sinExpr = Expression.parse('sin(x) + cos(y)');
print(sinExpr.evaluate(context));
```

### Calculus Operations

```dart
Variable x = Variable('x');

// Differentiation
var f = (x ^ ex(3)) + 2.toExpression() * (x ^ ex(2)) - ex(5) * x + ex(7);
print('f(x) = $f');
print("f'(x) = ${f.differentiate()}");

// Integration
var g = 6.toExpression() * x + ex(4);
print('g(x) = $g');
print('∫g(x)dx = ${g.integrate()}');

// Trigonometric calculus
print('∫sin(x)dx = ${Sin(x).integrate()}');  // -cos(x) + C
print('∫cos(x)dx = ${Cos(x).integrate()}');  // sin(x) + C
print('d/dx[ln(x)] = ${Ln(x).differentiate()}');  // 1/x
```

### Simplification

```dart
var complex = Add(
  Multiply(Literal(2), x),
  Add(Add(Literal(5), x), Multiply(Literal(2), x))
);
print(complex.simplify());  // 5x + 5
```

### Available Functions

| Category          | Functions                                |
| ----------------- | ---------------------------------------- |
| **Trigonometric** | `Sin`, `Cos`, `Tan`, `Cot`, `Sec`, `Csc` |
| **Inverse Trig**  | `Asin`, `Acos`, `Atan`                   |
| **Hyperbolic**    | `Sinh`, `Cosh`, `Tanh`                   |
| **Logarithmic**   | `Ln`, `Log`, `Log10`                     |
| **Exponential**   | `Exp`                                    |
| **Power**         | `Pow`, `Sqrt`                            |

---

## Polynomials

### Single Variable Polynomials

```dart
// From string
var p = Polynomial.fromString('x^2 + 2x + 1');

// Operations
print(p.roots());           // [-1.0, -1.0]
print(p.factorize());       // Factorized form
print(p.factorizeString()); // "(x + 1)^2"

// Arithmetic
Polynomial P = Polynomial.fromString("x^4 + 6x^2 + 4");
Polynomial Q = Polynomial.fromString('x^2 - 9');
print(P / Q);               // Division result

// Rational functions
var rational = RationalFunction(P, Q);
print("Quotient: ${rational.quotient}");
print("Remainder: ${rational.remainder}");
```

### Multi-Variable Polynomials

```dart
var polynomial = MultiVariablePolynomial([
  Term(3, {'x': 2, 'y': 1}),  // 3x²y
  Term(2, {'x': 1}),          // 2x
  Term(1, {'y': 2}),          // y²
  Term(4, {})                 // 4
]);

var result = polynomial.evaluate({'x': 2, 'y': 3});
print(result);  // 3*(4)*(3) + 2*2 + 9 + 4 = 49

// Parse from string
var parsed = MultiVariablePolynomial.fromString("7x^2y^3 + 2x + 5");
```

---

## Decompositions

The library supports multiple matrix decomposition methods.

### LU Decomposition

```dart
var mat = Matrix([
  [4.0, 2.0, 1.0],
  [16.0, 4.0, 1.0],
  [64.0, 8.0, 1.0]
]);

// Various LU algorithms
var lud = mat.decomposition.luDecompositionDoolittle();
print("L: ${lud.L}");
print("U: ${lud.U}");
print("Verify: ${lud.checkMatrix}");

// With pivoting
var ludPP = mat.decomposition.luDecompositionDoolittlePartialPivoting();
print("P: ${ludPP.P}");  // Permutation matrix

var ludCP = mat.decomposition.luDecompositionDoolittleCompletePivoting();
print("Q: ${ludCP.Q}");  // Column permutation

// Other variants
var crout = mat.decomposition.luDecompositionCrout();
var gauss = mat.decomposition.luDecompositionGauss();
```

### QR Decomposition

```dart
var A = Matrix([
  [4, 1, -1],
  [1, 4, -1],
  [-1, -1, 4]
]);

// Gram-Schmidt
var qr1 = A.decomposition.qrDecompositionGramSchmidt();
print("Q: ${qr1.Q}");
print("R: ${qr1.R}");
print("Q orthogonal: ${qr1.Q.isOrthogonalMatrix()}");
print("R upper triangular: ${qr1.R.isUpperTriangular()}");

// Householder
var qr2 = A.decomposition.qrDecompositionHouseholder();
```

### Other Decompositions

```dart
// LQ Decomposition
var lq = A.decomposition.lqDecomposition();
print("L: ${lq.L}");
print("Q: ${lq.Q}");

// Cholesky Decomposition (for positive definite matrices)
var chol = A.decomposition.choleskyDecomposition();
print("L: ${chol.L}");

// Eigenvalue Decomposition
var eigen = A.decomposition.eigenvalueDecomposition();
print("D (eigenvalues): ${eigen.D}");
print("V (eigenvectors): ${eigen.V}");

// Singular Value Decomposition (SVD)
var svd = A.decomposition.singularValueDecomposition();
print("U: ${svd.U}");
print("S: ${svd.S}");
print("V: ${svd.V}");
print("Verify: ${A.isAlmostEqual(svd.checkMatrix.round())}");

// Schur Decomposition
var schur = A.decomposition.schurDecomposition();
print("T: ${schur.T}");
print("Q: ${schur.Q}");
```

---

## Linear System Solvers

Solve systems of the form `Ax = b`.

```dart
var A = Matrix([
  [4, 1, -1],
  [1, 4, -1],
  [-1, -1, 4]
]);
var b = Matrix.fromList([[6], [25], [14]]);

// Using decomposition (recommended)
var x = A.decomposition.solve(b);
print("Solution: $x");

// Using specific decomposition
var qr = A.decomposition.qrDecompositionGramSchmidt();
print("QR solution: ${qr.solve(b)}");

var lu = A.decomposition.luDecompositionDoolittle();
print("LU solution: ${lu.solve(b)}");

var svd = A.decomposition.singularValueDecomposition();
print("SVD solution: ${svd.solve(b)}");
```

### Available Solvers

| Method              | Best For                          |
| ------------------- | --------------------------------- |
| LU Decomposition    | General square systems            |
| QR Decomposition    | Overdetermined systems            |
| Cholesky            | Symmetric positive definite       |
| SVD                 | Ill-conditioned or rank-deficient |
| Jacobi/Gauss-Seidel | Large sparse systems              |

---

## Expression Parser

The expression parser evaluates string expressions with variables and functions.

```dart
var parser = ExpressionParser();
var context = {
  'x': 3.0,
  'y': 4.0,
  'pi': pi,
  'e': e,
};

// Mathematical expressions
print(parser.parse('sqrt(x) + sin(pi/2)').evaluate(context));
print(parser.parse('log10(10) + ln(e)').evaluate(context));
print(parser.parse('pow(2, 3)').evaluate(context));

// Conditional expressions
print(parser.parse('x > 2 ? "bigger" : "smaller"').evaluate(context));

// String operations
print(parser.parse('length("test string")').evaluate(context));
print(parser.parse('toUpper("hello")').evaluate(context));

// Statistical functions
print(parser.parse('mean([1, 2, 3, 4, 5])').evaluate(context));
print(parser.parse('nCr(5, 3)').evaluate(context));  // 10
print(parser.parse('nPr(5, 3)').evaluate(context));  // 60
```

### Built-in Functions

| Category          | Functions                                                 |
| ----------------- | --------------------------------------------------------- |
| **Math**          | `abs`, `sqrt`, `cbrt`, `pow`, `exp`, `log`, `log10`, `ln` |
| **Trig**          | `sin`, `cos`, `tan`, `asin`, `acos`, `atan`, `atan2`      |
| **Hyperbolic**    | `sinh`, `cosh`, `tanh`, `asinh`, `acosh`, `atanh`         |
| **Rounding**      | `round`, `floor`, `ceil`, `roundTo`                       |
| **Stats**         | `min`, `max`, `sum`, `avg`, `mean`                        |
| **Combinatorics** | `factorial`, `nPr`, `nCr`                                 |
| **String**        | `length`, `toUpper`, `toLower`, `concat`, `left`, `right` |
| **Date**          | `now`, `daysDiff`, `hoursDiff`                            |

---

## Related Tests

- [`test/matrix_decomposition_test.dart`](../test/matrix_decomposition_test.dart)
- [`test/matrix_linear_equation_test.dart`](../test/matrix_linear_equation_test.dart)
- [`test/expression/`](../test/expression/) - Expression parsing and evaluation tests
- [`test/calculus/`](../test/calculus/) - Calculus operations tests
- [`test/bases.dart`](../test/bases.dart) - Number base conversion tests

## Related Documentation

- [Algebra Index](algebra/00_index.md) - Detailed algebra submodule documentation
- [Bases](algebra/01_bases.md) - Number base conversions
- [Calculus](algebra/02_calculus.md) - Differentiation and integration
- [Expression](algebra/03_expression.md) - Symbolic expressions
- [Matrix](algebra/04_matrix.md) - Matrix operations
- [Vector](algebra/05_vector.md) - Vector operations
- [Linear](algebra/06_linear.md) - Linear system solvers
- [Nonlinear](algebra/07_nonlinear.md) - Root finding and optimization
- [Least Squares](algebra/08_least_squares.md) - Least squares fitting
