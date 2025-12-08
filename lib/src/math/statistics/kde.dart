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

/// Kernel Density Estimation.
class KDE {
  final List<num> _data;
  late final double _bandwidth;

  /// Creates a KDE model.
  ///
  /// [data] is the input samples.
  /// [bandwidth] (optional) is the smoothing parameter.
  /// If null, uses Silverman's Rule.
  KDE(dynamic data, {double? bandwidth}) : _data = _toNumList(data) {
    if (_data.isEmpty) throw ArgumentError("Data cannot be empty");
    _bandwidth = bandwidth ?? _silvermanRule();
  }

  double _silvermanRule() {
    // 0.9 * min(std, IQR/1.34) * n^(-1/5)
    int n = _data.length;
    if (n == 1) return 1.0; // Default fallback

    // Calc std
    double mean = _data.reduce((a, b) => a + b) / n;
    double variance =
        _data.map((e) => (e - mean) * (e - mean)).reduce((a, b) => a + b) /
            (n - 1);
    double std = math.sqrt(variance);

    // Calc IQR
    List<num> sorted = List.from(_data)..sort();
    double q1 = _percentile(sorted, 25);
    double q3 = _percentile(sorted, 75);
    double iqr = q3 - q1;

    double sigma = std;
    if (iqr > 0) {
      sigma = math.min(std, iqr / 1.34);
    }

    return 0.9 * sigma * math.pow(n, -0.2);
  }

  double _percentile(List<num> sortedData, double percentile) {
    int n = sortedData.length;
    double index = (percentile / 100) * (n - 1);
    int lower = index.floor();
    int upper = index.ceil();
    if (lower == upper) return sortedData[lower].toDouble();
    double weight = index - lower;
    return sortedData[lower] * (1 - weight) + sortedData[upper] * weight;
  }

  /// Evaluates the PDF at [x].
  double pdf(num x) {
    double sum = 0;
    double h = _bandwidth;
    int n = _data.length;
    double c = 1.0 / (math.sqrt(2 * math.pi) * n * h);

    for (num xi in _data) {
      double z = (x - xi) / h;
      sum += math.exp(-0.5 * z * z);
    }
    return c * sum;
  }

  /// Evaluates the PDF for a list of points.
  List<double> evaluate(List<num> points) {
    return points.map((x) => pdf(x)).toList();
  }

  double get bandwidth => _bandwidth;
}
