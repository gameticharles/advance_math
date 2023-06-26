part of algebra;

/*
Linear Algebra Utilities:
   - Linear least squares
   - Linear programming solver
   - Quadratic programming solver
 */

class LinearSystemSolvers {
  final Matrix _matrix;
  LinearSystemSolvers(this._matrix);

  /// Solves a linear system Ax = b using Cramer's Rule.
  ///
  /// [a] The matrix A of the linear system Ax = b.
  /// [b] The matrix b of the linear system Ax = b.
  ///
  /// Returns the solution matrix x.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix([
  ///   [4, 1, -1],
  ///   [1, 4, -1],
  ///   [-1, -1, 4]
  /// ]);
  /// Matrix b = Matrix([
  ///   [6],
  ///   [25],
  ///   [14]
  /// ]);
  ///
  /// Matrix result = LinearSystemSolvers.cramersRule(A, b);
  /// print(result.round());
  /// // Output:
  /// // Matrix: 3x1
  /// // ┌ 1 ┐
  /// // │ 7 │
  /// // └ 6 ┘
  /// ```
  static Matrix cramersRule(Matrix a, Matrix b) {
    if (a.rowCount != a.columnCount) {
      throw Exception("Matrix A must be a square matrix for Cramer's Rule.");
    }
    int n = a.rowCount;
    num determinantA = a.determinant();
    if (determinantA == 0) {
      throw Exception(
          "The determinant of A is zero. Cramer's rule is not applicable.");
    }

    Matrix x = Matrix.zeros(n, 1, isDouble: true);
    Matrix ai = Matrix.zeros(n, a.columnCount, isDouble: true);
    for (int i = 0; i < n; i++) {
      ai.copyFrom(a);
      ai.setColumn(i, b.flatten());
      num determinantAi = ai.determinant();
      x[i][0] = determinantAi / determinantA;
    }

    return x;
  }

  /// Solves a linear equation system Ax = b with Ridge Regression (L2 regularization).
  ///
  /// Ridge Regression is used when the matrix A is ill-conditioned or close to singular.
  /// It adds a regularization term alpha * I to the matrix A^T * A, where I is the identity matrix.
  ///
  /// [b] is the right-hand side matrix in the equation Ax = b.
  /// [alpha] is the regularization parameter. It must be a non-negative scalar value.
  ///
  /// Returns the solution matrix x.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [1, 2, 4],
  ///   [4, 8, 20],
  ///   [3, 6, 7]
  /// ]);
  /// Matrix b = Matrix.fromList([
  ///   [15],
  ///   [68],
  ///   [27]
  /// ]);
  /// double alpha = 0.01;
  ///
  /// Matrix x = A.ridgeRegression(b, alpha);
  /// x.prettyPrint();
  /// ```
  static Matrix ridgeRegression(Matrix a, Matrix b, double alpha) {
    Matrix A = _Utils.toDoubleMatrix(a);
    int n = A.columnCount;
    Matrix I = Matrix.eye(n, isDouble: true);
    Matrix aTrans = A.transpose();
    Matrix atAplusAlphai = (aTrans * A) + I.scale(alpha);
    Matrix atAplusAlphaIInv = atAplusAlphai.inverse();
    Matrix x = atAplusAlphaIInv * aTrans * b;
    return x;
  }

  /// Solves a linear system Ax = b using Montante's Method (Bareiss Algorithm).
  ///
  /// [a] The matrix A of the linear system Ax = b.
  /// [b] The matrix b of the linear system Ax = b.
  ///
  /// Returns the solution matrix x.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix([
  ///   [4, 1, -1],
  ///   [1, 4, -1],
  ///   [-1, -1, 4]
  /// ]);
  /// Matrix b = Matrix([
  ///   [6],
  ///   [25],
  ///   [14]
  /// ]);
  ///
  /// Matrix result = LinearSystemSolvers.bareissAlgorithm(A, b);
  /// print(result.round());
  /// // Output:
  /// // Matrix: 3x1
  /// // ┌ 1 ┐
  /// // │ 7 │
  /// // └ 6 ┘
  /// ```
  static Matrix bareissAlgorithm(Matrix a, Matrix b) {
    int n = a.rowCount;

    // Augment the matrix A with matrix b
    Matrix ab = a.appendColumns(b);

    for (int k = 0; k < n; k++) {
      for (int i = k + 1; i < n; i++) {
        for (int j = k + 1; j < n + 1; j++) {
          ab[i][j] = ((ab[k][k] * ab[i][j]) - (ab[i][k] * ab[k][j])) /
              (k == 0 ? 1 : ab[k - 1][k - 1]);
        }
      }
    }

    // Extract the solution from the upper triangular augmented matrix
    Matrix x = Matrix.zeros(n, 1);
    for (int i = n - 1; i >= 0; i--) {
      x[i][0] = ab[i][n] / ab[i][i];
      for (int j = i - 1; j >= 0; j--) {
        ab[j][n] -= ab[j][i] * x[i][0];
      }
    }

    return x;
  }

