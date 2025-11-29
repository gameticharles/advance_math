import '../../basic/math.dart';

/// A class providing various numerical integration methods for calculating
/// definite integrals of functions.
///
/// This class implements several numerical integration techniques ranging from
/// basic methods like the trapezoidal and Simpson's rules to more advanced
/// techniques like Romberg integration and Gaussian quadrature.
///
/// Example:
/// ```dart
/// // Integrate f(x) = x^2 from 0 to 1
/// double f(double x) => x * x;
///
/// var result = NumericalIntegration.trapezoidal(f, 0, 1, n: 1000);
/// print('Integral: $result'); // ~0.333333
/// ```
class NumericalIntegration {
  /// Computes the definite integral using the trapezoidal rule.
  ///
  /// The trapezoidal rule approximates the integral by dividing the interval
  /// into `n` subintervals and approximating the area under the curve as a
  /// series of trapezoids.
  ///
  /// Formula: ∫[a,b] f(x)dx ≈ h/2 * [f(a) + 2*Σf(xi) + f(b)]
  /// where h = (b-a)/n
  ///
  /// Parameters:
  /// - [f]: The function to integrate
  /// - [a]: Lower bound of integration
  /// - [b]: Upper bound of integration
  /// - [n]: Number of subintervals (default: 100)
  ///
  /// Returns: Approximation of the definite integral
  ///
  /// Example:
  /// ```dart
  /// double f(double x) => math.sin(x);
  /// var result = NumericalIntegration.trapezoidal(f, 0, math.pi, n: 1000);
  /// print(result); // ~2.0
  /// ```
  static num trapezoidal(num Function(num) f, num a, num b, {int n = 100}) {
    if (n <= 0) {
      throw ArgumentError('Number of subintervals must be positive');
    }
    if (a == b) return 0;

    final h = (b - a) / n;
    num sum = (f(a) + f(b)) / 2;

    for (int i = 1; i < n; i++) {
      sum += f(a + i * h);
    }

    return h * sum;
  }

  /// Computes the definite integral using Simpson's rule.
  ///
  /// Simpson's rule uses quadratic polynomials to approximate the function
  /// and provides better accuracy than the trapezoidal rule. Requires an
  /// even number of subintervals.
  ///
  /// Formula: ∫[a,b] f(x)dx ≈ h/3 * [f(a) + 4*Σf(x_odd) + 2*Σf(x_even) + f(b)]
  ///
  /// Parameters:
  /// - [f]: The function to integrate
  /// - [a]: Lower bound of integration
  /// - [b]: Upper bound of integration
  /// - [n]: Number of subintervals (must be even, default: 100)
  ///
  /// Returns: Approximation of the definite integral
  ///
  /// Throws [ArgumentError] if n is odd
  ///
  /// Example:
  /// ```dart
  /// double f(double x) => x * x * x;
  /// var result = NumericalIntegration.simpsons(f, 0, 2, n: 100);
  /// print(result); // ~4.0
  /// ```
  static num simpsons(num Function(num) f, num a, num b, {int n = 100}) {
    if (n <= 0) {
      throw ArgumentError('Number of subintervals must be positive');
    }
    if (n % 2 != 0) {
      throw ArgumentError(
          'Number of subintervals must be even for Simpson\'s rule');
    }
    if (a == b) return 0;

    final h = (b - a) / n;
    num sum = f(a) + f(b);

    for (int i = 1; i < n; i++) {
      final x = a + i * h;
      sum += (i % 2 == 0 ? 2 : 4) * f(x);
    }

    return (h / 3) * sum;
  }

