part of '../algebra.dart';

/// Enum for specifying the direction of rescaling operation in a matrix.
///
/// This enum is used in conjunction with the rescale() method in the Matrix class.
///
/// Each value of this enum represents a possible direction to perform rescaling:
///
/// [Rescale.row]: Rescaling is performed independently for each row. For every row in the matrix,
/// the minimum value in that row is subtracted from each element and then each element is divided
/// by the difference between the maximum and minimum values in the row. As a result, all elements in
/// each row will be in the range of 0 to 1.
///
/// [Rescale.column]: Rescaling is performed independently for each column. For every column in the
/// matrix, the minimum value in that column is subtracted from each element and then each element
/// is divided by the difference between the maximum and minimum values in the column. As a result,
/// all elements in each column will be in the range of 0 to 1.
///
/// [Rescale.all]: Rescaling is performed for all elements in the matrix. The minimum value in the
/// entire matrix is subtracted from each element and then each element is divided by the difference
/// between the maximum and minimum values in the entire matrix. As a result, all elements in the
/// matrix will be in the range of 0 to 1.
enum Rescale {
  row,
  column,
  all,
}
