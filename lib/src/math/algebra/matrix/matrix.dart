part of '../algebra.dart';

/// The `Matrix` class provides a structure for two-dimensional arrays of data,
/// along with various utility methods for manipulating these arrays.
///
/// The class extends `IterableMixin` allowing iteration over the rows or columns of the matrix.
class Matrix extends IterableMixin<List<dynamic>> {
  /// Private field to hold the actual data of the matrix.
  List<List<dynamic>> _data = const [];

  /// Constructs a Matrix object from a `List<List<dynamic>>` or a String.
  /// If input is null or not provided, an empty Matrix is created.
  ///
  /// [input]: `List<List<dynamic>>` or String representing the matrix data.
  ///
  /// Example 1:
  /// ```dart
  /// var m1 = Matrix([
  ///   [1, 2],
  ///   [3, 4]
  /// ]);
  /// ```
  ///
  /// Example 2:
  /// ```dart
  /// var m2 = Matrix("1 2; 3 4"); // Matrix("1, 2; 3, 4")
  /// ```
  Matrix([dynamic input]) {
    if (input == null) {
      _data = const [];
    } else if (input is String) {
      _data = _Utils.parseMatrixString(input);
    } else if (input is List<List<dynamic>>) {
      int length = input[0].length;
      for (var row in input) {
        if (row.length != length) {
          throw Exception('Rows have different lengths');
        }
      }
      _data = input;
    } else {
      throw Exception('Invalid input type');
    }
  }

  /// Getter to retrieve row-wise iteration over the matrix.
  /// It returns an iterable of rows, where each row is a list of elements.
  ///
  /// Example usage:
  /// ```
  /// final matrix = Matrix([[1, 2], [3, 4]]);
  /// matrix.rows.forEach(print); // Prints [1, 2] then [3, 4]
  /// ```
  Iterable<List<dynamic>> get rows => _MatrixIterable(this, columnMajor: false);

  /// Getter to retrieve column-wise iteration over the matrix.
  /// It returns an iterable of columns, where each column is a list of elements.
  ///
  /// Example usage:
  /// ```
  /// final matrix = Matrix([[1, 2], [3, 4]]);
  /// matrix.columns.forEach(print); // Prints [[1], [3]] then [[2], [4]]
  /// ```
  Iterable<List<dynamic>> get columns =>
      _MatrixIterable(this, columnMajor: true);

  /// Getter to retrieve an iterable over all elements in the matrix,
  /// regardless of their row or column.
  ///
  /// Example usage:
  /// ```
  /// final matrix = Matrix([[1, 2], [3, 4]]);
  /// matrix.elements.forEach(print); // Prints 1, 2, 3, 4
  /// ```
  Iterable<dynamic> get elements => _MatrixElementIterable(this);

  /// Getter to retrieve the MatrixDecomposition object associated with the matrix.
  /// This object provides methods for various matrix decompositions, like LU, QR etc.
  MatrixDecomposition get decomposition => MatrixDecomposition(this);

  /// Getter to retrieve the LinearSystemSolvers object associated with the matrix.
  /// This object provides methods for solving linear systems of equations represented by the matrix.
  LinearSystemSolvers get linear => LinearSystemSolvers(this);

  /// Static getter to retrieve the MatrixFactory object.
  /// This object provides methods for generating special kinds of matrices like diagonal, identity etc.
  static MatrixFactory get factory => MatrixFactory();

  /// Overrides the iterator getter to provide a MatrixIterator.
  /// This iterator iterates over the rows of the matrix.
  @override
  Iterator<List<dynamic>> get iterator => MatrixIterator(this);

  /// Returns the number of rows in the matrix.
  int get rowCount => _data.length;

  /// Returns the number of columns in the matrix.
  int get columnCount => _data.isEmpty ? 0 : _data[0].length;

  /// Returns the dimensions of the matrix as a `List<int>` in the format [rowCount, columnCount].
  List<int> get shape => [rowCount, columnCount];

  /// Assigns the value to the specified row index of the matrix.
  operator []=(int index, List<dynamic> value) {
    if (_data.isNotEmpty && value.length != columnCount) {
      throw Exception('Row has different length than the other rows');
    }
    if (index < 0 || index >= _data.length) {
      throw Exception('Index is out of range');
    }
    _data[index] = value;
  }

  /// Retrieves the specified row from the matrix.
  List<dynamic> operator [](int index) {
    if (index < 0 || index >= _data.length) {
      throw Exception('Index is out of range');
    }
    return _data[index];
  }

  /// Compares two matrices for inequality. Returns true if the matrices have different dimensions or any elements are not equal, otherwise false.
  ///
  /// [other]: The other Matrix object to compare.
  ///
  /// Example:
  /// ```dart
  /// var m1 = Matrix([[1, 2], [3, 4]]);
  /// var m2 = Matrix([[1, 2], [3, 5]]);
  /// print(m1.equal(m2)); // Output: false
  ///```
  bool equal(Object other) => (this == other);

  /// Compares two matrices for inequality. Returns true if the matrices have different dimensions or any elements are not equal, otherwise false.
  ///
  /// [other]: The other Matrix object to compare.
  ///
  /// Example:
  /// ```dart
  /// var m1 = Matrix([[1, 2], [3, 4]]);
  /// var m2 = Matrix([[1, 2], [3, 5]]);
  /// print(m1.notEqual(m2)); // Output: true
  ///```
  bool notEqual(Object other) => !(this == other);