  /// Computes the definite integral using adaptive Simpson's rule.
  ///
  /// This method recursively subdivides intervals where the error estimate
  /// exceeds the tolerance, providing efficient and accurate integration.
  ///
  /// Parameters:
  /// - [f]: The function to integrate
  /// - [a]: Lower bound of integration
  /// - [b]: Upper bound of integration
  /// - [tolerance]: Desired accuracy (default: 1e-6)
  /// - [maxDepth]: Maximum recursion depth (default: 50)
  ///
  /// Returns: Approximation of the definite integral
  ///
  /// Example:
  /// ```dart
  /// double f(double x) => 1 / (1 + x * x);
  /// var result = NumericalIntegration.adaptiveSimpson(f, 0, 1, tolerance: 1e-8);
  /// print(result); // π/4 ≈ 0.785398
  /// ```
  static num adaptiveSimpson(num Function(num) f, num a, num b,
      {double tolerance = 1e-6, int maxDepth = 50}) {
    if (a == b) return 0;

    return _adaptiveSimpsonRecursive(f, a, b, tolerance, maxDepth, 0);
  }

  /// Helper function for adaptive Simpson's rule recursion
  static num _adaptiveSimpsonRecursive(
    num Function(num) f,
    num a,
    num b,
    double tolerance,
    int maxDepth,
    int depth,
  ) {
    final c = (a + b) / 2;
    final h = b - a;

    final fa = f(a);
    final fb = f(b);
    final fc = f(c);

    // Simpson's rule for whole interval
    final s = (h / 6) * (fa + 4 * fc + fb);

    if (depth >= maxDepth) {
      return s;
    }

    // Simpson's rule for left and right halves
    final d = (a + c) / 2;
    final e = (c + b) / 2;
    final fd = f(d);
    final fe = f(e);

    final sleft = (h / 12) * (fa + 4 * fd + fc);
    final sright = (h / 12) * (fc + 4 * fe + fb);
    final s2 = sleft + sright;

    // Error estimate
    final error = (s2 - s).abs() / 15;

    if (error < tolerance) {
      return s2 + error; // Richardson extrapolation
    }

    // Recursively refine
    return _adaptiveSimpsonRecursive(
            f, a, c, tolerance / 2, maxDepth, depth + 1) +
        _adaptiveSimpsonRecursive(f, c, b, tolerance / 2, maxDepth, depth + 1);
  }

  /// Computes the definite integral using Romberg integration.
  ///
  /// Romberg integration uses Richardson extrapolation on the trapezoidal rule
  /// to achieve higher accuracy. It builds a triangular array of estimates
  /// with increasing accuracy.
  ///
  /// Parameters:
  /// - [f]: The function to integrate
  /// - [a]: Lower bound of integration
  /// - [b]: Upper bound of integration
  /// - [tolerance]: Desired accuracy (default: 1e-6)
  /// - [maxDepth]: Maximum number of iterations (default: 10)
  ///
  /// Returns: Approximation of the definite integral
  ///
  /// Example:
  /// ```dart
  /// double f(double x) => math.exp(-x * x);
  /// var result = NumericalIntegration.romberg(f, 0, 1, tolerance: 1e-10);
  /// print(result);
  /// ```
  static num romberg(num Function(num) f, num a, num b,
      {double tolerance = 1e-6, int maxDepth = 10}) {
    if (a == b) return 0;

    // Initialize Romberg table
    List<List<num>> r =
        List.generate(maxDepth, (_) => List.filled(maxDepth, 0));

    final h = b - a;
    r[0][0] = (h / 2) * (f(a) + f(b));

    for (int i = 1; i < maxDepth; i++) {
      // Trapezoidal approximation with 2^i intervals
      num sum = 0;
      final stepSize = h / pow(2, i);
      final numPoints = pow(2, i - 1).toInt();

      for (int k = 0; k < numPoints; k++) {
        sum += f(a + (2 * k + 1) * stepSize);
      }

      r[i][0] = r[i - 1][0] / 2 + stepSize * sum;

      // Richardson extrapolation
      for (int j = 1; j <= i; j++) {
        final coefficient = pow(4, j);
        r[i][j] =
            (coefficient * r[i][j - 1] - r[i - 1][j - 1]) / (coefficient - 1);
      }

      // Check convergence
      if (i > 0 && (r[i][i] - r[i - 1][i - 1]).abs() < tolerance) {
        return r[i][i];
      }
    }

    return r[maxDepth - 1][maxDepth - 1];
  }

