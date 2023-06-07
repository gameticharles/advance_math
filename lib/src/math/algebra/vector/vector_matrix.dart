part of algebra;

extension MatrixVectorOperations on Matrix {
  /// Add a matrix and a vector
  Matrix addVector(Vector vector) {
    if (rowCount != vector.length) {
      throw ArgumentError(
          "Matrix and vector dimensions must match for addition.");
    }

    Matrix result = copy();
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] += vector[i];
      }
    }
    return result;
  }

  /// Subtract a vector from a matrix
  Matrix subtractVector(Vector vector) {
    if (rowCount != vector.length) {
      throw ArgumentError(
          "Matrix and vector dimensions must match for subtraction.");
    }

    Matrix result = copy();
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i][j] -= vector[i];
      }
    }
    return result;
  }

  Vector multiply(Vector vector) {
    if (columnCount != vector.length) {
      throw ArgumentError(
          'The number of columns in the matrix must be equal to the length of the vector for multiplication.');
    }

    Vector result = Vector(rowCount);
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        result[i] += this[i][j] * vector[j];
      }
    }

    return result;
  }
}

extension VectorMatrixOperations on Vector {
  /// Add a vector and a matrix
  Matrix addMatrix(Matrix matrix) => matrix.addVector(this);

  /// Subtract a matrix from a vector
  Matrix subtractMatrix(Matrix matrix) => matrix.subtractVector(this);
}
