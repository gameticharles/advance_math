part of algebra;

// extension DynamicVector on dynamic {
//   Matrix operator +(dynamic other) {
//     if (this is Matrix && other is Matrix) {
//       return (this as Matrix) * (Matrix);
//     }
//     return Matrix(1);
//   }
// }

extension VectorOperations on Vector {
  dynamic operator +(dynamic other) {
    if (other is Matrix) {
      return other + this;
    } else if (other is num) {
      Vector result = Vector(length);
      for (int i = 0; i < length; i++) {
        result[i] = this[i] + other;
      }
    }
    if (length != other.length) {
      throw ArgumentError("Vectors must have the same length for addition.");
    }

    if (other is! Vector && other is! List<num>) {
      throw ArgumentError(
          "Invalid right-hand value type (Vector or List<num>).");
    }

    Vector result = Vector(length);
    for (int i = 0; i < length; i++) {
      result[i] = this[i] + other[i];
    }
    return result;
  }

  dynamic operator -(dynamic other) {
    if (other is Matrix) {
      return other - this;
    } else if (other is num) {
      Vector result = Vector(length);
      for (int i = 0; i < length; i++) {
        result[i] = this[i] - other;
      }
    }
    if (length != other.length) {
      throw ArgumentError("Vectors must have the same length for subtraction.");
    }

    if (other is! Vector && other is! List<num>) {
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
    } else if (other is Matrix) {
      result = Vector((other * this).flatten().cast<num>());
    } else if (other is Vector) {
      if (length != other.length) {
        throw ArgumentError(
            "Vectors must have the same length for subtraction.");
      }
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
      if (length != other.length) {
        throw ArgumentError(
            "Vectors must have the same length for subtraction.");
      }
      for (int i = 0; i < length; i++) {
        result[i] = this[i] / other[i];
      }
    }
    return result;
  }

  /// Negates this vector element-wise.
  ///
  /// Returns a new vector containing the result of the element-wise negation.
  ///
  /// Example:
  /// ``` dart
  /// var vector = Vector([1, 2, 3]);
  /// var result = -vector;
  /// print(result);
  /// // Output:   /// // -1 -2 -3
  /// ```
  Vector operator -() {
    List<num> newData = List.generate(length, (i) => -_data[i]);

    return Vector(newData);
  }

  /// Calculates the dot product of the vector with another vector.
  ///
  /// The two vectors must have the same length. If they don't, an
  /// ArgumentError is thrown.
  double dot(Vector other) {
    if (length != other.length) {
      throw ArgumentError("Vectors must have the same length for dot product.");
    }
    double result = 0;
    for (int i = 0; i < length; i++) {
      result += this[i] * other[i];
    }
    return result;
  }

  /// Calculates the cross product of the vector with another vector.
  ///
  /// Both vectors must be three-dimensional. If they are not, an
  /// ArgumentError is thrown.
  Vector cross(Vector other) {
    if (length != 3 || other.length != 3) {
      throw ArgumentError("Both vectors must be three-dimensional.");
    }
    return Vector.fromList([
      this[1] * other[2] - this[2] * other[1],
      this[2] * other[0] - this[0] * other[2],
      this[0] * other[1] - this[1] * other[0]
    ]);
  }

  /// Checks if this [Vector] is parallel to [other].
  ///
  /// Two vectors are parallel if their cross product has a magnitude of 0.
  ///
  /// Example:
  /// ```dart
  /// var vector1 = Vector(1, 0, 0);
  /// var vector2 = Vector(2, 0, 0);
  /// print(vector1.isParallelTo(vector2)); // Output: true
  /// ```
  ///
  /// Returns `true` if the vectors are parallel, and `false` otherwise.
  bool isParallelTo(Vector other) {
    if (length != 3 || other.length != 3) {
      throw ArgumentError("Both vectors must be three-dimensional.");
    }
    if (magnitude == 0 || other.magnitude == 0) {
      throw ArgumentError(
          'Neither the Vector nor the other Vector can be zero');
    }

    return cross(other).magnitude < 1e-10;
  }

  /// Checks if this [Vector] is perpendicular to [other].
  ///
  /// Two vectors are perpendicular if their dot product is 0.
  ///
  /// Example:
  /// ```dart
  /// var vector1 = Vector(1, 0, 0);
  /// var vector2 = Vector(0, 1, 0);
  /// print(vector1.isPerpendicularTo(vector2)); // Output: true
  /// ```
  ///
  /// Returns `true` if the vectors are perpendicular, and `false` otherwise.
  bool isPerpendicularTo(Vector other) {
    if (length != 3 || other.length != 3) {
      throw ArgumentError("Both vectors must be three-dimensional.");
    }
    if (magnitude == 0 || other.magnitude == 0) {
      throw ArgumentError(
          'Neither the Vector nor the other Vector can be zero');
    }

    return dot(other).abs() < 1e-10;
  }

