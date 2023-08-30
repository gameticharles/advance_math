part of algebra;

/// Computes Z-scores based on a given confidence level.
///
/// The class provides functionalities to compute Z-scores, which are used
/// in statistical hypothesis testing. The Z-score represents how many standard
/// deviations an element is from the mean.
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
  static double computeZScore(num confidenceLevel) {
    if (confidenceLevel < 0 || confidenceLevel > 100) {
      throw ArgumentError('Confidence level must be between 0 and 100.');
    }

    // Convert the confidence level to a tail area
    double p = 1.0 - (1.0 - confidenceLevel / 100) / 2.0;

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
}
