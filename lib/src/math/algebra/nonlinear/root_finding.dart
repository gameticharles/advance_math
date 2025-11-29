part of '../algebra.dart';

/// A collection of root-finding algorithms for non-linear equations.
class RootFinding {
  // --- Bracketing Methods ---

  /// Finds a root of a continuous function [f] in the interval [a, b] using the Bisection method.
  ///
  /// The function must have different signs at [a] and [b].
  ///
  /// Parameters:
  /// - [f]: The function to find the root of.
  /// - [a]: Lower bound of the interval.
  /// - [b]: Upper bound of the interval.
  /// - [tolerance]: The convergence tolerance (default: 1e-6).
  /// - [maxIter]: Maximum number of iterations (default: 100).
  ///
  /// Throws [ArgumentError] if f(a) and f(b) have the same sign.
  static num bisection(
    Function f,
    num a,
    num b, {
    double tolerance = 1e-6,
    int maxIter = 100,
  }) {
    num fa = f(a);
    num fb = f(b);

    if (fa * fb > 0) {
      throw ArgumentError(
          'Function must have different signs at interval endpoints.');
    }
    if (fa == 0) return a;
    if (fb == 0) return b;

    num low = a;
    num high = b;

    for (int i = 0; i < maxIter; i++) {
      num mid = low + (high - low) / 2;
      num fmid = f(mid);

      if (fmid == 0 || (high - low).abs() < tolerance) {
        return mid;
      }

      if (fa * fmid < 0) {
        high = mid;
        fb = fmid;
      } else {
        low = mid;
        fa = fmid;
      }
    }

    throw Exception(
        'Bisection method failed to converge within $maxIter iterations.');
  }

  /// Finds a root using the False Position (Regula Falsi) method.
  ///
  /// Similar to bisection but uses linear interpolation to estimate the root.
  static num falsePosition(
    Function f,
    num a,
    num b, {
    double tolerance = 1e-6,
    int maxIter = 100,
  }) {
    num fa = f(a);
    num fb = f(b);

    if (fa * fb > 0) {
      throw ArgumentError(
          'Function must have different signs at interval endpoints.');
    }
    if (fa == 0) return a;
    if (fb == 0) return b;

    num low = a;
    num high = b;
    num root = low;

    for (int i = 0; i < maxIter; i++) {
      // Linear interpolation formula
      num newRoot = high - (fb * (high - low)) / (fb - fa);
      num fNew = f(newRoot);

      if (fNew == 0 || (newRoot - root).abs() < tolerance) {
        return newRoot;
      }

      root = newRoot;

      if (fa * fNew < 0) {
        high = newRoot;
        fb = fNew;
      } else {
        low = newRoot;
        fa = fNew;
      }
    }

    throw Exception(
        'False Position method failed to converge within $maxIter iterations.');
  }

  /// Finds a root using Brent's method.
  ///
  /// Combines bisection, secant, and inverse quadratic interpolation.
  /// This is generally the preferred bracketing method.
  static num brent(
    Function f,
    num a,
    num b, {
    double tolerance = 1e-6,
    int maxIter = 100,
  }) {
    num fa = f(a);
    num fb = f(b);

    if (fa * fb > 0) {
      throw ArgumentError(
          'Function must have different signs at interval endpoints.');
    }

    if (fa.abs() < fb.abs()) {
      num temp = a;
      a = b;
      b = temp;
      temp = fa;
      fa = fb;
      fb = temp;
    }

    num c = a;
    num fc = fa;
    bool mflag = true;
    num s = b;
    num d = 0; // Initialize d

    for (int i = 0; i < maxIter; i++) {
      if (fb.abs() < tolerance || (b - a).abs() < tolerance) {
        return b;
      }

      if (fa != fc && fb != fc) {
        // Inverse quadratic interpolation
        s = (a * fb * fc) / ((fa - fb) * (fa - fc)) +
            (b * fa * fc) / ((fb - fa) * (fb - fc)) +
            (c * fa * fb) / ((fc - fa) * (fc - fb));
      } else {
        // Secant method
        s = b - fb * (b - a) / (fb - fa);
      }

      // Check conditions to switch to bisection
      bool condition1 =
          !((s > (3 * a + b) / 4 && s < b) || (s < (3 * a + b) / 4 && s > b));
      bool condition2 = mflag && (s - b).abs() >= (b - c).abs() / 2;
      bool condition3 = !mflag && (s - b).abs() >= (c - d).abs() / 2;
      bool condition4 = mflag && (b - c).abs() < tolerance;
      bool condition5 = !mflag && (c - d).abs() < tolerance;

      if (condition1 || condition2 || condition3 || condition4 || condition5) {
        // Bisection step
        s = (a + b) / 2;
        mflag = true;
      } else {
        mflag = false;
      }

      num fs = f(s);
      d = c; // Update d
      c = b;
      fc = fb;

      if (fa * fs < 0) {
        b = s;
        fb = fs;
      } else {
        a = s;
        fa = fs;
      }

      if (fa.abs() < fb.abs()) {
        num temp = a;
        a = b;
        b = temp;
        temp = fa;
        fa = fb;
        fb = temp;
      }
    }

    throw Exception(
        'Brent\'s method failed to converge within $maxIter iterations.');
  }

