/// Result of seasonal decomposition.
class SeasonalDecomposition {
  final List<num> trend;
  final List<num> seasonal;
  final List<num> residual;

  SeasonalDecomposition({
    required this.trend,
    required this.seasonal,
    required this.residual,
  });
}

/// Time series analysis methods.
class TimeSeries {
  /// Simple moving average.
  static List<num> movingAverage(List<num> data, int window) {
    if (window <= 0 || window > data.length) {
      throw ArgumentError('Invalid window size');
    }

    List<num> result = [];
    for (int i = 0; i <= data.length - window; i++) {
      num sum = 0;
      for (int j = 0; j < window; j++) {
        sum += data[i + j];
      }
      result.add(sum / window);
    }
    return result;
  }

  /// Exponential smoothing (single exponential smoothing).
  static List<num> exponentialSmoothing(List<num> data, double alpha) {
    if (alpha < 0 || alpha > 1) {
      throw ArgumentError('alpha must be between 0 and 1');
    }

    List<num> result = [data[0]];
    for (int i = 1; i < data.length; i++) {
      num smoothed = alpha * data[i] + (1 - alpha) * result[i - 1];
      result.add(smoothed);
    }
    return result;
  }

  /// Double exponential smoothing (Holt's method).
  static List<num> doubleExponentialSmoothing(
    List<num> data,
    double alpha,
    double beta,
  ) {
    if (alpha < 0 || alpha > 1 || beta < 0 || beta > 1) {
      throw ArgumentError('alpha and beta must be between 0 and 1');
    }

    List<num> result = [];
    num level = data[0];
    num trend = data.length > 1 ? data[1] - data[0] : 0;

    for (int i = 0; i < data.length; i++) {
      result.add(level + trend);

      num prevLevel = level;
      level = alpha * data[i] + (1 - alpha) * (level + trend);
      trend = beta * (level - prevLevel) + (1 - beta) * trend;
    }
    return result;
  }

  /// Triple exponential smoothing (Holt-Winters method).
  static List<num> tripleExponentialSmoothing(
    List<num> data,
    double alpha,
    double beta,
    double gamma,
    int period,
  ) {
    if (alpha < 0 ||
        alpha > 1 ||
        beta < 0 ||
        beta > 1 ||
        gamma < 0 ||
        gamma > 1) {
      throw ArgumentError('alpha, beta, and gamma must be between 0 and 1');
    }
    if (period <= 0 || period > data.length) {
      throw ArgumentError('Invalid period');
    }

    List<num> result = [];
    List<num> seasonal = List.filled(period, 0);

    // Initialize seasonal components
    for (int i = 0; i < period; i++) {
      seasonal[i] = data[i] / (data.reduce((a, b) => a + b) / data.length);
    }

    num level = data[0];
    num trend = 0;

    for (int i = 0; i < data.length; i++) {
      int seasonIndex = i % period;
      num forecast = (level + trend) * seasonal[seasonIndex];
      result.add(forecast);

      num prevLevel = level;
      level = alpha * (data[i] / seasonal[seasonIndex]) +
          (1 - alpha) * (level + trend);
      trend = beta * (level - prevLevel) + (1 - beta) * trend;
      seasonal[seasonIndex] =
          gamma * (data[i] / level) + (1 - gamma) * seasonal[seasonIndex];
    }

    return result;
  }

  /// Autocovariance at given lag.
  static num autocovariance(List<num> data, int lag) {
    if (lag < 0 || lag >= data.length) {
      throw ArgumentError('Invalid lag');
    }

    num mean = data.reduce((a, b) => a + b) / data.length;
    num sum = 0;
    int n = data.length - lag;

    for (int i = 0; i < n; i++) {
      sum += (data[i] - mean) * (data[i + lag] - mean);
    }

    return sum / data.length;
  }

  /// Autocorrelation at given lag.
  static num autocorrelation(List<num> data, int lag) {
    num acov0 = autocovariance(data, 0);
    if (acov0 == 0) return 0;
    return autocovariance(data, lag) / acov0;
  }

  /// Autocorrelation function up to maxLag.
  static List<num> acf(List<num> data, int maxLag) {
    List<num> result = [];
    for (int lag = 0; lag <= maxLag; lag++) {
      result.add(autocorrelation(data, lag));
    }
    return result;
  }

