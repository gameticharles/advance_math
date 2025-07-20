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

class SVD {
  //#region Class variables
  /// Matrix for internal storage of U and V.
  /// internal storage of [_u].
  /// internal storage of [_v].
  Matrix _u = Matrix(), _v = Matrix();

  /// Matrix for internal storage of singular values.
  /// internal storage of singular values.
  Matrix _s = Matrix();

  /// Row and column dimensions.
  /// - [_m] row dimension.
  /// - [_n] column dimension.
  int _m = 0, _n = 0;

  //#endregion

  //#region Constructor
  /// Construct the singular value decomposition
  /// Structure to access U, S and V.
  /// - [mat] Rectangular matrix
  SVD(Matrix mat, {int? maxIterations}) {
    // Derived from LINPACK code.
    // Initialize.
    _m = mat.rowCount;
    _n = mat.columnCount;

    // Apparently the failing cases are only a proper subset of (m<n),
    // so let's not throw error.  Correct fix to come later?
    Matrix A;
    var specialCaseMoreColumns = false;
    var specialCaseMoreRows = false;
    if (_m < _n) {
      specialCaseMoreColumns = true;
      _m = mat.columnCount;
      _n = mat.columnCount;

      A = Matrix.zeros(_m, _n);
      A.copyFrom(mat, retainSize: true);
    } else if (_m > _n) {
      specialCaseMoreRows = true;
      _m = mat.rowCount;
      _n = mat.rowCount;

      A = Matrix.zeros(_m, _n);
      A.copyFrom(mat, retainSize: true);
    } else {
      A = mat.copy();
    }

    A = _Utils.toNumMatrix(A);

    var nu = math.max(_m, _n);
    _s = Matrix.zeros(1, math.min(_m + 1, _n));
    _u = Matrix.zeros(_m, nu);
    _v = Matrix.zeros(_n, _n);
    var e = Matrix.zeros(1, _n);
    var work = Matrix.zeros(1, _m);
    var wantu = true;
    var wantv = true;

    // Reduce A to bidiagonal form, storing the diagonal elements
    // in s and the super-diagonal elements in e.

    var nct = math.min(_m - 1, _n);
    var nrt = math.max(0, math.min(_n - 2, _m));
    for (var k = 0; k < math.max(nct, nrt); k++) {
      if (k < nct) {
        // Compute the transformation for the k-th column and
        // place the k-th diagonal in s[k].
        // Compute 2-norm of k-th column without under/overflow.
        _s[0][k] = Complex.zero();
        for (var i = k; i < _m; i++) {
          _s[0][k] = hypotenuse(_s[0][k], A[i][k]);
        }
        if (_s[0][k] != Complex.zero()) {
          if (A[k][k] < Complex.zero()) {
            _s[0][k] = -_s[0][k];
          }
          for (var i = k; i < _m; i++) {
            A[i][k] /= _s[0][k];
          }
          A[k][k] += Complex.one();
        }
        _s[0][k] = -_s[0][k];
      }
      for (var j = k + 1; j < _n; j++) {
        if ((k < nct) && (_s[0][k] != Complex.zero())) {
          // Apply the transformation.

          dynamic t = Complex.zero();
          for (var i = k; i < _m; i++) {
            t += A[i][k] * A[i][j];
          }
          t = -t / A[k][k];
          for (var i = k; i < _m; i++) {
            A[i][j] += t * A[i][k];
          }
        }

        // Place the k-th row of A into e for the
        // subsequent calculation of the row transformation.

        e[0][j] = A[k][j];
      }
      if (wantu && (k < nct)) {
        // Place the transformation in U for subsequent back
        // multiplication.

        for (var i = k; i < _m; i++) {
          _u[i][k] = A[i][k];
        }
      }
      if (k < nrt) {
        // Compute the k-th row transformation and place the
        // k-th super-diagonal in e[0][k].
        // Compute 2-norm without under/overflow.
        e[0][k] = Complex.zero();
        for (var i = k + 1; i < _n; i++) {
          e[0][k] = hypotenuse(e[0][k], e[0][i]);
        }
        if (e[0][k] != Complex.zero()) {
          if (e[0][k + 1] < Complex.zero()) {
            e[0][k] = -e[0][k];
          }
          for (var i = k + 1; i < _n; i++) {
            e[0][i] /= e[0][k];
          }
          e[0][k + 1] += Complex.one();
        }
        e[0][k] = -e[0][k];
        if ((k + 1 < _m) && (e[0][k] != Complex.zero())) {
          // Apply the transformation.

          for (var i = k + 1; i < _m; i++) {
            work[0][i] = Complex.zero();
          }
          for (var j = k + 1; j < _n; j++) {
            for (var i = k + 1; i < _m; i++) {
              work[0][i] += e[0][j] * A[i][j];
            }
          }
          for (var j = k + 1; j < _n; j++) {
            var t = -e[0][j] / e[0][k + 1];
            for (var i = k + 1; i < _m; i++) {
              A[i][j] += t * work[0][i];
            }
          }
        }
        if (wantv) {
          // Place the transformation in V for subsequent
          // back multiplication.

          for (var i = k + 1; i < _n; i++) {
            _v[i][k] = e[0][i];
          }
        }
      }
    }

    // Set up the final bidiagonal matrix or order p.

    var p = math.min(_n, _m + 1);
    if (nct < _n) {
      _s[0][nct] = A[nct][nct];
    }
    if (_m < p) {
      _s[0][p - 1] = Complex.zero();
    }
    if (nrt + 1 < p) {
      e[0][nrt] = A[nrt][p - 1];
    }
    e[0][p - 1] = Complex.zero();

    // If required, generate U.

    if (wantu) {
      for (var j = nct; j < nu; j++) {
        for (var i = 0; i < _m; i++) {
          _u[i][j] = Complex.zero();
        }
        _u[j][j] = Complex.one();
      }
      for (var k = nct - 1; k >= 0; k--) {
        if (_s[0][k] != Complex.zero()) {
          for (var j = k + 1; j < nu; j++) {
            dynamic t = Complex.zero();
            for (var i = k; i < _m; i++) {
              t += _u[i][k] * _u[i][j];
            }
            t = -t / _u[k][k];
            for (var i = k; i < _m; i++) {
              _u[i][j] += t * _u[i][k];
            }
          }
          for (var i = k; i < _m; i++) {
            _u[i][k] = -_u[i][k];
          }
          _u[k][k] = Complex.one() + _u[k][k];
          for (var i = 0; i < k - 1; i++) {
            _u[i][k] = Complex.zero();
          }
        } else {
          for (var i = 0; i < _m; i++) {
            _u[i][k] = Complex.zero();
          }
          _u[k][k] = Complex.one();
        }
      }
    }

    // If required, generate V.

    if (wantv) {
      for (var k = _n - 1; k >= 0; k--) {
        if ((k < nrt) && (e[0][k] != Complex.zero())) {
          for (var j = k + 1; j < nu; j++) {
            dynamic t = Complex.zero();
            for (var i = k + 1; i < _n; i++) {
              t += _v[i][k] * _v[i][j];
            }
            t = -t / _v[k + 1][k];
            for (var i = k + 1; i < _n; i++) {
              _v[i][j] += t * _v[i][k];
            }
          }
        }
        for (var i = 0; i < _n; i++) {
          _v[i][k] = Complex.zero();
        }
        _v[k][k] = Complex.one();
      }
    }

    // Main iteration loop for the singular values.

    var pp = p - 1;
    var iter = 0;
    var eps = Complex(math.pow(2.0, -52.0));
    var tiny = Complex(math.pow(2.0, -966.0));

    // Add maximum iteration count to prevent infinite loops
    maxIterations = maxIterations ?? 100 * math.max(_m, _n);

    while (p > 0) {
      // Check if we've exceeded the maximum number of iterations
      if (iter > maxIterations) {
        // Force convergence by setting remaining e values to zero
        for (int i = 0; i < e[0].length; i++) {
          e[0][i] = Complex.zero();
        }
        break;
      }

      int k, kase;

      // Here is where a test for too many iterations would go.

      // This section of the program inspects for
      // negligible elements in the s and e arrays.  On
      // completion the variables kase and k are set as follows.

      // kase = 1     if s(p) and e[0][k-1] are negligible and k<p
      // kase = 2     if s(k) is negligible and k<p
      // kase = 3     if e[0][k-1] is negligible, k<p, and
      //              s(k), ..., s(p) are not negligible (qr step).
      // kase = 4     if e(p-1) is negligible (convergence).
      for (k = p - 2; k >= -1; k--) {
        if (k == -1) {
          break;
        }
        if (Complex(e[0][k].abs()) <=
            (tiny + (eps * Complex(_s[0][k].abs() + _s[0][k + 1].abs())))) {
          e[0][k] = Complex.zero();
          break;
        }
      }
      if (k == p - 2) {
        kase = 4;
      } else {
        int ks;
        for (ks = p - 1; ks >= k; ks--) {
          if (ks == k) {
            break;
          }
          var t = (ks != p ? (e[0][ks].abs()) : 0) +
              (ks != k + 1 ? e[0][ks - 1].abs() : 0);
          if (Complex(_s[0][ks].abs()) <= (tiny + (eps * Complex(t)))) {
            _s[0][ks] = Complex.zero();
            break;
          }
        }
        if (ks == k) {
          kase = 3;
        } else if (ks == p - 1) {
          kase = 1;
        } else {
          kase = 2;
          k = ks;
        }
      }
      k++;

      // Perform the task indicated by kase.

      switch (kase) {
        // Deflate negligible s(p).

        case 1:
          {
            var f = e[0][p - 2];
            e[0][p - 2] = Complex.zero();
            for (var j = p - 2; j >= k; j--) {
              var t = hypotenuse(_s[0][j], f);
              var cs = _s[0][j] / t;
              var sn = f / t;
              _s[0][j] = t;
              if (j != k) {
                f = -sn * e[0][j - 1];
                e[0][j - 1] = cs * e[0][j - 1];
              }
              if (wantv) {
                for (var i = 0; i < _n; i++) {
                  t = (cs * _v[i][j]) + (sn * _v[i][p - 1]);
                  _v[i][p - 1] = (-sn * _v[i][j]) + (cs * _v[i][p - 1]);
                  _v[i][j] = t;
                }
              }
            }
          }
          break;

        // Split at negligible s(k).

        case 2:
          {
            var f = e[0][k - 1];
            e[0][k - 1] = Complex.zero();
            for (var j = k; j < p; j++) {
              var t = hypotenuse(_s[0][j], f);
              var cs = _s[0][j] / t;
              var sn = f / t;
              _s[0][j] = t;
              f = -sn * e[0][j];
              e[0][j] = cs * e[0][j];
              if (wantu) {
                for (var i = 0; i < _m; i++) {
                  t = (cs * _u[i][j]) + (sn * _u[i][k - 1]);
                  _u[i][k - 1] = (-sn * _u[i][j]) + (cs * _u[i][k - 1]);
                  _u[i][j] = t;
                }
              }
            }
          }
          break;

        // Perform one qr step.

        case 3:
          {
            // Calculate the shift.

            var scale = math.max(
                math.max(
                    math.max(math.max(_s[0][p - 1].abs(), _s[0][p - 2].abs()),
                        e[0][p - 2].abs()),
                    _s[0][k].abs()),
                e[0][k].abs());
            var sp = _s[0][p - 1] / scale;
            var spm1 = _s[0][p - 2] / scale;
            var epm1 = e[0][p - 2] / scale;
            var sk = _s[0][k] / scale;
            var ek = e[0][k] / scale;
            var b = ((spm1 + sp) * (spm1 - sp) + (epm1 * epm1)) / Complex(2.0);
            var c = (sp * epm1) * (sp * epm1);
            dynamic shift = Complex.zero();
            if ((b != Complex.zero()) | (c != Complex.zero())) {
              shift = math.sqrt((b * b) + c);
              if (b < Complex.zero()) {
                shift = -shift;
              }
              shift = c / (b + shift);
            }
            var f = ((sk + sp) * (sk - sp)) + shift;
            var g = sk * ek;

            // Chase zeros.

            for (var j = k; j < p - 1; j++) {
              var t = hypotenuse(f, g);
              var cs = f / t;
              var sn = g / t;
              if (j != k) {
                e[0][j - 1] = t;
              }
              f = (cs * _s[0][j]) + (sn * e[0][j]);
              e[0][j] = (cs * e[0][j]) - (sn * _s[0][j]);
              g = sn * _s[0][j + 1];
              _s[0][j + 1] = cs * _s[0][j + 1];
              if (wantv) {
                for (var i = 0; i < _n; i++) {
                  t = (cs * _v[i][j]) + (sn * _v[i][j + 1]);
                  _v[i][j + 1] = (-sn * _v[i][j]) + (cs * _v[i][j + 1]);
                  _v[i][j] = t;
                }
              }
              t = hypotenuse(f, g);
              cs = f / t;
              sn = g / t;
              _s[0][j] = t;
              f = (cs * e[0][j]) + (sn * _s[0][j + 1]);
              _s[0][j + 1] = (-sn * e[0][j]) + (cs * _s[0][j + 1]);
              g = sn * e[0][j + 1];
              e[0][j + 1] = cs * e[0][j + 1];
              if (wantu && (j < _m - 1)) {
                for (var i = 0; i < _m; i++) {
                  t = (cs * _u[i][j]) + (sn * _u[i][j + 1]);
                  _u[i][j + 1] = (-sn * _u[i][j]) + (cs * _u[i][j + 1]);
                  _u[i][j] = t;
                }
              }
            }
            e[0][p - 2] = f;
            iter = iter + 1;
          }
          break;

        // Convergence.
        case 4:
          {
            // Make the singular values positive.

            if (_s[0][k] <= Complex.zero()) {
              _s[0][k] =
                  (_s[0][k] < Complex.zero() ? -_s[0][k] : Complex.zero());
              if (wantv) {
                for (var i = 0; i <= pp; i++) {
                  _v[i][k] = -_v[i][k];
                }
              }
            }

            // Order the singular values.

            while (k < pp) {
              if (_s[0][k] >= _s[0][k + 1]) {
                break;
              }
              var t = _s[0][k];
              _s[0][k] = _s[0][k + 1];
              _s[0][k + 1] = t;
              if (wantv && (k < _n - 1)) {
                for (var i = 0; i < _n; i++) {
                  t = _v[i][k + 1];
                  _v[i][k + 1] = _v[i][k];
                  _v[i][k] = t;
                }
              }
              if (wantu && (k < _m - 1)) {
                for (var i = 0; i < _m; i++) {
                  t = _u[i][k + 1];
                  _u[i][k + 1] = _u[i][k];
                  _u[i][k] = t;
                }
              }
              k++;
            }
            iter = 0;
            p--;
          }
          break;
      }
    }

    if (specialCaseMoreColumns) {
      _m = mat.rowCount;
      _n = mat.columnCount;
      _u = _u * -1;
      _v = _v * -1;
    } else if (specialCaseMoreRows) {
      _m = mat.rowCount;
      _n = mat.columnCount;

      for (var i = 0; i < _u.rowCount; i++) {
        for (var j = 0; j < _u.columnCount; j++) {
          if (isOdd(j)) {
            _u[i][j] *= -1;
          }
        }
      }

      for (var i = 0; i < _v.rowCount; i++) {
        for (var j = 0; j < _v.columnCount; j++) {
          if (isOdd(j)) {
            _v[i][j] *= -1;
          }
        }
      }
    }
  }

