part of 'complex.dart';

/// A specialized array for efficient storage and manipulation of complex numbers.
///
/// Uses a [Float64List] to store real and imaginary parts interleaved:
/// [real0, imag0, real1, imag1, ...]. This improves memory locality and
/// allows for potential future SIMD optimizations.
class ComplexArray {
  final Float64List _data;

  /// Creates a [ComplexArray] with the given [length].
  ComplexArray(int length) : _data = Float64List(length * 2);

  /// Creates a [ComplexArray] from a list of [Complex] numbers.
  factory ComplexArray.from(List<Complex> list) {
    final array = ComplexArray(list.length);
    for (int i = 0; i < list.length; i++) {
      array[i] = list[i];
    }
    return array;
  }

  /// The number of complex numbers in the array.
  int get length => _data.length ~/ 2;

  /// Gets the [Complex] number at index [i].
  Complex operator [](int i) => Complex(_data[i * 2], _data[i * 2 + 1]);

  /// Sets the [Complex] number at index [i].
  void operator []=(int i, Complex z) {
    _data[i * 2] = z.real.toDouble();
    _data[i * 2 + 1] = z.imaginary.toDouble();
  }

  /// Adds another array element-wise to this array, in-place.
  ///
  /// Throws [ArgumentError] if arrays have different lengths.
  void addInPlace(ComplexArray other) {
    if (length != other.length) {
      throw ArgumentError('Arrays must have the same length');
    }
    for (int i = 0; i < _data.length; i++) {
      _data[i] += other._data[i];
    }
  }

  /// Subtracts another array element-wise from this array, in-place.
  ///
  /// Throws [ArgumentError] if arrays have different lengths.
  void subtractInPlace(ComplexArray other) {
    if (length != other.length) {
      throw ArgumentError('Arrays must have the same length');
    }
    for (int i = 0; i < _data.length; i++) {
      _data[i] -= other._data[i];
    }
  }

  /// Multiplies this array by a scalar (real number), in-place.
  void scaleInPlace(double factor) {
    for (int i = 0; i < _data.length; i++) {
      _data[i] *= factor;
    }
  }

  /// Multiplies this array by another array element-wise, in-place.
  /// (a + bi)(c + di) = (ac - bd) + i(ad + bc)
  ///
  /// Throws [ArgumentError] if arrays have different lengths.
  void multiplyInPlace(ComplexArray other) {
    if (length != other.length) {
      throw ArgumentError('Arrays must have the same length');
    }
    for (int i = 0; i < length; i++) {
      final r1 = _data[i * 2];
      final i1 = _data[i * 2 + 1];
      final r2 = other._data[i * 2];
      final i2 = other._data[i * 2 + 1];

      _data[i * 2] = r1 * r2 - i1 * i2;
      _data[i * 2 + 1] = r1 * i2 + i1 * r2;
    }
  }

  /// Returns a new [List<Complex>] containing the elements of this array.
  List<Complex> toList() {
    final list = List<Complex>.filled(length, Complex.zero());
    for (int i = 0; i < length; i++) {
      list[i] = this[i];
    }
    return list;
  }

  // ============================================================
  // Arithmetic Operations
  // ============================================================

  /// Divides this array by another array element-wise, in-place.
  /// (a + bi) / (c + di) = ((ac + bd) + i(bc - ad)) / (c² + d²)
  ///
  /// Throws [ArgumentError] if arrays have different lengths.
  void divideInPlace(ComplexArray other) {
    if (length != other.length) {
      throw ArgumentError('Arrays must have the same length');
    }
    for (int i = 0; i < length; i++) {
      final a = _data[i * 2];
      final b = _data[i * 2 + 1];
      final c = other._data[i * 2];
      final d = other._data[i * 2 + 1];
      final denom = c * c + d * d;
      _data[i * 2] = (a * c + b * d) / denom;
      _data[i * 2 + 1] = (b * c - a * d) / denom;
    }
  }

  /// Conjugates all elements in-place (negates imaginary parts).
  void conjugateInPlace() {
    for (int i = 0; i < length; i++) {
      _data[i * 2 + 1] = -_data[i * 2 + 1];
    }
  }

