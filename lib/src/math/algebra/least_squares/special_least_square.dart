part of algebra;

/// The `LeastSquares` class is used to perform a least squares fit to the
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
///
/// Example:
/// ```dart
/// var A = Matrix([
///   [1, 0, 0],
///   [0, 1, 0],
///   [0, 0, 1],
///   [-1, 1, 0],
///   [-1, 0, 1],
///   [0, -1, 1],
/// ]);
///
/// var B = Column([0, 0, 0, -0.015, 0.102, 0.097]);
/// var W = Diagonal([1 / 5, 1 / 10, 1 / 7, 1 / 7, 1 / 12, 1 / 9]);
///
/// var lsq = LeastSquares(A, B, W: W, method: EquationMethod.linear);
/// lsq.fit();
///
/// print('Unknown Errors (x): \n${lsq.beta}\n');
/// print('Residuals (V): \n${lsq.residuals}\n');
/// print('Unit Variance (𝛔^2): \n${lsq.unitVariance()}\n');
/// print('Covariance: \n${lsq.covariance().round(6)}\n');
/// print('Standard Deviation: \n${lsq.standardDeviation()}\n');
/// print('Standard Error: \n${lsq.standardError()}\n');
/// print('Confidence Level: \n${lsq.confidenceLevel()}\n');
/// print('Detect Outliers 95% CL: \n${lsq.detectOutliers(0.95)}\n');
///
/// // Output:
/// // Unknown Errors (x):
/// // Matrix: 3x1
/// // ┌ -0.016295505617977508 ┐
/// // │ -0.029447191011235933 │
/// // └  0.043426741573033736 ┘
///
/// // Residuals (V):
/// // Matrix: 6x1
/// // ┌   0.016295505617977508 ┐
/// // │   0.029447191011235933 │
/// // │  -0.043426741573033736 │
/// // │ -0.0018483146067415739 │
/// // │    0.04227775280898875 │
/// // └    0.02412606741573034 ┘
///
/// // Unit Variance (𝛔^2):
/// // 0.00020778232209737825
///
/// // Covariance:
/// // Matrix: 3x3
/// // ┌ 0.000661 0.000355  0.00028 ┐
/// // │ 0.000355 0.000845 0.000366 │
/// // └  0.00028 0.000366 0.000806 ┘
///
/// // Standard Deviation:
/// // 0.01441465650292709
///
/// // Standard Error:
/// // 0.005884758874943791
///
/// // Confidence Level:
/// // 0.9941152411250562
///
/// // Detect Outliers 95% CL:
/// // []
/// ```
class LeastSquares extends BaseLeastSquares {
  /// Creates an instance of the `WeightedLeastSquares` class.
  ///
  /// The `A` parameter is a matrix containing the independent variables.
  /// The `b` parameter is a column vector containing the dependent variable.
  /// The `W` parameter is a diagonal matrix containing the weights for weighted least squares.
  ///
  /// The `method` parameter is an optional parameter specifying the equation method to be used.
  /// By default, it is set to `EquationMethod.linear`.
  LeastSquares(Matrix A, ColumnMatrix b, DiagonalMatrix W,
      {EquationMethod method = EquationMethod.linear})
      : super(A, b, W: W, method: method);
}

/// Implements Ordinary Least Squares method for linear regression.
///
/// This class inherits all the attributes and methods from `LeastSquares`.
///
/// Example:
/// ```dart
/// var A = Matrix.fromList([[1, 2], [3, 4], [5, 6]]);
/// var b = Column.fromList([7, 8, 9]);
/// var ols = OrdinaryLeastSquares(A, b);
/// ols.fit();
/// print(ols.beta);  // Prints the coefficients of the regression model
/// print(ols.residuals); // Prints the residuals of the model
/// print(ols.standardError());  // Prints the standard error of the residuals
/// ```
class OrdinaryLeastSquares extends BaseLeastSquares {
  /// Creates an instance of the `OrdinaryLeastSquares` class.
  ///
  /// The `A` parameter is a matrix containing the independent variables.
  /// The `b` parameter is a column vector containing the dependent variable.
  ///
  /// The `method` parameter is an optional parameter specifying the equation method to be used.
  /// By default, it is set to `EquationMethod.linear`.
  OrdinaryLeastSquares(Matrix A, ColumnMatrix b,
      {DiagonalMatrix? W, EquationMethod method = EquationMethod.linear})
      : super(A, b, method: method);
}

