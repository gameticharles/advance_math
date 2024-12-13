part of '../algebra.dart';

/// Enum representing different types of matrices and their properties.
///
/// Each variant corresponds to a specific property or type of a matrix:
///
/// - [general]: A general matrix without any specific properties.
/// - [square]: A matrix with the same number of rows and columns.
/// - [nullMatrix]: A matrix with all elements equal to zero.
/// - [diagonal]: A matrix with non-zero elements on the main diagonal and zero elements elsewhere.
/// - [identity]: A diagonal matrix with ones on the main diagonal.
/// - [ones]: A matrix with all elements of 1.
/// - [zeros]: A matrix with all elements of 0.
/// - [scalar]: A diagonal matrix with equal non-zero elements on the main diagonal.
/// - [row]: A matrix with only one row.
/// - [column]: A matrix with only one column.
/// - [magic]: A magic square is an arrangement of the integers 1:n^2 such that the row sums, column sums, and diagonal sums are all equal to the same value.
/// - [fullRank]: A matrix with rank equal to the minimum of its row and column count.
/// - [horizontal]: A matrix with more columns than rows.
/// - [vertical]: A matrix with more rows than columns.
/// - [upperTriangular]: A matrix with all elements below the main diagonal equal to zero.
/// - [lowerTriangular]: A matrix with all elements above the main diagonal equal to zero.
/// - [symmetric]: A matrix that equals its transpose.
/// - [skewSymmetric]: A matrix that equals the negative of its transpose.
/// - [orthogonal]: A matrix whose transpose equals its inverse.
/// - [singular]: A matrix with a determinant equal to zero.
/// - [nonSingular]: A matrix with a non-zero determinant.
/// - [toeplitz]: A matrix with constant values along its diagonals.
/// - [hankel]: A matrix with constant values along its anti-diagonals.
/// - [circulant]: A matrix where each row is a cyclic shift of the previous row.
/// - [vandermonde]: A matrix where the columns are powers of a set of values.
/// - [permutation]: A matrix obtained by permuting the rows of an identity matrix.
/// - [nilpotent]: A matrix where some power of the matrix equals the null matrix.
/// - [involutory]: A matrix that is its own inverse.
/// - [idempotent]: A matrix that equals its square.
/// - [tridiagonal]: A matrix with non-zero elements only on the main diagonal and the diagonals adjacent to it.
/// - [hermitian]: A matrix that equals its conjugate transpose.
/// - [sparse]: A matrix with mostly zero elements.
/// - [periodic]: A matrix that repeats itself after a certain number of matrix multiplications.
/// - [positiveDefinite]: A matrix that is positive definite (all its eigenvalues are positive).
/// - [negativeDefinite]: A matrix that is negative definite (all its eigenvalues are negative).
/// - [derogatory]: A matrix whose minimal polynomial has a higher degree than its characteristic polynomial.
/// - [diagonallyDominant]: A matrix where the absolute value of each diagonal element is greater than or equal to the sum of absolute values of other elements in the same row.
/// - [strictlyDiagonallyDominant]: A matrix where the absolute value of each diagonal element is strictly greater than the sum of absolute values of other elements in the same row.
///
/// Example:
/// ```
/// import 'dart:math' as math;
///
/// void main() {
///   // Generate a random 3x3 symmetric matrix
///   Matrix symmetricMatrix = Matrix.random(3, 3, types: [MatrixType.symmetric]);
///   print(symmetricMatrix);
///
///   // Generate a random 4x4 orthogonal matrix
///   Matrix orthogonalMatrix = Matrix.random(4, 4, types: [MatrixType.orthogonal]);
///   print(orthogonalMatrix);
/// }
/// ```
enum MatrixType {
  general,
  square,
  nullMatrix,
  diagonal,
  identity,
  ones,
  zeros,
  scalar,
  row,
  column,
  magic,
  fullRank,
  horizontal,
  vertical,
  upperTriangular,
  lowerTriangular,
  symmetric,
  skewSymmetric,
  orthogonal,
  singular,
  nonSingular,
  toeplitz,
  hankel,
  circulant,
  vandermonde,
  permutation,
  nilpotent,
  involutory,
  idempotent,
  tridiagonal,
  hermitian,
  sparse,
  periodic,
  positiveDefinite,
  negativeDefinite,
  derogatory,
  diagonallyDominant,
  strictlyDiagonallyDominant
}