  /// Solves a linear system Ax = b using the inverse matrix method.
  ///
  /// [a] The matrix A of the linear system Ax = b.
  /// [b] The matrix b of the linear system Ax = b.
  /// Returns the solution matrix x.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix([
  ///   [4, 1, -1],
  ///   [1, 4, -1],
  ///   [-1, -1, 4]
  /// ]);
  /// Matrix b = Matrix([
  ///   [6],
  ///   [25],
  ///   [14]
  /// ]);
  ///
  /// Matrix result = LinearSystemSolvers.inverseMatrix(A, b);
  /// print(result.round());
  /// // Output:
  /// // Matrix: 3x1
  /// // ┌ 1 ┐
  /// // │ 7 │
  /// // └ 6 ┘
  /// ```
  static Matrix inverseMatrix(Matrix a, Matrix b) {
    Matrix invA = a.inverse();
    return invA * b;
  }

  /// Solves a linear system Ax = b using Gauss Elimination.
  ///
  /// [a] The matrix A of the linear system Ax = b.
  /// [b] The matrix b of the linear system Ax = b.
  /// Returns the solution matrix x.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix([
  ///   [4, 1, -1],
  ///   [1, 4, -1],
  ///   [-1, -1, 4]
  /// ]);
  /// Matrix b = Matrix([
  ///   [6],
  ///   [25],
  ///   [14]
  /// ]);
  ///
  /// Matrix result = LinearSystemSolvers.gaussElimination(A, b);
  /// print(result.round());
  /// // Output:
  /// // Matrix: 3x1
  /// // ┌ 1 ┐
  /// // │ 7 │
  /// // └ 6 ┘
  /// ```
  static Matrix gaussElimination(Matrix a, Matrix b) {
    Matrix fe = _Utils.forwardElimination(a, b);
    return _Utils.backwardSubstitution(fe, b);
  }

  /// Solves a linear system Ax = b using Gauss-Jordan Elimination.
  ///
  /// [a] The matrix A of the linear system Ax = b.
  /// [b] The matrix b of the linear system Ax = b.
  /// Returns the solution matrix x.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix([
  ///   [4, 1, -1],
  ///   [1, 4, -1],
  ///   [-1, -1, 4]
  /// ]);
  /// Matrix b = Matrix([
  ///   [6],
  ///   [25],
  ///   [14]
  /// ]);
  ///
  /// Matrix result = LinearSystemSolvers.gaussJordanElimination(A, b);
  /// print(result.round());
  /// // Output:
  /// // Matrix: 3x1
  /// // ┌ 1 ┐
  /// // │ 7 │
  /// // └ 6 ┘
  /// ```
  static Matrix gaussJordanElimination(Matrix a, Matrix b) {
    int rowCount = a.rowCount;
    Matrix augmentedMatrix = a;
    augmentedMatrix.appendColumns(b);

    for (int i = 0; i < rowCount; i++) {
      int pivotIndex = i;

      // Find the largest pivot
      for (int j = i + 1; j < rowCount; j++) {
        if (augmentedMatrix[j][i].abs() >
            augmentedMatrix[pivotIndex][i].abs()) {
          pivotIndex = j;
        }
      }

      // Swap rows
      if (pivotIndex != i) {
        augmentedMatrix.swapRows(i, pivotIndex);
      }

      // Perform row reduction
      for (int j = 0; j < rowCount; j++) {
        if (j != i) {
          double factor = augmentedMatrix[j][i] / augmentedMatrix[i][i];
          for (int k = i; k < augmentedMatrix.columnCount; k++) {
            augmentedMatrix[j][k] -= factor * augmentedMatrix[i][k];
          }
        }
      }

      // Normalize the pivot row
      num pivot = augmentedMatrix[i][i];
      for (int k = i; k < augmentedMatrix.columnCount; k++) {
        augmentedMatrix[i][k] /= pivot;
      }
    }

    return augmentedMatrix.slice(
        0, rowCount, rowCount, augmentedMatrix.columnCount);
  }

