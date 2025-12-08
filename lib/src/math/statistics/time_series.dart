import 'package:dartframe/dartframe.dart';

/// Result of seasonal decomposition.
class SeasonalDecomposition {
  final Series trend;
  final Series seasonal;
  final Series residual;

  SeasonalDecomposition({
    required this.trend,
    required this.seasonal,
    required this.residual,
  });
}

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

/// Time series analysis methods.
class TimeSeries {
  /// Simple moving average.
  static Series movingAverage(dynamic data, int window) {
    List<num> d = _toNumList(data);
    if (window <= 0 || window > d.length) {
      throw ArgumentError('Invalid window size');
    }

    List<num> result = [];
    for (int i = 0; i <= d.length - window; i++) {
      num sum = 0;
      for (int j = 0; j < window; j++) {
        sum += d[i + j];
      }
      result.add(sum / window);
    }
    return Series(result, name: 'moving_average');
  }

  /// Exponential smoothing (single exponential smoothing).
  static Series exponentialSmoothing(dynamic data, double alpha) {
    List<num> d = _toNumList(data);
    if (alpha < 0 || alpha > 1) {
      throw ArgumentError('alpha must be between 0 and 1');
    }

    List<num> result = [d[0]];
    for (int i = 1; i < d.length; i++) {
      num smoothed = alpha * d[i] + (1 - alpha) * result[i - 1];
      result.add(smoothed);
    }
    return Series(result, name: 'exponential_smoothing');
  }

  /// Double exponential smoothing (Holt's method).
  static Series doubleExponentialSmoothing(
    dynamic data,
    double alpha,
    double beta,
  ) {
    List<num> d = _toNumList(data);
    if (alpha < 0 || alpha > 1 || beta < 0 || beta > 1) {
      throw ArgumentError('alpha and beta must be between 0 and 1');
    }

    List<num> result = [];
    num level = d[0];
    num trend = d.length > 1 ? d[1] - d[0] : 0;

    for (int i = 0; i < d.length; i++) {
      result.add(level + trend);

      num prevLevel = level;
      level = alpha * d[i] + (1 - alpha) * (level + trend);
      trend = beta * (level - prevLevel) + (1 - beta) * trend;
    }
    return Series(result, name: 'double_exponential_smoothing');
  }

  /// Triple exponential smoothing (Holt-Winters method).
  static Series tripleExponentialSmoothing(
    dynamic data,
    double alpha,
    double beta,
    double gamma,
    int period,
  ) {
    List<num> d = _toNumList(data);
    if (alpha < 0 ||
        alpha > 1 ||
        beta < 0 ||
        beta > 1 ||
        gamma < 0 ||
        gamma > 1) {
      throw ArgumentError('alpha, beta, and gamma must be between 0 and 1');
    }
    if (period <= 0 || period > d.length) {
      throw ArgumentError('Invalid period');
    }

    List<num> result = [];
    List<num> seasonal = List.filled(period, 0);

    // Initialize seasonal components
    for (int i = 0; i < period; i++) {
      seasonal[i] = d[i] / (d.reduce((a, b) => a + b) / d.length);
    }

    num level = d[0];
    num trend = 0;

    for (int i = 0; i < d.length; i++) {
      int seasonIndex = i % period;
      num forecast = (level + trend) * seasonal[seasonIndex];
      result.add(forecast);

      num prevLevel = level;
      level = alpha * (d[i] / seasonal[seasonIndex]) +
          (1 - alpha) * (level + trend);
      trend = beta * (level - prevLevel) + (1 - beta) * trend;
      seasonal[seasonIndex] =
          gamma * (d[i] / level) + (1 - gamma) * seasonal[seasonIndex];
    }

    return Series(result, name: 'triple_exponential_smoothing');
  }

  /// Autocovariance at given lag.
  static num autocovariance(dynamic data, int lag) {
    List<num> d = _toNumList(data);
    if (lag < 0 || lag >= d.length) {
      throw ArgumentError('Invalid lag');
    }

    num mean = d.reduce((a, b) => a + b) / d.length;
    num sum = 0;
    int n = d.length - lag;

    for (int i = 0; i < n; i++) {
      sum += (d[i] - mean) * (d[i + lag] - mean);
    }

    return sum / d.length;
  }

  /// Autocorrelation at given lag.
  static num autocorrelation(dynamic data, int lag) {
    // Note: Recursive calls (acf/pacf) might re-convert list if we just pass 'data'.
    // However, autocovariance calls _toNumList again, which is efficient if list is reused? No.
    // Ideally we convert once. But for API simplicity 'dynamic' is fine.
    // Actually, 'autocovariance' is static so passing 'data' (List) works fine.
    num acov0 = autocovariance(data, 0);
    if (acov0 == 0) return 0;
    return autocovariance(data, lag) / acov0;
  }

  /// Autocorrelation function up to maxLag.
  static Series acf(dynamic data, int maxLag) {
    List<num> d = _toNumList(data);
    List<num> result = [];
    for (int lag = 0; lag <= maxLag; lag++) {
      result.add(autocorrelation(d, lag));
    }
    return Series(result, name: 'acf');
  }

  /// Partial autocorrelation function (PACF) using Durbin-Levinson algorithm.
  static Series pacf(dynamic data, int maxLag) {
    List<num> acfValues = acf(data, maxLag).data.cast<num>().toList();
    List<num> pacfValues = [1.0]; // PACF at lag 0 is always 1

    if (maxLag == 0) return Series(pacfValues, name: 'pacf');

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

    return Series(pacfValues, name: 'pacf');
  }

  /// Seasonal decomposition (additive model).
  static SeasonalDecomposition decompose(
    dynamic data,
    int period, {
    String model = 'additive',
  }) {
    List<num> d = _toNumList(data);
    if (period <= 0 || period > d.length) {
      throw ArgumentError('Invalid period');
    }

    int n = d.length;

    // Calculate trend using centered moving average
    List<num> trend = List.filled(n, 0.0);
    int halfWindow = period ~/ 2;

    for (int i = halfWindow; i < n - halfWindow; i++) {
      num sum = 0;
      for (int j = i - halfWindow; j <= i + halfWindow; j++) {
        sum += d[j];
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
        detrended.add(d[i] - trend[i]);
      }
    } else {
      // Multiplicative
      for (int i = 0; i < n; i++) {
        detrended.add(trend[i] != 0 ? d[i] / trend[i] : 0);
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
        residual.add(d[i] - trend[i] - seasonal[i]);
      }
    } else {
      for (int i = 0; i < n; i++) {
        num expected = trend[i] * seasonal[i];
        residual.add(expected != 0 ? d[i] / expected : 0);
      }
    }

    return SeasonalDecomposition(
      trend: Series(trend, name: 'trend'),
      seasonal: Series(seasonal, name: 'seasonal'),
      residual: Series(residual, name: 'residual'),
    );
  }

  /// Difference the series (for stationarity).
  static Series difference(dynamic data, {int lag = 1}) {
    List<num> d = _toNumList(data);
    if (lag <= 0 || lag >= d.length) {
      throw ArgumentError('Invalid lag');
    }

    List<num> result = [];
    for (int i = lag; i < d.length; i++) {
      result.add(d[i] - d[i - lag]);
    }
    return Series(result, name: 'difference');
  }
}
