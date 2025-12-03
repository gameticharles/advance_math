part of '../../geometry.dart';

/// A class representing an error ellipse (confidence ellipse) in 2D space.
///
/// An error ellipse is used in statistics, robotics, and geodesy to represent
/// uncertainty or confidence regions. It's derived from a covariance matrix.
///
/// Properties:
/// - Semi-major and semi-minor axes (from eigenvalues)
/// - Orientation angle (from eigenvectors)
/// - Confidence level (e.g., 95%, 99%)
/// - Chi-squared scaling factor
///
/// Example:
/// ```dart
/// var errorEllipse = ErrorEllipse.from(
///   sigmaX: 2.0,
///   sigmaY: 1.0,
///   correlation: 0.5,
///   confidenceLevel: 0.95
/// );
/// print('Semi-major axis: ${errorEllipse.semiMajorAxis}');
/// ```
class ErrorEllipse extends PlaneGeometry {
  /// Semi-major axis length
  double semiMajorAxis;

  /// Semi-minor axis length
  double semiMinorAxis;

  /// Orientation angle (rotation of the ellipse)
  Angle orientation;

  /// Center point of the ellipse
  Point center;

  /// Confidence level (e.g., 0.95 for 95%)
  double confidenceLevel;

  /// Chi-squared scaling factor based on confidence level
  double chiSquaredScale;

  /// Creates an error ellipse with the specified parameters.
  ///
  /// [semiMajorAxis] is the length of the semi-major axis.
  /// [semiMinorAxis] is the length of the semi-minor axis.
  /// [orientation] is the rotation angle of the ellipse.
  /// [center] is the center point (defaults to origin).
  /// [confidenceLevel] is the confidence level (default: 0.95).
  ///
  /// Throws [ArgumentError] if axes are not positive or confidence level is invalid.
  ErrorEllipse(
    this.semiMajorAxis,
    this.semiMinorAxis,
    this.orientation, {
    Point? center,
    this.confidenceLevel = 0.95,
  })  : center = center ?? Point(0, 0),
        chiSquaredScale = _getChiSquaredScale(confidenceLevel),
        super('ErrorEllipse') {
    if (semiMajorAxis <= 0 || semiMinorAxis <= 0) {
      throw ArgumentError(
          'Axes must be positive. Got semiMajorAxis: $semiMajorAxis, semiMinorAxis: $semiMinorAxis');
    }
    if (confidenceLevel <= 0 || confidenceLevel >= 1) {
      throw ArgumentError(
          'Confidence level must be between 0 and 1. Got: $confidenceLevel');
    }
    if (semiMajorAxis < semiMinorAxis) {
      throw ArgumentError(
          'Semi-major axis must be >= semi-minor axis. Got major: $semiMajorAxis, minor: $semiMinorAxis');
    }
  }

  /// Creates an error ellipse from standard deviations and correlation.
  ///
  /// [sigmaX] is the standard deviation in the x-direction.
  /// [sigmaY] is the standard deviation in the y-direction.
  /// [correlation] is the correlation coefficient between x and y (-1 to 1).
  /// [confidenceLevel] is the desired confidence level (default: 0.95).
  ///
  /// The covariance matrix is constructed as:
  /// ```
  /// [ σx²      ρσxσy  ]
  /// [ ρσxσy    σy²    ]
  /// ```
  factory ErrorEllipse.from({
    required double sigmaX,
    required double sigmaY,
    required double correlation,
    double confidenceLevel = 0.95,
    Point? center,
  }) {
    // Validate inputs FIRST before any calculations
    if (sigmaX <= 0 || sigmaY <= 0) {
      throw ArgumentError(
          'Standard deviations must be positive. Got sigmaX: $sigmaX, sigmaY: $sigmaY');
    }
    if (correlation < -1 || correlation > 1) {
      throw ArgumentError(
          'Correlation must be between -1 and 1. Got: $correlation');
    }
    if (confidenceLevel <= 0 || confidenceLevel >= 1) {
      throw ArgumentError(
          'Confidence level must be between 0 and 1. Got: $confidenceLevel');
    }

    // Construct covariance matrix
    double varX = sigmaX * sigmaX;
    double varY = sigmaY * sigmaY;
    double covariance = correlation * sigmaX * sigmaY;

    // Eigenvalue calculation for 2x2 symmetric matrix
    double trace = varX + varY;
    double det = varX * varY - covariance * covariance;
    double discriminant = sqrt(trace * trace / 4 - det);

    double lambda1 = trace / 2 + discriminant; // Larger eigenvalue
    double lambda2 = trace / 2 - discriminant; // Smaller eigenvalue

    // Semi-axes are square roots of eigenvalues scaled by chi-squared
    double chiSq = _getChiSquaredScale(confidenceLevel);
    double semiMajor = sqrt(lambda1 * chiSq);
    double semiMinor = sqrt(lambda2 * chiSq);

    // Orientation angle from eigenvector
    double angle;
    if (covariance.abs() < 1e-10) {
      // No correlation, aligned with axes
      angle = varX >= varY ? 0 : pi / 2;
    } else {
      // Eigenvector for larger eigenvalue
      angle = atan2(lambda1 - varX, covariance);
    }

    return ErrorEllipse(
      semiMajor,
      semiMinor,
      Angle(rad: angle),
      center: center,
      confidenceLevel: confidenceLevel,
    );
  }