  /// Creates a square Matrix with the specified diagonal elements.
  ///
  /// [diagonal]: `List<dynamic>` containing the diagonal elements.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix.fromDiagonal([1, 2, 3]);
  /// print(m);
  /// // Output:
  /// // Matrix: 3x3
  /// // ┌ 1 0 0 ┐
  /// // │ 0 2 0 │
  /// // └ 0 0 3 ┘
  /// ```
  factory Matrix.fromDiagonal(List<dynamic> diagonal) {
    if (diagonal.isEmpty) {
      throw Exception('Diagonal cannot be null or empty');
    }
    int n = diagonal.length;
    List<List<dynamic>> data = List.generate(
        n, (i) => List.generate(n, (j) => i == j ? diagonal[i] : 0));
    return Matrix(data);
  }

  /// Creates a matrix from the given list of lists.
  ///
  /// [list]: The input list of lists containing elements to populate the matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix.fromList([[1, 2], [3, 4], [5, 6]]);
  /// print(matrix);
  /// // Output:
  /// // Matrix: 3x2
  /// // ┌ 1  2 ┐
  /// // │ 3  4 │
  /// // └ 5  6 ┘
  /// ```
  factory Matrix.fromList(List<List<dynamic>> list) {
    return Matrix(list);
  }

  /// Constructs a new Matrix from a flattened list.
  ///
  /// This function takes a single-dimensional list and the desired number of
  /// rows and columns and returns a new Matrix with those dimensions, populated
  /// with the elements from the source list.
  ///
  /// The function fills the Matrix in row-major order, which means that it
  /// fills the first row from left to right, then moves on to the next row,
  /// and so on.
  ///
  /// Throws an `ArgumentError` if the provided list does not contain enough elements
  /// to fill the Matrix and `fillWithZeros` is `false`, or if `rows * cols` exceeds
  /// the size of the list.
  ///
  /// - [source]: A single-dimensional list containing the elements to populate
  ///             the new Matrix.
  /// - [rows]: The number of rows the new Matrix should have.
  /// - [cols]: The number of columns the new Matrix should have.
  /// - [fillWithZeros]: Whether the function should fill the remaining elements
  ///                    with zeros if the source list does not contain enough elements.
  ///                    Default is `true`.
  ///
  /// Example:
  /// ```dart
  /// final source = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];
  /// final matrix = Matrix.fromFlattenedList(source, 3, 5, fillWithZeros: true);
  /// print(matrix);
  /// // Output:
  /// // 1 2 3 4 5
  /// // 6 7 8 9 0
  /// // 0 0 0 0 0
  /// ```
  factory Matrix.fromFlattenedList(List<dynamic> source, int rows, int cols,
      {bool fillWithZeros = true}) {
    int sourceIndex = 0;
    if (!fillWithZeros && source.length < rows * cols) {
      throw ArgumentError(
          'List length is less than the matrix size and fillWithZeros is set to false');
    }
    List<List<dynamic>> data = List.generate(
        rows,
        (_) => List.generate(cols,
            (_) => sourceIndex < source.length ? source[sourceIndex++] : 0));
    return Matrix(data);
  }

  /// Constructs a Matrix from a list of Column vectors.
  ///
  /// All columns must have the same number of rows. Otherwise, an exception will be thrown.
  ///
  /// Example:
  /// ```dart
  /// var col1 = Column([1, 2, 3]);
  /// var col2 = Column([4, 5, 6]);
  /// var col3 = Column([7, 8, 9]);
  /// var matrix = Matrix.fromColumns([col1, col2, col3]);
  /// print(matrix);
  /// ```
  ///
  /// Output:
  /// ```
  /// 1 4 7
  /// 2 5 8
  /// 3 6 9
  /// ```
  factory Matrix.fromColumns(List<ColumnMatrix> columns,
      {bool resize = false}) {
    final numRows = columns[0].rowCount;
    for (ColumnMatrix col in columns) {
      if (col.rowCount != numRows) {
        throw Exception('All columns must have the same number of rows');
      }
    }

    List<List<dynamic>> data =
        List.generate(numRows, (i) => List.filled(columns.length, 0));
    for (int j = 0; j < columns.length; j++) {
      for (int i = 0; i < numRows; i++) {
        data[i][j] = columns[j].getValueAt(i);
      }
    }
    return Matrix(data);
  }

  /// Constructs a Matrix from a list of Row vectors.
  ///
  /// All rows must have the same number of columns. Otherwise, an exception will be thrown.
  ///
  /// Example:
  /// ```dart
  /// var row1 = Row([1, 2, 3]);
  /// var row2 = Row([4, 5, 6]);
  /// var row3 = Row([7, 8, 9]);
  /// var matrix = Matrix.fromRows([row1, row2, row3]);
  /// print(matrix);
  /// ```
  ///
  /// Output:
  /// ```
  /// 1 2 3
  /// 4 5 6
  /// 7 8 9
  /// ```
  factory Matrix.fromRows(List<RowMatrix> rows, {bool resize = false}) {
    final numCols = rows[0].columnCount;
    for (RowMatrix row in rows) {
      if (row.columnCount != numCols) {
        throw Exception('All rows must have the same number of columns');
      }
    }

    return Matrix(rows.map((row) => row.rows.first).toList());
  }