  /// Rounds each element in the vector to the specified number of decimal places.
  ///
  /// [decimalPlaces]: The number of decimal places to round to.
  ///
  /// Returns a new vector with the rounded elements.
  ///
  /// Example:
  ///
  /// ```dart
  /// var vector = Vector([1.2345, 2.3456]);
  ///
  /// var roundedVector = vector.round(3);
  ///
  /// print(roundedMatrix);
  /// // Output:
  /// // 1.235  2.346
  /// // 3.457  4.568
  /// ```
  Vector round([int decimalPlaces = 0]) {
    // Create a new data structure for the rounded matrix
    List<num> newData = List.filled(length, decimalPlaces == 0 ? 0 : 0.0);

    // Iterate over each element in the matrix
    for (int i = 0; i < length; i++) {
      if (decimalPlaces == 0) {
        newData[i] = _data[i].round();
      } else {
        newData[i] = (_data[i] * math.pow(10, decimalPlaces)).round() /
            math.pow(10, decimalPlaces);
      }
    }

    return Vector(newData);
  }

  /// Scales a vector by a given scalar.
  ///
  /// The scalar is multiplied to each element of the vector, resulting in a new vector.
  ///
  /// This operation can be used for various purposes, like resizing, reflection, or changing the direction of the vector.
  ///
  /// [scalar]: The scalar number to multiply with each component of the vector.
  ///
  /// Returns a new [Vector] that is the scaled version of the original vector.
  ///
  /// Example:
  /// ```dart
  /// var v = Vector.fromList([1.0, 2.0, 3.0]);
  /// var scaled = v.scale(2);
  /// print(scaled); // "Vector(2.0, 4.0, 6.0)"
  /// ```
  ///
  /// In the example, the original vector `v` is scaled by a factor of 2,
  /// resulting in a new vector `scaled` where each component is twice its original value.
  ///
  /// @param b The scalar value to multiply the vector by.
  /// @return A new Vector that is the original Vector scaled by `b`.
  Vector scale(num scalar) {
    return Vector.fromList(_data.map((e) => e * scalar).toList());
  }

  /// Returns the magnitude (or norm) of the vector.
  ///
  /// This is equivalent to the Euclidean length of the vector.
  num get magnitude => norm();

  /// Returns the direction (or angle) of the vector, in radians.
  ///
  /// This is only valid for 2D vectors. For vectors of other dimensions, an
  /// AssertionError is thrown.
  double get direction {
    assert(length == 2, 'Direction can only be calculated for 2D vectors');
    return math.atan2(_data[1], _data[0]);
  }

  /// Returns the norm (or length) of this vector.
  ///
  /// The norm of a vector is the square root of the sum of the squares of its elements.
  /// It gives a measure of the magnitude (or length) of the vector.
  ///
  /// Example:
  /// ```dart
  /// var v = Vector.fromList([3, 4]);
  /// print(v.norm());
  /// ```
  ///
  /// Output:
  /// ```
  /// 5.0
  /// ```
  /// Explanation:
  /// The vector [3, 4] has a norm of 5 because sqrt(3*3 + 4*4) = sqrt(9 + 16) = sqrt(25) = 5.
  num norm([Norm normType = Norm.frobenius]) {
    switch (normType) {
      case Norm.frobenius:
        return math
            .sqrt(_data.map((value) => value * value).reduce((a, b) => a + b));
      case Norm.manhattan:
        return _data.map((value) => value.abs()).reduce((a, b) => a + b);
      case Norm.chebyshev:
        return _data
            .map((value) => value.abs())
            .reduce((a, b) => math.max(a, b));
      case Norm.hamming:
        return _data.where((value) => value != 0).length;
      case Norm.cosine:
        final magnitude =
            math.sqrt(_data.map((v) => v * v).reduce((a, b) => a + b));
        final vDot = dot(this);
        return vDot / magnitude;
      // The below norms need more context to implement.
      case Norm.mahalanobis:
        throw UnimplementedError('Mahalanobis norm is not implemented');
      case Norm.spectral:
      case Norm.trace:
      default:
        throw Exception('Invalid norm type');
    }
  }

  /// Returns this vector normalized.
  ///
  /// Normalizing a vector scales it so that its norm becomes 1. The resulting vector
  /// points in the same direction as the original vector.
  /// This method throws an `ArgumentError` if this is a zero vector, as zero vectors cannot be normalized.
  ///
  /// Example:
  /// ```dart
  /// var v = Vector.fromList([3, 4]);
  /// print(v.normalize());
  /// ```
  ///
  /// Output:
  /// ```
  /// [0.6, 0.8]
  /// ```
  /// Explanation:
  /// The vector [3, 4] gets normalized to [0.6, 0.8] because 3/5 = 0.6 and 4/5 = 0.8,
  /// where 5 is the norm of the original vector.
  Vector normalize([Norm normType = Norm.frobenius]) {
    num normValue = norm(normType);
    if (normValue == 0) {
      throw ArgumentError("Cannot normalize a zero vector.");
    }
    return this / normValue;
  }

