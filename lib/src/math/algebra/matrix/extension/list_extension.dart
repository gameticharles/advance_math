part of algebra;

extension MatrixListExtension on List<List<dynamic>> {
  /// The shape of an array is the number of elements in each dimension.
  List get shape => Matrix(this).shape;

  /// Used to get a copy of an given array collapsed into one dimension
  List<dynamic> get flatten => Matrix(this).flatten();

  /// Reverse the axes of an array and returns the modified array.
  Matrix get transpose => Matrix(this).transpose();

  /// Create a matrix with the list
  Matrix toMatrix() => Matrix(this);

  /// Function returns the sum of array elements
  num get sum => Matrix(this).sum();

  /// To find a diagonal element from a given matrix and gives output as one dimensional matrix
  List<dynamic> get diagonal => Matrix(this).diagonal();

  /// Reshaping means changing the shape of an array.
  List reshape(int row, int column) => Matrix().reshape(row, column).toList();

  /// find min value of given matrix
  List min({int? axis}) => Matrix(this).min();

  /// find max value of given matrix
  List max({int? axis}) => Matrix(this).max();

  /// flip (`reverse`) the matrix along the given axis and returns the modified array.
  List flip({int axis = 0}) => Matrix(this).reverse(axis).toList();
}

extension ListVector on List<num> {
  List<num> plus(List<num> other) {
    if (length != other.length) {
      throw ArgumentError('Both vectors should have the same length');
    }

    return List<num>.generate(length, (i) => this[i] + other[i]);
  }

  Vector operator +(dynamic other) {
    if (length != other.length) {
      throw ArgumentError("Vectors must have the same length for addition.");
    }

    if (other is! Vector || other is! List<num>) {
      throw ArgumentError(
          "Invalid right-hand value type (Vector or List<num>).");
    }

    Vector result = Vector(length);
    for (int i = 0; i < length; i++) {
      result[i] = this[i] + other[i];
    }
    return result;
  }

  Vector operator -(dynamic other) {
    if (length != other.length) {
      throw ArgumentError("Vectors must have the same length for subtraction.");
    }

    if (other is! Vector || other is! List<num>) {
      throw ArgumentError(
          "Invalid right-hand value type (Vector or List<num>).");
    }

    Vector result = Vector(length);
    for (int i = 0; i < length; i++) {
      result[i] = this[i] - other[i];
    }
    return result;
  }

  Vector operator *(dynamic other) {
    Vector result = Vector(length);
    if (other is num) {
      for (int i = 0; i < length; i++) {
        result[i] = this[i] * other;
      }
    } else if (other is Vector) {
      for (int i = 0; i < length; i++) {
        result[i] = this[i] * other[i];
      }
    }

    return result;
  }

  Vector operator /(dynamic other) {
    Vector result = Vector(length);
    if (other is num) {
      for (int i = 0; i < length; i++) {
        result[i] = this[i] / other;
      }
    } else if (other is Vector) {
      for (int i = 0; i < length; i++) {
        result[i] = this[i] / other[i];
      }
    }
    return result;
  }
}