  /// Concatenates a list of matrices along the specified axis.
  ///
  /// The `matrices` list must contain at least one matrix. If `resize` is true,
  /// the matrices will be resized to match the size of the largest matrix along
  /// the axis of concatenation. If `resize` is false, the matrices must have the
  /// same size along the axis of concatenation, otherwise an exception will be thrown.
  ///
  /// The `axis` parameter determines the axis along which the matrices will be concatenated.
  /// If `axis` is 0, the matrices will be concatenated vertically (i.e., one below the other).
  /// If `axis` is 1, the matrices will be concatenated horizontally (i.e., one next to the other).
  ///
  /// Example:
  /// ```dart
  /// var matrix1 = Matrix([[1, 2], [3, 4]]);
  /// var matrix2 = Matrix([[5, 6], [7, 8]]);
  /// var concatenated = Matrix.concatenate([matrix1, matrix2], axis: 0);
  /// print(concatenated);
  /// ```
  ///
  /// Output:
  /// ```dart
  /// 1 2
  /// 3 4
  /// 5 6
  /// 7 8
  /// ```
  factory Matrix.concatenate(List<Matrix> matrices,
      {int axis = 0, bool resize = false}) {
    if (matrices.isEmpty) {
      throw ArgumentError("Matrices list cannot be null or empty");
    }

    if (axis != 0 && axis != 1) {
      throw ArgumentError("Invalid axis: Axis must be either 0 or 1");
    }

    Matrix first = matrices[0];
    int commonSize = (axis == 0 ? first.columnCount : first.rowCount);

    if (!resize) {
      for (var matrix in matrices) {
        if ((axis == 0 && matrix.columnCount != commonSize) ||
            (axis == 1 && matrix.rowCount != commonSize)) {
          throw Exception("Incompatible matrices for concatenation");
        }
      }
    }

    if (axis == 0) {
      List<List<dynamic>> data = [];
      for (Matrix matrix in matrices) {
        if (resize) {
          // Copy and resize rows
          for (List<dynamic> row in matrix) {
            data.add(row + List<dynamic>.filled(commonSize - row.length, 0));
          }
        } else {
          // Directly concatenate original rows
          data.addAll(matrix);
        }
      }
      return Matrix(data);
    } else {
      // axis == 1
      int maxRows = matrices.map((matrix) => matrix.rowCount).reduce(math.max);
      List<List<dynamic>> data = List.generate(maxRows, (_) => []);
      for (Matrix matrix in matrices) {
        for (int i = 0; i < maxRows; i++) {
          if (i < matrix.rowCount) {
            if (resize) {
              // Copy and resize row
              data[i] += matrix[i] +
                  List<dynamic>.filled(commonSize - matrix[i].length, 0);
            } else {
              // Directly concatenate original row
              data[i] += matrix[i];
            }
          } else {
            // Add padding row
            data[i] += List<dynamic>.filled(commonSize, 0);
          }
        }
      }
      return Matrix(data);
    }
  }

  /// Creates a matrix with random elements of type double or int.
  ///
  /// [rowCount]: The number of rows in the matrix.
  /// [columnCount]: The number of columns in the matrix.
  /// [min]: The minimum value for the random elements (inclusive). Default is 0.
  /// [max]: The maximum value for the random elements (exclusive). Default is 1.
  /// [isDouble]: If true, generates random doubles. If false, generates random integers. Default is true.
  /// [random]: A `Random` object to generate random numbers. If not provided, a new `Random` object will be created.
  /// [seed]: An optional seed for the random number generator for reproducible randomness. If not provided, the randomness is not reproducible.
  ///
  /// Example:
  /// ```dart
  /// var randomMatrix = Matrix.random(3, 4, min: 1, max: 10, isDouble: false);
  /// print(randomMatrix);
  /// // Output:
  /// // Matrix: 3x4
  /// // ┌ 3  5  9  2 ┐
  /// // │ 1  7  6  8 │
  /// // └ 4  9  1  3 ┘
  /// ```
  factory Matrix.random(int rowCount, int columnCount,
      {double min = 0,
      double max = 1,
      bool isDouble = true,
      math.Random? random,
      int? seed}) {
    return Matrix.factory.create(MatrixType.general, rowCount, columnCount,
        min: min, max: max, random: random, seed: seed, isDouble: isDouble);
  }

  /// Creates a Matrix of the specified dimensions with all elements set to 0.
  ///
  /// [rows]: Number of rows.
  /// [cols]: Number of columns.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix.zeros(2, 3);
  /// print(m);
  /// // Output:
  /// // Matrix: 2x3
  /// // ┌ 0 0 0 ┐
  /// // └ 0 0 0 ┘
  /// ```
  factory Matrix.zeros(int rows, int cols, {bool isDouble = false}) {
    return Matrix.factory
        .create(MatrixType.zeros, rows, cols, isDouble: isDouble);
  }

  /// Creates a Matrix of the specified dimensions with all elements set to 1.
  ///
  /// [rows]: Number of rows.
  /// [cols]: Number of columns.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix.ones(2, 3);
  /// print(m);
  /// // Output:
  /// // Matrix: 2x3
  /// // ┌ 1 1 1 ┐
  /// // └ 1 1 1 ┘
  /// ```
  factory Matrix.ones(int rows, int cols, {bool isDouble = false}) {
    return Matrix.factory
        .create(MatrixType.ones, rows, cols, isDouble: isDouble);
  }

  /// Creates a square identity Matrix of the specified size.
  ///
  /// [size]: Number of rows and columns.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix.eye(3);
  /// print(m);
  /// // Output:
  /// // Matrix: 3x3
  /// // ┌ 1 0 0 ┐
  /// // │ 0 1 0 │
  /// // └ 0 0 1 ┘
  /// ```
  // Method to create an identity matrix.
  factory Matrix.eye(int size, {bool isDouble = false}) {
    return Matrix.factory
        .create(MatrixType.identity, size, size, isDouble: isDouble);
  }

  /// Method to create a scalar matrix.
  /// Example:
  /// ```dart
  /// var m = Matrix.scalar(3);
  /// print(m);
  /// // Output:
  /// // Matrix: 3x3
  /// // ┌ 3 0 0 ┐
  /// // │ 0 3 0 │
  /// // └ 0 0 3 ┘
  /// ```
  factory Matrix.scalar(int size, dynamic value) {
    if (value is! num) {
      throw ArgumentError('Value must be a number (int or double)');
    }

    return Matrix.factory.create(MatrixType.identity, size, size,
        value: value, isDouble: value is double);
  }

