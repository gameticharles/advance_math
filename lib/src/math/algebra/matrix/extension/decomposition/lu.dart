part of '../../../algebra.dart';

/*
 * In this implementation, the code for Singular Value Decomposition (SVD)
 * and LU Decomposition has been borrowed from the SciDart library.
 * SciDart is an open-source library for scientific computing in Dart,
 * which provides various mathematical and statistical functions.
 *
 * Please find the reference to the SciDart library and its source code below:
 *
 * SciDart: https://scidart.org/
 * GitHub repository: https://github.com/scidart/scidart
 *
 * We would like to express our gratitude to the authors and contributors of
 * the SciDart library for their valuable work in providing these efficient
 * and well-tested algorithms for the Dart community.
 */
class LU {
  //#region class variables
  /// Array for internal storage of decomposition.
  /// internal array storage.
  Matrix luMatrix = Matrix();

  /// Row and column dimensions, and pivot sign.
  /// - [_m] column dimension.
  /// - [_n] row dimension.
  /// - [_pivsign] pivot sign.
  int _m = 0, _n = 0;
  dynamic _pivsign = Complex.one();

  /// Internal storage of pivot vector.
  /// - [_piv] pivot vector.
  Matrix _piv = Matrix();

  //#endregion

  //#region Constructor
  /// LU Decomposition
  /// Structure to access L, U and piv.
  /// - [A] Rectangular matrix
  LU(Matrix A) {
    // Use a "left-looking", dot-product, Crout/Doolittle algorithm.
    luMatrix = A.copy();
    _m = A.rowCount;
    _n = A.columnCount;
    _piv = Matrix.zeros(1, _m);
    for (var i = 0; i < _m; i++) {
      _piv[0][i] = i;
    }
    _pivsign = Complex.one();
    Matrix luRowI = Matrix();
    var luColJ = Matrix.zeros(_m, 1);

    // Outer loop.

    for (var j = 0; j < _n; j++) {
      // Make a copy of the j-th column to localize references.

      for (var i = 0; i < _m; i++) {
        luColJ[i][0] = luMatrix[i][j];
      }

      // Apply previous transformations.

      for (var i = 0; i < _m; i++) {
        luRowI = _Utils.toNumMatrix(luMatrix.row(i));

        // Most of the time is spent in the following dot product.

        var kmax = math.min(i, j);
        dynamic s = Complex.zero();
        for (var k = 0; k < kmax; k++) {
          s += luRowI[0][k] * luColJ[k][0];
        }

        luRowI[0][j] = luColJ[i][0] -= s;
      }

      // Find pivot and exchange if necessary.

      var p = j;
      for (var i = j + 1; i < _m; i++) {
        if (luColJ[i][0].abs() > luColJ[p][0].abs()) {
          p = i;
        }
      }
      if (p != j) {
        for (var k = 0; k < _n; k++) {
          var t = luMatrix[p][k];
          luMatrix[p][k] = luMatrix[j][k];
          luMatrix[j][k] = t;
        }
        var k = _piv[0][p];
        _piv[0][p] = _piv[0][j];
        _piv[0][j] = k;
        _pivsign = -_pivsign;
      }

      // Compute multipliers.
      if (j < _m && luMatrix[j][j] != Complex.zero()) {
        for (var i = j + 1; i < _m; i++) {
          luMatrix[i][j] /= luMatrix[j][j];
        }
      }
    }
  }

//#region Temporary, experimental code.
/*
   \** LU Decomposition, computed by Gaussian elimination.
   <P>
   This constructor computes L and U with the "daxpy"-based elimination
   algorithm used in LINPACK and MATLAB.  In Java, we suspect the dot-product,
   Crout algorithm will be faster.  We have temporarily included this
   constructor until timing experiments confirm this suspicion.
   <P>
   @param  A             Rectangular matrix
   @param  linpackflag   Use Gaussian elimination.  Actual value ignored.
   @return               Structure to access L, U and piv.
   *\

   public LUDecomposition (Matrix A, int linpackflag) {
      // Initialize.
      LU = A.getArrayCopy();
      m = A.getRowDimension();
      n = A.getColumnDimension();
      piv = new int[m];
      for (int i = 0; i < m; i++) {
         piv[i] = i;
      }
      pivsign = 1;
      // Main loop.
      for (int k = 0; k < n; k++) {
         // Find pivot.
         int p = k;
         for (int i = k+1; i < m; i++) {
            if (Math.abs(LU[i][k]) > Math.abs(LU[p][k])) {
               p = i;
            }
         }
         // Exchange if necessary.
         if (p != k) {
            for (int j = 0; j < n; j++) {
               double t = LU[p][j]; LU[p][j] = LU[k][j]; LU[k][j] = t;
            }
            int t = piv[p]; piv[p] = piv[k]; piv[k] = t;
            pivsign = -pivsign;
         }
         // Compute multipliers and eliminate k-th column.
         if (LU[k][k] != 0.0) {
            for (int i = k+1; i < m; i++) {
               LU[i][k] /= LU[k][k];
               for (int j = k+1; j < n; j++) {
                  LU[i][j] -= LU[i][k]*LU[k][j];
               }
            }
         }
      }
   }
*/
//#endregion.

//#region Public Methods
  /// Is the matrix nonsingular?
  /// return true if U, and hence A, is nonsingular.
  bool isNonSingular() {
    for (var j = 0; j < _n; j++) {
      if (luMatrix[j][j] == 0) {
        return false;
      }
    }
    return true;
  }

