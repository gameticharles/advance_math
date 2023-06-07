part of algebra;

extension MatrixStructure on Matrix {
  /// Returns a list of all the properties of the matrix.
  ///
  /// The list of properties includes:
  ///   - Square Matrix
  ///   - Null Matrix
  ///   - Diagonal Matrix
  ///   - Identity Matrix
  ///   - Unitary Matrix
  ///   - Scalar Matrix
  ///   - Row Matrix
  ///   - Column Matrix
  ///   - Full Rank Matrix
  ///   - Horizontal Matrix
  ///   - Vertical Matrix
  ///   - Upper Triangular Matrix
  ///   - Lower Triangular Matrix
  ///   - Symmetric Matrix
  ///   - Skew Symmetric Matrix
  ///   - Orthogonal Matrix
  ///   - Singular Matrix
  ///   - Non-Singular Matrix
  ///   - Nilpotent Matrix
  ///   - Involutary Matrix
  ///   - Idempotent Matrix
  ///   - Bidiagonal Matrix
  ///   - Tridiagonal Matrix
  ///   - Hermitian Matrix
  ///   - Toeplitz Matrix
  ///   - Hankel Matrix
  ///   - Sparse Matrix
  ///   - Circulant Matrix
  ///   - Vandermonde Matrix
  ///   - Permutation Matrix
  ///   - Periodic Matrix
  ///   - Positive Definite Matrix
  ///   - Negative Definite Matrix
  ///   - Derogatory Matrix
  ///   - Has Dominant Eigenvalue
  ///   - Diagonally Dominant Matrix
  ///   - Strictly Diagonally Dominant Matrix
  ///
  /// If no specific properties apply, it will return a list containing only
  /// the 'General Matrix' property.
  ///
  /// @returns A [List<String>] of all properties that apply to the matrix.
  List<String> matrixProperties() {
    List<String> properties = [];

    void safelyAdd(String property, bool Function() check) {
      try {
        if (check()) properties.add(property);
      } catch (_) {
        // Ignore errors and continue
      }
    }

    safelyAdd('Square Matrix', isSquareMatrix);
    safelyAdd('Null Matrix', isNullMatrix);
    safelyAdd('Diagonal Matrix', isDiagonalMatrix);
    safelyAdd('Identity Matrix', isIdentityMatrix);
    safelyAdd('Scalar Matrix', isScalarMatrix);
    safelyAdd('Row Matrix', isRowMatrix);
    safelyAdd('Column Matrix', isColumnMatrix);
    safelyAdd('Full Rank Matrix', isFullRank);
    safelyAdd('Horizontal Matrix', isHorizontalMatrix);
    safelyAdd('Vertical Matrix', isVerticalMatrix);
    safelyAdd('Upper Triangular Matrix', isUpperTriangular);
    safelyAdd('Lower Triangular Matrix', isLowerTriangular);
    safelyAdd('Symmetric Matrix', isSymmetricMatrix);
    safelyAdd('Skew Symmetric Matrix', isSkewSymmetricMatrix);
    safelyAdd('Orthogonal Matrix', isOrthogonalMatrix);
    safelyAdd('Singular Matrix', isSingularMatrix);
    safelyAdd('Non-Singular Matrix', isNonSingularMatrix);
    safelyAdd('Toeplitz Matrix', isToeplitzMatrix);
    safelyAdd('Hankel Matrix', isHankelMatrix);
    safelyAdd('Circulant Matrix', isCirculantMatrix);
    safelyAdd('Vandermonde Matrix', isVandermondeMatrix);
    safelyAdd('Permutation Matrix', isPermutationMatrix);
    safelyAdd('Nilpotent Matrix', isNilpotentMatrix);
    safelyAdd('Involutary Matrix', isInvolutaryMatrix);
    safelyAdd('Idempotent Matrix', isIdempotentMatrix);
    safelyAdd('Tridiagonal Matrix', isTridiagonal);
    safelyAdd('Hermitian Matrix', isHermitianMatrix);
    safelyAdd('Sparse Matrix', isSparseMatrix);
    safelyAdd('Periodic Matrix', () => isPeriodicMatrix(findSmallestPeriod()));
    safelyAdd('Positive Definite Matrix', isPositiveDefiniteMatrix);
    safelyAdd('Negative Definite Matrix', isNegativeDefiniteMatrix);
    safelyAdd('Derogatory Matrix', isDerogatoryMatrix);
    safelyAdd('Has Dominant Eigenvalue', hasDominantEigenvalue);
    safelyAdd('Diagonally Dominant Matrix', isDiagonallyDominantMatrix);
    safelyAdd('Strictly Diagonally Dominant Matrix',
        isStrictlyDiagonallyDominantMatrix);

    if (properties.isEmpty) properties.add('General Matrix');

    return properties;
  }

