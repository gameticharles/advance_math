import '../algebra/algebra.dart';
import 'package:dartframe/dartframe.dart';
import 'dart:math' as math;

/// Helper to safely convert dynamic matrix values to double.
double _toNum(dynamic val) {
  // Check if it has real property (Complex number)
  try {
    return (val as dynamic).real.toDouble();
  } catch (e) {
    return val.toDouble();
  }
}

/// Helper to convert List or Series to `List<num>`.
List<num> _toNumList(dynamic input) {
  if (input is Series) {
    return input.data.cast<num>().toList();
  }
  if (input is List) {
    return input.cast<num>();
  }
  throw ArgumentError('Input must be List<num> or Series');
}

/// Result of a regression analysis.
/// Result of a regression analysis.
class RegressionResult {
  /// Regression coefficients (including intercept as first element).
  final Series coefficients;

  /// R-squared value.
  final num rSquared;

  /// Adjusted R-squared value.
  final num? adjustedRSquared;

  /// Residuals.
  final Series residuals;

  /// Predicted values.
  final Series predictions;

  /// Standard errors of coefficients.
  final Series? standardErrors;

  /// P-values for coefficients.
  final Series? pValues;

  RegressionResult({
    required this.coefficients,
    required this.rSquared,
    this.adjustedRSquared,
    required this.residuals,
    required this.predictions,
    this.standardErrors,
    this.pValues,
  });

  /// Predict new values.
  /// [x] can be a `List<num>` or Series.
  num predict(dynamic x) {
    if (x is! List && x is! Series) {
      throw ArgumentError('Input x must be List or Series');
    }

    // Convert Series to List for indexing if needed, or iterate
    List<dynamic> xList = (x is Series) ? x.toList() : x as List;

    if (xList.length != coefficients.length - 1) {
      throw ArgumentError('Input dimension mismatch');
    }

    // coefficients is Series<dynamic>, cast if needed or access via []
    // coefficients[0] is intercept
    num result = coefficients[0] as num;
    for (int i = 0; i < xList.length; i++) {
      result += (coefficients[i + 1] as num) * (xList[i] as num);
    }
    return result;
  }

  @override
  String toString() {
    return 'RegressionResult(R²=${rSquared.toStringAsFixed(4)}, coefficients=${coefficients.data})';
  }
}

/// Regression analysis methods.
class Regression {
  /// Simple linear regression (y = a + bx).
  static RegressionResult linear(dynamic x, dynamic y) {
    List<num> xList = _toNumList(x);
    List<num> yList = _toNumList(y);

    if (xList.length != yList.length || xList.isEmpty) {
      throw ArgumentError('x and y must have same non-zero length');
    }

    int n = xList.length;
    num sumX = xList.reduce((a, b) => a + b);
    num sumY = yList.reduce((a, b) => a + b);
    num sumXY = 0, sumX2 = 0;

    for (int i = 0; i < n; i++) {
      sumXY += xList[i] * yList[i];
      sumX2 += xList[i] * xList[i];
    }

    num slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    num intercept = (sumY - slope * sumX) / n;

    // Calculate predictions and residuals
    List<num> predictions = xList.map((xi) => intercept + slope * xi).toList();
    List<num> residuals = [];
    for (int i = 0; i < n; i++) {
      residuals.add(yList[i] - predictions[i]);
    }

    // Calculate R-squared
    num yMean = sumY / n;
    num ssTot =
        yList.map((yi) => (yi - yMean) * (yi - yMean)).reduce((a, b) => a + b);
    num ssRes = residuals.map((r) => r * r).reduce((a, b) => a + b);
    num rSquared = 1 - ssRes / ssTot;

    return RegressionResult(
      coefficients: Series([intercept, slope], name: 'coefficients'),
      rSquared: rSquared,
      adjustedRSquared: 1 - (1 - rSquared) * (n - 1) / (n - 2),
      residuals: Series(residuals, name: 'residuals'),
      predictions: Series(predictions, name: 'predictions'),
    );
  }