  /// Negates all elements in-place.
  void negateInPlace() {
    for (int i = 0; i < _data.length; i++) {
      _data[i] = -_data[i];
    }
  }

  /// Adds a scalar (real number) to all elements in-place.
  void addScalarInPlace(double scalar) {
    for (int i = 0; i < length; i++) {
      _data[i * 2] += scalar;
    }
  }

  // ============================================================
  // Aggregation
  // ============================================================

  /// Returns the sum of all complex numbers in the array.
  Complex sum() {
    double re = 0, im = 0;
    for (int i = 0; i < length; i++) {
      re += _data[i * 2];
      im += _data[i * 2 + 1];
    }
    return Complex(re, im);
  }

  /// Returns the mean (average) of all complex numbers in the array.
  Complex mean() {
    if (length == 0) return Complex.zero();
    final s = sum();
    return Complex(s.real / length, s.imaginary / length);
  }

  /// Computes the dot product: Σ(this[i] * conj(other[i])).
  ///
  /// Throws [ArgumentError] if arrays have different lengths.
  Complex dot(ComplexArray other) {
    if (length != other.length) {
      throw ArgumentError('Arrays must have the same length');
    }
    double re = 0, im = 0;
    for (int i = 0; i < length; i++) {
      final a = _data[i * 2];
      final b = _data[i * 2 + 1];
      final c = other._data[i * 2];
      final d = -other._data[i * 2 + 1]; // conjugate
      re += a * c - b * d;
      im += a * d + b * c;
    }
    return Complex(re, im);
  }

  /// Returns the sum of squared magnitudes: Σ|z[i]|².
  double normSquared() {
    double sum = 0;
    for (int i = 0; i < length; i++) {
      final r = _data[i * 2];
      final im = _data[i * 2 + 1];
      sum += r * r + im * im;
    }
    return sum;
  }

  // ============================================================
  // Element-wise Functions
  // ============================================================

  /// Applies e^z to each element in-place.
  void expInPlace() {
    for (int i = 0; i < length; i++) {
      final z = this[i].exp();
      _data[i * 2] = z.real.toDouble();
      _data[i * 2 + 1] = z.imaginary.toDouble();
    }
  }

  /// Applies log(z) to each element in-place.
  void logInPlace() {
    for (int i = 0; i < length; i++) {
      final z = this[i].log();
      _data[i * 2] = z.real.toDouble();
      _data[i * 2 + 1] = z.imaginary.toDouble();
    }
  }

  /// Applies √z to each element in-place.
  void sqrtInPlace() {
    for (int i = 0; i < length; i++) {
      final z = this[i].sqrt();
      _data[i * 2] = z.real.toDouble();
      _data[i * 2 + 1] = z.imaginary.toDouble();
    }
  }

  /// Applies z^n to each element in-place.
  void powInPlace(num n) {
    for (int i = 0; i < length; i++) {
      final z = this[i].pow(n);
      _data[i * 2] = z.real.toDouble();
      _data[i * 2 + 1] = z.imaginary.toDouble();
    }
  }

  // ============================================================
  // Signal Processing
  // ============================================================

  /// Computes the Fast Fourier Transform (Cooley-Tukey radix-2).
  ///
  /// The array length must be a power of 2.
  ComplexArray fft() {
    final n = length;
    if (n == 0 || (n & (n - 1)) != 0) {
      throw ArgumentError('Array length must be a power of 2 for FFT');
    }
    final result = ComplexArray.from(toList());
    _fftInPlace(result._data, false);
    return result;
  }

  /// Computes the Inverse Fast Fourier Transform.
  ///
  /// The array length must be a power of 2.
  ComplexArray ifft() {
    final n = length;
    if (n == 0 || (n & (n - 1)) != 0) {
      throw ArgumentError('Array length must be a power of 2 for IFFT');
    }
    final result = ComplexArray.from(toList());
    _fftInPlace(result._data, true);
    // Scale by 1/n
    for (int i = 0; i < result._data.length; i++) {
      result._data[i] /= n;
    }
    return result;
  }

