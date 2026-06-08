part of '../../expression.dart';

class Abs extends Expression {
  final Expression operand;

  Abs(this.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    return operand.evaluate(arg).abs();
  }

  @override
  Expression differentiate([Variable? v]) {
    // Simplify first to avoid messy derivative trees
    final u = operand.simplify();

    // If it's a constant, the derivative is 0
    if (u is Literal) {
      return Literal(0);
    }

    // d/dx |u| = (u / |u|) * du/dx
    final du = u.differentiate(v);
    final signum = Divide(u, Abs(u));

    return Multiply(signum, du).simplify();
  }

  @override
  Expression integrate() {
    // 1. Simplify the inner expression first
    final simplified = operand.simplify();

    // 2. Check if the expression is strictly non-negative
    if (_isNonNegative(simplified)) {
      // If it's always positive, integral of |u| is just the integral of u
      return simplified.integrate();
    }

    // 3. Check if the expression is strictly non-positive
    if (_isNonPositive(simplified)) {
      // If it's always negative, integral of |u| is the integral of -u
      return Negate(simplified).integrate();
    }

    // 4. Fallback: The expression crosses zero.
    // To integrate this, the CAS would need to calculate the roots of 'simplified',
    // determine the intervals, and return a Piecewise expression.
    throw UnimplementedError(
        "Cannot automatically integrate |${operand.toString()}|. "
        "The expression crosses zero, which requires root-finding and a Piecewise representation.");
  }

  bool _isNonNegative(Expression expr) {
    // 1. Structural checks (your existing logic)
    if (expr is Literal) {
      final val = expr.evaluate();
      if (val is num) {
        return val >= 0;
      }
      if (val is Rational) {
        return val >= Rational.zero;
      }
      if (val is Complex) {
        return val.imaginary == 0 && val.real >= 0;
      }
    }
    if (expr is Abs) {
      return true;
    }

    if (expr is Negate) {
      return _isNonPositive(expr.operand);
    }

    if (expr is Pow) {
      if (_isNonNegative(expr.left)) {
        return true;
      }
      final exponent = expr.right;
      if (exponent is Literal) {
        final expVal = exponent.evaluate();
        if (expVal is num && expVal % 2 == 0) {
          return true;
        }
        if (expVal is Rational &&
            expVal.isInteger &&
            expVal.numerator.toInt() % 2 == 0) {
          return true;
        }
      }
    }
    if (expr is Multiply) {
      if (_isNonNegative(expr.left) && _isNonNegative(expr.right)) {
        return true;
      }
      if (_isNonPositive(expr.left) && _isNonPositive(expr.right)) {
        return true;
      }
    }
    if (expr is Add) {
      if (_isNonNegative(expr.left) && _isNonNegative(expr.right)) {
        return true;
      }
    }
    if (expr is Subtract) {
      // A - B >= 0 if A >= 0 and B <= 0
      if (_isNonNegative(expr.left) && _isNonPositive(expr.right)) return true;
    }

    // 2. Algebraic fallback for Scenario B (e.g., abs(5*x^2 - x + 11))
    if (_isAlgebraicallyNonNegative(expr)) return true;

    return false;
  }

  bool _isNonPositive(Expression expr) {
    // 1. Structural checks (your existing logic)
    if (expr is Literal) {
      final val = expr.evaluate();
      if (val is num) {
        return val <= 0;
      }
      if (val is Rational) {
        return val <= Rational.zero;
      }
      if (val is Complex) {
        return val.imaginary == 0 && val.real <= 0;
      }
    }
    if (expr is Negate) {
      // A negative expression is non-positive if its inner part is non-negative
      return _isNonNegative(expr.operand);
    }
    if (expr is Multiply) {
      if ((_isNonNegative(expr.left) && _isNonPositive(expr.right)) ||
          (_isNonPositive(expr.left) && _isNonNegative(expr.right))) {
        return true;
      }
    }

    if (expr is Add) {
      if (_isNonPositive(expr.left) && _isNonPositive(expr.right)) {
        return true;
      }
    }

    if (expr is Subtract) {
      // A - B <= 0 if A <= 0 and B >= 0
      if (_isNonPositive(expr.left) && _isNonNegative(expr.right)) return true;
    }

    // 2. Algebraic fallback
    if (_isAlgebraicallyNonPositive(expr)) return true;

    return false;
  }

