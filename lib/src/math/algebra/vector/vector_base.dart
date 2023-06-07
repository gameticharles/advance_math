part of algebra;

//extends ListBase<num>
class Vector extends IterableMixin<num> {
  /// Internal data of the vector.
  List<num> _data = const [];

  /// Getter to retrieve an iterable over all elements in the matrix,
  /// regardless of their row or column.
  ///
  /// Example usage:
  /// ```
  /// final matrix = Matrix([[1, 2], [3, 4]]);
  /// matrix.elements.forEach(print); // Prints 1, 2, 3, 4
  /// ```
  Iterable<dynamic> get elements => _VectorElementIterable(this);

  /// Overrides the iterator getter to provide a VectorIterator.
  /// This iterator iterates over the elements of the vector.
  @override
  Iterator<num> get iterator => VectorIterator(this);

  /// Constructs a [Vector] of given length with all elements initialized to 0.
  ///
  /// If [isDouble] is true, the elements are initialized with 0.0,
  /// otherwise they are initialized with 0.
  Vector(dynamic input, {bool isDouble = true}) {
    if (input is int) {
      _data = List<num>.filled(input, isDouble ? 0.0 : 0);
    } else if (input is List<num>) {
      _data = input.cast<num>();
    } else {
      throw Exception('Invalid input type');
    }
  }

  /// Constructs a [Vector] from a list of numerical values.
  Vector.fromList(List<num> data) : _data = data;

  /// Constructs a new vector of the given [length] with randomly generated values.
  ///
  /// The elements of the vector are either floating point or integer numbers depending
  /// on the value of [isDouble]. If [isDouble] is true (the default), then the elements are
  /// floating point numbers between [min] (inclusive) and [max] (exclusive). If [isDouble]
  /// is false, the elements are integer numbers between [min] and [max] (both inclusive).
  ///
  /// The optional [random] parameter can be used to provide a random number generator. If not
  /// provided, a new one is created. The optional [seed] parameter can be used to set the seed
  /// of the random number generator for reproducible results.
  ///
  /// Examples
  ///
  /// ```dart
  /// // Create a vector of length 3 with random double values between 0 and 1
  /// var v1 = Vector.random(3);
  /// print(v1);
  ///
  /// // Outputs: Vector([0.1231231, 0.4564564, 0.7897897])
  ///
  /// // Create a vector of length 3 with random integer values between 0 and 10
  /// var v2 = Vector.random(3, min: 0, max: 10, isDouble: false);
  /// print(v2);
  ///
  /// // Outputs: Vector([2, 6, 9])
  ///
  /// // Create a vector of length 3 with random double values between 0 and 1, with a specific seed
  /// var v3 = Vector.random(3, seed: 42);
  /// print(v3);
  ///
  /// // Outputs: Vector([0.56756756, 0.23423423, 0.89189189])
  /// ```
  ///
  /// Parameters
  /// - [length]: The length of the vector.
  /// - [min]: The minimum value that the generated random numbers can be. Defaults to 0.
  /// - [max]: The maximum value that the generated random numbers can be. Defaults to 1.
  /// - [isDouble]: Whether to generate floating point numbers (true) or integer numbers (false).
  ///   Defaults to true.
  /// - [random]: An optional random number generator. If not provided, a new one is created.
  /// - [seed]: An optional seed for the random number generator for reproducible results.
  ///
  /// Returns
  /// A new [Vector] with randomly generated values.
  factory Vector.random(int length,
      {double min = 0,
      double max = 1,
      bool isDouble = true,
      math.Random? random,
      int? seed}) {
    if (seed != null) {
      random = math.Random(seed);
    }
    random ??= math.Random();
    List<num> data = List.generate(
      length,
      (_) => (isDouble
          ? random!.nextDouble() * (max - min) + min
          : random!.nextInt(max.toInt() - min.toInt()) + min.toInt()),
    );

    return Vector.fromList(data);
  }

