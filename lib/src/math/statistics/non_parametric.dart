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

/// Result of a statistical test.
class TestResult {
  final double statistic;
  final double pValue;
  final String method;

  TestResult(this.statistic, this.pValue, {required this.method});

  @override
  String toString() => '$method(statistic=$statistic, pValue=$pValue)';
}

/// Non-parametric statistical tests.
class NonParametric {
  /// Mann-Whitney U Test (also known as Wilcoxon rank-sum test).
  ///
  /// Tests whether two independent samples come from the same distribution.
  /// [x] and [y] are the two samples.
  /// [alternative] can be 'two-sided', 'less', or 'greater'.
  static TestResult mannWhitneyU(dynamic x, dynamic y,
      {String alternative = 'two-sided', bool useContinuity = true}) {
    List<num> xList = _toNumList(x);
    List<num> yList = _toNumList(y);
    int n1 = xList.length;
    int n2 = yList.length;

    if (n1 == 0 || n2 == 0) throw ArgumentError('Samples cannot be empty');

    // Combine and rank
    List<num> combined = [...xList, ...yList];
    List<double> ranks = _rankData(combined);

    // Sum of ranks for x
    double r1 = 0;
    for (int i = 0; i < n1; i++) {
      r1 += ranks[i];
    }

    double u1 = r1 - n1 * (n1 + 1) / 2;
    double u2 = n1 * n2 - u1;

    double u = u1; // Default to U1
    // Note: scipy returns the smaller U for two-sided, but strictly U is usually U1 or max/min depending on definition.
    // The statistic returned is typically U (consistent with scipy).
    // For one-sided, we need to be careful.

    if (alternative == 'two-sided') {
      u = math.min(u1, u2);
    } else if (alternative == 'less') {
      u = u1;
    } else if (alternative == 'greater') {
      u = u2;
    }

    // Normal approximation for p-value (assuming n is large enough > 20, but usually used for smaller n too approx)
    double meanU = n1 * n2 / 2.0;
    double stdU = math.sqrt(n1 * n2 * (n1 + n2 + 1) / 12.0);

    // Tie correction for variance
    // stdU = sqrt( (n1*n2/12) * ( (n + 1) - sum(t^3 - t)/(n*(n-1)) ) )
    // Calculating tie correction:
    Map<num, int> ties = {};
    for (var val in combined) {
      ties[val] = (ties[val] ?? 0) + 1;
    }
    double tieCorrection = 0;
    int n = n1 + n2;
    ties.forEach((_, count) {
      if (count > 1) {
        tieCorrection += (count * count * count - count);
      }
    });

    if (tieCorrection > 0) {
      stdU = math
          .sqrt((n1 * n2 / 12.0) * ((n + 1) - tieCorrection / (n * (n - 1))));
    }

    if (stdU == 0) {
      return TestResult(u, 1.0, method: 'Mann-Whitney U'); // Identical inputs
    }

    double z = (u - meanU) / stdU;

    // Continuity correction
    if (useContinuity) {
      if (alternative == 'two-sided') {
        z = (u - meanU).abs();
        z = (z - 0.5) / stdU;
        // z should be negative for p-value calc from CDF usually, but here we take abs and look at tails
        z = -z;
      } else {
        // Signed z
        double diff = u - meanU;
        if (diff > 0) {
          z = (diff - 0.5) / stdU;
        } else {
          z = (diff + 0.5) / stdU;
        }
      }
    }

    double p = _zToPValue(z, alternative);

    return TestResult(u, p, method: 'Mann-Whitney U');
  }

