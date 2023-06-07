part of matrix;

/// Enumeration for available decomposition methods in the `solve` function.
enum DecompositionMethod {
  /// LU Decomposition Crout's algorithm.
  crout,

  /// LU Decomposition Doolittle algorithm.
  doolittle,

  /// LU Decomposition Doolittle algorithm with partial pivoting.
  doolittlePivoting,

  /// LU Decomposition Doolittle algorithm with complete pivoting.
  doolittleCompletePivoting,

  /// LU Decomposition Gauss Elimination Method.
  gaussElimination,

  /// QR Decomposition Gram Schmidt method.
  qrGramSchmidt,

  /// QR Decomposition Householder method.
  qrHouseholder,

  /// LQ Decomposition.
  lq,

  /// Cholesky Decomposition.
  cholesky,

  /// Eigenvalue Decomposition.
  eigenvalue,

  /// Singular Value Decomposition.
  singularValue,

  /// Schur Decomposition.
  schur,

  /// Automatically selects a suitable decomposition method.
  auto,
}