  /// Partial autocorrelation function (PACF) using Durbin-Levinson algorithm.
  static List<num> pacf(List<num> data, int maxLag) {
    List<num> acfValues = acf(data, maxLag);
    List<num> pacfValues = [1.0]; // PACF at lag 0 is always 1

    if (maxLag == 0) return pacfValues;

    // PACF at lag 1 is same as ACF at lag 1
    pacfValues.add(acfValues[1]);

    for (int k = 2; k <= maxLag; k++) {
      // Durbin-Levinson recursion
      num numerator = acfValues[k];
      num denominator = 1;

      for (int j = 1; j < k; j++) {
        numerator -= pacfValues[j] * acfValues[k - j];
      }

      for (int j = 1; j < k; j++) {
        denominator -= pacfValues[j] * acfValues[j];
      }

      num pacfK = numerator / denominator;
      pacfValues.add(pacfK);
    }

    return pacfValues;
  }

  /// Seasonal decomposition (additive model).
  static SeasonalDecomposition decompose(
    List<num> data,
    int period, {
    String model = 'additive',
  }) {
    if (period <= 0 || period > data.length) {
      throw ArgumentError('Invalid period');
    }

    int n = data.length;

    // Calculate trend using centered moving average
    List<num> trend = List.filled(n, 0.0);
    int halfWindow = period ~/ 2;

    for (int i = halfWindow; i < n - halfWindow; i++) {
      num sum = 0;
      for (int j = i - halfWindow; j <= i + halfWindow; j++) {
        sum += data[j];
      }
      trend[i] = sum / period;
    }

    // Fill edges with nearest values
    for (int i = 0; i < halfWindow; i++) {
      trend[i] = trend[halfWindow];
    }
    for (int i = n - halfWindow; i < n; i++) {
      trend[i] = trend[n - halfWindow - 1];
    }

    // Calculate detrended series
    List<num> detrended = [];
    if (model == 'additive') {
      for (int i = 0; i < n; i++) {
        detrended.add(data[i] - trend[i]);
      }
    } else {
      // Multiplicative
      for (int i = 0; i < n; i++) {
        detrended.add(trend[i] != 0 ? data[i] / trend[i] : 0);
      }
    }

    // Calculate seasonal component
    Map<int, List<num>> seasonalByPeriod = {};
    for (int i = 0; i < n; i++) {
      int seasonIndex = i % period;
      seasonalByPeriod.putIfAbsent(seasonIndex, () => []);
      seasonalByPeriod[seasonIndex]!.add(detrended[i]);
    }

    List<num> seasonalAvg = [];
    for (int i = 0; i < period; i++) {
      num avg = seasonalByPeriod[i]!.reduce((a, b) => a + b) /
          seasonalByPeriod[i]!.length;
      seasonalAvg.add(avg);
    }

    // Normalize seasonal component
    num seasonalSum = seasonalAvg.reduce((a, b) => a + b);
    if (model == 'additive') {
      num adjustment = seasonalSum / period;
      seasonalAvg = seasonalAvg.map((s) => s - adjustment).toList();
    }

    List<num> seasonal = [];
    for (int i = 0; i < n; i++) {
      seasonal.add(seasonalAvg[i % period]);
    }

    // Calculate residual
    List<num> residual = [];
    if (model == 'additive') {
      for (int i = 0; i < n; i++) {
        residual.add(data[i] - trend[i] - seasonal[i]);
      }
    } else {
      for (int i = 0; i < n; i++) {
        num expected = trend[i] * seasonal[i];
        residual.add(expected != 0 ? data[i] / expected : 0);
      }
    }

    return SeasonalDecomposition(
      trend: trend,
      seasonal: seasonal,
      residual: residual,
    );
  }

  /// Difference the series (for stationarity).
  static List<num> difference(List<num> data, {int lag = 1}) {
    if (lag <= 0 || lag >= data.length) {
      throw ArgumentError('Invalid lag');
    }

    List<num> result = [];
    for (int i = lag; i < data.length; i++) {
      result.add(data[i] - data[i - lag]);
    }
    return result;
  }
}