  /// Constructs a new `Matrix` from smaller square matrices (blocks).
  ///
  /// The blocks of the matrix are specified in a two-dimensional list, with each inner list
  /// representing a row of blocks. This allows you to construct a large matrix from
  /// smaller matrices, each representing a block of the larger one.
  ///
  /// It's essential that all block matrices are square and of the same size. This constructor
  /// will throw an `ArgumentError` if the blocks are not all the same size, or if they're not
  /// all square matrices.
  ///
  /// Example:
  /// ```dart
  /// var block1 = Matrix([
  ///   [1, 2],
  ///   [3, 4]
  /// ]);
  /// var block2 = Matrix([
  ///   [5, 6],
  ///   [7, 8]
  /// ]);
  /// var block3 = Matrix([
  ///   [9, 10],
  ///   [11, 12]
  /// ]);
  /// var block4 = Matrix([
  ///   [13, 14],
  ///   [15, 16]
  /// ]);
  /// var matrix = Matrix.fromBlocks([
  ///   [block1, block2],
  ///   [block3, block4]
  /// ]);
  /// print(matrix);
  /// ```
  ///
  /// Output:
  /// ```plaintext
  /// Matrix: 4x4
  /// ┌  1   2   5   6 ┐
  /// |  3   4   7   8 |
  /// |  9  10  13  14 |
  /// └ 11  12  15  16 ┘
  /// ```
  ///
  /// [blocks]: A 2D list of square `Matrix` objects that will be used to create
  /// the new `Matrix`. All matrices must be of the same size.
  factory Matrix.fromBlocks(List<List<Matrix>> blocks) {
    int rows = blocks.length;
    int cols = blocks[0].length;
    int blockSize = blocks[0][0]._data.length;

    // Check for block validity and uniformity.
    for (var blockRow in blocks) {
      if (blockRow.length != cols) {
        throw ArgumentError('All rows of blocks must have the same length.');
      }

      for (var block in blockRow) {
        if (block._data.length != blockSize ||
            block._data[0].length != blockSize) {
          throw ArgumentError(
              'All blocks must be square matrices and have the same dimensions.');
        }
      }
    }

    // Pre-compute the final size of the matrix and allocate memory at once.
    List<List<dynamic>> matrix = List.generate(
        rows * blockSize, (_) => List<num>.filled(cols * blockSize, 0));

    // Re-order loops for more linear data access.
    for (int row = 0; row < blockSize; ++row) {
      for (int col = 0; col < blockSize; ++col) {
        for (int blockRow = 0; blockRow < rows; ++blockRow) {
          for (int blockCol = 0; blockCol < cols; ++blockCol) {
            matrix[blockSize * blockRow + row][blockSize * blockCol + col] =
                blocks[blockRow][blockCol]._data[row][col];
          }
        }
      }
    }

    return Matrix(matrix);
  }

  /// Generates a magic square of the given size.
  ///
  /// A magic square is an `n x n` matrix filled with distinct positive integers
  /// from `1` to `n^2` that add up to the same number in each row, column, and diagonal.
  ///
  /// This function throws an [ArgumentError] if the input size `n` is non-positive or equals to 2,
  /// since a magic square is not possible for these values.
  ///
  /// Example:
  /// ```dart
  /// final magicSquare = Matrix.magic(3);
  /// print(magicSquare);
  /// ```
  ///
  /// Output:
  /// ```dart
  /// // Matrix: 3x3
  /// // ┌ 8 1 6 ┐
  /// // | 3 5 7 |
  /// // └ 4 9 2 ┘
  /// ```
  factory Matrix.magic(int n) {
    if (n < 3) {
      throw ArgumentError("Size must be at least 3");
    }

    var result = Matrix.zeros(n, n);

    if (math.isOdd(n)) {
      // Odd order case remains the same (Siamese method).
      var p = List<int>.generate(n, (i) => i + 1);
      var nPlus3Over2 = (n + 3) ~/ 2;

      for (var i = 0; i < n; i++) {
        for (var j = 0; j < n; j++) {
          result[i][j] = n * ((p[i] + p[j] - nPlus3Over2) % n) +
              (p[i] + 2 * p[j] - 2) % n +
              1;
        }
      }
    } else if (math.isDivisible(n, 4)) {
      // Doubly even order case for n divisible by 4(Bachmann's Method)
      var J = List<int>.generate(n, (i) => (i + 1) % 4 ~/ 2);
      for (var i = 0; i < n; i++) {
        for (var j = 0; j < n; j++) {
          result[i][j] = i * n + j + 1;
          if (J[i] == J[j]) {
            result[i][j] = n * n + 1 - result[i][j];
          }
        }
      }
    } else {
      // LUX method for singly even numbers
      var p = n ~/ 2;
      // Recursive call to generate smaller magic square
      var M = Matrix.magic(p);

      var p2 = p * p;
      var m3p2 = 3 * p2;
      var m2p2 = 2 * p2;

      // Populate quadrants with values
      for (var i = 0; i < p; i++) {
        for (var j = 0; j < p; j++) {
          var val = M[i][j];
          result[i][j] = val;
          result[i + p][j] = val + m3p2;
          result[i][j + p] = val + m2p2;
          result[i + p][j + p] = val + p2;
        }
      }
      var k = (n - 2) ~/ 4;
      var j = List<int>.generate(k, (idx) => idx)
        ..addAll(List<int>.generate(k, (idx) => n - k + idx));

      for (var x = 0; x < p; x++) {
        for (var y in j) {
          if (y < n) {
            var tmp = result[x][y];
            result[x][y] = result[x + p][y];
            result[x + p][y] = tmp;
          }
        }
      }

      // Swap corners
      var tmp = result[k][0];
      result[k][0] = result[k + p][0];
      result[k + p][0] = tmp;

      tmp = result[k][k];
      result[k][k] = result[k + p][k];
      result[k + p][k] = tmp;

      int swapColumnIndex = (n - 6) ~/ 4 + 1;
      var swapColumn =
          result.column(result.columnCount - swapColumnIndex).asList;

      result.setColumn(result.columnCount - swapColumnIndex,
          [...swapColumn.sublist(n ~/ 2), ...swapColumn.sublist(0, n ~/ 2)]);
    }
    return result;
  }

