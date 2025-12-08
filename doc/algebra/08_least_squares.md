# Least Squares Module

Least squares fitting and regression with statistical analysis.

---

## Table of Contents

1. [Overview](#overview)
2. [Basic Fitting](#basic-fitting)
3. [Weighted Least Squares](#weighted-least-squares)
4. [Statistical Analysis](#statistical-analysis)
5. [Special Least Squares](#special-least-squares)
6. [Z-Score](#z-score)

---

## Overview

Least squares finds the best fit solution **β** that minimizes ||Aβ - b||².

```dart
import 'package:advance_math/advance_math.dart';

// Design matrix (observations)
Matrix A = Matrix([
  [1, 1],
  [1, 2],
  [1, 3],
  [1, 4]
]);

// Observations
ColumnMatrix b = ColumnMatrix([2, 4, 5, 4]);

// Fit
var ls = BaseLeastSquares(A, b);
ls.fit();

print('Coefficients: ${ls.beta}');
```

---

## Basic Fitting

### Using LinearSystemMethod

```dart
var ls = BaseLeastSquares(A, b, method: EquationMethod.linear);

ls.fit(linear: LinearSystemMethod.leastSquares);
print('β = ${ls.beta}');
```

### Using Decomposition

```dart
var ls = BaseLeastSquares(A, b, method: EquationMethod.decomposition);

ls.fit(decomposition: DecompositionMethod.qr);
print('β = ${ls.beta}');
```

### Prediction

```dart
// Fit the model
var ls = BaseLeastSquares(A, b);
ls.fit();

// Predict new values
Matrix xNew = Matrix([
  [1, 5],
  [1, 6]
]);

Matrix predictions = ls.predict(xNew);
print('Predictions: $predictions');
```

---

## Weighted Least Squares

Use weights when observations have different uncertainties:

```dart
// Observations
Matrix A = Matrix([
  [1, 1],
  [1, 2],
  [1, 3],
  [1, 4]
]);

ColumnMatrix b = ColumnMatrix([2, 4, 5, 4]);

// Weight matrix (diagonal)
DiagonalMatrix W = DiagonalMatrix([1.0, 2.0, 1.0, 0.5]);

var ls = BaseLeastSquares(A, b, W: W);
ls.fit();

print('Weighted β = ${ls.beta}');
```

---

## Statistical Analysis

### Residuals

```dart
var ls = BaseLeastSquares(A, b);
ls.fit();

// Residuals: b - A*β
print('Residuals: ${ls.residuals}');
```

### Unit Variance (MSE)

```dart
// Mean Square Error
var mse = ls.unitVariance();
print('MSE: $mse');
```

### Covariance Matrix

```dart
// Covariance of coefficients
Matrix covCoef = ls.covariance(true);
print('Coefficient covariance: $covCoef');

// Covariance of residuals
Matrix covRes = ls.covariance(false);
print('Residual covariance: $covRes');
```

### Standard Deviation & Error

```dart
// Standard deviation of residuals
var stdDev = ls.standardDeviation();
print('Standard deviation: $stdDev');

// Standard error
var stdErr = ls.standardError();
print('Standard error: $stdErr');
```

### Error Ellipse

For 2D parameter estimation:

```dart
Eigen errorParams = ls.errorEllipse();
print('Eigenvalues (axes): ${errorParams.eigenvalues}');
print('Eigenvectors (orientation): ${errorParams.eigenvectors}');
```

### Confidence Level

```dart
var confidenceLevel = ls.confidenceLevel();
print('Confidence: $confidenceLevel');
```

### Outlier Detection

Using Chauvenet's criterion:

```dart
List<int> outliers = ls.detectOutliers(0.95);
print('Outlier indices: $outliers');
```

---

## Special Least Squares

### Polynomial Fitting

```dart
// Fit polynomial of degree 2: y = a + bx + cx²
List<num> x = [1, 2, 3, 4, 5];
List<num> y = [2, 5, 10, 17, 26];

// Build Vandermonde matrix
Matrix A = Matrix.fromList([
  for (var xi in x)
    [1, xi, xi * xi]
]);

ColumnMatrix b = ColumnMatrix(y);

var ls = BaseLeastSquares(A, b);
ls.fit();

print('Polynomial coefficients: ${ls.beta}');
// [a, b, c] for y = a + bx + cx²
```

### Line Fitting

```dart
// y = a + bx
List<num> x = [1, 2, 3, 4, 5];
List<num> y = [2.1, 3.9, 6.2, 8.0, 9.8];

Matrix A = Matrix.fromList([
  for (var xi in x) [1, xi]
]);

ColumnMatrix b = ColumnMatrix(y);

var ls = BaseLeastSquares(A, b);
ls.fit();

double intercept = ls.beta[0][0];
double slope = ls.beta[1][0];

print('y = $intercept + ${slope}x');
```

### Total Least Squares

When both A and b have errors:

```dart
// Total Least Squares accounts for errors in all variables
var tls = TotalLeastSquares(A, b);
tls.fit();

print('TLS coefficients: ${tls.beta}');
```

---

## Z-Score

Statistical z-score calculations:

```dart
import 'package:advance_math/advance_math.dart';

// Calculate z-score
double value = 85;
double mean = 75;
double stdDev = 10;

double z = ZScore.calculate(value, mean, stdDev);
print('Z-score: $z');  // 1.0

// From z-score to raw score
double rawScore = ZScore.toRawScore(1.0, mean, stdDev);
print('Raw score: $rawScore');  // 85

// Probability (CDF)
double probability = ZScore.probability(z);
print('P(Z < $z): $probability');

// Percentile
double percentile = ZScore.percentile(z);
print('Percentile: $percentile');
```

### Confidence Intervals

```dart
// Calculate confidence interval
double confidence = 0.95;
var interval = ZScore.confidenceInterval(mean, stdDev, 30, confidence);
print('95% CI: [${interval.lower}, ${interval.upper}]');
```

---

## Normal Equation

The normal equation is:

**(AᵀWA)β = AᵀWb**

For standard least squares (W = I):

**(AᵀA)β = Aᵀb**

```dart
var ls = BaseLeastSquares(A, b);

// Get the normal equation matrix (AᵀWA)
Matrix N = ls.normal();
print('Normal matrix: $N');
```

---

## Fitting Methods

| Method                            | Best For                                  |
| --------------------------------- | ----------------------------------------- |
| `LinearSystemMethod.leastSquares` | General least squares                     |
| `LinearSystemMethod.gramSchmidt`  | Better numerical stability                |
| `DecompositionMethod.qr`          | Recommended for least squares             |
| `DecompositionMethod.cholesky`    | Symmetric positive-definite normal matrix |
| `DecompositionMethod.svd`         | Rank-deficient or ill-conditioned         |

---

## Example: Complete Workflow

```dart
import 'package:advance_math/advance_math.dart';

void main() {
  // Survey data: observed coordinates
  Matrix A = Matrix([
    [1, 100],
    [1, 200],
    [1, 300],
    [1, 400],
    [1, 500]
  ]);

  ColumnMatrix b = ColumnMatrix([102.1, 199.8, 301.2, 400.5, 498.7]);

  // Weight matrix (precision weights)
  DiagonalMatrix W = DiagonalMatrix([1, 1, 1, 1, 1]);

  // Fit model
  var ls = BaseLeastSquares(A, b, W: W);
  ls.fit(decomposition: DecompositionMethod.qr);

  // Results
  print('Coefficients: ${ls.beta}');
  print('Residuals: ${ls.residuals}');
  print('Standard deviation: ${ls.standardDeviation()}');
  print('MSE: ${ls.unitVariance()}');

  // Error ellipse for confidence region
  var ellipse = ls.errorEllipse();
  print('Error ellipse eigenvalues: ${ellipse.eigenvalues}');

  // Detect outliers
  var outliers = ls.detectOutliers(0.95);
  if (outliers.isNotEmpty) {
    print('Outliers at indices: $outliers');
  }
}
```

---

## Related Tests

- [`test/least_squares`](../../test/least_squares/) - Least squares fitting tests

## Related Documentation

- [Matrix](04_matrix.md) - Matrix operations for least squares
- [Linear](06_linear.md) - Linear system solvers
- [Statistics](../04_statistics.md) - Statistical analysis
