import '../algebra/algebra.dart';
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

/// Result of a regression analysis.
class RegressionResult {
  /// Regression coefficients (including intercept as first element).
  final List<num> coefficients;

  /// R-squared value.
  final num rSquared;

  /// Adjusted R-squared value.
  final num? adjustedRSquared;

  /// Residuals.
  final List<num> residuals;

  /// Predicted values.
  final List<num> predictions;

  /// Standard errors of coefficients.
  final List<num>? standardErrors;

  /// P-values for coefficients.
  final List<num>? pValues;

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
  num predict(List<num> x) {
    if (x.length != coefficients.length - 1) {
      throw ArgumentError('Input dimension mismatch');
    }

    num result = coefficients[0]; // Intercept
    for (int i = 0; i < x.length; i++) {
      result += coefficients[i + 1] * x[i];
    }
    return result;
  }

  @override
  String toString() {
    return 'RegressionResult(R²=$rSquared, coefficients=$coefficients)';
  }
}

/// Regression analysis methods.
class Regression {
  /// Simple linear regression (y = a + bx).
  static RegressionResult linear(List<num> x, List<num> y) {
    if (x.length != y.length || x.isEmpty) {
      throw ArgumentError('x and y must have same non-zero length');
    }

    int n = x.length;
    num sumX = x.reduce((a, b) => a + b);
    num sumY = y.reduce((a, b) => a + b);
    num sumXY = 0, sumX2 = 0;

    for (int i = 0; i < n; i++) {
      sumXY += x[i] * y[i];
      sumX2 += x[i] * x[i];
    }

    num slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    num intercept = (sumY - slope * sumX) / n;

    // Calculate predictions and residuals
    List<num> predictions = x.map((xi) => intercept + slope * xi).toList();
    List<num> residuals = [];
    for (int i = 0; i < n; i++) {
      residuals.add(y[i] - predictions[i]);
    }

    // Calculate R-squared
    num yMean = sumY / n;
    num ssTot =
        y.map((yi) => (yi - yMean) * (yi - yMean)).reduce((a, b) => a + b);
    num ssRes = residuals.map((r) => r * r).reduce((a, b) => a + b);
    num rSquared = 1 - ssRes / ssTot;

    return RegressionResult(
      coefficients: [intercept, slope],
      rSquared: rSquared,
      adjustedRSquared: 1 - (1 - rSquared) * (n - 1) / (n - 2),
      residuals: residuals,
      predictions: predictions,
    );
  }

  /// Multiple linear regression.
  static RegressionResult multipleLinear(Matrix X, List<num> y) {
    int n = X.rowCount;
    int p = X.columnCount;

    if (y.length != n) {
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
    Matrix yMat = Matrix(y.map((e) => [e.toDouble()]).toList());

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
      residuals.add(y[i] - predictions[i]);
    }

    num yMean = y.reduce((a, b) => a + b) / n;
    num ssTot =
        y.map((yi) => (yi - yMean) * (yi - yMean)).reduce((a, b) => a + b);
    num ssRes = residuals.map((r) => r * r).reduce((a, b) => a + b);
    num rSquared = 1 - ssRes / ssTot;
    num adjRSquared = 1 - (1 - rSquared) * (n - 1) / (n - p - 1);

    return RegressionResult(
      coefficients: coefficients,
      rSquared: rSquared,
      adjustedRSquared: adjRSquared,
      residuals: residuals,
      predictions: predictions,
    );
  }

  /// Polynomial regression.
  static RegressionResult polynomial(List<num> x, List<num> y, int degree) {
    if (degree < 1) {
      throw ArgumentError('degree must be at least 1');
    }

    // Generate polynomial features
    int n = x.length;
    List<List<double>> xPoly = [];
    for (int i = 0; i < n; i++) {
      List<double> row = [];
      for (int d = 1; d <= degree; d++) {
        row.add(math.pow(x[i], d).toDouble());
      }
      xPoly.add(row);
    }

    Matrix xMat = Matrix(xPoly);
    return multipleLinear(xMat, y);
  }

  /// Ridge regression (L2 regularization).
  static RegressionResult ridge(Matrix X, List<num> y, {double alpha = 1.0}) {
    int n = X.rowCount;
    int p = X.columnCount;

    if (y.length != n) {
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
    Matrix yMat = Matrix(y.map((e) => [e.toDouble()]).toList());

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
      residuals.add(y[i] - predictions[i]);
    }

    num yMean = y.reduce((a, b) => a + b) / n;
    num ssTot =
        y.map((yi) => (yi - yMean) * (yi - yMean)).reduce((a, b) => a + b);
    num ssRes = residuals.map((r) => r * r).reduce((a, b) => a + b);
    num rSquared = 1 - ssRes / ssTot;

    return RegressionResult(
      coefficients: coefficients,
      rSquared: rSquared,
      adjustedRSquared: 1 - (1 - rSquared) * (n - 1) / (n - p - 1),
      residuals: residuals,
      predictions: predictions,
    );
  }

  /// Logistic regression for binary classification.
  static RegressionResult logistic(
    Matrix X,
    List<num> y, {
    int maxIter = 100,
    double learningRate = 0.01,
  }) {
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
        num error = predictions[i] - y[i];
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
      residuals.add(y[i] - predictions[i]);
    }

    // Calculate pseudo R-squared (McFadden's)
    num yMean = y.reduce((a, b) => a + b) / n;
    num nullDeviance = 0;
    for (int i = 0; i < n; i++) {
      if (y[i] == 1) {
        nullDeviance -= 2 * math.log(yMean);
      } else {
        nullDeviance -= 2 * math.log(1 - yMean);
      }
    }

    num residualDeviance = 0;
    for (int i = 0; i < n; i++) {
      num p = predictions[i].clamp(1e-10, 1 - 1e-10);
      if (y[i] == 1) {
        residualDeviance -= 2 * math.log(p);
      } else {
        residualDeviance -= 2 * math.log(1 - p);
      }
    }

    num pseudoR2 = 1 - residualDeviance / nullDeviance;

    return RegressionResult(
      coefficients: coefficients,
      rSquared: pseudoR2,
      residuals: residuals,
      predictions: predictions,
    );
  }

  static num _sigmoid(num z) {
    return 1 / (1 + math.exp(-z));
  }
}
