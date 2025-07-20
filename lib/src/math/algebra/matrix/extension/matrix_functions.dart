part of '../../algebra.dart';

extension MatrixFunctions on Matrix {
  /// Element-wise sine
  Matrix sin() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.sin(this[i][j]);
      }
    }
    return result;
  }

  /// Element-wise cosine
  Matrix cos() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.cos(this[i][j]);
      }
    }
    return result;
  }

  /// Element-wise tangent
  Matrix tan() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.tan(this[i][j]);
      }
    }
    return result;
  }

  /// Element-wise arcsine
  Matrix asin() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.asin(this[i][j]);
      }
    }
    return result;
  }

  /// Element-wise arccosine
  Matrix acos() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.acos(this[i][j]);
      }
    }
    return result;
  }

  /// Element-wise arctangent
  Matrix atan() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.atan(this[i][j]);
      }
    }
    return result;
  }

  /// Element-wise atan2
  Matrix atan2(Matrix other) {
    if (rowCount != other.rowCount || columnCount != other.columnCount) {
      throw ArgumentError('Matrix dimensions must match for atan2');
    }

    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.atan2(this[i][j], other[i][j]);
      }
    }
    return result;
  }

  /// Element-wise sinh
  Matrix sinh() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.sinh(this[i][j]);
      }
    }
    return result;
  }

  /// Element-wise cosh
  Matrix cosh() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.cosh(this[i][j]);
      }
    }
    return result;
  }

  /// Element-wise tanh
  Matrix tanh() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.tanh(this[i][j]);
      }
    }
    return result;
  }

  /// Element-wise asinh
  Matrix asinh() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.asinh(this[i][j]);
      }
    }
    return result;
  }

  /// Element-wise acosh
  Matrix acosh() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.acosh(this[i][j]);
      }
    }
    return result;
  }

  /// Element-wise atanh
  Matrix atanh() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.atanh(this[i][j]);
      }
    }
    return result;
  }

  /// Element-wise exponential
  Matrix exp() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.exp(this[i][j]);
      }
    }
    return result;
  }

  /// Element-wise natural logarithm
  Matrix log() {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.log(this[i][j]);
      }
    }
    return result;
  }

  /// Element-wise logarithm for any base
  Matrix logn(num base) {
    Matrix result = Matrix.zeros(rowCount, columnCount, isDouble: true);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] = math.log(this[i][j]) / math.log(base);
      }
    }
    return result;
  }

  /// Raises this matrix to a given power.
  /// Uses eigenvalue decomposition for non-integer powers and binary exponentiation for integer powers.
  ///
  /// Note: For non-symmetric matrices, the eigenvalues might be complex, and thus
  /// the result of raising them to a power could also be complex. In such cases,
  /// the output of this function might not be accurate.
  ///
  /// If the matrix is not square, this method throws an ArgumentError.
  /// If a negative eigenvalue is encountered when trying to compute a fractional power,
  /// this method throws an ArgumentError.
  ///
  /// [power] - the power to which this matrix should be raised.
  /// Returns a new matrix that is this matrix raised to the given power.
  Matrix pow(num power) {
    // Ensure the matrix is square
    if (rowCount != columnCount) {
      throw ArgumentError('Matrix must be square to raise it to a power.');
    }

    if (power < 0) {
      throw ArgumentError('Power must be non-negative.');
    }

    if (power == power.floor()) {
      // Use binary exponentiation for integer powers
      Matrix result = Matrix.eye(rowCount);
      Matrix base = this;
      int p = power.toInt();

      while (p > 0) {
        if (p % 2 == 1) {
          result = result * base;
        }
        base = base * base;
        p = p ~/ 2;
      }

      return result;
    } else {
      // Perform eigenvalue decomposition
      var eigenvalueDecomposition = decomposition.eigenvalueDecomposition();
      Matrix D = eigenvalueDecomposition.D;
      Matrix V = eigenvalueDecomposition.V;

      // Raise eigenvalues to the given power
      for (int i = 0; i < D.rowCount; i++) {
        if (D[i][i] < 0 && power != power.floor()) {
          throw ArgumentError(
              'Negative eigenvalue found when trying to compute fractional power.');
        }
        D[i][i] = math.pow(D[i][i], power);
      }

      // Reconstruct the matrix using the pseudo-inverse of V
      var result = V * D * V.pseudoInverse();

      return result;
    }
  }
}