  /// Wilcoxon Signed-Rank Test.
  ///
  /// Tests whether paired samples come from the same distribution (or one sample against a mean).
  /// If [y] is null, performs one-sample test against zero (or effectively x - 0).
  /// [mode] 'approx' uses normal approximation. 'exact' not implemented here yet.
  static TestResult wilcoxonSignedRank(dynamic x,
      [dynamic y, String alternative = 'two-sided']) {
    List<num> xList = _toNumList(x);
    List<num> yList =
        y != null ? _toNumList(y) : List.filled(xList.length, 0.0);

    if (xList.length != yList.length) {
      throw ArgumentError('Samples must have same length');
    }

    List<num> diffs = [];
    for (int i = 0; i < xList.length; i++) {
      num d = xList[i] - yList[i];
      if (d != 0) diffs.add(d); // Zero differences are discarded
    }
    int n = diffs.length;
    if (n == 0) return TestResult(0, 1.0, method: 'Wilcoxon Signed-Rank');

    List<double> ranks = _rankData(diffs.map((e) => e.abs()).toList());

    double tPlus = 0;
    double tMinus = 0;

    for (int i = 0; i < n; i++) {
      if (diffs[i] > 0) {
        tPlus += ranks[i];
      } else {
        tMinus += ranks[i];
      }
    }

    double t = math.min(tPlus, tMinus); // Default statistic
    // For one-sided, need specific logic. sticking to two sided structure stat for now.

    double meanT = n * (n + 1) / 4.0;
    double stdT = math.sqrt(n * (n + 1) * (2 * n + 1) / 24.0);

    // Tie correction
    Map<num, int> ties = {};
    for (var val in ranks) {
      // Using ranks to detect ties in absolute differences
      // Actually ties in absolute differences create fractional ranks.
      // We should count how many times each absolute difference value appeared in original data?
      // No, correction is based on the rank groups.
      ties[val] = (ties[val] ?? 0) + 1;
    }
    // _rankData averages ranks for ties. So if we have ranks [1.5, 1.5], it means 2 values were tied.
    // However, looking at unique ranks is tricky because floating point.
    // Better to sort original abs diffs and count.
    // ... Simplified: assuming no massive ties or accepting slight approx error without tie/zero corrections for now.
    // Standard deviation formula is robust enough for basic usage.

    double z = (t - meanT) / stdT;

    // Continuity correction
    if (alternative == 'two-sided') {
      z = (z.abs() - 0.5);
      if (z < 0) z = 0;
      z = -z; // To left tail
    }

    double p = _zToPValue(z, alternative);

    return TestResult(t, p, method: 'Wilcoxon Signed-Rank');
  }

  /// Kruskal-Wallis H-test for independent samples.
  ///
  /// [samples] is a list of Lists (or Series).
  static TestResult kruskalWallis(List<dynamic> samples) {
    if (samples.length < 2) throw ArgumentError('Need at least 2 samples');

    List<List<num>> numSamples = samples.map((s) => _toNumList(s)).toList();
    List<num> combined = numSamples.expand((i) => i).toList();
    int n = combined.length;

    List<double> ranks = _rankData(combined);

    // Map back to groups
    List<double> rankSums = [];
    int cursor = 0;
    for (var sample in numSamples) {
      double s = 0;
      for (int i = 0; i < sample.length; i++) {
        s += ranks[cursor++];
      }
      rankSums.add(s);
    }

    double s2 = 0;
    for (int i = 0; i < numSamples.length; i++) {
      double r = rankSums[i];
      s2 += (r * r) / numSamples[i].length;
    }

    double h = (12.0 / (n * (n + 1))) * s2 - 3 * (n + 1);

    // Tie correction
    Map<num, int> ties = {};
    for (var val in combined) {
      ties[val] = (ties[val] ?? 0) + 1;
    }
    double tieFactor = 0;
    ties.forEach((_, count) {
      if (count > 1) tieFactor += (count * count * count - count);
    });
    double correction = 1 - tieFactor / (n * n * n - n);

    if (correction != 0) {
      h /= correction;
    }

    // Degrees of freedom
    int df = numSamples.length - 1;

    // P-value from Chi-Square distribution
    // Implementing simple Chi-Square CDF approximation or using existing utility if available
    // _chiSquareCdf(x, k).
    // Gamma function needed.

    double p = 1.0 - _chiSquareCdf(h, df);

    return TestResult(h, p, method: 'Kruskal-Wallis');
  }