  /// Gets the chi-squared scaling factor for a given confidence level.
  ///
  /// For 2D (2 degrees of freedom), common values:
  /// - 68.27% (1σ): 2.28
  /// - 95.00%:      5.991
  /// - 99.00%:      9.210
  static double _getChiSquaredScale(double confidenceLevel) {
    // Approximation for 2 DOF chi-squared distribution
    // Using inverse chi-squared CDF approximations
    if ((confidenceLevel - 0.68).abs() < 0.01) return 2.28;
    if ((confidenceLevel - 0.95).abs() < 0.01) return 5.991;
    if ((confidenceLevel - 0.99).abs() < 0.01) return 9.210;

    // Approximate formula for other values
    // This is a simple approximation; for exact values, use a chi-squared table
    double p = confidenceLevel;
    return (2 * (1 - pow(1 - p, 1 / 2))).toDouble(); // Simplified approximation
  }

  /// Calculates the area of the error ellipse.
  ///
  /// Area = π × semiMajorAxis × semiMinorAxis
  @override
  double area() {
    return pi * semiMajorAxis * semiMinorAxis;
  }

  /// Calculates the approximate perimeter of the error ellipse.
  ///
  /// Uses Ramanujan's approximation:
  /// P ≈ π × [3(a + b) - √((3a + b)(a + 3b))]
  @override
  double perimeter() {
    double a = semiMajorAxis;
    double b = semiMinorAxis;
    return pi * (3 * (a + b) - sqrt((3 * a + b) * (a + 3 * b)));
  }

  /// Checks if a point is inside the error ellipse.
  ///
  /// Transforms the point to ellipse coordinates and checks if:
  /// (x'/a)² + (y'/b)² ≤ 1
  bool contains(Point point) {
    // Translate to ellipse center
    num dx = point.x - center.x;
    num dy = point.y - center.y;

    // Rotate to ellipse's principal axes
    double cosTheta = cos(orientation.rad);
    double sinTheta = sin(orientation.rad);
    double xPrime = (dx * cosTheta + dy * sinTheta).toDouble();
    double yPrime = (-dx * sinTheta + dy * cosTheta).toDouble();

    // Check if inside ellipse
    double normalized = (xPrime * xPrime) / (semiMajorAxis * semiMajorAxis) +
        (yPrime * yPrime) / (semiMinorAxis * semiMinorAxis);

    return normalized <= 1.0;
  }

  /// Gets the eccentricity of the error ellipse.
  ///
  /// Eccentricity = √(1 - (b²/a²))
  double get eccentricity {
    return sqrt(
        1 - (semiMinorAxis * semiMinorAxis) / (semiMajorAxis * semiMajorAxis));
  }

  @override
  String toString() {
    return 'ErrorEllipse(semiMajor: $semiMajorAxis, semiMinor: $semiMinorAxis, '
        'orientation: ${orientation.deg}°, confidence: ${(confidenceLevel * 100).toStringAsFixed(1)}%)';
  }
}