  //#endregion

  //#region Public Methods
  /// Check if a is an Odd number.
  bool isOdd(int a) => a % 2 != 0;

  // Modified hypotenuse function to properly handle Complex numbers
  dynamic hypotenuse(dynamic x, dynamic y) {
    // Handle the case when both are Complex
    if (x is Complex && y is Complex) {
      return Complex(math.sqrt(math.pow(x.abs(), 2) + math.pow(y.abs(), 2)), 0);
    }

    // Handle the case when one is Complex
    if (x is Complex) {
      return Complex(
          math.sqrt(math.pow(x.abs(), 2) + math.pow(y as num, 2)), 0);
    }

    if (y is Complex) {
      return Complex(
          math.sqrt(math.pow(x as num, 2) + math.pow(y.abs(), 2)), 0);
    }

    // Original implementation for numeric values
    return math.sqrt(math.pow(x as num, 2) + math.pow(y as num, 2));
  }

  /// Return the left singular vectors
  /// return U
  Matrix U() {
    if (_m > _n) {
      var dim = math.max(_m, _n) - 1;
      return _u.slice(0, dim + 1, 0, dim + 1);
    }
    if (_m < _n) {
      var dim = math.min(_m, _n) - 1;
      return _u.slice(0, dim + 1, 0, dim + 1);
    } else {
      return _u.slice(0, _m, 0, math.min(_m + 1, _n));
    }
  }

