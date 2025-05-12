part of '../../../algebra.dart';

class QRDecomposition extends Decomposition {
  final Matrix Q;
  final Matrix R;

  QRDecomposition(this.Q, this.R);

  /// Checks if Q is an orthogonal matrix.
  bool get isOrthogonalMatrix => Q.isOrthogonalMatrix();

  /// Checks if R is an upper triangular matrix.
  bool get isUpperTriangular => R.isUpperTriangular();

  /// Checks the decomposition by reconstructing the original matrix.
  /// Returns the reconstructed matrix as Q * R.
  @override
  Matrix get checkMatrix => Q * R;

  /// Solves a linear equation system Ax = b for the given matrix b.
  /// Returns the solution matrix x.
  @override
  Matrix solve(Matrix b) {
    // Check if the matrix R is non-singular
    if (!R.isNonSingularMatrix()) {
      throw Exception("Matrix R is singular, cannot solve the linear system.");
    }

    // Compute Q^T * b
    Matrix y = Q.transpose() * b;

    // Solve Rx = Q^T * b using backward substitution
    Matrix x = _Utils.backwardSubstitution(R, y);

    return x;
  }

  @override
  String toString() {
    return 'QRDecomposition \nQ: $Q \nR: $R';
  }
}

class LQDecomposition extends Decomposition {
  final Matrix Q;
  final Matrix L;

  LQDecomposition(this.Q, this.L);

  /// Checks if Q is an orthogonal matrix.
  bool get isOrthogonalMatrix => Q.isOrthogonalMatrix();

  /// Checks if L is a lower triangular matrix.
  bool get isLowerTriangular => L.isLowerTriangular();

  /// Checks the decomposition by reconstructing the original matrix.
  /// Returns the reconstructed matrix as L * Q.
  @override
  Matrix get checkMatrix => L * Q;

  /// Solves a linear equation system Ax = b for the given matrix b.
  /// Returns the solution matrix x.
  @override
  Matrix solve(Matrix b) {
    // Check if the matrix L is non-singular
    if (!L.isNonSingularMatrix()) {
      throw Exception("Matrix L is singular, cannot solve the linear system.");
    }

    // Solve Ly = b using forward substitution
    Matrix y = _Utils.forwardSubstitution(L, b);

    // Compute x = Q^T * y
    Matrix x = Q.transpose() * y;

    return x;
  }

  @override
  String toString() {
    return 'LQDecomposition(Q: $Q, L: $L)';
  }
}

class EigenvalueDecomposition extends Decomposition {
  final Matrix D;
  final Matrix V;

  EigenvalueDecomposition(this.D, this.V);

  /// Checks the decomposition by reconstructing the original matrix.
  /// Returns the reconstructed matrix as V * D * V.inverse().
  @override
  Matrix get checkMatrix => V * D * V.inverse();