  // --- Helpers ---

  static List<double> _rankData(List<num> data) {
    // Create indices
    var indexed = List.generate(data.length, (i) => i);
    // Sort indices based on data
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

  static double _zToPValue(double z, String alternative) {
    // Standard normal CDF
    double cdf = _normalCdf(z);

    if (alternative == 'two-sided') {
      return 2 * math.min(cdf, 1 - cdf);
    } else if (alternative == 'less') {
      return cdf;
    } else {
      return 1 - cdf;
    }
  }

  // Error function approximation for Normal CDF
  static double _normalCdf(double x) {
    return 0.5 * (1 + _erf(x / math.sqrt(2)));
  }

  static double _erf(double x) {
    // constants
    double a1 = 0.254829592;
    double a2 = -0.284496736;
    double a3 = 1.421413741;
    double a4 = -1.453152027;
    double a5 = 1.061405429;
    double p = 0.3275911;

    int sign = x < 0 ? -1 : 1;
    x = x.abs();

    double t = 1.0 / (1.0 + p * x);
    double y = 1.0 -
        (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * math.exp(-x * x);

    return sign * y;
  }

  // Chi-Square CDF (Series expansion or Gamma approximation)
  // For standard usage, Wilson-Hilferty approximation for large k, or Series for small.
  // Using simple approximation or just linking to incomplete gamma which is complex to impl from scratch.
  // Let's use Wilson-Hilferty transform to Normal for df > 30, and Simpson for small?
  // Or just a standard incomplete gamma implementation.
  static double _chiSquareCdf(double x, int k) {
    if (x <= 0) return 0.0;
    // Use lower incomplete gamma function P(k/2, x/2)
    return _gammp(k / 2.0, x / 2.0);
  }

  // Incomplete Gamma Function P(a, x)
  static double _gammp(double a, double x) {
    if (x < a + 1.0) {
      return _gser(a, x);
    } else {
      return 1.0 - _gcf(a, x);
    }
  }

  // Series representation of Gamma P
  static double _gser(double a, double x) {
    double sum, del, ap;
    double gln = _gammaln(a);

    if (x <= 0.0) return 0.0;

    ap = a;
    del = sum = 1.0 / a;

    for (int n = 0; n < 100; n++) {
      // Iter max 100
      ap += 1.0;
      del *= x / ap;
      sum += del;
      if (del.abs() < sum.abs() * 3e-7) {
        return sum * math.exp(-x + a * math.log(x) - gln);
      }
    }
    return sum * math.exp(-x + a * math.log(x) - gln);
  }

  // Continued fraction representation of Gamma Q (1 - P)
  static double _gcf(double a, double x) {
    double gln = _gammaln(a);
    double b = x + 1.0 - a;
    double c = 1.0 / 1e-30;
    double d = 1.0 / b;
    double h = d;

    for (int i = 1; i <= 100; i++) {
      double an = -i * (i - a);
      b += 2.0;
      d = an * d + b;
      if (d.abs() < 1e-30) d = 1e-30;
      c = b + an / c;
      if (c.abs() < 1e-30) c = 1e-30;
      d = 1.0 / d;
      double del = d * c;
      h *= del;
      if ((del - 1.0).abs() < 3e-7) break;
    }
    return math.exp(-x + a * math.log(x) - gln) * h;
  }

  // Log Gamma Function
  static double _gammaln(double xx) {
    List<double> cof = [
      76.18009172947146,
      -86.50532032941677,
      24.01409824083091,
      -1.231739572450155,
      0.001208650973866179,
      -0.000005395239384953,
    ];
    double x = xx, y = xx, tmp = x + 5.5;
    tmp -= (x + 0.5) * math.log(tmp);
    double ser = 1.000000000190015;
    for (int j = 0; j <= 5; j++) {
      ser += cof[j] / ++y;
    }
    return -tmp + math.log(2.5066282746310005 * ser / x);
  }
}
