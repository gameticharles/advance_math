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
/// This class merges covariance-based construction with geometric properties.
///
/// Example:
/// ```dart
/// var errorEllipse = ErrorEllipse.fromCovariance(
///   sigmaX2: 4.0,
///   sigmaY2: 1.0,
///   sigmaXY: 0.5,
///   confidenceLevel: 0.95
/// );
/// print('Semi-major axis: ${errorEllipse.semiMajorAxis}');
/// ```
class ErrorEllipse extends PlaneGeometry {
  static const double degreesToRadians = pi / 180;

  // --- Core Parameters ---

  /// Variance along the X axis.
  double sigmaX2;

  /// Variance along the Y axis.
  double sigmaY2;

  /// Covariance between X and Y.
  double sigmaXY;

  /// Scale factor for the ellipse (default is 1.0).
  ///
  /// This is applied as a multiplier to the final axes lengths.
  /// If set, it operates alongside [confidenceLevel]'s Chi-squared scaling.
  double sigmaO;

  /// Confidence level (e.g., 0.95 for 95%)
  double confidenceLevel;

  /// Center point of the ellipse
  Point center;

  // --- Computed Geometry (Cached) ---
  double _semiMajorAxis = 0.0;
  double _semiMinorAxis = 0.0;
  Angle _orientation = Angle(rad: 0);
  double _chiSquaredScale = 0.0;

  /// Standard constructor using variance components (covariance matrix).
  ///
  /// [sigmaX2]: Variance in X.
  /// [sigmaY2]: Variance in Y.
  /// [sigmaXY]: Covariance between X and Y.
  /// [sigmaO]: Optional additional scale factor (default 1.0).
  /// [confidenceLevel]: Probability level (default 0.95).
  /// [center]: Center point (default Origin).
  ErrorEllipse({
    required this.sigmaX2,
    required this.sigmaY2,
    required this.sigmaXY,
    this.sigmaO = 1.0,
    this.confidenceLevel = 0.95,
    Point? center,
  })  : center = center ?? Point(0, 0),
        super('ErrorEllipse') {
    _validateInputs();
    _computeEllipseParameters();
  }

  /// Creates an error ellipse from standard deviations and correlation.
  ///
  /// [sigmaX]: Standard deviation in X.
  /// [sigmaY]: Standard deviation in Y.
  /// [correlation]: Correlation coefficient (-1 to 1).
  factory ErrorEllipse.fromStandardDeviations({
    required double sigmaX,
    required double sigmaY,
    required double correlation,
    double sigmaO = 1.0,
    double confidenceLevel = 0.95,
    Point? center,
  }) {
    if (sigmaX <= 0 || sigmaY <= 0) {
      throw ArgumentError('Standard deviations must be positive.');
    }
    if (correlation < -1 || correlation > 1) {
      throw ArgumentError('Correlation must be between -1 and 1.');
    }
    return ErrorEllipse(
      sigmaX2: sigmaX * sigmaX,
      sigmaY2: sigmaY * sigmaY,
      sigmaXY: correlation * sigmaX * sigmaY,
      sigmaO: sigmaO,
      confidenceLevel: confidenceLevel,
      center: center,
    );
  }

  /// Compatibility factory for existing code (aliased to [fromStandardDeviations]).
  factory ErrorEllipse.from({
    required double sigmaX,
    required double sigmaY,
    required double correlation,
    double confidenceLevel = 0.95,
    Point? center,
  }) {
    return ErrorEllipse.fromStandardDeviations(
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      correlation: correlation,
      confidenceLevel: confidenceLevel,
      center: center,
    );
  }

  /// Deserializes JSON-compatible map into an ErrorEllipse instance.
  factory ErrorEllipse.fromJson(Map<String, dynamic> json) => ErrorEllipse(
        sigmaX2: json['sigmaX2']?.toDouble() ?? 0.0,
        sigmaY2: json['sigmaY2']?.toDouble() ?? 0.0,
        sigmaXY: json['sigmaXY']?.toDouble() ?? 0.0,
        sigmaO: json['sigmaO']?.toDouble() ?? 1.0,
        confidenceLevel: json['confidenceLevel']?.toDouble() ?? 0.95,
        center: json['centerX'] != null && json['centerY'] != null
            ? Point(json['centerX'], json['centerY'])
            : null,
      );

