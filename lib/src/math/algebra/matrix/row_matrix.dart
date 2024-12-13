part of '../algebra.dart';

/// Row class extends Matrix and represents a single row in a matrix.
///
/// Inherits all Matrix properties and methods, but the data is stored in a 1xN matrix.
class RowMatrix extends Matrix {
  /// Constructs a Row object from a list of dynamic data.
  ///
  /// [data]: List of dynamic data elements representing a single row.
  ///
  /// Example:
  /// ```dart
  /// var row = Row([1, 2, 3]);
  /// print(row);
  /// // Output: 1 2 3
  /// ```
  RowMatrix(List<dynamic> data) : super([data]);

  /// Retrieves the value at a specific column index from the Row.
  ///
  /// [colIndex]: The index of the column.
  ///
  /// Throws [Exception] if the index is out of range.
  ///
  /// Example:
  /// ```dart
  /// var row = Row([1, 2, 3]);
  /// print(row.getValueAt(1)); // Output: 2
  /// ```
  dynamic getValueAt(int colIndex) {
    if (colIndex < 0 || colIndex >= columnCount) {
      throw Exception('Index is out of range');
    }
    return _data[0][colIndex];
  }

  /// Assigns a value at a specific column index in the Row.
  ///
  /// [colIndex]: The index of the column.
  /// [value]: The value to be assigned.
  ///
  /// Throws [Exception] if the index is out of range.
  ///
  /// Example:
  /// ```dart
  /// var row = Row([1, 2, 3]);
  /// row.setValueAt(1, 5);
  /// print(row); // Output: [1, 5, 3]
  /// ```
  void setValueAt(int colIndex, dynamic value) {
    if (colIndex < 0 || colIndex >= columnCount) {
      throw Exception('Index is out of range');
    }
    _data[0][colIndex] = value;
  }

  /// Creates a new Row object with the specified number of columns filled with the specified value.
  ///
  /// [cols]: The number of columns in the new Row object.
  /// [value]: The value used to fill each element in the new Row object.
  ///
  /// Throws [Exception] if the specified number of columns is less than 1.
  ///
  /// Returns a new Row object with the specified number of columns filled with the specified value.
  ///```dart
  /// Row filledRow = Row.fill(5, 3);
  /// print(filledRow);
  /// ```
  ///
  factory RowMatrix.fill(int cols, dynamic value) {
    if (cols < 1) {
      throw Exception("Columns must be greater than 0");
    }

    List<dynamic> row = List.generate(cols, (index) => value);

    return RowMatrix(row);
  }

  /// Generates a `Row` with the given `length`, filled with random values
  /// between `min` and `max`. If `isDouble` is `true`, then the values will be doubles.
  /// Otherwise, they will be integers. If `random` is not `null`, it will be used
  /// as the random number generator.
  static RowMatrix random(int length,
      {double min = 0,
      double max = 1,
      bool isDouble = true,
      math.Random? random,
      int? seed}) {
    if (seed != null) {
      random = math.Random(seed);
    }
    random ??= math.Random();
    return RowMatrix(List.generate(
      length,
      (_) => (isDouble
          ? random!.nextDouble() * (max - min) + min
          : random!.nextInt(max.toInt() - min.toInt()) + min.toInt()),
    ));
  }

  /// Adds a new value at the end of the row.
  void push(dynamic value) {
    _data[0].add(value);
  }

  /// Removes the last value in the row.
  dynamic pop() {
    return _data[0].removeLast();
  }

  /// Adds a new value at the beginning of the row.
  void unShift(dynamic value) {
    _data[0].insert(0, value);
  }

  /// Removes the first value in the row.
  dynamic shift() {
    return _data[0].removeAt(0);
  }

  /// Adds/removes elements at an arbitrary position in the row.
  void splice(int start, int deleteCount, [List<dynamic> newItems = const []]) {
    _data[0].removeRange(start, start + deleteCount);
    _data[0].insertAll(start, newItems);
  }

  /// Swaps two elements in the row.
  void swap(int index1, int index2) {
    var temp = _data[0][index1];
    _data[0][index1] = _data[0][index2];
    _data[0][index2] = temp;
  }

  /// Get the list of the elements that are in the matrix
  List<dynamic> get asList => _data;

  /// Returns the first element of the row.
  ///
  /// Example:
  /// ```dart
  /// var row = Row([1, 2, 3]);
  /// print(row.first); // Output: 1
  /// ```
  dynamic get firstItem => _data[0][0];

  /// Returns the last element of the row.
  ///
  /// Example:
  /// ```dart
  /// var row = Row([1, 2, 3]);
  /// print(row.last); // Output: 3
  /// ```
  dynamic get lastItem => _data[0][columnCount - 1];

  /// Returns the sum of all elements in the row.
  ///
  /// Example:
  /// ```dart
  /// var row = Row([1, 2, 3]);
  /// print(row.sum); // Output: 6
  /// ```
  double get sum => _data[0].reduce((value, element) => value + element);

  /// Returns the average of all elements in the row.
  ///
  /// Example:
  /// ```dart
  /// var row = Row([1, 2, 3]);
  /// print(row.average); // Output: 2.0
  /// ```
  double get average => sum / columnCount;

  /// Returns the leading diagonals from a row.
  ///
  /// Example:
  /// ```dart
  /// var row = Row([1, 2, 3]);
  /// print(row.toDiagonal);
  /// // 1 0 0
  /// // 0 2 0
  /// // 0 0 3
  /// ```
  Matrix toDiagonal() {
    List<dynamic> diagonal = [];
    for (int i = 0; i < columnCount; i++) {
      diagonal.add(_data[0][i]);
    }
    return DiagonalMatrix(diagonal);
  }
}