  // --- Open Methods ---

  /// Finds a root using the Newton-Raphson method.
  ///
  /// Requires the derivative of the function [df].
  /// Converges quadratically if close to the root.
  static num newtonRaphson(
    Function f,
    Function df,
    num x0, {
    double tolerance = 1e-6,
    int maxIter = 100,
  }) {
    num x = x0;

    for (int i = 0; i < maxIter; i++) {
      num fx = f(x);
      if (fx.abs() < tolerance) return x;

      num dfx = df(x);
      if (dfx == 0) {
        throw Exception('Derivative is zero. Newton-Raphson failed.');
      }

      num xNew = x - fx / dfx;
      if ((xNew - x).abs() < tolerance) return xNew;

      x = xNew;
    }

    throw Exception(
        'Newton-Raphson failed to converge within $maxIter iterations.');
  }

  /// Finds a root using the Secant method.
  ///
  /// Similar to Newton-Raphson but approximates the derivative using two points.
  static num secant(
    Function f,
    num x0,
    num x1, {
    double tolerance = 1e-6,
    int maxIter = 100,
  }) {
    num xPrev = x0;
    num xCurr = x1;

    for (int i = 0; i < maxIter; i++) {
      num fxPrev = f(xPrev);
      num fxCurr = f(xCurr);

      if (fxCurr.abs() < tolerance) return xCurr;

      if ((fxCurr - fxPrev).abs() < 1e-15) {
        throw Exception('Division by zero in Secant method.');
      }

      num xNew = xCurr - fxCurr * (xCurr - xPrev) / (fxCurr - fxPrev);

      if ((xNew - xCurr).abs() < tolerance) return xNew;

      xPrev = xCurr;
      xCurr = xNew;
    }

    throw Exception(
        'Secant method failed to converge within $maxIter iterations.');
  }

  /// Finds a fixed point x such that g(x) = x.
  static num fixedPoint(
    Function g,
    num x0, {
    double tolerance = 1e-6,
    int maxIter = 100,
  }) {
    num x = x0;

    for (int i = 0; i < maxIter; i++) {
      num xNew = g(x);

      if ((xNew - x).abs() < tolerance) return xNew;

      x = xNew;
    }

    throw Exception(
        'Fixed-point iteration failed to converge within $maxIter iterations.');
  }

  // --- Complex Roots ---

  /// Finds a complex root using Muller's method.
  ///
  /// Requires three initial guesses [x0], [x1], [x2].
  /// Can find complex roots even if initial guesses are real.
  static Complex muller(
    Function f,
    dynamic x0,
    dynamic x1,
    dynamic x2, {
    double tolerance = 1e-6,
    int maxIter = 100,
  }) {
    Complex p0 = x0 is Complex ? x0 : Complex(x0);
    Complex p1 = x1 is Complex ? x1 : Complex(x1);
    Complex p2 = x2 is Complex ? x2 : Complex(x2);

    Complex h1 = p1 - p0;
    Complex h2 = p2 - p1;

    // Helper to evaluate f with Complex support
    Complex eval(Complex z) {
      var res = f(z);
      return res is Complex ? res : Complex(res);
    }

    Complex d1 = (eval(p1) - eval(p0)) / h1;
    Complex d2 = (eval(p2) - eval(p1)) / h2;
    Complex d = (d2 - d1) / (h2 + h1);

    for (int i = 0; i < maxIter; i++) {
      Complex b = d2 + h2 * d;
      Complex D = (b * b - eval(p2) * d * 4)
          .sqrt(); // Assuming Complex has sqrt or similar

      // Choose the denominator with the larger magnitude
      Complex E;
      if ((b - D).abs() < (b + D).abs()) {
        E = b + D;
      } else {
        E = b - D;
      }

      Complex h = (eval(p2) * -2) / E;
      Complex p = p2 + h;

      if (h.abs() < tolerance) return p;

      p0 = p1;
      p1 = p2;
      p2 = p;

      h1 = p1 - p0;
      h2 = p2 - p1;
      d1 = (eval(p1) - eval(p0)) / h1;
      d2 = (eval(p2) - eval(p1)) / h2;
      d = (d2 - d1) / (h2 + h1);
    }

    throw Exception(
        'Muller\'s method failed to converge within $maxIter iterations.');
  }
}