  /// Creates a Matrix of the specified dimensions with all elements set to the specified value.
  ///
  /// [rows]: Number of rows.
  /// [cols]: Number of columns.
  /// [value]: Value to fill the matrix with.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix.fill(2, 3, 7);
  /// print(m);
  /// // Output:
  /// // Matrix: 2x3
  /// // ┌ 7 7 7 ┐
  /// // └ 7 7 7 ┘
  /// ```
  factory Matrix.fill(int rows, int cols, dynamic value) {
    return Matrix.factory.create(MatrixType.general, rows, cols,
        value: value, isDouble: value is double);
  }

  /// Creates a row Matrix with equally spaced values between the start and end values (inclusive).
  ///
  /// [start]: Start value.
  /// [end]: End value.
  /// [number]: Number of equally spaced points. Default is 50.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix.linespace(0, 10, 3);
  /// print(m);
  /// // Output:
  /// // Matrix: 1x3
  /// // [ 0 5 10 ]
  /// ```
  factory Matrix.linspace(int start, int end, [int number = 50]) {
    if (start.runtimeType != end.runtimeType) {
      throw Exception('Start and end must be of the same type');
    }

    if (number <= 0) {
      throw ArgumentError('Number must be a positive integer');
    }

    List<List<dynamic>> data = [];

    double step = (end - start) / (number - 1);
    List<dynamic> row = [];
    for (int i = 0; i < number; i++) {
      row.add(start + i * step);
    }
    data.add(row);

    return Matrix(data);
  }

  /// Creates a Matrix with values in the specified range, incremented or decremented by the specified step size.
  ///
  /// [end]: End value (exclusive).
  /// [start]: Start value. Default is 0.
  /// [step]: Step size. Default is 1. Can be negative for decrementing ranges.
  /// [isColumn]: If true, creates a column matrix. Default is false (creates a row matrix).
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix.range(6,  start: 1, step: 2, isColumn: true);
  /// print(m);
  /// // Output:
  /// // Matrix: 3x1
  /// // ┌ 1 ┐
  /// // | 3 |
  /// // └ 5 ┘
  /// ```
  factory Matrix.range(int end,
      {int start = 0, int step = 1, bool isColumn = false}) {
    if (step == 0) {
      throw ArgumentError('Step must not be zero');
    }

    if (step > 0 && start >= end) {
      throw ArgumentError(
          'Start must be less than end for positive step sizes');
    }

    if (step < 0 && start <= end) {
      throw ArgumentError(
          'Start must be greater than end for negative step sizes');
    }

    List<dynamic> range = [];
    for (int i = start; step > 0 ? i < end : i > end; i += step) {
      range.add(i);
    }

    if (isColumn) {
      return Matrix(range.map((x) => [x]).toList());
    } else {
      return Matrix([range]);
    }
  }

  /// Alias for Matrix.range.
  factory Matrix.arrange(int end,
      {int start = 0, int step = 1, bool isColumn = false}) {
    return Matrix.range(end, start: start, step: step, isColumn: isColumn);
  }

  /// Computes the distance between two matrices.
  ///
  /// The method supports several types of matrix distances, defined by the `MatrixDistanceType` enum.
  /// These include:
  /// - Frobenius: The square root of the sum of the absolute squares of its elements, often used when matrices have the same dimensions.
  /// - Manhattan: The sum of the absolute values of its elements.
  /// - Chebyshev: The maximum absolute row or column sum norm.
  /// - Spectral: The largest singular value of the matrix, i.e., the square root of the largest eigenvalue of the matrix's hermitian transpose multiplied by the matrix.
  /// - Trace: The sum of the absolute values of eigenvalues (also equals to the sum of absolute values of singular values).
  ///
  /// The distance is computed as the norm of the difference between the two matrices, `m1` and `m2`.
  ///
  /// [m1]: The first matrix.
  /// [m2]: The second matrix.
  /// [distanceType]: The type of matrix distance to compute. Default is `DistanceType.frobenius`.
  ///
  /// Throws an `Exception` if an invalid distance type is provided.
  ///
  /// Example:
  /// ```dart
  /// var m1 = Matrix([[1, 2], [3, 4]]);
  /// var m2 = Matrix([[5, 6], [7, 8]]);
  /// print(Matrix.distance(m1, m2, distanceType: DistanceType.frobenius));
  /// // Output: 8.0
  /// ```
  ///
  /// Returns the computed distance between `m1` and `m2` according to `distanceType`.
  static num distance(Matrix m1, Matrix m2,
      {DistanceType distance = DistanceType.frobenius}) {
    switch (distance) {
      case DistanceType.frobenius:
        return (m1 - m2).norm();
      case DistanceType.manhattan:
        return (m1 - m2).norm(Norm.manhattan);
      case DistanceType.chebyshev:
        return (m1 - m2).norm(Norm.chebyshev);
      case DistanceType.spectral:
        return (m1 - m2).norm(Norm.spectral);
      case DistanceType.trace:
        return (m1 - m2).norm(Norm.trace);
      case DistanceType.cosine:
      // // Flatten the matrices and compute cosine distance
      // return Vector.fromList(_Utils.toSDList(m1.flatten())).distance(
      //     Vector.fromList(_Utils.toSDList(m2.flatten())),
      //     distanceType: DistanceType.cosine);
      case DistanceType.hamming:
      // // Flatten the matrices and compute hamming distance
      // return Vector.fromList(_Utils.toSDList(m1.flatten())).distance(
      //     Vector.fromList(_Utils.toSDList(m2.flatten())),
      //     distanceType: DistanceType.hamming);
      default:
        throw Exception('Invalid distance type');
    }
  }