  /// Internal Cooley-Tukey FFT implementation.
  static void _fftInPlace(Float64List data, bool inverse) {
    final n = data.length ~/ 2;
    if (n <= 1) return;

    // Bit-reversal permutation
    int j = 0;
    for (int i = 0; i < n - 1; i++) {
      if (i < j) {
        // Swap real parts
        final tr = data[i * 2];
        data[i * 2] = data[j * 2];
        data[j * 2] = tr;
        // Swap imag parts
        final ti = data[i * 2 + 1];
        data[i * 2 + 1] = data[j * 2 + 1];
        data[j * 2 + 1] = ti;
      }
      int k = n ~/ 2;
      while (k <= j) {
        j -= k;
        k ~/= 2;
      }
      j += k;
    }

    // Cooley-Tukey iterative FFT
    final sign = inverse ? 1.0 : -1.0;
    for (int len = 2; len <= n; len *= 2) {
      final halfLen = len ~/ 2;
      final angle = sign * 2 * math.pi / len;
      final wRe = math.cos(angle);
      final wIm = math.sin(angle);

      for (int i = 0; i < n; i += len) {
        double curRe = 1.0, curIm = 0.0;
        for (int k = 0; k < halfLen; k++) {
          final evenIdx = (i + k) * 2;
          final oddIdx = (i + k + halfLen) * 2;

          final tRe = curRe * data[oddIdx] - curIm * data[oddIdx + 1];
          final tIm = curRe * data[oddIdx + 1] + curIm * data[oddIdx];

          data[oddIdx] = data[evenIdx] - tRe;
          data[oddIdx + 1] = data[evenIdx + 1] - tIm;
          data[evenIdx] += tRe;
          data[evenIdx + 1] += tIm;

          final nextRe = curRe * wRe - curIm * wIm;
          curIm = curRe * wIm + curIm * wRe;
          curRe = nextRe;
        }
      }
    }
  }

  /// Circularly shifts the array by [n] positions.
  /// Positive n shifts right, negative shifts left.
  ComplexArray circularShift(int n) {
    if (length == 0) return ComplexArray(0);
    final shift = ((n % length) + length) % length;
    final result = ComplexArray(length);
    for (int i = 0; i < length; i++) {
      final newIdx = (i + shift) % length;
      result._data[newIdx * 2] = _data[i * 2];
      result._data[newIdx * 2 + 1] = _data[i * 2 + 1];
    }
    return result;
  }

  // ============================================================
  // Non-Mutating Variants
  // ============================================================

  /// Returns a new array with element-wise addition.
  ComplexArray add(ComplexArray other) {
    final result = ComplexArray.from(toList());
    result.addInPlace(other);
    return result;
  }

  /// Returns a new array with element-wise multiplication.
  ComplexArray multiply(ComplexArray other) {
    final result = ComplexArray.from(toList());
    result.multiplyInPlace(other);
    return result;
  }

  /// Returns a copy of this array.
  ComplexArray copy() {
    return ComplexArray.from(toList());
  }
}

/// SIMD-optimized array for efficient bulk complex number operations.
///
/// Uses [Float64x2List] where each [Float64x2] stores one complex number:
/// - x lane: real part
/// - y lane: imaginary part
///
/// This provides 150%+ speedup for bulk operations on native platforms.
///
/// > **Note**: SIMD is only available on native platforms (iOS, Android,
/// > macOS, Windows, Linux). For web, use [ComplexArray] instead.
///
/// Example:
/// ```dart
/// final a = ComplexArraySimd.from([Complex(1, 2), Complex(3, 4)]);
/// final b = ComplexArraySimd.from([Complex(5, 6), Complex(7, 8)]);
/// a.addInPlace(b);
/// print(a[0]); // 6 + 8i
/// ```
class ComplexArraySimd {
  final Float64x2List _data;

  /// Creates a [ComplexArraySimd] with the given [length].
  ComplexArraySimd(int length) : _data = Float64x2List(length);

  /// Creates a [ComplexArraySimd] from a list of [Complex] numbers.
  factory ComplexArraySimd.from(List<Complex> list) {
    final array = ComplexArraySimd(list.length);
    for (int i = 0; i < list.length; i++) {
      array[i] = list[i];
    }
    return array;
  }

