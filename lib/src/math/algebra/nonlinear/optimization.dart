part of '../algebra.dart';

/// Result of an optimization algorithm.
class OptimizationResult {
  /// The optimal point found.
  final Matrix solution;

  /// Function value at the optimal point.
  final num value;

  /// Number of iterations performed.
  final int iterations;

  /// Whether the algorithm converged.
  final bool converged;

  /// Additional message or error description.
  final String message;

  OptimizationResult({
    required this.solution,
    required this.value,
    required this.iterations,
    required this.converged,
    this.message = '',
  });

  @override
  String toString() {
    return 'OptimizationResult(converged: $converged, iterations: $iterations, value: $value, solution: $solution)';
  }
}

/// Optimization algorithms for finding minima of functions.
class Optimization {
  /// Minimizes a function using Gradient Descent.
  ///
  /// [f]: Objective function to minimize.
  /// [gradient]: Gradient of the objective function.
  /// [x0]: Initial guess.
  /// [learningRate]: Step size (default: 0.01).
  /// [maxIter]: Maximum iterations (default: 1000).
  /// [tolerance]: Convergence tolerance (default: 1e-6).
  static OptimizationResult gradientDescent(
    Function f,
    Function gradient,
    List<num> x0, {
    double learningRate = 0.01,
    int maxIter = 1000,
    double tolerance = 1e-6,
  }) {
    Matrix x = Matrix.fromList(x0.map((e) => [Complex(e)]).toList());

    for (int k = 0; k < maxIter; k++) {
      List<num> currentX =
          x.flatten().map((e) => e is Complex ? e.real : (e as num)).toList();

      // Compute gradient
      var gradResult = gradient(currentX);
      List<num> grad = (gradResult as List).cast<num>();
      Matrix gradMatrix =
          Matrix.fromList(grad.map((e) => [Complex(e.toDouble())]).toList());

      // Update: x = x - learningRate * gradient
      Matrix xNew = x - gradMatrix.scale(learningRate);

      // Check convergence
      if ((xNew - x).norm(Norm.manhattan) < tolerance) {
        List<num> finalX = xNew
            .flatten()
            .map((e) => e is Complex ? e.real : (e as num))
            .toList();
        return OptimizationResult(
          solution: xNew,
          value: f(finalX),
          iterations: k + 1,
          converged: true,
        );
      }

      x = xNew;
    }

    List<num> finalX = x.flatten().map((e) => (e as Complex).real).toList();
    return OptimizationResult(
      solution: x,
      value: f(finalX),
      iterations: maxIter,
      converged: false,
      message: 'Max iterations reached',
    );
  }

  /// Minimizes a function using Conjugate Gradient method (Fletcher-Reeves).
  static OptimizationResult conjugateGradient(
    Function f,
    Function gradient,
    List<num> x0, {
    int maxIter = 1000,
    double tolerance = 1e-6,
  }) {
    Matrix x = Matrix.fromList(x0.map((e) => [Complex(e)]).toList());
    List<num> currentX = x0;

    // Initial gradient
    dynamic gradResult = gradient(currentX);
    List<num> grad =
        (gradResult is List) ? gradResult.cast<num>() : gradResult as List<num>;
    Matrix gradMatrix =
        Matrix.fromList(grad.map((e) => [Complex(-e.toDouble())]).toList());
    Matrix direction = gradMatrix.copy(); // d = -grad

    for (int k = 0; k < maxIter; k++) {
      currentX =
          x.flatten().map((e) => e is Complex ? e.real : (e as num)).toList();

      // Line search to find optimal step size
      List<num> dir = direction
          .flatten()
          .map((e) => e is Complex ? e.real : (e as num))
          .toList();
      double alpha = _lineSearch(f, currentX, dir);

      // Update position
      Matrix xNew = x + direction.scale(alpha);
      List<num> xNewList = xNew
          .flatten()
          .map((e) => e is Complex ? e.real : (e as num))
          .toList();

      // New gradient
      var gradNewResult = gradient(xNewList);
      List<num> gradNew = (gradNewResult as List).cast<num>();
      Matrix gradNewMatrix =
          Matrix.fromList(gradNew.map((e) => [Complex(e.toDouble())]).toList());

      // Check convergence
      if (gradNewMatrix.norm(Norm.manhattan) < tolerance) {
        return OptimizationResult(
          solution: xNew,
          value: f(xNewList),
          iterations: k + 1,
          converged: true,
        );
      }

      // Fletcher-Reeves: beta = ||grad_new||^2 / ||grad||^2
      gradMatrix =
          Matrix.fromList(grad.map((e) => [Complex(e.toDouble())]).toList());
      double beta = (gradNewMatrix.norm(Norm.frobenius) *
              gradNewMatrix.norm(Norm.frobenius)) /
          (gradMatrix.norm(Norm.frobenius) * gradMatrix.norm(Norm.frobenius));

      // Update direction: d = -grad_new + beta * d
      direction = gradNewMatrix.scale(-1) + direction.scale(beta);

      x = xNew;
      grad = gradNew;
    }

    List<num> finalX = x.flatten().map((e) => (e as Complex).real).toList();
    return OptimizationResult(
      solution: x,
      value: f(finalX),
      iterations: maxIter,
      converged: false,
      message: 'Max iterations reached',
    );
  }

