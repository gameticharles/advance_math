part of algebra;

class SylvesterMatrix extends Matrix {
  /// The polynomial used to build the Sylvester matrix.
  final Polynomial polynomial;

  /// Creates a [SylvesterMatrix] object.
  SylvesterMatrix({
    required this.polynomial,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is SylvesterMatrix) {
      return runtimeType == other.runtimeType && polynomial == other.polynomial;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => polynomial.hashCode;

  /// Builds the Sylvester matrix associated to the given polynomial.
  Matrix buildMatrix() {
    // Computing the derivative of the polynomial and the size of the matrix
    final coefficients = polynomial.coefficients;
    final derivative = polynomial.differentiate().coefficients;
    final size = (coefficients.length - 1) + (derivative.length - 1);

    // Building the matrix with FIXED length lists (optimization)
    final flatData = List<num>.generate(
      (size * size).toInt(),
      (_) => 0,
      growable: false,
    );

    /* Iterating over the coefficients and placing them in the matrix. Since the
     * 2D array is "flattened", the way we have to access "cells" is this...
     *
     *  > flatData[arraySize * row + column] = value
     *
     * which is equivalent to 'flatData[row][column]' if 'flatData' was a 2D
     * array.
     */
    for (var i = 0; i < size - coefficients.length + 1; ++i) {
      for (var j = 0; j < coefficients.length; ++j) {
        flatData[(size * i + (j + i)).toInt()] = numberToNum(coefficients[j]);
      }
    }

    var pos = 0;
    for (var i = size - coefficients.length + 1; i < size; ++i) {
      for (var j = 0; j < derivative.length; ++j) {
        flatData[(size * i + (j + pos)).toInt()] = numberToNum(derivative[j]);
      }
      ++pos;
    }

    // Returning the Sylvester matrix.
    return Matrix.fromFlattenedList(flatData, size.toInt(), size.toInt());
  }

  /// Computes the determinant of the Sylvester matrix.
  num matrixDeterminant() => buildMatrix().determinant();

  /// The discriminant of a polynomial P(x) is the determinant of the Sylvester
  /// matrix of P and P' (where P' is the derivative of P).
  ///
  /// By default, the [optimize] parameter is set to `true` so that the
  /// Sylvester matrix is not computed for polynomials whose degree is 4 or
  /// lower. To be more precise:
  ///
  ///  - With `optimize = true`, if the degree of the polynomial is lower than
  ///  4, then the Sylvester matrix is not built. The computation of its
  ///  determinant can be computationally heavy so we can just avoid such
  ///  complexity by using the simple formulas for lower degree polynomials.
  ///
  ///  - With `optimize = false`, the Sylvester matrix and its determinant are
  ///  always computed regardless the degree of the polynomial.
  ///
  /// You should keep the default value of [optimize].
  Number polynomialDiscriminant({bool optimize = true}) {
    final quarticOrLower = polynomial is Number ||
        polynomial is Linear ||
        polynomial is Quadratic ||
        polynomial is Cubic ||
        polynomial is Quartic;

    // In case the optimization flag was 'true' and the degree of the
    // polynomial is <= 4, then go for the easy way.
    if (optimize && quarticOrLower) {
      return polynomial.discriminant();
    } else {
      // The determinant of the Sylvester matrix
      final determinant = matrixDeterminant();

      /*
      * Once we got the determinant, we need to make the last calculation to
      * also determine the sign. The formula is the following:
      *
      *  Disc(A) = (-1)^(n*(n-1)/2) * 1/A[n] * Res(A, A')
      *
      * In the above formula, 'n' is the degree of the polynomial, A(x) is the
      * polynomial and A'(x) is the derivative of A(x).
      *
      * Res(A, A') is the resultant of A(x) and A'(x), which is nothing more
      * than the determinant of the Sylvester matrix.
      */
      final coefficients = polynomial.coefficients;
      final degree = coefficients.length - 1;
      final sign = math.pow(-1, degree * (degree - 1) / 2) as double;
      final denominator = coefficients.first;

      // Returning the determinant with the correct sign
      return Complex.fromReal(sign) / denominator * determinant;
    }
  }
}
