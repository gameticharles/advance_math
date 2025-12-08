import 'package:advance_math/advance_math.dart';

void main() {
  print('Running Verification for Advanced Math Enhancements...\n');

  try {
    testSpline();
  } catch (e, s) {
    print('Spline Failed: $e\n$s');
  }

  try {
    testRBF();
  } catch (e, s) {
    print('RBF Failed: $e\n$s');
  }

  try {
    testNonParametric();
  } catch (e, s) {
    print('NonParametric Failed: $e\n$s');
  }

  try {
    testCorrelation();
  } catch (e, s) {
    print('Correlation Failed: $e\n$s');
  }

  try {
    testPCA();
  } catch (e, s) {
    print('PCA Failed: $e\n$s');
  }

  try {
    testKMeans();
  } catch (e, s) {
    print('KMeans Failed: $e\n$s');
  }

  try {
    testKDE();
  } catch (e, s) {
    print('KDE Failed: $e\n$s');
  }

  try {
    testRegression();
  } catch (e, s) {
    print('Regression Failed: $e\n$s');
  }

  print('\nVerification Complete.');
}

void testSpline() {
  print('--- Testing Spline Interpolation ---');
  List<double> x = [0, 1, 2, 3, 4, 5];
  List<double> y = [0, 0.8, 0.9, 0.1, -0.8, -1.0];

  var cubic = SplineInterpolator(x, y, type: SplineType.naturalCubic);
  var pchip = SplineInterpolator(x, y, type: SplineType.monotoneCubic);
  var akima = SplineInterpolator(x, y, type: SplineType.akima);

  print('Cubic(1.5): ${cubic.interpolate(1.5)}');
  print('PCHIP(1.5): ${pchip.interpolate(1.5)}');
  print('Akima(1.5): ${akima.interpolate(1.5)}');
}

void testRBF() {
  print('\n--- Testing RBF Interpolation ---');
  List<double> x = [0, 1, 2, 3];
  List<double> y = [0, 1, 0, 1];

  var rbf = RBFInterpolator(x, y, kernel: RBFKernel.gaussian, epsilon: 1.0);
  print(
      'RBF(1.5): ${rbf.interpolate(1.5)} (Expect approx 0.5)'); // Between 1 and 0
}

void testNonParametric() {
  print('\n--- Testing Non-Parametric Statistics ---');
  List<double> x = [1, 2, 3, 4, 5];
  List<double> y = [1, 2, 3, 4, 100]; // Outlier

  var mw = NonParametric.mannWhitneyU(x, y);
  print('Mann-Whitney U: u=${mw.statistic}, p=${mw.pValue}');

  var ws = NonParametric.wilcoxonSignedRank(x, y);
  print('Wilcoxon Signed-Rank: t=${ws.statistic}, p=${ws.pValue}');

  var kw = NonParametric.kruskalWallis([x, y]);
  print('Kruskal-Wallis: h=${kw.statistic}, p=${kw.pValue}');
}

void testCorrelation() {
  print('\n--- Testing Correlation ---');
  List<double> x = [1, 2, 3, 4, 5];
  List<double> y = [1, 2, 3, 4, 100];

  print('Pearson: ${Correlation.pearson(x, y)}');
  print('Spearman: ${Correlation.spearman(x, y)}');
  print('Kendall: ${Correlation.kendall(x, y)}');
}

void testPCA() {
  print('\n--- Testing PCA ---');
  // 3x2 matrix
  Matrix data = Matrix.fromList([
    [1.0, 2.0],
    [3.0, 4.0],
    [5.0, 6.0]
  ]);

  var pca = Multivariate.pca(data, nComponents: 1);
  print('Original Shape: ${data.rowCount}x${data.columnCount}');
  print('Explained Variance Ratio: ${pca.explainedVarianceRatio}');
  print('Components: \n${pca.components}');
}

void testKMeans() {
  print('\n--- Testing KMeans ---');
  Matrix data = Matrix.fromList([
    [1.0, 1.0],
    [1.1, 1.1],
    [0.9, 0.9],
    [5.0, 5.0],
    [5.1, 5.1],
    [4.9, 4.9]
  ]);

  var kmeans = Multivariate.kMeans(data, k: 2);
  print('Inertia: ${kmeans.inertia}');
  print('Labels: ${kmeans.labels}');
  print('Centroids: \n${kmeans.centroids}'); // Field is centroids
}

void testKDE() {
  print('\n--- Testing KDE ---');
  List<double> data = [0.1, 0.2, 0.5, 2.0, 2.1];
  var kde = KDE(data);
  print('PDF at 0.15: ${kde.pdf(0.15)}');
  print('PDF at 2.05: ${kde.pdf(2.05)}');
  print('PDF at 1.0 (empty region): ${kde.pdf(1.0)}');
}

void testRegression() {
  print('\n--- Testing Lasso/ElasticNet ---');
  Matrix X = Matrix.fromList([
    [1.0, 0.0],
    [0.0, 1.0],
    [0.0, 0.0]
  ]);
  List<double> y = [1.0, 0.5, 0.0];

  var lasso = Regression.lasso(X, y, alpha: 0.1);
  print('Lasso Coeffs: \n${lasso.coefficients}');

  var elastic = Regression.elasticNet(X, y, alpha: 0.1, l1Ratio: 0.5);
  print('ElasticNet Coeffs: \n${elastic.coefficients}');
}