/// Implements Weighted Least Squares method for linear regression.
///
/// This class inherits all the attributes and methods from `LeastSquares`.
/// It also introduces the `calculateWeightedResiduals()` method, which computes the residuals
/// taking into account the weights associated with each observation.
///
/// Example:
/// ```dart
/// var A = Matrix.fromList([[1, 2], [3, 4], [5, 6]]);
/// var b = Column.fromList([7, 8, 9]);
/// var W = Diagonal.fromList([0.5, 0.3, 0.2]);
/// var wls = WeightedLeastSquares(A, b, W);
/// wls.fit();
/// print(wls.beta);  // Prints the coefficients of the regression model
/// print(wls.calculateWeightedResiduals());  // Prints the weighted residuals of the model
/// ```
class WeightedLeastSquares extends BaseLeastSquares {
  /// Creates an instance of the `WeightedLeastSquares` class.
  ///
  /// The `A` parameter is a matrix containing the independent variables.
  /// The `b` parameter is a column vector containing the dependent variable.
  /// The `W` parameter is a diagonal matrix containing the weights for weighted least squares.
  ///
  /// The `method` parameter is an optional parameter specifying the equation method to be used.
  /// By default, it is set to `EquationMethod.linear`.
  WeightedLeastSquares(Matrix A, ColumnMatrix b, DiagonalMatrix W,
      {EquationMethod method = EquationMethod.linear})
      : super(A, b, W: W, method: method);

  /// Computes the residuals of the regression model, taking into account
  /// the weights associated with each observation.
  Matrix calculateWeightedResiduals() {
    // Invalidate cached values
    _residuals = null;

    // If weights are provided, compute a weighted residuals
    _residuals = (W ?? Matrix.eye(A.rowCount)) * (b - A * beta);

    return _residuals!;
  }
}

/// Implements Generalized Least Squares method for linear regression.
///
/// This class inherits all the attributes and methods from `LeastSquares`.
/// It also introduces the `calculateWeightedResiduals()` method, which computes the residuals
/// taking into account the weights associated with each observation.
///
/// Example:
/// ```dart
/// var A = Matrix.fromList([[1, 2], [3, 4], [5, 6]]);
/// var b = Column.fromList([7, 8, 9]);
/// var W = Diagonal.fromList([0.5, 0.3, 0.2]);
/// var gls = GeneralizedLeastSquares(A, b, W);
/// gls.fit();
/// print(gls.beta);  // Prints the coefficients of the regression model
/// print(gls.calculateWeightedResiduals());  // Prints the weighted residuals of the model
/// ```
class GeneralizedLeastSquares extends BaseLeastSquares {
  /// Creates an instance of the `GeneralizedLeastSquares` class.
  ///
  /// The `A` parameter is a matrix containing the independent variables.
  /// The `b` parameter is a column vector containing the dependent variable.
  /// The `W` parameter is a diagonal matrix containing the weights for generalized least squares.
  ///
  /// The `method` parameter is an optional parameter specifying the equation method to be used.
  /// By default, it is set to `EquationMethod.linear`.
  GeneralizedLeastSquares(Matrix A, ColumnMatrix b, DiagonalMatrix W,
      {EquationMethod method = EquationMethod.linear})
      : super(A, b, W: W, method: method);

  /// Computes the residuals of the regression model, taking into account
  /// the weights associated with each observation.
  Matrix calculateWeightedResiduals() {
    // Invalidate cached values
    _residuals = null;

    // If weights are provided, compute a weighted residuals
    _residuals = (W ?? Matrix.eye(A.rowCount)) * (b - A * beta);

    return _residuals!;
  }
}

/// A class for Total Least Squares Regression
///
/// Total Least Squares Regression is a type of regression analysis which minimizes
/// the sum of squared perpendicular distances from each data point to the model.
/// It is a form of errors-in-variables regression.
class TotalLeastSquares extends BaseLeastSquares {
  /// Constructs an instance of TotalLeastSquares
  ///
  /// [A] is the matrix of observations, [b] is the vector of dependent variable values
  /// [method] determines the solving method, defaults to linear.
  TotalLeastSquares(Matrix A, ColumnMatrix b,
      {EquationMethod method = EquationMethod.linear})
      : super(A, b, method: method);

