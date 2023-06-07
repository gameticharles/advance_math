part of matrix;

/// Enumeration of supported norms for vectors and matrices.
///
/// Each type corresponds to a specific method of calculating the norm (or length) of a vector or matrix.
enum Norm {
  /// The Frobenius norm, also known as the Euclidean norm for a vector,
  /// is calculated as the square root of the sum of the absolute squares of its elements.
  /// Applicable to both vectors and matrices.
  frobenius,

  /// The Manhattan norm, also known as the L1 norm or Taxicab norm,
  /// is the sum of the absolute values of the vector elements or matrix entries.
  /// Applicable to both vectors and matrices.
  manhattan,

  /// The Chebyshev norm, also known as the infinity norm or max norm,
  /// is the maximum absolute value among the elements for a vector and maximum absolute row sum for a matrix.
  /// Applicable to both vectors and matrices.
  chebyshev,

  /// The Cosine norm calculates the cosine of the angle between two vectors.
  /// Not applicable to matrices.
  cosine,

  /// The Hamming norm calculates the number of positions at which the corresponding values are different.
  /// For a single vector, it counts the number of non-zero elements.
  /// Not applicable to matrices.
  hamming,

  /// The Mahalanobis distance is a measure of the distance between a point and a distribution, not between two points.
  /// It transforms the vector into a standard score and measures how many standard deviations the point is from the mean of the distribution.
  /// Requires the covariance matrix of the dataset and its inverse.
  /// Applicable to both vectors and matrices.
  mahalanobis,

  /// The Spectral norm, also known as the 2-norm or the operator norm,
  /// is the largest singular value (the square root of the largest eigenvalue of the matrix's conjugate transpose times the matrix).
  /// Not applicable to vectors.
  spectral,

  /// The Trace norm (also known as the nuclear norm) of a matrix is the sum of its singular values.
  /// Not applicable to vectors.
  trace,
}