  // ==========================================
  // ALGEBRAIC HELPER METHODS (SCENARIO B FIX)
  // ==========================================

  bool _isAlgebraicallyNonNegative(Expression expr) {
    final vars = expr.getVariableTerms();
    if (vars.length == 1) {
      final v = vars.first;
      final coeffs = _extractCoefficients(expr, v);
      if (coeffs != null && coeffs.isNotEmpty) {
        int maxDeg = coeffs.keys.reduce((a, b) => a > b ? a : b);

        if (maxDeg == 2) {
          double a = coeffs[2] ?? 0.0;
          double b = coeffs[1] ?? 0.0;
          double c = coeffs[0] ?? 0.0;
          if (a > 0 && (b * b - 4 * a * c) <= 1e-10) return true;
        }

        if (maxDeg % 2 == 0) {
          bool allNonNegative = true,
              hasOddDegree = false,
              hasPositiveEven = false;
          for (var entry in coeffs.entries) {
            if (entry.value < -1e-10) {
              allNonNegative = false;
              break;
            }
            if (entry.key % 2 != 0 && entry.value.abs() > 1e-10) {
              hasOddDegree = true;
            }
            if (entry.key % 2 == 0 && entry.value > 1e-10) {
              hasPositiveEven = true;
            }
          }
          if (allNonNegative && !hasOddDegree && hasPositiveEven) return true;
        }
      }
    } else if (vars.isEmpty) {
      final val = expr.evaluate();
      if (val is num) return val >= -1e-10;
    }
    return false;
  }

  bool _isAlgebraicallyNonPositive(Expression expr) {
    final vars = expr.getVariableTerms();
    if (vars.length == 1) {
      final v = vars.first;
      final coeffs = _extractCoefficients(expr, v);
      if (coeffs != null && coeffs.isNotEmpty) {
        int maxDeg = coeffs.keys.reduce((a, b) => a > b ? a : b);

        if (maxDeg == 2) {
          double a = coeffs[2] ?? 0.0;
          double b = coeffs[1] ?? 0.0;
          double c = coeffs[0] ?? 0.0;
          if (a < 0 && (b * b - 4 * a * c) <= 1e-10) return true;
        }

        if (maxDeg % 2 == 0) {
          bool allNonPositive = true,
              hasOddDegree = false,
              hasNegativeEven = false;
          for (var entry in coeffs.entries) {
            if (entry.value > 1e-10) {
              allNonPositive = false;
              break;
            }
            if (entry.key % 2 != 0 && entry.value.abs() > 1e-10) {
              hasOddDegree = true;
            }
            if (entry.key % 2 == 0 && entry.value < -1e-10) {
              hasNegativeEven = true;
            }
          }
          if (allNonPositive && !hasOddDegree && hasNegativeEven) return true;
        }
      }
    } else if (vars.isEmpty) {
      final val = expr.evaluate();
      if (val is num) return val <= 1e-10;
    }
    return false;
  }