  /// Multiple linear regression.
  static RegressionResult multipleLinear(Matrix X, dynamic y) {
    List<num> yList = _toNumList(y);
    int n = X.rowCount;
    int p = X.columnCount;

    if (yList.length != n) {
      throw ArgumentError('y length must match X rows');
    }

    // Add intercept column
    List<List<double>> xData = [];
    for (int i = 0; i < n; i++) {
      List<double> row = [1.0]; // Intercept
      for (int j = 0; j < p; j++) {
        row.add(_toNum(X[i][j]));
      }
      xData.add(row);
    }

    Matrix xMat = Matrix(xData);
    Matrix yMat = Matrix(yList.map((e) => [e.toDouble()]).toList());

    // Use Gauss-Jordan to solve (X'X)β = X'y
    Matrix xTX = xMat.transpose() * xMat;
    Matrix xTy = xMat.transpose() * yMat;

    Matrix beta = LinearSystemSolvers.gaussJordanElimination(xTX, xTy);

    List<num> coefficients = [];
    for (int i = 0; i < beta.rowCount; i++) {
      coefficients.add(_toNum(beta[i][0]));
    }

    // Calculate predictions
    List<num> predictions = [];
    for (int i = 0; i < n; i++) {
      num pred = coefficients[0];
      for (int j = 0; j < p; j++) {
        pred += coefficients[j + 1] * _toNum(X[i][j]);
      }
      predictions.add(pred);
    }

    // Calculate residuals and R-squared
    List<num> residuals = [];
    for (int i = 0; i < n; i++) {
      residuals.add(yList[i] - predictions[i]);
    }

    num yMean = yList.reduce((a, b) => a + b) / n;
    num ssTot =
        yList.map((yi) => (yi - yMean) * (yi - yMean)).reduce((a, b) => a + b);
    num ssRes = residuals.map((r) => r * r).reduce((a, b) => a + b);
    num rSquared = 1 - ssRes / ssTot;
    num adjRSquared = 1 - (1 - rSquared) * (n - 1) / (n - p - 1);

    return RegressionResult(
      coefficients: Series(coefficients, name: 'coefficients'),
      rSquared: rSquared,
      adjustedRSquared: adjRSquared,
      residuals: Series(residuals, name: 'residuals'),
      predictions: Series(predictions, name: 'predictions'),
    );
  }

  /// Polynomial regression.
  static RegressionResult polynomial(dynamic x, dynamic y, int degree) {
    List<num> xList = _toNumList(x);
    if (degree < 1) {
      throw ArgumentError('degree must be at least 1');
    }

    // Generate polynomial features
    int n = xList.length;
    List<List<double>> xPoly = [];
    for (int i = 0; i < n; i++) {
      List<double> row = [];
      for (int d = 1; d <= degree; d++) {
        row.add(math.pow(xList[i], d).toDouble());
      }
      xPoly.add(row);
    }

    Matrix xMat = Matrix(xPoly);
    return multipleLinear(xMat, y);
  }

  /// Ridge regression (L2 regularization).
  static RegressionResult ridge(Matrix X, dynamic y, {double alpha = 1.0}) {
    List<num> yList = _toNumList(y);
    int n = X.rowCount;
    int p = X.columnCount;

    if (yList.length != n) {
      throw ArgumentError('y length must match X rows');
    }

    // Add intercept column
    List<List<double>> xData = [];
    for (int i = 0; i < n; i++) {
      List<double> row = [1.0];
      for (int j = 0; j < p; j++) {
        row.add(X[i][j].toDouble());
      }
      xData.add(row);
    }

    Matrix xMat = Matrix(xData);
    Matrix yMat = Matrix(yList.map((e) => [e.toDouble()]).toList());

    // Use built-in ridge regression
    Matrix beta = LinearSystemSolvers.ridgeRegression(xMat, yMat, alpha);

    List<num> coefficients = [];
    for (int i = 0; i < beta.rowCount; i++) {
      coefficients.add(_toNum(beta[i][0]));
    }

    // Calculate predictions and metrics
    List<num> predictions = [];
    for (int i = 0; i < n; i++) {
      num pred = coefficients[0];
      for (int j = 0; j < p; j++) {
        pred += coefficients[j + 1] * _toNum(X[i][j]);
      }
      predictions.add(pred);
    }

    List<num> residuals = [];
    for (int i = 0; i < n; i++) {
      residuals.add(yList[i] - predictions[i]);
    }

    num yMean = yList.reduce((a, b) => a + b) / n;
    num ssTot =
        yList.map((yi) => (yi - yMean) * (yi - yMean)).reduce((a, b) => a + b);
    num ssRes = residuals.map((r) => r * r).reduce((a, b) => a + b);
    num rSquared = 1 - ssRes / ssTot;

    return RegressionResult(
      coefficients: Series(coefficients, name: 'coefficients'),
      rSquared: rSquared,
      adjustedRSquared: 1 - (1 - rSquared) * (n - 1) / (n - p - 1),
      residuals: Series(residuals, name: 'residuals'),
      predictions: Series(predictions, name: 'predictions'),
    );
  }