  /// Computes the definite integral using Gaussian quadrature.
  ///
  /// Gaussian quadrature uses optimally chosen sample points and weights
  /// to achieve high accuracy with relatively few function evaluations.
  /// This implementation uses Gauss-Legendre quadrature.
  ///
  /// Parameters:
  /// - [f]: The function to integrate
  /// - [a]: Lower bound of integration
  /// - [b]: Upper bound of integration
  /// - [order]: Number of sample points (default: 5, valid: 2-10)
  ///
  /// Returns: Approximation of the definite integral
  ///
  /// Example:
  /// ```dart
  /// double f(double x) => x * x * x;
  /// var result = NumericalIntegration.gaussianQuadrature(f, 0, 1, order: 5);
  /// print(result); // 0.25
  /// ```
  static num gaussianQuadrature(num Function(num) f, num a, num b,
      {int order = 5}) {
    if (order < 2 || order > 10) {
      throw ArgumentError('Order must be between 2 and 10');
    }
    if (a == b) return 0;

    // Get nodes and weights for [-1, 1] interval
    final nodesAndWeights = _getGaussLegendreNodesAndWeights(order);
    final nodes = nodesAndWeights[0];
    final weights = nodesAndWeights[1];

    // Transform from [-1, 1] to [a, b]
    final c1 = (b - a) / 2;
    final c2 = (b + a) / 2;

    num sum = 0;
    for (int i = 0; i < order; i++) {
      final x = c1 * nodes[i] + c2;
      sum += weights[i] * f(x);
    }

    return c1 * sum;
  }

  /// Returns Gauss-Legendre nodes and weights for the interval [-1, 1]
  static List<List<num>> _getGaussLegendreNodesAndWeights(int n) {
    // Pre-computed nodes and weights for orders 2-10
    final data = <int, List<List<num>>>{
      2: [
        [-0.5773502691896257, 0.5773502691896257],
        [1.0, 1.0]
      ],
      3: [
        [-0.7745966692414834, 0.0, 0.7745966692414834],
        [0.5555555555555556, 0.8888888888888888, 0.5555555555555556]
      ],
      4: [
        [
          -0.8611363115940526,
          -0.3399810435848563,
          0.3399810435848563,
          0.8611363115940526
        ],
        [
          0.3478548451374538,
          0.6521451548625461,
          0.6521451548625461,
          0.3478548451374538
        ]
      ],
      5: [
        [
          -0.9061798459386640,
          -0.5384693101056831,
          0.0,
          0.5384693101056831,
          0.9061798459386640
        ],
        [
          0.2369268850561891,
          0.4786286704993665,
          0.5688888888888889,
          0.4786286704993665,
          0.2369268850561891
        ]
      ],
      6: [
        [
          -0.9324695142031521,
          -0.6612093864662645,
          -0.2386191860831969,
          0.2386191860831969,
          0.6612093864662645,
          0.9324695142031521
        ],
        [
          0.1713244923791704,
          0.3607615730481386,
          0.4679139345726910,
          0.4679139345726910,
          0.3607615730481386,
          0.1713244923791704
        ]
      ],
      7: [
        [
          -0.9491079123427585,
          -0.7415311855993945,
          -0.4058451513773972,
          0.0,
          0.4058451513773972,
          0.7415311855993945,
          0.9491079123427585
        ],
        [
          0.1294849661688697,
          0.2797053914892766,
          0.3818300505051189,
          0.4179591836734694,
          0.3818300505051189,
          0.2797053914892766,
          0.1294849661688697
        ]
      ],
      8: [
        [
          -0.9602898564975363,
          -0.7966664774136267,
          -0.5255324099163290,
          -0.1834346424956498,
          0.1834346424956498,
          0.5255324099163290,
          0.7966664774136267,
          0.9602898564975363
        ],
        [
          0.1012285362903763,
          0.2223810344533745,
          0.3137066458778873,
          0.3626837833783620,
          0.3626837833783620,
          0.3137066458778873,
          0.2223810344533745,
          0.1012285362903763
        ]
      ],
      9: [
        [
          -0.9681602395076261,
          -0.8360311073266358,
          -0.6133714327005904,
          -0.3242534234038089,
          0.0,
          0.3242534234038089,
          0.6133714327005904,
          0.8360311073266358,
          0.9681602395076261
        ],
        [
          0.0812743883615744,
          0.1806481606948574,
          0.2606106964029354,
          0.3123470770400029,
          0.3302393550012598,
          0.3123470770400029,
          0.2606106964029354,
          0.1806481606948574,
          0.0812743883615744
        ]
      ],
      10: [
        [
          -0.9739065285171717,
          -0.8650633666889845,
          -0.6794095682990244,
          -0.4333953941292472,
          -0.1488743389816312,
          0.1488743389816312,
          0.4333953941292472,
          0.6794095682990244,
          0.8650633666889845,
          0.9739065285171717
        ],
        [
          0.0666713443086881,
          0.1494513491505806,
          0.2190863625159820,
          0.2692667193099963,
          0.2955242247147529,
          0.2955242247147529,
          0.2692667193099963,
          0.2190863625159820,
          0.1494513491505806,
          0.0666713443086881
        ]
      ],
    };

    return data[n]!;
  }

