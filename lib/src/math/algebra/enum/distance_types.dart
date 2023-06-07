part of matrix;

/// The DistanceType enum contains different types of distance metrics used
/// for both Vector and Matrix distance calculations.
enum Distance {
  /// The Frobenius norm, often used as a matrix norm, is a
  /// measure of the magnitude of the matrix elements. It's the square
  /// root of the sum of the absolute squares of its elements and is
  /// analogous to the Euclidean norm for vectors.
  frobenius,

  /// Manhattan, also known as the taxicab or city-block distance, it is
  /// the sum of the absolute differences of the components. It calculates
  /// distance as if moving in a grid-based path (like a car driving in city
  /// streets). For matrices, it's the sum of absolute differences between
  /// all corresponding elements.
  manhattan,

  /// Chebyshev is also known as maximum value norm, it finds the maximum
  /// absolute difference between components of the vectors (or matrices).
  /// It is effectively a limit of the p-norm as p approaches infinity.
  chebyshev,

  /// The cosine distance measures the cosine of the angle between
  /// two vectors. It is not a norm, but rather a similarity measure. The
  /// cosine distance ranges between -1 and 1. Cosine similarity is often
  /// used in high dimensional positive spaces, where the Euclidean
  /// distance can be distorted. When applied to matrices, the matrices
  /// are typically flattened to vectors first, which may not preserve
  /// their 2D structure and can be computationally expensive for large
  /// matrices. However, it can be useful for comparing the overall
  /// "direction" or "shape" of the data in the matrices.
  cosine,

  /// The Hamming distance calculates the number of differing
  /// components between two vectors or matrices. It's often used in
  /// computer science for error detection or error correction when data
  /// is transmitted over computer networks. For matrices, the Hamming
  /// distance is computed after the matrices are flattened into vectors,
  /// which can be computationally expensive for large matrices.
  hamming,

  /// The Mahalanobis distance is a measure of the distance
  /// between a point and a distribution, not between two distinct points.
  /// It transforms the inputs into a standardized space where the
  /// covariance matrix is the identity matrix. This is currently
  /// not implemented for matrices.
  mahalanobis,

  /// Spectral norm is the operator norm corresponding to the
  /// 2-norm for matrix. It is the largest singular value of the matrix.
  spectral,

  /// The trace norm (also known as nuclear norm) is the sum of
  /// singular values of the matrix. It is often used as a matrix norm.
  trace,
}