  /// Return the right singular vectors
  /// return V
  Matrix V() {
    return _v.slice(0, _n, 0, _n);
  }

  /// Return the diagonal matrix of singular values
  /// return S
  Matrix S() {
    // Create a matrix with the same dimensions as the original matrix
    Matrix result = Matrix.zeros(_m, _n);

    // Get the minimum dimension to avoid index out of bounds
    int minDim = math.min(_m, _n);

    // Set the diagonal elements to the singular values
    for (int i = 0; i < minDim; i++) {
      result[i][i] = _s[0][i];
    }

    return result;
  }

  /// Two norm condition number
  /// return max(S)/min(S)
  dynamic cond() {
    // Get the largest singular value (always at position [0][0])
    dynamic maxSingularValue = _s[0][0];

    // Find the smallest non-zero singular value
    int minDim = math.min(_m, _n);
    dynamic minSingularValue = maxSingularValue; // Start with the largest value

    for (int i = 0; i < minDim; i++) {
      dynamic value = _s[0][i];
      // Only consider non-zero values to avoid division by zero
      if (value.abs() > 1e-15 && value.abs() < minSingularValue.abs()) {
        minSingularValue = value;
      }
    }

    // Calculate the condition number
    return maxSingularValue / minSingularValue;
  }

//#endregion
}
