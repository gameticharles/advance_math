import 'dart:math' as math;

/// Abstract base class for probability distributions.
abstract class ProbabilityDistribution {
  /// Probability density function (continuous) or mass function (discrete).
  num pdf(num x);

  /// Cumulative distribution function.
  num cdf(num x);

  /// Quantile function (inverse CDF).
  num quantile(num p);

  /// Mean of the distribution.
  num mean();

  /// Variance of the distribution.
  num variance();

  /// Standard deviation of the distribution.
  num stdDev() => math.sqrt(variance());

  /// Generate a single random sample.
  num sample();

  /// Generate multiple random samples.
  List<num> samples(int n) => List.generate(n, (_) => sample());
}
