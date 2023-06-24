part of algebra;

/// An enum representing the axes along which operations can be performed in a matrix.
///
/// `MatrixAxis` defines the two possible orientations along which certain operations can be performed on a matrix.
///
/// - [horizontal] represents the horizontal direction from left to right (column-wise).
/// An operation performed along this axis would generally affect the layout in a horizontal manner.
///
/// - [vertical] represents the vertical direction from top to bottom (row-wise).
/// An operation performed along this axis would generally affect the layout in a vertical manner.
///
/// This naming is more abstract and could be more appropriate in cases where the concept of "row" and "column" isn't as relevant.
/// For example, in graphical contexts or when describing the orientation of a UI layout or a print format.
///
/// Used in functions like [Matrix.flip] to specify the direction of the operation.
///
/// Example:
/// ```dart
/// var matrix = Matrix([[1, 2], [3, 4], [5, 6]]);
/// var matrixReversed = matrix.flip(MatrixAxis.columns);
/// print(matrixReversed);
/// // Output:
/// // Matrix: 3x2
/// // ┌ 2  1 ┐
/// // │ 4  3 │
/// // └ 6  5 ┘
/// ```
enum MatrixAxis {
  /// Specifies that the operation should be performed across rows.
  vertical,

  /// Specifies that the operation should be performed down columns.
  horizontal,
}
