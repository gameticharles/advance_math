part of '../algebra.dart';

/// Result of a nonlinear system solver.
class NonlinearSystemResult {
  /// The solution vector.
  final Matrix solution;

  /// Number of iterations performed.
  final int iterations;

  /// Whether the solver converged.
  final bool converged;

  /// Additional message or error description.
  final String message;

  NonlinearSystemResult({
    required this.solution,
    required this.iterations,
    required this.converged,
    this.message = '',
  });

  @override
  String toString() {
    return 'NonlinearSystemResult(converged: $converged, iterations: $iterations, solution: $solution)';
  }
}

/// Solvers for systems of nonlinear equations.
class NonlinearSystems {
  /// Solves a system of nonlinear equations using Newton's method.
  ///
  /// [functions]: A list of functions $f_1, f_2, ..., f_n$ where each takes a `List<num>` (the variables) and returns a `num`.
  /// [initialGuess]: Initial guess for the variables.
  /// [jacobian]: Optional function to compute the Jacobian matrix. If null, it is approximated numerically.
  /// [maxIter]: Maximum number of iterations.
  /// [tolerance]: Convergence tolerance.
  ///
  /// Returns a [NonlinearSystemResult].
  static NonlinearSystemResult newton(
    List<Function> functions,
    List initialGuess, {
    Function(List)? jacobian,
    int maxIter = 100,
    double tolerance = 1e-6,
  }) {
    int n = initialGuess.length;
    if (functions.length != n) {
      throw ArgumentError(
          'Number of functions must match number of variables.');
    }

    Matrix x = Matrix.fromList(initialGuess.map((e) => [e]).toList());

    for (int k = 0; k < maxIter; k++) {
      List<num> currentX =
          x.flatten().map((e) => e is Complex ? e.real : e as num).toList();

      // Evaluate F(x)
      Matrix F = Matrix.zeros(n, 1);
      for (int i = 0; i < n; i++) {
        F[i][0] = Complex(functions[i](currentX) as num);
      }

      // Check convergence
      if (F.norm(Norm.manhattan) < tolerance) {
        return NonlinearSystemResult(
          solution: x,
          iterations: k,
          converged: true,
        );
      }

      // Compute Jacobian J(x)
      Matrix J;
      if (jacobian != null) {
        // User provided Jacobian might return Matrix or List<List<num>>
        dynamic jVal = jacobian(currentX);
        if (jVal is Matrix) {
          J = jVal;
        } else {
          J = Matrix.fromList(jVal);
        }
      } else {
        J = _approximateJacobian(functions, currentX);
      }

      // Solve J * deltaX = -F
      try {
        Matrix deltaX = J.linear
            .solve(F.scale(-1), method: LinearSystemMethod.gaussElimination);
        x = x + deltaX;

        if (deltaX.norm(Norm.manhattan) < tolerance) {
          return NonlinearSystemResult(
            solution: x,
            iterations: k + 1,
            converged: true,
          );
        }
      } catch (e) {
        return NonlinearSystemResult(
          solution: x,
          iterations: k,
          converged: false,
          message: 'Singular Jacobian or solver error: $e',
        );
      }
    }

    return NonlinearSystemResult(
      solution: x,
      iterations: maxIter,
      converged: false,
      message: 'Max iterations reached',
    );
  }