  /// Compares each element of the matrix to the specified value using the given comparison operator.
  /// Returns a new Matrix with boolean values as a result of the comparison.
  ///
  /// [matrix]: The input Matrix to perform the comparison on.
  /// [operator]: A string representing the comparison operator ('>', '<', '>=', '<=', '==', '!=', '~=').
  /// Also performs a comparison on the element type ('is' and 'is!')
  /// [value]: The value to compare each element to.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix([[1, 2], [3, 4]]);
  /// var result = Matrix.compare(m, '>', 2);
  /// print(result);
  /// // Output:
  /// // Matrix: 2x2
  /// // ┌ false false ┐
  /// // └ true true   ┘
  /// ```
  static Matrix compare(Matrix matrix, String operator, dynamic value,
      {double tolerance = 1e-6}) {
    _Utils.defaultTolerance = tolerance;

    if (!_Utils.comparisonFunctions.containsKey(operator)) {
      throw Exception('Invalid operator');
    }

    var compareFunc = _Utils.comparisonFunctions[operator];

    var result = matrix
        .map((row) => row.map((item) => compareFunc!(item, value)).toList())
        .toList();

    return Matrix(result);
  }

  /// Importing from binary
  /// byteData: ByteData object containing the matrix data
  /// jsonFormat (optional): Set to true to use JSON string format, false to use binary format (default: false)
  ///
  /// Expected output:
  /// m1 and m2 will be matrices with the same values as the original matrix stored in the ByteData object.
  ///
  /// Example:
  /// ```dart
  /// Matrix m1 = Matrix.fromBinary(byteData, jsonFormat: false); // Binary format
  /// Matrix m2 = Matrix.fromBinary(byteData, jsonFormat: true); // JSON format
  /// ```
  static Matrix fromBinary(ByteData byteData, {bool jsonFormat = false}) {
    if (jsonFormat) {
      String jsonString = utf8.decode(byteData.buffer.asUint8List());
      return fromJSON(jsonString: jsonString);
    } else {
      int numRows = byteData.getInt32(0, Endian.little);
      int numCols = byteData.getInt32(4, Endian.little);
      int offset = 8;

      List<List<double>> rows =
          List.generate(numRows, (_) => List.filled(numCols, 0.0));
      for (int i = 0; i < numRows; i++) {
        for (int j = 0; j < numCols; j++) {
          rows[i][j] = byteData.getFloat64(offset, Endian.little);
          offset += 8;
        }
      }

      return Matrix.fromList(rows);
    }
  }

  /// Exporting to binary
  /// jsonFormat (optional): Set to true to use JSON string format, false to use binary format (default: false)
  ///
  /// Expected output:
  /// bd1 and bd2 will be ByteData objects containing the matrix data in the chosen format
  ///
  /// Example:
  /// ```data
  /// ByteData bd1 = matrix.toBinary(jsonFormat: false); // Binary format
  /// ByteData bd2 = matrix.toBinary(jsonFormat: true); // JSON format
  /// ```
  ByteData toBinary({bool jsonFormat = false}) {
    if (jsonFormat) {
      String jsonString = toJSON();
      return ByteData.view(utf8.encoder.convert(jsonString).buffer);
    } else {
      int numRows = rowCount;
      int numCols = columnCount;
      int bufferSize = 8 + numRows * numCols * 8;
      ByteData byteData = ByteData(bufferSize);

      byteData.setInt32(0, numRows, Endian.little);
      byteData.setInt32(4, numCols, Endian.little);
      int offset = 8;

      for (int i = 0; i < numRows; i++) {
        for (int j = 0; j < numCols; j++) {
          byteData.setFloat64(offset, this[i][j], Endian.little);
          offset += 8;
        }
      }
      return byteData;
    }
  }

  /// Importing from JSON
  ///
  /// [jsonString]: A JSON-formatted string containing the matrix data.
  /// [inputFilePath]: A file path to a JSON file containing the matrix data.
  ///
  /// Example:
  /// ```dart
  /// Matrix myMatrix = Matrix.fromJSON(inputFilePath: 'path/to/matrix_data.json');
  /// ```
  /// Output:
  ///
  /// myMatrix will be constructed from the data in the specified JSON file.
  static Matrix fromJSON({String? jsonString, String? inputFilePath}) {
    if (jsonString == null && inputFilePath != null) {

      // Read file
      fileIO.readFromFile(inputFilePath).then((data) {
        jsonString = data;
      });
    } else if (jsonString == null) {
      throw ArgumentError(
          'Either jsonString or inputFilePath must be provided.');
    }

    List<List> rows = jsonDecode(jsonString!);
    return Matrix.fromList(rows);
  }