  /// Creates a row Vector with equally spaced values between the start and end values (inclusive).
  ///
  /// [start]: Start value.
  /// [end]: End value.
  /// [number]: Number of equally spaced points. Default is 50.
  ///
  /// Example:
  /// ```dart
  /// var m = Vector.linespace(0, 10, 3);
  /// print(m);
  /// // Output:
  /// // Matrix: 1x3
  /// // [ 0 5 10 ]
  /// ```
  factory Vector.linspace(int start, int end, [int number = 50]) {
    if (start.runtimeType != end.runtimeType) {
      throw Exception('Start and end must be of the same type');
    }

    if (number <= 0) {
      throw Exception('Number must be a positive integer');
    }

    double step = (end - start) / (number - 1);
    List<num> data = [];
    for (int i = 0; i < number; i++) {
      data.add(start + i * step);
    }

    return Vector.fromList(data);
  }

  /// Creates a Vector with values in the specified range, incremented by the specified step size.
  ///
  /// [end]: End value (exclusive).
  /// [start]: Start value. Default is 1.
  /// [steps]: Step size. Default is 1.
  ///
  /// Example:
  /// ```dart
  /// var m = Vector.range(6,  start: 1, step: 2);
  /// print(m);
  /// // Output:
  /// // [1, 3, 5]
  /// ```
  factory Vector.range(int end, {int start = 1, int step = 1}) {
    if (start >= end) {
      throw Exception('Start must be less than end');
    }

    if (step <= 0) {
      throw Exception('Step must be a positive integer');
    }

    List<num> range = [];
    for (int i = start; i < end; i += step) {
      range.add(i);
    }

    return Vector.fromList(range);
  }

  /// Alias for Matrix.range.
  factory Vector.arrange(int end, {int start = 1, int step = 1}) {
    return Vector.range(end, start: start, step: step);
  }

  /// Fetches the value at the given index of the vector.
  num operator [](int index) => _data[index];

  /// Sets the value at the given index of the vector.
  void operator []=(int index, num value) {
    _data[index] = value;
  }

  // /// Converts the vector to a list of numerical values.
  // @override
  // List<num> toList() => _data;