  /// Verifies the eigenvalues and eigenvectors by checking if A * x = λ * x
  /// for all eigenvalue-eigenvector pairs. Returns true if the verification
  /// is successful within the specified tolerance.
  bool verify(Matrix A, {double tolerance = 1e-6}) {
    for (int i = 0; i < V.columnCount; i++) {
      Matrix eigenvector = V.column(i);
      Matrix ax = A * eigenvector;
      Matrix lambdaX = eigenvector * D[i][i];

      for (int j = 0; j < ax.rowCount; j++) {
        if ((ax[j][0] - lambdaX[j][0]).abs() > tolerance) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  Matrix solve(Matrix b) {
    if (b.rowCount != V.rowCount) {
      throw ArgumentError('Matrix row dimensions must agree.');
    }

    // Compute D^-1
    Matrix dInv = D.copy();
    for (int i = 0; i < D.rowCount; i++) {
      dInv[i][i] = Complex.one() / dInv[i][i];
    }

    // Compute x = V * D^-1 * V^-1 * b
    Matrix x = V * dInv * V.inverse() * b;

    return x;
  }

  @override
  String toString() {
    return 'Eigenvalue Decomposition \nD: $D \nV: $V';
  }
}

class EigenvalueDecompositions {
  final Matrix eigenvalues;
  final Matrix eigenvectors;

  EigenvalueDecompositions(this.eigenvalues, this.eigenvectors);

  static EigenvalueDecomposition decompose(Matrix a,
      {int maxIterations = 100, double tolerance = 1e-10}) {
    if (a.rowCount != a.columnCount) {
      throw Exception("Matrix A must be a square matrix.");
    }

    // Compute the Real Schur Decomposition
    final schurDecomposition = a.decomposition.schurDecomposition();
    Matrix q = schurDecomposition.Q;
    Matrix t = schurDecomposition.T;

    // Extract eigenvalues
    Matrix lambda = DiagonalMatrix(t.diagonal());

    // Compute eigenvectors
    // Extract eigenvalues from the diagonal of the upper-triangular matrix T

    return EigenvalueDecomposition(lambda, q);
  }

  @override
  String toString() {
    return 'Eigenvalue Decompositions \nEigenvalues: $eigenvalues \nEigenvectors: $eigenvectors';
  }
}

class CholeskyDecomposition extends Decomposition {
  final Matrix L;
  final Matrix _originalMatrix;

  CholeskyDecomposition(this._originalMatrix, this.L);

  /// Checks if L is a lower triangular matrix.
  bool get isLowerTriangular => L.isLowerTriangular();

  /// Checks if the matrix is positive definite.
  bool get isPositiveDefiniteMatrix =>
      _originalMatrix.isPositiveDefiniteMatrix();

  /// Checks the decomposition by reconstructing the original matrix.
  /// Returns the reconstructed matrix as L * L.transpose().
  @override
  Matrix get checkMatrix => L * L.transpose();

  /// Solves the linear system Ax = b using Cholesky decomposition, where A is the original matrix.
  /// The method assumes that the original matrix A is positive definite.
  ///
  /// [b] is the right-hand side matrix of the linear system.
  ///
  /// Returns the solution matrix x, such that Ax = b.
  ///
  /// Throws an exception if the original matrix is not positive definite.
  @override
  Matrix solve(Matrix b) {
    // Check if the original matrix is positive definite
    if (!isPositiveDefiniteMatrix) {
      throw Exception(
          "Original matrix is not positive definite, cannot solve the linear system.");
    }

    // Solve Ly = b using forward substitution
    // L is the lower triangular matrix from Cholesky decomposition
    Matrix y = _Utils.forwardSubstitution(L, b);

    // Solve L^T * x = y using backward substitution
    // L^T is the transpose of the lower triangular matrix L
    Matrix x = _Utils.backwardSubstitution(L.transpose(), y);

    return x;
  }

  @override
  String toString() {
    return 'Cholesky Decomposition \nL: $L \nOriginal Matrix: $_originalMatrix';
  }
}

class SchurDecomposition extends Decomposition {
  final Matrix Q;
  final Matrix T;

  SchurDecomposition(this.Q, this.T);

  /// Checks if Q is an orthogonal matrix.
  bool get isOrthogonalMatrix => Q.isOrthogonalMatrix();

  /// Checks the decomposition by reconstructing the original matrix.
  /// Returns the reconstructed matrix as Q * A * Q.transpose().
  @override
  Matrix get checkMatrix => Q * T * Q.transpose();

  /// Solves a linear equation system Ax = b using the Schur decomposition of A.
  ///
  /// computed, where T is a diagonal or nearly diagonal matrix. This approach
  /// is not guaranteed to work for all matrices and might not provide accurate
  /// results in certain cases.
  ///
  /// Note: It is generally preferable to use other decomposition methods, such
  /// as LU or QR decomposition, to solve linear systems, as they are specifically
  /// designed for this purpose.
  ///
  /// Throws an exception if the matrix A in the Schur decomposition is not diagonal.
  ///
  /// Returns the solution matrix x.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [4, 1, -1],
  ///   [1, 4, -1],
  ///   [-1, -1, 4]
  /// ]);
  /// Matrix b = Matrix.fromList([
  ///   [6],
  ///   [25],
  ///   [14]
  /// ]);
  ///
  /// SchurDecomposition schur = A.decomposition.schurDecomposition();
  /// Matrix x = schur.solve(b);
  /// x.prettyPrint();
  /// ```
  @override
  Matrix solve(Matrix b) {
    // Check if A is diagonal
    if (!T.isDiagonalMatrix()) {
      throw Exception(
          "Matrix A in Schur decomposition is not diagonal, cannot solve the linear system.");
    }

    // Compute the transformed right-hand side vector, y = Q.transpose() * b
    Matrix y = Q.transpose() * b;

    // Solve the diagonal system A * x = y
    Matrix x = Matrix.zeros(y.rowCount, y.columnCount);
    for (int i = 0; i < T.rowCount; i++) {
      for (int j = 0; j < y.columnCount; j++) {
        x[i][j] = y[i][j] / T[i][i];
      }
    }

    // Transform the solution back to the original coordinate system, x_original = Q * x
    Matrix xOriginal = Q * x;

    return xOriginal;
  }

  @override
  String toString() {
    return 'Schur Decomposition \nQ: $Q \nT: $T';
  }
}

class LUDecomposition extends Decomposition {
  final Matrix L;
  final Matrix U;
  final Matrix? P;
  final Matrix? Q;

  LUDecomposition(this.L, this.U, [this.P, this.Q]);

  /// Checks if the matrix U is non-singular.
  bool get isNonSingular => U.isNonSingularMatrix();

  /// Checks the decomposition by reconstructing the original matrix.
  /// If P and Q are not null, returns P * L * U * Q.
  /// If only P is not null, returns P * L * U.
  /// If both P and Q are null, returns L * U.
  @override
  Matrix get checkMatrix {
    if (P != null && Q != null) {
      return P! * L * U * Q!;
    } else if (P != null) {
      return P! * L * U;
    } else {
      return L * U;
    }
  }

  @override
  Matrix solve(Matrix b) {
    // Check if the matrix is non-singular
    if (!isNonSingular) {
      throw Exception("Matrix is singular, cannot solve the linear system.");
    }

    // If the matrix has been permuted, apply the permutation to b
    Matrix pb = P != null ? P! * b : b;

    // Solve LY = Pb using forward substitution
    Matrix y = _Utils.forwardSubstitution(L, pb);

    // Solve UX = Y using backward substitution
    Matrix x = _Utils.backwardSubstitution(U, y);

    return x;
  }

  @override
  String toString() {
    return 'LU Decomposition \nL: $L \nU: $U \nP: $P \nQ: $Q';
  }
}

class SingularValueDecomposition extends Decomposition {
  final SVD? _svd;
  final Matrix? _u;
  final Matrix? _s;
  final Matrix? _v;
  final dynamic _conditionNumber;

  /// Constructor that takes an SVD object
  SingularValueDecomposition(SVD svd) 
    : _svd = svd,
      _u = null,
      _s = null,
      _v = null,
      _conditionNumber = null;

  /// Constructor that takes pre-computed U, S, and V matrices
  /// 
  /// [u] The left singular vectors matrix
  /// [s] The diagonal matrix of singular values
  /// [v] The right singular vectors matrix (V^T)
  /// [condNumber] Optional pre-computed condition number
  SingularValueDecomposition.fromComponents(Matrix u, Matrix s, Matrix v, {dynamic condNumber}) 
    : _svd = null,
      _u = u,
      _s = s,
      _v = v,
      _conditionNumber = condNumber;

  /// Returns the left singular vectors
  Matrix get U => _svd != null ? _svd.U() : _u!;

  /// Returns the diagonal matrix of singular values
  Matrix get S => _svd != null ? _svd.S() : _s!;

  /// Returns the right singular vectors (V^T)
  Matrix get V => _svd != null ? _svd.V() : _v!;

  /// Two norm condition number
  dynamic get conditionNumber {
    if (_conditionNumber != null) return _conditionNumber;
    if (_svd != null) return _svd.cond();
    
    // Calculate condition number from singular values if not provided
    dynamic maxSingularValue = S[0][0];
    dynamic minSingularValue = maxSingularValue;
    
    int minDim = math.min(S.rowCount, S.columnCount);
    for (int i = 0; i < minDim; i++) {
      if (S[i][i] != Complex.zero() && S[i][i].abs() < minSingularValue.abs()) {
        minSingularValue = S[i][i];
      }
    }
    
    return maxSingularValue / minSingularValue;
  }

  // Rest of the class remains the same
  /// Checks if U is an orthogonal matrix.
  bool get isOrthogonalU => U.isOrthogonalMatrix();

  /// Checks if V is an orthogonal matrix.
  bool get isOrthogonalV => V.isOrthogonalMatrix();

  /// Checks the decomposition by reconstructing the original matrix.
  /// Returns the reconstructed matrix as U * S * V.transpose().
  @override
  Matrix get checkMatrix => U * S * V.transpose();

  /// Solves a linear equation system Ax = b for the given matrix b.
  /// Returns the solution matrix x.
  @override
  Matrix solve(Matrix b) {
    // Compute the pseudo-inverse of S
    var sPseudoInverse = Matrix.fill(S.rowCount, S.columnCount, Complex.zero());
    for (int i = 0; i < S.rowCount; i++) {
      sPseudoInverse[i][i] =
          S[i][i] != 0 ? Complex.one() / S[i][i] : Complex.zero();
    }

    // Compute x = V * S^+ * U^T * b
    Matrix x = V * sPseudoInverse * U.transpose() * b;

    return x;
  }

  @override
  String toString() {
    return 'Singular Value Decomposition \nU: $U \nS: $S \nV: $V';
  }
}

class Bidiagonalization {
  Matrix U;
  Matrix B;
  Matrix V;

  Bidiagonalization(this.U, this.B, this.V);
}