  /// Exporting to JSON
  ///
  /// [outputFilePath]: An optional file path to save the JSON representation of the matrix.
  ///
  /// Example:
  /// ```dart
  /// String jsonOutput = myMatrix.toJSON(outputFilePath: 'path/to/output_file.json');
  /// ```
  /// Output:
  ///
  /// The JSON representation of myMatrix will be saved to the specified file path, and
  /// jsonOutput will contain the JSON-formatted string.
  String toJSON({String? outputFilePath}) {
    String jsonString = jsonEncode(toList());

    if (outputFilePath != null) {
      // Save file
      fileIO.saveToFile(outputFilePath, jsonString);
    }

    return jsonString;
  }

  /// Creates a Matrix object from a CSV string or a CSV file.
  ///
  /// This method reads the CSV string or a CSV file specified by the input file path,
  /// using the specified delimiter, and constructs a Matrix object.
  ///
  /// [csv]: The CSV string to create the Matrix from (optional).
  /// [delimiter]: The delimiter to use in the CSV string (default: ',').
  /// [inputFilePath]: The input file path to read the CSV string from (optional).
  ///
  /// Example:
  /// ```dart
  /// String csv = '''
  /// 1.0,2.0,3.0
  /// 4.0,5.0,6.0
  /// 7.0,8.0,9.0
  /// ''';
  /// Matrix matrix = await Matrix.fromCSV(csv: csv);
  /// print(matrix);
  ///
  /// // Alternatively, read the CSV from a file:
  /// Matrix matrixFromFile = await Matrix.fromCSV(inputFilePath: 'input.csv');
  /// print(matrixFromFile);
  /// ```
  ///
  /// Output:
  /// ```
  /// Matrix: 3x3
  /// ┌ 1.0 2.0 3.0 ┐
  /// │ 4.0 5.0 6.0 │
  /// └ 7.0 8.0 9.0 ┘
  /// ```
  ///
  static Future<Matrix> fromCSV(
      {String? csv, String delimiter = ',', String? inputFilePath}) async {
    if (csv == null && inputFilePath != null) {
      // Read file
      fileIO.readFromFile(inputFilePath).then((data) {
        csv = data;
      });
    } else if (csv == null) {
      throw ArgumentError('Either csv or inputFilePath must be provided.');
    }

    List<List> rows = csv!
        .trim()
        .split('\n')
        .map((row) =>
            row.split(delimiter).map((value) => double.parse(value)).toList())
        .toList();
    return Matrix.fromList(rows);
  }

  /// Converts the Matrix to a CSV string and optionally saves it to a file.
  ///
  /// This method converts the Matrix object to a CSV string, using the specified delimiter.
  /// If an output file path is provided, the CSV string will be saved to that file.
  ///
  /// [delimiter]: The delimiter to use in the CSV string (default: ',').
  /// [outputFilePath]: The output file path to save the CSV string (optional).
  ///
  /// Example:
  /// ```dart
  /// Matrix matrix = Matrix.fromList([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9]
  /// ]);
  /// String csv = matrix.toCSV(outputFilePath: 'output.csv');
  /// print(csv);
  /// ```
  ///
  /// Output:
  /// ```
  /// 1.0,2.0,3.0
  /// 4.0,5.0,6.0
  /// 7.0,8.0,9.0
  /// ```
  ///
  Future<String> toCSV({String delimiter = ',', String? outputFilePath}) async {
    String csv =
        map((row) => row.map((value) => value.toString()).join(delimiter))
            .toList()
            .join('\n');

    if (outputFilePath != null) {
      // Save file
      fileIO.saveToFile(outputFilePath, csv);
    }

    return csv;
  }

  /// Returns the row at the specified index as a Row object.
  ///
  /// [index]: Index of the row.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix([[1, 2], [3, 4]]);
  /// var row = m.row(1);
  /// print(row);
  /// // Output:
  /// // Matrix: 1x2
  /// // [ 3 4 ]
  /// ```
  RowMatrix row(int index) => RowMatrix(_data[index]);

  /// Returns the column at the specified index as a Column object.
  ///
  /// [index]: Index of the column.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix([[1, 2], [3, 4]]);
  /// var col = m.column(1);
  /// print(col);
  /// // Output:
  /// // Matrix: 2x1
  /// // ┌ 2 ┐
  /// // └ 4 ┘
  /// ```
  ColumnMatrix column(int index) =>
      ColumnMatrix(_data.map((row) => row[index]).toList());

  /// Extracts the diagonal elements from the matrix based on the given offset.
  ///
  /// The function accepts an optional integer parameter `k` which represents the
  /// offset from the leading diagonal. A positive value of `k` extracts the
  /// super-diagonal elements, while a negative value extracts the sub-diagonal
  /// elements.
  ///
  /// The optional `reverse` parameter will reverse the order of the rows before
  /// extracting the diagonal, thus returning the diagonal from bottom-left to top-right.
  ///
  /// Example:
  /// ```dart
  /// var A = Matrix.fromList([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9]
  /// ]);
  ///
  /// var mainDiagonal = A.diagonal(); // [1, 5, 9]
  /// var subDiagonal = A.diagonal(k: -1); // [4, 8]
  /// var superDiagonal = A.diagonal(k: 1); // [2, 6]
  /// var reverseDiagonal = A.diagonal(reverse: true); // [7, 5, 3]
  /// var reverseSuperDiagonal =A.diagonal(k: -1, reverse: true); // [4, 2]
  /// var reverseSubDiagonal =A.diagonal(k: 1, reverse: true); // [8, 6]
  /// ```
  List<dynamic> diagonal({int k = 0, reverse = false}) {
    List<dynamic> diagonal = [];
    int n = _data.length;

    var data = reverse ? _data.reversed.toList() : _data;

    if (k > 0) {
      for (int i = 0; i < n - k; i++) {
        diagonal.add(data[i][i + k]);
      }
    } else if (k < 0) {
      for (int i = 0; i < n + k; i++) {
        diagonal.add(data[i - k][i]);
      }
    } else {
      for (int i = 0; i < n; i++) {
        diagonal.add(data[i][i]);
      }
    }

    return diagonal;
  }