  /// Returns the length (number of elements) of the vector.
  @override
  int get length => _data.length;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Vector) return false;
    Vector vector = other;
    if (vector.length != length) return false;
    for (int i = 0; i < length; ++i) {
      if (this[i] != vector[i]) return false;
    }
    return true;
  }

  /// Returns `true` if this is a zero vector, i.e., all its elements are zero.
  ///
  /// Example:
  /// ```dart
  /// var v = Vector.fromList([0, 0, 0]);
  /// print(v.isZero());
  /// ```
  ///
  /// Output:
  /// ```
  /// true
  /// ```
  bool isZero() {
    for (var i = 0; i < length; i++) {
      if (this[i] != 0) {
        return false;
      }
    }
    return true;
  }

  /// Returns `true` if this is a unit vector, i.e., its norm is 1.
  ///
  /// Example:
  /// ```dart
  /// var v = Vector.fromList([0, 1]);
  /// print(v.isUnit());
  /// ```
  ///
  /// Output:
  /// ```
  /// true
  /// ```
  bool isUnit() {
    const double tolerance =
        1e-10; // Define a suitable tolerance as per your needs
    return (norm() - 1).abs() < tolerance;
  }

  /// Sets all elements of this vector to [value].
  ///
  /// Example:
  /// ```dart
  /// var v = Vector.fromList([1, 2, 3]);
  /// v.setAll(0);
  /// print(v);
  /// ```
  ///
  /// Output:
  /// ```
  /// [0, 0, 0]
  /// ```

  // void setAll(num value) {
  //   for (var i = 0; i < length; i++) {
  //     this[i] = value;
  //   }
  // }

  /// Returns the Euclidean distance between this vector and [other].
  ///
  /// The distance is given by the formula `sqrt(sum((this[i] - other[i])^2))` for all i.
  ///
  /// Throws an `ArgumentError` if the vectors have different lengths.
  ///
  /// Example:
  /// ```dart
  /// var v1 = Vector.fromList([1, 2, 3]);
  /// var v2 = Vector.fromList([4, 5, 6]);
  /// print(v1.distance(v2));
  /// ```
  ///
  /// Output:
  /// ```
  /// 5.196152422706632
  /// ```

  num distance(Vector other, {Distance distance = Distance.frobenius}) {
    if (length != other.length) {
      throw ArgumentError(
          "Vectors must have the same length for distance calculation.");
    }

    double sumSquare = 0;
    double sumAbs = 0;
    num maxAbs = 0;
    double dotProduct = 0;
    double sumSquare1 = 0;
    double sumSquare2 = 0;
    int hammingDistance = 0;

    for (int i = 0; i < _data.length; i++) {
      final diff = _data[i] - other[i];
      final absDiff = diff.abs();

      sumSquare += diff * diff;
      sumAbs += absDiff;
      maxAbs = math.max(maxAbs, absDiff);
      dotProduct += _data[i] * other[i];
      sumSquare1 += _data[i] * _data[i];
      sumSquare2 += other[i] * other[i];
      hammingDistance += _data[i] != other[i] ? 1 : 0;
    }

    switch (distance) {
      case Distance.frobenius:
        return math.sqrt(sumSquare);
      case Distance.manhattan:
        return sumAbs;
      case Distance.chebyshev:
        return maxAbs;
      case Distance.mahalanobis:
        // We need a covariance matrix and its inverse to compute Mahalanobis distance
        return double.nan; // placeholder value indicating unimplemented
      case Distance.cosine:
        final magnitude1 = math.sqrt(sumSquare1);
        final magnitude2 = math.sqrt(sumSquare2);
        return 1 - (dotProduct / (magnitude1 * magnitude2));
      case Distance.hamming:
        return hammingDistance;
      case Distance.spectral:
      // For vectors, we consider spectral norm as its magnitude
      //return math.sqrt(sumSquare);
      case Distance.trace:
      // For vectors, we consider trace norm as the sum of its elements
      //return sumAbs;
      default:
        throw Exception('Invalid distance type');
    }
  }

  /// Returns the projection of this vector onto [other].
  ///
  /// The projection is given by the formula `(this . other / other . other) * other`, where `.` denotes the dot product.
  ///
  /// Throws an `ArgumentError` if the vectors have different lengths.
  ///
  /// Example:
  /// ```dart
  /// var v1 = Vector.fromList([1, 2, 3]);
  /// var v2 = Vector.fromList([4, 5, 6]);
  /// print(v1.projection(v2));
  /// ```
  ///
  /// Output:
  /// ```
  /// [0.96, 1.2, 1.44]
  /// ```
  Vector projection(Vector other) {
    if (length != other.length) {
      throw ArgumentError("Vectors must have the same length for projection.");
    }
    double scalar = dot(other) / other.dot(other);
    return other * scalar;
  }

  /// Returns the angle (in radians) between this vector and [other].
  ///
  /// The angle is given by the formula `acos((this . other) / (||this|| * ||other||))`, where `.` denotes the dot product and `|| ||` the norm.
  ///
  /// Throws an `ArgumentError` if the vectors have different lengths.
  ///
  /// Example:
  /// ```dart
  /// var v1 = Vector.fromList([1, 0]);
  /// var v2 = Vector.fromList([0, 1]);
  /// print(v1.angle(v2));
  /// ```
  ///
  /// Output:
  /// ```
  /// 1.5707963267948966
  /// ```
  double angle(Vector other) {
    if (length != other.length) {
      throw ArgumentError(
          "Vectors must have the same length for angle calculation.");
    }
    return math.acos(dot(other) / (norm() * other.norm()));
  }

  /// Converts the Vector from Cartesian to Spherical coordinates.
  ///
  /// Returns a list of doubles [r, theta, phi] where:
  /// - r is the radius (distance from origin)
  /// - theta is the inclination (angle from the z-axis, in range [0, pi])
  /// - phi is the azimuth (angle from the x-axis in the xy-plane, in range [0, 2*pi])
  ///
  /// Example:
  /// ```dart
  /// Vector v = Vector.fromList([1, 1, 1]);
  /// print(v.toSpherical());
  /// // Output: [1.7320508075688772, 0.9553166181245093, 0.7853981633974483]
  /// ```
  List<double> toSpherical() {
    if (length != 3) {
      throw Exception(
          "Vector must be 3D for conversion to Spherical coordinates");
    }
    double x = _data[0].toDouble();
    double y = _data[1].toDouble();
    double z = _data[2].toDouble();
    double r = math.sqrt(x * x + y * y + z * z);
    double theta = math.acos(z / r);
    double phi = math.atan2(y, x);
    return [r, theta, phi];
  }

  /// Converts the Vector from Cartesian to Cylindrical coordinates.
  ///
  /// Returns a list of doubles [rho, phi, z] where:
  /// - rho is the radial distance from the z-axis
  /// - phi is the azimuth (angle from the x-axis in the xy-plane, in range [0, 2*pi])
  /// - z is the height along the z-axis
  ///
  /// Example:
  /// ```dart
  /// Vector v = Vector.fromList([1, 1, 1]);
  /// print(v.toCylindrical());
  /// // Output: [1.4142135623730951, 0.7853981633974483, 1]
  /// ```
  List<double> toCylindrical() {
    if (length != 3) {
      throw Exception(
          "Vector must be 3D for conversion to Cylindrical coordinates");
    }
    double x = _data[0].toDouble();
    double y = _data[1].toDouble();
    double z = _data[2].toDouble();
    double rho = math.sqrt(x * x + y * y);
    double phi = math.atan2(y, x);
    return [rho, phi, z];
  }

  /// Converts the Vector from Cartesian to Polar coordinates.
  ///
  /// This function assumes the vector is 2D.
  /// Throws an exception if the vector has more than two components.
  ///
  /// Returns a list of doubles [r, theta] where:
  /// - r is the radius (distance from origin)
  /// - theta is the angle from the positive x-axis, in range [0, 2*pi])
  ///
  /// Example:
  /// ```dart
  /// Vector v = Vector.fromList([1, 1]);
  /// print(v.toPolar());
  /// // Output: [1.4142135623730951, 0.7853981633974483]
  /// ```
  List<double> toPolar() {
    if (length != 2) {
      throw Exception("Vector must be 2D for conversion to Polar coordinates");
    }
    double x = _data[0].toDouble();
    double y = _data[1].toDouble();
    double r = math.sqrt(x * x + y * y);
    double theta = math.atan2(y, x);
    return [r, theta];
  }

  // @override  //performance optimization
  // int get hashCode {
  //   const int numberOfElements = 10;
  //   int stride = length < numberOfElements ? 1 : length ~/ numberOfElements;
  //   int result = 17;
  //   for (int i = 0; i < length; i += stride) {
  //     result = result * 31 + this[i].hashCode;
  //   }
  //   result = result * 31 + length.hashCode; // Include length in hash computation
  //   return result;
  // }

  @override
  int get hashCode {
    int result = 17;
    for (int i = 0; i < length; ++i) {
      result = result * 31 + this[i].hashCode;
    }
    return result;
  }

  /// Generates a new Vector ([Vector2], [Vector3], [Vector4]) based on the mapping provided.
  ///
  /// The [mapping] should be a List<String> consisting of the characters 'x', 'y', 'z', 'w'
  /// representing the desired components for the new Vector. The [mapping] and the Vector must
  /// have the same number of components.
  ///
  /// For example, if the current Vector is a [Vector3] with values [1, 2, 3] and the provided
  /// mapping is ['x', 'x', 'y'], the resulting Vector will be a [Vector3] with values [1, 1, 2].
  ///
  /// If a 'z' or 'w' component is requested from a [Vector2], or if a 'w' component is requested
  /// from a [Vector3], the function will throw an Exception as these components do not exist in
  /// the respective Vectors.
  ///
  /// Example:
  /// ```
  /// var u = Vector.fromList([5,0,2,4]);
  /// var v = u.getVector(['x','x','y']);
  /// print(v); // "Vector3(5.0, 5.0, 0.0)"
  ///
  /// u = Vector.fromList([5,0,2]);
  /// v = u.getVector(['x','x','y','z']);
  /// print(v); // "Vector4(5.0, 5.0, 0.0, 2.0)"
  /// ```
  ///
  /// @param mapping A list of strings indicating the desired components for the new Vector.
  /// @throws Exception If the mapping requests a component that does not exist in the current Vector.
  /// @return A new Vector (Vector2, Vector3, Vector4) with components as specified by the mapping.
  Vector getVector(List<String> mapping) {
    if (mapping.length < 2 || mapping.length > 4) {
      throw Exception('Vector must have between 2 and 4 components');
    }

    // Create a dictionary that stores the maximum allowed index for each component
    Map<String, int> maxAllowedIndex = {'x': 0, 'y': 1, 'z': 2, 'w': 3};
    if (_data.length < 4) {
      maxAllowedIndex['w'] = -1; // -1 indicates the component doesn't exist
    }
    if (_data.length < 3) {
      maxAllowedIndex['z'] = -1;
    }

    List<num> mappedComponents = List.filled(mapping.length, 0.0);

    for (int i = 0; i < mapping.length; i++) {
      String component = mapping[i];

      if (maxAllowedIndex[component] == -1) {
        throw Exception('Invalid mapping for this Vector dimension');
      }

      mappedComponents[i] = _data[maxAllowedIndex[component]!];
    }

    // Then create the appropriate Vector.
    if (mapping.length == 2) {
      return Vector2(mappedComponents[0], mappedComponents[1]);
    } else if (mapping.length == 3) {
      return Vector3(
          mappedComponents[0], mappedComponents[1], mappedComponents[2]);
    } else {
      return Vector4(mappedComponents[0], mappedComponents[1],
          mappedComponents[2], mappedComponents[3]);
    }
  }

  /// Extracts a subVector from the given vector using the specified indices or range.
  ///
  /// - [indices]: Optional list of integers representing the indices to include in the subVector.
  /// - [range]: Optional string representing the range (e.g. "1:3").
  /// - [start]: Optional start index of the range.
  /// - [end]: Optional end index of the range.
  ///
  /// Returns a new vector containing the specified subVector.
  ///
  /// Example 1:
  /// ```dart
  /// var v = Vector.fromList([1, 2, 3, 4, 5]);
  /// var subVector = v.subVector(indices: [0, 2, 4]);
  /// print(subVector);  // Output: "Vector3(1.0, 3.0, 5.0)"
  /// ```
  ///
  /// Example 2:
  /// ```dart
  /// var v = Vector.fromList([1, 2, 3, 4, 5]);
  /// var subVector = v.subVector(range: '1:3');
  /// print(subVector);  // Output: "Vector3(2.0, 3.0, 4.0)"
  /// ```
  ///
  /// Example 3:
  /// ```dart
  /// var v = Vector.fromList([1, 2, 3, 4, 5]);
  /// var subVector = v.subVector(start: 1, end: 3);
  /// print(subVector);  // Output: "Vector3(2.0, 3.0, 4.0)"
  /// ```
  ///
  /// @throws Exception If the indices or range are out of the Vector's bounds.
  Vector subVector(
      {List<int>? indices, String range = '', int? start, int? end}) {
    final indices_ = indices ??
        (start != null && end != null
            ? List.generate(end - start + 1, (i) => start + i)
            : (range.isNotEmpty
                ? _Utils.parseRange(range, length)
                : (start != null
                    ? List.generate(length - start, (i) => start + i)
                    : (end != null
                        ? List.generate(end + 1, (i) => i)
                        : List.generate(length, (i) => i)))));

    if (indices_.any((i) => i < 0 || i >= _data.length)) {
      throw Exception('Indices are out of range');
    }

    List<num> newValues = indices_.map((i) => _data[i]).toList();

    switch (newValues.length) {
      case 2:
        return Vector2(newValues[0], newValues[1]);
      case 3:
        return Vector3(newValues[0], newValues[1], newValues[2]);
      case 4:
        return Vector4(newValues[0], newValues[1], newValues[2], newValues[3]);
      default:
        return Vector.fromList(newValues);
    }
  }

  /// Adds a new value at the end of the row.
  void push(num value) {
    _data.add(value);
  }

  /// Removes the last value in the row.
  num pop() {
    return _data.removeLast();
  }

  /// Adds a new value at the beginning of the row.
  void unShift(num value) {
    _data.insert(0, value);
  }

  /// Removes the first value in the row.
  dynamic shift() {
    return _data.removeAt(0);
  }

  /// Adds/removes elements at an arbitrary position in the row.
  void splice(int start, int deleteCount, [List<num> newItems = const []]) {
    _data.removeRange(start, start + deleteCount);
    _data.insertAll(start, newItems);
  }

  /// Swaps two elements in the row.
  void swap(int index1, int index2) {
    var temp = _data[index1];
    _data[index1] = _data[index2];
    _data[index2] = temp;
  }

  /// Returns the leading diagonal matrix from a vector.
  ///
  /// Example:
  /// ```dart
  /// var vector = Vector([1, 2, 3]);
  /// print(vector.toDiagonal);
  /// // 1 0 0
  /// // 0 2 0
  /// // 0 0 3
  /// ```
  Matrix toDiagonal() {
    return Diagonal(_data);
  }

  /// Constructs a new Matrix from a vector.
  ///
  /// This function takes a current vector and the desired number of
  /// `rows` and `columns` and returns a new Matrix with those dimensions, populated
  /// with the elements from the source list.
  ///
  /// The function fills the Matrix in row-major order, which means that it
  /// fills the first row from left to right, then moves on to the next row,
  /// and so on. If the
  ///
  /// Throws an `ArgumentError` if the provided list does not contain enough elements
  /// to fill the Matrix and `fillWithZeros` is `false`, or if `rows * cols` exceeds
  /// the size of the list.
  ///
  /// - [rows]: The number of rows the new Matrix should have.
  /// - [cols]: The number of columns the new Matrix should have.
  /// - [fillWithZeros]: Whether the function should fill the remaining elements
  ///                    with zeros if the source list does not contain enough elements.
  ///                    Default is `true`.
  ///
  /// Example:
  /// ```dart
  /// final source = Vector([1, 2, 3, 4, 5, 6, 7, 8, 9, 0]);
  /// final matrix = source.toMatrix(3, 5, fillWithZeros: true);
  /// print(matrix);
  /// // Output:
  /// // 1 2 3 4 5
  /// // 6 7 8 9 0
  /// // 0 0 0 0 0
  /// ```
  Matrix toMatrix(int rows, int cols, {bool fillWithZeros = true}) {
    return Matrix.fromFlattenedList(_data, rows, cols);
  }

  @override
  String toString() {
    return _data.toString();
  }
}

class _VectorElementIterable extends IterableBase<dynamic> {
  final Vector _vector;

  _VectorElementIterable(this._vector);

  @override
  Iterator<dynamic> get iterator => VectorElementIterator(_vector);
}
