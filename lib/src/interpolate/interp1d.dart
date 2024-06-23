part of 'interpolate.dart';

/// Provides interpolation for a 1-D function.
///
/// `x` and `y` are arrays of values used to approximate some function f: `y = f(x)`.
/// This class returns a function whose call method uses interpolation to find the value of new points.
///
/// Note:
/// - Calling `Interp1D` with NaNs present in input values results in undefined behaviour.
/// - Input values `x` and `y` must be convertible to `float` values like `int` or `float`.
/// - If the values in `x` are not unique, the resulting behavior is undefined and specific to the choice of `method`.
class Interp1D {
  List<num> x;
  List<num> y;
  MethodType method;
  bool throwOnOutOfBounds; // Renamed for clarity
  dynamic fillValue; // Can be num or 'extrapolate'
  bool copy;
  bool assumeSorted;

  // Cache for divided differences
  List<List<num>>? _dividedDifferences;

  /// Constructs an `Interp1D` object.
  ///
  /// [x] and [y] are arrays of values used to approximate some function f: `y = f(x)`.
  /// The [method] parameter specifies the kind of interpolation to use.
  /// If [throwOnOutOfBounds] is true, a `ValueError` is raised when interpolation is attempted on
  /// a value outside of the range of x (where extrapolation is necessary).
  /// [fillValue] determines the value to use or return when a value is out of bounds.
  /// If [copy] is set to true, the class will use a copy of the provided data.
  /// If [assumeSorted] is true, the class assumes the x values are already sorted.

  Interp1D(this.x, this.y,
      {this.method = MethodType.linear,
      this.throwOnOutOfBounds = true, // Renamed for clarity
      this.fillValue,
      this.copy = true,
      this.assumeSorted = false}) {
    if (x.length != y.length) {
      throw Exception('x and y must have the same length.');
    }
    if (_hasDuplicate(x)) {
      throw Exception('x values must be unique.');
    }
    if (!assumeSorted) {
      _sortXY();
    }
    x = copy ? List.from(x) : x;
    y = copy ? List.from(y) : y;
    fillValue = fillValue ?? double.nan;
    _validateDataForMethod();
  }

  /// Checks if the list contains any duplicate values.
  ///
  /// Returns `true` if duplicates are found, `false` otherwise.
  bool _hasDuplicate(List<num> list) {
    return list.toSet().length != list.length;
  }

  /// Interpolates the value based on the provided [xNew].
  ///
  /// Returns the interpolated value or the fill value depending on the settings.
  num call(num xNew) {
    if (xNew < x.first || xNew > x.last) {
      return _handleExtrapolation(xNew);
    }
    switch (method) {
      case MethodType.linear:
        return _linearInterpolation(xNew);
      case MethodType.nearest:
        return _nearestInterpolation(xNew);
      case MethodType.previous:
        return _previousInterpolation(xNew);
      case MethodType.next:
        return _nextInterpolation(xNew);
      case MethodType.quadratic:
        return _quadraticInterpolation(xNew);
      case MethodType.cubic:
        return _cubicInterpolation(xNew);
      case MethodType.newton:
        return _newtonInterpolation(xNew);
      default:
        throw Exception('Invalid interpolation method');
    }
  }

  /// Handles extrapolation for values outside the x range.
  ///
  /// Depending on the settings, this may throw an error, return a fill value, or extrapolate.
  num _handleExtrapolation(num xNew) {
    if (throwOnOutOfBounds && fillValue != 'extrapolate') {
      throw Exception('Value of xNew is out of the interpolation range');
    } else if (fillValue == 'extrapolate') {
      return _extrapolate(xNew);
    } else {
      return fillValue;
    }
  }

  /// Validates the provided data against the selected interpolation method.
  ///
  /// Throws an exception if there are insufficient data points for the chosen method.
  void _validateDataForMethod() {
    int requiredPoints;
    switch (method) {
      case MethodType.quadratic:
        requiredPoints = 3;
        break;
      case MethodType.cubic:
        requiredPoints = 4;
        break;
      default:
        requiredPoints = 2;
    }
    if (x.length < requiredPoints) {
      throw Exception(
          'Insufficient data points for the selected interpolation method.');
    }
  }

  /// Sorts x and y data, ensuring that x values are in ascending order.
  void _sortXY() {
    var zipped = x.asMap().entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    x = zipped.map((e) => e.value).toList();
    y = zipped.map((e) => y[e.key]).toList();
  }

  /// Computes the divided differences table used for Newton interpolation.
  ///
  /// Returns a list of lists representing the divided differences.
  List<List<num>> _computeDividedDifferences() {
    int n = x.length;
    List<List<num>> f = List.generate(n, (i) => List.filled(n, 0.0));
    for (int i = 0; i < n; i++) {
      f[i][0] = y[i];
    }
    for (int j = 1; j < n; j++) {
      for (int i = 0; i < n - j; i++) {
        f[i][j] = (f[i + 1][j - 1] - f[i][j - 1]) / (x[i + j] - x[i]);
      }
    }
    return f;
  }