  /// Returns the indices of occurrences of the specified element in the matrix.
  /// If [findAll] is set to true, returns a `List<List<int>>` of all indices where the element was found.
  /// If [findAll] is false or not provided, returns a `List<int> `of the first occurrence.
  /// Returns null if the element is not found.
  ///
  /// [element]: The element to search for in the matrix.
  /// [findAll]: Whether to find all occurrences of the element.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix([[1, 2, 1], [3, 1, 4], [1, 5, 6]]);
  /// var singleIndex = m.indicesOf(1);
  /// print(singleIndex);
  /// // Output: [0, 0]
  /// var allIndices = m.indicesOf(1, findAll: true);
  /// print(allIndices);
  /// // Output: [[0, 0], [0, 2], [1, 1], [2, 0]]
  /// ```
  dynamic indexOf(dynamic element, {bool findAll = false}) {
    List<List<int>> allIndices = [];

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < _data[i].length; j++) {
        if (_data[i][j] == element) {
          if (!findAll) {
            return [i, j];
          }
          allIndices.add([i, j]);
        }
      }
    }

    if (findAll) {
      return allIndices.isNotEmpty ? allIndices : null;
    }

    return null;
  }

  /// Compares two matrices for equality. Returns true if the matrices have the same dimensions and all elements are equal, otherwise false.
  ///
  /// [other]: The other Matrix object to compare.
  ///
  /// Example:
  /// ```dart
  /// var m1 = Matrix([[1, 2], [3, 4]]);
  /// var m2 = Matrix([[1, 2], [3, 4]]);
  /// print(m1 == m2); // Output: true
  /// ```
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final Matrix otherMatrix = other as Matrix;
    if (rowCount != otherMatrix.rowCount ||
        columnCount != otherMatrix.columnCount) {
      return false;
    }
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (_data[i][j] != otherMatrix[i][j]) {
          return false;
        }
      }
    }
    return true;
  }

  // @override  //performance optimization
  // int get hashCode {
  //   const int numberOfElements = 10;
  //   int rowStride = rowCount < numberOfElements ? 1 : rowCount ~/ numberOfElements;
  //   int colStride = columnCount < numberOfElements ? 1 : columnCount ~/ numberOfElements;
  //   int result = 17;
  //   for (int i = 0; i < rowCount; i += rowStride) {
  //     for (int j = 0; j < columnCount; j += colStride) {
  //       result = result * 31 + this[i, j].hashCode;
  //     }
  //   }
  //   result = result * 31 + rowCount.hashCode;   // Include rowCount in hash computation
  //   result = result * 31 + columnCount.hashCode; // Include columnCount in hash computation
  //   return result;
  // }

  @override
  int get hashCode {
    int result = 17;
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result = 37 * result + _data[i][j].hashCode;
      }
    }
    return result;
  }

  /// Returns a string representation of the matrix with its shape and elements separated by the specified separator.
  ///
  /// [separator]: A string used to separate matrix elements in a row. Default is a space character (' ').
  /// [alignment]: An enum indicating the alignment of the elements in each column. Default is MatrixAlign.right.
  /// [isPrettyMatrix]: A bool indicating the output matrix string should have square around it. Default is true.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix([[1, 2], [3, 4]]);
  /// print(m.toString(separator: ' ', isPrettyMatrix : true, alignment: MatrixAlign.right));
  /// // Output:
  /// // Matrix: 2x2
  /// // ┌ 1 2 ┐
  /// // └ 3 4 ┘
  /// ```
  @override
  String toString(
      {String separator = ' ',
      bool isPrettyMatrix = true,
      MatrixAlign alignment = MatrixAlign.right}) {
    return _Utils.matString(this,
        separator: separator,
        isPrettyMatrix: isPrettyMatrix,
        alignment: alignment);
  }

  /// Print a string representation of the matrix with its shape and elements separated by the specified separator.
  ///
  /// [separator]: A string used to separate matrix elements in a row. Default is a space character (' ').
  /// [alignment]: An enum indicating the alignment of the elements in each column. Default is MatrixAlign.right.
  /// [isPrettyMatrix]: A bool indicating the output matrix string should have square around it. Default is true.
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix([[1, 2], [3, 4]]);
  /// print(m.toString(separator: ' ', alignment: 'right'));
  /// // Output:
  /// // Matrix: 2x2
  /// // ┌ 1 2 ┐
  /// // └ 3 4 ┘
  /// ```
  void prettyPrint(
      {String separator = ' ',
      bool isPrettyMatrix = true,
      MatrixAlign alignment = MatrixAlign.right}) {
    print(_Utils.matString(this,
        separator: separator,
        isPrettyMatrix: isPrettyMatrix,
        alignment: alignment));
  }
}

class _MatrixIterable extends IterableBase<List<dynamic>> {
  final Matrix _matrix;
  final bool _columnMajor;

  _MatrixIterable(this._matrix, {columnMajor = false})
      : _columnMajor = columnMajor;

  @override
  Iterator<List<dynamic>> get iterator =>
      MatrixIterator(_matrix, columnMajor: _columnMajor);
}

class _MatrixElementIterable extends IterableBase<dynamic> {
  final Matrix _matrix;

  _MatrixElementIterable(this._matrix);

  @override
  Iterator<dynamic> get iterator => MatrixElementIterator(_matrix);
}
