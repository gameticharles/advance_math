part of 'interpolate.dart';

/// Provides interpolation for a 2-D function.
///
/// `x` and `y` are arrays of values representing the grid over which `z` is defined.
/// `z` is a 2D grid of values used to approximate some function f: `z = f(x, y)`.
/// This class returns a function whose call method uses interpolation to find the value of new points.
class Interp2D {
  List<num> x;
  List<num> y;
  List<List<num>> z;
  MethodType method;
  bool throwOnOutOfBounds;
  dynamic fillValue; // Can be num or 'extrapolate'
  bool copy;
  bool assumeSorted;

  Interp2D(this.x, this.y, this.z,
      {this.method = MethodType.linear,
      this.throwOnOutOfBounds = true,
      this.fillValue,
      this.assumeSorted = false,
      this.copy = true}) {
    // Validation and Initialization
    if (x.length != z.length) {
      throw Exception('x and z must have the same number of rows.');
    }
    if (y.length != z[0].length) {
      throw Exception('y and z must have the same number of columns.');
    }
    if (_hasDuplicate(x) || _hasDuplicate(y)) {
      throw Exception('x and y values must be unique.');
    }

    if (!assumeSorted) {
      _sortXY();
    }

    x = copy ? List.from(x) : x;
    y = copy ? List.from(y) : y;
    z = copy ? z.map((row) => List<num>.from(row)).toList() : z;
    fillValue = fillValue ?? double.nan;
  }

  /// Checks if the list contains any duplicate values.
  ///
  /// Returns `true` if duplicates are found, `false` otherwise.
  bool _hasDuplicate(List<num> list) {
    return list.toSet().length != list.length;
  }

  /// Sorts x and y data, ensuring that x values are in ascending order.
  void _sortXY() {
    var zippedX = x.asMap().entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    x = zippedX.map((e) => e.value).toList();
    z = zippedX.map((e) => z[e.key]).toList();

    var zippedY = y.asMap().entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    y = zippedY.map((e) => e.value).toList();
    for (int i = 0; i < z.length; i++) {
      var sortedRow = zippedY.map((e) => z[i][e.key]).toList();
      z[i] = sortedRow;
    }
  }

  /// Interpolates the value based on the provided [xNew] and [yNew].
  ///
  /// Returns the interpolated value or the fill value depending on the settings.
  num call(num xNew, num yNew) {
    if (xNew < x.first || xNew > x.last || yNew < y.first || yNew > y.last) {
      return _handleExtrapolation(xNew, yNew);
    }

    switch (method) {
      case MethodType.linear:
        return _bilinearInterpolation(xNew, yNew);
      case MethodType.nearest:
        return _nearestInterpolation(xNew, yNew);
      case MethodType.previous:
        return _previousInterpolation(xNew, yNew);
      case MethodType.next:
        return _nextInterpolation(xNew, yNew);
      case MethodType.quadratic:
        return _quadraticInterpolation(xNew, yNew);
      case MethodType.cubic:
        return _cubicInterpolation(xNew, yNew);
      case MethodType.newton:
        return _newtonInterpolation(xNew, yNew);
    }
  }

  /// Handles extrapolation for values outside the x-y grid.
  ///
  /// Depending on the settings, this may throw an error or return a fill value.
  num _handleExtrapolation(num xNew, num yNew) {
    if (throwOnOutOfBounds && fillValue != 'extrapolate') {
      throw Exception(
          'Value of (xNew, yNew) is out of the interpolation range');
    } else if (fillValue == 'extrapolate') {
      return _extrapolate(xNew, yNew);
    } else {
      return fillValue;
    }
  }