  /// Logistic regression for binary classification.
  static RegressionResult logistic(
    Matrix X,
    dynamic y, {
    int maxIter = 100,
    double learningRate = 0.01,
  }) {
    List<num> yList = _toNumList(y);
    int n = X.rowCount;
    int p = X.columnCount;

    // Initialize coefficients
    List<num> coefficients = List.filled(p + 1, 0.0);

    // Gradient descent
    for (int iter = 0; iter < maxIter; iter++) {
      List<num> predictions = [];
      for (int i = 0; i < n; i++) {
        num z = coefficients[0];
        for (int j = 0; j < p; j++) {
          z += coefficients[j + 1] * _toNum(X[i][j]);
        }
        predictions.add(_sigmoid(z));
      }

      // Calculate gradients
      List<num> gradients = List.filled(p + 1, 0.0);
      for (int i = 0; i < n; i++) {
        num error = predictions[i] - yList[i];
        gradients[0] += error;
        for (int j = 0; j < p; j++) {
          gradients[j + 1] += error * X[i][j].toDouble();
        }
      }

      // Update coefficients
      for (int j = 0; j < coefficients.length; j++) {
        coefficients[j] -= learningRate * gradients[j] / n;
      }
    }

    // Final predictions
    List<num> predictions = [];
    for (int i = 0; i < n; i++) {
      num z = coefficients[0];
      for (int j = 0; j < p; j++) {
        z += coefficients[j + 1] * _toNum(X[i][j]);
      }
      predictions.add(_sigmoid(z));
    }

    List<num> residuals = [];
    for (int i = 0; i < n; i++) {
      residuals.add(yList[i] - predictions[i]);
    }

    // Calculate pseudo R-squared (McFadden's)
    num yMean = yList.reduce((a, b) => a + b) / n;
    num nullDeviance = 0;
    for (int i = 0; i < n; i++) {
      if (yList[i] == 1) {
        nullDeviance -= 2 * math.log(yMean);
      } else {
        nullDeviance -= 2 * math.log(1 - yMean);
      }
    }

    num residualDeviance = 0;
    for (int i = 0; i < n; i++) {
      num p = predictions[i].clamp(1e-10, 1 - 1e-10);
      if (yList[i] == 1) {
        residualDeviance -= 2 * math.log(p);
      } else {
        residualDeviance -= 2 * math.log(1 - p);
      }
    }

    num pseudoR2 = 1 - residualDeviance / nullDeviance;

    return RegressionResult(
      coefficients: Series(coefficients, name: 'coefficients'),
      rSquared: pseudoR2,
      residuals: Series(residuals, name: 'residuals'),
      predictions: Series(predictions, name: 'predictions'),
    );
  }

  /// Lasso regression (L1 regularization) using Coordinate Descent.
  static RegressionResult lasso(Matrix X, dynamic y,
      {double alpha = 1.0, int maxIter = 1000, double tol = 1e-4}) {
    return elasticNet(X, y,
        alpha: alpha, l1Ratio: 1.0, maxIter: maxIter, tol: tol);
  }

