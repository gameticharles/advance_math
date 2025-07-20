part of '../algebra.dart';

/// Computes Z-score based on a given confidence level.
///
/// The class provides functionalities to compute Z-scores, which are used
/// in statistical hypothesis testing. The Z-score represents how many standard
/// deviations an element is from the mean.
///
/// ```
/// print(ZScore.computeZScore(95)); // 1.9603949169253396
/// print(ZScore.computeZScore(95, twoTailed: false)); // 1.645211440143815
///
/// print(ZScore.computeConfidenceLevel(1.9603949169253396)); // 95.00503548449109
/// print(ZScore.computeConfidenceLevel(5.326446072058037)); // 99.99998998470075
/// ```
class ZScore {
  /// Approximation to the inverse of the normal CDF (cumulative density function)
  /// Source: https://www.johndcook.com/blog/normal_cdf_inverse/
  static double rationalApproximation(double t) {
    // Abramowitz and Stegun formula 26.2.23.
    const c0 = 2.515517;
    const c1 = 0.802853;
    const c2 = 0.010328;
    const d1 = 1.432788;
    const d2 = 0.189269;
    const d3 = 0.001308;

    return t - ((c2 * t + c1) * t + c0) / (((d3 * t + d2) * t + d1) * t + 1.0);
  }

  /// Compute Z-score based on confidence level.
  ///
  /// [confidenceLevel]: Confidence level between 0 and 100.
  /// [twoTailed]: Boolean indicating if the test is two-tailed. Default is true.
  ///
  /// Example:
  /// ```dart
  /// var zScore = ZScore.computeZScore(95);
  /// print('Z-score for 95% confidence level is: $zScore');
  /// // Z-score for 95% confidence level is 1.9603949169253396
  /// ```
  ///
  /// @return Z-score corresponding to the confidence level.
  static double computeZScore(num confidenceLevel, {bool twoTailed = true}) {
    if (confidenceLevel < 0 || confidenceLevel > 100) {
      throw ArgumentError('Confidence level must be between 0 and 100.');
    }

    // Convert the confidence level to a tail area
    double p = 1.0 - (1.0 - confidenceLevel / 100) / (twoTailed ? 2.0 : 1.0);

    if (p <= 0.0 || p >= 1.0) {
      throw ArgumentError('Tail area must be between 0 and 1.');
    }

    if (p < 0.5) {
      // F^-1(p) = - G^-1(p)
      return -rationalApproximation(math.sqrt(-2.0 * math.log(p)));
    } else {
      // F^-1(p) = G^-1(1-p)
      return rationalApproximation(math.sqrt(-2.0 * math.log(1 - p)));
    }
  }

  /// Compute confidence level based on Z-score and type of test.
  ///
  /// [zScore]: zScore value as double.
  /// [twoTailed]: Boolean indicating if the test is two-tailed. Default is true.
  ///
  /// Example:
  /// ```dart
  /// print(ZScore.computeConfidenceLevel(1.9603949169253396)); // 95.0
  /// print(ZScore.computeConfidenceLevel(5.326446072058037, twoTailed: false)); // 99.99999499235037
  /// ```
  ///
  /// @return confidence level between 0 and 100 corresponding to the Z-score.
  static double computeConfidenceLevel(num zScore, {bool twoTailed = true}) {
    // Compute the tail area
    double p = (1.0 + erf(zScore / math.sqrt(2.0))) / 2.0;

    // Convert the tail area to a confidence level
    double confidenceLevel = 100 * (1 - (1 - p) * (twoTailed ? 2.0 : 1.0));

    return confidenceLevel;
  }

  /// Compute the value of the standard normal Probability Density Function (PDF) at a given Z-score.
  ///
  /// [zScore]: Z-score value as double.
  ///
  /// Example:
  /// ```dart
  /// print(ZScore.computePDF(0)); // 0.3989422804014337
  /// ```
  ///
  /// @return PDF value at the given Z-score.
  static double computePDF(double zScore) {
    return (1 / math.sqrt(2 * math.pi)) * math.exp(-math.pow(zScore, 2) / 2);
  }

  /// Compute the value of the standard normal Cumulative Density Function (CDF) at a given Z-score.
  ///
  /// [zScore]: Z-score value as double.
  ///
  /// Example:
  /// ```dart
  /// print(ZScore.computeCDF(0)); // 0.5
  /// ```
  ///
  /// @return CDF value at the given Z-score.
  static double computeCDF(double zScore) {
    return 0.5 * (1 + erf(zScore / math.sqrt(2)));
  }

  /// Compute the confidence interval for a given sample mean, sample size, and standard deviation.
  ///
  /// [sampleMean]: Sample mean as double.
  /// [sampleSize]: Sample size as integer.
  /// [stdDev]: Standard deviation as double.
  /// [confidenceLevel]: Confidence level as percentage (0-100).
  ///
  /// Example:
  /// ```dart
  /// print(ZScore.computeConfidenceInterval(50, 100, 10, 95)); // (48.040605084588995, 51.959394915411005)
  /// ```
  ///
  /// @return A records containing the lower and upper bounds of the confidence interval.
  static ({double lower, double upper}) computeConfidenceInterval(
      double sampleMean,
      int sampleSize,
      double stdDev,
      double confidenceLevel) {
    double zScore = computeZScore(confidenceLevel);
    double marginOfError = zScore * (stdDev / math.sqrt(sampleSize));
    return (
      lower: sampleMean - marginOfError,
      upper: sampleMean + marginOfError
    );
  }

  /// Compute p-value from a given Z-score.
  ///
  /// [zScore]: The Z-score.
  ///
  /// Example:
  /// ```dart
  /// print(ZScore.computePValue(1.96)); // 0.025
  /// ```
  ///
  /// @return The p-value.
  static double computePValue(double zScore) {
    return 1 - (1.0 + erf(zScore / math.sqrt(2.0))) / 2.0;
  }

  /// Convert Z-score to T-score.
  ///
  /// [zScore]: The Z-score.
  ///
  /// Example:
  /// ```dart
  /// print(ZScore.convertZToT(1.96)); // 69.6
  /// ```
  ///
  /// @return The T-score.
  static double convertZToT(double zScore) {
    return 10 * zScore + 50;
  }

  /// Compute the percentile from a given Z-score.
  ///
  /// [zScore]: The Z-score.
  ///
  /// Example:
  /// ```dart
  /// print(ZScore.computePercentile(1.96)); // 97.5
  /// ```
  ///
  /// @return The percentile.
  static double computePercentile(double zScore) {
    return (1.0 + erf(zScore / math.sqrt(2.0))) / 2.0 * 100;
  }

  /// Compute Z-score from a raw score.
  ///
  /// [rawScore]: The raw score.
  /// [mean]: The population mean.
  /// [stdDev]: The standard deviation.
  ///
  /// Example:
  /// ```dart
  /// print(ZScore.computeZScoreFromRawScore(110, 100, 15)); // 0.6666666666666666
  /// ```
  ///
  /// @return The Z-score.
  static double computeZScoreFromRawScore(
      double rawScore, double mean, double stdDev) {
    return (rawScore - mean) / stdDev;
  }
}