  /// Performs bilinear interpolation based on the provided [xNew] and [yNew].
  num _bilinearInterpolation(num xNew, num yNew) {
    int xIndex = x.indexWhere((num e) => e >= xNew) - 1;
    int yIndex = y.indexWhere((num e) => e >= yNew) - 1;

    // Add boundary checks
    if (xIndex < 0) xIndex = 0;
    if (xIndex >= x.length - 1) xIndex = x.length - 2;
    if (yIndex < 0) yIndex = 0;
    if (yIndex >= y.length - 1) yIndex = y.length - 2;

    // Bounding coordinates
    num x0 = x[xIndex];
    num x1 = x[xIndex + 1];
    num y0 = y[yIndex];
    num y1 = y[yIndex + 1];

    // Z values of the bounding square
    num z00 = z[xIndex][yIndex];
    num z01 = z[xIndex][yIndex + 1];
    num z10 = z[xIndex + 1][yIndex];
    num z11 = z[xIndex + 1][yIndex + 1];

    // Linear interpolation in the x direction
    num z0 = z00 + (z10 - z00) * (xNew - x0) / (x1 - x0);
    num z1 = z01 + (z11 - z01) * (xNew - x0) / (x1 - x0);

    // Linear interpolation in the y direction using the results from the x interpolation
    return z0 + (z1 - z0) * (yNew - y0) / (y1 - y0);
  }

  num _nearestInterpolation(num xNew, num yNew) {
    int xIndex = x.indexWhere((num e) => e >= xNew);
    int yIndex = y.indexWhere((num e) => e >= yNew);

    if (xIndex > 0 && (xNew - x[xIndex - 1]).abs() < (xNew - x[xIndex]).abs()) {
      xIndex -= 1;
    }

    if (yIndex > 0 && (yNew - y[yIndex - 1]).abs() < (yNew - y[yIndex]).abs()) {
      yIndex -= 1;
    }

    return z[xIndex][yIndex];
  }

  num _previousInterpolation(num xNew, num yNew) {
    int xIndex = x.indexWhere((num e) => e >= xNew) - 1;
    int yIndex = y.indexWhere((num e) => e >= yNew) - 1;

    if (xIndex < 0) xIndex = 0;
    if (yIndex < 0) yIndex = 0;

    return z[xIndex][yIndex];
  }

  num _nextInterpolation(num xNew, num yNew) {
    int xIndex = x.indexWhere((num e) => e >= xNew);
    int yIndex = y.indexWhere((num e) => e >= yNew);

    if (xIndex >= x.length) xIndex = x.length - 1;
    if (yIndex >= y.length) yIndex = y.length - 1;

    return z[xIndex][yIndex];
  }

  num _quadraticInterpolation(num xNew, num yNew) {
    int xIndex = x.indexWhere((num e) => e >= xNew);
    int yIndex = y.indexWhere((num e) => e >= yNew);

    // Ensure there are two points before and one after, or two after and one before.
    if (xIndex < 2) xIndex = 2;
    if (xIndex > x.length - 1) xIndex = x.length - 1;
    if (yIndex < 2) yIndex = 2;
    if (yIndex > y.length - 1) yIndex = y.length - 1;

    // Interpolate in x direction for each y
    List<num> interpX = [];
    for (int i = -1; i <= 1; i++) {
      interpX.add(_quadraticInterp1D(
          xNew,
          x.sublist(xIndex - 2, xIndex + 1),
          z
              .sublist(xIndex - 2, xIndex + 1)
              .map((row) => row[yIndex + i])
              .toList()));
    }

    // Interpolate in y direction using the results
    return _quadraticInterp1D(yNew, y.sublist(yIndex - 1, yIndex + 2), interpX);
  }

  num _quadraticInterp1D(num xNew, List<num> x, List<num> y) {
    num p0 =
        y[0] * (xNew - x[1]) * (xNew - x[2]) / ((x[0] - x[1]) * (x[0] - x[2]));
    num p1 =
        y[1] * (xNew - x[0]) * (xNew - x[2]) / ((x[1] - x[0]) * (x[1] - x[2]));
    num p2 =
        y[2] * (xNew - x[0]) * (xNew - x[1]) / ((x[2] - x[0]) * (x[2] - x[1]));

    return p0 + p1 + p2;
  }

