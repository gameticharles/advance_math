part of 'interpolate.dart';

/// Type of spline interpolation.
enum SplineType {
  /// Linear interpolation (C0 continuity).
  linear,

  /// Cubic spline with natural boundary conditions (2nd derivative is 0 at ends).
  /// Requires solving a linear system. Smooth C2 continuity.
  naturalCubic,

  /// Monotone Cubic Hermite Interpolation (PCHIP).
  /// Preserves monotonicity of the data. C1 continuity.
  monotoneCubic,

  /// Akima spline.
  /// Stable to outliers, less oscillation than cubic splines. C1 continuity.
  akima,
}

/// A class for performing spline interpolation.
///
/// Supports piecewise polynomial interpolation including Cubic Splines,
/// Monotone Cubic Hermite Interpolation (PCHIP), and Akima Splines.
class SplineInterpolator {
  final List<num> _x;
  final List<num> _y;
  final SplineType _type;

  late final List<num> _a; // Coefficients for (x-xi)^0 (which is yi)
  late final List<num> _b; // Coefficients for (x-xi)^1
  late final List<num> _c; // Coefficients for (x-xi)^2
  late final List<num> _d; // Coefficients for (x-xi)^3

  /// Creates a SplineInterpolator.
  ///
  /// [x] and [y] are the data points. They must have the same length and
  /// [x] must be strictly increasing.
  SplineInterpolator(List<num> x, List<num> y,
      {SplineType type = SplineType.naturalCubic})
      : _x = List.from(x),
        _y = List.from(y),
        _type = type {
    if (_x.length != _y.length) {
      throw ArgumentError('x and y must have the same length.');
    }
    if (_x.length < 2) {
      throw ArgumentError('At least 2 points are required for interpolation.');
    }
    for (int i = 0; i < _x.length - 1; i++) {
      if (_x[i] >= _x[i + 1]) {
        throw ArgumentError('x values must be strictly increasing.');
      }
    }

    _computeCoefficients();
  }

  /// Calculates the interpolated value at [xi].
  num interpolate(num xi) {
    if (xi < _x.first || xi > _x.last) {
      // Simple linear extrapolation for now, or clamp?
      // Let's stick to extrapolation using the first/last polynomial segment.
    }

    // Binary search to find the interval
    int i = _findInterval(xi);

    num dx = xi - _x[i];
    return _a[i] + _b[i] * dx + _c[i] * dx * dx + _d[i] * dx * dx * dx;
  }

  /// Helper to make the class callable.
  num call(num xi) => interpolate(xi);

  int _findInterval(num xi) {
    int left = 0;
    int right = _x.length - 2; // Last interval starts at n-2

    // Clamp to range boundaries for extrapolation
    if (xi < _x.first) return 0;
    if (xi >= _x.last) return _x.length - 2;

    while (left <= right) {
      int mid = (left + right) ~/ 2;
      if (xi >= _x[mid] && xi < _x[mid + 1]) {
        return mid;
      } else if (xi < _x[mid]) {
        right = mid - 1;
      } else {
        left = mid + 1;
      }
    }
    return _x.length - 2; // Should typically satisfy loop, fallback.
  }

  void _computeCoefficients() {
    int n = _x.length - 1; // Number of segments
    _a = List<num>.filled(n + 1, 0.0);
    _b = List<num>.filled(n, 0.0);
    _c = List<num>.filled(n + 1, 0.0);
    _d = List<num>.filled(n, 0.0);

    for (int i = 0; i <= n; i++) {
      _a[i] = _y[i];
    }

    // Step sizes
    List<num> h = List<num>.filled(n, 0.0);
    for (int i = 0; i < n; i++) {
      h[i] = _x[i + 1] - _x[i];
    }

    switch (_type) {
      case SplineType.linear:
        _computeLinear(n, h);
        break;
      case SplineType.naturalCubic:
        _computeNaturalCubic(n, h);
        break;
      case SplineType.monotoneCubic:
        _computePCHIP(n, h);
        break;
      case SplineType.akima:
        _computeAkima(n, h);
        break;
    }
  }

  void _computeLinear(int n, List<num> h) {
    for (int i = 0; i < n; i++) {
      _b[i] = (_y[i + 1] - _y[i]) / h[i];
      _c[i] = 0;
      _d[i] = 0;
    }
  }

