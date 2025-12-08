import 'dart:math' as math;
import 'package:dartframe/dartframe.dart';

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

class Correlation {
  /// Pearson Product-Moment Correlation Coefficient.
  /// Linear correlation.
  static double pearson(dynamic x, dynamic y) {
    List<num> xList = _toNumList(x);
    List<num> yList = _toNumList(y);

    if (xList.length != yList.length) {
      throw ArgumentError("Vectors must have same length");
    }
    int n = xList.length;
    if (n == 0) return double.nan;

    double sumX = 0, sumY = 0, sumXY = 0;
    double sumX2 = 0, sumY2 = 0;

    for (int i = 0; i < n; i++) {
      sumX += xList[i];
      sumY += yList[i];
      sumXY += xList[i] * yList[i];
      sumX2 += xList[i] * xList[i];
      sumY2 += yList[i] * yList[i];
    }

    double numerator = n * sumXY - sumX * sumY;
    double den =
        math.sqrt((n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY));

    if (den == 0) return 0; // Constant arrays
    return numerator / den;
  }

  /// Spearman's Rank Correlation Coefficient.
  /// Correlation of ranks.
  static double spearman(dynamic x, dynamic y) {
    List<num> xList = _toNumList(x);
    List<num> yList = _toNumList(y);

    if (xList.length != yList.length) {
      throw ArgumentError("Vectors must have same length");
    }

    List<double> rankX = _rankData(xList);
    List<double> rankY = _rankData(yList);

    return pearson(rankX, rankY);
  }

  /// Kendall's Tau Rank Correlation Coefficient.
  /// Based on concordant and discordant pairs.
  /// O(n^2) implementation for simplicity.
  static double kendall(dynamic x, dynamic y) {
    List<num> xList = _toNumList(x);
    List<num> yList = _toNumList(y);
    int n = xList.length;

    int concordant = 0;
    int discordant = 0;

    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        // Check pair (i, j)
        double dx = (xList[i] - xList[j]).toDouble();
        double dy = (yList[i] - yList[j]).toDouble();
        double prod = dx * dy;

        if (prod > 0) {
          concordant++;
        } else if (prod < 0) {
          discordant++;
        }
        // Ties are ignored in basic Tau-a, usually considered in Tau-b
      }
    }

    // Using Tau-b for handling ties
    // Count ties
    int nTx = 0; // pairs tied in x
    int nTy = 0; // pairs tied in y
    // O(n^2) tie counting for now
    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        if (xList[i] == xList[j]) nTx++;
        if (yList[i] == yList[j]) nTy++;
      }
    }

    int totalPairs = n * (n - 1) ~/ 2;

    double numer = (concordant - discordant).toDouble();
    double denom = math.sqrt((totalPairs - nTx) * (totalPairs - nTy));

    if (denom == 0) return 0;
    return numer / denom;
  }

  // Reuse rank helper
  static List<double> _rankData(List<num> data) {
    var indexed = List.generate(data.length, (i) => i);
    indexed.sort((a, b) => data[a].compareTo(data[b]));

    List<double> ranks = List.filled(data.length, 0.0);

    int i = 0;
    while (i < data.length) {
      int j = i;
      while (j < data.length - 1 && data[indexed[j]] == data[indexed[j + 1]]) {
        j++;
      }
      int nTies = j - i + 1;
      double rank = i + 1 + (nTies - 1) / 2.0;
      for (int k = i; k <= j; k++) {
        ranks[indexed[k]] = rank;
      }
      i = j + 1;
    }
    return ranks;
  }
}
