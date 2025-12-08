import 'package:dartframe/dartframe.dart';
import '../algebra/algebra.dart';
import 'regression.dart';
import 'time_series.dart';
import 'hypothesis_testing.dart';
import 'series_stats.dart';
import 'dart:math' as math;

/// Statistical extensions for DataFrame.
extension DataFrameStats on DataFrame {
  /// Helper to get a numeric column as `List<num>`.
  /// Returns a clean list of numbers (converting from dynamic if needed).
  List<num> _getCol(String name) {
    if (!columns.contains(name)) {
      throw ArgumentError("Column '$name' not found in DataFrame");
    }

    // DataFrame columns are Series, which we can convert to list
    final List<dynamic> raw = this[name]!.toList();

    // Convert to num, throwing if any value is not convertible
    return raw.map((e) {
      if (e is num) return e;
      if (e is String) return num.parse(e);
      throw FormatException("Value '$e' in column '$name' is not a number");
    }).toList();
  }

  /// Helper to construct a Matrix from a list of column names.
  Matrix _getMatrix(List<String> xCols) {
    // Collect data by column first
    List<List<num>> colsData = xCols.map((col) => _getCol(col)).toList();

    if (colsData.isEmpty) throw ArgumentError("No columns provided");

    int rows = colsData[0].length;
    // Transpose to rows (List<List<double>>)
    List<List<double>> matrixData = [];

    for (int i = 0; i < rows; i++) {
      List<double> row = [];
      for (int j = 0; j < colsData.length; j++) {
        row.add(colsData[j][i].toDouble());
      }
      matrixData.add(row);
    }

    return Matrix(matrixData);
  }

  // --- Descriptive Statistics ---

  /// Helper to get a Series.
  Series _getSeries(String name) {
    if (!columns.contains(name)) {
      throw ArgumentError('Column "$name" not found.');
    }
    return this[name];
  }

  /// Calculates the sum of a column.
  num sumColumn(String col) {
    return _getSeries(col).sum();
  }

  /// Calculates the mean of a column.
  double meanColumn(String col) {
    return _getSeries(col).mean();
  }

  /// Calculates the median of a column.
  num medianColumn(String col) {
    return _getSeries(col).median();
  }

  /// Calculates the mode of a column.
  List<num> modeColumn(String col) {
    // Note: Series.mode() returns a single value in recent logic, wrapping.
    // However, if the user API has mode() returning dynamic, we cast.
    final m = _getSeries(col).mode();
    return m != null ? [m] : [];
  }

  /// Calculates the variance of a column.
  double varianceColumn(String col) {
    return _getSeries(col).variance();
  }

  /// Calculates the standard deviation of a column.
  double stdDevColumn(String col) {
    // stdDev is our extension getter alias for std()
    return _getSeries(col).stdDev;
  }

  /// Minimum value in a column.
  num minColumn(String col) {
    return _getSeries(col).min();
  }

  /// Maximum value in a column.
  num maxColumn(String col) {
    return _getSeries(col).max();
  }

  /// Calculates the q-th quantile of a column.
  num quantileColumn(String col, double q) {
    if (q < 0 || q > 1) throw ArgumentError('Probability q must be in [0, 1]');
    return _getSeries(col).quantile(q);
  }

  /// Calculates the skewness of a column.
  double skewnessColumn(String col) {
    // skewness is our extension getter alias for skew()
    return _getSeries(col).skewness;
  }

  /// Calculates the kurtosis of a column.
  double kurtosisColumn(String col) {
    return _getSeries(col).kurtosis();
  }

  /// Descriptive statistics for a column.
  Map<String, num> describeColumn(String col) {
    return _getSeries(col).describeStats();
  }

  // --- Correlation & Covariance ---

  /// Covariance between two columns.
  double covariance(String col1, String col2) {
    List<num> x = _getCol(col1);
    List<num> y = _getCol(col2);
    if (x.length != y.length) throw ArgumentError("Column lengths must match");
    if (x.length < 2) return double.nan;

    double mx = meanColumn(col1);
    double my = meanColumn(col2);

    double sum = 0;
    for (int i = 0; i < x.length; i++) {
      sum += (x[i] - mx) * (y[i] - my);
    }

    return sum / (x.length - 1);
  }

  /// Pearson Correlation Coefficient between two columns.
  double correlation(String col1, String col2) {
    double cov = covariance(col1, col2);
    double sx = stdDevColumn(col1);
    double sy = stdDevColumn(col2);
    if (sx == 0 || sy == 0) return double.nan;
    return cov / (sx * sy);
  }

  /// Computes the Correlation Matrix for a list of columns.
  /// Returns a DataFrame.
  DataFrame correlationMatrix(List<String> cols) {
    Map<String, List<double>> data = {};

    for (var col1 in cols) {
      List<double> row = [];
      for (var col2 in cols) {
        row.add(correlation(col1, col2));
      }
      data[col1] = row;
    }

    // Note: DataFrame.fromMap expects map of columns.
    // The loop above constructs what looks like columns if we view keys as headers.
    // However, we want a symmetric matrix where index matches columns.
    // dartframe doesn't have row labels easily accessible in all versions,
    // but we can return the DF where columns are the input cols.
    return DataFrame.fromMap(data);
  }

