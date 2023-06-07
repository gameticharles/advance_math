part of matrix;

enum SparseFormat {
  /// Coordinate List format
  coo,

  /// Compressed Sparse Row format
  csr,

  /// Compressed Sparse Column format
  csc,

  /// Dictionary of Keys format
  dok,

  /// List of Lists format
  lil,
}
