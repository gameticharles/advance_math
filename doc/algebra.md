# Algebra Module

This module provides a rich set of tools for algebraic computations, including matrix and vector operations, polynomial manipulation, mathematical expression parsing and evaluation, and base conversion utilities.

## Table of Contents
- [Vector](#vector)
  - [Overview](#vector-overview)
  - [Constructors](#vector-constructors)
  - [Properties](#vector-properties)
  - [Methods](#vector-methods)
    - [Core Vector Operations (Conceptual)](#core-vector-operations)
  - [Operators](#vector-operators)
- [Matrix](#matrix)
  - [Overview](#matrix-overview)
  - [Constructors](#matrix-constructors)
  - [Properties](#matrix-properties)
  - [Methods](#matrix-methods)
  - [Operators](#matrix-operators)
  - [Static Methods](#matrix-static-methods)
  - [Matrix Extensions](#matrix-extensions)
    - [Arithmetic Operations](#matrix-arithmetic-operations)
    - [Structural Manipulations](#matrix-structural-manipulations)
    - [Mathematical Functions on Elements](#matrix-mathematical-functions)
    - [Linear Algebra Operations](#matrix-linear-algebra-operations)
  - [Matrix Decompositions](#matrix-decompositions)
    - [Overview](#matrix-decomposition-overview)
    - [LU Decomposition](#lu-decomposition)
    - [Singular Value Decomposition (SVD)](#singular-value-decomposition-svd)
    - [QR Decomposition](#qr-decomposition)
    - [LQ Decomposition](#lq-decomposition)
    - [Cholesky Decomposition](#cholesky-decomposition)
    - [Eigenvalue Decomposition](#eigenvalue-decomposition)
    - [Schur Decomposition](#schur-decomposition)
  - [Solving Linear Systems (`Matrix.linear`)](#solving-linear-systems)
- [Mathematical Expressions](#mathematical-expressions)
  - [Overview](#expression-overview)
  - [Usage (Parsing and Evaluation)](#expression-usage)
  - [Parser Details](#expression-parser-details)
  - [Supported Elements](#supported-expression-elements)
- [Polynomials](#polynomials)
  - [Overview](#polynomial-overview)
  - [Constructors](#polynomial-constructors)
  - [Properties](#polynomial-properties)
  - [Methods](#polynomial-methods)
  - [Operators](#polynomial-operators)
- [Base Conversion Utilities (`Bases`)](#base-conversion-utilities-bases)
  - [Overview](#bases-overview)
  - [Static Methods](#bases-static-methods)
- [Other Algebraic Utilities](#other-algebraic-utilities)

---

## Vector
*(Documentation for the `Vector` class from `lib/src/math/algebra/vector/vector.dart`. Specific arithmetic operations like dot/cross products, norm, and normalize are often found in vector extensions (e.g., `vector_extensions.dart`) or specialized classes like `Vector2`, `Vector3`, `Vector4`, which were not read in this session. Their documentation here is conceptual or based on general vector library patterns.)*

### Vector Overview
The `Vector` class represents a one-dimensional array of numerical values, internally storing them as `Complex` numbers. It serves as a fundamental building block for various mathematical and scientific computations.

Key features:
- Stores sequences of numbers (real or complex).
- Basic data manipulation (add, remove, access elements).
- Conversion to/from Lists and Matrices.
- Geometric calculations like distance, angle, and projection.

### Vector Constructors
*(Retained from previous documentation: `Vector()`, `Vector.fromList()`, `Vector.random()`, `Vector.linspace()`, `Vector.range()`/`arrange()`)*

#### `Vector(dynamic input, {bool isDouble = true})`
- If `input` is an `int` (length `L`), creates a vector of length `L` initialized with `Complex(0.0, 0.0)` if `isDouble` is true, or `Complex(0, 0)` otherwise.
- If `input` is a `List`, creates a vector from its elements, converting them to `Complex`.
```dart
var vLen = Vector(3); // Output: [0.0 + 0.0i, 0.0 + 0.0i, 0.0 + 0.0i]
var vList = Vector([1, 2.5, Complex(0,1)]); // Output: [1.0 + 0.0i, 2.5 + 0.0i, 0.0 + 1.0i]
```

#### `Vector.fromList(List data)`
Creates a `Vector` from `data`. Elements are converted to `Complex`.
```dart
var v = Vector.fromList([1, Complex(2, -1)]); // Output: [1.0 + 0.0i, 2.0 - 1.0i]
```
*(Other constructors like `random`, `linspace`, `range`/`arrange` retained as previously documented.)*

### Vector Properties
*(Retained from previous documentation: `length`, `elements`, `iterator`)*

### Vector Methods
*(Includes methods from `vector.dart` and conceptual documentation for common vector operations that are typically in extensions.)*

#### Core Vector Operations (Conceptual)
These operations are standard for vector libraries. While their direct implementation in the base `Vector` class wasn't fully confirmed from the provided snippets (they often reside in extensions like `VectorArithmeticExtension` or specific types like `Vector3`), their conceptual usage is as follows:

-   **`dynamic dot(Vector other)`**: Calculates the dot product (inner product).
    `sum(this[i] * other[i])`. Result is typically a scalar (`Complex` or `num`).
    ```dart
    // final v1 = Vector([1, 2, 3]);
    // final v2 = Vector([4, -5, 6]);
    // final dotProduct = v1.dot(v2); // Conceptual: (1*4) + (2*-5) + (3*6) = 12
    // print(dotProduct); // Example: 12.0 + 0.0i
    ```
-   **`Vector cross(Vector other)`**: (For 3D Vectors) Calculates the cross product.
    ```dart
    // final v1 = Vector([1, 0, 0]); // Typically Vector3
    // final v2 = Vector([0, 1, 0]);
    // final crossProduct = v1.cross(v2);
    // print(crossProduct); // Example: [0.0+0.0i, 0.0+0.0i, 1.0+0.0i] (k-vector)
    ```
-   **`dynamic norm({Norm type = Norm.frobenius})`**: Calculates vector norm (magnitude).
    - `Norm.frobenius` (L2 norm, default): `sqrt(sum(this[i].abs()²))`.
    - `Norm.manhattan` (L1 norm): `sum(this[i].abs())`.
    - `Norm.chebyshev` (L-infinity norm): `max(this[i].abs())`.
    ```dart
    // final v = Vector([3, 4]);
    // print(v.norm()); // L2 norm: 5.0
    // print(v.norm(type: Norm.manhattan)); // L1 norm: 7.0
    ```
-   **`Vector normalize()`**: Returns a unit vector (magnitude 1) in the same direction.
    ```dart
    // final v = Vector([3, 0, 4]); // Magnitude 5
    // final normalizedV = v.normalize();
    // print(normalizedV); // Output: [0.6+0.0i, 0.0+0.0i, 0.8+0.0i]
    ```

#### `distance(Vector other, {DistanceType distance = DistanceType.frobenius}) -> dynamic`
Calculates distance to `other` vector. Supported `DistanceType` enums: `frobenius` (Euclidean), `manhattan`, `chebyshev`, `cosine`, `hamming`.
```dart
final v1 = Vector([1,2]); final v2 = Vector([4,6]);
print(v1.distance(v2)); // Euclidean distance. Output: 5.0 + 0.0i
```

#### `angle(Vector other) -> dynamic`
*(Renamed from `angleTo` for consistency if it's the primary angle method)*
Calculates angle in radians to `other` vector: `acos(dot(this,other) / (norm(this)*norm(other)))`.
```dart
final v1 = Vector([1,0]); final v2 = Vector([1,1]);
print(v1.angle(v2)); // Output: 0.7853... + 0.0i (pi/4)
```

#### `projection(Vector other) -> Vector`
*(Renamed from `projectionOnto` for consistency)*
Calculates projection of this vector onto `other`.
```dart
final v1 = Vector([2,2]); final v2 = Vector([3,0]);
print(v1.projection(v2)); // Output: [2.0+0.0i, 0.0+0.0i]
```

*(Other methods like `isZero`, `isUnit`, `toSpherical`, `toCylindrical`, `toPolar`, `getVector`, `subVector`, list manipulations (`flip`, `push`, `pop`, `unShift`, `shift`, `roll`, `splice`, `swap`), and conversions (`toDiagonal`, `toMatrix`, `toPoint`) are retained as documented previously, verified with `vector.dart`.)*

### Vector Operators
*(Retained from previous documentation: `[]`, `[]=`, `==`. Arithmetic operators are typically via extensions, not part of base `vector.dart`.)*

---

## Matrix
*(Documentation for the `Matrix` class and its extensions, incorporating details from all read files.)*

### Matrix Overview
*(Retained from previous documentation. Key idea: 2D array of `Complex` numbers, extensive linear algebra functionalities.)*

### Matrix Constructors
*(Retained and verified with `matrix.dart` source. This includes the main constructor, `fromList`, `fromFlattenedList`, `fromDiagonal`, `fromColumns`, `fromRows`, `random`, `zeros`, `ones`, `eye`, `scalar`, `fill`, `linspace`, `range`/`arrange`, `fromBlocks`, `magic`, `fromCSV`, `fromJSON`, `fromBinary`.)*

### Matrix Properties
*(Retained and verified: `rowCount`, `columnCount`, `shape`, `rows`, `columns`, `elements`, `iterator`, `decomposition`, `linear`, `Matrix.factory`.)*

### Matrix Methods
*(Retained and verified for base Matrix class: `equal()`, `notEqual()`, `row()`, `column()`, `diagonal()`, `indexOf()`, `toString()`, `prettyPrint()`, `toCSV()`, `toJSON()`, `toBinary()`.)*

### Matrix Operators
*(Retained and verified for base Matrix class: `[]`, `[]=`, `==`.)*

### Matrix Static Methods
*(Retained and verified: `Matrix.compare()`, `Matrix.concatenate()`, `Matrix.distance()`.)*

### Matrix Extensions
The `Matrix` class capabilities are significantly expanded through extension methods.

#### Arithmetic Operations (`matrix/extension/operations.dart`)
-   `operator +(dynamic other) -> Matrix`: Element-wise addition with another `Matrix`, `Vector` (column-wise to each matrix column, or row-wise if vector matches column count), or `num`/`Complex` (scalar added to all elements).
-   `operator -(dynamic other) -> Matrix`: Element-wise subtraction.
-   `operator *(dynamic other) -> Matrix`:
    - If `other` is `Matrix`: Matrix multiplication (dot product). Uses Strassen's algorithm for large matrices (threshold `sizeLimit = 64`).
    - If `other` is `Vector`: Matrix-vector multiplication, returns a `ColumnMatrix`.
    - If `other` is `num` or `Complex`: Scalar multiplication.
-   `operator /(dynamic other) -> Matrix`: Scalar division (element-wise by `num` or `Complex`).
-   `operator -() -> Matrix`: Unary negation (element-wise).
-   `pow(num exponent) -> Matrix`: Element-wise power (each element raised to `exponent`).
-   `operator ^(int exponent) -> Matrix`: Matrix power (matrix multiplied by itself `exponent` times). Requires square matrix and non-negative integer exponent.
-   `elementMultiply(Matrix other) -> Matrix`: Element-wise (Hadamard) product.
-   `elementDivide(Matrix other) -> Matrix`: Element-wise division.
-   `scale(dynamic scaleFactor) -> Matrix`: Alias for scalar multiplication.
-   `dot(Matrix other) -> Matrix`: Alias for matrix multiplication.
```dart
final m1 = Matrix([[1,2],[3,4]]);
final m2 = Matrix([[0,1],[1,0]]);
print(m1 + m2); // Output: [[1,3],[4,4]]
print(m1 * 2);  // Output: [[2,4],[6,8]]
print(m1 * m2); // Output: [[2,1],[4,3]] (dot product)
print(m1 ^ 2);  // Output: [[7,10],[15,22]] (m1 * m1)
```

#### Structural Manipulations (`matrix/extension/manipulate.dart`)
*(Retained from previous documentation. Includes: `reshape`, `reshapeList`, `sort`, `removeRow/s`, `removeColumn/s`, `setRow`, `setColumn`, `insertRow`, `insertColumn`, `appendRows`, `appendColumns`, `augment`, `elementAt`, `replace`, `flatten`, `flip`, `copy`, `copyFrom`, `subMatrix`, `slice`, `setSubMatrix`, `split`, `swapRows`, `swapColumns`, `replicateMatrix`, `roll`, `isCompatibleForBroadcastWith`, `broadcast`, `apply` (element-wise), `applyToRows`.)*

-   **`transpose() -> Matrix`**: (from `matrix_functions.dart` or similar extension) Returns the matrix transpose.
    ```dart
    final m = Matrix([[1,2,3],[4,5,6]]);
    print(m.transpose());
    // Output:
    // Matrix: 3x2
    // [ 1.0+0.0i 4.0+0.0i ]
    // [ 2.0+0.0i 5.0+0.0i ]
    // [ 3.0+0.0i 6.0+0.0i ]
    ```
-   **`slice(int startRow, int endRow, [int? startCol, int? endCol]) -> Matrix`**: Extracts a sub-matrix. `endRow` and `endCol` are exclusive.
-   **`subMatrix({List<int>? rowIndices, ...}) -> Matrix`**: Extracts a sub-matrix using lists of indices or ranges. `rowEnd` and `colEnd` in range strings are inclusive.
    ```dart
    final m = Matrix.magic(4);
    print(m.slice(1, 3, 1, 3)); // Rows 1,2 (exclusive end), Cols 1,2 (exclusive end)
    print(m.subMatrix(rowRange: "1:2", colRange: "1:2")); // Rows 1,2 (inclusive end), Cols 1,2 (inclusive end)
    ```

#### Mathematical Functions on Elements
*(Many of these are in `matrix/extension/matrix_functions.dart` or similar, applied element-wise)*
- `abs() -> Matrix`
- `conjugate() -> Matrix`
- `exp()`, `log()`, `sqrt()`, `pow(num exponent)` (element-wise)
- Trigonometric: `sin()`, `cos()`, `tan()`, etc. (element-wise)

#### Linear Algebra Operations
*(From `matrix_functions.dart`, `operations.dart` or specific decomposition extensions)*
-   `trace() -> dynamic`: Sum of diagonal elements.
-   `determinant({DeterminantMethod method = DeterminantMethod.LU}) -> dynamic`: LU default or Laplace.
-   `inverse({double conditionThreshold = 1e-3}) -> Matrix`: Uses LU, SVD, or pseudo-inverse based on condition number.
-   `pseudoInverse() -> Matrix`: Moore-Penrose pseudo-inverse.
-   `rank({double tolerance = 1e-9}) -> int`: Effective rank.
-   `norm([Norm normType = Norm.frobenius]) -> dynamic`: Frobenius, Manhattan, Chebyshev, Spectral, Trace.
-   `conditionNumber() -> dynamic`: `norm(A) * norm(A⁻¹)`.
-   `cofactors() -> Matrix`
-   `adjoint() -> Matrix`
-   `rowSpace() -> Matrix`, `columnSpace() -> Matrix`, `nullSpace() -> Matrix`, `nullity() -> int`.
-   `reducedRowEchelonForm() -> Matrix`.
-   Boolean checks: `isSquareMatrix()`, `isSymmetricMatrix()`, `isSkewSymmetricMatrix()`, `isDiagonalMatrix()`, `isUpperTriangularMatrix()`, `isLowerTriangularMatrix()`, `isOrthogonalMatrix()`, `isIdentityMatrix()`, `isInvertibleMatrix()`, `isPositiveDefiniteMatrix()`.

### Matrix Decompositions
#### Overview
Matrix decompositions factor a matrix into a product of simpler matrices, essential for solving linear systems, eigenvalue problems, etc. Accessed via `matrix.decomposition`, which returns a `MatrixDecomposition` object. This object then provides specific decomposition methods.

#### LU Decomposition
-   **Purpose**: Factors `A` into `L*U` (lower and upper triangular), often with pivoting `P*A=L*U` or `P*A*Q=L*U`.
-   **Methods on `MatrixDecomposition`**:
    - `luDecompositionDoolittle()`: Returns `LUDecomposition(L, U)`.
    - `luDecompositionDoolittlePartialPivoting()`: Returns `LUDecomposition(L, U, P)`.
    - `luDecompositionDoolittleCompletePivoting()`: Returns `LUDecomposition(L, U, P, Q)`.
    - `luDecompositionCrout()`: Returns `LUDecomposition(L, U)`.
    - `luDecompositionGauss()`: Returns `LUDecomposition(L, U, P)`.
-   **`LU` Object (from `lu.dart`)**: Contains `L()`, `U()`, `pivot()` (permutation vector), `det()`, `solve(Matrix B)`.
-   **Example**:
    ```dart
    final A = Matrix([[1,2,3],[2,5,8],[3,8,14]]);
    final b = Matrix.column([6,15,25]); // Column Matrix
    final luResult = A.decomposition.luDecompositionDoolittlePartialPivoting();
    final x = luResult.solve(b);
    print("Solution x using LU: \n$x"); // Expected: [[1],[1],[1]]
    // Matrix PMatrix = Matrix.eye(A.rowCount).subMatrix(rowIndices: luResult.pivot().flatten().map((e) => (e as Complex).toInt()).toList());
    // print("P*A approx L*U: ${MatrixDecomposition.checkLUDecomposition(PMatrix * A, luResult)}");
    ```

#### Singular Value Decomposition (SVD)
-   **Purpose**: Factors `A` into `U*S*Vᵀ` (U, V orthogonal; S diagonal with singular values).
-   **Method on `MatrixDecomposition`**: `singularValueDecomposition({int? maxIterations})`.
-   **`SVD` Object (from `svd.dart`)**: Contains `U()`, `S()` (diagonal matrix), `V()` (not Vᵀ), `singularValues()` (list), `cond()` (condition number), `solve(Matrix B)`.
-   **Example**:
    ```dart
    final A = Matrix([[1.0, 0.0], [0.0, -2.0], [0.0, 0.0]]);
    final svdResult = A.decomposition.singularValueDecomposition();
    // print("U:\n${svdResult.U()}S:\n${svdResult.S()}V:\n${svdResult.V()}");
    // print("Singular Values: ${svdResult.singularValues()}");
    // print("A approx U*S*Vᵀ: ${MatrixDecomposition.checkSingularValueDecomposition(A, svdResult)}");
    // Solve Ax=b using SVD (least squares for non-square/singular)
    // final B_svd = Matrix.column([1,2,3]);
    // final x_svd = svdResult.solve(B_svd);
    // print("Solution x (SVD): \n$x_svd");
    ```

#### Other Decompositions
*(Specific source files for QR, LQ, Cholesky, Eigen, Schur were not available. Documentation is based on common patterns and methods in `MatrixDecomposition`.)*
-   **QR Decomposition**: `A = QR`. `Q` orthogonal, `R` upper triangular.
    -   Methods: `qrDecompositionGramSchmidt()`, `qrDecompositionHouseholder()`.
    -   Result: `QRDecomposition` object with `Q`, `R`, `solve(B)`.
-   **LQ Decomposition**: `A = LQ`. `L` lower triangular, `Q` orthogonal.
    -   Method: `lqDecomposition()`.
    -   Result: `LQDecomposition` object with `L`, `Q`, `solve(B)`.
-   **Cholesky Decomposition**: `A = LLᵀ` for symmetric positive-definite `A`. `L` lower triangular.
    -   Method: `choleskyDecomposition()`.
    -   Result: `CholeskyDecomposition` object with `L`, `solve(B)`.
-   **Eigenvalue Decomposition**: `A = VDV⁻¹`. `D` diagonal (eigenvalues), `V` columns are eigenvectors.
    -   Method: `eigenvalueDecomposition({maxIterations, tolerance})`.
    -   Result: `EigenvalueDecomposition` object with `D`, `V`, `solve(B)`.
-   **Schur Decomposition**: `A = QTQ*`. `Q` unitary, `T` upper (quasi-)triangular.
    -   Method: `schurDecomposition({maxIterations, tolerance})`.
    -   Result: `SchurDecomposition` object with `Q`, `T`, `solve(B)`.

### Solving Linear Systems (`Matrix.linear`)
The `matrix.linear` getter provides access to a `LinearSystemSolvers` instance. The primary method is `solve(Matrix B, {LinearSystemMethod method = LinearSystemMethod.auto, double ridgeAlpha = 0.0}) -> Matrix`.
-   **`method`: `LinearSystemMethod` enum**:
    -   `auto`: Default, usually picks LU or QR.
    -   `luDecomposition`, `qrDecomposition`, `svd`, `cholesky`, `eigenvalueDecomposition`, `schurDecomposition`: Use the specified decomposition.
    -   Direct methods: `inverseMatrix`, `gaussElimination`, `gaussJordanElimination`, `cramersRule`, `bareiss`.
    -   Iterative: `jacobi`, `gaussSeidel`, `sor`, `conjugateGradient`.
    -   Regularization: `ridgeRegression` (uses `ridgeAlpha`).
    -   Other: `leastSquares`.
-   **Example**:
    ```dart
    Matrix A = Matrix([[4,1,-1],[1,4,-1],[-1,-1,4]]);
    Matrix b = Matrix.column([6,25,14]);
    Matrix x = A.linear.solve(b, method: LinearSystemMethod.luDecomposition);
    print("Solution (LU): \n${x.round()}"); // Expected: [[1],[7],[6]]
    ```

---

## Mathematical Expressions
*(Retained from previous documentation: Overview, Usage, Parser Details, Supported Elements)*

---

## Polynomials
*(Documentation for `Polynomial` class from `lib/src/math/algebra/expression/components/polynomial/polynomial.dart`)*

### Polynomial Overview
The `Polynomial` class (extends `Expression`) represents a univariate polynomial with coefficients typically as `Complex` numbers. It supports standard polynomial operations, evaluation, differentiation, integration, and finding roots. Coefficients are stored in decreasing order of degree (e.g., `[a, b, c]` for `ax² + bx + c`).

The library provides specialized classes for common degrees (`Constant`, `Linear`, `Quadratic`, `Cubic`, `Quartic`) which are created by the `Polynomial.fromList` factory based on the number of coefficients. For degrees higher than 4, a general `DurandKerner` (using Durand-Kerner method for root finding) or a base `Polynomial` instance is used.

### Polynomial Constructors
-   **`Polynomial(List<dynamic> coefficients)`**: Primary constructor. Coefficients (highest degree first) are converted to `Complex`.
    ```dart
    final p = Polynomial([Complex(1), -2, Complex(1,0)]); // x² - 2x + 1
    print(p); // Output: x² - 2.0 + 0.0i*x + 1.0 + 0.0i
    ```
-   **`static Polynomial.fromList(List<dynamic> coefficientList)`**: Factory that returns a specialized polynomial type (`Constant`, `Linear`, `Quadratic`, `Cubic`, `Quartic`, or `DurandKerner` for degree >= 5) based on the length of `coefficientList`. Coefficients are ordered from highest degree to constant term.
    ```dart
    final pQuad = Polynomial.fromList([2, -3, 1]); // 2x² - 3x + 1 (Quadratic)
    print('$pQuad is Quadratic: ${pQuad is Quadratic}'); // Output: 2.0 + 0.0ix² - 3.0 + 0.0ix + 1.0 + 0.0i is Quadratic: true
    ```
-   **`factory Polynomial.fromString(String source)`**: Parses a polynomial string (e.g., "x^2 + 2x + 1", "-20x⁴ + 163x³"). Supports `x`, `^`, and superscripts (e.g., `x²`).
    ```dart
    final pStr = Polynomial.fromString("3x^3 - 2x + 5");
    print(pStr); // Output: 3.0 + 0.0ix³ - 2.0 + 0.0ix + 5.0 + 0.0i
    ```

### Polynomial Properties
-   `coefficients: List<dynamic>`: List of `Complex` coefficients (highest degree first).
-   `degree: int`: Degree of the polynomial.

### Polynomial Methods
-   **`Polynomial differentiate()`**: Returns the derivative of the polynomial.
    ```dart
    final p = Polynomial.fromString("x^3 - 2x^2 + 5");
    print(p.differentiate()); // Output: 3.0 + 0.0ix² - 4.0 + 0.0ix
    ```
-   **`Expression integrate([dynamic start, dynamic end])`**: Returns the indefinite integral (as `Polynomial` with constant term 0).
    ```dart
    final p = Polynomial.fromString("3x^2 - 4x");
    print(p.integrate()); // Output: 1.0 + 0.0ix³ - 2.0 + 0.0ix² + 0.0 + 0.0i
    ```
-   **`List<dynamic> roots()`**: Calculates the roots (`Complex`) of the polynomial.
    ```dart
    final pQuad = Polynomial.fromList([1, -3, 2]); // x² - 3x + 2
    print(pQuad.roots()); // Output: [1.0 + 0.0i, 2.0 + 0.0i] (approx)
    ```
-   **`dynamic evaluate([dynamic x])`**: Evaluates P(x). `x` can be `num` or `Complex`.
    ```dart
    final p = Polynomial([1, -2, 1]); // x² - 2x + 1
    print(p.evaluate(Complex(3,0))); // Output: 4.0 + 0.0i
    ```
-   **`Polynomial simplify()`**: Simplifies by dividing coefficients by their GCD.
-   **`String factorizeString()`**: Returns string of factors, e.g., "c * (x - r1) * (x - r2)".
-   **`List<Polynomial> factorize()`**: Returns list of `Polynomial` factors.
-   **`String toString([bool useUnicode = true])`**: String representation. `useUnicode` for superscripts.

### Polynomial Operators
-   `+`, `-`, `*` with `Polynomial` return `Polynomial`.
-   `/` with `Polynomial` returns an `Expression` (potentially `Add(PolynomialQuotient, RationalFunctionRemainder)`).
-   `==`, `[]` (coefficient access).

---

## Base Conversion Utilities (`Bases`)
*(Retained from previous documentation: Overview, Static Methods for `isValidForBase`, `toDecimal`, `fromDecimal`, `convert`, `rangeInBase`, and specialized converters like `binaryToDecimal` etc. Error handling and `padLength` example included.)*

---
## Other Algebraic Utilities
*(This section remains a placeholder.)*
