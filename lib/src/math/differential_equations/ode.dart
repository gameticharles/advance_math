/// Result of an ODE solver.
class ODEResult {
  /// Time points.
  final List<num> t;

  /// Solution values at each time point.
  /// For single ODE: `List<num>`
  /// For systems: `List<List<num>>` where each inner list is `[y1, y2, ..., yn]` at time t[i]
  final List<dynamic> y;

  /// Number of steps taken.
  final int steps;

  /// Whether the solver succeeded.
  final bool success;

  /// Additional message or error description.
  final String message;

  ODEResult({
    required this.t,
    required this.y,
    required this.steps,
    required this.success,
    this.message = '',
  });

  @override
  String toString() {
    return 'ODEResult(success: $success, steps: $steps, points: ${t.length})';
  }
}

/// Solvers for Ordinary Differential Equations.
class ODE {
  /// Solves ODE using Euler's method.
  ///
  /// [dydt]: Function defining dy/dt = f(t, y). For systems, returns `List<num>`.
  /// [y0]: Initial condition(s). Single value for scalar ODE, `List<num>` for systems.
  /// [t0]: Initial time.
  /// [tf]: Final time.
  /// [steps]: Number of steps.
  static ODEResult euler(
    Function dydt,
    dynamic y0,
    num t0,
    num tf, {
    int steps = 100,
  }) {
    bool isSystem = y0 is List;
    num h = (tf - t0) / steps;

    List<num> tValues = [];
    List<dynamic> yValues = [];

    num t = t0;
    dynamic y = isSystem ? List<num>.from(y0) : y0;

    for (int i = 0; i <= steps; i++) {
      tValues.add(t);
      yValues.add(isSystem ? List<num>.from(y) : y);

      if (i < steps) {
        dynamic dydtVal = dydt(t, y);
        if (isSystem) {
          List<num> yList = y as List<num>;
          List<num> dydtList = dydtVal as List<num>;
          y = List.generate(yList.length, (j) => yList[j] + h * dydtList[j]);
        } else {
          y = y + h * dydtVal;
        }
        t = t0 + (i + 1) * h;
      }
    }

    return ODEResult(
      t: tValues,
      y: yValues,
      steps: steps,
      success: true,
    );
  }

  /// Solves ODE using 4th-order Runge-Kutta method.
  static ODEResult rk4(
    Function dydt,
    dynamic y0,
    num t0,
    num tf, {
    int steps = 100,
  }) {
    bool isSystem = y0 is List;
    num h = (tf - t0) / steps;

    List<num> tValues = [];
    List<dynamic> yValues = [];

    num t = t0;
    dynamic y = isSystem ? List<num>.from(y0) : y0;

    for (int i = 0; i <= steps; i++) {
      tValues.add(t);
      yValues.add(isSystem ? List<num>.from(y) : y);

      if (i < steps) {
        if (isSystem) {
          List<num> yList = y as List<num>;
          int n = yList.length;

          List<num> k1 = dydt(t, yList) as List<num>;
          List<num> k2 =
              dydt(t + h / 2, List.generate(n, (j) => yList[j] + h * k1[j] / 2))
                  as List<num>;
          List<num> k3 =
              dydt(t + h / 2, List.generate(n, (j) => yList[j] + h * k2[j] / 2))
                  as List<num>;
          List<num> k4 =
              dydt(t + h, List.generate(n, (j) => yList[j] + h * k3[j]))
                  as List<num>;

          y = List.generate(
              n,
              (j) =>
                  yList[j] + h * (k1[j] + 2 * k2[j] + 2 * k3[j] + k4[j]) / 6);
        } else {
          num k1 = dydt(t, y);
          num k2 = dydt(t + h / 2, y + h * k1 / 2);
          num k3 = dydt(t + h / 2, y + h * k2 / 2);
          num k4 = dydt(t + h, y + h * k3);

          y = y + h * (k1 + 2 * k2 + 2 * k3 + k4) / 6;
        }
        t = t0 + (i + 1) * h;
      }
    }

    return ODEResult(
      t: tValues,
      y: yValues,
      steps: steps,
      success: true,
    );
  }