  /// Solves a linear system Ax = b using the least squares method.
  ///
  /// [a] The matrix A of the linear system Ax = b.
  /// [b] The matrix b of the linear system Ax = b.
  /// Returns the solution matrix x.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix([
  ///   [4, 1, -1],
  ///   [1, 4, -1],
  ///   [-1, -1, 4]
  /// ]);
  /// Matrix b = Matrix([
  ///   [6],
  ///   [25],
  ///   [14]
  /// ]);
  ///
  /// Matrix result = LinearSystemSolvers.leastSquares(A, b);
  /// print(result.round());
  /// // Output:
  /// // Matrix: 3x1
  /// // ┌ 1 ┐
  /// // │ 7 │
  /// // └ 6 ┘
  /// ```
  static Matrix leastSquares(Matrix a, Matrix b) {
    Matrix ata = a.transpose() * a;
    Matrix atb = a.transpose() * b;
    return gaussElimination(ata, atb);
  }

  /// Solves a linear system Ax = b using the Gram-Schmidt orthogonalization method.
  ///
  /// [a] The matrix A of the linear system Ax = b.
  /// [b] The matrix b of the linear system Ax = b.
  /// Returns the solution matrix x.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix([
  ///   [4, 1, -1],
  ///   [1, 4, -1],
  ///   [-1, -1, 4]
  /// ]);
  /// Matrix b = Matrix([
  ///   [6],
  ///   [25],
  ///   [14]
  /// ]);
  ///
  /// Matrix result = LinearSystemSolvers.gramSchmidt(A, b);
  /// print(result.round());
  /// // Output:
  /// // Matrix: 3x1
  /// // ┌ 1 ┐
  /// // │ 7 │
  /// // └ 6 ┘
  /// ```
  static Matrix gramSchmidt(Matrix a, Matrix b) {
    // Compute the orthogonal matrix Q using Gram-Schmidt process
    Matrix q = a.linear.orthogonalize();

    // Compute the upper triangular matrix R
    Matrix r = q.transpose() * a;

    // Compute the new right-hand side matrix c
    Matrix c = q.transpose() * b;

    // Solve the system Rx = c using backward substitution
    return _Utils.backwardSubstitution(r, c);
  }

  /// Solves a linear system Ax = b using the Jacobi method.
  ///
  /// [a] The matrix A of the linear system Ax = b.
  /// [b] The matrix b of the linear system Ax = b.
  /// [maxIterations] The maximum number of iterations allowed (default is 1000).
  /// [tolerance] The tolerance for the convergence criterion (default is 1e-10).
  /// Returns the solution matrix x.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix([
  ///   [4, 1, -1],
  ///   [1, 4, -1],
  ///   [-1, -1, 4]
  /// ]);
  /// Matrix b = Matrix([
  ///   [6],
  ///   [25],
  ///   [14]
  /// ]);
  ///
  /// Matrix result = LinearSystemSolvers.jacobi(A, b);
  /// print(result.round());
  /// // Output:
  /// // Matrix: 3x1
  /// // ┌ 1 ┐
  /// // │ 7 │
  /// // └ 6 ┘
  /// ```
  static Matrix jacobi(Matrix a, Matrix b,
      {int maxIterations = 1000, double tolerance = 1e-10}) {
    int n = a.rowCount;
    Matrix x = Matrix.zeros(n, 1);
    Matrix xNew = Matrix.zeros(n, 1);

    for (int iteration = 0; iteration < maxIterations; iteration++) {
      for (int i = 0; i < n; i++) {
        double sum = 0;
        for (int j = 0; j < n; j++) {
          if (i != j) {
            sum += a[i][j] * x[j][0];
          }
        }
        xNew[i][0] = (b[i][0] - sum) / a[i][i];
      }

      if ((xNew - x).norm(Norm.manhattan) / xNew.norm(Norm.manhattan) <
          tolerance) {
        return xNew;
      }

      x = xNew.copy();
    }

    return x;
  }

