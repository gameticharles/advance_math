part of '../../algebra.dart';

extension MatrixStatsExtension on Matrix {
  /// Returns the smallest value in the matrix along the specified axis.
  ///
  /// If [axis] is null, the smallest value in the matrix is returned.
  /// If [axis] is 0, a list of the smallest values in each column is returned.
  /// If [axis] is 1, a list of the smallest values in each row is returned.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix.fromList([[2, 3], [1, 4]]);
  ///
  /// var minValue = matrix.min();
  /// print(minValue); // Output: 1
  ///
  /// var rowMinValues = matrix.min(axis: 1);
  /// print(rowMinValues); // Output: [2, 1]
  ///
  /// var colMinValues = matrix.min(axis: 0);
  /// print(colMinValues); // Output: [1, 3]
  /// ```
  ///
  /// Throws [Exception] if the matrix is empty.
  /// Throws [ArgumentError] if [axis] is not null, 0, or 1.
  dynamic min({int? axis}) {
    int rows = rowCount;
    int cols = columnCount;
    if (rows == 0 || cols == 0) {
      throw Exception("Matrix is empty");
    }

    if (axis != null && axis != 0 && axis != 1) {
      throw ArgumentError(
          "Axis must be 0 (for columns), 1 (for rows), or null (for total min)");
    }

    switch (axis) {
      case 0:
        return List<dynamic>.generate(
            _data[0].length,
            (i) =>
                _Utils.toNumList(_data).map((row) => row[i]).reduce(math.min));
      case 1:
        return _Utils.toNumList(_data)
            .map((row) => row.reduce(math.min))
            .toList();
      default:
        dynamic minValue = _data[0][0];

        for (var row in _Utils.toNumList(_data)) {
          dynamic rowMin = row.reduce(math.min);
          if (rowMin < minValue) {
            minValue = rowMin;
          }
        }

        return minValue;
    }
  }

  /// Returns the largest numeric value in the matrix along the specified axis.
  ///
  /// If [axis] is null, the largest value in the matrix is returned.
  /// If [axis] is 0, a list of the largest values in each column is returned.
  /// If [axis] is 1, a list of the largest values in each row is returned.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix.fromList([[2, 3], [1, 4]]);
  ///
  /// var maxValue = matrix.max();
  /// print(maxValue); // Output: 4
  ///
  /// var rowMaxValues = matrix.max(axis: 1);
  /// print(rowMaxValues); // Output: [3, 4]
  ///
  /// var colMaxValues = matrix.max(axis: 0);
  /// print(colMaxValues); // Output: [2, 4]
  /// ```
  ///
  /// Throws [Exception] if the matrix is empty.
  /// Throws [ArgumentError] if [axis] is not null, 0, or 1.
  /// Throws [ArgumentError] if the matrix contains non-numeric values.
  dynamic max({int? axis}) {
    int rows = rowCount;
    int cols = columnCount;
    if (rows == 0 || cols == 0) {
      throw Exception("Matrix is empty");
    }

    if (axis != null && axis != 0 && axis != 1) {
      throw ArgumentError(
          "Axis must be 0 (for columns), 1 (for rows), or null (for total min)");
    }

    switch (axis) {
      case 0:
        return List<dynamic>.generate(
            _data[0].length,
            (i) =>
                _Utils.toNumList(_data).map((row) => row[i]).reduce(math.max));
      case 1:
        return _Utils.toNumList(_data)
            .map((row) => row.reduce(math.max))
            .toList();
      default:
        dynamic maxValue = _data[0][0];

        for (var row in _Utils.toNumList(_data)) {
          num rowMax = row.reduce(math.max);
          if (rowMax > maxValue) {
            maxValue = rowMax;
          }
        }

        return maxValue;
    }
  }

