import 'package:dartframe/dartframe.dart';
import 'dart:math' as math;

/// Statistical extensions for NDArray.
extension NDArrayStats on NDArray {
  /// Helper to get data as `List<num>`.
  List<num> get _dataList {
    return toFlatList().map((e) => e as num).toList();
  }

  /// Variance (sample).
  double get variance {
    final d = _dataList;
    if (d.length < 2) return double.nan;

    // Calculate mean manually to avoid dependency on external extensions
    double sum = d.reduce((a, b) => a + b).toDouble();
    double m = sum / d.length;

    double sumSq =
        d.map((e) => math.pow(e - m, 2)).reduce((a, b) => a + b).toDouble();
    return sumSq / (d.length - 1);
  }

  /// Standard Deviation.
  double get stdDev {
    return math.sqrt(variance);
  }
}
