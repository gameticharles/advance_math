import 'dart:math' as math;

/// Result of a hypothesis test.
class HypothesisTestResult {
  /// Test statistic value.
  final num statistic;

  /// P-value of the test.
  final num pValue;

  /// Degrees of freedom (if applicable).
  final num? degreesOfFreedom;

  /// Whether to reject null hypothesis at significance level alpha.
  final bool reject;

  /// Name of the test.
  final String testName;

  /// Significance level used.
  final double alpha;

  HypothesisTestResult({
    required this.statistic,
    required this.pValue,
    this.degreesOfFreedom,
    required this.reject,
    required this.testName,
    required this.alpha,
  });

  @override
  String toString() {
    return '$testName: statistic=$statistic, p-value=$pValue, reject=$reject (α=$alpha)';
  }
}

/// Hypothesis testing methods.
class HypothesisTesting {
  /// Two-sample t-test (Student's t-test).
  ///
  /// Tests if two samples have different means.
  /// Assumes independent samples with approximately normal distributions.
  static HypothesisTestResult tTest(
    List<num> sample1,
    List<num> sample2, {
    double alpha = 0.05,
    bool equalVariance = true,
  }) {
    int n1 = sample1.length;
    int n2 = sample2.length;

    // Calculate means
    num mean1 = sample1.reduce((a, b) => a + b) / n1;
    num mean2 = sample2.reduce((a, b) => a + b) / n2;

    // Calculate variances
    num var1 =
        sample1.map((x) => (x - mean1) * (x - mean1)).reduce((a, b) => a + b) /
            (n1 - 1);
    num var2 =
        sample2.map((x) => (x - mean2) * (x - mean2)).reduce((a, b) => a + b) /
            (n2 - 1);

    num tStat;
    num df;

    if (equalVariance) {
      // Pooled variance
      num pooledVar = ((n1 - 1) * var1 + (n2 - 1) * var2) / (n1 + n2 - 2);
      num se = math.sqrt(pooledVar * (1 / n1 + 1 / n2));
      tStat = (mean1 - mean2) / se;
      df = n1 + n2 - 2;
    } else {
      // Welch's t-test
      num se = math.sqrt(var1 / n1 + var2 / n2);
      tStat = (mean1 - mean2) / se;
      // Welch-Satterthwaite equation
      df = ((var1 / n1 + var2 / n2) * (var1 / n1 + var2 / n2)) /
          ((var1 / n1) * (var1 / n1) / (n1 - 1) +
              (var2 / n2) * (var2 / n2) / (n2 - 1));
    }

    // Calculate p-value (two-tailed)
    num pValue = 2 * (1 - _studentTCDF(tStat.abs(), df));

    return HypothesisTestResult(
      statistic: tStat,
      pValue: pValue,
      degreesOfFreedom: df,
      reject: pValue < alpha,
      testName: 'Two-sample t-test',
      alpha: alpha,
    );
  }

  /// One-sample t-test.
  ///
  /// Tests if sample mean differs from population mean mu0.
  static HypothesisTestResult tTestOneSample(
    List<num> sample,
    num mu0, {
    double alpha = 0.05,
  }) {
    int n = sample.length;
    num mean = sample.reduce((a, b) => a + b) / n;
    num variance =
        sample.map((x) => (x - mean) * (x - mean)).reduce((a, b) => a + b) /
            (n - 1);
    num se = math.sqrt(variance / n);
    num tStat = (mean - mu0) / se;
    num df = n - 1;

    num pValue = 2 * (1 - _studentTCDF(tStat.abs(), df));

    return HypothesisTestResult(
      statistic: tStat,
      pValue: pValue,
      degreesOfFreedom: df,
      reject: pValue < alpha,
      testName: 'One-sample t-test',
      alpha: alpha,
    );
  }

  /// Z-test for known population standard deviation.
  static HypothesisTestResult zTest(
    List<num> sample,
    num mu0,
    num sigma, {
    double alpha = 0.05,
  }) {
    int n = sample.length;
    num mean = sample.reduce((a, b) => a + b) / n;
    num se = sigma / math.sqrt(n);
    num zStat = (mean - mu0) / se;

    // Calculate p-value (two-tailed)
    num pValue = 2 * (1 - _normalCDF(zStat.abs()));

    return HypothesisTestResult(
      statistic: zStat,
      pValue: pValue,
      reject: pValue < alpha,
      testName: 'Z-test',
      alpha: alpha,
    );
  }

  /// Chi-square goodness-of-fit test.
  ///
  /// Tests if observed frequencies match expected frequencies.
  static HypothesisTestResult chiSquareTest(
    List<num> observed,
    List<num> expected, {
    double alpha = 0.05,
  }) {
    if (observed.length != expected.length) {
      throw ArgumentError('Observed and expected must have same length');
    }

    num chiSq = 0;
    for (int i = 0; i < observed.length; i++) {
      num diff = observed[i] - expected[i];
      chiSq += (diff * diff) / expected[i];
    }

    num df = observed.length - 1;
    num pValue = 1 - _chiSquareCDF(chiSq, df);

    return HypothesisTestResult(
      statistic: chiSq,
      pValue: pValue,
      degreesOfFreedom: df,
      reject: pValue < alpha,
      testName: 'Chi-square test',
      alpha: alpha,
    );
  }