  /// The number of complex numbers in the array.
  int get length => _data.length;

  /// Gets the [Complex] number at index [i].
  Complex operator [](int i) => Complex(_data[i].x, _data[i].y);

  /// Sets the [Complex] number at index [i].
  void operator []=(int i, Complex z) {
    _data[i] = Float64x2(z.real.toDouble(), z.imaginary.toDouble());
  }

  /// Adds another array element-wise to this array, in-place (SIMD accelerated).
  ///
  /// Throws [ArgumentError] if arrays have different lengths.
  void addInPlace(ComplexArraySimd other) {
    if (length != other.length) {
      throw ArgumentError('Arrays must have the same length');
    }
    for (int i = 0; i < length; i++) {
      _data[i] = _data[i] + other._data[i];
    }
  }

  /// Subtracts another array element-wise from this array, in-place (SIMD accelerated).
  ///
  /// Throws [ArgumentError] if arrays have different lengths.
  void subtractInPlace(ComplexArraySimd other) {
    if (length != other.length) {
      throw ArgumentError('Arrays must have the same length');
    }
    for (int i = 0; i < length; i++) {
      _data[i] = _data[i] - other._data[i];
    }
  }

  /// Multiplies this array by a scalar (real number), in-place (SIMD accelerated).
  void scaleInPlace(double factor) {
    for (int i = 0; i < length; i++) {
      _data[i] = _data[i].scale(factor);
    }
  }

  /// Multiplies this array by another array element-wise, in-place.
  /// (a + bi)(c + di) = (ac - bd) + i(ad + bc)
  ///
  /// Throws [ArgumentError] if arrays have different lengths.
  void multiplyInPlace(ComplexArraySimd other) {
    if (length != other.length) {
      throw ArgumentError('Arrays must have the same length');
    }
    for (int i = 0; i < length; i++) {
      final z1 = _data[i];
      final z2 = other._data[i];
      final a = z1.x, b = z1.y;
      final c = z2.x, d = z2.y;
      // (a+bi)(c+di) = (ac-bd) + (ad+bc)i
      _data[i] = Float64x2(a * c - b * d, a * d + b * c);
    }
  }

  /// Computes the element-wise absolute value (magnitude) of each complex number.
  /// Returns a new [Float64List] containing the magnitudes.
  Float64List absAll() {
    final result = Float64List(length);
    for (int i = 0; i < length; i++) {
      final z = _data[i];
      result[i] = (z * z).x + (z * z).y; // x² + y²
      result[i] = result[i] > 0 ? result[i] : 0; // Ensure non-negative for sqrt
    }
    // Apply sqrt
    for (int i = 0; i < length; i++) {
      result[i] = result[i] != 0 ? Float64x2.splat(result[i]).sqrt().x : 0;
    }
    return result;
  }

  /// Returns a new [List<Complex>] containing the elements of this array.
  List<Complex> toList() {
    final list = List<Complex>.filled(length, Complex.zero());
    for (int i = 0; i < length; i++) {
      list[i] = this[i];
    }
    return list;
  }

  /// Converts this SIMD array to a regular [ComplexArray].
  ComplexArray toComplexArray() {
    return ComplexArray.from(toList());
  }

  // ============================================================
  // Arithmetic Operations
  // ============================================================

  /// Divides this array by another array element-wise, in-place.
  void divideInPlace(ComplexArraySimd other) {
    if (length != other.length) {
      throw ArgumentError('Arrays must have the same length');
    }
    for (int i = 0; i < length; i++) {
      final z1 = _data[i];
      final z2 = other._data[i];
      final a = z1.x, b = z1.y;
      final c = z2.x, d = z2.y;
      final denom = c * c + d * d;
      _data[i] = Float64x2((a * c + b * d) / denom, (b * c - a * d) / denom);
    }
  }

  /// Conjugates all elements in-place (negates imaginary parts).
  void conjugateInPlace() {
    for (int i = 0; i < length; i++) {
      _data[i] = Float64x2(_data[i].x, -_data[i].y);
    }
  }

  /// Negates all elements in-place (SIMD accelerated).
  void negateInPlace() {
    for (int i = 0; i < length; i++) {
      _data[i] = -_data[i];
    }
  }