  /// Rescales the vector to the range 0-1.
  ///
  /// It applies the Min-Max normalization technique on the vector.
  ///
  /// Example:
  /// ```dart
  /// var v = Vector.fromList([1.0, 2.0, 3.0, 4.0, 5.0]);
  /// print(v.rescale());
  /// // Output: [0.0, 0.25, 0.5, 0.75, 1.0]
  /// ```
  Vector rescale() {
    num maxElement = _data.reduce(math.max);
    num minElement = _data.reduce(math.min);

    return Vector.fromList(_data
        .map((n) => (n - minElement) / (maxElement - minElement))
        .toList());
  }

  /// Returns the arithmetic mean of the vector.
  ///
  /// Usage:
  /// ```dart
  /// var vector = Vector([1.0, 2.0, 3.0, 4.0, 5.0]);
  /// print(vector.mean());  // Output: 3.0
  /// ```
  num mean() {
    return sum() / length;
  }

  /// Returns the median value of the vector.
  /// If the vector has an even number of elements, the median is calculated as the mean of the two central elements.
  ///
  /// Usage:
  /// ```dart
  /// var vector = Vector([1.0, 2.0, 3.0, 4.0, 5.0]);
  /// print(vector.median());  // Output: 3.0
  /// ```
  num median() {
    List<num> sortedData = _data..sort();
    int midIndex = sortedData.length ~/ 2;
    if (sortedData.length.isEven) {
      return (sortedData[midIndex - 1] + sortedData[midIndex]) / 2;
    } else {
      return sortedData[midIndex];
    }
  }

  /// Returns the sum of all elements in the vector.
  ///
  /// Usage:
  /// ```dart
  /// var vector = Vector([1.0, 2.0, 3.0, 4.0, 5.0]);
  /// print(vector.sum());  // Output: 15.0
  /// ```
  num sum() {
    return _data.fold<num>(0, (a, b) => a + b);
  }

  /// Returns the product of all elements in the vector.
  ///
  /// Usage:
  /// ```dart
  /// var vector = Vector([1.0, 2.0, 3.0]);
  /// print(vector.product());  // Output: 6.0
  /// ```
  num product() {
    return _data.fold<num>(1, (a, b) => a * b);
  }

  /// Computes the inner product of two vectors.
  ///
  /// This is the operation of multiplying two vectors of the same size
  /// element-wise and summing up the results, resulting in a scalar.
  ///
  /// The vectors must have the same length, otherwise an [ArgumentError] is thrown.
  ///
  /// Example:
  /// ```dart
  /// var x = Vector([1, 2, 3]);
  /// var y = Vector([4, 5, 6]);
  /// double z = x.innerProduct(y);
  /// print(z); // 32
  /// ```
  num innerProduct(Vector other) {
    // Check that the vectors have the same length
    if (length != other.length) {
      throw ArgumentError('Vectors must have the same length');
    }
    // Initialize the result to zero
    num result = 0;
    // Loop over the elements and add their products
    for (int i = 0; i < length; i++) {
      result += this[i] * other[i];
    }
    // Return the result
    return result;
  }

  /// Computes the outer product of two vectors.
  ///
  /// This is the operation of multiplying two vectors of different sizes
  /// element-wise and forming a matrix, resulting in a matrix.
  ///
  /// The outer product of two vectors x and y is a matrix whose element at row i
  /// and column j is the product of x[i] and y[j].
  /// The matrix has the same number of rows as x and the same number of columns as y.
  ///
  /// Example:
  /// ```dart
  /// var x = [1, 2, 3];
  /// var y = [4, 5];
  /// var z = x.outerProduct(y);
  /// print(z);
  ///
  /// // Output:
  /// // Matrix: 3x2
  /// // ┌  4  5 ┐
  /// // │  8 10 │
  /// // └ 12 15 ┘
  /// ```
  Matrix outerProduct(Vector other) {
    return Matrix(
        _data.map((xi) => other._data.map((yj) => xi * yj).toList()).toList());
  }

  /// Returns a new vector with each element being the exponential function of the corresponding element in the original vector.
  ///
  /// Usage:
  /// ```dart
  /// var vector = Vector([1.0, 2.0]);
  /// print(vector.exp());  // Output: [2.718281828459045, 7.3890560989306495]
  /// ```
  Vector exp() {
    return Vector.fromList(_data.map(math.exp).toList());
  }

  /// Returns a new vector with each element being raised to the provided exponent.
  ///
  /// Usage:
  /// ```dart
  /// var vector = Vector([2.0, 3.0]);
  /// print(vector.pow(2));  // Output: [4.0, 9.0]
  /// ```
  Vector pow(num exponent) {
    return Vector.fromList(
        _data.map((n) => math.pow(n, exponent) as num).toList());
  }

  /// Returns a new vector with the absolute values of the original vector's elements.
  ///
  /// Usage:
  /// ```dart
  /// var vector = Vector([-1.0, -2.0, 3.0]);
  /// print(vector.abs());  // Output: [1.0, 2.0, 3.0]
  /// ```
  Vector abs() {
    return Vector.fromList(_data.map((n) => n.abs()).toList());
  }
}