  // --- Getters ---

  /// Semi-major axis length (scaled).
  double get semiMajorAxis => _semiMajorAxis;

  /// Semi-minor axis length (scaled).
  double get semiMinorAxis => _semiMinorAxis;

  /// Orientation angle of the ellipse.
  Angle get orientation => _orientation;

  /// Orientation angle in degrees.
  double get orientationAngle => _orientation.deg.toDouble();

  /// Bearing angle derived from the orientation (90 - theta).
  double get bearing => (90 - orientationAngle) % 360;

  /// Distance along the X axis (unrotated, scaled 1-sigma * factors).
  double get sx => sigmaO * sqrt(sigmaX2);

  /// Distance along the Y axis (unrotated, scaled 1-sigma * factors).
  double get sy => sigmaO * sqrt(sigmaY2);

  /// Eccentricity of the ellipse: √(1 - (b²/a²)).
  double get eccentricity {
    if (_semiMajorAxis == 0) return 0;
    return sqrt(1 -
        (_semiMinorAxis * _semiMinorAxis) / (_semiMajorAxis * _semiMajorAxis));
  }

  /// Aspect ratio of the ellipse: a / b.
  double get aspectRatio =>
      _semiMinorAxis == 0 ? 0 : _semiMajorAxis / _semiMinorAxis;

  // --- Methods ---

  /// Updates ellipse parameters dynamically.
  void updateParameters({
    double? newSigmaX2,
    double? newSigmaY2,
    double? newSigmaXY,
    double? newSigmaO,
    double? newConfidenceLevel,
  }) {
    if (newSigmaX2 != null) sigmaX2 = newSigmaX2;
    if (newSigmaY2 != null) sigmaY2 = newSigmaY2;
    if (newSigmaXY != null) sigmaXY = newSigmaXY;
    if (newSigmaO != null) sigmaO = newSigmaO;
    if (newConfidenceLevel != null) confidenceLevel = newConfidenceLevel;

    _validateInputs();
    _computeEllipseParameters();
  }

  void _validateInputs() {
    if (sigmaX2 < 0 || sigmaY2 < 0) {
      throw ArgumentError('Variances must be non-negative.');
    }
    if (confidenceLevel <= 0 || confidenceLevel >= 1) {
      throw ArgumentError(
          'Confidence level must be between 0 and 1 exclusive.');
    }
  }

  void _computeEllipseParameters() {
    // 1. Calculate Chi-squared scale
    _chiSquaredScale = _getChiSquaredScale(confidenceLevel);

    // 2. Eigenvalue calculation helper (Delta)
    // λ = (σx² + σy² ± √((σx² - σy²)² + 4σxy²)) / 2
    double delta = sqrt(pow((sigmaX2 - sigmaY2), 2) + 4 * pow(sigmaXY, 2));
    double lambda1 = 0.5 * (sigmaX2 + sigmaY2 + delta);
    double lambda2 = 0.5 * (sigmaX2 + sigmaY2 - delta);

    // Apply scaling factors: sigmaO and chiSquared
    // Axis = sigmaO * sqrt(lambda * chiSquared)
    // Note: If sigmaO is meant to work on Standard Deviation level, appropriate;
    // if on Variance, it would be sqrt. Usage usually implies linear scale factor.
    double scale = sigmaO * sqrt(_chiSquaredScale);
    _semiMajorAxis = scale * sqrt(lambda1);
    _semiMinorAxis = scale * sqrt(lambda2);

    // 3. Orientation
    // θ = 0.5 * atan2(2σxy, σx² - σy²)
    double thetaRad;
    if (sigmaXY.abs() < 1e-10 && (sigmaX2 - sigmaY2).abs() < 1e-10) {
      thetaRad = 0.0;
    } else {
      thetaRad = 0.5 * atan2(2 * sigmaXY, sigmaX2 - sigmaY2);
    }
    _orientation = Angle(rad: thetaRad);
  }