  /// Solves a linear system Ax = b using the Gauss-Seidel method.
  ///
  /// [a] The matrix A of the linear system Ax = b.
  /// [b] The matrix b of the linear system Ax = b.
  /// [maxIterations] The maximum number of iterations allowed (default is 1000).
  /// [tolerance] The tolerance for the convergence criterion (default is 1e-10).
  /// Returns the solution matrix x.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix([
  ///   [4, 1, -1],
  ///   [1, 4, -1],
  ///   [-1, -1, 4]
  /// ]);
  /// Matrix b = Matrix([
  ///   [6],
  ///   [25],
  ///   [14]
  /// ]);
  ///
  /// Matrix result = LinearSystemSolvers.gaussSeidel(A, b);
  /// print(result.round());
  /// // Output:
  /// // Matrix: 3x1
  /// // ┌ 1 ┐
  /// // │ 7 │
  /// // └ 6 ┘
  /// ```
  static Matrix gaussSeidel(Matrix a, Matrix b,
      {int maxIterations = 1000, double tolerance = 1e-10}) {
    int n = a.rowCount;
    Matrix x = Matrix.zeros(n, 1);

    for (int iteration = 0; iteration < maxIterations; iteration++) {
      Matrix xOld = x.copy();
      for (int i = 0; i < n; i++) {
        double sum1 = 0;
        for (int j = 0; j < i; j++) {
          sum1 += a[i][j] * x[j][0];
        }

        double sum2 = 0;
        for (int j = i + 1; j < n; j++) {
          sum2 += a[i][j] * x[j][0];
        }

        x[i][0] = (b[i][0] - sum1 - sum2) / a[i][i];
      }

      if ((x - xOld).norm(Norm.manhattan) / x.norm(Norm.manhattan) <
          tolerance) {
        return x;
      }
    }

    return x;
  }

  /// Solves a linear system Ax = b using the Successive Over-Relaxation (SOR) method.
  ///
  /// [a] The matrix A of the linear system Ax = b.
  /// [b] The matrix b of the linear system Ax = b.
  /// [omega] The relaxation factor (0 < omega < 2).
  /// [maxIterations] The maximum number of iterations allowed (default is 1000).
  /// [tolerance] The tolerance for the convergence criterion (default is 1e-10).
  ///
  /// Returns the solution matrix x.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix([
  ///   [4, 1, -1],
  ///   [1, 4, -1],
  ///   [-1, -1, 4]
  /// ]);
  /// Matrix b = Matrix([
  ///   [6],
  ///   [25],
  ///   [14]
  /// ]);
  ///
  /// Matrix result = LinearSystemSolvers.sor(A, b, 1);
  /// print(result.round());
  /// // Output:
  /// // Matrix: 3x1
  /// // ┌ 1 ┐
  /// // │ 7 │
  /// // └ 6 ┘
  /// ```
  static Matrix sor(Matrix a, Matrix b, double omega,
      {int maxIterations = 1000, double tolerance = 1e-10}) {
    int n = a.rowCount;
    Matrix x = Matrix.zeros(n, 1);

    for (int iteration = 0; iteration < maxIterations; iteration++) {
      Matrix xOld = x.copy();
      for (int i = 0; i < n; i++) {
        double sum1 = 0;
        for (int j = 0; j < i; j++) {
          sum1 += a[i][j] * x[j][0];
        }

        double sum2 = 0;
        for (int j = i + 1; j < n; j++) {
          sum2 += a[i][j] * x[j][0];
        }

        x[i][0] =
            (1 - omega) * x[i][0] + (omega / a[i][i]) * (b[i][0] - sum1 - sum2);
      }

      if ((x - xOld).norm(Norm.manhattan) / x.norm(Norm.manhattan) <
          tolerance) {
        return x;
      }
    }

    return x;
  }

  /// Solves a linear system Ax = b using the Conjugate Gradient method.
  ///
  /// [a] The matrix A of the linear system Ax = b.
  /// [b] The matrix b of the linear system Ax = b.
  /// [maxIterations] The maximum number of iterations allowed (default is 1000).
  /// [tolerance] The tolerance for the convergence criterion (default is 1e-10).
  ///
  /// Returns the solution matrix x.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix([
  ///   [4, 1, -1],
  ///   [1, 4, -1],
  ///   [-1, -1, 4]
  /// ]);
  /// Matrix b = Matrix([
  ///   [6],
  ///   [25],
  ///   [14]
  /// ]);
  ///
  /// Matrix result = LinearSystemSolvers.conjugateGradient(A, b);
  /// print(result.round());
  /// // Output:
  /// // Matrix: 3x1
  /// // ┌ 1 ┐
  /// // │ 7 │
  /// // └ 6 ┘
  /// ```
  static Matrix conjugateGradient(Matrix a, Matrix b,
      {int maxIterations = 1000, double tolerance = 1e-10}) {
    int n = a.rowCount;
    Matrix x = Matrix.zeros(n, 1);
    Matrix r = b - a * x;
    Matrix p = r.copy();
    double rsOld = (r.transpose() * r)[0][0];

    for (int iteration = 0; iteration < maxIterations; iteration++) {
      Matrix ap = a * p;
      var pap = (p.transpose() * ap)[0][0];
      double alpha = rsOld / pap;
      x = x + p * alpha;
      r = r - ap * alpha;

      double rsNew = (r.transpose() * r)[0][0];

      if (math.sqrt(rsNew) < tolerance) {
        return x;
      }

      p = r + p * (rsNew / rsOld);
      rsOld = rsNew;
    }

    return x;
  }

