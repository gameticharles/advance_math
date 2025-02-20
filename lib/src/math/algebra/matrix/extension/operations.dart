// ignore_for_file: unreachable_switch_default

part of '../../algebra.dart';

extension NumOperationExtension on num {
  dynamic operator +(dynamic other) {
    if (other is Matrix || other is Vector) {
      return -other + this;
    }
  }
}

extension MatrixOperationExtension on Matrix {
  /// Adds the given matrix to this matrix element-wise.
  ///
  /// [other]: The matrix to add to this matrix.
  ///
  /// Returns a new matrix containing the result of the element-wise addition.
  ///
  /// Example:
  /// ```dart
  /// var matrixA = Matrix([[1, 2], [3, 4]]);
  /// var matrixB = Matrix([[1, 1], [1, 1]]);
  /// var matrixC = matrixA + matrixB;
  /// print(matrixC);
  /// // Output:
  /// // 2  3
  /// // 4  5
  /// ```
  Matrix operator +(dynamic other) {
    if (other is Matrix) {
      if (rowCount != other.rowCount || columnCount != other.columnCount) {
        throw Exception('Cannot add matrices of different sizes');
      }

      List<List<dynamic>> newData = List.generate(rowCount,
          (i) => List.generate(columnCount, (j) => _data[i][j] + other[i][j]));

      return Matrix(newData);
    } else if (other is Vector) {
      if (rowCount != other.length) {
        throw ArgumentError(
            'Matrix and vector dimensions must match for addition.');
      }

      List<List<dynamic>> newData = List.generate(rowCount,
          (i) => List.generate(columnCount, (j) => _data[i][j] + other[i]));

      return Matrix(newData);
    } else if (other is num || other is Number) {
      List<List<dynamic>> newData = List.generate(
          rowCount,
          (i) => List.generate(
              columnCount,
              (j) =>
                  _data[i][j] +
                  (other is num ? Complex.fromReal(other) : other)));

      return Matrix(newData);
    } else {
      throw Exception('Invalid operand type');
    }
  }

  /// Subtracts the given matrix from this matrix element-wise.
  ///
  /// [other]: The matrix to subtract from this matrix.
  ///
  /// Returns a new matrix containing the result of the element-wise subtraction.
  ///
  /// Example:
  /// ```dart
  /// var matrixA = Matrix([[3, 4], [5, 6]]);
  /// var matrixB = Matrix([[1, 1], [1, 1]]);
  /// var matrixC = matrixA - matrixB;
  /// print(matrixC);
  /// // Output:
  /// // 2  3
  /// // 4  5
  /// ```
  Matrix operator -(dynamic other) {
    if (other is Matrix) {
      if (rowCount != other.rowCount || columnCount != other.columnCount) {
        throw Exception('Cannot subtract matrices of different sizes');
      }

      List<List<dynamic>> newData = List.generate(rowCount,
          (i) => List.generate(columnCount, (j) => _data[i][j] - other[i][j]));

      return Matrix(newData);
    } else if (other is Vector) {
      if (rowCount != other.length) {
        throw ArgumentError(
            "Matrix and vector dimensions must match for addition.");
      }

      List<List<dynamic>> newData = List.generate(rowCount,
          (i) => List.generate(columnCount, (j) => _data[i][j] - other[i]));

      return Matrix(newData);
    } else if (other is num || other is Number) {
      List<List<dynamic>> newData = List.generate(
          rowCount,
          (i) => List.generate(
              columnCount,
              (j) =>
                  _data[i][j] -
                  (other is num ? Complex.fromReal(other) : other)));

      return Matrix(newData);
    } else {
      throw Exception('Invalid operand type');
    }
  }

  /// Multiplies this matrix with another matrix or a scalar value.
  ///
  /// This method performs the multiplication operation based on the type of [other]:
  /// - If [other] is a [Matrix], it performs matrix multiplication. This operation
  ///   requires the number of columns in this matrix to equal the number of rows in the [other] matrix.
  /// - If [other] is a [num], it performs scalar multiplication. Each element in this matrix
  ///   is multiplied by the [other] scalar value.
  ///
  /// The function does not mutate the original matrix but instead returns a new
  /// matrix that is the result of the multiplication operation.
  ///
  /// Throws an [Exception] if:
  /// - [other] is a [Matrix] but the matrices have incompatible sizes for multiplication.
  /// - [other] is not a [Matrix] or a [num].
  ///
  /// Example:
  /// ```dart
  /// var matrixA = Matrix([
  ///   [1, 2],
  ///   [3, 4],
  /// ]);
  /// var matrixB = Matrix([
  ///   [2, 0],
  ///   [1, 2],
  /// ]);
  /// var resultMatrix = matrixA * matrixB;
  /// print(resultMatrix);
  /// // Output:
  /// // 4  4
  /// // 10 8
  ///
  /// var scalar = 2;
  /// var resultScalar = matrixA * scalar;
  /// print(resultScalar);
  /// // Output:
  /// // 2  4
  /// // 6  8
  /// ```
  Matrix operator *(dynamic other) {
    if (other is Matrix) {
      if (columnCount != other.rowCount) {
        throw Exception('Cannot multiply matrices of incompatible sizes');
      }

      // Define the size limit for switching to normal multiplication
      const int sizeLimit =
          64; // Adjust this value based on your performance testing

      // Switch to normal multiplication for small matrices
      if (rowCount <= sizeLimit ||
          columnCount <= sizeLimit ||
          other.columnCount <= sizeLimit) {
        return _normalMultiply(other);
      }

      // Otherwise, use Strassen's algorithm
      return _strassenMultiply(other);
    } else if (other is Vector) {
      if (columnCount != other.length) {
        throw ArgumentError(
            'The number of columns in the matrix must be equal to the length of the vector for multiplication.');
      }

      Vector result = Vector(rowCount);
      for (int i = 0; i < rowCount; i++) {
        for (int j = 0; j < columnCount; j++) {
          result[i] += this[i][j] * other[j];
        }
      }

      return ColumnMatrix(result.toList());
    } else if (other is num || other is Number) {
      return scale(other);
    } else {
      throw Exception('Invalid operand type ${other.runtimeType}');
    }
  }

