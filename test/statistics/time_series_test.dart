import 'package:advance_math/src/math/statistics/time_series.dart';
import 'package:test/test.dart';
import 'dart:math' as math;

void main() {
  group('Time Series - Smoothing', () {
    test('Moving average', () {
      List<num> data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      var ma = TimeSeries.movingAverage(data, 3);

      expect(ma[0], equals(2)); // (1+2+3)/3
      expect(ma[1], equals(3)); // (2+3+4)/3
      expect(ma.length, equals(8)); // 10 - 3 + 1
    });

    test('Exponential smoothing', () {
      List<num> data = [10, 12, 11, 13, 12, 14];
      var smoothed = TimeSeries.exponentialSmoothing(data, 0.5);

      expect(smoothed[0], equals(10)); // First value unchanged
      expect(smoothed.length, equals(data.length));

      // Values should be smoothed
      expect(smoothed[1], closeTo(11, 0.1)); // 0.5*12 + 0.5*10
    });

    test('Double exponential smoothing', () {
      List<num> data = [10, 12, 14, 16, 18, 20];
      var smoothed = TimeSeries.doubleExponentialSmoothing(data, 0.6, 0.3);

      expect(smoothed.length, equals(data.length));
      // Should capture trend
      expect(smoothed.data.last, greaterThan(smoothed.data.first));
    });
  });

  group('Time Series - Autocorrelation', () {
    test('Autocovariance at lag 0 equals variance', () {
      List<num> data = [1, 2, 3, 4, 5];
      num acov0 = TimeSeries.autocovariance(data, 0);

      num mean = data.reduce((a, b) => a + b) / data.length;
      num variance =
          data.map((x) => (x - mean) * (x - mean)).reduce((a, b) => a + b) /
              data.length;

      expect(acov0, closeTo(variance, 1e-10));
    });

    test('Autocorrelation at lag 0 is 1', () {
      List<num> data = [1, 2, 3, 4, 5];
      num ac0 = TimeSeries.autocorrelation(data, 0);

      expect(ac0, equals(1));
    });

    test('ACF returns correct length', () {
      List<num> data = [1, 2, 3, 4, 5, 6, 7, 8];
      var acfValues = TimeSeries.acf(data, 5);

      expect(acfValues.length, equals(6)); // 0 to 5 inclusive
      expect(acfValues[0], equals(1)); // Lag 0
    });

    test('ACF for trending data', () {
      List<num> data = List.generate(100, (i) => i * 1.0); // Linear trend
      var acfValues = TimeSeries.acf(data, 10);

      // ACF should decay slowly for trending data
      expect(acfValues[1], greaterThan(0.8));
      expect(acfValues[5], greaterThan(0.5));
    });

    test('PACF at lag 0 is 1', () {
      List<num> data = [1, 2, 3, 4, 5];
      var pacfValues = TimeSeries.pacf(data, 3);

      expect(pacfValues[0], equals(1));
      expect(pacfValues.length, equals(4)); // 0 to 3
    });
  });

  group('Time Series - Decomposition', () {
    test('Seasonal decomposition with known pattern', () {
      // Create data with trend and seasonality
      List<num> data = [];
      for (int i = 0; i < 24; i++) {
        num trend = i * 2.0;
        num seasonal = math.sin(i * 2 * math.pi / 12) * 5;
        num noise = (i % 2 == 0) ? 0.5 : -0.5;
        data.add(trend + seasonal + noise);
      }

      var decomp = TimeSeries.decompose(data, 12);

      expect(decomp.trend.length, equals(24));
      expect(decomp.seasonal.length, equals(24));
      expect(decomp.residual.length, equals(24));

      // Trend should be increasing
      expect(decomp.trend.data.last, greaterThan(decomp.trend.data.first));

      // Seasonal component should repeat
      expect(decomp.seasonal[0], closeTo(decomp.seasonal[12], 1.0));
    });

    test('Decomposition preserves data sum (additive)', () {
      List<num> data = [10, 12, 11, 15, 13, 16, 14, 18, 16, 20, 18, 22];
      var decomp = TimeSeries.decompose(data, 4);

      // For additive: data ≈ trend + seasonal + residual
      for (int i = 0; i < data.length; i++) {
        num reconstructed =
            decomp.trend[i] + decomp.seasonal[i] + decomp.residual[i];
        expect(reconstructed, closeTo(data[i], 0.5));
      }
    });
  });

  group('Time Series - Differencing', () {
    test('First difference', () {
      List<num> data = [1, 3, 6, 10, 15];
      var diff = TimeSeries.difference(data);

      expect(diff.data, equals([2, 3, 4, 5])); // Differences
      expect(diff.length, equals(data.length - 1));
    });

    test('Second difference', () {
      List<num> data = [1, 3, 6, 10, 15];
      var diff1 = TimeSeries.difference(data);
      var diff2 = TimeSeries.difference(diff1.data.cast<num>().toList());

      expect(diff2.data, equals([1, 1, 1])); // Constant second differences
    });
  });
}