  /// Computes a double integral over a rectangular region.
  ///
  /// Integrates f(x,y) over the region [ax, bx] × [ay, by] using nested
  /// trapezoidal integration.
  ///
  /// Parameters:
  /// - [f]: Function of two variables to integrate
  /// - [ax]: Lower x bound
  /// - [bx]: Upper x bound
  /// - [ay]: Lower y bound (can be a function of x)
  /// - [by]: Upper y bound (can be a function of x)
  /// - [nx]: Number of x subintervals (default: 50)
  /// - [ny]: Number of y subintervals (default: 50)
  ///
  /// Returns: Approximation of the double integral
  ///
  /// Example:
  /// ```dart
  /// // Integrate f(x,y) = x*y over [0,1] × [0,1]
  /// double f(double x, double y) => x * y;
  /// var result = NumericalIntegration.doubleIntegral(
  ///   f, 0, 1, (x) => 0, (x) => 1, nx: 100, ny: 100
  /// );
  /// print(result); // 0.25
  /// ```
  static num doubleIntegral(num Function(num, num) f, num ax, num bx,
      num Function(num) ay, num Function(num) by,
      {int nx = 50, int ny = 50}) {
    num outerIntegrand(num x) {
      num innerIntegrand(num y) => f(x, y);
      return trapezoidal(innerIntegrand, ay(x), by(x), n: ny);
    }

    return trapezoidal(outerIntegrand, ax, bx, n: nx);
  }