  // Helper function to multiply small matrices
  Matrix _normalMultiply(Matrix other) {
    List<List<dynamic>> newData = List.generate(
        rowCount, (_) => List.filled(other.columnCount, Complex.zero()));

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < other.columnCount; j++) {
        for (int k = 0; k < columnCount; k++) {
          newData[i][j] += _data[i][k] * other[k][j];
        }
      }
    }

    return Matrix(newData);
  }

  // Helper function to multiply larger matrices
  Matrix _strassenMultiply(Matrix B) {
    Matrix A = this;

    // If matrices' sizes are not a power of 2, we fill them with zeroes
    int newSize = math
        .pow(
            2,
            (math.log(math.max(
                        math.max(A.rowCount, A.columnCount), B.columnCount)) /
                    math.log(2))
                .ceil())
        .toInt();

    Matrix a1 = Matrix.zeros(newSize, newSize, isDouble: true);
    Matrix b1 = Matrix.zeros(newSize, newSize, isDouble: true);

    for (int i = 0; i < A.rowCount; i++) {
      for (int j = 0; j < A.columnCount; j++) {
        a1[i][j] = A[i][j];
      }
    }
    for (int i = 0; i < B.rowCount; i++) {
      for (int j = 0; j < B.columnCount; j++) {
        b1[i][j] = B[i][j];
      }
    }

    Matrix C = a1._strassenRecursive(b1);

    Matrix c1 = Matrix.zeros(A.rowCount, B.columnCount, isDouble: true);
    for (int i = 0; i < c1.rowCount; i++) {
      for (int j = 0; j < c1.columnCount; j++) {
        c1[i][j] = C[i][j];
      }
    }

    return c1;
  }

  // Helper function to help multiply large matrices
  Matrix _strassenRecursive(Matrix B) {
    Matrix A = this;
    int size = A.rowCount;

    if (size == 1) {
      return A * B;
    }

    // Step 1: Dividing the matrices into quarters
    int newSize = size ~/ 2;

    // Ensure that the matrices are square and have dimensions that are a power of 2.
    if (newSize * 2 != size) {
      Matrix oldA = A;
      Matrix oldB = B;

      // Increase size to the next power of 2.
      size = size * 2;
      newSize = size ~/ 2;

      A = Matrix.zeros(size, size, isDouble: true);
      B = Matrix.zeros(size, size, isDouble: true);

      A.copyFrom(oldA, resize: false);
      B.copyFrom(oldB, resize: false);
    }

    // Divide matrices into quarters
    // Divide matrices into quarters
    Matrix a11 = A.slice(0, newSize, 0, newSize);
    Matrix a12 = A.slice(0, newSize, newSize, size);
    Matrix a21 = A.slice(newSize, size, 0, newSize);
    Matrix a22 = A.slice(newSize, size, newSize, size);

    Matrix b11 = B.slice(0, newSize, 0, newSize);
    Matrix b12 = B.slice(0, newSize, newSize, size);
    Matrix b21 = B.slice(newSize, size, 0, newSize);
    Matrix b22 = B.slice(newSize, size, newSize, size);

// Step 2: Calculating the seven products
    Matrix p1 = (a11) * (b12 - b22);
    Matrix p2 = (a11 + a12) * (b22);
    Matrix p3 = (a21 + a22) * (b11);
    Matrix p4 = (a22) * (b21 - b11);
    Matrix p5 = (a11 + a22) * (b11 + b22);
    Matrix p6 = (a12 - a22) * (b21 + b22);
    Matrix p7 = (a11 - a21) * (b11 + b12);

// Step 3: Calculating the four quarters of the resulting matrix
    Matrix c11 = p5 + p4 - p2 + p6;
    Matrix c12 = p1 + p2;
    Matrix c21 = p3 + p4;
    Matrix c22 = p1 + p5 - p3 - p7;

// Step 4: Combining the quarters into the resulting matrix
    Matrix C = Matrix.zeros(size, size, isDouble: true);
    C.setSubMatrix(0, 0, c11);
    C.setSubMatrix(0, newSize, c12);
    C.setSubMatrix(newSize, 0, c21);
    C.setSubMatrix(newSize, newSize, c22);

    return C;
  }

  /// Scales a matrix by a given factor.
  ///
  /// This method multiplies every element in the matrix by [scaleFactor].
  ///
  /// The function does not mutate the original matrix but instead returns a new
  /// matrix that is the result of the scaling operation.
  ///
  /// The parameter [scaleFactor] is a number by which every element of the matrix will be multiplied.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9],
  /// ]);
  ///
  /// var scaledMatrix = matrix.scale(2);
  ///
  /// print(scaledMatrix);
  /// ```
  ///
  /// Output:
  /// ```dart
  /// // Matrix: 3x3
  /// // ┌  2  4  6 ┐
  /// // │  8 10 12 │
  /// // └ 14 16 18 ┘
  /// ```
  Matrix scale(dynamic scaleFactor) {
    List<List<dynamic>> newData = [];

    for (int i = 0; i < rowCount; i++) {
      List<dynamic> row = [];
      for (int j = 0; j < columnCount; j++) {
        row.add(
            (scaleFactor is num ? Complex.fromReal(scaleFactor) : scaleFactor) *
                this[i][j]);
      }
      newData.add(row);
    }

    return Matrix(newData);
  }

  /// Rescales each column of the matrix to the range 0-1.
  ///
  /// It applies the Min-Max normalization technique on each column of the matrix.
  ///
  /// Example:
  /// ```dart
  /// var mat = Matrix.fromList([
  ///    [2, 3, 3, 3],
  ///    [9, 9, 8, 6],
  ///    [1, 1, 2, 9]
  /// ]);
  /// print(m.rescale());
  /// // Output:
  /// // Matrix: 3x4
  /// // ┌ 0.125 0.25 0.167 0.0 ┐
  /// // │   1.0  1.0   1.0 0.5 │
  /// // └   0.0  0.0   0.0 1.0 ┘
  /// ```
  Matrix rescale({Rescale rescaleBy = Rescale.column}) {
    var rescaledMatrix = Matrix.zeros(rowCount, columnCount, isDouble: true);

    switch (rescaleBy) {
      case Rescale.row:
        for (int i = 0; i < rowCount; i++) {
          var row = _Utils.toSDList(_data[i]);
          var maxElement = row.reduce(math.max);
          var minElement = row.reduce(math.min);

          for (int j = 0; j < columnCount; j++) {
            rescaledMatrix[i][j] =
                (this[i][j] - minElement) / (maxElement - minElement);
          }
        }

        return rescaledMatrix;
      case Rescale.column:
        for (int j = 0; j < columnCount; j++) {
          var col = _Utils.toSDList(column(j).asList);
          var maxElement = col.reduce(math.max);
          var minElement = col.reduce(math.min);

          for (int i = 0; i < rowCount; i++) {
            rescaledMatrix[i][j] =
                (this[i][j] - minElement) / (maxElement - minElement);
          }
        }

        return rescaledMatrix;
      case Rescale.all:
        var maxElement = max();
        var minElement = min();

        for (int i = 0; i < rowCount; i++) {
          for (int j = 0; j < columnCount; j++) {
            rescaledMatrix[i][j] =
                (this[i][j] - minElement) / (maxElement - minElement);
          }
        }

        return rescaledMatrix;
      default:
        throw Exception('Invalid RescaleType');
    }
  }

  /// Divides this matrix by a scalar value.
  ///
  /// [divisor]: The scalar value to divide this matrix by.
  ///
  /// Returns a new matrix containing the result of the scalar division.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[2, 4], [6, 8]]);
  /// var result = matrix / 2;
  /// print(result);
  /// // Output:
  /// // 1  2
  /// // 3  4
  /// ```
  Matrix operator /(dynamic other) {
    if (other is num || other is Number) {
      if (other == 0) {
        throw Exception('Cannot divide by zero');
      }

      List<List<dynamic>> newData = List.generate(
          rowCount,
          (i) => List.generate(
              columnCount,
              (j) =>
                  _data[i][j] /
                  (other is num ? Complex.fromReal(other) : other)));

      return Matrix(newData);
    } else {
      throw Exception(
          'Invalid operand type, division is only supported by scalar');
    }
  }

  /// Raises this matrix to the power of the given exponent using exponentiation by squaring.
  ///
  /// [exponent]: The non-negative integer exponent to raise this matrix to.
  ///
  /// Returns a new matrix containing the result of the exponentiation.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4]]);
  /// var result = matrix ^ 2;
  /// print(result);
  /// // Output:
  /// // 7   10
  /// // 15  22
  /// ```
  Matrix operator ^(int exponent) {
    if (rowCount != columnCount) {
      throw Exception('Cannot exponentiate non-square matrix');
    }

    if (exponent < 0) {
      throw Exception('Exponent must be a non-negative integer');
    }

    Matrix result = Matrix.eye(rowCount);
    Matrix base = Matrix(_data.map((row) => List<dynamic>.from(row)).toList());

    while (exponent > 0) {
      if (exponent % 2 == 1) {
        result = result.dot(base);
      }
      base = base.dot(base);
      exponent ~/= 2;
    }

    return result;
  }

  /// Negates this matrix element-wise.
  ///
  /// Returns a new matrix containing the result of the element-wise negation.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4]]);
  /// var result = -matrix;
  /// print(result);
  /// // Output:
  /// // -1 -2
  /// // -3 -4
  /// ```
  Matrix operator -() {
    List<List<dynamic>> newData = List.generate(
        rowCount, (i) => List.generate(columnCount, (j) => -_data[i][j]));

    return Matrix(newData);
  }

  /// Returns a new matrix with each element raised to the power of [exponent].
  ///
  /// Example:
  ///
  /// ```dart
  /// var matrix = Matrix([[1.0, 2.0], [3.0, 4.0]]);
  /// print(matrix.pow(2)); // Output: [[1.0, 4.0], [9.0, 16.0]]
  /// ```
  Matrix pow(num exponent) {
    return Matrix(_data
        .map((row) => row.map((cell) => math.pow(cell, exponent)).toList())
        .toList());
  }

  /// Returns a new matrix with the exponential of each element of the matrix.
  ///
  /// Example:
  ///
  /// ```dart
  /// var matrix = Matrix([[1.0, 2.0], [3.0, 4.0]]);
  /// print(matrix.exp()); // Output: [[2.718281828459045, 7.38905609893065], [20.085536923187668, 54.598150033144236]]
  /// ```
  // Matrix exp() {
  //   return Matrix(_data.map((row) => row.map(math.exp).toList()).toList());
  // }

  /// Multiplies the corresponding elements of this matrix and the given matrix.
  ///
  /// [other]: The matrix to element-wise multiply with this matrix.
  ///
  /// Returns a new matrix containing the result of the element-wise multiplication.
  ///
  /// Example:
  /// ```dart
  /// var matrixA = Matrix([[1, 2], [3, 4]]);
  /// var matrixB = Matrix([[2, 2], [2, 2]]);
  /// var result = matrixA.elementMultiply(matrixB);
  /// print(result);
  /// // Output:
  /// // 2  4
  /// // 6  8
  /// ```
  Matrix elementMultiply(Matrix other) {
    return elementWise(other, (a, b) => a * b);
  }

  /// Divides the corresponding elements of this matrix by the elements of the given matrix.
  ///
  /// [other]: The matrix to element-wise divide with this matrix.
  ///
  /// Returns a new matrix containing the result of the element-wise division.
  ///
  /// Example:
  /// ```dart
  /// var matrixA = Matrix([[2, 4], [6, 8]]);
  /// var matrixB = Matrix([[1, 2], [3, 4]]);
  /// var result = matrixA.elementDivide(matrixB);
  /// print(result);
  /// // Output:
  /// // 2  2
  /// // 2  2
  /// ```
  Matrix elementDivide(Matrix other) {
    return elementWise(other, (a, b) => a / b);
  }

  /// applies the given binary function element-wise on this matrix and the given matrix.
  ///
  /// [other]: The matrix to element-wise apply the function with this matrix.
  /// [f]: The binary function to apply element-wise on the matrices.
  ///
  /// Returns a new matrix containing the result of the element-wise function application.
  ///
  /// Example:
  /// ```dart
  /// var matrixA = Matrix([[1, 2], [3, 4]]);
  /// var matrixB = Matrix([[2, 3], [4, 5]]);
  /// var result = matrixA.elementWise(matrixB, (a, b) => a * b);
  /// print(result);
  /// // Output:
  /// // 2  6
  /// // 12 20
  /// ```
  Matrix elementWise(Matrix other, dynamic Function(dynamic, dynamic) f) {
    if (rowCount != other.rowCount || columnCount != other.columnCount) {
      throw Exception(
          "Matrices must have the same shape for element-wise operation");
    }

    List<List<dynamic>> newData = List.generate(rowCount,
        (i) => List.generate(columnCount, (j) => f(this[i][j], other[i][j])));
    return Matrix(newData);
  }

  /// Calculates the sum of the elements in the matrix along the specified axis.
  ///
  /// - If [axis] is null, the sum of all elements is returned.
  /// - If [axis] is 0, a list of sums of each column is returned.
  /// - If [axis] is 1, a list of sums of each row is returned.
  /// - If [axis] is 2, the sum of the diagonal elements is returned.
  /// If the matrix is non-square, the sum is of the elements from
  /// the top left to the bottom right, up to the point where the matrix ends.
  /// - If [axis] is 3, a list of sums of each main diagonal (top-left to bottom-right) is returned.
  /// - If [axis] is 4, a list of sums of each anti-diagonal (top-right to bottom-left) is returned.
  ///
  /// [absolute] (optional): If set to `true`, the absolute values of the elements are summed.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix.fromList([[1, 2, 3], [4, -5, 6], [-7, 8, 9]]);
  /// var nonSquareMatrix = Matrix.fromList([[1, 2, 3], [4, -5, 6]]);
  ///
  /// var totalSum = matrix.sum();
  /// print(totalSum); // Output: 21
  ///
  /// var rowSums = matrix.sum(axis: 1);
  /// print(rowSums); // Output: [6, 5, 10]
  ///
  /// var colSums = matrix.sum(axis: 0);
  /// print(colSums); // Output: [-2, 5, 18]
  ///
  /// var diagSum = matrix.sum(axis: 2);
  /// print(diagSum); // Output: 5
  ///
  /// var diagonalSumTLBR = matrix.sum(axis: 3);
  /// print(diagonalSumTLBR); // Output: [-7, 12, 5, 8, 3]
  ///
  /// var diagonalSumTRBL = matrix.sum(axis: 4);
  /// print(diagonalSumTRBL); // Output: [1, 6, -5, 14, 9]
  ///
  /// var diagSumNonSquare = nonSquareMatrix.sum(axis: 2);
  /// print(diagSumNonSquare); // Output: -4
  ///
  /// var diagonalNonSumTLBR = nonSquareMatrix.sum(axis: 3);
  /// print(diagonalNonSumTLBR); // Output: [4, -4, 8, 3]
  ///
  /// var diagonalNonSumTRBL = nonSquareMatrix.sum(axis: 4);
  /// print(diagonalNonSumTRBL); // Output: [1, 6, -2, 6]
  ///
  /// var totalSumAbs = matrix.sum(absolute: true);
  /// print(totalSumAbs); // Output: 45
  ///
  /// var rowSumsAbs = matrix.sum(axis: 1, absolute: true);
  /// print(rowSumsAbs); // Output: [6, 15, 24]
  ///
  /// var colSumsAbs = matrix.sum(axis: 0, absolute: true);
  /// print(colSumsAbs); // Output: [12, 15, 18]
  ///
  /// var diagSumAbs = matrix.sum(axis: 2, absolute: true);
  /// print(diagSumAbs); // Output: 15
  /// ```
  ///
  /// Returns zero(0) if the matrix is empty.
  /// Throws [ArgumentError] if [axis] is not null, 0, 1, 2, 3 or 4.
  dynamic sum({bool absolute = false, int? axis}) {
    if (_data.isEmpty) {
      return Complex.zero();
    }

    if (axis != null &&
        axis != 0 &&
        axis != 1 &&
        axis != 2 &&
        axis != 3 &&
        axis != 4) {
      throw ArgumentError(
          "Axis must be 0 (for columns), 1 (for rows), 2 (for diagonal), 3 (for main diagonal), 4 (for anti-diagonal),  or null (for total sum)");
    }

    switch (axis) {
      case 0:
        return List.generate(
            columnCount,
            (col) => _data
                .map((row) => absolute ? row[col].abs() : row[col])
                .reduce((value, element) => value + element));
      case 1:
        return _data
            .map((row) => row
                .map((e) => absolute ? e.abs() : e)
                .reduce((value, element) => value + element))
            .toList();
      case 2:
        int diagonalLength = math.min(rowCount, columnCount);
        dynamic diagonalSum = Complex.zero();
        for (int i = 0; i < diagonalLength; i++) {
          diagonalSum += absolute ? _data[i][i].abs() : _data[i][i];
        }
        return diagonalSum;

      case 3:
      case 4:
        List sums = [];
        var data = axis == 4 ? _data.reversed.toList() : _data;
        for (int offset = 1 - rowCount; offset < columnCount; offset++) {
          dynamic diagonalSum = Complex.zero();
          for (int row = 0; row < rowCount; row++) {
            int col = row + offset;
            if (col >= 0 && col < columnCount) {
              diagonalSum += absolute ? data[row][col].abs() : data[row][col];
            }
          }
          sums.add(diagonalSum);
        }
        return sums;

      default:
        dynamic sum = Complex.zero();
        for (dynamic element in elements) {
          sum += absolute ? element.abs() : element;
        }
        return sum;
    }
  }

  /// Performs cumulative sum operations similar to numpy's cumsum but with more flexibility.
  ///
  /// Parameters:
  /// - [continuous]: When true, continues accumulation across axis boundaries (default: false)
  /// - [axis]: The summation axis (null returns flattened list, 0-4 for matrix operations):
  ///   - null: Flattened list
  ///   - 0: Column-wise accumulation
  ///   - 1: Row-wise accumulation
  ///   - 2: Diagonal (top-left to bottom-right)
  ///   - 3: Diagonal (bottom-left to top-right)
  ///   - 4: Diagonal (top-right to bottom-left)
  ///
  /// Returns:
  /// - [List<dynamic>] when axis is null
  /// - [Matrix] when axis is specified
  ///
  /// Examples:
  /// ```
  /// var arr = Matrix([
  ///   [1, 5, 6],
  ///   [4, 7, 2],
  ///   [3, 1, 9]
  /// ]);
  ///
  /// print(arr.cumsum());
  /// // [1, 6, 12, 4, 11, 13, 3, 4, 13]
  ///
  /// print(arr.cumsum(continuous: true));
  /// // [1, 6, 12, 16, 23, 25, 28, 29, 38]
  ///
  /// print(arr.cumsum(axis: 0));
  /// // ┌ 1  5  6 ┐
  /// // │ 5 12  8 │
  /// // └ 8 13 17 ┘
  ///
  /// print(arr.cumsum(continuous: true, axis: 0));
  /// // ┌ 1 13 27 ┐
  /// // │ 5 20 29 │
  /// // └ 8 21 38 ┘
  ///
  /// print(arr.cumsum(axis: 1));
  /// // ┌ 1  6 12 ┐
  /// // │ 4 11 13 │
  /// // └ 3  4 13 ┘
  ///
  /// print(arr.cumsum(continuous: true, axis: 1));
  /// // ┌  1  6 12 ┐
  /// // │ 16 23 25 │
  /// // └ 28 29 38 ┘
  ///
  /// print(arr.cumsum(axis: 2));
  /// // ┌ 1 5  6 ┐
  /// // │ 4 8  7 │
  /// // └ 3 5 17 ┘
  ///
  /// print(arr.cumsum(continuous: true, axis: 2));
  /// // ┌ 9 30 38 ┐
  /// // │ 7 16 32 │
  /// // └ 3 8 25 ┘
  ///
  /// print(arr.cumsum(axis: 3));
  /// // ┌ 1 9  16 ┐
  /// // │ 4 10 3  │
  /// // └ 3 1  9  ┘
  ///
  /// print(arr.cumsum(continuous: true, axis: 3));
  /// // ┌ 38 37 28 ┐
  /// // │ 32 22 12 │
  /// // └ 15 10 9 ┘
  ///
  /// print(arr.cumsum(axis: 4));
  /// // ┌ 1  5  6 ┐
  /// // │ 9  13 2 │
  /// // └ 16 3  9 ┘
  ///
  /// print(arr.cumsum(continuous: true, axis: 4));
  /// // ┌ 38 33 18 ┐
  /// // │ 37 25 11 │
  /// // └ 28 12 9 ┘
  /// ```
  dynamic cumsum({bool continuous = false, int? axis}) {
    int rows = _data.length;
    int cols = _data[0].length;

    List<List<dynamic>> result =
        List.generate(rows, (i) => List.filled(cols, 0));

    switch (axis) {
      case null:
        if (continuous) {
          // Continuous accumulation across entire matrix
          List flat = [];
          dynamic cumulative = 0;
          for (var row in _data) {
            for (var val in row) {
              cumulative += val;
              flat.add(cumulative);
            }
          }
          return flat;
        } else {
          // Row-wise accumulation without continuity
          List flat = [];
          for (var row in _data) {
            dynamic rowSum = 0;
            for (var val in row) {
              rowSum += val;
              flat.add(rowSum);
            }
          }
          return flat;
        }
      case 0: // Column-wise
        for (int j = 0; j < cols; j++) {
          for (int i = 0; i < rows; i++) {
            result[i][j] = _data[i][j];
            if (continuous) {
              if (j > 0 && i == 0) {
                result[i][j] += result[rows - 1][j - 1];
              }
              if (i > 0) {
                result[i][j] += result[i - 1][j];
              }
            } else {
              if (i > 0) {
                result[i][j] += result[i - 1][j];
              }
            }
          }
        }
        break;

      case 1: // Row-wise
        for (int i = 0; i < rows; i++) {
          for (int j = 0; j < cols; j++) {
            result[i][j] = _data[i][j];
            if (continuous) {
              if (i > 0 && j == 0) {
                result[i][j] += result[i - 1][cols - 1];
              }
              if (j > 0) {
                result[i][j] += result[i][j - 1];
              }
            } else {
              if (j > 0) {
                result[i][j] += result[i][j - 1];
              }
            }
          }
        }
        break;

      case 2: // Diagonal top-left to bottom-right
        if (continuous) {
          List<List<int>> coords = [];
          for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
              coords.add([i, j]);
            }
          }
          coords.sort((a, b) {
            int diffA = a[0] - a[1];
            int diffB = b[0] - b[1];
            if (diffA != diffB) {
              return diffB.compareTo(diffA);
            } else {
              return a[0].compareTo(b[0]);
            }
          });
          dynamic cumulative = 0;
          for (var coord in coords) {
            int i = coord[0];
            int j = coord[1];
            cumulative += _data[i][j];
            result[i][j] = cumulative;
          }
        } else {
          for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
              result[i][j] = _data[i][j];
              if (i > 0 && j > 0) {
                result[i][j] += result[i - 1][j - 1];
              }
            }
          }
        }

      case 3: // Diagonal bottom-left to top-right
        if (continuous) {
          List<List<int>> coords = [];
          for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
              coords.add([i, j]);
            }
          }
          coords.sort((a, b) {
            int sumA = a[0] + a[1];
            int sumB = b[0] + b[1];
            if (sumA != sumB) {
              return sumB.compareTo(sumA);
            } else {
              return b[0].compareTo(a[0]);
            }
          });
          dynamic cumulative = 0;
          for (var coord in coords) {
            int i = coord[0];
            int j = coord[1];
            cumulative += _data[i][j];
            result[i][j] = cumulative;
          }
        } else {
          for (int j = 0; j < cols; j++) {
            for (int i = rows - 1; i >= 0; i--) {
              result[i][j] = _data[i][j];
              if (i < rows - 1 && j > 0) {
                result[i][j] += result[i + 1][j - 1];
              }
            }
          }
        }
        break;

      case 4: // Diagonal top-right to bottom-left
        if (continuous) {
          List<List<int>> coords = [];
          for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
              coords.add([i, j]);
            }
          }
          coords.sort((a, b) {
            int sumA = a[0] + a[1];
            int sumB = b[0] + b[1];
            if (sumA != sumB) {
              return sumB.compareTo(sumA);
            } else {
              return b[1].compareTo(a[1]);
            }
          });
          dynamic cumulative = 0;
          for (var coord in coords) {
            int i = coord[0];
            int j = coord[1];
            cumulative += _data[i][j];
            result[i][j] = cumulative;
          }
        } else {
          for (int j = cols - 1; j >= 0; j--) {
            for (int i = 0; i < rows; i++) {
              result[i][j] = _data[i][j];
              if (i > 0 && j < cols - 1) {
                result[i][j] += result[i - 1][j + 1];
              }
            }
          }
        }
        break;

      default:
        throw ArgumentError('Invalid axis value');
    }

    return Matrix(result);
  }

  /// Returns the product of all elements in the matrix.
  ///
  /// Example:
  ///
  /// ```dart
  /// final matrix = Matrix.fromList([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9],
  /// ]);
  ///
  /// print(matrix.product());
  /// // Output: 362880
  /// ```
  dynamic product() {
    return _data.expand((element) => element).reduce((a, b) => a * b);
  }

  /// Calculates the trace of a square matrix.
  ///
  /// Returns the trace of the matrix (the sum of its diagonal elements).
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4]]);
  /// var result = matrix.trace();
  /// print(result); // Output: 5
  /// ```
  dynamic trace() {
    if (_data.isEmpty) {
      throw Exception("Matrix is empty");
    }

    if (rowCount != columnCount) {
      throw Exception("Matrix must be square to calculate the trace");
    }
    var diag = Matrix.fromDiagonal(diagonal());

    return diag.sum();
  }

  dynamic norm([Norm normType = Norm.frobenius]) {
    switch (normType) {
      case Norm.manhattan:
        return _l1Norm();
      case Norm.frobenius:
        return _l2Norm();
      case Norm.chebyshev:
        return _infinityNorm();
      case Norm.spectral:
        return _spectralNorm();
      case Norm.trace:
        return _traceNorm();
      // The below norms need more context to implement.
      case Norm.mahalanobis:
        throw UnimplementedError('Mahalanobis norm is not implemented');
      case Norm.hamming:
      case Norm.cosine:
      default:
        throw Exception('Invalid norm type');
    }
  }

  /// Calculates the L1 norm (Manhattan) of the matrix.
  ///
  /// The L1 norm, also known as the maximum absolute column sum norm, is
  /// calculated by summing the absolute values of each element in each column
  /// and taking the maximum of these sums.
  ///
  /// Example:
  /// ```
  /// var mat = Matrix.fromList([
  ///   [2, -3],
  ///   [-1, 4],
  /// ]);
  /// print(mat.l1Norm()); // Output: 7.0
  /// ```
  ///
  /// Returns:
  /// A double representing the L1 norm of the matrix.
  dynamic _l1Norm() {
    dynamic maxSum = Complex(0.0, 0.0);

    for (int j = 0; j < columnCount; j++) {
      dynamic colSum = Complex(0.0, 0.0);
      for (int i = 0; i < rowCount; i++) {
        colSum += this[i][j].abs();
      }
      maxSum = math.max(maxSum, colSum);
    }

    return maxSum;
  }

  /// Calculates the L2 (Euclidean) norm of the matrix.
  ///
  /// The L2 norm, also known as the Euclidean norm or Frobenius norm, is
  /// calculated by summing the squares of each element and taking the square
  /// root of the result.
  ///
  /// Example:
  /// ```
  /// var mat = Matrix.fromList([
  ///   [2, -3],
  ///   [-1, 4],
  /// ]);
  /// print(mat.l2Norm()); // Output: 5.477225575051661
  /// ```
  ///
  /// Returns:
  /// A double representing the L2 norm of the matrix.
  dynamic _l2Norm() {
    dynamic sum = Complex(0.0, 0.0);

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        sum += this[i][j] * this[i][j];
      }
    }

    return math.sqrt(sum);
  }

  /// Calculates the Infinity norm (Chebyshev) of the matrix.
  ///
  /// The Infinity norm, also known as the maximum absolute row sum norm, is
  /// calculated by summing the absolute values of each element in each row and
  /// taking the maximum of these sums.
  ///
  /// Example:
  /// ```
  /// var mat = Matrix.fromList([
  ///   [2, -3],
  ///   [-1, 4],
  /// ]);
  /// print(mat.infinityNorm()); // Output: 5.0
  /// ```
  ///
  /// Returns:
  /// A double representing the Infinity norm of the matrix.
  dynamic _infinityNorm() {
    dynamic maxSum = Complex(0.0, 0.0);

    for (int i = 0; i < rowCount; i++) {
      dynamic rowSum = Complex(0.0, 0.0);
      for (int j = 0; j < columnCount; j++) {
        rowSum += this[i][j].abs();
      }
      maxSum = math.max(maxSum, rowSum);
    }

    return maxSum;
  }

  /// Computes the spectral norm of the matrix, which is the maximum singular value.
  ///
  /// The spectral norm is a measure of a matrix's size that is derived from the matrix's singular values.
  /// It is also known as the 2-norm or the operator norm.
  ///
  /// Returns the spectral norm as a double.
  ///
  /// Example:
  /// ```dart
  /// var A = Matrix.fromList([
  ///   [3, 2, 2],
  ///   [2, 3, -2]
  /// ]);
  ///
  /// print(A.spectralNorm());
  /// // Output: 5.4649857042
  /// ```
  ///
  /// Note: The output may vary due to numerical precision.
  ///
  /// Throws [Exception] if the matrix is empty.
  dynamic _spectralNorm() {
    var singularValues = decomposition.singularValueDecomposition();

    return _Utils.toSDList(singularValues.S.diagonal()).reduce(math.max);
  }

  /// Computes the trace norm (also known as nuclear norm) of the matrix,
  /// which is the sum of its singular values.
  ///
  /// The trace norm is a measure of a matrix's size derived from the matrix's
  /// singular values. It's used in several areas of matrix computations including
  /// matrix approximation and understanding the properties of specific kinds of matrices.
  ///
  /// Returns the trace norm as a double.
  ///
  /// Example:
  /// ```dart
  /// var A = Matrix.fromList([
  ///   [3, 2, 2],
  ///   [2, 3, -2]
  /// ]);
  ///
  /// print(A.traceNorm());
  /// // Output: 7.865259521
  /// ```
  ///
  /// Note: The output may vary due to numerical precision.
  ///
  /// Throws [Exception] if the matrix is empty.
  dynamic _traceNorm() {
    var singularValues = decomposition.singularValueDecomposition();
    return singularValues.S.diagonal().reduce((a, b) => a + b);
  }

  /// Computes the distance between this matrix and another provided matrix
  /// based on the specified distance type.
  ///
  /// [other]: The other matrix to which the distance will be calculated.
  /// [distanceType]: The type of distance measure to be used. Default is Frobenius norm.
  ///
  /// Returns the distance as a double.
  ///
  /// Example:
  /// ```dart
  /// var A = Matrix.fromList([
  ///   [3, 2, 2],
  ///   [2, 3, -2]
  /// ]);
  ///
  /// var B = Matrix.fromList([
  ///   [1, 2, 3],
  ///   [4, 5, 6]
  /// ]);
  ///
  /// print(A.distance(B, distanceType: DistanceType.manhattan));
  /// // Output: 10.5
  /// ```
  ///
  /// Note: The output may vary due to numerical precision.
  ///
  /// Throws [Exception] if the matrices have different dimensions.
  dynamic distance(Matrix other,
      {DistanceType distance = DistanceType.frobenius}) {
    return Matrix.distance(this, other, distance: distance);
  }

  /// Normalizes the matrix by dividing each element by the maximum element value.
  ///
  /// Returns a new normalized matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4]]);
  /// var result = matrix.normalize();
  /// print(result);
  /// // Output:
  /// // 0.25 0.5
  /// // 0.75 1.0
  /// ```
  Matrix normalize([Norm? normType]) {
    if (_data.isEmpty) {
      throw Exception("Matrix is empty");
    }

    if (normType != null) {
      return this / norm(normType);
    }

    dynamic maxValue = max();
    if (maxValue == 0) {
      throw Exception("Matrix is filled with zeros, cannot normalize");
    }

    return this / maxValue;
  }

  /// Transposes the matrix by swapping rows and columns.
  ///
  /// Returns a new transposed matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4]]);
  /// var result = matrix.transpose();
  /// print(result);
  /// // Output:
  /// // 1 3
  /// // 2 4
  /// ```
  Matrix transpose() {
    int rows = rowCount;
    int cols = columnCount;
    if (rows == 0) {
      throw Exception('Cannot transpose an empty matrix');
    }

    List<List<dynamic>> newData = List.generate(
        cols, (i) => List<dynamic>.filled(rows, null, growable: false));

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        newData[j][i] = this[i][j];
      }
    }

    return Matrix(newData);
  }

  /// Returns the conjugate transpose (also known as the Hermitian transpose) of the matrix.
  /// The conjugate transpose is obtained by first computing the conjugate of the matrix
  /// and then transposing it.
  ///
  /// If the matrix has complex elements, the conjugate transpose is computed by
  /// taking the complex conjugate of each element and transposing the resulting matrix.
  ///
  /// Example:
  /// ```
  /// var A = Matrix('1+2i 3-4i; 5+6i 7-8i');
  /// var B = A.conjugateTranspose();
  /// ```
  ///
  /// Returns a new [Matrix] object containing the conjugate transpose.
  Matrix conjugateTranspose() {
    return conjugate().transpose();
  }

  /// Computes the matrix of cofactors for a square matrix.
  /// Each element in the cofactor matrix is the determinant of the subMatrix
  /// formed by removing the corresponding row and column from the original matrix,
  /// multiplied by the alternating sign pattern.
  ///
  /// Throws an [ArgumentError] if the matrix is not square.
  ///
  /// Example:
  /// ```
  /// var A = Matrix('1+2i 3-4i; 5+6i 7-8i');
  /// var B = A.conjugate();
  /// ```
  ///
  /// Returns a new [Matrix] object containing the cofactors.
  Matrix conjugate() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (this[i][j] is Complex) {
          result[i][j] = (this[i][j] as Complex).conjugate;
        } else {
          result[i][j] = this[i][j];
        }
      }
    }
    return result;
  }

  /// Computes the matrix of cofactors for a square matrix.
  /// Each element in the cofactor matrix is the determinant of the subMatrix
  /// formed by removing the corresponding row and column from the original matrix,
  /// multiplied by the alternating sign pattern.
  ///
  /// Example:
  /// ```
  /// var A = Matrix('1 2 3; 4 5 6; 7 8 9');
  /// var B = A.cofactors();
  /// ```
  ///
  /// Throws an [ArgumentError] if the matrix is not square.
  ///
  /// Returns a new [Matrix] object containing the cofactors.
  Matrix cofactors() {
    if (!isSquareMatrix()) {
      throw ArgumentError('Cofactors can only be computed for square matrices');
    }

    Matrix cofactorMatrix = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        cofactorMatrix[i][j] = math.pow(-1, i + j) * slice(i, j).determinant();
      }
    }
    return cofactorMatrix;
  }

  /// Computes the adjoint (also known as adjugate or adjunct) of a square matrix.
  /// The adjoint is obtained by transposing the cofactor matrix.
  ///
  /// Example:
  /// ```
  /// var A = Matrix('1 2 3; 4 5 6; 7 8 9');
  /// var B = A.adjoint();
  /// ```
  ///
  /// Throws an [ArgumentError] if the matrix is not square.
  ///
  /// Returns a new [Matrix] object containing the adjoint.
  Matrix adjoint() {
    return cofactors().transpose();
  }

  /// Computes the determinant of the matrix.
  ///
  /// Throws an [Exception] if the matrix is not square.
  ///
  /// Takes an optional [method] parameter to specify the method for calculating
  /// the determinant. The default method is [DeterminantMethod.LU].
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([
  ///   [1, 2],
  ///   [3, 4]
  /// ]);
  /// var det = matrix.determinant();  // Output: -2.0
  /// var detLaplace = matrix.determinant(method: DeterminantMethod.Laplace);  // Output: -2.0
  /// ```
  ///
  /// \[ \text{Determinant} = 1 \times 4 - 2 \times 3 = -2 \]
  ///
  /// @param method The method used for calculating the determinant. One of [DeterminantMethod.Laplace] or [DeterminantMethod.LU].
  /// @return The determinant of the matrix as a [dynamic].
  dynamic determinant({DeterminantMethod method = DeterminantMethod.LU}) {
    int n = rowCount;
    if (n != columnCount) {
      throw Exception('Matrix must be square to calculate determinant');
    }
    Number det = Complex.one();
    if (method == DeterminantMethod.LU) {
      // Perform LU decomposition
      // (Replace with your actual LU decomposition implementation)
      var lu = decomposition.luDecompositionDoolittle();
      // var l = lu.L;
      var u = lu.U;

      // Compute the product of the diagonal elements of U

      for (int i = 0; i < n; i++) {
        det *= u[i][i];
      }
      return det;
    } else {
      // Laplace Expansion
      if (n == 1) {
        return this[0][0];
      }

      if (n == 2) {
        return (_data[0][0] * _data[1][1]) - (_data[0][1] * _data[1][0]);
      }

      for (int p = 0; p < n; p++) {
        Matrix subMatrix = Matrix([
          for (int i = 1; i < n; i++)
            [
              for (int j = 0; j < n; j++)
                if (j != p) _data[i][j]
            ]
        ]);

        det += _data[0][p] * (p % 2 == 0 ? 1 : -1) * subMatrix.determinant();
      }
    }

    return det;
  }

  /// Scales the elements of the specified row by a given factor.
  ///
  /// This function multiplies all the elements in the row with the specified
  /// [rowIndex] by the given [scaleFactor].
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9]
  /// ]);
  /// A.scaleRow(1, 2);
  /// print(A);
  /// ```
  ///
  /// Output:
  /// ```
  /// 1 2 3
  /// 8 10 12
  /// 7 8 9
  /// ```
  ///
  /// Validation:
  /// Throws [RangeError] if [rowIndex] is not a valid row index in the matrix.
  void scaleRow(int rowIndex, dynamic scaleFactor) {
    RangeError.checkValidIndex(rowIndex, this, "rowIndex", rowCount);

    for (int j = 0; j < columnCount; j++) {
      this[rowIndex][j] *=
          (scaleFactor is num) ? Complex(scaleFactor) : scaleFactor;
    }
  }

  /// Returns the row space of the matrix.
  ///
  /// The row space is the linear space formed by the linearly independent
  /// rows of the matrix.
  ///
  /// Example:
  ///
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [1, 2, 3],
  ///   [0, 1, 1],
  ///   [0, 0, 0]
  /// ]);
  /// print(A.rowSpace());
  /// // Output:
  /// // 1  2  3
  /// // 0  1  1
  /// ```
  Matrix rowSpace() {
    Matrix rref = reducedRowEchelonForm();
    List<List<dynamic>> rowSpace = [];

    for (int i = 0; i < rref.rowCount; i++) {
      bool isZeroRow = true;

      for (int j = 0; j < rref.columnCount; j++) {
        if (rref[i][j] != 0) {
          isZeroRow = false;
          break;
        }
      }

      if (!isZeroRow) {
        rowSpace.add(this[i]);
      }
    }

    return Matrix.fromList(rowSpace);
  }

  /// Returns the column space of the matrix.
  ///
  /// The column space is the linear space formed by the linearly independent
  /// columns of the matrix.
  ///
  /// Example:
  ///
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [1, 0, 0],
  ///   [2, 1, 0],
  ///   [3, 1, 0]
  /// ]);
  /// print(A.columnSpace());
  /// // Output:
  /// // 1  0
  /// // 2  1
  /// // 3  1
  /// ```
  Matrix columnSpace() {
    Matrix transpose = this.transpose();
    return transpose.rowSpace().transpose();
  }

  /// Returns the null space (also known as kernel) of the matrix.
  ///
  /// The null space is the linear space formed by all vectors that, when
  /// multiplied by the matrix, result in the zero vector.
  ///
  /// Example:
  ///
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [1, 2, 3],
  ///   [0, 1, 1],
  ///   [0, 0, 0]
  /// ]);
  /// print(A.nullSpace());
  /// // Output:
  /// // -2
  /// //  3
  /// //  0
  /// ```
  Matrix nullSpace() {
    Matrix rref = reducedRowEchelonForm();
    int freeVarCount = rref.columnCount - rref.rank();

    if (freeVarCount > 0) {
      List<List<double>> nullSpace = [];
      for (int i = 0; i < freeVarCount; i++) {
        List<double> nullSpaceVector = List.filled(rref.columnCount, 0.0);
        int freeVarIndex = rref.columnCount - freeVarCount + i;

        for (int j = 0; j < rref.rowCount; j++) {
          int pivotPosition = rref[j].lastIndexOf(
              rref[j][freeVarIndex]); // Find last index of the value
          if (rref[j][freeVarIndex] != 0 && pivotPosition == freeVarIndex) {
            nullSpaceVector[j] = -rref[j][freeVarIndex];
          }
        }

        nullSpaceVector[freeVarIndex] = 1;
        nullSpace.add(nullSpaceVector);
      }

      return Matrix(nullSpace);
    } else {
      //throw Exception('The matrix has no null space.');
      return Matrix();
    }
  }

  /// Returns the nullity of the matrix.
  ///
  /// The nullity is the dimension of the null space of the matrix.
  ///
  /// Example:
  ///
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [1, 2, 3],
  ///   [0, 1, 1],
  ///   [0, 0, 0]
  /// ]);
  ///
  /// print(A.nullity()); // Output: 1
  /// ```
  int nullity() {
    return columnCount - rank();
  }

  /// Adds a multiple of one row to another row.
  ///
  /// This function multiplies the elements in the row with the specified
  /// [sourceIndex] by the given [scaleFactor] and adds the result to the
  /// elements in the row with the specified [targetIndex].
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9]
  /// ]);
  /// A.addRow(0, 2, -3);
  /// print(A);
  /// ```
  ///
  /// Output:
  /// ```
  ///  1  2  3
  ///  4  5  6
  /// -4 -2  0
  /// ```
  ///
  /// Validation:
  /// Throws [RangeError] if [sourceIndex] or [targetIndex] is not a valid row index in the matrix.
  void addRow(int sourceIndex, int targetIndex, dynamic scaleFactor) {
    RangeError.checkValidIndex(sourceIndex, this, "sourceIndex", rowCount);
    RangeError.checkValidIndex(targetIndex, this, "targetIndex", rowCount);

    for (int j = 0; j < columnCount; j++) {
      this[targetIndex][j] += scaleFactor * this[sourceIndex][j];
    }
  }

  /// Calculates the inverse of a square matrix, falling back to SVD-based
  /// inversion or generalized pseudo-inversion if necessary.
  ///
  /// This method first attempts regular matrix inversion using LU decomposition.
  /// If the matrix is near-singular or ill-conditioned (as determined by the
  /// condition number), it falls back to an inversion based on Singular Value
  /// Decomposition (SVD). If all else fails, it uses the pseudo-inverse as a
  /// generalized solution.
  ///
  /// - [conditionThreshold]: A threshold for the condition number, above which
  ///   the matrix is considered ill-conditioned. Default is `1e-3`.
  ///
  /// Throws:
  /// - [Exception] if the matrix is not square.
  /// - [Exception] if all inversion methods fail.
  ///
  /// Returns:
  /// - A [Matrix] representing the inverse of the current matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4]]);
  /// var result = matrix.inverse();
  /// print(result);
  /// // Output:
  /// // Matrix: 2x2
  /// // ┌ -2.0  1.0 ┐
  /// // └  1.5 -0.5 ┘
  /// ```
  Matrix inverse({double conditionThreshold = 1e-3}) {
    // if (rowCount != columnCount) {
    //   throw Exception('Matrix must be square to calculate inverse');
    // }

    // Compute SVD decomposition.
    var svd = decomposition.singularValueDecomposition();

    print('Condition number is: ${svd.conditionNumber}');

    if (svd.conditionNumber > Complex(conditionThreshold)) {
      print(
          'Matrix condition number exceeds threshold $conditionThreshold. Likely singular.');
    } else {
      try {
        // Attempt regular inversion using LU solve.
        var lu = decomposition.luDecompositionDoolittle();
        var identity = Matrix.eye(rowCount);
        return lu
            .solve(identity); // Solve A * X = I for X (generalized inverse).
      } catch (e) {
        print('Failed regular inversion: $e. Falling back to SVD inversion...');
      }
    }

    // SVD Inversion.
    try {
      print('Attempting SVD inversion...');
      // Identity matrix of the same size.
      var identity = Matrix.eye(rowCount);
      return svd.solve(identity);
    } catch (e) {
      print('SVD inversion failed: $e');
    }

    // Generalized Inverse Fallback.
    print('Falling back to generalized inverse...');
    return pseudoInverse();
  }

  /// Computes the pseudo-inverse of a matrix using Singular Value Decomposition (SVD).
  ///
  /// This method provides a robust approach to calculating the pseudo-inverse of
  /// a matrix, handling cases where the matrix is singular, poorly conditioned,
  /// or not square. The method falls back to SVD-based computation when the
  /// condition number exceeds the specified threshold, ensuring numerical stability.
  ///
  /// ### Returns:
  /// - A `Matrix` object representing the pseudo-inverse of the input matrix.
  ///
  /// ### Methodology:
  /// 1. **SVD Decomposition**: The matrix is decomposed into \( U, S, V \) components.
  /// 2. **Singular Value Inversion**:
  ///    - Singular values are inverted to construct \( S^+ \), with small values set
  ///      to zero to handle numerical instability.
  /// 3. **Pseudo-Inverse Reconstruction**:
  ///    - Combines \( U, S^+, V \) to compute the pseudo-inverse:
  ///      \[ A^+ = V S^+ U^T \]
  ///
  /// ### Example:
  /// ```dart
  /// Matrix a = Matrix([
  ///   [1, 2],
  ///   [3, 4],
  ///   [5, 6]
  /// ]);
  ///
  /// Matrix aPseudoInverse = a.pseudoInverse();
  /// print(aPseudoInverse);
  /// ```
  ///
  /// ### Output:
  /// ```
  /// Matrix: 2x3
  /// ┌ -1.3333333333333308 -0.3333333333333339  0.6666666666666643 ┐
  /// └  1.0833333333333313 0.33333333333333304 -0.4166666666666643 ┘
  /// ```
  ///
  /// ### Notes:
  /// - This implementation is suitable for both square and rectangular matrices.
  /// - Provides robust handling for singular and low-rank matrices.
  /// - If the matrix is well-conditioned, the SVD fallback may not be triggered.
  ///
  /// ### Limitations:
  /// - The computational cost of SVD may be significant for very large matrices.
  ///
  Matrix pseudoInverse() {
    Matrix a = copy();
    Matrix aTranspose = a.transpose();
    return (aTranspose * a).inverse() * aTranspose;
  }
  // Matrix pseudoInverse() {
  //   var svd = decomposition.singularValueDecomposition();
  //   // Identity matrix of the same size.
  //   var identity = Matrix.eye(rowCount);
  //   return svd.solve(identity);
  // }

  /// Calculates the dot product of two matrices.
  ///
  /// [other]: The matrix to be multiplied.
  ///
  /// Returns a new matrix that is the product of this matrix and [other].
  ///
  /// Example:
  /// ```dart
  /// var matrixA = Matrix([[1, 2], [3, 4]]);
  /// var matrixB = Matrix([[2, 0], [1, 2]]);
  /// var result = matrixA.dot(matrixB);
  /// print(result);
  /// // Output:
  /// // 4 4
  /// // 10 8
  /// ```
  Matrix dot(Matrix other) {
    int rowsA = rowCount;
    int colsA = columnCount;
    int rowsB = other.rowCount;
    int colsB = other.columnCount;

    if (colsA != rowsB) {
      throw Exception(
          'Cannot calculate dot product of matrices with incompatible shapes');
    }

    List<List<dynamic>> newData = [];

    for (int i = 0; i < rowsA; i++) {
      List<dynamic> row = [];
      for (int j = 0; j < colsB; j++) {
        dynamic sum = 0;
        for (int k = 0; k < colsA; k++) {
          sum += this[i][k] * other[k][j];
        }
        row.add(sum);
      }
      newData.add(row);
    }

    return Matrix(newData);
  }

  /// Calculates the element-wise reciprocal of the matrix.
  ///
  /// Returns a new matrix with the reciprocal of each element.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4]]);
  /// var result = matrix.reciprocal();
  /// print(result);
  /// // Output:
  /// // 1.0 0.5
  /// // 0.3333333333333333 0.25
  /// ```
  Matrix reciprocal() {
    List<List<dynamic>> newData = List.generate(
        rowCount,
        (i) => List.generate(columnCount, (j) {
              if (_data[i][j] == Complex.zero()) {
                return Complex.infinity();
              }
              return Complex.one() / _data[i][j];
            }));

    return Matrix(newData);
  }

  /// Calculates the element-wise absolute value of the matrix.
  ///
  /// Returns a new matrix with the absolute value of each element.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[-1, 2], [3, -4]]);
  /// var result = matrix.abs();
  /// print(result);
  /// // Output:
  /// // 1 2
  /// // 3 4
  /// ```
  Matrix abs() {
    return Matrix(List.generate(
        rowCount, (i) => List.generate(columnCount, (j) => _data[i][j].abs())));
  }

  /// Rounds each element in the matrix to the specified number of decimal places.
  ///
  /// [decimalPlaces]: The number of decimal places to round to.
  ///
  /// Returns a new matrix with the rounded elements.
  ///
  /// Example:
  ///
  /// ```dart
  /// var matrix = Matrix([
  ///   [1.2345, 2.3456],
  ///   [3.4567, 4.5678]
  /// ]);
  ///
  /// var roundedMatrix = matrix.round(3);
  ///
  /// print(roundedMatrix);
  /// // Output:
  /// // 1.235  2.346
  /// // 3.457  4.568
  /// ```
  Matrix round([int decimalPlaces = 0]) {
    // Create a new data structure for the rounded matrix
    List<List<dynamic>> newData = List.generate(
        rowCount, (i) => List<dynamic>.generate(columnCount, (j) => 0));

    // Iterate over each element in the matrix
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (decimalPlaces == 0) {
          newData[i][j] = _data[i][j].round();
        } else {
          newData[i][j] = (_data[i][j] * math.pow(10, decimalPlaces)).round() /
              math.pow(10, decimalPlaces);
        }
      }
    }

    return Matrix(newData);
  }

  /// Computes the eigenvalues of the matrix using the QR algorithm.
  ///
  /// This implementation assumes that the matrix is symmetric and may not converge for non-symmetric matrices.
  ///
  /// * [maxIterations]: Maximum number of iterations for the QR algorithm (default: 1000).
  /// * [tolerance]: Tolerance for checking the convergence of the QR algorithm (default: 1e-10).
  ///
  /// Returns a list of eigenvalues.
  ///
  /// Example:
  /// ```
  /// var matrix = Matrix([
  ///   [1, 2, 3],
  ///   [2, 1, 2],
  ///   [3, 2, 1]
  /// ]);
  /// var eigenvalues = matrix.eigenvalues();
  /// print(eigenvalues); // [5.372281323269014, -2.3722813232690143, -1.0000000000000002]
  /// ```
  List<dynamic> eigenvalues({int maxIterations = 1000, num tolerance = 1e-10}) {
    return eigen(maxIterations: maxIterations, tolerance: tolerance).values;
  }

  /// Computes the eigenvectors of the matrix using the QR algorithm.
  ///
  /// This implementation assumes that the matrix is symmetric and may not converge for non-symmetric matrices.
  ///
  /// * [maxIterations]: Maximum number of iterations for the QR algorithm (default: 1000).
  /// * [tolerance]: Tolerance for checking the convergence of the QR algorithm (default: 1e-10).
  ///
  /// Returns a list of eigenvectors, each represented as a column matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([
  ///   [1, 2, 3],
  ///   [2, 1, 2],
  ///   [3, 2, 1]
  /// ]);
  /// var eigenvectors = matrix.eigenvectors();
  /// print(eigenvectors[0]); // Matrix([[0.5773502691896258], [0.5773502691896257], [0.5773502691896257]])
  /// ```
  List<Matrix> eigenvectors(
      {int maxIterations = 1000, double tolerance = 1e-10}) {
    return eigen(maxIterations: maxIterations, tolerance: tolerance).vectors;
  }

  /// Computes the eigenvalues and eigenvectors of the matrix using the QR algorithm.
  ///
  /// This implementation assumes that the matrix is symmetric and may not converge for non-symmetric matrices.
  ///
  /// * [maxIterations]: Maximum number of iterations for the QR algorithm (default: 1000).
  /// * [tolerance]: Tolerance for checking the convergence of the QR algorithm (default: 1e-10).
  ///
  /// Returns an `Eigen` object containing eigenvalues and eigenvectors.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([
  ///   [1, 2, 3],
  ///   [2, 1, 2],
  ///   [3, 2, 1]
  /// ]);
  /// var eigen = matrix.eigen();
  /// print(eigen.values); // [5.701562118716425, -1.9999999999999998, -0.701562118716424]
  /// print(eigen.vectors[0]); // Matrix([[0.5773502691896258], [0.5773502691896257], [0.5773502691896257]])
  /// ```
  Eigen eigen1({int maxIterations = 1000, num tolerance = 1e-10}) {
    // Ensure the matrix is square.
    if (!isSquareMatrix()) {
      throw ArgumentError(
          'Eigenvalues and eigenvectors can only be computed for square matrices');
    }
    int n = rowCount;
    // Convert to a numerical matrix (assuming this converts to a double-based Matrix).
    Matrix A = _Utils.toNumMatrix(this);

    // Initialize eigenvector accumulator as the identity matrix.
    Matrix V = Matrix.eye(n, isDouble: true);
    Matrix aPrev;

    // Iteratively apply the Householder-based QR algorithm.
    for (int iter = 0; iter < maxIterations; iter++) {
      aPrev = A.copy();
      final qr = A.decomposition.qrDecompositionHouseholder();
      Matrix Q = qr.Q;
      Matrix R = qr.R;
      A = R * Q;
      V = V * Q;

      Matrix diff = A - aPrev;
      if (diff.norm(Norm.chebyshev) < tolerance) {
        break;
      }
    }

    // Now A should be in (quasi-triangular) Schur form.
    // For symmetric matrices, A is (approximately) diagonal.
    // For general matrices, A is block upper-triangular with 1x1 blocks (real eigenvalues)
    // and 2x2 blocks (representing complex conjugate eigenvalue pairs).
    List<Complex> eigenvalues = [];
    int i = 0;
    while (i < n) {
      // Check if a 2x2 block is present: off-diagonal element A[i+1][i] is significant.
      if (i < n - 1 && (A[i + 1][i]).abs() > tolerance) {
        dynamic a = A[i][i];
        dynamic b = A[i][i + 1];
        dynamic c = A[i + 1][i];
        dynamic d = A[i + 1][i + 1];
        dynamic trace = a + d;
        dynamic det = a * d - b * c;
        dynamic disc = trace * trace - Complex(4) * det;
        if (disc >= 0) {
          eigenvalues.add(Complex((trace + math.sqrt(disc)) / 2, 0));
          eigenvalues.add(Complex((trace - math.sqrt(disc)) / 2, 0));
        } else {
          eigenvalues.add(Complex(trace / 2, math.sqrt(-disc) / 2));
          eigenvalues.add(Complex(trace / 2, -math.sqrt(-disc) / 2));
        }
        i += 2;
      } else {
        eigenvalues.add(Complex(A[i][i], 0));
        i++;
      }
    }

    // For symmetric matrices, the accumulated Q gives eigenvectors.
    List<Matrix> eigenvectors = [];
    if (isSymmetricMatrix(tolerance: tolerance)) {
      eigenvectors = List.generate(n, (i) => V.column(i));
    } else {
      // Computing eigenvectors for non-symmetric matrices requires additional work (e.g. via inverse iteration)
      // and is not provided in this simple implementation.
      eigenvectors =
          []; // or you could throw an error if eigenvectors are required.
    }

    return Eigen(eigenvalues, eigenvectors);
  }

  Eigen eigen({int maxIterations = 1000, num tolerance = 1e-10}) {
    if (!isSquareMatrix()) {
      throw ArgumentError(
          'Eigenvalues and eigenvectors can only be computed for square matrices');
    }
    // Convert matrix to a numerical matrix.
    Matrix A = _Utils.toNumMatrix(this);
    Matrix
        QH; // Will hold the orthogonal transformation from Hessenberg reduction.

    // If the matrix is not symmetric (within tolerance), reduce to Hessenberg form.
    if (!isSymmetricMatrix(tolerance: tolerance)) {
      var hessResult = A.hessenberg();
      A = hessResult.H;
      QH = hessResult.Q; // QH satisfies: A_original = QH * A * QH^T.
    } else {
      QH = Matrix.eye(rowCount, isDouble: true);
    }

    int n = rowCount;
    Matrix V = Matrix.eye(n,
        isDouble: true); // Accumulate Q factors from QR iterations.
    Matrix aPrev;

    for (int i = 0; i < maxIterations; i++) {
      aPrev = A.copy();
      var qr = A.decomposition.qrDecompositionGramSchmidt();
      Matrix Q = qr.Q;
      Matrix R = qr.R;

      A = R * Q;
      V = V * Q;

      Matrix diff = A - aPrev;
      if (diff.norm(Norm.chebyshev) < tolerance) {
        break;
      }
      if (A.isUpperTriangular(tolerance) && A.isLowerTriangular(tolerance)) {
        break;
      }
    }

    // The eigenvalues are the diagonal entries of A.
    List<dynamic> eigenvalues = List.generate(n, (i) => A[i][i]);
    // The eigenvectors computed from the QR algorithm (in V) correspond to the Hessenberg matrix.
    // To obtain eigenvectors of the original matrix, back-transform:
    List<Matrix> eigenvectors = List.generate(n, (i) => QH * V.column(i));

    return Eigen(eigenvalues, eigenvectors);
  }

