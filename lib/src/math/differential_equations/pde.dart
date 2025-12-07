import '../algebra/algebra.dart';
import 'ode.dart';

/// Result of a PDE solver.
class PDEResult {
  /// Solution u(x,t) as matrix where rows are time steps, columns are spatial points.
  final Matrix solution;

  /// Spatial grid points.
  final List<num> x;

  /// Time grid points.
  final List<num> t;

  /// Whether the solver succeeded.
  final bool success;

  /// Additional message or error description.
  final String message;

  PDEResult({
    required this.solution,
    required this.x,
    required this.t,
    required this.success,
    this.message = '',
  });

  @override
  String toString() {
    return 'PDEResult(success: $success, grid: ${x.length}x${t.length})';
  }
}

/// Solvers for Partial Differential Equations.
class PDE {
  /// Solves 1D heat equation using finite difference method.
  ///
  /// Solves: ∂u/∂t = alpha * ∂²u/∂x²
  ///
  /// [alpha]: Thermal diffusivity constant.
  /// [initial]: Initial condition u(x, 0).
  /// [xRange]: `[x_min, x_max]`.
  /// [tRange]: `[t_min, t_max]`.
  /// [boundaryLeft]: Boundary value at x = x_min.
  /// [boundaryRight]: Boundary value at x = x_max.
  /// [nx]: Number of spatial points.
  /// [nt]: Number of time steps.
  static PDEResult heatEquation1D(
    num alpha,
    List<num> xRange,
    List<num> tRange,
    Function(num) initial,
    num boundaryLeft,
    num boundaryRight, {
    int nx = 50,
    int nt = 100,
  }) {
    num xMin = xRange[0], xMax = xRange[1];
    num tMin = tRange[0], tMax = tRange[1];

    num dx = (xMax - xMin) / (nx - 1);
    num dt = (tMax - tMin) / nt;
    num r = alpha * dt / (dx * dx);

    // Stability check
    if (r > 0.5) {
      return PDEResult(
        solution: Matrix.zeros(1, 1),
        x: [],
        t: [],
        success: false,
        message: 'Unstable: r = $r > 0.5. Reduce dt or increase dx.',
      );
    }

    List<num> x = List.generate(nx, (i) => xMin + i * dx);
    List<num> t = List.generate(nt + 1, (i) => tMin + i * dt);

    // Initialize solution matrix
    List<List<num>> u = List.generate(nt + 1, (_) => List.filled(nx, 0.0));

    // Initial condition
    for (int i = 0; i < nx; i++) {
      u[0][i] = initial(x[i]).toDouble();
    }

    // Time stepping using explicit finite difference
    for (int n = 0; n < nt; n++) {
      for (int i = 1; i < nx - 1; i++) {
        u[n + 1][i] = u[n][i] + r * (u[n][i + 1] - 2 * u[n][i] + u[n][i - 1]);
      }
      // Boundary conditions
      u[n + 1][0] = boundaryLeft.toDouble();
      u[n + 1][nx - 1] = boundaryRight.toDouble();
    }

    return PDEResult(
      solution: Matrix.fromList(u),
      x: x,
      t: t,
      success: true,
    );
  }

  /// Solves 1D wave equation using finite difference method.
  ///
  /// Solves: ∂²u/∂t² = c² * ∂²u/∂x²
  ///
  /// [c]: Wave speed.
  /// [xRange]: `[x_min, x_max]`.
  /// [tRange]: `[t_min, t_max]`.
  /// [initialPosition]: Initial position u(x, 0).
  /// [initialVelocity]: Initial velocity ∂u/∂t(x, 0).
  /// [boundaryLeft]: Boundary value at x = x_min.
  /// [boundaryRight]: Boundary value at x = x_max.
  static PDEResult waveEquation1D(
    num c,
    List<num> xRange,
    List<num> tRange,
    Function(num) initialPosition,
    Function(num) initialVelocity,
    num boundaryLeft,
    num boundaryRight, {
    int nx = 50,
    int nt = 100,
  }) {
    num xMin = xRange[0], xMax = xRange[1];
    num tMin = tRange[0], tMax = tRange[1];

    num dx = (xMax - xMin) / (nx - 1);
    num dt = (tMax - tMin) / nt;
    num r = c * dt / dx;

    // Stability check (CFL condition)
    if (r > 1) {
      return PDEResult(
        solution: Matrix.zeros(1, 1),
        x: [],
        t: [],
        success: false,
        message: 'Unstable: CFL condition violated. r = $r > 1.',
      );
    }

    List<num> x = List.generate(nx, (i) => xMin + i * dx);
    List<num> t = List.generate(nt + 1, (i) => tMin + i * dt);

    List<List<num>> u = List.generate(nt + 1, (_) => List.filled(nx, 0.0));

    // Initial condition
    for (int i = 0; i < nx; i++) {
      u[0][i] = initialPosition(x[i]).toDouble();
    }

    // First time step using forward difference for velocity
    for (int i = 1; i < nx - 1; i++) {
      u[1][i] = u[0][i] +
          dt * initialVelocity(x[i]).toDouble() +
          0.5 * r * r * (u[0][i + 1] - 2 * u[0][i] + u[0][i - 1]);
    }
    u[1][0] = boundaryLeft.toDouble();
    u[1][nx - 1] = boundaryRight.toDouble();

    // Time stepping
    num r2 = r * r;
    for (int n = 1; n < nt; n++) {
      for (int i = 1; i < nx - 1; i++) {
        u[n + 1][i] = 2 * u[n][i] -
            u[n - 1][i] +
            r2 * (u[n][i + 1] - 2 * u[n][i] + u[n][i - 1]);
      }
      u[n + 1][0] = boundaryLeft.toDouble();
      u[n + 1][nx - 1] = boundaryRight.toDouble();
    }

    return PDEResult(
      solution: Matrix.fromList(u),
      x: x,
      t: t,
      success: true,
    );
  }
}

