part of 'interpolate.dart';

/// Barycentric Rational Interpolation.
///
/// Efficient and numerically stable method for polynomial interpolation.
/// Unlike Newton or Lagrange forms, it allows updating points in O(n) and evaluating in O(n).
/// It avoids Runge's phenomenon if using Chebyshev nodes (but this implementation works for arbitrary nodes).
class BarycentricInterpolator {
  final List<num> _x;
  final List<num> _y;
  late final List<num> _weights;

  /// Creates a BarycentricInterpolator.
  ///
  /// [x] and [y] are the data points. x values do not need to be sorted, but must be unique.
  BarycentricInterpolator(List<num> x, List<num> y)
      : _x = List.from(x),
        _y = List.from(y) {
    if (_x.length != _y.length) {
      throw ArgumentError('x and y must have the same length.');
    }
    if (_x.toSet().length != _x.length) {
      throw ArgumentError('x values must be unique.');
    }
    _computeWeights();
  }

  void _computeWeights() {
    int n = _x.length;
    _weights = List.filled(n, 0.0);

    for (int j = 0; j < n; j++) {
      num w = 1.0;
      for (int i = 0; i < n; i++) {
        if (i != j) {
          w *= (_x[j] - _x[i]);
        }
      }
      _weights[j] = 1.0 / w; // Standard Lagrange weights

      // Note: For equidistant points or Chebyshev points, there are faster formulas for weights,
      // but this O(n^2) method works for arbitrary points.
    }
  }

  /// Evaluates the interpolation polynomial at [xi].
  num interpolate(num xi) {
    num numSum = 0.0;
    num denSum = 0.0;

    for (int i = 0; i < _x.length; i++) {
      num diff = xi - _x[i];
      // Handle exact node match to avoid division by zero
      if (diff.abs() < 1e-15) {
        return _y[i];
      }
      num term = _weights[i] / diff;
      numSum += term * _y[i];
      denSum += term;
    }

    return numSum / denSum;
  }

  num call(num xi) => interpolate(xi);

  /// Add a point to the interpolation set.
  /// O(n) update for weights.
  void addPoint(num xNew, num yNew) {
    if (_x.contains(xNew)) throw ArgumentError("Point x=$xNew already exists");

    int n = _x.length;

    // Update existing weights
    for (int i = 0; i < n; i++) {
      _weights[i] /= (_x[i] - xNew);
    }

    // Calculate new weight
    num wNew = 1.0;
    for (int i = 0; i < n; i++) {
      wNew *= (xNew - _x[i]);
    }
    wNew = 1.0 / wNew;

    _x.add(xNew);
    _y.add(yNew);
    _weights.add(wNew);
  }
}