  /// Finds the maximum absolute value in the matrix starting from the given row and column indices (inclusive).
  ///
  /// [startRow]: The starting row index for the search.
  /// [startCol]: The starting column index for the search.
  /// Returns a list containing the row and column indices of the maximum absolute value found in the matrix region.
  /// Example:
  /// ```dart
  /// Matrix A = Matrix([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9]
  /// ]);
  /// List<int> maxIndices = A.findMaxInMatrixRegion(1, 1);
  /// print(maxIndices); // Output: [2, 2] (since the maximum value is 9)
  /// ```
  List<int> findMaxInMatrixRegion(int startRow, int startCol) {
    num maxValue = 0.0;
    int maxRow = startRow;
    int maxCol = startCol;

    for (int i = startRow; i < rowCount; i++) {
      for (int j = startCol; j < columnCount; j++) {
        if (this[i][j].abs() > maxValue) {
          maxValue = (this[i][j] as num).abs();
          maxRow = i;
          maxCol = j;
        }
      }
    }

    return [maxRow, maxCol];
  }

  /// Finds the minimum absolute value in the matrix starting from the given row and column indices (inclusive).
  ///
  /// [startRow]: The starting row index for the search.
  /// [startCol]: The starting column index for the search.
  /// Returns a list containing the row and column indices of the minimum absolute value found in the matrix region.
  /// Example:
  /// ```dart
  /// Matrix A = Matrix([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9]
  /// ]);
  /// List<int> minIndices = A.findMinInMatrixRegion(1, 1);
  /// print(minIndices); // Output: [1, 1] (since the minimum value is 5)
  /// ```
  List<int> findMinInMatrixRegion(int startRow, int startCol) {
    num minValue = double.maxFinite;
    int minRow = startRow;
    int minCol = startCol;

    for (int i = startRow; i < rowCount; i++) {
      for (int j = startCol; j < columnCount; j++) {
        if (this[i][j].abs() < minValue) {
          minValue = (this[i][j] as num).abs();
          minRow = i;
          minCol = j;
        }
      }
    }

    return [minRow, minCol];
  }

  /// Calculates the minimum value for each column in the matrix.
  ///
  /// Returns a list of minimum values, one for each column.
  ///
  /// Example usage:
  /// ```dart
  /// final matrix = Matrix([
  ///   [1, 2],
  ///   [3, 4],
  ///   [5, 6]
  /// ]);
  /// final mins = matrix.columnMins();
  /// print(mins);  // Output: [1, 2]
  /// ```
  List<double> columnMins() {
    List<double> mins = List.filled(columnCount, double.infinity);
    for (var row in _data) {
      for (int j = 0; j < columnCount; j++) {
        mins[j] = math.min(mins[j], row[j]);
      }
    }
    return mins;
  }

  /// Calculates the maximum value for each column in the matrix.
  ///
  /// Returns a list of maximum values, one for each column.
  ///
  /// Example usage:
  /// ```dart
  /// final matrix = Matrix([
  ///   [1, 2],
  ///   [3, 4],
  ///   [5, 6]
  /// ]);
  /// final maxs = matrix.columnMaxs();
  /// print(maxs);  // Output: [5, 6]
  /// ```
  List<double> columnMaxs() {
    List<double> maxs = List.filled(columnCount, double.negativeInfinity);
    for (var row in _data) {
      for (int j = 0; j < columnCount; j++) {
        maxs[j] = math.max(maxs[j], row[j]);
      }
    }
    return maxs;
  }

  /// Calculates the mean value for each column in the matrix.
  ///
  /// Returns a list of mean values, one for each column.
  ///
  /// Example usage:
  /// ```dart
  /// final matrix = Matrix([
  ///   [1, 2],
  ///   [3, 4],
  ///   [5, 6]
  /// ]);
  /// final means = matrix.columnMeans();
  /// print(means);  // Output: [3.0, 4.0]
  /// ```
  List<double> columnMeans() {
    List<double> sums = List.filled(columnCount, 0.0);
    for (var row in _data) {
      for (int j = 0; j < columnCount; j++) {
        sums[j] += row[j];
      }
    }
    return sums.map((sum) => sum / rowCount).toList();
  }

