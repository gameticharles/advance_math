import 'dart:math' as math;

import '../../number/complex/complex.dart';
import '../algebra/algebra.dart';

/// Result of PCA.
class PCAResult {
  final Matrix components;
  final List<double> explainedVariance;
  final List<double> explainedVarianceRatio;
  final List<double> singularValues;
  final List<double> mean;

  PCAResult(this.components, this.explainedVariance,
      this.explainedVarianceRatio, this.singularValues, this.mean);
}

/// Result of K-Means.
class KMeansResult {
  final Matrix centroids;
  final List<int> labels;
  final double inertia;

  KMeansResult(this.centroids, this.labels, this.inertia);
}

class Multivariate {
  /// Principal Component Analysis (PCA).
  ///
  /// [data] is a Matrix (rows are samples, columns are features).
  /// [nComponents] is the number of components to keep.
  static PCAResult pca(Matrix data, {int? nComponents}) {
    int nSamples = data.rowCount;
    int nFeatures = data.columnCount;
    int k = nComponents ?? math.min(nSamples, nFeatures);

    // 1. Center the data
    List<double> mean = List.filled(nFeatures, 0.0);
    for (int j = 0; j < nFeatures; j++) {
      double s = 0;
      for (int i = 0; i < nSamples; i++) {
        s += _toDouble(data[i][j]);
      }
      mean[j] = s / nSamples;
    }

    List<List<double>> centeredData = [];
    for (int i = 0; i < nSamples; i++) {
      List<double> row = [];
      for (int j = 0; j < nFeatures; j++) {
        row.add(_toDouble(data[i][j]) - mean[j]);
      }
      centeredData.add(row);
    }
    Matrix X = Matrix(centeredData);

    // 2. Compute Covariance Matrix (unbiased)
    // Cov = (X^T * X) / (n - 1)
    Matrix cov = (X.transpose() * X) * (1.0 / (nSamples - 1));

    // 3. Eigendecomposition (or SVD)
    // Since Cov is symmetric, we can use EigenDecomposition
    EigenvalueDecomposition eigen = cov.decomposition.eigenvalueDecomposition();

    // Extract real eigenvalues from Diagonal matrix D
    List<double> eigenvalues = [];
    for (int i = 0; i < nFeatures; i++) {
      eigenvalues.add(eigen.D[i][i].toDouble());
    }

    // Make pairs of (eigenvalue, eigenvector column)
    Matrix V = eigen.V; // Matrix of eigenvectors

    List<MapEntry<double, List<num>>> pairs = [];
    for (int i = 0; i < nFeatures; i++) {
      // Flatten column to list
      pairs.add(MapEntry(
          eigenvalues[i], V.column(i).flatten().map((e) => e as num).toList()));
    }

    // Sort by eigenvalue descending
    pairs.sort((a, b) => b.key.compareTo(a.key));

    // Select top k
    List<double> topEigenvalues = [];
    List<List<num>> topEigenvectors = [];
    for (int i = 0; i < k; i++) {
      topEigenvalues.add(pairs[i].key);
      topEigenvectors.add(pairs[i].value);
    }

    // Components matrix (rows are eigenvectors, like sklearn)
    // Or columns? Sklearn components_ is [n_components, n_features]
    List<List<num>> componentRows = [];
    for (int i = 0; i < k; i++) {
      componentRows.add(topEigenvectors[i]);
    }
    Matrix components = Matrix(componentRows);

    // Explained variance
    double totalVar = eigenvalues.reduce((a, b) => a + b);
    List<double> explainedRatio =
        topEigenvalues.map((e) => e / totalVar).toList();

    // Singular values = sqrt(eigenvalues * (n-1))
    List<double> singularValues =
        topEigenvalues.map((e) => math.sqrt(e * (nSamples - 1))).toList();

    return PCAResult(
        components, topEigenvalues, explainedRatio, singularValues, mean);
  }

  /// K-Means Clustering.
  ///
  /// Lloyd's algorithm.
  static KMeansResult kMeans(Matrix data,
      {required int k, int maxIter = 300, double tol = 1e-4, int seed = 42}) {
    int nSamples = data.rowCount;
    int nFeatures = data.columnCount;
    math.Random rng = math.Random(seed);

    // 1. Initialize centroids (Randomly pick k samples)
    List<List<double>> centroidsData = [];
    Set<int> picked = {};
    while (picked.length < k) {
      int idx = rng.nextInt(nSamples);
      if (!picked.contains(idx)) {
        picked.add(idx);
        // Copy row
        centroidsData.add(data[idx].map((e) => _toDouble(e)).toList());
      }
    }

    List<int> labels = List.filled(nSamples, -1);
    double inertia = 0;

    for (int iter = 0; iter < maxIter; iter++) {
      // 2. Assignment Step
      List<int> newLabels = List.filled(nSamples, -1);
      double currentInertia = 0;

      for (int i = 0; i < nSamples; i++) {
        double minDistSq = double.infinity;
        int bestCluster = 0;

        for (int j = 0; j < k; j++) {
          double distSq = _distSq(data[i], centroidsData[j]);
          if (distSq < minDistSq) {
            minDistSq = distSq;
            bestCluster = j;
          }
        }
        newLabels[i] = bestCluster;
        currentInertia += minDistSq;
      }

      // Check convergence (assignments didn't change? or centroids didn't move?)
      // Calculating shift
      double shift = 0;
      // 3. Update Step
      List<List<double>> newCentroids =
          List.generate(k, (_) => List.filled(nFeatures, 0.0));
      List<int> counts = List.filled(k, 0);

      for (int i = 0; i < nSamples; i++) {
        int cluster = newLabels[i];
        counts[cluster]++;
        for (int f = 0; f < nFeatures; f++) {
          newCentroids[cluster][f] += _toDouble(data[i][f]);
        }
      }

      for (int j = 0; j < k; j++) {
        if (counts[j] > 0) {
          for (int f = 0; f < nFeatures; f++) {
            newCentroids[j][f] /= counts[j];
          }
        } else {
          // Handle empty cluster? Re-init?
          // For simplicity, leave as is or re-pick random.
        }
        shift += _distSq(centroidsData[j], newCentroids[j]); // Shift squared
      }

      centroidsData = newCentroids;
      labels = newLabels;
      inertia = currentInertia;

      if (shift < tol) break;
    }

    return KMeansResult(Matrix(centroidsData), labels, inertia);
  }

  static double _distSq(List<dynamic> a, List<double> b) {
    double sum = 0;
    for (int i = 0; i < a.length; i++) {
      var val = a[i];
      double d = _toDouble(val) - b[i];
      sum += d * d;
    }
    return sum;
  }
}

double _toDouble(dynamic val) {
  if (val is Complex) return val.real.toDouble();
  if (val is num) return val.toDouble();
  return (val as dynamic).toDouble();
}