  /// Perform Gram-Schmidt orthogonalization on the matrix
  Matrix orthogonalize() {
    Matrix A = _matrix.copy();
    int m = A.rowCount;
    int n = A.columnCount;

    Matrix Q = Matrix.zeros(m, n);

    for (int j = 0; j < n; j++) {
      Vector v = Vector.fromList(_Utils.toSDList(A.column(j).asList));

      for (int i = 0; i < j; i++) {
        Vector qi = Vector.fromList(_Utils.toSDList(Q.column(i).asList));
        double projCoeff = v.dot(qi) / qi.dot(qi);
        v = v - qi.scale(projCoeff);
      }

      num normV = v.norm();
      if (normV > 1e-10) {
        v = v.scale(1 / normV);
        Q.setColumn(j, v.toList());
      } else {
        Q.setColumn(j, List.filled(m, 0.0));
      }
    }

    return Q;
  }

  /// LU decomposition Doolittle method.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix([
  ///   [4, 1, -1],
  ///   [1, 4, -1],
  ///   [-1, -1, 4]
  /// ]);
  /// Matrix b = Matrix([
  ///   [6],
  ///   [25],
  ///   [14]
  /// ]);
  ///
  /// Matrix result = LinearSystemSolvers.luDecompositionSolve(a, b);
  /// print(result.round());
  /// // Output:
  /// // Matrix: 3x1
  /// // ┌ 1 ┐
  /// // │ 7 │
  /// // └ 6 ┘
  /// ```
  static Matrix luDecompositionSolve(Matrix a, Matrix b) {
    a = _Utils.toDoubleMatrix(a);
    var lu = a.decomposition.luDecompositionDoolittle();
    Matrix l = lu.L;
    Matrix u = lu.U;

    // Solve Ly = b
    Matrix y = _Utils.forwardSubstitution(l, b);

    // Solve Ux = y
    Matrix x = _Utils.backwardSubstitution(u, y);

    return x;
  }

  /// Solves a linear system Ax = b using the specified [method].
  ///
  /// [b]: The right-hand side matrix.
  /// [method]: The method to use for solving the system. Options are 'lu' (LU decomposition, default) or 'gaussian' (Gaussian elimination).
  ///
  /// Returns a matrix x that satisfies Ax = b.
  ///
  /// Throws an exception if the current matrix is not square, if the row counts of the current matrix and [b] do not match, or if an invalid [method] is specified.
  ///
  /// Example:
  /// ```dart
  /// var matrixA = Matrix([[2, 1, 1], [1, 3, 2], [1, 0, 0]]);
  /// var matrixB = Matrix([[4], [5], [6]]);
  /// var result = matrixA.linear.solve(matrixB, method = LinearSystemMethod.gaussElimination);
  /// print(result);
  /// // Output:
  /// // 6.0
  /// // 15.0
  /// // -23.0
  /// ```
  Matrix solve(Matrix b,
      {LinearSystemMethod method = LinearSystemMethod.gaussElimination}) {
    var a = _Utils.toDoubleMatrix(_matrix);
    b = _Utils.toDoubleMatrix(b);

    switch (method) {
      case LinearSystemMethod.cramersRule:
        return cramersRule(a, b);
      case LinearSystemMethod.conjugateGradient:
        return conjugateGradient(a, b);
      case LinearSystemMethod.bareiss:
        return bareissAlgorithm(a, b);
      case LinearSystemMethod.jacobi:
        return jacobi(a, b);
      case LinearSystemMethod.sor:
        return sor(a, b, 1);
      case LinearSystemMethod.gaussSeidel:
        return gaussSeidel(a, b);
      case LinearSystemMethod.inverseMatrix:
        return inverseMatrix(a, b);
      case LinearSystemMethod.gaussElimination:
        return gaussElimination(a, b);
      case LinearSystemMethod.gaussJordanElimination:
        return gaussJordanElimination(a, b);
      case LinearSystemMethod.leastSquares:
        return leastSquares(a, b);
      case LinearSystemMethod.gramSchmidt:
        return gramSchmidt(a, b);
      case LinearSystemMethod.luDecomposition:
        return luDecompositionSolve(a, b);
      case LinearSystemMethod.ridgeRegression:
        return ridgeRegression(a, b, 0.1);
      default:
        throw Exception("Unknown method for solving a linear system.");
    }
  }
}