  /// Elastic Net regression (L1 and L2 regularization).
  /// [l1Ratio] = 1.0 is Lasso, 0.0 is Ridge.
  static RegressionResult elasticNet(
    Matrix X,
    dynamic y, {
    double alpha = 1.0,
    double l1Ratio = 0.5,
    int maxIter = 1000,
    double tol = 1e-4,
  }) {
    List<num> yList = _toNumList(y);
    int n = X.rowCount;
    int p = X.columnCount;

    // Standardize features? Usually needed for regularization.
    // For simplicity here, we assume user provided standardized data or we work raw.
    // Let's implement Coordinate Descent on raw data but ideally inputs should be centered/scaled.
    // WARNING: Intercept handling in regularized regression is tricky. Usually intercept is not penalized.
    // We will add intercept column and NOT penalize it (index 0).

    // Add intercept
    List<List<double>> xData = [];
    for (int i = 0; i < n; i++) {
      List<double> row = [1.0];
      for (int j = 0; j < p; j++) {
        row.add(_toNum(X[i][j]));
      }
      xData.add(row);
    }
    // Now p is p+1 (including intercept)
    int pTotal = p + 1;

    // Initialize beta = 0
    List<double> beta = List.filled(pTotal, 0.0);

    // Precompute sum of squares for each column (denominator part)
    List<double> normCols = List.filled(pTotal, 0.0);
    for (int j = 0; j < pTotal; j++) {
      double s = 0;
      for (int i = 0; i < n; i++) {
        s += xData[i][j] * xData[i][j];
      }
      normCols[j] = s;
    }

    double lambda1 = alpha * l1Ratio;
    double lambda2 = alpha * (1 - l1Ratio);

    for (int iter = 0; iter < maxIter; iter++) {
      double maxShift = 0.0;

      for (int j = 0; j < pTotal; j++) {
        // Calculate partial residual (y - y_pred_without_j)
        // r_i = y_i - sum_{k!=j} x_ik * beta_k
        //     = (y_i - y_pred) + x_ij * beta_j

        // Recomputing predictions every step is slow O(np), doing partial update O(n)
        double rho = 0.0;
        for (int i = 0; i < n; i++) {
          // Calculate prediction
          double pred = 0;
          for (int k = 0; k < pTotal; k++) {
            pred += xData[i][k] * beta[k];
          }
          double rI = yList[i] - pred + xData[i][j] * beta[j];
          rho += xData[i][j] * rI;
        }

        // Soft thresholding
        double oldBeta = beta[j];
        if (j == 0) {
          // Do not penalize intercept
          beta[j] = rho / normCols[j];
        } else {
          double denom =
              normCols[j] + lambda2; // Include L2 penalty in denominator
          // Simple Coordinate Descent for Elastic Net:
          // beta_j = S(rho, lambda1) / (sum(x_ij^2) + lambda2)
          if (rho > lambda1) {
            beta[j] = (rho - lambda1) / denom;
          } else if (rho < -lambda1) {
            beta[j] = (rho + lambda1) / denom;
          } else {
            beta[j] = 0.0;
          }
        }

        double shift = (beta[j] - oldBeta).abs();
        if (shift > maxShift) maxShift = shift;
      }

      if (maxShift < tol) break;
    }

    // Prepare result
    List<num> predictions = [];
    for (int i = 0; i < n; i++) {
      double pred = 0;
      for (int j = 0; j < pTotal; j++) {
        pred += beta[j] * xData[i][j];
      }
      predictions.add(pred);
    }

    List<num> residuals = [];
    for (int i = 0; i < n; i++) {
      residuals.add(yList[i] - predictions[i]);
    }

    // R2
    num yMean = yList.reduce((a, b) => a + b) / n;
    num ssTot =
        yList.map((yi) => (yi - yMean) * (yi - yMean)).reduce((a, b) => a + b);
    num ssRes = residuals.map((r) => r * r).reduce((a, b) => a + b);
    num rSquared = 1 - ssRes / ssTot;

    return RegressionResult(
      coefficients: Series(beta, name: 'coefficients'),
      rSquared: rSquared,
      residuals: Series(residuals, name: 'residuals'),
      predictions: Series(predictions, name: 'predictions'),
    );
  }

  static num _sigmoid(num z) {
    return 1 / (1 + math.exp(-z));
  }
}