  /// Interpolates using the Newton method.
  ///
  /// [xNew] is the new x value for which the y value will be interpolated.
  num _newtonInterpolation(num xNew) {
    _dividedDifferences ??= _computeDividedDifferences();
    List<List<num>> f = _dividedDifferences!;
    num result = f[0][0];
    num term = 1;
    for (int i = 1; i < x.length; i++) {
      term *= (xNew - x[i - 1]);
      result += term * f[0][i];
    }
    return result;
  }

  /// Interpolates using the cubic method.
  ///
  /// [xNew] is the new x value for which the y value will be interpolated.
  num _cubicInterpolation(num xNew) {
    int index = x.indexWhere((num e) => e >= xNew);

    // Ensure there are three points before and one after, or three after and one before.
    if (index < 3) index = 3;
    if (index > x.length - 1) index = x.length - 1;

    num x0 = x[index - 3];
    num x1 = x[index - 2];
    num x2 = x[index - 1];
    num x3 = x[index];
    num y0 = y[index - 3];
    num y1 = y[index - 2];
    num y2 = y[index - 1];
    num y3 = y[index];

    // Apply the Lagrange interpolation formula for cubic polynomial
    num p0 = y0 *
        (xNew - x1) *
        (xNew - x2) *
        (xNew - x3) /
        ((x0 - x1) * (x0 - x2) * (x0 - x3));
    num p1 = y1 *
        (xNew - x0) *
        (xNew - x2) *
        (xNew - x3) /
        ((x1 - x0) * (x1 - x2) * (x1 - x3));
    num p2 = y2 *
        (xNew - x0) *
        (xNew - x1) *
        (xNew - x3) /
        ((x2 - x0) * (x2 - x1) * (x2 - x3));
    num p3 = y3 *
        (xNew - x0) *
        (xNew - x1) *
        (xNew - x2) /
        ((x3 - x0) * (x3 - x1) * (x3 - x2));

    return p0 + p1 + p2 + p3;
  }

  /// Interpolates using the quadratic method.
  ///
  /// [xNew] is the new x value for which the y value will be interpolated.
  num _quadraticInterpolation(num xNew) {
    int index = x.indexWhere((num e) => e >= xNew);

    // Ensure there are two points before and one after, or two after and one before.
    if (index < 2) index = 2;
    if (index > x.length - 1) index = x.length - 1;

    num x0 = x[index - 2];
    num x1 = x[index - 1];
    num x2 = x[index];
    num y0 = y[index - 2];
    num y1 = y[index - 1];
    num y2 = y[index];

    // Apply the Lagrange interpolation formula for quadratic polynomial
    num p0 = y0 * (xNew - x1) * (xNew - x2) / ((x0 - x1) * (x0 - x2));
    num p1 = y1 * (xNew - x0) * (xNew - x2) / ((x1 - x0) * (x1 - x2));
    num p2 = y2 * (xNew - x0) * (xNew - x1) / ((x2 - x0) * (x2 - x1));

    return p0 + p1 + p2;
  }

  /// Interpolates using the linear method.
  ///
  /// [xNew] is the new x value for which the y value will be interpolated.
  num _linearInterpolation(num xNew) {
    int index = x.indexWhere((num e) => e >= xNew);
    if (index == 0) return y[0];
    num x0 = x[index - 1];
    num x1 = x[index];
    num y0 = y[index - 1];
    num y1 = y[index];
    return y0 + (y1 - y0) * (xNew - x0) / (x1 - x0);
  }

  /// Interpolates using the nearest method.
  ///
  /// [xNew] is the new x value for which the y value will be interpolated.
  num _nearestInterpolation(num xNew) {
    int index = x.indexWhere((num e) => e >= xNew);
    if (index == 0) return y[0];
    num x0 = x[index - 1];
    num x1 = x[index];
    if ((xNew - x0) < (x1 - xNew)) {
      return y[index - 1];
    } else {
      return y[index];
    }
  }

  /// Interpolates using the previous value method.
  ///
  /// [xNew] is the new x value for which the previous y value will be returned.
  num _previousInterpolation(num xNew) {
    int index = x.indexWhere((num e) => e >= xNew);
    if (index == 0) return y[0];
    return y[index - 1];
  }

  /// Interpolates using the next value method.
  ///
  /// [xNew] is the new x value for which the next y value will be returned.
  num _nextInterpolation(num xNew) {
    int index = x.indexWhere((num e) => e >= xNew);
    if (index == 0) return y[0];
    if (index == x.length - 1) return y.last;
    return y[index];
  }

  /// Extrapolates the value based on the provided [xNew].
  ///
  /// Uses a linear extrapolation based on the first or last two points.
  num _extrapolate(num xNew) {
    // Using a linear extrapolation based on the first or last two points.
    if (xNew < x.first) {
      num x0 = x[0];
      num x1 = x[1];
      num y0 = y[0];
      num y1 = y[1];
      num slope = (y1 - y0) / (x1 - x0);
      return y0 - slope * (x0 - xNew);
    } else if (xNew > x.last) {
      num x0 = x[x.length - 2];
      num x1 = x.last;
      num y0 = y[y.length - 2];
      num y1 = y.last;
      num slope = (y1 - y0) / (x1 - x0);
      return y1 + slope * (xNew - x1);
    }
    return double.nan; // This should not be reached.
  }
}