  /// Calculates the standard deviation for each column in the matrix.
  ///
  /// Returns a list of standard deviation values, one for each column.
  ///
  /// Example usage:
  /// ```dart
  /// final matrix = Matrix([
  ///   [1, 2],
  ///   [3, 4],
  ///   [5, 6]
  /// ]);
  /// final stdDevs = matrix.columnStdDevs();
  /// print(stdDevs);  // Output: [1.632993161855452, 1.632993161855452]
  /// ```
  List<dynamic> columnStdDevs() {
    List<double> means = columnMeans();
    List<double> variances = List.filled(columnCount, 0.0);

    for (var row in _data) {
      for (int j = 0; j < columnCount; j++) {
        variances[j] += math.pow(row[j] - means[j], 2);
      }
    }

    return variances.map((variance) => math.sqrt(variance / rowCount)).toList();
  }

  /// Calculates the minimum value for each row in the matrix.
  ///
  /// Returns a list of minimum values, one for each row.
  ///
  /// Example usage:
  /// ```dart
  /// final matrix = Matrix([
  ///   [1, 2],
  ///   [3, 4],
  ///   [5, 6]
  /// ]);
  /// final mins = matrix.rowMins();
  /// print(mins);  // Output: [1, 3, 5]
  /// ```
  List<dynamic> rowMins() {
    return _Utils.toNumList(_data).map((row) => row.reduce(math.min)).toList();
  }

  /// Calculates the maximum value for each row in the matrix.
  ///
  /// Returns a list of maximum values, one for each row.
  ///
  /// Example usage:
  /// ```dart
  /// final matrix = Matrix([
  ///   [1, 2],
  ///   [3, 4],
  ///   [5, 6]
  /// ]);
  /// final maxs = matrix.rowMaxs();
  /// print(maxs);  // Output: [2, 4, 6]
  /// ```
  List<dynamic> rowMaxs() {
    return _Utils.toNumList(_data).map((row) => row.reduce(math.max)).toList();
  }

  /// Calculates the mean value for each row in the matrix.
  ///
  /// Returns a list of mean values, one for each row.
  ///
  /// Example usage:
  /// ```dart
  /// final matrix = Matrix([
  ///   [1, 2],
  ///   [3, 4],
  ///   [5, 6]
  /// ]);
  /// final means = matrix.rowMeans();
  /// print(means);  // Output: [1.5, 3.5, 5.5]
  /// ```
  List<double> rowMeans() {
    return _data
        .map((row) =>
            ((row.reduce((a, b) => a + b) / row.length) as num).toDouble())
        .toList();
  }

  /// Calculates the standard deviation for each row in the matrix.
  ///
  /// Returns a list of standard deviation values, one for each row.
  ///
  /// Example usage:
  /// ```dart
  /// final matrix = Matrix([
  ///   [1, 2],
  ///   [3, 4],
  ///   [5, 6]
  /// ]);
  /// final stdDevs = matrix.rowStdDevs();
  /// print(stdDevs);  // Output: [0.7071067811865476, 0.7071067811865476, 0.7071067811865476]
  /// ```
  List<dynamic> rowStdDevs() {
    return _data.map((row) {
      double mean = row.reduce((a, b) => a + b) / row.length;
      double variance =
          row.map((x) => math.pow(x - mean, 2)).reduce((a, b) => a + b) /
              row.length;
      return math.sqrt(variance);
    }).toList();
  }

  /// Returns the rank of the matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [2, 4]]);
  /// print(matrix.rank()); // Output: 1
  /// ```
  int rank() {
    int rows = rowCount;
    int cols = columnCount;

    Matrix reducedMatrix = Matrix([
      for (int i = 0; i < rows; i++) [for (int j = 0; j < cols; j++) this[i][j]]
    ]);

    int rank = 0;
    bool rowAllZeros;

    for (int r = 0; r < rows; ++r) {
      if (reducedMatrix[r][rank] != 0) {
        for (int c = 0; c < rows; ++c) {
          // Changed 'cols' to 'rows'
          if (c != r) {
            double ratio = reducedMatrix[c][rank] / reducedMatrix[r][rank];
            for (int i = rank; i < cols; ++i) {
              reducedMatrix[c][i] -= ratio * reducedMatrix[r][i];
            }
          }
        }
        rank++;
      } else {
        rowAllZeros = true;
        for (int i = r + 1; i < rows; ++i) {
          if (reducedMatrix[i][rank] != 0) {
            List<dynamic> tmp = reducedMatrix[r];
            reducedMatrix[r] = reducedMatrix[i];
            reducedMatrix[i] = tmp;

            rowAllZeros = false;
            break;
          }
        }

        if (!rowAllZeros) {
          --r;
        }
      }

      if (rank == cols) {
        break;
      }
    }

    return rank;
  }