  Map<int, double>? _extractCoefficients(Expression expr, Variable v) {
    if (expr is Variable) {
      bool isSameVar = (expr == v);
      if (!isSameVar) {
        try {
          isSameVar = (expr as dynamic).name == (v as dynamic).name;
        } catch (_) {}
      }
      if (isSameVar) return {1: 1.0};
      return null;
    }
    if (expr is Literal) {
      final val = expr.evaluate();
      if (val is num) return {0: val.toDouble()};
      try {
        if (val is Rational) return {0: (val as dynamic).toDouble()};
      } catch (_) {}
      return null;
    }
    if (expr is Negate) {
      final inner = _extractCoefficients(expr.operand, v);
      return inner?.map((k, val) => MapEntry(k, -val));
    }
    if (expr is Add) {
      final left = _extractCoefficients(expr.left, v);
      final right = _extractCoefficients(expr.right, v);
      if (left == null || right == null) return null;
      final result = Map<int, double>.from(left);
      right.forEach((k, val) => result[k] = (result[k] ?? 0.0) + val);
      return result;
    }
    if (expr is Subtract) {
      final left = _extractCoefficients(expr.left, v);
      final right = _extractCoefficients(expr.right, v);
      if (left == null || right == null) return null;
      final result = Map<int, double>.from(left);
      right.forEach((k, val) => result[k] = (result[k] ?? 0.0) - val);
      return result;
    }
    if (expr is Multiply) {
      final left = _extractCoefficients(expr.left, v);
      final right = _extractCoefficients(expr.right, v);
      if (left == null || right == null) return null;
      final result = <int, double>{};
      for (var lEntry in left.entries) {
        for (var rEntry in right.entries) {
          int deg = lEntry.key + rEntry.key;
          result[deg] = (result[deg] ?? 0.0) + (lEntry.value * rEntry.value);
        }
      }
      return result;
    }
    if (expr is Pow) {
      final base = _extractCoefficients(expr.left, v);
      if (base == null) return null;
      final expExpr = expr.right;
      if (expExpr is Literal) {
        final expVal = expExpr.evaluate();
        if (expVal is num && expVal >= 0 && expVal % 1 == 0) {
          int exp = expVal.toInt();
          var result = <int, double>{0: 1.0};
          for (int i = 0; i < exp; i++) {
            var next = <int, double>{};
            for (var rEntry in result.entries) {
              for (var bEntry in base.entries) {
                int deg = rEntry.key + bEntry.key;
                next[deg] = (next[deg] ?? 0.0) + (rEntry.value * bEntry.value);
              }
            }
            result = next;
          }
          return result;
        }
      }
      return null;
    }
    if (expr is Divide) {
      final num = _extractCoefficients(expr.left, v);
      final den = _extractCoefficients(expr.right, v);
      if (num == null || den == null) return null;
      if (den.length == 1 && den.containsKey(0) && den[0]!.abs() > 1e-10) {
        double d = den[0]!;
        return num.map((k, val) => MapEntry(k, val / d));
      }
      return null;
    }
    return null;
  }

  @override
  Expression simplify() {
    final simplifiedOperand = operand.simplify();
    if (simplifiedOperand is Literal) {
      return Literal(simplifiedOperand.evaluate().abs());
    }
    if (_isNonNegative(simplifiedOperand)) {
      return simplifiedOperand;
    }
    if (_isNonPositive(simplifiedOperand)) {
      return Negate(simplifiedOperand).simplify();
    }
    return Abs(simplifiedOperand);
  }

  @override
  Expression expand() {
    return this;
  }

  @override
  bool isPoly([bool strict = false]) {
    // If the inner expression has a guaranteed sign, the absolute value
    // resolves to a standard polynomial (either 'operand' or '-operand').
    if (_isNonNegative(operand) || _isNonPositive(operand)) {
      return operand.isPoly(strict);
    }
    // If it's an arbitrary absolute value (e.g., abs(x)), it's not a polynomial.
    return false;
  }

  @override
  Set<Variable> getVariableTerms() {
    return operand.getVariableTerms();
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    if (this == oldExpr) {
      return newExpr;
    }
    return Abs(operand.substitute(oldExpr, newExpr));
  }

  @override
  bool isIndeterminate(dynamic x) {
    return operand.isIndeterminate(x);
  }

  @override
  bool isInfinity(dynamic x) {
    return operand.isInfinity(x);
  }

  // Calculating the depth
  @override
  int depth() {
    return 1 + operand.depth();
  }

  // Calculating the size
  @override
  int size() {
    return 1 + operand.size();
  }

  @override
  String toString() {
    return "|${operand.toString()}|";
  }
}
