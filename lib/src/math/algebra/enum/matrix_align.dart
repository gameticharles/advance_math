part of algebra;

/// An enum representing the alignment options for matrix elements in a string representation.
///
/// [MatrixAlign.left]: Left-aligns the matrix elements in each column.
/// [MatrixAlign.right]: Right-aligns the matrix elements in each column.
///
/// Example:
///
/// ```dart
/// var m = Matrix([
///   [1, 23, 3],
///   [456, 5, 67],
///   [7, 88, 9],
///   [10, 111, 12],
/// ]);
///
/// // Use MatrixAlign.left for left-aligned elements
/// print(m.toString(separator: ' ', alignment: MatrixAlign.left));
///
/// // Output:
/// // Matrix: 4x3
/// // ┌1   23  3  ┐
/// // │456 5   67 │
/// // │7   88  9  │
/// // └10  111 12 ┘
///
/// // Use MatrixAlign.right for right-aligned elements
/// print(m.toString(separator: ' ', alignment: MatrixAlign.right));
///
/// // Output:
/// // Matrix: 4x3
/// // ┌  1  23  3┐
/// // │456   5 67│
/// // │  7  88  9│
/// // └ 10 111 12┘
/// ```
enum MatrixAlign { left, right }