  /// Checks if two matrices are approximately equal within the given tolerance.
  ///
  /// [other]: The matrix to compare with.
  /// [tolerance]: The tolerance for the element-wise comparison.
  /// Returns true if the matrices are approximately equal within the given tolerance, false otherwise.
  ///
  /// Example:
  ///
  /// ```dart
  /// Matrix A = Matrix([
  /// [1.0, 2.00001],
  /// [3.0, 4.0]
  /// ]);
  /// Matrix B = Matrix([
  ///  [1.0, 2.0],
  ///  [3.0, 4.0]
  /// ]);
  /// print(A.isAlmostEqual(B, tolerance: 1e-5)); // Output: true
  /// print(A.isAlmostEqual(B, tolerance: 1e-6)); // Output: false
  ///```
  bool isAlmostEqual(Matrix other, {double tolerance = 1e-10}) {
    if (rowCount != other.rowCount || columnCount != other.columnCount) {
      return false;
    }

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (((this[i][j] as num) - (other[i][j] as num)).abs() > tolerance) {
          return false;
        }
      }
    }

    return true;
  }

  /// Checks if the matrix is a Unitary matrix.
  ///
  /// A square matrix is unitary if its conjugate transpose (also known as adjoint)
  /// is equal to its inverse. In other words, for a matrix A, if A * A.conjugateTranspose()
  /// equals the identity matrix, then A is unitary.
  bool isUnitaryMatrix({double tolerance = 1e-12}) {
    if (!isSquareMatrix()) {
      return false;
    }

    Matrix conjugateTranspose = this.conjugateTranspose();
    Matrix product = this * conjugateTranspose;

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (i == j) {
          if ((product[i][j] - 1 as num).abs() > tolerance) {
            return false;
          }
        } else {
          if (product[i][j].abs() > tolerance) {
            return false;
          }
        }
      }
    }
    return true;
  }

  /// Checks if the matrix is a Bidiagonal matrix.
  ///
  /// A matrix is bidiagonal if all its elements are zero except for the elements
  /// on its main diagonal and the first superdiagonal (the diagonal just above the main diagonal).
  bool isBidiagonalMatrix({double tolerance = 1e-12}) {
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (i != j && i != j - 1) {
          if (_data[i][j].abs() > tolerance) {
            return false;
          }
        }
      }
    }
    return true;
  }

  /// Checks if the matrix is a Toeplitz matrix.
  ///
  /// A Toeplitz matrix is a matrix in which each descending diagonal
  /// from left to right is constant.
  ///
  /// [tolerance] is the numerical tolerance used to compare the elements.
  /// Default value for [tolerance] is 1e-10.
  ///
  /// Returns `true` if the matrix is tridiagonal, `false` otherwise.
  bool isToeplitzMatrix({double tolerance = 1e-10}) {
    for (int i = 0; i < rowCount - 1; i++) {
      for (int j = 0; j < columnCount - 1; j++) {
        if ((_data[i][j] - _data[i + 1][j + 1]).abs() > tolerance) {
          return false;
        }
      }
    }
    return true;
  }

  /// Checks if the matrix is a Hankel matrix.
  ///
  /// A Hankel matrix is a matrix in which each ascending diagonal
  /// from left to right is constant.
  ///
  /// [tolerance] is the numerical tolerance used to compare the elements.
  /// Default value for [tolerance] is 1e-10.
  ///
  /// Returns `true` if the matrix is tridiagonal, `false` otherwise.
  bool isHankelMatrix({double tolerance = 1e-10}) {
    for (int i = 0; i < rowCount - 1; i++) {
      for (int j = 0; j < columnCount - 1; j++) {
        if ((_data[i + 1][j] - _data[i][j + 1]).abs() > tolerance) {
          return false;
        }
      }
    }
    return true;
  }

  /// Checks if the matrix is a Circulant matrix.
  ///
  /// A Circulant matrix is a special kind of Toeplitz matrix where
  /// the diagonals "wrap around" such that the first row is a cyclic
  /// shift of the row above it.
  ///
  /// [tolerance] is the numerical tolerance used to compare the elements.
  /// Default value for [tolerance] is 1e-10.
  ///
  /// Returns `true` if the matrix is tridiagonal, `false` otherwise.
  bool isCirculantMatrix({double tolerance = 1e-10}) {
    if (!isSquareMatrix()) return false;

    for (int i = 0; i < rowCount - 1; i++) {
      for (int j = 0; j < columnCount - 1; j++) {
        if ((_data[i][j] - _data[i + 1][(j + 1) % columnCount]).abs() >
            tolerance) {
          return false;
        }
      }
    }
    return true;
  }

  /// Checks if the matrix is a Vandermonde matrix.
  ///
  /// A Vandermonde matrix has the terms of a geometric progression
  /// in each row, often used in polynomial interpolation problems.
  ///
  /// [tolerance] is the numerical tolerance used to compare the elements.
  /// Default value for [tolerance] is 1e-10.
  ///
  /// Returns `true` if the matrix is tridiagonal, `false` otherwise.
  bool isVandermondeMatrix({double tolerance = 1e-10}) {
    for (int i = 0; i < rowCount - 1; i++) {
      double ratio = _data[i + 1][0] / _data[i][0];
      for (int j = 1; j < columnCount; j++) {
        double currentRatio = _data[i + 1][j] / _data[i][j];
        if ((currentRatio - ratio).abs() > tolerance) {
          return false;
        }
      }
    }
    return true;
  }

  /// Checks if the matrix is a Permutation matrix.
  ///
  /// A Permutation matrix is a square matrix obtained by permuting
  /// the rows of an identity matrix, with exactly one '1' in each row
  /// and column, and all other elements being '0'.
  ///
  /// [tolerance] is the numerical tolerance used to compare the elements.
  /// Default value for [tolerance] is 1e-10.
  ///
  /// Returns `true` if the matrix is tridiagonal, `false` otherwise.
  bool isPermutationMatrix({double tolerance = 1e-10}) {
    if (!isSquareMatrix()) return false;

    for (int i = 0; i < rowCount; i++) {
      int onesCount = 0;
      for (int j = 0; j < columnCount; j++) {
        if (_data[i][j].abs() < tolerance) continue;
        if ((_data[i][j] - 1.0).abs() < tolerance) {
          onesCount++;
        } else {
          return false;
        }
      }
      if (onesCount != 1) return false;
    }

    for (int j = 0; j < columnCount; j++) {
      int onesCount = 0;
      for (int i = 0; i < rowCount; i++) {
        if (_data[i][j].abs() < tolerance) continue;
        if ((_data[i][j] - 1.0).abs() < tolerance) {
          onesCount++;
        } else {
          return false;
        }
      }
      if (onesCount != 1) return false;
    }

    return true;
  }

  /// Checks if the matrix is Hermitian (equal to its conjugate transpose).
  /// Returns true if the matrix is Hermitian, false otherwise.
  ///
  /// Parameters:
  /// - `tolerance` (optional, default = 1e-10): The tolerance used to check for equality of elements.
  bool isHermitianMatrix({double tolerance = 1e-10}) {
    if (!isSquareMatrix()) {
      return false;
    }

    int n = rowCount;
    for (int i = 0; i < n; i++) {
      for (int j = i; j < n; j++) {
        Complex conjugateValue;
        if (this[j][i] is Complex) {
          conjugateValue = (this[j][i] as Complex).conjugate();
        } else {
          conjugateValue = this[j][i];
        }

        if ((this[i][j] - conjugateValue).abs() > tolerance) {
          return false;
        }
      }
    }

    return true;
  }

  /// Checks if the matrix is sparse.
  /// Returns true if the matrix is sparse, false otherwise.
  ///
  /// Parameters:
  /// - `threshold` (optional, default = 0.5): The proportion of non-zero elements required to classify a matrix as sparse.
  bool isSparseMatrix({double threshold = 0.5}) {
    int nonZeroElements = 0;
    int totalElements = rowCount * columnCount;

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (this[i][j] != 0) {
          nonZeroElements++;
        }
      }
    }

    return (nonZeroElements / totalElements) < threshold;
  }

  /// Checks if the matrix has a dominant eigenvalue.
  /// Returns true if the matrix has a dominant eigenvalue, false otherwise.
  ///
  /// Parameters:
  /// - `tolerance` (optional, default = 1e-10): The tolerance used to check for the dominance of the eigenvalue.
  bool hasDominantEigenvalue({double tolerance = 1e-10}) {
    var eigen = this.eigen();
    List<double> eigenvalues = eigen.values;

    double maxEigenvalue =
        eigenvalues.reduce((a, b) => a.abs() > b.abs() ? a : b);
    double sumEigenvalues =
        eigenvalues.map((e) => e.abs()).reduce((a, b) => a + b);

    return (maxEigenvalue.abs() - (sumEigenvalues - maxEigenvalue.abs())) >
        tolerance;
  }

  /// Checks if the matrix is a Tridiagonal matrix.
  ///
  /// A matrix is tridiagonal if all its elements are zero except for the elements
  /// on its main diagonal, the first subdiagonal (the diagonal just below the main diagonal),
  /// and the first superdiagonal (the diagonal just above the main diagonal).
  ///
  /// [tolerance] is the numerical tolerance used to compare the elements.
  /// Default value for [tolerance] is 1e-10.
  ///
  /// Returns `true` if the matrix is tridiagonal, `false` otherwise.
  bool isTridiagonal({double tolerance = 1e-10}) {
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (i < j - 1 || i > j + 1) {
          if ((this[i][j]).abs() > tolerance) {
            return false;
          }
        }
      }
    }
    return true;
  }

  /// Checks if the current matrix is a submatrix of [parent].
  ///
  /// [parent]: The matrix in which to search for the current matrix.
  ///
  /// Returns `true` if the current matrix is a submatrix of [parent], otherwise `false`.
  ///
  /// Example:
  /// ```dart
  /// var parentMatrix = Matrix([[1, 2, 3], [4, 5, 6], [7, 8, 9]]);
  /// var subMatrix = Matrix([[5, 6], [8, 9]]);
  /// var result = subMatrix.isSubMatrix(parentMatrix);
  /// print(result); // Output: true
  /// ```
  bool isSubMatrix(Matrix parent) {
    for (int i = 0; i <= parent.rowCount - rowCount; i++) {
      for (int j = 0; j <= parent.columnCount - columnCount; j++) {
        bool found = true;
        for (int k = 0; k < rowCount && found; k++) {
          for (int l = 0; l < columnCount && found; l++) {
            if (parent[i + k][j + l] != this[k][l]) {
              found = false;
            }
          }
        }
        if (found) {
          return true;
        }
      }
    }
    return false;
  }

  /// Checks if the matrix has full rank.
  ///
  /// A matrix has full rank if its rank is equal to the smaller of its row and column dimensions.
  /// This means that all rows or columns are linearly independent.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9]
  /// ]);
  /// print(A.isFullRank()); // Output: false
  /// ```
  ///
  bool isFullRank() {
    int minDimension = math.min(rowCount, columnCount);
    int rank = this.rank();
    return rank == minDimension;
  }

  /// Checks if the matrix is upper triangular within the given tolerance.
  ///
  /// [tolerance] is the tolerance for checking if the matrix is upper triangular.
  ///
  /// Returns true if the matrix is upper triangular within the given tolerance, false otherwise.
  bool isUpperTriangular([double tolerance = 1e-10]) {
    for (int i = 1; i < rowCount; i++) {
      for (int j = 0; j < i; j++) {
        if (this[i][j].abs() > tolerance) {
          return false;
        }
      }
    }
    return true;
  }

  // Checks if the matrix is lower triangular within the given tolerance.
  //
  // [tolerance] is the tolerance for checking if the matrix is lower triangular.
  //
  // Returns true if the matrix is lower triangular within the given tolerance, false otherwise.
  bool isLowerTriangular([double tolerance = 1e-10]) {
    for (int i = 0; i < rowCount - 1; i++) {
      for (int j = i + 1; j < columnCount; j++) {
        if (this[i][j].abs() > tolerance) {
          return false;
        }
      }
    }
    return true;
  }

  /// Check if the matrix is a row matrix (1 row, n columns).
  ///
  /// Example:
  /// ```dart
  ///   Matrix A = Matrix([
  ///     [1, 2, 3]
  ///   ]);
  ///   print(A.isRowMatrix()); // Output: true
  /// ```
  bool isRowMatrix() {
    return rowCount == 1;
  }

  /// Check if the matrix is a column matrix (n rows, 1 column).
  ///
  /// Example:
  /// ```dart
  ///   Matrix A = Matrix([
  ///     [1],
  ///     [2],
  ///     [3]
  ///   ]);
  ///   print(A.isColumnMatrix()); // Output: true
  /// ```
  bool isColumnMatrix() {
    return columnCount == 1;
  }

  /// Check if the matrix is a square matrix (n rows, n columns).
  ///
  /// Example:
  /// ```dart
  ///   Matrix A = Matrix([
  ///     [1, 2],
  ///     [3, 4]
  ///   ]);
  ///   print(A.isSquareMatrix()); // Output: true
  /// ```
  bool isSquareMatrix() {
    return rowCount == columnCount;
  }

  /// Check if the matrix is a horizontal matrix (rows < columns).
  ///
  /// Example:
  /// ```dart
  ///   Matrix A = Matrix([
  ///     [1, 2, 3]
  ///   ]);
  ///   print(A.isHorizontalMatrix()); // Output: true
  /// ```
  bool isHorizontalMatrix() {
    return rowCount < columnCount;
  }

  /// Check if the matrix is a vertical matrix (rows > columns).
  ///
  /// Example:
  /// ```dart
  ///   Matrix A = Matrix([
  ///     [1],
  ///     [2],
  ///     [3]
  ///   ]);
  ///   print(A.isVerticalMatrix()); // Output: true
  /// ```
  bool isVerticalMatrix() {
    return rowCount > columnCount;
  }

  /// Check if the matrix is a diagonal matrix.
  ///
  /// Example:
  /// ```dart
  ///   Matrix A = Matrix([
  ///     [1, 0, 0],
  ///     [0, 2, 0],
  ///     [0, 0, 3]
  ///   ]);
  ///   print(A.isDiagonalMatrix()); // Output: true
  /// ```
  bool isDiagonalMatrix({double tolerance = 1e-10}) {
    if (!isSquareMatrix()) return false;

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (i != j && this[i][j].abs() > tolerance) return false;
      }
    }
    return true;
  }

  /// Check if the matrix is an identity matrix.
  ///
  /// Example:
  /// ```dart
  ///   Matrix A = Matrix([
  ///     [1, 0, 0],
  ///     [0, 1, 0],
  ///     [0, 0, 1]
  ///   ]);
  ///   print(A.isIdentityMatrix()); // Output: true
  /// ```
  bool isIdentityMatrix({double tolerance = 1e-10}) {
    if (!isSquareMatrix()) return false;

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        double expectedValue = (i == j) ? 1.0 : 0.0;
        if ((this[i][j] - expectedValue).abs() > tolerance) return false;
      }
    }
    return true;
  }

  /// Check if the matrix is a scalar matrix.
  ///
  /// Example:
  /// ```dart
  ///   Matrix A = Matrix([
  ///     [2, 0, 0],
  ///     [0, 2, 0],
  ///     [0, 0, 2]
  ///   ]);
  ///   print(A.isScalarMatrix()); // Output: true
  /// ```
  bool isScalarMatrix({double tolerance = 1e-10}) {
    if (!isDiagonalMatrix(tolerance: tolerance)) return false;

    double scalarValue = this[0][0];
    for (int i = 1; i < rowCount; i++) {
      if ((this[i][i] - scalarValue).abs() > tolerance) return false;
    }
    return true;
  }

  /// Check if the matrix is a null matrix (all elements are zero).
  /// Example:
  /// ```dart
  ///   Matrix A = Matrix([
  ///     [0, 0],
  ///     [0, 0]
  ///   ]);
  ///   print(A.isNullMatrix()); // Output: true
  /// ```
  bool isNullMatrix({double tolerance = 1e-10}) {
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (this[i][j].abs() > tolerance) return false;
      }
    }
    return true;
  }

  /// Checks if the matrix is a zero matrix.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix([
  ///   [0, 0],
  ///   [0, 0]
  /// ]);
  /// print(A.isZeroMatrix()); // Output: true
  /// ```
  bool isZeroMatrix({double tolerance = 1e-10}) {
    return every((row) => row.every((element) => element.abs() <= tolerance));
  }

  /// Checks if the matrix is an orthogonal matrix.
  ///
  /// Example:
  /// ```dart
  /// Matrix B = Matrix([
  ///   [1, 0],
  ///   [0, -1]
  /// ]);
  /// print(B.isOrthogonalMatrix()); // Output: true
  /// ```
  bool isOrthogonalMatrix({double tolerance = 1e-10}) {
    if (rowCount != columnCount) return false;
    Matrix product = this * transpose();
    return product.isIdentityMatrix(tolerance: tolerance);
  }

  /// Checks if the matrix is a singular matrix.
  ///
  /// Example:
  /// ```dart
  /// Matrix C = Matrix([
  ///   [1, 2],
  ///   [2, 4]
  /// ]);
  /// print(C.isSingularMatrix()); // Output: true
  /// ```
  bool isSingularMatrix() {
    return determinant() == 0;
  }

  /// Checks if the matrix is a NonSingularMatrix matrix.
  ///
  /// Example:
  /// ```dart
  /// Matrix D = Matrix([
  ///   [2, 1],
  ///   [1, 2]
  /// ]);
  /// print(D.isNonSingularMatrix()); // Output: true
  /// ```
  bool isNonSingularMatrix() {
    return !isSingularMatrix();
  }

  /// Checks if the matrix is a symmetric matrix.
  ///
  /// Example:
  /// ```dart
  /// Matrix E = Matrix([
  ///   [1, 2, 3],
  ///   [2, 3, 4],
  ///   [3, 4, 5]
  /// ]);
  /// print(E.isSymmetricMatrix()); // Output: true
  /// ```
  bool isSymmetricMatrix({double tolerance = 1e-10}) {
    if (rowCount != columnCount) return false;
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < i; j++) {
        if ((this[i][j] - this[j][i]).abs() > tolerance) {
          return false;
        }
      }
    }
    return true;
  }

  /// Checks if the matrix is a skew symmetric matrix.
  ///
  /// Example:
  /// ```dart
  /// Matrix F = Matrix([
  ///   [0, -1],
  ///   [1, 0]
  /// ]);
  /// print(F.isSkewSymmetricMatrix()); // Output: true
  /// ```
  bool isSkewSymmetricMatrix({double tolerance = 1e-10}) {
    if (rowCount != columnCount) return false;
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < i; j++) {
        if ((this[i][j] + this[j][i]).abs() > tolerance) {
          return false;
        }
      }
    }
    return true;
  }

  /// Checks if the matrix is a nilpotent matrix.
  ///
  /// Example:
  /// ```dart
  /// Matrix G = Matrix([
  ///   [0, 1, 2],
  ///   [-1, 0, 1],
  ///   [-2, -1, 0]
  /// ]);
  /// print(G.isNilpotentMatrix()); // Output: true
  /// ```
  bool isNilpotentMatrix({int maxIterations = 100}) {
    Matrix product = copy();
    for (int i = 1; i < maxIterations; i++) {
      product = product * this;
      if (product.isZeroMatrix()) {
        return true;
      }
    }
    return false;
  }

  /// Checks if the matrix is an involutory matrix.
  ///
  /// Example:
  /// ```dart
  /// Matrix H = Matrix([
  ///   [0, 1],
  ///   [1, 0]
  /// ]);
  /// print(H.isInvolutaryMatrix()); // Output: true
  /// ```
  bool isInvolutaryMatrix({double tolerance = 1e-10}) {
    Matrix product = this * this;
    return product.isIdentityMatrix(tolerance: tolerance);
  }

  /// Checks if the matrix is an idempotent matrix.
  ///
  /// Example:
  /// ```dart
  /// Matrix I = Matrix([
  ///   [1, 0],
  ///   [0, 0]
  /// ]);
  /// print(I.isIdempotentMatrix()); // Output: true
  ///```
  bool isIdempotentMatrix({double tolerance = 1e-10}) {
    Matrix product = this * this;
    return isAlmostEqual(product, tolerance: tolerance);
  }

  /// Checks if the matrix is a periodic matrix.
  ///
  /// Example:
  /// ```dart
  /// Matrix J = Matrix([
  ///   [0, 1],
  ///   [-1, 0]
  /// ]);
  /// print(J.isPeriodicMatrix()); // Output: true
  ///```
  bool isPeriodicMatrix(int period, {double tolerance = 1e-10}) {
    Matrix product = copy();
    for (int i = 1; i <= period; i++) {
      product = product * this;
      if (product.isIdentityMatrix(tolerance: tolerance)) {
        return true;
      }
    }
    return false;
  }

  /// Finds the smallest period of the matrix.
  ///
  /// This function checks if the matrix is periodic for periods from 1 to [maxPeriod].
  /// If it finds a period for which the matrix is periodic, it returns that period.
  /// If no periodicity is found within the [maxPeriod], it returns -1.
  ///
  /// The optional parameter [tolerance] specifies the tolerance used for checking if the matrix
  /// is periodic. The default value is 1e-10.
  ///
  /// The optional parameter [maxPeriod] specifies the maximum period to check for periodicity.
  /// The default value is 100.
  ///
  /// Example:
  /// ```dart
  /// Matrix J = Matrix([
  ///   [0, 1],
  ///   [-1, 0]
  /// ]);
  /// print(J.findSmallestPeriod(maxPeriod: 10)); // Output: 4
  /// ```
  ///
  int findSmallestPeriod({double tolerance = 1e-10, int maxPeriod = 100}) {
    for (int period = 1; period <= maxPeriod; period++) {
      if (isPeriodicMatrix(period, tolerance: tolerance)) {
        return period;
      }
    }
    return -1; // Returns -1 if no periodicity is found within the maxPeriod
  }

  /// Checks if the matrix is a positive definite matrix.
  ///
  /// Example:
  /// ```dart
  /// Matrix K = Matrix([
  ///   [2, 1],
  ///   [1, 2]
  /// ]);
  /// print(K.isPositiveDefiniteMatrix()); // Output: true
  ///```
  bool isPositiveDefiniteMatrix() {
    return isSymmetricMatrix() &&
        eigenvalues().every((eigenvalue) => eigenvalue > 0);
  }

  /// Checks if the matrix is a negative definite matrix.
  ///
  /// Example:
  /// ```dart
  /// Matrix L = Matrix([
  /// [-2, 1],
  /// [1, -2]
  /// ]);
  /// print(L.isNegativeDefiniteMatrix()); // Output: true
  /// ```
  bool isNegativeDefiniteMatrix() {
    return isSymmetricMatrix() &&
        eigenvalues().every((eigenvalue) => eigenvalue < 0);
  }

  /// Checks if the matrix is a derogatory matrix.
  ///
  /// Example:
  /// ```dart
  /// Matrix M = Matrix([
  ///   [2, 1],
  ///   [1, 2]
  /// ]);
  /// print(M.isDerogatoryMatrix()); // Output: false
  /// ```
  bool isDerogatoryMatrix() {
    List<double> eigenvalues = this.eigenvalues();
    Map<double, int> eigenvalueCounts = {};

    for (double eigenvalue in eigenvalues) {
      eigenvalueCounts[eigenvalue] = (eigenvalueCounts[eigenvalue] ?? 0) + 1;
    }

    for (double eigenvalue in eigenvalueCounts.keys) {
      if (eigenvalueCounts[eigenvalue]! > 1) {
        return true;
      }
    }
    return false;
  }

  /// Checks if the matrix is a diagonally dominant matrix.
  ///
  /// Example:
  /// ```dart
  /// Matrix N = Matrix([
  ///   [4, 1, 1],
  ///   [1, 4, 1],
  ///   [1, 1, 4]
  /// ]);
  /// print(N.isDiagonallyDominantMatrix()); // Output: true
  /// ```
  bool isDiagonallyDominantMatrix() {
    for (int i = 0; i < rowCount; i++) {
      double rowSum = 0;
      for (int j = 0; j < columnCount; j++) {
        if (i != j) {
          rowSum += this[i][j].abs();
        }
      }
      if (this[i][i].abs() < rowSum) {
        return false;
      }
    }
    return true;
  }

  /// Checks if the matrix is a strictly diagonally dominant matrix.
  ///
  /// Example:
  /// ```dart
  /// Matrix O = Matrix([
  ///   [5, 1, 1],
  ///   [1, 5, 1],
  ///   [1, 1, 5]
  /// ]);
  /// print(O.isStrictlyDiagonallyDominantMatrix()); // Output: true
  /// ```
  bool isStrictlyDiagonallyDominantMatrix() {
    for (int i = 0; i < rowCount; i++) {
      double rowSum = 0;
      for (int j = 0; j < columnCount; j++) {
        if (i != j) {
          rowSum += this[i][j].abs();
        }
      }
      if (this[i][i].abs() <= rowSum) {
        return false;
      }
    }
    return true;
  }
}