  num _cubicInterpolation(num xNew, num yNew) {
    int xIndex = x.indexWhere((num e) => e >= xNew);
    int yIndex = y.indexWhere((num e) => e >= yNew);

    // Ensure there are three points before and one after, or three after and one before.
    if (xIndex < 3) xIndex = 3;
    if (xIndex > x.length - 1) xIndex = x.length - 1;
    if (yIndex < 3) yIndex = 3;
    if (yIndex > y.length - 1) yIndex = y.length - 1;

    // Interpolate in x direction for each y
    List<num> interpX = [];
    for (int i = -2; i <= 1; i++) {
      interpX.add(_cubicInterp1D(
          xNew,
          x.sublist(xIndex - 3, xIndex + 1),
          z
              .sublist(xIndex - 3, xIndex + 1)
              .map((row) => row[yIndex + i])
              .toList()));
    }

    // Interpolate in y direction using the results
    return _cubicInterp1D(yNew, y.sublist(yIndex - 2, yIndex + 2), interpX);
  }

  num _cubicInterp1D(num xNew, List<num> x, List<num> y) {
    num p0 = y[0] *
        (xNew - x[1]) *
        (xNew - x[2]) *
        (xNew - x[3]) /
        ((x[0] - x[1]) * (x[0] - x[2]) * (x[0] - x[3]));
    num p1 = y[1] *
        (xNew - x[0]) *
        (xNew - x[2]) *
        (xNew - x[3]) /
        ((x[1] - x[0]) * (x[1] - x[2]) * (x[1] - x[3]));
    num p2 = y[2] *
        (xNew - x[0]) *
        (xNew - x[1]) *
        (xNew - x[3]) /
        ((x[2] - x[0]) * (x[2] - x[1]) * (x[2] - x[3]));
    num p3 = y[3] *
        (xNew - x[0]) *
        (xNew - x[1]) *
        (xNew - x[2]) /
        ((x[3] - x[0]) * (x[3] - x[1]) * (x[3] - x[2]));

    return p0 + p1 + p2 + p3;
  }

  num _newtonInterpolation(num xNew, num yNew) {
    int yIndex = y.indexWhere((num e) => e >= yNew);

    // Ensure there are enough points in y direction for interpolation
    if (yIndex < 0) yIndex = 1;
    if (yIndex > y.length - 1) yIndex = y.length - 1;

    // Interpolate in x direction for each y
    List<num> interpX = [];
    for (int i = 0; i < y.length; i++) {
      interpX.add(_newtonInterp1D(xNew, x, z.map((row) => row[i]).toList()));
    }

    // Interpolate in y direction using the results
    return _newtonInterp1D(yNew, y, interpX);
  }

  num _newtonInterp1D(num xNew, List<num> x, List<num> y) {
    List<List<num>> f = _computeDividedDifferences(x, y);

    num result = f[0][0];
    num term = 1;
    for (int i = 1; i < x.length; i++) {
      term *= (xNew - x[i - 1]);
      result += term * f[0][i];
    }

    return result;
  }

  List<List<num>> _computeDividedDifferences(List<num> x, List<num> y) {
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

  /// Performs extrapolation based on the provided [xNew] and [yNew].
  num _extrapolate(num xNew, num yNew) {
    // Determine the direction of extrapolation
    bool extrapolateRight = xNew > x.last;
    bool extrapolateUp = yNew > y.last;

    // Determine the indices of the last two x and y values
    int xIndex1 = extrapolateRight ? x.length - 1 : 0;
    int xIndex2 = extrapolateRight ? x.length - 2 : 1;
    int yIndex1 = extrapolateUp ? y.length - 1 : 0;
    int yIndex2 = extrapolateUp ? y.length - 2 : 1;

    // Calculate the gradient in the x and y direction based on the z-values of the last two points
    num gradientX =
        (z[xIndex1][yIndex1] - z[xIndex2][yIndex1]) / (x[xIndex1] - x[xIndex2]);
    num gradientY =
        (z[xIndex1][yIndex1] - z[xIndex1][yIndex2]) / (y[yIndex1] - y[yIndex2]);

    // Compute the extrapolated z-values based on the gradients
    num extrapolatedValueX =
        z[xIndex1][yIndex1] + gradientX * (xNew - x[xIndex1]);
    num extrapolatedValueY =
        z[xIndex1][yIndex1] + gradientY * (yNew - y[yIndex1]);

    // Return the average of the extrapolated values in both directions
    return (extrapolatedValueX + extrapolatedValueY) / 2;
  }
}
