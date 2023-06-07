part of vector;

/// A class representing a vector with complex numbers.
///
/// This class provides methods for common vector operations, such as
/// calculating the norm, checking if the vector is a zero vector, checking
/// if the vector is a unit vector, and setting all elements to a specific value.
///
/// Example:
/// ```
/// var v1 = ComplexVector.fromList([Complex(1, 1), Complex(2, -1), Complex(3, 0)]);
/// print(v1.norm());  // Output: 3.7416573867739413
/// print(v1.isZero());  // Output: false
/// print(v1.isUnit());  // Output: false
///
/// var v2 = v1.normalize();
/// print(v2.norm());  // Output: 1.0
/// print(v2.isUnit());  // Output: true
///
/// v1.setAll(Complex(0, 0));
/// print(v1.isZero());  // Output: true
///
/// print(v1[0]);  // Output: 1 + 1i
///
/// var v3 = ComplexVector.fromList([Complex(1, -1), Complex(2, 1), Complex(3, 0)]);
/// print(v1.dot(v3));  // Output: 8 + 0i
/// print(v1.toList());  // Output: [1 + 1i, 2 - 1i, 3 + 0i]
/// ```
class ComplexVector {
  /// Internal data of the ComplexVector.
  final List<Complex> _data;

  /// Constructs a ComplexVector with the given length, with all elements initialized to 0.
  ComplexVector(int length)
      : _data = List<Complex>.filled(length, Complex(0, 0));

  /// Constructs a ComplexVector from a list of Complex numbers.
  ComplexVector.fromList(List<Complex> data) : _data = data;

  /// Returns the complex number at the given index in the vector.
  Complex operator [](int index) => _data[index];

  /// Sets the complex number at the given index in the vector to the given value.
  void operator []=(int index, Complex value) {
    _data[index] = value;
  }

  /// Returns the vector as a list of complex numbers.
  List<Complex> toList() => _data;

  /// Returns the length of the vector.
  int get length => _data.length;

  /// Returns the dot product of this vector with the other vector.
  ///
  /// The dot product of two vectors is the sum of the product of their corresponding entries.
  /// For complex vectors, the dot product involves complex multiplication.
  Complex dot(ComplexVector other) {
    if (length != other.length) {
      throw ArgumentError("Vectors must have the same length for dot product.");
    }
    Complex result = Complex(0, 0);
    for (int i = 0; i < length; i++) {
      result += this[i] * other[i];
    }
    return result;
  }

  ComplexVector operator +(ComplexVector other) {
    if (length != other.length) {
      throw ArgumentError("Vectors must have the same length for addition.");
    }
    ComplexVector result = ComplexVector(length);
    for (int i = 0; i < length; i++) {
      result[i] = this[i] + other[i];
    }
    return result;
  }

  ComplexVector operator -(ComplexVector other) {
    if (length != other.length) {
      throw ArgumentError("Vectors must have the same length for subtraction.");
    }
    ComplexVector result = ComplexVector(length);
    for (int i = 0; i < length; i++) {
      result[i] = this[i] - other[i];
    }
    return result;
  }

  ComplexVector operator *(Complex scalar) {
    ComplexVector result = ComplexVector(length);
    for (int i = 0; i < length; i++) {
      result[i] = this[i] * scalar;
    }
    return result;
  }

  ComplexVector operator /(Complex scalar) {
    ComplexVector result = ComplexVector(length);
    for (int i = 0; i < length; i++) {
      result[i] = this[i] / scalar;
    }
    return result;
  }

  /// Returns the Euclidean norm (also known as the 2-norm, Euclidean length, or L2 distance)
  /// of this vector. The norm is always a real number, even for complex vectors.
  /// Example:
  /// ```
  /// var v = ComplexVector.fromList([Complex(1, 1), Complex(2, -1), Complex(3, 0)]);
  /// print(v.norm());  // Output: 3.7416573867739413
  /// ```
  double norm() {
    double sum = 0;
    for (int i = 0; i < length; i++) {
      sum += (this[i].real * this[i].real) +
          (this[i].imaginary * this[i].imaginary);
    }
    return math.sqrt(sum);
  }

  /// Returns a normalized version of this vector (a vector of length 1 in the same direction).
  /// Throws an exception if this is the zero vector.
  /// Example:
  /// ```
  /// var v = ComplexVector.fromList([Complex(1, 1), Complex(2, -1), Complex(3, 0)]);
  /// var normalizedV = v.normalize();
  /// print(normalizedV.norm());  // Output: 1.0
  /// ```
  ComplexVector normalize() {
    double normValue = norm();
    if (normValue == 0) {
      throw ArgumentError("Cannot normalize a zero vector.");
    }
    return this / Complex(normValue, 0);
  }

  /// Returns true if this is the zero vector, false otherwise.
  /// Example:
  /// ```
  /// var v = ComplexVector.fromList([Complex(1, 1), Complex(2, -1), Complex(3, 0)]);
  /// print(v.isZero());  // Output: false
  /// v.setAll(Complex(0, 0));
  /// print(v.isZero());  // Output: true
  /// ```
  bool isZero() {
    for (int i = 0; i < length; i++) {
      if (this[i].real != 0 || this[i].imaginary != 0) {
        return false;
      }
    }
    return true;
  }

  /// Returns true if this is a unit vector (a vector of length 1), false otherwise.
  /// Example:
  /// ```
  /// var v = ComplexVector.fromList([Complex(1, 1), Complex(2, -1), Complex(3, 0)]);
  /// print(v.isUnit());  // Output: false
  /// var normalizedV = v.normalize();
  /// print(normalizedV.isUnit());  // Output: true
  /// ```
  bool isUnit() {
    return norm() == 1;
  }

  /// Sets all components of this vector to the given complex number.
  /// Example:
  /// ```
  /// var v = ComplexVector.fromList([Complex(1, 1), Complex(2, -1), Complex(3, 0)]);
  /// print(v.isZero());  // Output: false
  /// v.setAll(Complex(0, 0));
  /// print(v.isZero());  // Output: true
  /// ```
  void setAll(Complex value) {
    for (int i = 0; i < length; i++) {
      this[i] = value;
    }
  }

  @override
  String toString() {
    return _data.toString();
  }
}
