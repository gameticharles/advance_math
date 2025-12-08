part of 'interpolate.dart';

/// Kernel function type for RBF.
enum RBFKernel {
  linear,
  gaussian,
  multiquadric,
  inverseMultiquadric,
  thinPlateSpline,
}

/// Radial Basis Function (RBF) Interpolator.
///
/// Used for interpolating scattered data, potentially in higher dimensions (though usually 1D/2D).
/// This implementation currently supports 1D inputs but can be extended.
/// For 1D: s(x) = sum(w_i * phi(|x - x_i|))
class RBFInterpolator {
  final List<num> _x;
  final List<num> _y;
  final RBFKernel _kernel;
  final double _epsilon;

  late final Matrix _weights;

  /// Creates an RBF Interpolator.
  ///
  /// [x] and [y] are data points.
  /// [kernel] specifies the radial basis function (default Gaussian).
  /// [epsilon] is the shape parameter for kernels like Gaussian/Multiquadric.
  /// Defaults to average distance between nodes if not provided (conceptually).
  RBFInterpolator(List<num> x, List<num> y,
      {RBFKernel kernel = RBFKernel.gaussian, double epsilon = 1.0})
      : _x = List.from(x),
        _y = List.from(y),
        _kernel = kernel,
        _epsilon = epsilon {
    if (_x.length != _y.length) {
      throw ArgumentError('x and y must have the same length.');
    }

    _fit();
  }

  void _fit() {
    int n = _x.length;
    // Build Phi matrix
    List<List<double>> phiData = [];
    for (int i = 0; i < n; i++) {
      List<double> row = [];
      for (int j = 0; j < n; j++) {
        double r = (_x[i] - _x[j]).abs().toDouble(); // Distance
        row.add(_evaluateKernel(r));
      }
      phiData.add(row);
    }

    Matrix phi = Matrix(phiData);
    Matrix Y = Matrix(_y.map((e) => [e.toDouble()]).toList());

    // Solve Phi * W = Y
    try {
      // Try standard solve (LU or Gaussian)
      _weights = phi.linear.solve(Y);
    } catch (e) {
      // If singular, try pseudo-inverse (SVD) if available, or throw
      throw Exception(
          "Matrix is singular or ill-conditioned. Try a different epsilon or kernel.");
      // Note: SVD solver would be ideal here_
    }
  }

  double _evaluateKernel(double r) {
    switch (_kernel) {
      case RBFKernel.linear:
        return r;
      case RBFKernel.gaussian:
        return math.exp(-(r * r) /
            (2 * _epsilon * _epsilon)); // or exp(-(eps*r)^2) convention
      case RBFKernel.multiquadric:
        return math.sqrt(r * r + _epsilon * _epsilon);
      case RBFKernel.inverseMultiquadric:
        return 1.0 / math.sqrt(r * r + _epsilon * _epsilon);
      case RBFKernel.thinPlateSpline:
        return r == 0 ? 0.0 : r * r * math.log(r);
    }
  }

  /// Evaluates the RBF at [xi].
  num interpolate(num xi) {
    double sum = 0.0;
    for (int i = 0; i < _x.length; i++) {
      double r = (xi - _x[i]).abs().toDouble();
      var wVal = _weights[i][0];
      double w;
      if (wVal is Complex) {
        w = wVal.real.toDouble();
      } else if (wVal is num) {
        w = wVal.toDouble();
      } else {
        w = (wVal as dynamic).toDouble();
      }
      sum += w * _evaluateKernel(r);
    }
    return sum;
  }

  num call(num xi) => interpolate(xi);
}
