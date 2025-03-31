part of '../../algebra.dart';

class MatrixFactory {
  MatrixFactory();

  /// Creates a tridiagonal matrix with the given size and diagonal values.
  ///
  /// `n` is the size of the square matrix.
  /// `a` is the value to fill the first (lower) diagonal.
  /// `b` is the value to fill the second (main) diagonal.
  /// `c` is the value to fill the third (upper) diagonal.
  ///
  /// Returns a [Matrix] with the specified tridiagonal structure.
  ///
  /// Example:
  ///
  /// ```dart
  /// int n = 10;
  /// double a = -4;
  /// double b = 1;
  /// double c = 2;
  ///
  /// Matrix A = Matrix.tridiagonal(n, a, b, c);
  /// ```
  Matrix tridiagonal(int n, double a, double b, double c) {
    List<List<dynamic>> data =
        List.generate(n, (_) => List<dynamic>.filled(n, Complex.zero()));

    for (int i = 0; i < n; i++) {
      if (i - 1 >= 0) {
        data[i][i - 1] = a;
      }
      data[i][i] = b;
      if (i + 1 < n) {
        data[i][i + 1] = c;
      }
    }

    return Matrix.fromList(data);
  }

  /// Creates a matrix with the specified [type], [rowCount], and [columnCount].
  ///
  /// The [min] and [max] parameters specify the range of possible values for
  /// the matrix elements. If [isDouble] is set to true, the matrix elements
  /// will be doubles; otherwise, they will be integers. If a [value] is provided as default
  /// value for some matrices (such as diagonal and general matrices) type it will use it.
  /// If [random] is provided, it will be used as the random number generator; otherwise, a new instance
  /// of `Random` will be created.
  ///
  /// [seed]: An optional seed for the random number generator for reproducible randomness. If not provided, the randomness is not reproducible.
  ///
  /// The [type] parameter must be a value from the [MatrixType] enumeration, and
  /// it determines the structure of the matrix. The supported matrix types are:
  ///
  /// - General: A matrix with no specific structure.
  /// - Square: A square matrix with equal [rowCount] and [columnCount].
  /// - Diagonal: A square matrix with non-zero elements only on the main diagonal.
  /// - Identity: A square matrix with 1s on the main diagonal and 0s elsewhere.
  /// - Upper Triangular: A matrix with non-zero elements above the main diagonal.
  /// - Lower Triangular: A matrix with non-zero elements below the main diagonal.
  /// - Symmetric: A square matrix that is equal to its transpose.
  /// - Zeros: A matrix with all elements set to 0.
  /// - Ones: A matrix with all elements set to 1.
  /// - Tridiagonal: A square matrix with non-zero elements on the main diagonal and its adjacent diagonals.
  /// - Toeplitz: A square matrix in which each descending diagonal has constant elements.
  /// - Hankel: A square matrix in which each ascending diagonal has constant elements.
  /// - Circulant: A square matrix formed by shifting each row one position to the right relative to the row above it.
  /// - Vandermonde: A square matrix with elements defined by powers of a set of distinct values.
  /// - Permutation: A square matrix representing a permutation of the columns of the identity matrix.
  /// - Nilpotent: A square matrix that raises to some non-negative integer power, resulting in the zero matrix.
  /// - Involutory: A square matrix that is its own inverse.
  /// - Idempotent: A square matrix that is unchanged when multiplied by itself.
  /// - Hermitian: A square matrix that is equal to its conjugate transpose.
  /// - Sparse: A matrix with a significant number of zero elements.
  /// - Periodic: A matrix that has a periodic eigenvector.
  /// - Positive Definite: A symmetric matrix where all eigenvalues are positive.
  /// - Negative Definite: A symmetric matrix where all eigenvalues are negative.
  /// - Derogatory: A square matrix for which there exists an eigenvector that is not unique.
  /// - Diagonally Dominant: A square matrix where each diagonal element is greater than the sum of the absolute values of the other elements in its row.
  /// - Strictly Diagonally Dominant: A square matrix where each diagonal element is strictly greater than the sum of the absolute values of the other elements in its row.
  ///
  /// Returns a new instance of [MatrixFactory] with the generated matrix data.
  ///
  /// Example usage:
  /// ```dart
  /// final matrix = MatrixFactory.create(MatrixType.upperTriangular, 3, 3);
  ///
  /// final matrix = Matrix.factory.create(MatrixType.zeros, 3, 3);
  /// ```
  Matrix create(MatrixType type, int rowCount, int columnCount,
      {double min = 0,
      double max = 1,
      bool isDouble = false,
      dynamic value,
      int? seed,
      math.Random? random}) {
    if (seed != null) {
      random = math.Random(seed);
    }
    random ??= math.Random();

    if (rowCount <= 0 || columnCount <= 0) {
      throw Exception('Rows and columns must be greater than 0');
    }

    // Generate matrix with appropriate type of zeros
    List<List<dynamic>> data = List.generate(
        rowCount,
        (_) => List.filled(
            columnCount, isDouble ? Complex(0.0, 0.0) : Complex(0, 0),
            growable: false));

    switch (type) {
      case MatrixType.square:
        if (rowCount != columnCount) {
          throw ArgumentError("Matrix must be square for the square type.");
        }

        for (int i = 0; i < rowCount; i++) {
          for (int j = 0; j < columnCount; j++) {
            data[i][j] = isDouble
                ? Complex(random.nextDouble() * (max - min) + min)
                : Complex(
                    random.nextInt(max.toInt() - min.toInt()) + min.toInt());
          }
        }
        break;

      case MatrixType.upperTriangular:
        data = List.generate(
            rowCount,
            (_) => List.generate(
                columnCount,
                (j) => j >= _
                    ? Complex(random!.nextDouble() * (max - min) + min)
                    : Complex(0, 0)));
        break;

      case MatrixType.lowerTriangular:
        data = List.generate(
            rowCount,
            (_) => List.generate(
                columnCount,
                (j) => j <= _
                    ? Complex(random!.nextDouble() * (max - min) + min)
                    : Complex(0, 0)));
        break;

      case MatrixType.symmetric:
        if (rowCount != columnCount) {
          throw ArgumentError(
              "Matrix must be square for the symmetric matrix type.");
        }

        for (int i = 0; i < rowCount; i++) {
          for (int j = i; j < columnCount; j++) {
            final value = isDouble
                ? Complex(random.nextDouble() * (max - min) + min)
                : Complex(
                    random.nextInt(max.toInt() - min.toInt()) + min.toInt());
            data[i][j] = value;
            data[j][i] = value;
          }
        }
        break;

      case MatrixType.tridiagonal:
        if (rowCount != columnCount) {
          throw ArgumentError(
              "Matrix must be square for the tridiagonal matrix type.");
        }
        for (int i = 0; i < rowCount; i++) {
          for (int j = 0; j < columnCount; j++) {
            if (i == j || (i - j).abs() == 1) {
              data[i][j] = isDouble
                  ? Complex(random.nextDouble() * (max - min) + min)
                  : Complex(
                      random.nextInt(max.toInt() - min.toInt()) + min.toInt());
            }
          }
        }
        break;
      case MatrixType.periodic:
        if (rowCount != columnCount) {
          throw ArgumentError(
              "Matrix must be square for the periodic matrix type.");
        }

        List<dynamic> firstRow = List.generate(columnCount, (_) {
          return isDouble
              ? Complex(random!.nextDouble() * (max - min) + min)
              : Complex(
                  random!.nextInt(max.toInt() - min.toInt()) + min.toInt());
        });
        for (int i = 0; i < rowCount; i++) {
          for (int j = 0; j < columnCount; j++) {
            data[i][j] = firstRow[(j + i) % columnCount];
          }
        }
        break;

      case MatrixType.negativeDefinite:
        if (rowCount != columnCount) {
          throw ArgumentError(
              "Matrix must be square for the negative definite matrix type.");
        }

        List<List<dynamic>> lowerTriangular = List.generate(
            rowCount,
            (_) => List.generate(
                columnCount,
                (j) => j <= _
                    ? Complex(random!.nextDouble() * (max - min) + min)
                    : Complex(0, 0)));
        for (int i = 0; i < rowCount; i++) {
          for (int j = 0; j < columnCount; j++) {
            dynamic sum = Complex.zero();
            for (int k = 0; k <= j; k++) {
              sum += lowerTriangular[i][k] * lowerTriangular[j][k];
            }
            data[i][j] = (i == j ? -Complex(1) : Complex(1)) * sum;
          }
        }
        break;

      case MatrixType.derogatory:
        if (rowCount != columnCount) {
          throw ArgumentError(
              "Matrix must be square for the derogatory matrix type.");
        }

        List<int> indices = List.generate(columnCount, (index) => index);
        indices.shuffle(random);
        for (int i = 0; i < rowCount; i++) {
          for (int j = 0; j < columnCount; j++) {
            data[i][j] = i == j
                ? Complex(random.nextDouble() * (max - min) + min)
                : Complex(i == indices[j] ? 1 : 0);
          }
        }
        break;

      case MatrixType.positiveDefinite:
        if (rowCount != columnCount) {
          throw ArgumentError(
              "Matrix must be square for the positive definite matrix type.");
        }

        List<List<dynamic>> lowerTriangular = List.generate(
            rowCount,
            (_) => List.generate(
                columnCount,
                (j) => j <= _
                    ? Complex(random!.nextDouble() * (max - min) + min)
                    : Complex(0, 0)));
        for (int i = 0; i < rowCount; i++) {
          for (int j = 0; j < columnCount; j++) {
            dynamic sum = Complex.zero();
            for (int k = 0; k <= j; k++) {
              sum += lowerTriangular[i][k] * lowerTriangular[j][k];
            }
            data[i][j] = sum;
          }
        }
        break;

      case MatrixType.hermitian:
        if (rowCount != columnCount) {
          throw ArgumentError(
              "Matrix must be square for the hermitian matrix type.");
        }

        for (int i = 0; i < rowCount; i++) {
          for (int j = i; j < columnCount; j++) {
            if (i == j) {
              final value = isDouble
                  ? random.nextDouble() * (max - min) + min
                  :random.nextInt(max.toInt() - min.toInt()) + min.toInt();
              data[i][j] = value;
            } else {
              final realPart = isDouble
                  ? random.nextDouble() * (max - min) + min
                  : random.nextInt(max.toInt() - min.toInt()) + min.toInt();
              final imaginaryPart = isDouble
                  ? random.nextDouble() * (max - min) + min
                  : random.nextInt(max.toInt() - min.toInt()) + min.toInt();
              data[i][j] = Complex(realPart, imaginaryPart);
              data[j][i] = Complex(realPart, -imaginaryPart);
            }
          }
        }
        break;

      case MatrixType.sparse:
        double sparseRatio = 0.1; // Adjust this value to control sparsity

        int nonZeroCount = (rowCount * columnCount * sparseRatio).ceil();
        for (int i = 0; i < nonZeroCount; i++) {
          int row = random.nextInt(rowCount);
          int col = random.nextInt(columnCount);
          data[row][col] = isDouble
              ? Complex(random.nextDouble() * (max - min) + min)
              : Complex(
                  random.nextInt(max.toInt() - min.toInt()) + min.toInt());
        }
        break;

      case MatrixType.toeplitz:
        if (rowCount != columnCount) {
          throw ArgumentError(
              "Matrix must be square for the Toeplitz matrix type.");
        }
        List<dynamic> firstRow = List.generate(columnCount, (_) {
          return isDouble
              ? Complex(random!.nextDouble() * (max - min) + min)
              : Complex(
                  random!.nextInt(max.toInt() - min.toInt()) + min.toInt());
        });
        data = List.generate(rowCount,
            (i) => List.generate(columnCount, (j) => firstRow[(j - i).abs()]));

        break;

      case MatrixType.idempotent:
        if (rowCount != columnCount) {
          throw ArgumentError(
              "Matrix must be square for the idempotent matrix type.");
        }
        List<List<dynamic>> orthoData = List.generate(rowCount,
            (_) => List.filled(columnCount, Complex.zero(), growable: false));
        for (int i = 0; i < rowCount; i++) {
          for (int j = 0; j < columnCount; j++) {
            orthoData[i][j] = Complex(random.nextDouble() * (max - min) + min);
          }
        }
        Matrix orthoMatrix = Matrix(orthoData);
        Matrix orthoTransposed = orthoMatrix.transpose();
        Matrix idempotentMatrix = orthoMatrix * orthoTransposed;
        data = _Utils.toNumList(idempotentMatrix._data);
        break;

      case MatrixType.hankel:
        if (rowCount != columnCount) {
          throw ArgumentError(
              "Matrix must be square for the Hankel matrix type.");
        }
        List<dynamic> firstColumn = List.generate(rowCount, (_) {
          return isDouble
              ? Complex(random!.nextDouble() * (max - min) + min)
              : Complex(
                  random!.nextInt(max.toInt() - min.toInt()) + min.toInt());
        });
        data = List.generate(
            rowCount,
            (i) => List.generate(
                columnCount, (j) => firstColumn[rowCount - 1 - (i - j).abs()]));
        break;

      case MatrixType.circulant:
        if (rowCount != columnCount) {
          throw ArgumentError(
              "Matrix must be square for the circulant matrix type.");
        }
        List<dynamic> firstRow = List.generate(columnCount, (_) {
          return isDouble
              ? Complex(random!.nextDouble() * (max - min) + min)
              : Complex(
                  random!.nextInt(max.toInt() - min.toInt()) + min.toInt());
        });
        data = List.generate(
            rowCount,
            (i) => List.generate(columnCount,
                (j) => firstRow[(columnCount - i + j) % columnCount]));
        break;

      case MatrixType.vandermonde:
        if (rowCount != columnCount) {
          throw ArgumentError(
              "Matrix must be square for the Vandermonde matrix type.");
        }
        List<dynamic> firstRow = List.generate(columnCount, (_) {
          return isDouble
              ? Complex(random!.nextDouble() * (max - min) + min)
              : Complex(
                  random!.nextInt(max.toInt() - min.toInt()) + min.toInt());
        });
        data = List.generate(rowCount,
            (i) => List.generate(columnCount, (j) => math.pow(firstRow[j], i)));
        break;

      case MatrixType.permutation:
        if (rowCount != columnCount) {
          throw ArgumentError(
              "Matrix must be square for the permutation matrix type.");
        }
        List<int> indices = List.generate(columnCount, (index) => index);
        indices.shuffle(random);
        for (int i = 0; i < rowCount; i++) {
          data[i][indices[i]] = Complex.one();
        }
        break;

      case MatrixType.nilpotent:
        if (rowCount != columnCount) {
          throw ArgumentError(
              "Matrix must be square for the nilpotent matrix type.");
        }
        for (int i = 0; i < rowCount - 1; i++) {
          data[i][i + 1] = isDouble
              ? Complex(random.nextDouble() * (max - min) + min)
              : Complex(
                  random.nextInt(max.toInt() - min.toInt()) + min.toInt());
        }
        break;

      case MatrixType.involutory:
        if (rowCount != columnCount) {
          throw ArgumentError(
              "Matrix must be square for the involutory matrix type.");
        }

        for (int i = 0; i < rowCount; i++) {
          data[i][i] = isDouble ? Complex(1.0, 0.0) : Complex(1);
        }
        int half = (columnCount / 2).floor();
        for (int i = 0; i < half; i++) {
          int j = columnCount - i - 1;
          num value = isDouble
              ? random.nextDouble() * (max - min) + min
              : random.nextInt(max.toInt() - min.toInt()) + min.toInt();
          data[i][j] = Complex(value);
          data[j][i] = Complex(-value);
        }
        break;

      case MatrixType.diagonallyDominant:
        for (int i = 0; i < rowCount; i++) {
          dynamic rowSum = Complex.zero();
          for (int j = 0; j < columnCount; j++) {
            if (i != j) {
              data[i][j] = isDouble
                  ? Complex(random.nextDouble() * (max - min) + min)
                  : Complex(
                      random.nextInt(max.toInt() - min.toInt()) + min.toInt());
              rowSum += data[i][j].abs();
            }
          }
          data[i][i] = isDouble ? rowSum : rowSum.ceil();
        }
        break;

      case MatrixType.strictlyDiagonallyDominant:
        for (int i = 0; i < rowCount; i++) {
          dynamic rowSum = Complex.zero();
          for (int j = 0; j < columnCount; j++) {
            if (i != j) {
              data[i][j] = isDouble
                  ? Complex(random.nextDouble() * (max - min) + min)
                  : Complex(
                      random.nextInt(max.toInt() - min.toInt()) + min.toInt());
              rowSum += data[i][j].abs();
            }
          }
          data[i][i] = isDouble ? rowSum + (max - min) : rowSum.ceil() + 1;
        }
        break;

      case MatrixType.zeros:
        break;

      case MatrixType.ones:
        data = List.generate(
            rowCount,
            (_) => List.generate(
                columnCount, (_) => isDouble ? Complex(1.0, 0.0) : Complex(1)));
        break;

      case MatrixType.diagonal:
        if (rowCount != columnCount) {
          throw ArgumentError(
              "Matrix must be square for the diagonal matrix type.");
        }
        for (int i = 0; i < rowCount; i++) {
          data[i][i] = value != null
              ? (value is num
                  ? Complex((isDouble ? value.toDouble() : value.toInt()))
                  : value)
              : (isDouble
                  ? Complex(random.nextDouble() * (max - min) + min)
                  : Complex(
                      random.nextInt(max.toInt() - min.toInt()) + min.toInt()));
        }
        break;

      case MatrixType.identity:
        if (rowCount != columnCount) {
          throw ArgumentError(
              "Matrix must be square for the identity matrix type.");
        }
        for (int i = 0; i < rowCount; i++) {
          data[i][i] = isDouble ? Complex(1.0) : Complex(1);
        }

        break;

      case MatrixType.general:
      default:
        data = List.generate(
          rowCount,
          (_) => List.generate(
            columnCount,
            (_) => value != null
                ? (value is num
                    ? Complex(isDouble ? value.toDouble() : value.toInt())
                    : value)
                : (isDouble
                    ? Complex(random!.nextDouble() * (max - min) + min)
                    : Complex(random!.nextInt(max.toInt() - min.toInt()) +
                        min.toInt())),
          ),
        );
    }

    return Matrix(data);
  }
}
