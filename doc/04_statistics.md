# Statistics Module

Statistical analysis including distributions, hypothesis testing, regression, and time series analysis.

---

## Table of Contents

1. [Distributions](#distributions)
2. [Hypothesis Testing](#hypothesis-testing)
3. [Non-Parametric Statistics](#non-parametric-statistics)
4. [Correlation](#correlation)
5. [Regression](#regression)
6. [Multivariate Analysis](#multivariate-analysis)
7. [Density Estimation](#density-estimation)
8. [Time Series](#time-series)

---

## Distributions

### Continuous Distributions

#### Normal Distribution

```dart
import 'package:advance_math/advance_math.dart';

// Standard normal (mean=0, std=1)
var standard = NormalDistribution(0, 1);

// Custom normal distribution
var dist = NormalDistribution(10, 2);  // mean=10, std=2

// Properties
print('Mean: ${dist.mean()}');           // 10
print('Variance: ${dist.variance()}');   // 4
print('Std Dev: ${dist.stdDev()}');      // 2

// PDF (Probability Density Function)
print('PDF at 10: ${dist.pdf(10)}');     // Maximum at mean

// CDF (Cumulative Distribution Function)
print('CDF at 10: ${dist.cdf(10)}');     // 0.5 at mean

// Quantile (inverse CDF)
print('Quantile(0.5): ${dist.quantile(0.5)}');  // Returns mean

// Generate random samples
var samples = dist.samples(1000);
num sampleMean = samples.reduce((a, b) => a + b) / samples.length;
print('Sample mean: $sampleMean');  // ≈ 10
```

#### Uniform Distribution

```dart
var dist = UniformDistribution(0, 10);  // [0, 10)

print('Mean: ${dist.mean()}');           // 5
print('Variance: ${dist.variance()}');   // 100/12 ≈ 8.33

print('PDF at 5: ${dist.pdf(5)}');       // 0.1
print('PDF at -1: ${dist.pdf(-1)}');     // 0 (outside range)

print('CDF at 5: ${dist.cdf(5)}');       // 0.5
print('Quantile(0.5): ${dist.quantile(0.5)}');  // 5
```

#### Exponential Distribution

```dart
var dist = ExponentialDistribution(2);  // rate = 2

print('Mean: ${dist.mean()}');           // 0.5 (1/rate)
print('Variance: ${dist.variance()}');   // 0.25 (1/rate²)

print('PDF at 0: ${dist.pdf(0)}');       // 2 (rate)
print('CDF at 10: ${dist.cdf(10)}');     // ≈ 1.0
```

#### Other Continuous Distributions

```dart
// Gamma distribution (shape=2, scale=2)
var gamma = GammaDistribution(2, 2);
print('Mean: ${gamma.mean()}');          // 4 (shape * scale)
print('Variance: ${gamma.variance()}');  // 8 (shape * scale²)

// Chi-squared distribution (df=5)
var chi2 = ChiSquaredDistribution(5);
print('Mean: ${chi2.mean()}');           // 5 (df)
print('Variance: ${chi2.variance()}');   // 10 (2*df)

// Student's t-distribution (df=10)
var tDist = StudentTDistribution(10);
print('Mean: ${tDist.mean()}');          // 0
print('Variance: ${tDist.variance()}');  // 10/8 = 1.25

// Log-normal distribution (mu=0, sigma=1)
var logNorm = LogNormalDistribution(0, 1);
print('Mean: ${logNorm.mean()}');        // exp(0.5) ≈ 1.65
```

### Discrete Distributions

#### Binomial Distribution

```dart
var dist = BinomialDistribution(10, 0.5);  // n=10, p=0.5

print('Mean: ${dist.mean()}');           // 5 (n*p)
print('Variance: ${dist.variance()}');   // 2.5 (n*p*(1-p))

print('PDF at 5: ${dist.pdf(5)}');       // Probability of exactly 5 successes
print('CDF at 10: ${dist.cdf(10)}');     // 1.0

// Generate samples
var samples = dist.samples(1000);
num sampleMean = samples.reduce((a, b) => a + b) / samples.length;
print('Sample mean: $sampleMean');       // ≈ 5
```

#### Poisson Distribution

```dart
var dist = PoissonDistribution(5);  // lambda = 5

print('Mean: ${dist.mean()}');           // 5
print('Variance: ${dist.variance()}');   // 5

print('PDF at 0: ${dist.pdf(0)}');       // exp(-5) ≈ 0.0067
print('PDF at -1: ${dist.pdf(-1)}');     // 0 (negative values)
```

#### Geometric Distribution

```dart
var dist = GeometricDistribution(0.5);  // p = 0.5

print('Mean: ${dist.mean()}');           // 2 (1/p)
print('Variance: ${dist.variance()}');   // 2 ((1-p)/p²)

print('PDF at 1: ${dist.pdf(1)}');       // 0.5
print('PDF at 2: ${dist.pdf(2)}');       // 0.25
```

#### Negative Binomial Distribution

```dart
var dist = NegativeBinomialDistribution(3, 0.5);  // r=3, p=0.5

print('Mean: ${dist.mean()}');           // 3 (r*(1-p)/p)

var samples = dist.samples(500);
num sampleMean = samples.reduce((a, b) => a + b) / samples.length;
print('Sample mean: $sampleMean');       // ≈ 3
```

---

## Hypothesis Testing

### Two-Sample t-Test

```dart
// Compare means of two samples
List<num> sample1 = [4.5, 5.0, 5.5, 4.8, 5.2, 4.9, 5.1];  // mean ≈ 5
List<num> sample2 = [6.8, 7.2, 7.0, 6.9, 7.1, 7.3, 6.7];  // mean ≈ 7

var result = HypothesisTesting.tTest(sample1, sample2);

print('Test: ${result.testName}');       // "Two-sample t-test"
print('Statistic: ${result.statistic}'); // t-value
print('P-value: ${result.pValue}');      // e.g., 0.0001
print('Reject H0: ${result.reject}');    // true (α=0.05)
```

### One-Sample t-Test

```dart
// Test if sample mean equals hypothesized value
List<num> sample = [4.5, 5.0, 5.5, 4.8, 5.2, 4.9, 5.1, 5.0];
num mu0 = 10;  // Hypothesized mean

var result = HypothesisTesting.tTestOneSample(sample, mu0);

print('Test: ${result.testName}');       // "One-sample t-test"
print('Reject H0: ${result.reject}');    // true
print('P-value: ${result.pValue}');      // < 0.05
```

### Z-Test

```dart
// When population standard deviation is known
List<num> sample = [98, 102, 99, 101, 100, 103, 97, 101];
num mu0 = 95;   // Hypothesized mean
num sigma = 5;  // Known population std dev

var result = HypothesisTesting.zTest(sample, mu0, sigma);

print('Test: ${result.testName}');       // "Z-test"
print('Reject H0: ${result.reject}');    // true
```

### Chi-Square Test

```dart
// Goodness-of-fit test (is a die fair?)
List<num> observed = [12, 8, 11, 10, 9, 10];  // Rolled 60 times
List<num> expected = [10, 10, 10, 10, 10, 10]; // Expected if fair

var result = HypothesisTesting.chiSquareTest(observed, expected);

print('Test: ${result.testName}');       // "Chi-square test"
print('Statistic: ${result.statistic}'); // Chi-square value
print('DF: ${result.degreesOfFreedom}'); // 5
print('Reject H0: ${result.reject}');    // false (values close to expected)
```

### ANOVA (Analysis of Variance)

```dart
// Compare means of multiple groups
List<num> group1 = [5.0, 5.2, 4.8, 5.1, 4.9];  // mean ≈ 5
List<num> group2 = [7.0, 7.2, 6.8, 7.1, 6.9];  // mean ≈ 7
List<num> group3 = [9.0, 9.2, 8.8, 9.1, 8.9];  // mean ≈ 9

var result = HypothesisTesting.anovaTest([group1, group2, group3]);

print('Test: ${result.testName}');       // "One-way ANOVA"
print('F-statistic: ${result.statistic}');
print('P-value: ${result.pValue}');      // < 0.05
print('Reject H0: ${result.reject}');    // true (means differ)
```

---

## Non-Parametric Statistics

Methods for statistical analysis that do not assume a specific distribution (e.g., normal) for the data.

### Mann-Whitney U Test

Tests whether two independent samples come from the same distribution. Alternative to independent t-test.

```dart
List<num> sample1 = [12, 11, 15, 13, 16];
List<num> sample2 = [18, 17, 20, 19, 21];

var result = NonParametric.mannWhitneyU(sample1, sample2);

print('U-statistic: ${result.statistic}');
print('P-value: ${result.pValue}');
```

### Wilcoxon Signed-Rank Test

Tests whether two paired samples come from the same distribution. Alternative to paired t-test.

```dart
List<num> before = [10, 15, 20, 25, 30];
List<num> after = [12, 14, 22, 24, 32];

var result = NonParametric.wilcoxonSignedRank(before, after);

print('W-statistic: ${result.statistic}');
print('P-value: ${result.pValue}');
```

### Kruskal-Wallis H Test

Tests whether multiple independent samples come from the same distribution. Non-parametric alternative to ANOVA.

```dart
List<num> group1 = [10, 12, 14];
List<num> group2 = [20, 22, 24];
List<num> group3 = [30, 32, 34];

var result = NonParametric.kruskalWallis([group1, group2, group3]);

print('H-statistic: ${result.statistic}');
print('P-value: ${result.pValue}');
```

---

## Correlation

Measures the statistical relationship between two variables.

### Pearson, Spearman, and Kendall

```dart
List<num> x = [1, 2, 3, 4, 5];
List<num> y = [2, 4, 5, 4, 5];

// Pearson (Linear correlation)
print('Pearson: ${Correlation.pearson(x, y)}');

// Spearman (Rank correlation)
print('Spearman: ${Correlation.spearman(x, y)}');

// Kendall (Tau rank correlation)
print('Kendall: ${Correlation.kendall(x, y)}');
```

---

## Regression

### Simple Linear Regression

```dart
List<num> x = [1, 2, 3, 4, 5];
List<num> y = [2, 4, 6, 8, 10];  // Perfect line: y = 2x

var result = Regression.linear(x, y);

print('Intercept: ${result.coefficients[0]}');  // ≈ 0
print('Slope: ${result.coefficients[1]}');      // ≈ 2
print('R²: ${result.rSquared}');                // 1.0 (perfect fit)

// Predict
print('Prediction for x=6: ${result.predict([6])}');  // 12
```

### Multiple Linear Regression

```dart
Matrix X = Matrix([
  [1.0, 1.0],
  [2.0, 2.0],
  [3.0, 1.0],
  [4.0, 4.0],
]);
List<num> y = [3, 5, 5, 9];

var result = Regression.multipleLinear(X, y);

print('Coefficients: ${result.coefficients}');  // [intercept, b1, b2]
print('R²: ${result.rSquared}');                // > 0.9
```

### Polynomial Regression

```dart
List<num> x = [1, 2, 3, 4, 5];
List<num> y = [1, 4, 9, 16, 25];  // y = x²

var result = Regression.polynomial(x, y, 2);  // degree = 2

print('R²: ${result.rSquared}');               // > 0.99
print('x² coefficient: ${result.coefficients[2]}');  // ≈ 1
```

### Ridge Regression

```dart
Matrix X = Matrix([
  [1.0, 2.0],
  [2.0, 3.0],
  [3.0, 4.0],
  [4.0, 5.0],
]);
List<num> y = [3, 5, 7, 9];

var result = Regression.ridge(X, y, alpha: 0.1);  // L2 regularization

print('Coefficients: ${result.coefficients}');
print('R²: ${result.rSquared}');
```

### Logistic Regression

```dart
Matrix X = Matrix([
  [1.0], [2.0], [3.0], [4.0], [5.0], [6.0],
]);
List<num> y = [0, 0, 0, 1, 1, 1];  // Binary labels

var result = Regression.logistic(X, y, maxIter: 1000, learningRate: 0.1);

print('Coefficients: ${result.coefficients}');

// Predictions are probabilities between 0 and 1
print('Predictions: ${result.predictions}');
print('First prediction (low x): ${result.predictions[0]}');  // < 0.5
print('Last prediction (high x): ${result.predictions.last}'); // > 0.5
```

### Lasso Regression

Linear regression with L1 regularization (promotes sparsity).

```dart
Matrix X = Matrix([
  [1.0, 1.0], [2.0, 2.0], [3.0, 3.0]
]);
List<num> y = [2.0, 4.0, 6.0];

// alpha controls regularization strength
var lasso = Regression.lasso(X, y, alpha: 0.1);
print('Coefficients: ${lasso.coefficients}');
```

### Elastic Net Regression

Linear regression with combined L1 and L2 regularization.

```dart
Matrix X = Matrix([
  [1.0, 1.0], [2.0, 2.0], [3.0, 3.0]
]);
List<num> y = [2.0, 4.0, 6.0];

// alpha = overall strength, l1Ratio = balance between L1 and L2
var elastic = Regression.elasticNet(X, y, alpha: 0.1, l1Ratio: 0.5);
print('Coefficients: ${elastic.coefficients}');
```

---

## Multivariate Analysis

### Principal Component Analysis (PCA)

Dimensionality reduction technique.

```dart
Matrix data = Matrix([
  [2.5, 2.4], [0.5, 0.7], [2.2, 2.9],
  [1.9, 2.2], [3.1, 3.0], [2.3, 2.7],
  [2.0, 1.6], [1.0, 1.1], [1.5, 1.6],
  [1.1, 0.9]
]);

var pca = Multivariate.pca(data);

print('Explained Variance: ${pca['explainedVarianceRatio']}');
print('Components: ${pca['components']}');
```

### K-Means Clustering

Partitioning data into k clusters.

```dart
Matrix data = Matrix([
  [1.0, 1.0], [1.5, 2.0], [5.0, 5.0], [3.0, 4.0], [1.1, 1.2], [4.5, 5.0]
]);

// Cluster into 2 groups
var kmeans = Multivariate.kMeans(data, 2, maxIter: 10);

print('Centroids: ${kmeans['centroids']}');
print('Labels: ${kmeans['labels']}');
print('Inertia: ${kmeans['inertia']}');
```

---

## Density Estimation

### Kernel Density Estimation (KDE)

Non-parametric way to estimate the probability density function of a random variable.

```dart
List<num> samples = [1.0, 1.1, 1.2, 5.0, 5.1, 5.2];
var kde = KDE(samples); // Default Gaussian kernel, Silverman bandwidth

print('PDF at 1.0: ${kde.pdf(1.0)}');
print('PDF at 3.0: ${kde.pdf(3.0)}'); // Lower density between clusters
```

---

## Time Series

### Smoothing

#### Moving Average

```dart
List<num> data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
var ma = TimeSeries.movingAverage(data, 3);  // window = 3

print(ma[0]);        // 2 = (1+2+3)/3
print(ma[1]);        // 3 = (2+3+4)/3
print(ma.length);    // 8 = 10 - 3 + 1
```

#### Exponential Smoothing

```dart
List<num> data = [10, 12, 11, 13, 12, 14];
var smoothed = TimeSeries.exponentialSmoothing(data, 0.5);  // alpha = 0.5

print(smoothed[0]);  // 10 (first value unchanged)
print(smoothed[1]);  // 11 = 0.5*12 + 0.5*10
```

#### Double Exponential Smoothing (Holt's Method)

```dart
List<num> data = [10, 12, 14, 16, 18, 20];  // Trending data
var smoothed = TimeSeries.doubleExponentialSmoothing(data, 0.6, 0.3);

print(smoothed.length);  // Same as input
// Captures trend: last > first
print('${smoothed.last} > ${smoothed.first}');
```

### Autocorrelation

```dart
List<num> data = [1, 2, 3, 4, 5];

// Autocovariance at lag 0 = variance
num acov0 = TimeSeries.autocovariance(data, 0);

// Autocorrelation at lag 0 = 1
num ac0 = TimeSeries.autocorrelation(data, 0);  // 1.0

// ACF function (multiple lags)
var acfValues = TimeSeries.acf(data, 3);  // lags 0-3
print(acfValues[0]);  // 1.0 (lag 0)

// PACF function
var pacfValues = TimeSeries.pacf(data, 3);
print(pacfValues[0]);  // 1.0 (lag 0)
```

### Decomposition

```dart
// Create data with trend and seasonality
List<num> data = [];
for (int i = 0; i < 24; i++) {
  num trend = i * 2.0;
  num seasonal = sin(i * 2 * pi / 12) * 5;
  num noise = (i % 2 == 0) ? 0.5 : -0.5;
  data.add(trend + seasonal + noise);
}

var decomp = TimeSeries.decompose(data, 12);  // period = 12

print('Trend length: ${decomp.trend.length}');      // 24
print('Seasonal length: ${decomp.seasonal.length}'); // 24
print('Residual length: ${decomp.residual.length}'); // 24

// Trend should be increasing
print('Trend increases: ${decomp.trend.last > decomp.trend.first}');

// Seasonal repeats
print('Seasonal[0] ≈ Seasonal[12]: ${decomp.seasonal[0]} ≈ ${decomp.seasonal[12]}');

// Additive: data ≈ trend + seasonal + residual
for (int i = 0; i < data.length; i++) {
  num reconstructed = decomp.trend[i] + decomp.seasonal[i] + decomp.residual[i];
  print('Original: ${data[i]}, Reconstructed: $reconstructed');
}
```

### Differencing

```dart
List<num> data = [1, 3, 6, 10, 15];

// First difference
var diff1 = TimeSeries.difference(data);
print(diff1);  // [2, 3, 4, 5]

// Second difference
var diff2 = TimeSeries.difference(diff1);
print(diff2);  // [1, 1, 1] (constant = quadratic trend)
```

---

## Related Tests

- [`test/statistics/`](../test/statistics/) - Statistical analysis tests

## Related Documentation

- [Basic Math](02_basic_math.md) - Core math functions
- [Algebra](01_algebra.md) - Matrix operations for regression
- [Numbers](05_numbers.md) - Decimal precision for calculations