  /// Returns the mean of all elements in the matrix.
  ///
  /// Example:
  ///
  /// ```dart
  /// var matrix = Matrix([[1.0, 2.0], [3.0, 4.0]]);
  /// print(matrix.mean()); // Output: 2.5
  /// ```
  num mean() {
    return sum() / (rowCount * columnCount);
  }

  /// Returns the median of all elements in the matrix.
  ///
  /// If the number of elements in the matrix is even, it will return the average of the two middle elements.
  /// If the number is odd, it will return the middle element.
  ///
  /// Example:
  ///
  /// ```dart
  /// var matrix = Matrix([[1.0, 2.0], [3.0, 4.0]]);
  /// print(matrix.median()); // Output: 2.5
  /// ```
  num median() {
    var sortedData = _data.expand((element) => element).toList()..sort();
    int midIndex = sortedData.length ~/ 2;
    if (sortedData.length.isEven) {
      return (sortedData[midIndex - 1] + sortedData[midIndex]) / 2;
    } else {
      return sortedData[midIndex];
    }
  }

  /// Returns the variance of the elements in the matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[2, 3], [1, 4]]);
  /// print(matrix.variance()); // Output: 1.25
  /// ```
  num variance() {
    num meanValue = mean();
    double sum = 0;
    int count = 0;

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        double diff = _data[i][j] - meanValue;
        sum += diff * diff;
        count++;
      }
    }

    return sum / count;
  }

  /// Returns the standard deviation of the elements in the matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[2, 3], [1, 4]]);
  /// print(matrix.standardDeviation()); // Output: 1.118033988749895
  /// ```
  num standardDeviation() {
    return math.sqrt(variance());
  }

  /// Returns the covariance matrix of the input matrix.
  ///
  /// Throws an exception if the matrix is empty.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4], [5, 6]]);
  /// print(matrix.covarianceMatrix());
  /// // Output:
  /// // 4.0 4.0
  /// // 4.0 4.0
  /// ```
  Matrix covarianceMatrix() {
    if (rowCount == 0) {
      throw Exception("Matrix is empty");
    }

    int dimensions = columnCount;
    int n = rowCount;

    List<List<double>> means = [];
    for (int j = 0; j < dimensions; j++) {
      double sum = 0;
      for (int i = 0; i < n; i++) {
        sum += _data[i][j];
      }
      means.add(List<double>.filled(n, sum / n));
    }

    List<List<double>> centeredData = [];
    for (int i = 0; i < n; i++) {
      List<double> row = [];
      for (int j = 0; j < dimensions; j++) {
        row.add(_data[i][j] - means[j][i]);
      }
      centeredData.add(row);
    }

    List<List<double>> covMatrix =
        List.generate(dimensions, (_) => List<double>.filled(dimensions, 0));

    for (int i = 0; i < dimensions; i++) {
      for (int j = 0; j < dimensions; j++) {
        double sum = 0;
        for (int k = 0; k < n; k++) {
          sum += centeredData[k][i] * centeredData[k][j];
        }
        covMatrix[i][j] = sum / (n - 1);
      }
    }

    return Matrix(covMatrix);
  }

  /// Returns the Pearson correlation coefficient matrix of the input matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4], [5, 6]]);
  /// print(matrix.pearsonCorrelationCoefficient());
  /// // Output:
  /// // 1.0 1.0
  /// // 1.0 1.0
  /// ```
  Matrix pearsonCorrelationCoefficient() {
    Matrix covMatrix = covarianceMatrix();
    List<double> stdDevs = [];

    for (int i = 0; i < covMatrix.rowCount; i++) {
      stdDevs.add(math.sqrt(covMatrix[i][i]));
    }

    List<List<double>> correlationMatrix =
        List.generate(rowCount, (_) => List<double>.filled(columnCount, 0));

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        correlationMatrix[i][j] = covMatrix[i][j] / (stdDevs[i] * stdDevs[j]);
      }
    }

    return Matrix(correlationMatrix);
  }

  /// Returns the skewness of the elements in the matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4], [5, 6]]);
  /// print(matrix.skewness()); // Output: 0.0
  /// ```
  num skewness() {
    num meanValue = mean();
    num sum = 0;
    int count = 0;

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        double diff = _data[i][j] - meanValue;
        sum += math.pow(diff, 3);
        count++;
      }
    }

    num skewness = sum / count;
    num standardDeviationCubed = math.pow(standardDeviation(), 3) as double;
    return skewness / standardDeviationCubed;
  }

  /// Returns the kurtosis of the elements in the matrix.
  ///
  /// Example:
  /// ```dart
  /// var matrix = Matrix([[1, 2], [3, 4], [5, 6]]);
  /// print(matrix.kurtosis()); // Output: -1.2
  /// ```
  num kurtosis() {
    num meanValue = mean();
    num sum = 0;
    int count = 0;

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        double diff = _data[i][j] - meanValue;
        sum += math.pow(diff, 4);
        count++;
      }
    }

    num kurtosis = sum / count;
    num standardDeviationFourth = math.pow(standardDeviation(), 4) as double;
    return kurtosis / standardDeviationFourth - 3;
  }

  /// Returns the row echelon form (REF) of the current matrix.
  ///
  /// Algorithm:
  /// 1. Initialize the result matrix as a copy of the current matrix.
  /// 2. Iterate through the rows of the matrix.
  /// 3. If a pivot element is found, swap the rows and normalize the row.
  /// 4. Eliminate the elements below the pivot.
  ///
  /// Example:
  /// ```dart
  /// final matrix = Matrix([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9]
  /// ]);
  /// final refMatrix = matrix.rowEchelonForm();
  /// print(refMatrix);
  /// ```
  ///
  /// Output:
  /// ```dart
  /// 1  2  3
  /// 0 -3 -6
  /// 0  0  0
  /// ```
  Matrix rowEchelonForm() {
    Matrix result = _Utils.toNumMatrix(copy());
    int lead = 0;
    int rowCount = result.rowCount;
    int columnCount = result.columnCount;

    for (int r = 0; r < rowCount; r++) {
      if (lead >= columnCount) {
        break;
      }
      int i = r;
      while (result[i][lead] == 0) {
        i++;
        if (i == rowCount) {
          i = r;
          lead++;
          if (lead == columnCount) {
            return result;
          }
        }
      }
      result.swapRows(i, r);
      if (result[r][lead] != 0) {
        result.scaleRow(r, 1 / result[r][lead]);
      }
      for (i = r + 1; i < rowCount; i++) {
        result.addRow(r, i, -result[i][lead]);
      }
      lead++;
    }

    return result;
  }

  /// Returns the reduced row echelon form (RREF) of the current matrix.
  ///
  /// Example:
  /// ```dart
  /// final matrix = Matrix([
  ///   [1, 2, 3],
  ///   [4, 5, 6],
  ///   [7, 8, 9]
  /// ]);
  /// final rrefMatrix = matrix.rref();
  /// print(rrefMatrix);
  /// ```
  ///
  /// Output:
  /// ```dart
  /// 1  0 -1
  /// 0  1  2
  /// 0  0  0
  /// ```
  Matrix reducedRowEchelonForm() {
    Matrix result = rowEchelonForm();
    int rowCount = result.rowCount;

    for (int r = rowCount - 1; r >= 0; r--) {
      int nonZeroIndex = _Utils.getFirstNonZeroIndex(result[r]);

      if (nonZeroIndex != -1) {
        for (int i = r - 1; i >= 0; i--) {
          result.addRow(r, i, -result[i][nonZeroIndex]);
        }
      }
    }

    return result;
  }
}
