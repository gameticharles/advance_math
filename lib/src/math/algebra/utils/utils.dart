part of '../algebra.dart';

/* TODO:
Performance Optimizations:
   - Implement parallel processing techniques to improve the performance of computationally intensive operations (e.g., matrix multiplication, decompositions)
   - Optimize existing methods using efficient algorithms or data structures

*/

class _Utils {
  static List<List<dynamic>> parseMatrixString(String input) {
    return input
        .split(';')
        .map((rowString) => rowString
            .trim()
            .split(RegExp(r'\s+'))
            .map((elem) => Complex.parse(elem))
            .toList())
        .toList();
  }

// Helper function to parse index ranges
  static List<int> parseRange(String range, int maxIndex) {
    final rangeParts = range.split(':');
    final start = rangeParts.isNotEmpty && rangeParts[0].isNotEmpty
        ? int.parse(rangeParts[0])
        : 0;
    final end = rangeParts.length > 1 && rangeParts[1].isNotEmpty
        ? int.parse(rangeParts[1])
        : maxIndex - 1;
    return [start, end];
  }

  ///Convert the dynamic matrix to appropriate types
  ///Converts numbers and strings to Complex, preserves other types like boolean
  static List<List<dynamic>> toNumList(List<List<dynamic>> input) {
    return input
        .map((row) => row
            .map((value) {
              if (value is Complex) return value;
              if (value is num || value is String) {
                try {
                  return Complex.parse(value.toString());
                } catch (_) {
                  return value; // Keep original if parsing fails
                }
              }
              return value; // Preserve other types (boolean, etc.)
            })
            .toList())
        .toList();
  }

  /// Convert a dynamic matrix to double matrix
  static Matrix toNumMatrix(Matrix input) {
    return Matrix(toNumList(input._data));
  }

  ///Convert a dynamic list to double list
  static List<dynamic> toSDList(List<dynamic> list) {
    return list.map((e) {
      if (e is num || e is Complex) {
        return e is Complex ? e : Complex.parse(e.toString());
      } else {
        throw ArgumentError('List element is not of type num');
      }
    }).toList();
  }

  /// Default tolerance for approximate equality comparison
  static double defaultTolerance = 1e-6;

  /// Map of operator functions that can be used for element-wise comparisons.
  ///
  /// - '>': greater than
  /// - '<': less than
  /// - '>=': greater than or equal to
  /// - '<=': less than or equal to
  /// - '==': equal to
  /// - '!=': not equal to
  /// - '~=': approximately equal to, within defaultTolerance
  /// - 'is': checks if the runtime type of the left operand is the same as the right operand
  /// - 'is!': checks if the runtime type of the left operand is not the same as the right operand
  static final Map<String, Function(dynamic, dynamic)> comparisonFunctions = {
    '>': (a, b) => a > b,
    '<': (a, b) => a < b,
    '>=': (a, b) => a >= b,
    '<=': (a, b) => a <= b,
    '==': (a, b) => a == b,
    '!=': (a, b) => a != b,
    '~=': (a, b) => (a - b).abs() < defaultTolerance, // approximate equality
    'is': (a, b) => a.runtimeType == b,
    'is!': (a, b) => a.runtimeType != b,
  };

  // Helper method for solving a linear system using backward substitution.
  static Matrix backwardSubstitution(Matrix upper, Matrix y) {
    int rowCount = upper.rowCount;
    int colCount = y.columnCount;
    Matrix x = Matrix.zeros(rowCount, colCount, isDouble: true);

    for (int i = rowCount - 1; i >= 0; i--) {
      for (int j = 0; j < colCount; j++) {
        x[i][j] = y[i][j];
        for (int k = i + 1; k < rowCount; k++) {
          x[i][j] -= upper[i][k] * x[k][j];
        }
        x[i][j] /= upper[i][i];
      }
    }

    return x;
  }

