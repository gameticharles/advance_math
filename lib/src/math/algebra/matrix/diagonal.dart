part of '../algebra.dart';

/// The `Diagonal` class is a subclass of `Matrix` and represents a diagonal matrix.
/// A diagonal matrix is a square matrix in which all the elements outside the main diagonal are zero.
///
/// Example:
///
/// ```
/// final diagonal = Diagonal([1, 2, 3]);
/// print(diagonal);
/// ```
///
/// Output:
///
/// ```
/// 1 0 0
/// 0 2 0
/// 0 0 3
/// ```
class DiagonalMatrix extends Matrix {
  /// Creates a `Diagonal` matrix using a list of dynamic data.
  /// The provided list `data` contains the elements of the main diagonal.
  DiagonalMatrix(List<dynamic> data) : super(_createDiagonalMatrix(data));

  /// Generates the 2D list for the diagonal matrix based on the provided `data`.
  static List<List<dynamic>> _createDiagonalMatrix(List<dynamic> data) {
    int n = data.length;
    List<List<dynamic>> diagonalMatrix = List.generate(
        n, (i) => List.generate(n, (j) => i == j ? data[i] : Complex.zero()));
    return diagonalMatrix;
  }

  /// Get the list of the elements that are in the matrix
  List<dynamic> get asList => diagonal();

  /// Returns the first element of the Diagonal.
  ///
  /// Example:
  /// ```dart
  /// var diag = Diagonal([1, 2, 3]);
  /// print(diag.first); // Output: 1
  /// ```
  dynamic get firstItem => _data[0][0];

  /// Returns the last element of the Diagonal.
  ///
  /// Example:
  /// ```dart
  /// var diag = Diagonal([1, 2, 3]);
  /// print(diag.last); // Output: 3
  /// ```
  dynamic get lastItem => _data[_data.length - 1][_data.length - 1];

  /// Retrieves the value at a specific index from the main diagonal.
  ///
  /// [index]: The index on the main diagonal.
  ///
  /// Throws [Exception] if the index is out of range.
  ///
  /// Example:
  /// ```dart
  /// var diag = Diagonal([1, 2, 3]);
  /// print(diag.getValueAt(1)); // Output: 2
  /// ```
  dynamic getValueAt(int index) {
    if (index < 0 || index >= _data.length) {
      throw Exception('Index is out of range');
    }
    return _data[index][index];
  }

  /// Assigns a value at a specific index in the main diagonal.
  ///
  /// [index]: The index on the main diagonal.
  /// [value]: The value to be assigned.
  ///
  /// Throws [Exception] if the index is out of range.
  ///
  /// Example:
  /// ```dart
  /// var diag = Diagonal([1, 2, 3]);
  /// diag.setValueAt(1, 5);
  /// print(diag); // Output: [1, 5, 3]
  /// ```
  void setValueAt(int index, dynamic value) {
    if (index < 0 || index >= _data.length) {
      throw Exception('Index is out of range');
    }
    _data[index][index] = value;
  }

  /// Returns the sum of all elements in the Matrix.
  ///
  /// Example:
  /// ```dart
  /// var diag = Diagonal([1, 2, 3]);
  /// print(diag.sum); // Output: 6
  /// ```
  dynamic get sum => _data
      .map((row) => row[row.indexOf(row)])
      .reduce((value, element) => value + element);

  /// Returns the average of all elements in the Diagonal Matrix.
  ///
  /// Example:
  /// ```dart
  /// var diag = Diagonal([1, 2, 3]);
  /// print(diag.average); // Output: 2.0
  /// ```
  dynamic get average => sum / _data.length;
}
