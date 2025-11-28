part of '../../algebra.dart';

/// Class to store eigenvalues and eigenvectors of a matrix.
class Eigen {
  /// List of eigenvalues.
  final List<dynamic> values;

  /// List of eigenvectors, each represented as a column matrix.
  final List<Matrix> vectors;

  /// Constructs an Eigen object from the given eigenvalues and eigenvectors.
  Eigen(this.values, this.vectors);

  /// Construct the Matrix from the given eigenvalues and eigenvectors
  /// M = S.J.S^-1
  ///
  /// where S is a matrix of the eigenvectors in row-major order
  /// s = `[
  /// v1.transpose(),
  /// v2.transpose(),
  /// v3.transpose(),
  /// ...
  /// ]`
  ///
  /// J = Diagonal(eigenvalues)
  Matrix get check {
    var S = Matrix(vectors.map((e) => e.flatten()).toList()).transpose();
    var J = DiagonalMatrix(values);
    return S * J * S.inverse();
  }

  /// Verifies the eigenvalues and eigenvectors by checking if A * x = λ * x
  /// for all eigenvalue-eigenvector pairs. Returns true if the verification
  /// is successful within the specified tolerance.
  bool verify(Matrix A, {num tolerance = 1e-6}) {
    for (int i = 0; i < vectors.length; i++) {
      Matrix eigenvector = vectors[i];
      Matrix ax = A * eigenvector;
      Matrix lambdaX = eigenvector * values[i];
      Matrix residual = ax - lambdaX;

      if (residual.norm(Norm.chebyshev) > Complex(tolerance)) {
        return false;
      }
    }

    return true;
  }
}