  // Helper method for solving a linear system using forward substitution.
  static Matrix forwardSubstitution(Matrix lower, Matrix b) {
    int rowCount = lower.rowCount;
    int colCount = b.columnCount;
    Matrix y = Matrix.zeros(rowCount, colCount);

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < colCount; j++) {
        y[i][j] = b[i][j];
        for (int k = 0; k < i; k++) {
          y[i][j] -= lower[i][k] * y[k][j];
        }
        y[i][j] /= lower[i][i];
      }
    }

    return y;
  }

  // Helper method for forward elimination.
  static Matrix forwardElimination(Matrix a, Matrix b,
      {bool forLUDecomposition = false}) {
    int rowCount = a.rowCount;

    for (int k = 0; k < rowCount - 1; k++) {
      for (int i = k + 1; i < rowCount; i++) {
        dynamic factor = a[i][k] / a[k][k];
        if (forLUDecomposition) {
          a[i][k] = factor;
        }
        for (int j = k + 1; j < rowCount; j++) {
          a[i][j] -= factor * a[k][j];
        }
        for (int j = 0; j < b.columnCount; j++) {
          b[i][j] -= factor * b[k][j];
        }
      }
    }

    return a;
  }

  // Helper function to get the sum
  static dynamic sumLUk(Matrix L, Matrix U, int k, int row, int col) {
    Complex sum = Complex.zero();
    for (int p = 0; p < k; p++) {
      sum += L[row][p] * U[p][col];
    }
    return sum;
  }

  static int getFirstNonZeroIndex(List<dynamic> row) {
    for (int i = 0; i < row.length; i++) {
      if (row[i] != 0) {
        return i;
      }
    }
    return -1;
  }

  /// Calculate the Householder reflection matrix for a given vector
  static Matrix householderReflection(Matrix columnVector) {
    int n = columnVector.rowCount;
    Matrix e1 = Matrix.zeros(n, 1);
    e1[0][0] = Complex.one();

    // Check if the matrix is filled with zeros and return the identity matrix if true
    if (columnVector.norm() == Complex.zero()) {
      return Matrix.eye(n);
    }

    Matrix u =
        (columnVector + e1) * columnVector.norm() * columnVector[0][0].sign;

    Matrix P = Matrix.eye(n) -
        ((u * u.transpose()) * (Complex(2) / math.pow(u.norm(), Complex(2))));

    return P;
  }

  /// Returns a string representation of the matrix with its shape and elements separated by the specified separator.
  ///
  /// [separator]: A string used to separate matrix elements in a row. Default is a space character (' ').
  /// [alignment]: A string indicating the alignment of the elements in each column. Default is 'right'.
  /// [isPrettyMatrix]: A boolean indicating whether the matrix is pretty or not (as lists). Default is true
  ///
  /// Example:
  /// ```dart
  /// var m = Matrix([[1, 2], [3, 4]]);
  /// print(m.toString(separator: ' ', isPrettyMatrix = true, alignment: 'right'));
  /// // Output:
  /// // Matrix: 2x2
  /// // ┌ 1 2 ┐
  /// // └ 3 4 ┘
  /// ```
  static String matString(Matrix m,
      {String separator = ' ',
      bool isPrettyMatrix = true,
      MatrixAlign alignment = MatrixAlign.right}) {
    List<int> columnWidths = List.generate(m.columnCount, (_) => 0);
    List<String> rows = [];

    for (var row in m.toList()) {
      row.asMap().forEach((index, element) => columnWidths[index] =
          math.max(columnWidths[index], element.toString().length).toInt());
    }

    rows = m
        .toList()
        .map((row) => row
            .asMap()
            .entries
            .map((entry) => alignment == MatrixAlign.left
                ? entry.value.toString().padRight(columnWidths[entry.key])
                : entry.value.toString().padLeft(columnWidths[entry.key]))
            .join(separator))
        .toList();

    if (m.rowCount == 1) {
      return 'Matrix: ${m.rowCount}x${m.columnCount}\n[ ${rows[0]} ]';
    }

    String matToString = '';

    //Return empty matrix string
    if (m.toList().isEmpty) {
      matToString = '[ ]';
      return 'Matrix: ${m.rowCount}x${m.columnCount}\n$matToString';
    }

    if (isPrettyMatrix) {
      String top = '┌ ${rows[0]} ┐';
      String middle = m.rowCount > 2
          ? rows.sublist(1, m.rowCount - 1).map((row) => '│ $row │').join('\n')
          : '';
      String bottom = '└ ${rows[m.rowCount - 1]} ┘';
      matToString =
          middle.isNotEmpty ? '$top\n$middle\n$bottom' : '$top\n$bottom';
    } else {
      String matrixRepresentation = rows.map((row) => ' [ $row ]').join('\n');
      matToString = '[\n$matrixRepresentation\n]';
    }

    return 'Matrix: ${m.rowCount}x${m.columnCount}\n$matToString';
  }
}
