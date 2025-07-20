part of '../algebra.dart';

/// Enum representing the available methods for solving linear systems.
///
/// [cramersRule] : Cramer's rule is an explicit formula for the solution
/// of a system of linear equations with as many equations as unknowns,
/// valid whenever the system has a unique solution.
///
/// [inverseMatrix] : Inverse matrix method computes the inverse of the
/// coefficient matrix and multiplies it with the constant terms matrix
/// to get the solution.
///
/// [gaussElimination] : Gauss Elimination method is a technique for
/// transforming the system into a triangular matrix and then solving
/// the system using back substitution.
///
/// [gaussJordanElimination] : Gauss-Jordan Elimination is an extension
/// of Gauss Elimination method, that reduces the system to a reduced
/// row-echelon form.
///
/// [leastSquares] : Least Squares method is used to find the best-fitting
/// solution to a system of linear equations by minimizing the sum of
/// the squares of the residuals.
///
/// [gramSchmidt] : Gram-Schmidt method is an orthogonalization
/// process applied to the columns of the coefficient matrix A,
/// which forms an orthogonal basis used to solve the linear system.
///
/// [luDecomposition] : LU Decomposition method decomposes the coefficient
/// matrix into a lower triangular matrix (L) and an upper triangular
/// matrix (U). The linear system is then solved by forward and backward
/// substitution.
///
/// [jacobi] : Jacobi method is an iterative algorithm for solving linear
/// systems, particularly useful when the coefficient matrix is diagonally
/// dominant.
///
/// [gaussSeidel] : Gauss-Seidel method is an iterative technique for
/// solving linear systems, similar to Jacobi method, but with the updates
/// applied immediately.
///
/// [bareiss] : Montante's Method (Bareiss Algorithm) is a generalization
/// of Gaussian Elimination for solving linear systems, used for finding
/// the determinant and the inverse of a matrix.
///
/// [sor] : Successive Over-Relaxation (SOR) method is an iterative technique
/// for solving linear systems, an extension of Gauss-Seidel method, that
/// improves the convergence rate by using a relaxation factor.
///
/// [conjugateGradient] : Conjugate Gradient method is an iterative technique
/// for solving systems of linear equations, particularly useful when the
/// coefficient matrix is symmetric and positive definite.
///
/// [ridgeRegression] : Ridge Regression is a regularization technique for
/// linear regression, particularly useful when multicollinearity exists
/// among the predictor variables, by adding a degree of bias to the
/// regression estimates.
enum LinearSystemMethod {
  cramersRule,
  inverseMatrix,
  gaussElimination,
  gaussJordanElimination,
  leastSquares,
  gramSchmidt,
  luDecomposition,
  jacobi,
  gaussSeidel,
  bareiss,
  sor,
  conjugateGradient,
  ridgeRegression,
}