  /// Computes the Covariance Matrix for a list of columns.
  DataFrame covarianceMatrix(List<String> cols) {
    Map<String, List<double>> data = {};

    for (var col1 in cols) {
      List<double> row = [];
      for (var col2 in cols) {
        row.add(covariance(col1, col2));
      }
      data[col1] = row;
    }
    return DataFrame.fromMap(data);
  }

  // --- Data Preprocessing ---

  /// Normalizes a column (Min-Max Scaling) to `[0, 1]`.
  /// Returns a new `List<num>`.
  List<num> normalizeColumn(String col) {
    List<num> data = _getCol(col);
    if (data.isEmpty) return [];

    num minVal = data.reduce(math.min);
    num maxVal = data.reduce(math.max);
    num range = maxVal - minVal;

    if (range == 0) return List.filled(data.length, 0.0);

    return data.map((x) => (x - minVal) / range).toList();
  }

  /// Standardizes a column (Z-Score Scaling).
  /// Returns a new `List<num>`.
  List<num> standardizeColumn(String col) {
    List<num> data = _getCol(col);
    if (data.isEmpty) return [];

    double m = meanColumn(col);
    double s = stdDevColumn(col);

    if (s == 0) return List.filled(data.length, 0.0);

    return data.map((x) => (x - m) / s).toList();
  }

  // --- Advanced Hypothesis Testing Wrappers ---

  /// Z-test wrapper.
  HypothesisTestResult zTest(String col, num mu0, num sigma) {
    return HypothesisTesting.zTest(_getCol(col), mu0, sigma);
  }

  /// Chi-square goodness-of-fit wrapper using two columns (observed vs expected).
  HypothesisTestResult chiSquareTest(String observedCol, String expectedCol) {
    return HypothesisTesting.chiSquareTest(
        _getCol(observedCol), _getCol(expectedCol));
  }

  // --- Regression ---

  /// Performs simple linear regression on two columns.
  ///
  /// [xCol]: The independent variable column name.
  /// [yCol]: The dependent variable column name.
  RegressionResult linearRegression(String xCol, String yCol) {
    return Regression.linear(_getCol(xCol), _getCol(yCol));
  }

  /// Performs multiple linear regression.
  ///
  /// [xCols]: List of independent variable column names.
  /// [yCol]: Dependent variable column name.
  RegressionResult multipleLinearRegression(List<String> xCols, String yCol) {
    Matrix X = _getMatrix(xCols);
    List<num> y = _getCol(yCol);
    return Regression.multipleLinear(X, y);
  }

  /// Performs polynomial regression.
  ///
  /// [xCol]: Independent variable column name.
  /// [yCol]: Dependent variable column name.
  /// [degree]: Degree of the polynomial.
  RegressionResult polynomialRegression(String xCol, String yCol, int degree) {
    return Regression.polynomial(_getCol(xCol), _getCol(yCol), degree);
  }

  /// Performs logistic regression.
  ///
  /// [xCols]: List of independent variable column names.
  /// [yCol]: Binary dependent variable column name.
  RegressionResult logisticRegression(List<String> xCols, String yCol) {
    Matrix X = _getMatrix(xCols);
    List<num> y = _getCol(yCol);
    return Regression.logistic(X, y);
  }

  // --- Time Series ---

  /// Calculates simple moving average for a column.
  ///
  /// Returns a new Series with the moving average.
  List<num> movingAverage(String col, int window) {
    return TimeSeries.movingAverage(_getCol(col), window)
        .data
        .cast<num>()
        .toList();
  }

  /// Calculates exponential smoothing for a column.
  List<num> exponentialSmoothing(String col, double alpha) {
    return TimeSeries.exponentialSmoothing(_getCol(col), alpha)
        .data
        .cast<num>()
        .toList();
  }

  /// Performs seasonal decomposition on a column.
  SeasonalDecomposition seasonalDecompose(String col, int period,
      {String model = 'additive'}) {
    return TimeSeries.decompose(_getCol(col), period, model: model);
  }

  /// Calculates Autocorrelation for a column at a specific lag.
  num autocorrelation(String col, int lag) {
    return TimeSeries.autocorrelation(_getCol(col), lag);
  }

  // --- Hypothesis Testing ---

  /// Performs a two-sample t-test between two columns.
  HypothesisTestResult tTestPair(String col1, String col2,
      {bool equalVariance = true}) {
    return HypothesisTesting.tTest(_getCol(col1), _getCol(col2),
        equalVariance: equalVariance);
  }

  /// Performs a one-sample t-test on a column against a population mean.
  HypothesisTestResult tTestOneSample(String col, num populationMean) {
    return HypothesisTesting.tTestOneSample(_getCol(col), populationMean);
  }

  /// Performs One-way ANOVA on multiple columns (treating each column as a group).
  HypothesisTestResult anovaOneWay(List<String> groupCols) {
    List<List<num>> groups = groupCols.map((c) => _getCol(c)).toList();
    return HypothesisTesting.anovaTest(groups);
  }
}