/// Solvers for Boundary Value Problems.
class BVP {
  /// Solves BVP using shooting method.
  ///
  /// Solves: y'' = f(x, y, y') with y(a) = ya, y(b) = yb
  ///
  /// [f]: Function defining y'' = f(x, y, y').
  /// [xa]: Left boundary point.
  /// [xb]: Right boundary point.
  /// [ya]: Boundary value at xa.
  /// [yb]: Boundary value at xb.
  /// [initialSlope]: Initial guess for y'(a).
  /// [tol]: Tolerance for boundary condition.
  /// [maxIter]: Maximum iterations for shooting.
  static ODEResult shootingMethod(
    Function f,
    num xa,
    num xb,
    num ya,
    num yb, {
    num initialSlope = 0,
    double tol = 1e-6,
    int maxIter = 50,
  }) {
    // Convert second-order ODE to system of first-order ODEs
    // y1 = y, y2 = y'
    // y1' = y2
    // y2' = f(x, y1, y2)
    List<num> dydt(num x, List<num> y) {
      return [y[1], f(x, y[0], y[1])];
    }

    num slope1 = initialSlope;
    num slope2 = initialSlope + 1;

    for (int iter = 0; iter < maxIter; iter++) {
      // Solve IVP with guess slope1
      var result1 = ODE.rk4(dydt, [ya, slope1], xa, xb, steps: 100);
      num yb1 = result1.y.last[0];

      // Check if close enough
      if ((yb1 - yb).abs() < tol) {
        // Extract just the y values (not y')
        var yValues = result1.y.map((pt) => (pt as List<num>)[0]).toList();
        return ODEResult(
          t: result1.t,
          y: yValues,
          steps: result1.steps,
          success: true,
        );
      }

      // Solve with slope2
      var result2 = ODE.rk4(dydt, [ya, slope2], xa, xb, steps: 100);
      num yb2 = result2.y.last[0];

      // Secant method to update slopes
      num slopeNew = slope2 - (yb2 - yb) * (slope2 - slope1) / (yb2 - yb1);
      slope1 = slope2;
      slope2 = slopeNew;
    }

    return ODEResult(
      t: [],
      y: [],
      steps: maxIter,
      success: false,
      message: 'Shooting method did not converge',
    );
  }

  /// Solves linear BVP using finite difference method.
  ///
  /// Solves: y'' + p(x)y' + q(x)y = r(x) with y(a) = ya, y(b) = yb
  ///
  /// [p]: Function p(x).
  /// [q]: Function q(x).
  /// [r]: Function r(x).
  /// [xa]: Left boundary point.
  /// [xb]: Right boundary point.
  /// [ya]: Boundary value at xa.
  /// [yb]: Boundary value at xb.
  /// [n]: Number of interior points.
  static ODEResult finiteDifference(
    Function p,
    Function q,
    Function r,
    num xa,
    num xb,
    num ya,
    num yb, {
    int n = 99,
  }) {
    num h = (xb - xa) / (n + 1);
    List<num> x = List.generate(n + 2, (i) => xa + i * h);

    // Build tridiagonal system
    List<List<num>> A = List.generate(n, (_) => List.filled(n, 0.0));
    List<num> b = List.filled(n, 0.0);

    for (int i = 0; i < n; i++) {
      num xi = x[i + 1];
      num pi = p(xi).toDouble();
      num qi = q(xi).toDouble();
      num ri = r(xi).toDouble();

      // Diagonal
      A[i][i] = -2 / (h * h) + qi;

      // Off-diagonals
      if (i > 0) A[i][i - 1] = 1 / (h * h) - pi / (2 * h);
      if (i < n - 1) A[i][i + 1] = 1 / (h * h) + pi / (2 * h);

      // Right-hand side
      b[i] = ri;
      if (i == 0) b[i] -= ya * (1 / (h * h) - pi / (2 * h));
      if (i == n - 1) b[i] -= yb * (1 / (h * h) + pi / (2 * h));
    }

    // Solve tridiagonal system using Thomas algorithm
    List<num> y = _solveTridiagonal(A, b);

    // Add boundary values
    List<num> yfull = [ya, ...y, yb];

    return ODEResult(
      t: x,
      y: yfull,
      steps: n,
      success: true,
    );
  }

  /// Thomas algorithm for tridiagonal systems.
  static List<num> _solveTridiagonal(List<List<num>> A, List<num> b) {
    int n = b.length;
    List<num> c = List.filled(n, 0.0);
    List<num> d = List.filled(n, 0.0);
    List<num> x = List.filled(n, 0.0);

    // Forward elimination
    c[0] = (A[0].length > 1 ? A[0][1] : 0) / A[0][0];
    d[0] = b[0] / A[0][0];

    for (int i = 1; i < n; i++) {
      num denom = A[i][i] - (i > 0 ? A[i][i - 1] : 0) * c[i - 1];
      if (i < n - 1) c[i] = A[i][i + 1] / denom;
      d[i] = (b[i] - (i > 0 ? A[i][i - 1] : 0) * d[i - 1]) / denom;
    }

    // Back substitution
    x[n - 1] = d[n - 1];
    for (int i = n - 2; i >= 0; i--) {
      x[i] = d[i] - c[i] * x[i + 1];
    }

    return x;
  }
}
