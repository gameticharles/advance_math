import 'package:dartframe/dartframe.dart';

/// Statistical extensions for Series to add missing stats.
extension SeriesStats on Series {
  /// Alias for std().
  double get stdDev => std();

  /// Alias for skew().
  double get skewness => skew();

  /// Returns a summary dictionary of statistics.
  /// Note: 'describe' might exist in some versions, but we'll override or ensure we return map.
  Map<String, num> describeStats() {
    return {
      'count': count(),
      'mean': mean(),
      'std': std(),
      'min': min(),
      '25%': quantile(0.25),
      '50%': median(),
      '75%': quantile(0.75),
      'max': max(),
    };
  }
}