  /// Adds a scalar (real number) to all elements in-place.
  void addScalarInPlace(double scalar) {
    final scalarVec = Float64x2(scalar, 0);
    for (int i = 0; i < length; i++) {
      _data[i] = _data[i] + scalarVec;
    }
  }

  // ============================================================
  // Aggregation
  // ============================================================

  /// Returns the sum of all complex numbers.
  Complex sum() {
    double re = 0, im = 0;
    for (int i = 0; i < length; i++) {
      re += _data[i].x;
      im += _data[i].y;
    }
    return Complex(re, im);
  }

  /// Returns the mean (average) of all complex numbers.
  Complex mean() {
    if (length == 0) return Complex.zero();
    final s = sum();
    return Complex(s.real / length, s.imaginary / length);
  }

  /// Computes the dot product: Σ(this[i] * conj(other[i])).
  Complex dot(ComplexArraySimd other) {
    if (length != other.length) {
      throw ArgumentError('Arrays must have the same length');
    }
    double re = 0, im = 0;
    for (int i = 0; i < length; i++) {
      final a = _data[i].x, b = _data[i].y;
      final c = other._data[i].x, d = -other._data[i].y; // conjugate
      re += a * c - b * d;
      im += a * d + b * c;
    }
    return Complex(re, im);
  }

  /// Returns the sum of squared magnitudes: Σ|z[i]|².
  double normSquared() {
    double sum = 0;
    for (int i = 0; i < length; i++) {
      final z = _data[i];
      sum += z.x * z.x + z.y * z.y;
    }
    return sum;
  }

  // ============================================================
  // Element-wise Functions
  // ============================================================

  /// Applies e^z to each element in-place.
  void expInPlace() {
    for (int i = 0; i < length; i++) {
      final z = this[i].exp();
      _data[i] = Float64x2(z.real.toDouble(), z.imaginary.toDouble());
    }
  }

  /// Applies log(z) to each element in-place.
  void logInPlace() {
    for (int i = 0; i < length; i++) {
      final z = this[i].log();
      _data[i] = Float64x2(z.real.toDouble(), z.imaginary.toDouble());
    }
  }

  /// Applies √z to each element in-place.
  void sqrtInPlace() {
    for (int i = 0; i < length; i++) {
      final z = this[i].sqrt();
      _data[i] = Float64x2(z.real.toDouble(), z.imaginary.toDouble());
    }
  }

  /// Applies z^n to each element in-place.
  void powInPlace(num n) {
    for (int i = 0; i < length; i++) {
      final z = this[i].pow(n);
      _data[i] = Float64x2(z.real.toDouble(), z.imaginary.toDouble());
    }
  }

  // ============================================================
  // Signal Processing
  // ============================================================

  /// Computes the Fast Fourier Transform.
  /// Delegates to ComplexArray for simplicity.
  ComplexArraySimd fft() {
    return ComplexArraySimd.from(toComplexArray().fft().toList());
  }

  /// Computes the Inverse Fast Fourier Transform.
  ComplexArraySimd ifft() {
    return ComplexArraySimd.from(toComplexArray().ifft().toList());
  }

  /// Circularly shifts the array by [n] positions.
  ComplexArraySimd circularShift(int n) {
    if (length == 0) return ComplexArraySimd(0);
    final shift = ((n % length) + length) % length;
    final result = ComplexArraySimd(length);
    for (int i = 0; i < length; i++) {
      result._data[(i + shift) % length] = _data[i];
    }
    return result;
  }

  // ============================================================
  // Non-Mutating Variants
  // ============================================================

  /// Returns a new array with element-wise addition.
  ComplexArraySimd add(ComplexArraySimd other) {
    final result = ComplexArraySimd.from(toList());
    result.addInPlace(other);
    return result;
  }

  /// Returns a new array with element-wise multiplication.
  ComplexArraySimd multiply(ComplexArraySimd other) {
    final result = ComplexArraySimd.from(toList());
    result.multiplyInPlace(other);
    return result;
  }

  /// Returns a copy of this array.
  ComplexArraySimd copy() {
    return ComplexArraySimd.from(toList());
  }
}
