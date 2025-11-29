# Statistics & Data Analysis

Comprehensive statistical analysis, hypothesis testing, regression, and time series analysis.

## Table of Contents

- [Descriptive Statistics](#descriptive-statistics)
- [Probability Distributions](#probability-distributions)
- [Hypothesis Testing](#hypothesis-testing)
- [Regression Analysis](#regression-analysis)
- [Time Series Analysis](#time-series-analysis)
- [Examples](#examples)

## Descriptive Statistics

Compute basic statistical measures:

```dart
import 'package:advance_math/src/math/statistics/statistics.dart';

var data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// Central tendency
var mean = Statistics.mean(data);           // 5.5
var median = Statistics.median(data);       // 5.5
var mode = Statistics.mode(data);           // No mode (all unique)

// Dispersion
var variance = Statistics.variance(data);   // 8.25
var stdDev = Statistics.stdDev(data);       // 2.872
var range = Statistics.range(data);         // 9

// Shape
var skewness = Statistics.skewness(data);   // 0.0 (symmetric)
var kurtosis = Statistics.kurtosis(data);   // -1.224

// Quantiles
var q1 = Statistics.quantile(data, 0.25);   // 3.25
var q3 = Statistics.quantile(data, 0.75);   // 7.75
var iqr = Statistics.iqr(data);             // 4.5

// Correlation
var x = [1, 2, 3, 4, 5];
var y = [2, 4, 6, 8, 10];
var corr = Statistics.correlation(x, y);    // 1.0 (perfect positive)
```

## Probability Distributions

### Discrete Distributions

```dart
import 'package:advance_math/src/math/statistics/distributions/discrete.dart';

// Binomial Distribution
var binomial = BinomialDistribution(n: 10, p: 0.5);
print('P(X = 5): ${binomial.pmf(5)}');      // 0.246
print('P(X ≤ 5): ${binomial.cdf(5)}');      // 0.623
print('Mean: ${binomial.mean()}');           // 5.0
print('Variance: ${binomial.variance()}');   // 2.5

// Poisson Distribution
var poisson = PoissonDistribution(lambda: 3.0);
print('P(X = 2): ${poisson.pmf(2)}');       // 0.224
print('P(X ≤ 2): ${poisson.cdf(2)}');       // 0.423

// Geometric Distribution
var geometric = GeometricDistribution(p: 0.3);
print('P(X = 5): ${geometric.pmf(5)}');     // First success on 5th trial
```

### Continuous Distributions

```dart
import 'package:advance_math/src/math/statistics/distributions/continuous.dart';

// Normal (Gaussian) Distribution
var normal = NormalDistribution(mu: 0, sigma: 1);
print('P(X ≤ 0): ${normal.cdf(0)}');        // 0.5
print('P(X ≤ 1.96): ${normal.cdf(1.96)}');  // 0.975 (95% confidence)
print('PDF at 0: ${normal.pdf(0)}');         // 0.3989

// Exponential Distribution
var exponential = ExponentialDistribution(lambda: 0.5);
print('P(X ≤ 2): ${exponential.cdf(2)}');   // 0.632

// Uniform Distribution
var uniform = UniformDistribution(a: 0, b: 10);
print('P(X ≤ 5): ${uniform.cdf(5)}');       // 0.5

// Chi-Square Distribution
var chiSquare = ChiSquareDistribution(df: 5);
print('P(X ≤ 5): ${chiSquare.cdf(5)}');
```

## Hypothesis Testing

```dart
import 'package:advance_math/src/math/statistics/hypothesis_testing.dart';

// One-sample t-test
var sample = [23, 25, 27, 22, 24, 26, 25, 23, 24, 25];
var tTest = HypothesisTesting.tTestOneSample(
  sample,
  populationMean: 25,
  alpha: 0.05
);

print('t-statistic: ${tTest.statistic}');
print('p-value: ${tTest.pValue}');
print('Reject H0: ${tTest.rejectNull}');
print('95% CI: ${tTest.confidenceInterval}');

// Two-sample t-test
var sample1 = [23, 25, 27, 22, 24];
var sample2 = [28, 30, 29, 27, 31];
var tTest2 = HypothesisTesting.tTestTwoSample(
  sample1,
  sample2,
  alpha: 0.05
);

// Paired t-test
var before = [120, 125, 130, 128, 135];
var after = [115, 122, 125, 120, 130];
var pairedTest = HypothesisTesting.tTestPaired(
  before,
  after,
  alpha: 0.05
);

// Chi-square test for independence
var observed = [
  [10, 20, 30],
  [25, 35, 40],
];
var chiTest = HypothesisTesting.chiSquareTest(
  observed,
  alpha: 0.05
);

// ANOVA (Analysis of Variance)
var groups = [
  [23, 25, 27],
  [30, 32, 35],
  [28, 29, 31],
];
var anova = HypothesisTesting.anova(groups, alpha: 0.05);
print('F-statistic: ${anova.statistic}');
```

## Regression Analysis

### Simple Linear Regression

```dart
import 'package:advance_math/src/math/statistics/regression.dart';

var x = [1, 2, 3, 4, 5];
var y = [2, 4, 5, 4, 5];

var model = Regression.linear(x, y);

print('Slope: ${model.coefficients[0]}');        // β₁
print('Intercept: ${model.coefficients[1]}');    // β₀
print('R²: ${model.rSquared}');                  // Goodness of fit
print('Predictions: ${model.predictions}');

// Predict new value
var prediction = model.predict([6]);  // Predict y when x = 6
```

### Multiple Linear Regression

```dart
// Y = β₀ + β₁X₁ + β₂X₂ + ... + error
var X = [
  [1, 2],
  [2, 3],
  [3, 3],
  [4, 5],
  [5, 6],
];
var y = [5, 7, 9, 11, 13];

var model = Regression.multipleLinear(Matrix(X), y);

print('Coefficients: ${model.coefficients}');
print('R²: ${model.rSquared}');

// Predict
var newPoint = Matrix([[6, 7]]);
var prediction = model.predict(newPoint);
```

### Polynomial Regression

```dart
var x = [1, 2, 3, 4, 5];
var y = [1, 4, 9, 16, 25]; // Quadratic relationship

// Fit polynomial of degree 2
var model = Regression.polynomial(x, y, degree: 2);

print('Coefficients: ${model.coefficients}');
print('R²: ${model.rSquared}');
```

### Ridge Regression (L2 Regularization)

```dart
var X = Matrix([[1, 2], [2, 3], [3, 4], [4, 5]]);
var y = [3, 5, 7, 9];

var model = Regression.ridge(X, y, alpha: 0.1);
print('Coefficients: ${model.coefficients}');
```

### Logistic Regression

```dart
var X = Matrix([[1, 2], [2, 3], [3, 3], [4, 5]]);
var y = [0, 0, 1, 1]; // Binary classification

var model = Regression.logistic(X, y);

print('Coefficients: ${model.coefficients}');
print('Predictions: ${model.predictions}');

// Predict probability
var prob = model.predictProba(Matrix([[5, 6]]));
```

## Time Series Analysis

```dart
import 'package:advance_math/src/math/statistics/time_series.dart';

var data = [10, 12, 13, 15, 14, 16, 18, 20, 19, 21];

// Moving average
var ma = TimeSeries.movingAverage(data, window: 3);
print('Moving Average: $ma');

// Exponential smoothing
var es = TimeSeries.exponentialSmoothing(data, alpha: 0.3);
print('Exponential Smoothing: $es');

// Autocorrelation
var acf = TimeSeries.autocorrelation(data, lag: 5);
print('ACF: $acf');

// Trend detection
var trend = TimeSeries.linearTrend(data);
print('Trend slope: ${trend.slope}');
print('Detrended: ${trend.detrended}');

// Seasonality decomposition
var seasonal = TimeSeries.seasonalDecompose(
  data,
  period: 4,  // Quarterly
);
print('Trend: ${seasonal.trend}');
print('Seasonal: ${seasonal.seasonal}');
print('Residual: ${seasonal.residual}');
```

## Regression Result Structure

```dart
class RegressionResult {
  final List<num> coefficients;
  final num rSquared;
  final List<num> predictions;
  final List<num> residuals;

  num predict(List<num> x) { ... }
  num predictProba(Matrix X) { ... } // For logistic regression
}
```

## Hypothesis Test Result

```dart
class HypothesisTestResult {
  final num statistic;    // Test statistic (t, F, χ², etc.)
  final num pValue;       // Probability
  final bool rejectNull;  // Decision at α level
  final List<num>? confidenceInterval;
  final String? message;
}
```

## Examples

### Complete Statistical Analysis

```dart
import 'package:advance_math/src/math/statistics/statistics.dart';
import 'package:advance_math/src/math/statistics/hypothesis_testing.dart';
import 'package:advance_math/src/math/statistics/regression.dart';

void main() {
  // Sample data: exam scores
  var scores = [75, 82, 90, 68, 95, 88, 76, 84, 91, 79];

  // Descriptive statistics
  print('Mean: ${Statistics.mean(scores)}');
  print('Std Dev: ${Statistics.stdDev(scores)}');

  // Test if mean = 80
  var tTest = HypothesisTesting.tTestOneSample(
    scores,
    populationMean: 80,
    alpha: 0.05
  );
  print('p-value: ${tTest.pValue}');
  print('Reject H0 (mean ≠ 80): ${tTest.rejectNull}');

  // Regression: hours studied vs score
  var hoursStudied = [2, 3, 5, 1, 6, 4, 2, 4, 5, 3];
  var model = Regression.linear(hoursStudied, scores);
  print('Each hour increases score by: ${model.coefficients[0]}');
  print('R² = ${model.rSquared}');

  // Predict score for 7 hours of study
  print('Predicted score: ${model.predict([7])}');
}
```

## Related Tests

- [`test/statistics/statistics_test.dart`](../test/statistics/statistics_test.dart)
- [`test/statistics/distributions_test.dart`](../test/statistics/distributions_test.dart)
- [`test/statistics/hypothesis_testing_test.dart`](../test/statistics/hypothesis_testing_test.dart)
- [`test/statistics/regression_test.dart`](../test/statistics/regression_test.dart)
- [`test/statistics/time_series_test.dart`](../test/statistics/time_series_test.dart)

## Related Documentation

- [Mathematics](math.md) - Basic mathematical functions
- [Algebra](algebra.md) - Matrix operations for linear algebra
- [Calculus](calculus.md) - Differentiation and integration