// Returns the Hessenberg form of this square matrix along with the accumulated
  // orthogonal transformation Q such that A_original = Q * H * Q^T.
  HessenbergResult hessenberg({num tol = 1e-15}) {
    if (!isSquareMatrix()) {
      throw ArgumentError("Hessenberg reduction requires a square matrix.");
    }
    int n = rowCount;
    // Work on a copy of the matrix.
    Matrix H = copy();
    // Initialize Q as the identity matrix.
    Matrix Q = Matrix.eye(n, isDouble: true);

    // For each column k from 0 to n-2:
    for (int k = 0; k < n - 2; k++) {
      // Build the vector x = H[k+1:n][k] (elements below the diagonal in column k).
      List<dynamic> x = [];
      for (int i = k + 1; i < n; i++) {
        x.add(H[i][k]);
      }

      // Compute the Euclidean norm of x.
      dynamic normX = Complex(0);
      for (var xi in x) {
        normX += xi * xi;
      }
      normX = math.sqrt(normX);
      if (normX.abs() < tol) continue;

      // Determine r = -sign(x[0]) * normX.
      dynamic r = (x[0] >= Complex(0)) ? -normX : normX;

      // Compute u = x - r * e1, where e1 = [1, 0, ..., 0].
      List<dynamic> u = List.from(x);
      u[0] = u[0] - r;

      // Compute the norm of u.
      dynamic normU = Complex(0);
      for (var ui in u) {
        normU += ui * ui;
      }
      normU = math.sqrt(normU);
      if (normU.abs() < tol) continue;

      // Compute the Householder vector v = u / normU.
      List<dynamic> v = u.map((ui) => ui / normU).toList();

      // Construct the full n x n Householder matrix P.
      Matrix P = Matrix.eye(n, isDouble: true);
      for (int i = k + 1; i < n; i++) {
        for (int j = k + 1; j < n; j++) {
          P[i][j] = P[i][j] - Complex(2) * v[i - (k + 1)] * v[j - (k + 1)];
        }
      }

      // Apply the transformation from both sides: H = P * H * P.
      H = P * H * P;
      // Accumulate the transformation: Q = Q * P.
      Q = Q * P;

      // Explicitly zero out entries below the first subdiagonal in column k.
      for (int i = k + 2; i < n; i++) {
        H[i][k] = Complex(0);
      }
    }
    return HessenbergResult(H, Q);
  }

  // Performs a plane rotation (Givens rotation) on the matrix.
  Matrix rotate(int p, int q, double c, double s) {
    int n = rowCount;
    Matrix result = _Utils.toNumMatrix(this);

    for (int i = 0; i < n; i++) {
      double api = c * this[i][p] - s * this[i][q];
      double aqi = s * this[i][p] + c * this[i][q];
      result[i][p] = api;
      result[i][q] = aqi;
    }

    for (int i = 0; i < n; i++) {
      double aip = c * this[p][i] - s * this[q][i];
      double aiq = s * this[p][i] + c * this[q][i];
      result[p][i] = aip;
      result[q][i] = aiq;
    }

    return result;
  }

  /// Creates a tridiagonal matrix using the main diagonal, sub-diagonal, and
  /// super-diagonal elements of the current matrix.
  ///
  /// This function does not perform any actual tridiagonalization of the matrix.
  /// It just extracts the main diagonal, sub-diagonal, and super-diagonal elements
  /// from the input matrix and creates a new matrix with those elements.
  ///
  /// Example:
  /// ```dart
  /// var A = Matrix.fromList([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9]
  /// ]);
  ///
  /// var tridiagonalA = A.tridiagonalize();
  /// tridiagonalA.prettyPrint();
  /// ```
  Matrix tridiagonalize() {
    List mainDiagonal = diagonal();
    List subDiagonal = diagonal(k: -1);
    List superDiagonal = diagonal(k: 1);

    Matrix tridiagonal = Matrix.zeros(rowCount, columnCount);

    for (int i = 0; i < rowCount; i++) {
      tridiagonal[i][i] = mainDiagonal[i];
      if (i > 0) {
        tridiagonal[i][i - 1] = subDiagonal[i - 1];
      }
      if (i < rowCount - 1) {
        tridiagonal[i][i + 1] = superDiagonal[i];
      }
    }

    return tridiagonal;
  }

  /// Computes the bidiagonalization of the matrix using Householder reflections.
  ///
  /// Bidiagonalization decomposes the matrix A into three matrices U, B, and V,
  /// such that A = U * B * V', where U and V are orthogonal matrices and B is
  /// a bidiagonal matrix.
  ///
  /// Returns a Bidiagonalization object containing the U, B, and V matrices.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9]
  /// ]);
  ///
  /// Bidiagonalization bidiag = A.bidiagonalize();
  /// bidiag.U.prettyPrint();
  /// bidiag.B.prettyPrint();
  /// bidiag.V.prettyPrint();
  /// ```
  Bidiagonalization bidiagonalize() {
    var A = copy();
    int m = A.rowCount;
    int n = A.columnCount;

    Matrix U = Matrix.eye(m);
    Matrix B = A.copy();
    Matrix V = Matrix.eye(n);

    for (int k = 0; k < math.min(m - 1, n); k++) {
      // Compute Householder reflection for the k-th column of B
      var columnVector = B.slice(k, m, k, k + 1);

      Matrix pk = _Utils.householderReflection(columnVector);
      Matrix P = Matrix.eye(m);
      P.setSubMatrix(k, k, pk);

      // Update B and U
      B = P * B;
      U = U * P;

      if (k < n - 1) {
        // Compute Householder reflection for the k-th row of B
        var rowVector = ColumnMatrix(B.slice(k, k + 1, k, n).flatten());

        Matrix qk = _Utils.householderReflection(rowVector);
        Matrix Q = Matrix.eye(n);

        Q.setSubMatrix(k, k, qk);

        // Update B and V
        B = B * Q;
        V = V * Q;
      }
    }

    return Bidiagonalization(U, B, V);
  }

  /// Checks if the current matrix is contained in or is a subMatrix of any matrix in [matrices].
  ///
  /// [matrices]: A list of matrices to check against.
  ///
  /// Returns `true` if the current matrix is contained in or is a subMatrix of any matrix in [matrices], otherwise `false`.
  ///
  /// Example:
  /// ```dart
  /// var matrix1 = Matrix([[1, 2], [3, 4]]);
  /// var matrix2 = Matrix([[5, 6], [7, 8]]);
  /// var matrix3 = Matrix([[1, 2, 3], [3, 4, 5], [5, 6, 7]]);
  ///
  /// var targetMatrix = Matrix([[1, 2], [3, 4]]);
  /// print(targetMatrix.containsIn([matrix1, matrix2])); // Output: true
  /// print(targetMatrix.containsIn([matrix2, matrix3])); // Output: false
  /// ```
  bool containsIn(List<Matrix> matrices) {
    return matrices.any((matrix) => this == matrix || isSubMatrix(matrix));
  }

  /// Checks if the current matrix is not contained in and is not a subMatrix of any matrix in [matrices].
  ///
  /// [matrices]: A list of matrices to check against.
  ///
  /// Returns `true` if the current matrix is not contained in and is not a subMatrix of any matrix in [matrices], otherwise `false`.
  ///
  /// Example:
  /// ```dart
  /// var matrix1 = Matrix([[1, 2], [3, 4]]);
  /// var matrix2 = Matrix([[5, 6], [7, 8]]);
  /// var matrix3 = Matrix([[1, 2, 3], [3, 4, 5], [5, 6, 7]]);
  ///
  /// var targetMatrix = Matrix([[1, 2], [3, 4]]);
  /// print(targetMatrix.notIn([matrix2, matrix3])); // Output: true
  /// print(targetMatrix.notIn([matrix1, matrix2])); // Output: false
  /// ```
  bool notIn(List<Matrix> matrices) {
    return !containsIn(matrices);
  }

  /// Calculates the condition number of the matrix using the Frobenius norm.
  ///
  /// The condition number is a measure of how well-conditioned a matrix is. A matrix
  /// with a high condition number is considered to be ill-conditioned, which can
  /// result in loss of precision when solving linear systems or computing the inverse.
  /// The condition number is calculated as the product of the Frobenius norms of the
  /// matrix and its inverse.
  ///
  /// Returns the condition number as a double.
  ///
  /// Example:
  /// ```dart
  /// Matrix A = Matrix.fromList([
  ///   [1, 2, 4],
  ///   [4, 8, 20],
  ///   [3, 6, 7]
  /// ]);
  ///
  /// double conNumber = A.conditionNumber();
  /// print(conNumber);
  /// ```
  dynamic conditionNumber() {
    return norm() * inverse().norm();
  }
}