  void _computeNaturalCubic(int n, List<num> h) {
    // Solve for c coefficients (moments / 2nd derivatives)
    // System A*c = rhs
    List<num> alpha = List<num>.filled(n, 0.0);
    for (int i = 1; i < n; i++) {
      alpha[i] = 3.0 / h[i] * (_a[i + 1] - _a[i]) -
          3.0 / h[i - 1] * (_a[i] - _a[i - 1]);
    }

    List<num> l = List<num>.filled(n + 1, 0.0);
    List<num> mu = List<num>.filled(n + 1, 0.0);
    List<num> z = List<num>.filled(n + 1, 0.0);

    l[0] = 1.0;
    mu[0] = 0.0;
    z[0] = 0.0;

    for (int i = 1; i < n; i++) {
      l[i] = 2.0 * (_x[i + 1] - _x[i - 1]) - h[i - 1] * mu[i - 1];
      mu[i] = h[i] / l[i];
      z[i] = (alpha[i] - h[i - 1] * z[i - 1]) / l[i];
    }

    l[n] = 1.0;
    z[n] = 0.0;
    _c[n] = 0.0;

    for (int j = n - 1; j >= 0; j--) {
      _c[j] = z[j] - mu[j] * _c[j + 1];
      _b[j] =
          (_a[j + 1] - _a[j]) / h[j] - h[j] * (_c[j + 1] + 2.0 * _c[j]) / 3.0;
      _d[j] = (_c[j + 1] - _c[j]) / (3.0 * h[j]);
    }
  }

  void _computePCHIP(int n, List<num> h) {
    // Slopes of secant lines
    List<num> m = List<num>.filled(n, 0.0);
    for (int i = 0; i < n; i++) {
      m[i] = (_y[i + 1] - _y[i]) / h[i];
    }

    // Derivatives at nodes
    List<num> d = List<num>.filled(n + 1, 0.0);

    // Endpoints (simple one-sided differences or more complex 3-point - simplified here)
    d[0] = _pchipEnd(h[0], h[1], m[0], m[1]);
    d[n] = _pchipEnd(h[n - 1], h[n - 2], m[n - 1], m[n - 2]);

    // Interior points
    for (int i = 1; i < n; i++) {
      if (m[i - 1] * m[i] <= 0) {
        d[i] = 0; // Local extremum or flat
      } else {
        // Harmonic mean of slopes
        num w1 = 2 * h[i] + h[i - 1];
        num w2 = h[i] + 2 * h[i - 1];
        d[i] = (w1 + w2) / (w1 / m[i - 1] + w2 / m[i]);
      }
    }

    // Compute coefficients
    for (int i = 0; i < n; i++) {
      _b[i] = d[i];
      _c[i] = (3 * m[i] - 2 * d[i] - d[i + 1]) / h[i];
      _d[i] = (d[i] + d[i + 1] - 2 * m[i]) / (h[i] * h[i]);
    }
  }

  num _pchipEnd(num h1, num h2, num m1, num m2) {
    num d = ((2 * h1 + h2) * m1 - h1 * m2) / (h1 + h2);
    if (d * m1 <= 0) return 0;
    if ((m1 * m2 <= 0) && (d.abs() > 3 * m1.abs())) return 3 * m1;
    return d;
  }

  void _computeAkima(int n, List<num> h) {
    // Slopes
    List<num> m = List.filled(n, 0.0);
    for (int i = 0; i < n; i++) {
      m[i] = (_y[i + 1] - _y[i]) / h[i];
    }

    // Akima requires values m[-2], m[-1], m[n], m[n+1]
    // Extrapolate slopes linearly? Or nearest?
    // Typical Akima uses specific formula for end slopes
    num mOpt(int i) {
      if (i >= 0 && i < n) return m[i];
      if (i < 0) {
        return 2 * mOpt(i + 1) - mOpt(i + 2); // Extrapolate left
      } else {
        return 2 * mOpt(i - 1) - mOpt(i - 2); // Extrapolate right
      }
    }

    // Derivatives at nodes
    List<num> t = List.filled(n + 1, 0.0);
    for (int i = 0; i <= n; i++) {
      num m1 = mOpt(i - 2);
      num m2 = mOpt(i - 1);
      num m3 = mOpt(i);
      num m4 = mOpt(i + 1);

      num w1 = (m2 - m1).abs();
      num w2 = (m4 - m3).abs();

      if (w1 + w2 == 0) {
        t[i] = (m2 + m3) / 2;
      } else {
        t[i] = (w2 * m2 + w1 * m3) / (w1 + w2);
      }
    }

    // Compute coefficients
    for (int i = 0; i < n; i++) {
      _b[i] = t[i]; // t is derivative, so it's b coefficient
      _c[i] = (3 * m[i] - 2 * t[i] - t[i + 1]) / h[i];
      _d[i] = (t[i] + t[i + 1] - 2 * m[i]) / (h[i] * h[i]);
    }
  }
}