  static double _getChiSquaredScale(double confidenceLevel) {
    if ((confidenceLevel - 0.3935).abs() < 0.001) {
      return 1.0; // 1-sigma 2D approx
    }
    if ((confidenceLevel - 0.68).abs() < 0.01) return 2.28;
    if ((confidenceLevel - 0.95).abs() < 0.01) return 5.991;
    if ((confidenceLevel - 0.99).abs() < 0.01) return 9.210;

    // Approximation for 2 DOF: Quantile function of Chi-Squared(k=2)
    // Q(p) = -2 * ln(1 - p)
    return (-2 * log(1 - confidenceLevel)).toDouble();
  }

  @override
  double area() {
    return pi * _semiMajorAxis * _semiMinorAxis;
  }

  @override
  double perimeter() {
    // Ramanujan approximation
    double a = _semiMajorAxis;
    double b = _semiMinorAxis;
    return pi * (3 * (a + b) - sqrt((3 * a + b) * (a + 3 * b)));
  }

  /// Generates points representing the ellipse for plotting.
  List<Map<String, double>> generateEllipsePoints(int numPoints) {
    List<Map<String, double>> points = [];
    double theta = _orientation.rad.toDouble();
    double cosTheta = cos(theta);
    double sinTheta = sin(theta);
    double cx = center.x.toDouble();
    double cy = center.y.toDouble();

    for (int i = 0; i < numPoints; i++) {
      double angle = (2 * pi * i) / numPoints;
      double ca = cos(angle);
      double sa = sin(angle);

      // x = cx + a*cos(t)*cos(θ) - b*sin(t)*sin(θ)
      // y = cy + a*cos(t)*sin(θ) + b*sin(t)*cos(θ)
      double x =
          cx + _semiMajorAxis * ca * cosTheta - _semiMinorAxis * sa * sinTheta;
      double y =
          cy + _semiMajorAxis * ca * sinTheta + _semiMinorAxis * sa * cosTheta;
      points.add({'x': x, 'y': y});
    }
    return points;
  }

  /// Checks if a point is inside the error ellipse.
  bool contains(Point point) {
    num dx = point.x - center.x;
    num dy = point.y - center.y;

    double cosTheta = cos(_orientation.rad);
    double sinTheta = sin(_orientation.rad);

    // Rotate point to align with axes
    double xPrime = (dx * cosTheta + dy * sinTheta).toDouble();
    double yPrime = (-dx * sinTheta + dy * cosTheta).toDouble();

    // Check ellipse equation
    return (xPrime * xPrime) / (_semiMajorAxis * _semiMajorAxis) +
            (yPrime * yPrime) / (_semiMinorAxis * _semiMinorAxis) <=
        1.0;
  }

  /// Serializes the ellipse data.
  Map<String, dynamic> toJson() => {
        'sigmaX2': sigmaX2,
        'sigmaY2': sigmaY2,
        'sigmaXY': sigmaXY,
        'sigmaO': sigmaO,
        'confidenceLevel': confidenceLevel,
        'centerX': center.x,
        'centerY': center.y,
        'semiMajorAxis': _semiMajorAxis, // a
        'semiMinorAxis': _semiMinorAxis, // b
        'orientation': _orientation.deg, // theta
        'bearing': bearing,
        'sx': sx,
        'sy': sy,
        'area': area(),
        'eccentricity': eccentricity,
        'aspectRatio': aspectRatio,
      };

  @override
  String toString() {
    return 'ErrorEllipse(a: ${_semiMajorAxis.toStringAsFixed(3)}, b: ${_semiMinorAxis.toStringAsFixed(3)}, '
        'theta: ${_orientation.deg.toStringAsFixed(1)}°, conf: ${(confidenceLevel * 100).toStringAsFixed(1)}%)';
  }
}