  /// Computes a triple integral over a rectangular region.
  ///
  /// Integrates f(x,y,z) over a region defined by the bounds using nested
  /// trapezoidal integration.
  ///
  /// Parameters:
  /// - [f]: Function of three variables to integrate
  /// - [ax]: Lower x bound
  /// - [bx]: Upper x bound
  /// - [ay]: Lower y bound (can be a function of x)
  /// - [by]: Upper y bound (can be a function of x)
  /// - [az]: Lower z bound (can be a function of x and y)
  /// - [bz]: Upper z bound (can be a function of x and y)
  /// - [nx]: Number of x subintervals (default: 20)
  /// - [ny]: Number of y subintervals (default: 20)
  /// - [nz]: Number of z subintervals (default: 20)
  ///
  /// Returns: Approximation of the triple integral
  ///
  /// Example:
  /// ```dart
  /// // Integrate f(x,y,z) = x*y*z over unit cube
  /// double f(double x, double y, double z) => x * y * z;
  /// var result = NumericalIntegration.tripleIntegral(
  ///   f, 0, 1, (x) => 0, (x) => 1, (x, y) => 0, (x, y) => 1
  /// );
  /// print(result); // 0.125
  /// ```
  static num tripleIntegral(
      num Function(num, num, num) f,
      num ax,
      num bx,
      num Function(num) ay,
      num Function(num) by,
      num Function(num, num) az,
      num Function(num, num) bz,
      {int nx = 20,
      int ny = 20,
      int nz = 20}) {
    num outerIntegrand(num x) {
      num middleIntegrand(num y) {
        num innerIntegrand(num z) => f(x, y, z);
        return trapezoidal(innerIntegrand, az(x, y), bz(x, y), n: nz);
      }

      return trapezoidal(middleIntegrand, ay(x), by(x), n: ny);
    }

    return trapezoidal(outerIntegrand, ax, bx, n: nx);
  }

  /// Computes a multi-dimensional integral using Monte Carlo integration.
  ///
  /// Monte Carlo integration is particularly effective for high-dimensional
  /// integrals where traditional methods become computationally expensive.
  ///
  /// Parameters:
  /// - [f]: Function to integrate (takes a list of coordinates)
  /// - [lower]: Lower bounds for each dimension
  /// - [upper]: Upper bounds for each dimension
  /// - [samples]: Number of random samples (default: 10000)
  /// - [seed]: Random seed for reproducibility (optional)
  ///
  /// Returns: Approximation of the integral
  ///
  /// Example:
  /// ```dart
  /// // Integrate f(x,y) = x^2 + y^2 over [0,1] × [0,1]
  /// double f(List<num> coords) {
  ///   double x = coords[0].toDouble();
  ///   double y = coords[1].toDouble();
  ///   return x * x + y * y;
  /// }
  /// var result = NumericalIntegration.monteCarloIntegral(
  ///   f, [0, 0], [1, 1], samples: 100000
  /// );
  /// print(result); // ~0.6667
  /// ```
  static num monteCarloIntegral(
      num Function(List<num>) f, List<num> lower, List<num> upper,
      {int samples = 10000, int? seed}) {
    if (lower.length != upper.length) {
      throw ArgumentError(
          'Lower and upper bounds must have the same dimension');
    }

    final random = seed != null ? Random(seed) : Random();
    final dimension = lower.length;

    // Calculate volume of integration region
    num volume = 1;
    for (int i = 0; i < dimension; i++) {
      volume *= (upper[i] - lower[i]);
    }

    // Monte Carlo sampling
    num sum = 0;
    for (int i = 0; i < samples; i++) {
      final point = List<num>.generate(dimension,
          (j) => lower[j] + random.nextDouble() * (upper[j] - lower[j]));
      sum += f(point);
    }

    return volume * sum / samples;
  }

  /// Computes a definite integral with error estimation.
  ///
  /// Uses adaptive Simpson's rule and returns both the integral value and
  /// an error estimate.
  ///
  /// Returns: A map with keys 'value' and 'error'
  ///
  /// Example:
  /// ```dart
  /// double f(double x) => math.sin(x);
  /// var result = NumericalIntegration.integrateWithError(f, 0, math.pi);
  /// print('Value: ${result['value']}, Error: ${result['error']}');
  /// ```
  static Map<String, num> integrateWithError(num Function(num) f, num a, num b,
      {double tolerance = 1e-6}) {
    // Use two different methods and compare
    final simpson = adaptiveSimpson(f, a, b, tolerance: tolerance);
    final romberg = NumericalIntegration.romberg(f, a, b, tolerance: tolerance);

    final value = simpson;
    final error = (simpson - romberg).abs();

    return {'value': value, 'error': error};
  }
}