  /// Overridden fit method that solves the Total Least Squares problem
  ///
  /// This uses Singular Value Decomposition (SVD) instead of the normal equation
  /// method to solve for the coefficients.
  @override
  void fit(
      {LinearSystemMethod linear = LinearSystemMethod.leastSquares,
      DecompositionMethod decomposition = DecompositionMethod.singularValue}) {
    // Invalidate cached values
    _residuals = null;

    // The method of Total Least Squares involves performing Singular Value Decomposition (SVD) on the augmented matrix [A | b]
    Matrix augmented = A.augment(b);

    // Perform SVD
    SingularValueDecomposition svd =
        augmented.decomposition.singularValueDecomposition();

    // The solution is the last column of V corresponding to the smallest singular value
    beta = svd.V.column(svd.V.columnCount - 1);

    // Normalize the solution such that the last element is 1. This is because we augmented the column vector 'b' at the end
    beta /= beta[beta.rowCount - 1][0];

    // Discard the last element of beta as it corresponds to 'b'
    beta = beta.slice(0, beta.rowCount - 2, 0, 0);
  }

  /// Computes the residuals orthogonal to the fitted model
  ///
  /// These residuals are the perpendicular distances from each data point to the model.
  Matrix calculateOrthogonalResiduals() {
    // Perform prediction
    Matrix yPred = predict(A);

    // Compute residuals
    Matrix residuals = b - yPred;

    // The orthogonal residuals in TLS are not simply the differences between 'b' and 'yPred'.
    // Instead, we need to find the orthogonal projection of the residuals on the plane defined by 'beta'.
    Matrix orthogonalResiduals =
        residuals - beta * (beta.transpose() * residuals);

    return orthogonalResiduals;
  }

  /// Overridden residuals getter that calculates the orthogonal residuals
  @override
  Matrix get residuals {
    _residuals ??= calculateOrthogonalResiduals();
    return _residuals!;
  }
}

/// Implements Ridge Regression, a type of regularized linear regression.
/// It includes an L2 penalty term on the size of coefficients which helps
/// to control the magnitude of the coefficients.
///
/// The regularization parameter `alpha` controls the strength of the
/// penalty term. Larger values of `alpha` increase the effect of
/// regularization, shrinking coefficients towards zero to prevent overfitting.
///
/// ```dart
/// // Example usage:
/// var A = Matrix.fromList([[1, 2], [3, 4], [5, 6]]);
/// var b = Matrix.column([7, 8, 9]);
/// var alpha = 0.1;
/// var ridge = RidgeRegression(A, b, alpha);
///
/// ridge.fit();
///
/// print(ridge.beta);
/// // Output: Column Matrix of the estimated coefficients
///
/// print(ridge.residuals);
/// ```
class RidgeRegression extends BaseLeastSquares {
  final double alpha;

  RidgeRegression(Matrix A, ColumnMatrix b, this.alpha,
      {DiagonalMatrix? W, EquationMethod method = EquationMethod.linear})
      : super(A, b, W: W, method: method);

  @override
  void fit(
      {LinearSystemMethod linear = LinearSystemMethod.leastSquares,
      DecompositionMethod decomposition = DecompositionMethod.cholesky}) {
    // Invalidate cached values
    _residuals = null;
    _unitVariance = null;
    _standardDeviation = null;

    // The ridge regression normal equations are (A^TWA + alphaI)beta = A^TWb.
    Matrix I = Matrix.eye(A.columnCount);
    Matrix atWb = A.transpose() * (W ?? Matrix.eye(A.rowCount)) * b;
    Matrix atWAPlusAlphaI =
        normal() + I.scale(alpha); // Compute (A^TWA + alphaI)
    //beta = atWAPlusAlphaI.inverse() * atWb;
    beta = method == EquationMethod.linear
        ? atWAPlusAlphaI.linear.solve(atWb, method: linear)
        : atWAPlusAlphaI.decomposition.solve(atWb, method: decomposition);
  }
}