  /// Minimizes a function using BFGS (Broyden-Fletcher-Goldfarb-Shanno) method.
  static OptimizationResult bfgs(
    Function f,
    Function gradient,
    List<num> x0, {
    int maxIter = 1000,
    double tolerance = 1e-6,
  }) {
    int n = x0.length;
    Matrix x = Matrix.fromList(x0.map((e) => [Complex(e)]).toList());
    Matrix H = Matrix.eye(n); // Initial Hessian approximation (identity)

    for (int k = 0; k < maxIter; k++) {
      List<num> currentX =
          x.flatten().map((e) => e is Complex ? e.real : (e as num)).toList();

      // Compute gradient
      var gradResult = gradient(currentX);
      List<num> grad = (gradResult as List).cast<num>();
      Matrix gradMatrix =
          Matrix.fromList(grad.map((e) => [Complex(e.toDouble())]).toList());

      // Check convergence
      if (gradMatrix.norm(Norm.manhattan) < tolerance) {
        return OptimizationResult(
          solution: x,
          value: f(currentX),
          iterations: k,
          converged: true,
        );
      }

      // Compute search direction: p = -H * grad
      Matrix p = (H * gradMatrix).scale(-1);
      List<num> pList =
          p.flatten().map((e) => e is Complex ? e.real : (e as num)).toList();

      // Line search
      double alpha = _lineSearch(f, currentX, pList);

      // Update position: s = alpha * p
      Matrix s = p.scale(alpha);
      Matrix xNew = x + s;
      List<num> xNewList = xNew
          .flatten()
          .map((e) => e is Complex ? e.real : (e as num))
          .toList();

      // New gradient
      List<num> gradNew = gradient(xNewList) as List<num>;
      Matrix gradNewMatrix =
          Matrix.fromList(gradNew.map((e) => [Complex(e)]).toList());

      // y = grad_new - grad
      Matrix y = gradNewMatrix - gradMatrix;

      // BFGS update of Hessian approximation
      // H = H + (s^T y + y^T H y)(s s^T)/(s^T y)^2 - (H y s^T + s y^T H)/(s^T y)
      Matrix sTy = s.transpose() * y;
      num sTyVal = (sTy[0][0] as Complex).real;

      if (sTyVal.abs() > 1e-10) {
        Matrix yTHy = y.transpose() * H * y;
        num yTHyVal = (yTHy[0][0] as Complex).real;

        Matrix ssT = s * s.transpose();
        Matrix hyysT = (H * y) * s.transpose();
        Matrix syyTH = s * (y.transpose() * H);

        H = H +
            ssT.scale((sTyVal + yTHyVal) / (sTyVal * sTyVal)) -
            (hyysT + syyTH).scale(1 / sTyVal);
      }

      x = xNew;
    }

    List<num> finalX = x.flatten().map((e) => (e as Complex).real).toList();
    return OptimizationResult(
      solution: x,
      value: f(finalX),
      iterations: maxIter,
      converged: false,
      message: 'Max iterations reached',
    );
  }

