# Matrix Module

Comprehensive matrix operations including creation, manipulation, decomposition, and linear system solving.

---

## Table of Contents

1. [Creating Matrices](#creating-matrices)
2. [Properties](#properties)
3. [Basic Operations](#basic-operations)
4. [Matrix Manipulation](#matrix-manipulation)
5. [Statistical Methods](#statistical-methods)
6. [Decompositions](#decompositions)
7. [Solving Linear Systems of Equations](#solving-linear-systems-of-equations)
8. [Special Matrices](#special-matrices)
9. [Iteration](#iteration)
10. [Boolean Operations](#boolean-operations)
11. [Sorting Matrix](#sorting-matrix)
12. [Other Functions of matrices](#other-functions-of-matrices)
13. [I/O](#io)

---

## Creating Matrices

### From Nested Lists

```dart
import 'package:advance_math/advance_math.dart';

var m = Matrix([
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9]
]);
```

### From String

```dart
var m = Matrix("1 2 3; 4 5 6; 7 8 9");
```

### From List (Row-Major)

```dart
var m = Matrix.fromList([
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9]
]);
```

### Special Constructors

```dart
// Identity matrix
var identity = Matrix.eye(3);
// Output:
// ┌ 1 0 0 ┐
// │ 0 1 0 │
// └ 0 0 1 ┘

// Zero matrix
var zeros = Matrix.zeros(3, 4);  // 3 rows, 4 columns

// Ones matrix
var ones = Matrix.ones(2, 3);

// Diagonal matrix
var diag = Matrix.diagonal([1, 2, 3]);
// Output:
// ┌ 1 0 0 ┐
// │ 0 2 0 │
// └ 0 0 3 ┘

// Random matrix
var random = Matrix.random(3, 3);

// Fill with value
var filled = Matrix.fill(3, 3, 7);
```

### Column and Row Matrices

```dart
// Column matrix (n×1)
var col = ColumnMatrix([1, 2, 3, 4]);
// Output:
// ┌ 1 ┐
// │ 2 │
// │ 3 │
// └ 4 ┘

// Row matrix (1×n)
var row = RowMatrix([1, 2, 3, 4]);
// Output:
// [ 1 2 3 4 ]
```

---

## Properties

### Dimensions

```dart
var m = Matrix([
  [1, 2, 3],
  [4, 5, 6]
]);

print(m.rowCount);      // 2
print(m.columnCount);   // 3
print(m.shape);         // [2, 3]
print(m.isSquare);      // false
```

### Matrix Properties

```dart
var m = Matrix([
  [4, 2, 1],
  [16, 4, 1],
  [64, 8, 1]
]);

print(m.determinant());     // -24.0
print(m.trace());           // 9.0 (sum of diagonal)
print(m.rank());            // 3
print(m.conditionNumber()); // Condition number

// Check properties
print(m.isSymmetric());           // false
print(m.isDiagonal());            // false
print(m.isIdentity());            // false
print(m.isSingularMatrix());      // false
print(m.isPositiveDefiniteMatrix()); // depends
print(m.isUpperTriangular());     // false
print(m.isLowerTriangular());     // false
print(m.isOrthogonalMatrix());    // false

// Get all properties
m.matrixProperties().forEach((prop) => print(' - $prop'));
```

---

## Basic Operations

### Arithmetic

```dart
var A = Matrix([[1, 2], [3, 4]]);
var B = Matrix([[5, 6], [7, 8]]);

// Addition
var sum = A + B;

// Subtraction
var diff = A - B;

// Matrix multiplication
var prod = A * B;

// Scalar multiplication
var scaled = A * 2;
var scaled2 = 2 * A;

// Negation
var neg = -A;
```

### Element-wise Operations

```dart
// Element-wise multiplication (Hadamard product)
var elemMult = A.elementMultiply(B);

// Element-wise division
var elemDiv = A.elementDivide(B);

// Apply function to each element
var squared = A.map((e) => e * e);
```

### Transpose and Inverse

```dart
var A = Matrix([[1, 2, 3], [4, 5, 6]]);

// Transpose
var At = A.transpose();

// Inverse (for square matrices)
var B = Matrix([[1, 2], [3, 4]]);
var Binv = B.inverse();

// Pseudo-inverse (for non-square)
var Apinv = A.pseudoInverse();
```

### Matrix Norms

```dart
var m = Matrix([[1, 2], [3, 4]]);

// L1 norm (Manhattan)
print(m.norm(Norm.manhattan));

// L2 norm (Euclidean, default)
print(m.norm());

// Infinity norm (Chebyshev)
print(m.norm(Norm.chebyshev));

// Frobenius norm
print(m.norm(Norm.frobenius));
```

---

## Matrix Manipulation

### Accessing Elements

```dart
var m = Matrix([[1, 2, 3], [4, 5, 6], [7, 8, 9]]);

// Element access
print(m[0][1]);     // 2 (row 0, col 1)
print(m.get(0, 1)); // 2

// Row/column access
print(m.row(0));    // [1, 2, 3]
print(m.column(1)); // [2, 5, 8]

// Diagonal
print(m.diagonal()); // [1, 5, 9]
```

```dart
var v = Matrix([
  [1, 2, 3],
  [4, 5, 6],
  [1, 3, 5]
]);
var b = Matrix([
  [7, 8, 9],
  [4, 6, 8],
  [1, 2, 3]
]);

var r = Row([7, 8, 9]);
var c = Column([7, 4, 1]);
var d = Diagonal([1, 2, 3]);

print(d);
// Output:
// 1 0 0
// 0 2 0
// 0 0 3
```

Change or use element value

```dart
v[1][2] = 0;

var u = v[1][2] + r[0][1];
print(u); // 9

var z = v[0][0] + c[0][0];
print(z); // 8

var y = v[1][2] + b[1][1];
print(y); // 9

var k = v.row(1); // Get all elements in row 1
print(k); // [1,2,3]

var n = v.column(1); // Get all elements in column 1
print(n); // [1,4,1]
```

Index (row,column) of an element in the matrix

```dart
var mat = Matrix.fromList([
  [2, 3, 3, 3],
  [9, 9, 8, 6],
  [1, 1, 2, 9]
]);

var index = mat.indexOf(8);
print(index);
// Output: [1, 2]

var indices = mat.indexOf(3, findAll: true);
print(indices);
// Output: [[0, 1], [0, 2], [0, 3]]
```

Access Row and Column

```dart
var mat = Matrix.fromList([
  [2, 3, 3, 3],
  [9, 9, 8, 6],
  [1, 1, 2, 9]
]);

print(mat[0]);
print(mat.row(0));

// Access column
print(mat.column(0));

// update row method 1
mat[0] = [1, 2, 3, 4];
print(mat);

// update row method 2
var v = mat.setRow(0, [4, 5, 6, 7]);
print(v);

// Update column
v = mat.setColumn(0, [1, 4, 5]);
print(v);

// Insert row
v = mat.insertRow(0, [8, 8, 8, 8]);
print(v);

// Insert column
v = mat.insertColumn(4, [8, 8, 8, 8]);
print(v);

// Delete row
print(mat.removeRow(0));

// Delete column
print(mat.removeColumn(0));

// Delete rows
mat.removeRows([0, 1]);

// Delete columns
mat.removeColumns([0, 2]);
```

### Iterable objects from a matrix

You can get the iterable from a matrix object. Consider the matrix below:

```dart
var mat = Matrix.fromList([
  [2, 3, 3, 3],
  [9, 9, 8, 6],
  [1, 1, 2, 9]
]);
```

Iterate through the rows of the matrix using the default iterator

```dart
for (List<dynamic> row in mat.rows) {
  print(row);
}
```

Iterate through the columns of the matrix using the column iterator

```dart
for (List<dynamic> column in mat.columns) {
  print(column);
}
```

Iterate through the elements of the matrix using the element iterator

```dart
for (dynamic element in mat.elements) {
  print(element);
}
```

Iterate through elements in the matrix using foreach method

```dart
var m = Matrix([[1, 2], [3, 4]]);
m.forEach((x) => print(x));
// Output:
// 1
// 2
// 3
// 4
```

### Slicing

```dart
// Extract submatrix
var sub = m.slice(0, 2, 0, 2);  // rows 0-1, cols 0-1
// Output:
// ┌ 1 2 ┐
// └ 4 5 ┘

// Remove row
var noRow0 = m.removeRow(0);

// Remove column
var noCol1 = m.removeColumn(1);

// Remove multiple
var cleaned = m.removeRows([0, 2]).removeCols([1]);
```

### Partition of Matrix

```dart
// create a matrix
  Matrix m = Matrix([
    [1, 2, 3, 4, 5],
    [6, 7, 8, 9, 10],
    [5, 7, 8, 9, 10]
  ]);

// Extract a subMatrix with rows 1 to 2 and columns 1 to 2
Matrix sub = m.subMatrix(rowRange: "1:2", colRange: "0:1");

Matrix sub = m.subMatrix(rowStart: 1, rowEnd: 2, colStart: 0, colEnd: 1);

// submatrix will be:
// [
//   [6]
// ]

sub = m.subMatrix(rowList: [0, 2], colList: [0, 2, 4]);
// sub will be:
// [
//   [1, 3, 5],
//   [5, 8, 10]
// ]

sub = m.subMatrix(columnIndices: [4, 4, 2]);
 print("\nsub array: $sub");
// sub array: Matrix: 3x3
// ┌  5  5 3 ┐
// │ 10 10 8 │
// └ 10 10 8 ┘

// Get a submatrix
Matrix subMatrix = m.slice(0, 1, 1, 3);
```

### Concatenation

```dart
var A = Matrix([[1, 2], [3, 4]]);
var B = Matrix([[5, 6], [7, 8]]);

// Horizontal (side by side)
var h = A.concatenate(B, axis: 0);
// Output:
// ┌ 1 2 5 6 ┐
// └ 3 4 7 8 ┘

// Vertical (stacked)
var v = A.concatenate(B, axis: 1);
// Output:
// ┌ 1 2 ┐
// │ 3 4 │
// │ 5 6 │
// └ 7 8 ┘
```

### Row Operations

```dart
// Swap rows
var swapped = m.swapRows(0, 2);

// Swap columns
var swappedCols = m.swapColumns(0, 1);

// Row echelon form
var ref = m.rowEchelonForm();

// Reduced row echelon form
var rref = m.reducedRowEchelonForm();
```

### Reshaping

```dart
var m = Matrix([[1, 2, 3, 4, 5, 6]]);

// Reshape to 2x3
var reshaped = m.reshape(2, 3);
// Output:
// ┌ 1 2 3 ┐
// └ 4 5 6 ┘

// Flatten to 1D list
var flat = m.flatten();  // [1, 2, 3, 4, 5, 6]
```

---

## Statistical Methods

```dart
var data = Matrix([
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9]
]);

print(data.sum());      // Sum of all elements
print(data.mean());     // Mean
print(data.min());      // Minimum
print(data.max());      // Maximum
print(data.variance()); // Variance
print(data.std());      // Standard deviation
print(data.median());   // Median

// Along axis
print(data.sumByRow());     // Sum per row
print(data.sumByColumn());  // Sum per column
print(data.meanByRow());    // Mean per row
print(data.meanByColumn()); // Mean per column
```

---

## Decompositions

### LU Decomposition

```dart
var A = Matrix([
  [4, 3],
  [6, 3]
]);

// Doolittle's algorithm
var lu = A.decomposition.luDecompositionDoolittle();
print("L: ${lu.L}");
print("U: ${lu.U}");
print("Verify: ${lu.checkMatrix}");

// With partial pivoting
var luPP = A.decomposition.luDecompositionDoolittlePartialPivoting();
print("P: ${luPP.P}");

// With complete pivoting
var luCP = A.decomposition.luDecompositionDoolittleCompletePivoting();
print("Q: ${luCP.Q}");

// Crout's algorithm
var luCrout = A.decomposition.luDecompositionCrout();

// Gauss elimination
var luGauss = A.decomposition.luDecompositionGauss();
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

### LQ Decomposition

```dart
var lq = A.decomposition.lqDecomposition();
print("L: ${lq.L}");
print("Q: ${lq.Q}");
```

### Cholesky Decomposition

For symmetric positive-definite matrices:

```dart
var B = Matrix([
  [4, 12, -16],
  [12, 37, -43],
  [-16, -43, 98]
]);

var chol = B.decomposition.choleskyDecomposition();
print("L: ${chol.L}");
// L * L^T = B
```

### Eigenvalue Decomposition

```dart
var eigen = A.decomposition.eigenvalueDecomposition();
print("D (eigenvalues): ${eigen.D}");
print("V (eigenvectors): ${eigen.V}");

// Direct access
print(A.eigen().eigenvalues);
print(A.eigen().eigenvectors);
```

### Singular Value Decomposition (SVD)

```dart
var svd = A.decomposition.singularValueDecomposition();
print("U: ${svd.U}");
print("S: ${svd.S}");  // Singular values
print("V: ${svd.V}");
print("Verify: ${A.isAlmostEqual(svd.checkMatrix.round())}");
```

### Schur Decomposition

```dart
var schur = A.decomposition.schurDecomposition();
print("T: ${schur.T}");
print("Q: ${schur.Q}");
print("Q orthogonal: ${schur.isOrthogonalMatrix}");
```

---

## Solving Linear Systems of Equations

Use the solve method to solve a linear system of equations:

```dart
Matrix a = Matrix([[2, 1, 1], [1, 3, 2], [1, 0, 0]]);;

Matrix b = Matrix([[4], [5], [6]]);

// Solve the linear system Ax = b
Matrix x = a.linear.solve(b, method: LinearSystemMethod.gaussElimination);
print(x.round(1));
// Output:
// Matrix: 3x1
// ┌   6.0 ┐
// │  15.0 │
// └ -23.0 ┘
```

You can also use the the decompositions to solve a linear system of equations

```dart
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

//Solve using the Schur Decomposition
SchurDecomposition schur = A.decomposition.schurDecomposition();

//Solve using the QR Decomposition Householder
QRDecomposition qr = A.decomposition.qrDecompositionHouseholder();

// Solve for x using the object
var x = qr.solve(b).round();
print(x);

// Output:
// Matrix: 3x1
// ┌ 1 ┐
// │ 7 │
// └ 6 ┘
```

---

## Special Matrices

### DiagonalMatrix

```dart
var diag = DiagonalMatrix([1, 2, 3, 4]);
print(diag.diagonal);  // [1, 2, 3, 4]
print(diag.trace());   // 10
```

### SparseMatrix

For matrices with many zeros:

```dart
var sparse = SparseMatrix(1000, 1000);
sparse.set(0, 0, 5);
sparse.set(500, 500, 10);

print(sparse.get(0, 0));     // 5
print(sparse.get(1, 1));     // 0 (default)
print(sparse.nonZeroCount);  // 2
```

### SylvesterMatrix

For polynomials:

```dart
var sylvester = SylvesterMatrix.fromPolynomials(
  [1, 2, 1],   // x² + 2x + 1
  [1, -1]      // x - 1
);
```

---

## Iteration

### Iterate Over Rows

```dart
var m = Matrix([[1, 2, 3], [4, 5, 6]]);

for (var row in m.rows) {
  print(row);
}
// [1, 2, 3]
// [4, 5, 6]
```

### Iterate Over Columns

```dart
for (var col in m.columns) {
  print(col);
}
// [1, 4]
// [2, 5]
// [3, 6]
```

### Iterate Over Elements

```dart
for (var element in m.elements) {
  print(element);
}
// 1, 2, 3, 4, 5, 6
```

---

## Boolean Operations

Some functions in the library that results in boolean values

```dart
// Check contain or not
var matrix1 = Matrix([[1, 2], [3, 4]]);
var matrix2 = Matrix([[5, 6], [7, 8]]);
var matrix3 = Matrix([[1, 2, 3], [3, 4, 5], [5, 6, 7]]);
var targetMatrix = Matrix([[1, 2], [3, 4]]);

print(targetMatrix.containsIn([matrix1, matrix2])); // Output: true
print(targetMatrix.containsIn([matrix2, matrix3])); // Output: false

print(targetMatrix.notIn([matrix2, matrix3])); // Output: true
print(targetMatrix.notIn([matrix1, matrix2])); // Output: false

print(targetMatrix.isSubMatrix(matrix3)); // Output: true
```

Check Equality of Matrix

```dart
var m1 = Matrix([[1, 2], [3, 4]]);
var m2 = Matrix([[1, 2], [3, 4]]);
print(m1 == m2); // Output: true

print(m1.notEqual(m2)); // Output: false

```

Compare elements of Matrix

```dart
var m = Matrix.fromList([
    [2, 3, 3, 3],
    [9, 9, 8, 6],
    [1, 1, 2, 9]
  ]);
var result = Matrix.compare(m, '>', 2);
print(result);
// Output:
// Matrix: 3x4
// ┌ false  true  true true ┐
// │  true  true  true true │
// └ false false false true ┘
```

## Sorting Matrix

```dart
Matrix x = Matrix.fromList([
  [2, 3, 3, 3],
  [9, 9, 8, 6],
  [1, 1, 2, 9],
  [0, 1, 1, 1]
]);

//Sorting all elements in ascending order (default behavior):
var sortedMatrix = x.sort();
print(sortedMatrix);
// Matrix: 4x4
// ┌ 0 1 1 1 ┐
// │ 1 1 2 2 │
// │ 3 3 3 6 │
// └ 8 9 9 9 ┘

// Sorting all elements in descending order:
var sortedMatrix1 = x.sort(ascending: false);
print(sortedMatrix1);
// Matrix: 4x4
// ┌ 9 9 9 8 ┐
// │ 6 3 3 3 │
// │ 2 2 1 1 │
// └ 1 1 1 0 ┘

// Sort by a single column in descending order
var sortedMatrix2 = x.sort(columnIndices: [0]);
print(sortedMatrix2);
// Matrix: 4x4
// ┌ 0 1 1 1 ┐
// │ 1 1 2 9 │
// │ 2 3 3 3 │
// └ 9 9 8 6 ┘

// Sort by multiple columns in specified orders
var sortedMatrix3 = x.sort(columnIndices: [1, 0]);
print(sortedMatrix3);
// Matrix: 4x4
// ┌ 0 1 1 1 ┐
// │ 1 1 2 9 │
// │ 2 3 3 3 │
// └ 9 9 8 6 ┘

// Sorting rows based on the values in column 2 (descending order):
Matrix xSortedColumn2Descending =
    x.sort(columnIndices: [2], ascending: false);
print(xSortedColumn2Descending);
// Matrix: 4x4
// ┌ 9 9 8 6 ┐
// │ 2 3 3 3 │
// │ 1 1 2 9 │
// └ 0 1 1 1 ┘
```

## Other Functions of matrices

The Matrix class provides various other functions for matrix manipulation and analysis.

```dart

// Swap rows
var matrix = Matrix([[1, 2], [3, 4]]);
matrix.swapRows(0, 1);
print(matrix);
// Output:
// Matrix: 2x2
// ┌ 3 4 ┐
// └ 1 2 ┘

// Swap columns
matrix.swapColumns(0, 1);
print(matrix);
// Output:
// Matrix: 2x2
// ┌ 4 3 ┐
// └ 2 1 ┘

// Get the leading diagonal of the matrix
var m = Matrix([[1, 2], [3, 4]]);
var diag = m.diagonal();
print(diag);
// Output: [1, 4]

// Iterate through elements in the matrix using map function
var doubled = m.map((x) => x * 2);
print(doubled);
// Output:
// Matrix: 2x2
// ┌ 2 4 ┐
// └ 6 8 ┘
```

---

## I/O

### Export to CSV

```dart
var csv = m.toCsv();  // String
await File('matrix.csv').writeAsString(csv);
```

### Export to JSON

```dart
var json = m.toJson();  // String
await File('matrix.json').writeAsString(json);
```

### Pretty Print

```dart
m.prettyPrint();
// Matrix: 3x3
// ┌ 1 2 3 ┐
// │ 4 5 6 │
// └ 7 8 9 ┘
```

### Round

```dart
var rounded = m.round();      // Integer rounding
var rounded2 = m.round(2);    // 2 decimal places
```

---

## Related Tests

- [`test/matrix_decomposition_test.dart`](../../test/matrix_decomposition_test.dart)
- [`test/matrix_linear_equation_test.dart`](../../test/matrix_linear_equation_test.dart)
- [`test/matrix_test.dart`](../../test/matrix_test.dart)
- [`test/matrix_factory_test.dart`](../../test/matrix_factory_test.dart)

## Related Documentation

- [Vector](05_vector.md) - Vector operations
- [Linear](06_linear.md) - Linear system solvers
- [Least Squares](08_least_squares.md) - Fitting and regression
- [Main Algebra](../01_algebra.md) - Module overview