  /// Solves a system using Broyden's method (Quasi-Newton).
  ///
  /// Updates the Jacobian approximation iteratively, avoiding expensive re-calculation.
  static NonlinearSystemResult broyden(
    List<Function> functions,
    List initialGuess, {
    int maxIter = 100,
    double tolerance = 1e-6,
  }) {
    int n = initialGuess.length;
    Matrix x = Matrix.fromList(initialGuess.map((e) => [e]).toList());

    // Initial Jacobian approximation
    List<num> currentX =
        x.flatten().map((e) => e is Complex ? e.real : e as num).toList();
    Matrix J = _approximateJacobian(functions, currentX);

    // Evaluate F(x)
    Matrix F = Matrix.zeros(n, 1);
    for (int i = 0; i < n; i++) {
      F[i][0] = Complex(functions[i](currentX) as num);
    }

    for (int k = 0; k < maxIter; k++) {
      if (F.norm(Norm.manhattan) < tolerance) {
        return NonlinearSystemResult(
          solution: x,
          iterations: k,
          converged: true,
        );
      }

      // Solve J * deltaX = -F
      Matrix deltaX;
      try {
        deltaX = J.linear
            .solve(F.scale(-1), method: LinearSystemMethod.gaussElimination);
      } catch (e) {
        // Fallback or restart could be implemented here
        return NonlinearSystemResult(
          solution: x,
          iterations: k,
          converged: false,
          message: 'Singular Jacobian in Broyden step: $e',
        );
      }

      Matrix xNew = x + deltaX;
      List<num> xNewList =
          xNew.flatten().map((e) => e is Complex ? e.real : e as num).toList();

      // Evaluate F(xNew)
      Matrix fNew = Matrix.zeros(n, 1);
      for (int i = 0; i < n; i++) {
        fNew[i][0] = Complex(functions[i](xNewList) as num);
      }

      // Broyden update
      // y = FNew - F
      Matrix y = fNew - F;

      // J = J + (y - J * deltaX) * deltaX^T / (deltaX^T * deltaX)
      // Note: J * deltaX is approximately -F from the solve step, but we compute it exactly or use y - (-F) = FNew?
      // Actually J * deltaX = -F is only true if solved exactly.
      // Standard update: J_{k+1} = J_k + \frac{y_k - J_k s_k}{s_k^T s_k} s_k^T

      Matrix jdx = J * deltaX;
      Matrix numTerm = (y - jdx);
      Matrix denTerm = deltaX.transpose() * deltaX;
      num den = (denTerm[0][0] as Complex).real;

      if (den.abs() < 1e-15) {
        // Step too small, stop
        return NonlinearSystemResult(
          solution: xNew,
          iterations: k + 1,
          converged: true, // or false?
          message: 'Step size too small for update',
        );
      }

      J = J + (numTerm * deltaX.transpose()).scale(1 / den);

      x = xNew;
      F = fNew;
    }

    return NonlinearSystemResult(
      solution: x,
      iterations: maxIter,
      converged: false,
      message: 'Max iterations reached',
    );
  }

  /// Solves a system using Fixed-Point Iteration.
  ///
  /// [gFunctions]: List of functions $g_i(x)$ such that $x_i = g_i(x)$.
  static NonlinearSystemResult fixedPoint(
    List<Function> gFunctions,
    List initialGuess, {
    int maxIter = 100,
    double tolerance = 1e-6,
  }) {
    int n = initialGuess.length;
    Matrix x = Matrix.fromList(initialGuess.map((e) => [e]).toList());

    for (int k = 0; k < maxIter; k++) {
      List<num> currentX =
          x.flatten().map((e) => e is Complex ? e.real : e as num).toList();
      Matrix xNew = Matrix.zeros(n, 1);

      for (int i = 0; i < n; i++) {
        xNew[i][0] = Complex(gFunctions[i](currentX) as num);
      }

      if ((xNew - x).norm(Norm.manhattan) < tolerance) {
        return NonlinearSystemResult(
          solution: xNew,
          iterations: k + 1,
          converged: true,
        );
      }

      x = xNew;
    }

    return NonlinearSystemResult(
      solution: x,
      iterations: maxIter,
      converged: false,
      message: 'Max iterations reached',
    );
  }

  static Matrix _approximateJacobian(List<Function> functions, List<num> x) {
    int n = x.length;
    Matrix J = Matrix.zeros(n, n);
    double h = 1e-8;

    List<num> fx = functions.map((f) => f(x) as num).toList();

    for (int j = 0; j < n; j++) {
      List<num> xPlusH = List<num>.from(x);
      xPlusH[j] = xPlusH[j] + h;

      for (int i = 0; i < n; i++) {
        num fxh = functions[i](xPlusH) as num;
        J[i][j] = Complex((fxh - fx[i]) / h);
      }
    }
    return J;
  }
}