/// Implements Lasso Regression, a type of regularized linear regression.
/// It includes an L1 penalty term on the size of coefficients which helps
/// to control the magnitude of the coefficients and can produce models
/// with sparse coefficients (many coefficients being zero).
///
/// The regularization parameter `alpha` controls the strength of the
/// penalty term. Larger values of `alpha` increase the effect of
/// regularization, shrinking coefficients towards zero to prevent overfitting.
///
/// ```dart
/// // Example usage:
/// var A = Matrix.fromList([[1, 2], [3, 4], [5, 6]]);
/// var b = Matrix.column([7, 8, 9]);
/// var alpha = 0.1;
/// var lasso = LassoRegression(A, b, alpha);
///
/// lasso.fit();
///
/// print(lasso.beta);
/// // Output: Column Matrix of the estimated coefficients
///
/// print(lasso.residuals);
/// // Output: Column Matrix of the residuals (difference between observed and predicted responses)
/// ```
class LassoRegression extends BaseLeastSquares {
  final double alpha;

  LassoRegression(Matrix A, ColumnMatrix b, this.alpha,
      {DiagonalMatrix? W, EquationMethod method = EquationMethod.linear})
      : super(A, b, W: W, method: method);

  @override
  void fit(
      {LinearSystemMethod linear = LinearSystemMethod.leastSquares,
      DecompositionMethod decomposition = DecompositionMethod.cholesky}) {
    // The Lasso regression cannot be solved with standard matrix operations.
    // An iterative method such as coordinate descent or a gradient-based method is required.
    // Implementation of these methods goes beyond the scope of this example.
    throw UnimplementedError('LassoRegression.fit() is not implemented');
  }
}

/// Implements Elastic Net Regression, a type of regularized linear regression that
/// includes both L1 and L2 penalty terms.
///
/// The regularization parameter `alpha` controls the strength of the penalty terms, and `l1Ratio` controls the mix between L1 and L2 regularization. When `l1Ratio` equals 0, the penalty is an L2 penalty, and when it equals 1, the penalty is an L1 penalty.
///
/// As of the last update in September 2021, this functionality is not straightforward to implement with simple matrix operations, and typically requires optimization algorithms like coordinate descent or LARS which are not implemented in this code base.
///
/// ```dart
/// // Example usage:
/// var A = Matrix.fromList([[1, 2], [3, 4], [5, 6]]);
/// var b = Matrix.column([7, 8, 9]);
/// var alpha = 0.1;
/// var l1Ratio = 0.5;
/// var elasticNet = ElasticNetRegression(A, b, alpha, l1Ratio);
///
/// elasticNet.fit();
///
/// print(elasticNet.beta);
/// // Output: Column Matrix of the estimated coefficients
///
/// print(elasticNet.residuals);
/// // Output: Column Matrix of the residuals (difference between observed and predicted responses)
/// ```
class ElasticNetRegression extends BaseLeastSquares {
  final double alpha;
  final double l1Ratio;

  ElasticNetRegression(Matrix A, ColumnMatrix b, this.alpha, this.l1Ratio,
      {DiagonalMatrix? W, EquationMethod method = EquationMethod.linear})
      : super(A, b, W: W, method: method);

  @override
  void fit(
      {LinearSystemMethod linear = LinearSystemMethod.leastSquares,
      DecompositionMethod decomposition = DecompositionMethod.cholesky}) {
    throw UnimplementedError('ElasticNet regression is not yet implemented.');
  }
}

/// Implements Robust Least Squares, a type of linear regression that aims to be more resistant to outliers than ordinary least squares.
///
/// This implementation, however, does not specify a particular method for weighting the observations, which is a crucial part of making the method "robust". Without a specific weighting method, this implementation serves as a placeholder and does not add robustness beyond that provided by the parent class [LeastSquares].
///
/// ```dart
/// // Example usage:
/// var A = Matrix.fromList([[1, 2], [3, 4], [5, 6]]);
/// var b = Matrix.column([7, 8, 9]);
/// var robustLS = RobustLeastSquares(A, b);
///
/// robustLS.fit();
///
/// print(robustLS.beta);
/// // Output: Column Matrix of the estimated coefficients
///
/// print(robustLS.residuals);
/// // Output: Column Matrix of the residuals (difference between observed and predicted responses)
/// ```
class RobustLeastSquares extends BaseLeastSquares {
  RobustLeastSquares(Matrix A, ColumnMatrix b,
      {DiagonalMatrix? W, EquationMethod method = EquationMethod.linear})
      : super(A, b, W: W, method: method);

  // Implement the special method here
  void fitRobustly() {
    // Insert implementation here
  }
}