  /// Minimizes a function using Nelder-Mead simplex method (derivative-free).
  static OptimizationResult nelderMead(
    Function f,
    List<num> x0, {
    int maxIter = 1000,
    double tolerance = 1e-6,
  }) {
    int n = x0.length;

    // Create initial simplex
    List<List<num>> simplex = [x0];
    for (int i = 0; i < n; i++) {
      List<num> vertex = List<num>.from(x0);
      vertex[i] += 1.0; // Offset each dimension
      simplex.add(vertex);
    }

    // Nelder-Mead coefficients
    double alpha = 1.0; // Reflection
    double gamma = 2.0; // Expansion
    double rho = 0.5; // Contraction
    double sigma = 0.5; // Shrink

    for (int iter = 0; iter < maxIter; iter++) {
      // Sort simplex by function values
      simplex.sort((a, b) => (f(a) as num).compareTo(f(b) as num));

      // Check convergence
      num fBest = f(simplex[0]);
      num fWorst = f(simplex[n]);
      if ((fWorst - fBest).abs() < tolerance) {
        return OptimizationResult(
          solution:
              Matrix.fromList(simplex[0].map((e) => [Complex(e)]).toList()),
          value: fBest,
          iterations: iter,
          converged: true,
        );
      }

      // Compute centroid (excluding worst point)
      List<num> centroid = List.filled(n, 0.0);
      for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
          centroid[j] += simplex[i][j];
        }
      }
      centroid = centroid.map((e) => e / n).toList();

      // Reflection
      List<num> xReflect = List.generate(
        n,
        (i) => centroid[i] + alpha * (centroid[i] - simplex[n][i]),
      );
      num fReflect = f(xReflect);

      if (f(simplex[0]) <= fReflect && fReflect < f(simplex[n - 1])) {
        simplex[n] = xReflect;
        continue;
      }

      // Expansion
      if (fReflect < f(simplex[0])) {
        List<num> xExpand = List.generate(
          n,
          (i) => centroid[i] + gamma * (xReflect[i] - centroid[i]),
        );
        num fExpand = f(xExpand);
        simplex[n] = fExpand < fReflect ? xExpand : xReflect;
        continue;
      }

      // Contraction
      List<num> xContract = List.generate(
        n,
        (i) => centroid[i] + rho * (simplex[n][i] - centroid[i]),
      );
      num fContract = f(xContract);

      if (fContract < f(simplex[n])) {
        simplex[n] = xContract;
        continue;
      }

      // Shrink
      for (int i = 1; i <= n; i++) {
        simplex[i] = List.generate(
          n,
          (j) => simplex[0][j] + sigma * (simplex[i][j] - simplex[0][j]),
        );
      }
    }

    List<num> best = simplex[0];
    return OptimizationResult(
      solution: Matrix.fromList(best.map((e) => [Complex(e)]).toList()),
      value: f(best),
      iterations: maxIter,
      converged: false,
      message: 'Max iterations reached',
    );
  }

  /// Minimizes a constrained function using penalty method.
  ///
  /// Constraints should return 0 when satisfied, positive when violated.
  static OptimizationResult penaltyMethod(
    Function f,
    List<Function> constraints,
    List<num> x0, {
    double penalty = 10.0,
    int maxIter = 1000,
    double tolerance = 1e-6,
  }) {
    // Augmented objective with penalty
    num penaltyObjective(List<num> x) {
      num obj = f(x);
      for (var constraint in constraints) {
        num violation = constraint(x);
        if (violation > 0) {
          obj += penalty * violation * violation;
        }
      }
      return obj;
    }

    // Use Nelder-Mead for unconstrained minimization of penalty objective
    return nelderMead(
      penaltyObjective,
      x0,
      maxIter: maxIter,
      tolerance: tolerance,
    );
  }

  /// Backtracking line search (Armijo condition).
  static double _lineSearch(
    Function f,
    List<num> x,
    List<num> direction, {
    double alpha = 1.0,
    double c = 0.0001,
    double rho = 0.5,
  }) {
    num f0 = f(x);

    // Approximate directional derivative
    List<num> grad = _approximateGradient(f, x);
    double dirDeriv = 0.0;
    for (int i = 0; i < x.length; i++) {
      dirDeriv += grad[i] * direction[i];
    }

    // Backtracking
    for (int i = 0; i < 20; i++) {
      List<num> xNew =
          List.generate(x.length, (j) => x[j] + alpha * direction[j]);
      if (f(xNew) <= f0 + c * alpha * dirDeriv) {
        return alpha;
      }
      alpha *= rho;
    }

    return alpha;
  }

  /// Approximates gradient using finite differences.
  static List<num> _approximateGradient(Function f, List<num> x) {
    int n = x.length;
    double h = 1e-8;
    List<num> grad = [];

    num fx = f(x);
    for (int i = 0; i < n; i++) {
      List<num> xh = List<num>.from(x);
      xh[i] += h;
      grad.add((f(xh) - fx) / h);
    }

    return grad;
  }
}