  /// Solves ODE using Runge-Kutta-Fehlberg adaptive method (RK45).
  static ODEResult rk45(
    Function dydt,
    dynamic y0,
    num t0,
    num tf, {
    double tol = 1e-6,
    num hMax = 0.1,
    num hMin = 1e-10,
  }) {
    bool isSystem = y0 is List;

    List<num> tValues = [t0];
    List<dynamic> yValues = [isSystem ? List<num>.from(y0) : y0];

    num t = t0;
    dynamic y = isSystem ? List<num>.from(y0) : y0;
    num h = (tf - t0) / 100; // Initial step size
    int steps = 0;

    while (t < tf) {
      if (t + h > tf) h = tf - t;

      // RK45 coefficients
      dynamic k1, k2, k3, k4, k5, k6;
      dynamic y4, y5; // 4th and 5th order estimates

      if (isSystem) {
        List<num> yList = y as List<num>;
        int n = yList.length;

        k1 = dydt(t, yList) as List<num>;
        k2 = dydt(t + h / 4, List.generate(n, (j) => yList[j] + h * k1[j] / 4))
            as List<num>;
        k3 = dydt(
                t + 3 * h / 8,
                List.generate(
                    n, (j) => yList[j] + h * (3 * k1[j] + 9 * k2[j]) / 32))
            as List<num>;
        k4 = dydt(
            t + 12 * h / 13,
            List.generate(
                n,
                (j) =>
                    yList[j] +
                    h *
                        (1932 * k1[j] - 7200 * k2[j] + 7296 * k3[j]) /
                        2197)) as List<num>;
        k5 = dydt(
            t + h,
            List.generate(
                n,
                (j) =>
                    yList[j] +
                    h *
                        (439 * k1[j] / 216 -
                            8 * k2[j] +
                            3680 * k3[j] / 513 -
                            845 * k4[j] / 4104))) as List<num>;
        k6 = dydt(
            t + h / 2,
            List.generate(
                n,
                (j) =>
                    yList[j] +
                    h *
                        (-8 * k1[j] / 27 +
                            2 * k2[j] -
                            3544 * k3[j] / 2565 +
                            1859 * k4[j] / 4104 -
                            11 * k5[j] / 40))) as List<num>;

        y4 = List.generate(
            n,
            (j) =>
                yList[j] +
                h *
                    (25 * k1[j] / 216 +
                        1408 * k3[j] / 2565 +
                        2197 * k4[j] / 4104 -
                        k5[j] / 5));
        y5 = List.generate(
            n,
            (j) =>
                yList[j] +
                h *
                    (16 * k1[j] / 135 +
                        6656 * k3[j] / 12825 +
                        28561 * k4[j] / 56430 -
                        9 * k5[j] / 50 +
                        2 * k6[j] / 55));
      } else {
        k1 = dydt(t, y);
        k2 = dydt(t + h / 4, y + h * k1 / 4);
        k3 = dydt(t + 3 * h / 8, y + h * (3 * k1 + 9 * k2) / 32);
        k4 = dydt(t + 12 * h / 13,
            y + h * (1932 * k1 - 7200 * k2 + 7296 * k3) / 2197);
        k5 = dydt(
            t + h,
            y +
                h *
                    (439 * k1 / 216 -
                        8 * k2 +
                        3680 * k3 / 513 -
                        845 * k4 / 4104));
        k6 = dydt(
            t + h / 2,
            y +
                h *
                    (-8 * k1 / 27 +
                        2 * k2 -
                        3544 * k3 / 2565 +
                        1859 * k4 / 4104 -
                        11 * k5 / 40));

        y4 = y +
            h * (25 * k1 / 216 + 1408 * k3 / 2565 + 2197 * k4 / 4104 - k5 / 5);
        y5 = y +
            h *
                (16 * k1 / 135 +
                    6656 * k3 / 12825 +
                    28561 * k4 / 56430 -
                    9 * k5 / 50 +
                    2 * k6 / 55);
      }

      // Estimate error
      num error;
      if (isSystem) {
        List<num> y4List = y4 as List<num>;
        List<num> y5List = y5 as List<num>;
        error = 0;
        for (int j = 0; j < y4List.length; j++) {
          error += (y5List[j] - y4List[j]).abs();
        }
        error /= y4List.length;
      } else {
        error = (y5 - y4).abs();
      }

      // Adapt step size
      if (error < tol || h <= hMin) {
        t += h;
        y = y5;
        tValues.add(t);
        yValues.add(isSystem ? List<num>.from(y) : y);
        steps++;
      }

      if (error > 0) {
        num s = 0.84 * (tol / error).abs().clamp(0.1, 4.0);
        h = (h * s).clamp(hMin, hMax);
      }

      if (steps > 100000) {
        return ODEResult(
          t: tValues,
          y: yValues,
          steps: steps,
          success: false,
          message: 'Max steps exceeded',
        );
      }
    }

    return ODEResult(
      t: tValues,
      y: yValues,
      steps: steps,
      success: true,
    );
  }

  /// Solves ODE using Backward Euler method (implicit, good for stiff equations).
  static ODEResult backwardEuler(
    Function dydt,
    dynamic y0,
    num t0,
    num tf, {
    int steps = 100,
    int maxIter = 10,
    double tol = 1e-6,
  }) {
    bool isSystem = y0 is List;
    num h = (tf - t0) / steps;

    List<num> tValues = [];
    List<dynamic> yValues = [];

    num t = t0;
    dynamic y = isSystem ? List<num>.from(y0) : y0;

    for (int i = 0; i <= steps; i++) {
      tValues.add(t);
      yValues.add(isSystem ? List<num>.from(y) : y);

      if (i < steps) {
        num tNext = t0 + (i + 1) * h;
        dynamic yNext = y; // Initial guess

        // Fixed-point iteration to solve implicit equation
        for (int iter = 0; iter < maxIter; iter++) {
          dynamic f = dydt(tNext, yNext);
          dynamic yNew;

          if (isSystem) {
            List<num> yList = y as List<num>;
            List<num> fList = f as List<num>;
            yNew = List.generate(yList.length, (j) => yList[j] + h * fList[j]);
          } else {
            yNew = y + h * f;
          }

          // Check convergence
          num diff;
          if (isSystem) {
            List<num> yNewList = yNew as List<num>;
            List<num> yNextList = yNext as List<num>;
            diff = 0;
            for (int j = 0; j < yNewList.length; j++) {
              diff += (yNewList[j] - yNextList[j]).abs();
            }
          } else {
            diff = (yNew - yNext).abs();
          }

          yNext = yNew;
          if (diff < tol) break;
        }

        y = yNext;
        t = tNext;
      }
    }

    return ODEResult(
      t: tValues,
      y: yValues,
      steps: steps,
      success: true,
    );
  }
}
