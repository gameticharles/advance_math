// ignore_for_file: non_constant_identifier_names

part of algebra;

/// An enumeration of different methods that can be used to solve the least squares problem.
enum EquationMethod {
  linear,
  decomposition,
}

/// The `BaseLeastSquares` class is used to perform a least squares fit to the
/// given model, specified by matrix `A` and column vector `b`.
/// It supports weighted least squares with an optional weight matrix `W`,
///
/// The `W` parameter is an optional diagonal matrix containing the weights for weighted least squares.
/// If no weights are provided, an identity matrix is used by default.
///
/// The fit can be done using a linear method or through a decomposition method.
/// Further statistical analyses can be performed on the result such as
/// computation of residuals, covariance matrix, standard deviation, standard
/// error, confidence level, and outlier detection.
/// ```
abstract class BaseLeastSquares {
  /// The designed or input matrix for the model.
  final Matrix A;

  /// The absolute terms or output column matrix for the model.
  final Column b;

  /// An optional diagonal matrix of weights.
  final Diagonal? W;

  /// Coefficients vector, solved in the fit method.
  late Matrix beta;

  /// Equation solving method.
  EquationMethod method;

  // Cached values
  Matrix? _residuals;
  num? _unitVariance;
  num? _standardDeviation;

  /// Constructor for the LeastSquares class.
  /// If no weights are provided, it defaults to using the identity matrix.
  /// The default solving method is linear.
  BaseLeastSquares(this.A, this.b,
      {this.W, this.method = EquationMethod.linear});

  /// Fits the model to the data using the chosen method.
  /// The method can be either linear or using a matrix decomposition.
  void fit(
      {LinearSystemMethod linear = LinearSystemMethod.leastSquares,
      DecompositionMethod decomposition = DecompositionMethod.cholesky}) {
    // Invalidate cached values
    _residuals = null;
    _unitVariance = null;
    _standardDeviation = null;

    // If weights are provided, compute a weighted least squares fit
    //else compute a standard least squares fit
    Matrix AtWb = A.transpose() * (W ?? Matrix.eye(A.rowCount)) * b;

    beta = method == EquationMethod.linear
        ? normal().linear.solve(AtWb, method: linear)
        : normal().decomposition.solve(AtWb, method: decomposition);
  }

  /// Uses the fitted model to predict new outputs given new inputs `xNew`.
  Matrix predict(Matrix xNew) {
    return xNew * beta;
  }

  /// Computes the normal equation matrix.
  Matrix normal() {
    return A.transpose() * (W ?? Matrix.eye(A.rowCount)) * A;
  }

  /// Computes residuals of the fitted model.
  Matrix get residuals {
    _residuals ??= b - A * beta;
    return _residuals!;
  }

  /// Compute unit variance, also known as the mean square error (MSE).
  num unitVariance() {
    _unitVariance ??=
        ((residuals.transpose() * (W ?? Matrix.eye(A.rowCount)) * residuals) /
            (A.rowCount - A.columnCount))[0][0];
    return _unitVariance!;
  }

  /// Compute covariance matrix either of the coefficients or of the residuals.
  Matrix covariance([bool isOnDesignMatrix = true]) {
    if (isOnDesignMatrix) {
      // Compute the covariance matrix of the coefficients
      return normal().inverse() * unitVariance();
    } else {
      // Compute the covariance matrix of the residuals
      Matrix centered = residuals - residuals.mean();
      return (centered.transpose() * centered) / (A.rowCount - 1);
    }
  }

  /// Compute standard deviation of residuals.
  num standardDeviation() {
    _standardDeviation ??= math.sqrt(unitVariance());
    return _standardDeviation!;
  }

  /// Compute standard error of residuals, which is the standard deviation divided by the square root of the number of observations.
  num standardError() {
    return standardDeviation() / math.sqrt(A.rowCount);
  }

  /// Compute error ellipse parameters using eigenvalue decomposition on the covariance matrix.
  Eigen errorEllipse() {
    // Get covariance matrix
    Matrix cov = covariance();
    // Perform Eigenvalue decomposition on covariance matrix
    Eigen eig = cov.eigen();
    return eig;
  }

  /// Compute confidence level. Actual implementation depends on the fit and residuals.
  num confidenceLevel() {
    return 1 - standardError();
  }

  /// Detect outliers in the data using Chauvenet's criterion with a given confidence level.
  List<int> detectOutliers(double confidenceLevel) {
    // Compute mean and standard deviation of residuals
    num mean = residuals.mean();

    // Compute z-scores
    Matrix zScores = (residuals - mean) / standardDeviation();

    // Apply Chauvenet's criterion
    List<int> outliers = [];
    for (int i = 0; i < zScores.rowCount; i++) {
      // Compute the probability assuming normal distribution
      double probability = math.exp(-0.5 * math.pow(zScores[i][0], 2)) /
          (standardDeviation() * math.sqrt(2 * math.pi));

      // Apply the criterion
      if (probability < (1 - confidenceLevel) / residuals.rowCount) {
        outliers.add(i);
      }
    }

    return outliers;
  }
}