  /// Return lower triangular factor
  /// return  L
  Matrix L() {
    var L = Matrix.zeros(_m, _n);
    for (var i = 0; i < _m; i++) {
      for (var j = 0; j < _n; j++) {
        if (i > j) {
          L[i][j] = luMatrix[i][j];
        } else if (i == j) {
          L[i][j] = Complex.one();
        } else {
          L[i][j] = Complex.zero();
        }
      }
    }
    return L;
  }

  /// Return upper triangular factor
  /// return U
  Matrix U() {
    var U = Matrix.fill(_n, _n, 0.0);
    for (var i = 0; i < _n; i++) {
      for (var j = 0; j < _n; j++) {
        if (i <= j) {
          U[i][j] = luMatrix[i][j];
        } else {
          U[i][j] = Complex.zero();
        }
      }
    }
    return U;
  }

  /// Return pivot permutation vector
  /// return piv
  RowMatrix pivot() {
    var p = RowMatrix.fill(_m, 0.0);
    for (var i = 0; i < _m; i++) {
      p[i] = _piv[0][i];
    }
    return p;
  }

  /// Return pivot permutation vector as a one-dimensional double array
  /// return (double) piv
  RowMatrix doublePivot() {
    var val = RowMatrix.fill(_m, 0.0);
    for (var i = 0; i < _m; i++) {
      val[i] = _piv[0][i];
    }
    return val;
  }

  /// Determinant
  /// return det(A)
  /// exception FormatException Matrix must be square
  dynamic det() {
    if (_m != _n) {
      throw FormatException('Matrix must be square.');
    }
    var d = _pivsign;
    for (var j = 0; j < _n; j++) {
      d *= luMatrix[j][j];
    }
    return d;
  }

  /// Solve A*X = B
  /// - [B] A Matrix with as many rows as A and any number of columns.
  /// so that L*U*X = B(piv,:)
  /// - [FormatException] Matrix row dimensions must agree or Matrix is singular.
  Matrix solve(Matrix B) {
    if (B.rowCount != _m) {
      throw FormatException('Matrix row dimensions must agree.');
    }
    if (!isNonSingular()) {
      throw FormatException('Matrix is singular.');
    }

    // Copy right hand side with pivoting
    var nx = B.columnCount;
    var X = B.subMatrix(
        rowIndices: _piv.flatten().map((e) => (e as Complex).toInt()).toList(),
        colStart: 0,
        colEnd: nx - 1);

    // Solve L*Y = B(piv,:)
    for (var k = 0; k < _n; k++) {
      for (var i = k + 1; i < _n; i++) {
        for (var j = 0; j < nx; j++) {
          X[i][j] -= X[k][j] * luMatrix[i][k];
        }
      }
    }
    // Solve U*X = Y;
    for (var k = _n - 1; k >= 0; k--) {
      for (var j = 0; j < nx; j++) {
        X[k][j] /= luMatrix[k][k];
      }
      for (var i = 0; i < k; i++) {
        for (var j = 0; j < nx; j++) {
          X[i][j] -= X[k][j] * luMatrix[i][k];
        }
      }
    }
    return X;
  }
}
