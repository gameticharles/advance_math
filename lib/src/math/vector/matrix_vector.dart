part of vector;

extension MatrixVectorConversion on Matrix {
  // Convert a column vector matrix to a Vector object
  Vector toVector() {
    if (columnCount != 1) {
      throw ArgumentError(
          "Matrix must have exactly one column to be converted to a vector.");
    }

    List<double> data = List<double>.filled(rowCount, 0);
    for (int i = 0; i < rowCount; i++) {
      data[i] = this[i][0];
    }

    return Vector.fromList(data);
  }

  // Convert a Vector object to a column vector matrix
  static Matrix fromVector(Vector vector) {
    Matrix result = Matrix.zeros(vector.length, 1);
    for (int i = 0; i < vector.length; i++) {
      result[i][0] = vector[i];
    }
    return result;
  }
}
