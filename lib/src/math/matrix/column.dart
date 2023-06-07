part of matrix;

/// Column class extends Matrix and represents a single column in a matrix.
///
/// Inherits all Matrix properties and methods, but the data is stored in an Nx1 matrix.
class Column extends Matrix {
  /// Constructs a Column object from a list of dynamic data.
  ///
  /// [data]: List of dynamic data elements representing a single column.
  ///
  /// Example:
  /// ```dart
  /// var column = Column([1, 2, 3]);
  /// print(column);
  /// // Output:
  /// // 1
  /// // 2
  /// // 3
  /// ```
  Column(List<dynamic> data) : super(data.map((x) => [x]).toList());

  /// Retrieves the value at a specific row index from the Column.
  ///
  /// [rowIndex]: The index of the row.
  ///
  /// Throws [Exception] if the index is out of range.
  ///
  /// Example:
  /// ```dart
  /// var col = Column([1, 2, 3]);
  /// print(col.getValueAt(1)); // Output: 2
  /// ```
  dynamic getValueAt(int rowIndex) {
    if (rowIndex < 0 || rowIndex >= _data.length) {
      throw Exception('Index is out of range');
    }
    return _data[rowIndex][0];
  }

  /// Assigns a value at a specific row index in the Column.
  ///
  /// [rowIndex]: The index of the row.
  /// [value]: The value to be assigned.
  ///
  /// Throws [Exception] if the index is out of range.
  ///
  /// Example:
  /// ```dart
  /// var col = Column([1, 2, 3]);
  /// col.setValueAt(1, 5);
  /// print(col); // Output: [1, 5, 3]
  /// ```
  void setValueAt(int rowIndex, dynamic value) {
    if (rowIndex < 0 || rowIndex >= _data.length) {
      throw Exception('Index is out of range');
    }
    _data[rowIndex][0] = value;
  }

  /// Creates a new Column object with the specified number of rows filled with the specified value.
  ///
  /// [rows]: The number of rows in the new Column object.
  /// [value]: The value used to fill each element in the new Column object.
  ///
  /// Throws [Exception] if the specified number of rows is less than 1.
  ///
  /// Returns a new Column object with the specified number of rows filled with the specified value.
  ///```dart
  /// Column filledRow = Column.fill(5, 3);
  /// print(filledRow);
  /// ```
  ///
  factory Column.fill(int rows, dynamic value) {
    if (rows < 1) {
      throw Exception("Rows must be greater than 0");
    }

    List<dynamic> row = List.generate(rows, (index) => value);

    return Column(row);
  }

  /// Generates a `Column` with the given `length`, filled with random values
  /// between `min` and `max`. If `isDouble` is `true`, then the values will be doubles.
  /// Otherwise, they will be integers. If `random` is not `null`, it will be used
  /// as the random number generator.
  static Column random(int length,
      {double min = 0,
      double max = 1,
      bool isDouble = true,
      math.Random? random,
      int? seed}) {
    if (seed != null) {
      random = math.Random(seed);
    }
    random ??= math.Random();
    return Column(List.generate(
      length,
      (_) => (isDouble
          ? random!.nextDouble() * (max - min) + min
          : random!.nextInt(max.toInt() - min.toInt()) + min.toInt()),
    ));
  }

  /// Adds a new value at the end of the column.
  void push(dynamic value) {
    _data.add([value]);
  }

  /// Removes the last value in the column.
  dynamic pop() {
    return _data.removeLast()[0];
  }

  /// Adds a new value at the beginning of the column.
  void unShift(dynamic value) {
    _data.insert(0, [value]);
  }

  /// Removes the first value in the column.
  dynamic shift() {
    return _data.removeAt(0)[0];
  }

  /// Adds/removes elements at an arbitrary position in the column.
  void splice(int start, int deleteCount, [List<dynamic> newItems = const []]) {
    _data.removeRange(start, start + deleteCount);
    _data.insertAll(start, newItems.map((item) => [item]).toList());
  }

  /// Swaps two elements in the column.
  void swap(int index1, int index2) {
    var temp = _data[index1][0];
    _data[index1][0] = _data[index2][0];
    _data[index2][0] = temp;
  }

  /// Get the list of the elements that are in the matrix
  List<dynamic> get asList => flatten();

  /// Returns the first element of the column.
  ///
  /// Example:
  /// ```dart
  /// var column = Column([1, 2, 3]);
  /// print(column.first); // Output: 1
  /// ```
  dynamic get firstItem => _data[0][0];

  /// Returns the last element of the column.
  ///
  /// Example:
  /// ```dart
  /// var column = Column([1, 2, 3]);
  /// print(column.last); // Output: 3
  /// ```
  dynamic get lastItem => _data[_data.length - 1][0];

  /// Returns the sum of all elements in the column.
  ///
  /// Example:
  /// ```dart
  /// var column = Column([1, 2, 3]);
  /// print(column.sum); // Output: 6
  /// ```
  dynamic get sum =>
      _data.map((row) => row[0]).reduce((value, element) => value + element);

  /// Returns the average of all elements in the column.
  ///
  /// Example:
  /// ```dart
  /// var column = Column([1, 2, 3]);
  /// print(column.average); // Output: 2.0
  /// ```
  dynamic get average => sum / _data.length;

  /// Returns the leading diagonals from a column.
  ///
  /// Example:
  /// ```dart
  /// var column = Column([1, 2, 3]);
  /// print(column.toDiagonal);
  /// // 1 0 0
  /// // 0 2 0
  /// // 0 0 3
  /// ```
  Diagonal toDiagonal() {
    List<dynamic> diagonal = [];
    for (int i = 0; i < _data.length; i++) {
      diagonal.add(_data[i][0]);
    }
    return Diagonal(diagonal);
  }
}