  /// One-way ANOVA (Analysis of Variance).
  ///
  /// Tests if means of multiple groups are different.
  static HypothesisTestResult anovaTest(
    List<List<num>> groups, {
    double alpha = 0.05,
  }) {
    int k = groups.length; // Number of groups
    int n = groups.fold(
        0, (sum, group) => sum + group.length); // Total observations

    // Grand mean
    num grandMean = 0;
    for (var group in groups) {
      grandMean += group.reduce((a, b) => a + b);
    }
    grandMean /= n;

    // Between-group sum of squares (SSB)
    num ssb = 0;
    for (var group in groups) {
      num groupMean = group.reduce((a, b) => a + b) / group.length;
      ssb += group.length * (groupMean - grandMean) * (groupMean - grandMean);
    }

    // Within-group sum of squares (SSW)
    num ssw = 0;
    for (var group in groups) {
      num groupMean = group.reduce((a, b) => a + b) / group.length;
      for (var x in group) {
        ssw += (x - groupMean) * (x - groupMean);
      }
    }

    // Degrees of freedom
    num dfBetween = k - 1;
    num dfWithin = n - k;

    // Mean squares
    num msb = ssb / dfBetween;
    num msw = ssw / dfWithin;

    // F-statistic
    num fStat = msb / msw;

    // P-value
    num pValue = 1 - _fDistributionCDF(fStat, dfBetween, dfWithin);

    return HypothesisTestResult(
      statistic: fStat,
      pValue: pValue,
      degreesOfFreedom: dfBetween,
      reject: pValue < alpha,
      testName: 'One-way ANOVA',
      alpha: alpha,
    );
  }

  /// Approximation of Student's t CDF using normal approximation for large df.
  static num _studentTCDF(num t, num df) {
    if (df > 30) {
      // Normal approximation for large df
      return _normalCDF(t);
    }

    // Approximation using incomplete beta function
    // For simplicity, using a numerical approximation
    num x = df / (df + t * t);
    num beta = _incompleteBeta(0.5 * df, 0.5, x);

    if (t < 0) {
      return 0.5 * beta;
    } else {
      return 1 - 0.5 * beta;
    }
  }

  /// Standard normal CDF approximation.
  static num _normalCDF(num z) {
    // Abramowitz and Stegun approximation
    num t = 1 / (1 + 0.2316419 * z.abs());
    num d = 0.3989423 * math.exp(-z * z / 2);
    num prob = d *
        t *
        (0.3193815 +
            t * (-0.3565638 + t * (1.781478 + t * (-1.821256 + t * 1.330274))));

    if (z >= 0) {
      return 1 - prob;
    } else {
      return prob;
    }
  }

  /// Chi-square CDF approximation.
  static num _chiSquareCDF(num x, num k) {
    if (x <= 0) return 0;
    // Using incomplete gamma function: P(k/2, x/2)
    return _lowerIncompleteGamma(k / 2, x / 2) / _gamma(k / 2);
  }

  /// F-distribution CDF approximation.
  static num _fDistributionCDF(num f, num d1, num d2) {
    if (f <= 0) return 0;
    num x = d2 / (d2 + d1 * f);
    return 1 - _incompleteBeta(d2 / 2, d1 / 2, x);
  }

  /// Incomplete beta function approximation.
  static num _incompleteBeta(num a, num b, num x) {
    if (x <= 0) return 0;
    if (x >= 1) return 1;

    // Continued fraction approximation
    num bt = math.exp(_logGamma(a + b) -
        _logGamma(a) -
        _logGamma(b) +
        a * math.log(x) +
        b * math.log(1 - x));

    if (x < (a + 1) / (a + b + 2)) {
      return bt * _betaCF(a, b, x) / a;
    } else {
      return 1 - bt * _betaCF(b, a, 1 - x) / b;
    }
  }

  /// Continued fraction for incomplete beta.
  static num _betaCF(num a, num b, num x) {
    const int maxIter = 100;
    const double eps = 1e-10;

    num qab = a + b;
    num qap = a + 1;
    num qam = a - 1;
    num c = 1.0;
    num d = 1 - qab * x / qap;

    if (d.abs() < eps) d = eps;
    d = 1 / d;
    num h = d;

    for (int m = 1; m <= maxIter; m++) {
      num m2 = 2 * m;
      num aa = m * (b - m) * x / ((qam + m2) * (a + m2));
      d = 1 + aa * d;
      if (d.abs() < eps) d = eps;
      c = 1 + aa / c;
      if (c.abs() < eps) c = eps;
      d = 1 / d;
      h *= d * c;

      aa = -(a + m) * (qab + m) * x / ((a + m2) * (qap + m2));
      d = 1 + aa * d;
      if (d.abs() < eps) d = eps;
      c = 1 + aa / c;
      if (c.abs() < eps) c = eps;
      d = 1 / d;
      num del = d * c;
      h *= del;

      if ((del - 1).abs() < eps) break;
    }

    return h;
  }

  /// Lower incomplete gamma function.
  static num _lowerIncompleteGamma(num a, num x) {
    if (x < 0 || a <= 0) return 0;
    if (x == 0) return 0;

    // Series representation
    num sum = 1 / a;
    num term = 1 / a;

    for (int n = 1; n < 100; n++) {
      term *= x / (a + n);
      sum += term;
      if (term.abs() < 1e-10) break;
    }

    return sum * math.exp(-x + a * math.log(x) - _logGamma(a));
  }

  /// Gamma function using Lanczos approximation.
  static num _gamma(num z) {
    return math.exp(_logGamma(z));
  }

  /// Log-gamma function.
  static num _logGamma(num z) {
    // Lanczos approximation
    const List<double> coef = [
      76.18009172947146,
      -86.50532032941677,
      24.01409824083091,
      -1.231739572450155,
      0.1208650973866179e-2,
      -0.5395239384953e-5,
    ];

    num x = z;
    num tmp = x + 5.5;
    tmp -= (x + 0.5) * math.log(tmp);
    num ser = 1.000000000190015;

    for (int j = 0; j < 6; j++) {
      ser += coef[j] / (x + j + 1);
    }

    return -tmp + math.log(2.5066282746310005 * ser / x);
  }
}
