import '../expression/expression.dart';
import '../../../number/complex/complex.dart';
import '../../../number/decimal/rational.dart';
import 'integration.dart';
import 'symbolic_integration.dart';

// ---------------------------------------------------------------------------
// Formatting helpers
// ---------------------------------------------------------------------------

/// Tries to express [value] as a rational p/q (|q| ≤ [maxDenom]).
/// Returns `'p/q'` if a good approximation is found, otherwise `null`.
String? _bestRational(double value, {int maxDenom = 1000000000}) {
  if (value.isNaN || value.isInfinite) return null;

  final sign = value < 0 ? '-' : '';
  final absVal = value.abs();

  // Fast continued-fraction best approximation
  int p0 = 0, q0 = 1;
  int p1 = 1, q1 = 0;
  int bestP = 0, bestQ = 1;
  double bestErr = absVal;

  for (int i = 0; i < 60; i++) {
    final m = p0 + p1;
    final n = q0 + q1;
    if (n > maxDenom) break;
    final frac = m / n;
    final err = (frac - absVal).abs();
    if (err < bestErr) {
      bestErr = err;
      bestP = m;
      bestQ = n;
    }
    if (frac < absVal) {
      p0 = m;
      q0 = n;
    } else if (frac > absVal) {
      p1 = m;
      q1 = n;
    } else {
      break;
    }
    if (bestErr < 1e-15) break;
  }

  // Require the rational approximation to be within 1e-9
  if (bestErr > 1e-9) return null;

  if (bestQ == 1) {
    return '$sign$bestP';
  }
  return '$sign$bestP/$bestQ';
}

/// Formats a result as decimal (for definite integrals).
String formatDecimal(double value) {
  if (value.isNaN) return 'NaN';
  if (value.isInfinite) return value > 0 ? 'Infinity' : '-Infinity';

  // Negative zero check
  if (value == 0.0 && value.isNegative) {
    return '-0';
  }

  // Check for exact integer
  final rounded = value.roundToDouble();
  if ((value - rounded).abs() < 1e-6 && rounded.abs() < 1e15) {
    return rounded.toInt().toString();
  }

  // Decimal: format to 12 decimal places, trim trailing zeros
  String s = value.toStringAsFixed(12);
  if (s.contains('.')) {
    s = s.replaceAll(RegExp(r'0+$'), '');
    if (s.endsWith('.')) s = s.substring(0, s.length - 1);
  }
  return s;
}

/// Formats a result allowing rational approximation with small denominator (≤100).
/// Used for limits where we expect clean fractions.
String formatLimitResult(double value) {
  if (value.isNaN) return 'NaN';
  if (value.isInfinite) return value > 0 ? 'Infinity' : '-Infinity';

  final rounded = value.roundToDouble();
  if ((value - rounded).abs() < 1e-9 && rounded.abs() < 1e15) {
    return rounded.toInt().toString();
  }

  final rat = _bestRational(value, maxDenom: 100);
  if (rat != null) return rat;

  // Fall back to decimal
  return formatDecimal(value);
}

/// Formats a result for sums: rational if denominator ≤ 1e9, else decimal.
String formatSumResult(double value) {
  if (value.isNaN) return 'NaN';
  if (value.isInfinite) return value > 0 ? 'Infinity' : '-Infinity';

  final rounded = value.roundToDouble();
  if ((value - rounded).abs() < 1e-9 && rounded.abs() < 1e15) {
    return rounded.toInt().toString();
  }

  final rat = _bestRational(value, maxDenom: 1000000000);
  if (rat != null) return rat;

  return formatDecimal(value);
}

// Keep for backward compat
String formatNumericResult(double value) => formatSumResult(value);

// ---------------------------------------------------------------------------
// Shared helper: convert dynamic value to double
// ---------------------------------------------------------------------------
double? _toDbl(dynamic v) {
  if (v is num) return v.toDouble();
  if (v is Rational) return v.toDouble();
  if (v is Complex) {
    final r = v.real;
    if (r is num) return r.toDouble();
    if (r is Rational) return r.toDouble();
  }
  return null;
}

double? _tryNumericEval(Expression e) {
  try {
    final v = e.evaluate();
    return _toDbl(v);
  } catch (_) {
    return null;
  }
}

// ---------------------------------------------------------------------------
// Symbolic Sum  –  sum(expr, var, start, end)
// ---------------------------------------------------------------------------

class SymbolicSum {
  /// Evaluates Σ_{var=start}^{end} expr symbolically or numerically.
  static Expression evaluate(
    Expression expr,
    Variable variable,
    Expression startExpr,
    Expression endExpr,
  ) {
    final startVal = _tryNumericEval(startExpr);
    final endVal = _tryNumericEval(endExpr);

    if (startVal == null || endVal == null) {
      return CallExpression(
          Variable('sum'), [expr, variable, startExpr, endExpr]);
    }

    final start = startVal.round();
    final end = endVal.round();

    // Optimize purely numeric sums: if there are no other variables in the expression
    // other than the summation variable and mathematical constants, we can compute it numerically directly!
    final otherVars = expr.getVariableTerms().where((v) {
      final name = v.identifier.name;
      return v != variable &&
          name != 'e' &&
          name != 'π' &&
          name != 'pi' &&
          name != 'Infinity' &&
          name != '∞';
    });
    if (otherVars.isEmpty || end - start > 10000) {
      return _numericSum(expr, variable, start, end);
    }

    // Build symbolic sum by substituting each integer value
    Expression total = Literal(0);

    for (int k = start; k <= end; k++) {
      final substituted = expr.substitute(variable, Literal(k));
      total = Add(total, substituted);
    }

    // Simplify
    try {
      final simplified = total.simplify();
      final freeVars = simplified.getVariableTerms();

      if (freeVars.isEmpty) {
        // Purely numeric – evaluate and format
        try {
          final numResult = simplified.evaluate();
          final d = _toDbl(numResult);
          if (d != null) {
            final s = formatNumericResult(d);
            return Literal(d, s);
          }
        } catch (_) {}
      }

      return simplified;
    } catch (_) {
      return _numericSum(expr, variable, start, end);
    }
  }

  static Expression _numericSum(
      Expression expr, Variable variable, int start, int end) {
    final varName = variable.identifier.name;
    double total = 0.0;
    for (int k = start; k <= end; k++) {
      try {
        final val = expr.evaluate({varName: k.toDouble()});
        final d = _toDbl(val);
        if (d == null || d.isNaN) return Literal(double.nan, 'NaN');
        total += d;
      } catch (_) {
        return Literal(double.nan, 'NaN');
      }
    }
    final s = formatSumResult(total);
    return Literal(total, s);
  }
}

// ---------------------------------------------------------------------------
// Definite Integral  –  defint(expr, a, b [, var])
// ---------------------------------------------------------------------------

class DefiniteIntegral {
  /// Computes ∫_a^b expr d(variable) using adaptive quadrature.
  static Expression compute(
    Expression expr,
    Variable variable,
    Expression aExpr,
    Expression bExpr,
  ) {
    final varName = variable.identifier.name;

    final a = _tryNumericEval(aExpr);
    final b = _tryNumericEval(bExpr);

    if (a == null || b == null) return Literal(double.nan, 'NaN');

    // 1. Try symbolic antiderivative (fundamental theorem of calculus)
    try {
      final antideriv = SymbolicIntegration.integrate(expr, variable);
      final fb = _evalAt(antideriv, varName, b);
      final fa = _evalAt(antideriv, varName, a);
      if (fb != null && fa != null && !fb.isNaN && !fa.isNaN) {
        final result = fb - fa;
        if (!result.isNaN && !result.isInfinite) {
          final s = formatDecimal(result);
          return Literal(result, s);
        }
      }
    } catch (_) {}

    // 2. Numerical fallback: adaptive Simpson
    try {
      num f(num x) {
        try {
          final val = expr.evaluate({varName: x.toDouble()});
          final d = _toDbl(val) ?? double.nan;
          if (d.isInfinite || d.isNaN) {
            final mid = (a + b) / 2;
            final nudgeX = x + (mid - x).sign * 1e-10 * (b - a).abs();
            final valNudge = expr.evaluate({varName: nudgeX.toDouble()});
            final dNudge = _toDbl(valNudge) ?? double.nan;
            if (dNudge.isFinite) return dNudge;
          }
          return d;
        } catch (_) {
          try {
            final mid = (a + b) / 2;
            final nudgeX = x + (mid - x).sign * 1e-10 * (b - a).abs();
            final valNudge = expr.evaluate({varName: nudgeX.toDouble()});
            final dNudge = _toDbl(valNudge) ?? double.nan;
            if (dNudge.isFinite) return dNudge;
          } catch (_) {}
          return double.nan;
        }
      }

      final result = NumericalIntegration.adaptiveSimpson(f, a, b,
          tolerance: 1e-12, maxDepth: 25);

      final s = formatDecimal(result.toDouble());
      return Literal(result, s);
    } catch (e) {
      return Literal(double.nan, 'NaN');
    }
  }

  static double? _evalAt(Expression expr, String varName, double x) {
    try {
      final val = expr.evaluate({varName: x});
      return _toDbl(val);
    } catch (_) {
      return null;
    }
  }
}

// ---------------------------------------------------------------------------
// Symbolic Limit  –  limit(expr, var, value)
// ---------------------------------------------------------------------------

class SymbolicLimit {
  /// Computes lim_{var → value} expr.
  static Expression compute(
    Expression expr,
    Variable variable,
    Expression valueExpr,
  ) {
    final varName = variable.identifier.name;
    final limitPoint = _resolveLimitPoint(valueExpr);

    if (limitPoint == _LimitPoint.positiveInfinity) {
      return _limitAtInfinity(expr, varName, positive: true);
    }
    if (limitPoint == _LimitPoint.negativeInfinity) {
      return _limitAtInfinity(expr, varName, positive: false);
    }

    final c = (limitPoint as _FinitePoint).value;
    return _limitAtFinite(expr, varName, c);
  }

  // ----------- Limit at a finite point -----------

  static Expression _limitAtFinite(Expression expr, String varName, double c) {
    // Step 1: Direct substitution (avoid division by zero)
    final directVal = _tryEval(expr, varName, c);
    if (directVal != null && !directVal.isNaN && directVal.isFinite) {
      return _formatLit(directVal);
    }

    // Step 2: L'Hôpital's rule if it's a ratio
    final hopital = _tryLHopital(expr, varName, c);
    if (hopital != null) return hopital;

    // Step 3: Numerical squeeze from both sides
    final num = _numericalLimit(expr, varName, c);
    if (num != null) {
      if (num.isInfinite) {
        final s = num > 0 ? 'Infinity' : '-Infinity';
        return Literal(num, s);
      }
      return _formatLit(num);
    }

    // Step 4: Check for one-sided infinities
    final leftVal = _tryEval(expr, varName, c - 1e-8);
    final rightVal = _tryEval(expr, varName, c + 1e-8);
    if (leftVal != null &&
        leftVal.isInfinite &&
        rightVal != null &&
        rightVal.isInfinite) {
      // Both sides → infinity (same or different sign)
      if (leftVal == double.negativeInfinity &&
          rightVal == double.negativeInfinity) {
        return Literal(double.negativeInfinity, '-Infinity');
      }
      return Literal(double.negativeInfinity, '-Infinity');
    }

    return Literal(double.nan, 'NaN');
  }

  /// Tries L'Hôpital's rule by identifying numerator/denominator.
  static Expression? _tryLHopital(Expression expr, String varName, double c) {
    Expression? num, den;

    // Unwrap GroupExpression
    Expression unwrap(Expression e) =>
        e is GroupExpression ? unwrap(e.expression) : e;

    final top = unwrap(expr);

    if (top is Divide) {
      num = top.left;
      den = top.right;
    } else if (top is Multiply) {
      if (top.right is Pow) {
        final p = top.right as Pow;
        final expLit = p.exponent;
        if (expLit is Literal && _toDbl(expLit.value) == -1.0) {
          num = top.left;
          den = p.base;
        }
      }
    }

    if (num == null || den == null) return null;

    Expression currentNum = num;
    Expression currentDen = den;

    for (int iter = 0; iter < 5; iter++) {
      final numVal = _tryEval(currentNum, varName, c);
      final denVal = _tryEval(currentDen, varName, c);

      final numIsZero = numVal != null && numVal.abs() < 1e-9;
      final denIsZero = denVal != null && denVal.abs() < 1e-9;
      final numIsInf = numVal == null || numVal.isInfinite;
      final denIsInf = denVal == null || denVal.isInfinite;

      final indeterminate = (numIsZero && denIsZero) || (numIsInf && denIsInf);

      if (!indeterminate) {
        if (numVal != null && denVal != null && denVal.abs() > 1e-15) {
          return _formatLit(numVal / denVal);
        }
        break;
      }

      // Apply L'Hôpital
      try {
        final dNum = currentNum.differentiate(Variable(varName)).simplify();
        final dDen = currentDen.differentiate(Variable(varName)).simplify();

        final newNumVal = _tryEval(dNum, varName, c);
        final newDenVal = _tryEval(dDen, varName, c);

        if (newDenVal != null && newDenVal.abs() > 1e-15 && newNumVal != null) {
          return _formatLit(newNumVal / newDenVal);
        }

        currentNum = dNum;
        currentDen = dDen;
      } catch (_) {
        break;
      }
    }
    return null;
  }

  // ----------- Limit at infinity -----------

  static Expression _limitAtInfinity(Expression expr, String varName,
      {required bool positive}) {
    final c = positive ? double.infinity : double.negativeInfinity;
    final hopital = _tryLHopital(expr, varName, c);
    if (hopital != null) return hopital;

    final signs = positive
        ? [1e6, 1e9, 1e12, 1e15, 1e18]
        : [-1e6, -1e9, -1e12, -1e15, -1e18];

    double? prevVal;
    double? convergedVal;
    int stable = 0;

    for (final x in signs) {
      final val = _tryEval(expr, varName, x);
      if (val == null) continue;
      if (val.isInfinite) {
        final s = val > 0 ? 'Infinity' : '-Infinity';
        return Literal(val, s);
      }
      if (prevVal != null) {
        final relErr = (val - prevVal).abs() / (1 + val.abs());
        if (relErr < 1e-6) {
          stable++;
          if (stable >= 2) {
            convergedVal = val;
            break;
          }
        } else {
          stable = 0;
          // Check if diverging
          if (val.abs() > prevVal.abs() * 2 && val.abs() > 1e6) {
            final s = val > 0 ? 'Infinity' : '-Infinity';
            return Literal(val, s);
          }
        }
      }
      prevVal = val;
    }

    if (convergedVal != null) {
      return _formatLit(convergedVal);
    }

    // Try once more at very large value
    final bigX = positive ? 1e15 : -1e15;
    final val = _tryEval(expr, varName, bigX);
    if (val != null) {
      if (val.isInfinite) {
        final s = val > 0 ? 'Infinity' : '-Infinity';
        return Literal(val, s);
      }
      return _formatLit(val);
    }

    return Literal(double.nan, 'NaN');
  }

  // ----------- Numerical squeeze -----------

  static double? _numericalLimit(Expression expr, String varName, double c) {
    final steps = [1e-3, 1e-4, 1e-5, 1e-6, 1e-7, 1e-8];

    double? leftLim, rightLim;

    for (final h in steps) {
      final r = _tryEval(expr, varName, c + h);
      if (r != null && !r.isNaN) rightLim = r;
      final l = _tryEval(expr, varName, c - h);
      if (l != null && !l.isNaN) leftLim = l;
    }

    if (leftLim != null && rightLim != null) {
      // Two-sided limit
      if ((leftLim - rightLim).abs() < 1e-5 * (1 + leftLim.abs())) {
        final avg = (leftLim + rightLim) / 2;
        if (avg.abs() > 1e11) {
          return avg > 0 ? double.infinity : double.negativeInfinity;
        }
        return avg;
      }
      // Limits disagree → take left (for abs-value type problems)
      if (leftLim.abs() > 1e11) {
        return leftLim > 0 ? double.infinity : double.negativeInfinity;
      }
      return leftLim;
    }

    final res = leftLim ?? rightLim;
    if (res != null && res.abs() > 1e11) {
      return res > 0 ? double.infinity : double.negativeInfinity;
    }
    return res;
  }

  // ----------- Helpers -----------

  static double? _tryEval(Expression expr, String varName, double x) {
    try {
      final val = expr.evaluate({varName: x});
      return _toDbl(val);
    } catch (_) {
      return null;
    }
  }

  static Expression _formatLit(double d) {
    final s = formatLimitResult(d);
    return Literal(d, s);
  }

  static _LimitPointResult _resolveLimitPoint(Expression e) {
    // Unwrap group
    if (e is GroupExpression) return _resolveLimitPoint(e.expression);

    // Check for infinity identifiers
    if (e is Variable) {
      final name = e.identifier.name;
      if (name == '∞' || name == 'Infinity' || name == 'inf') {
        return _LimitPoint.positiveInfinity;
      }
      if (name == '−∞') return _LimitPoint.negativeInfinity;
    }
    // Unary minus on infinity
    if (e is UnaryExpression && e.operator == '-' && e.prefix) {
      final inner = e.operand;
      if (inner is Variable) {
        final name = inner.identifier.name;
        if (name == '∞' || name == 'Infinity' || name == 'inf') {
          return _LimitPoint.negativeInfinity;
        }
      }
    }
    // Numeric evaluation
    try {
      final val = e.evaluate();
      final d = _toDbl(val);
      if (d != null) {
        if (d == double.infinity) return _LimitPoint.positiveInfinity;
        if (d == double.negativeInfinity) return _LimitPoint.negativeInfinity;
        return _FinitePoint(d);
      }
    } catch (_) {}
    return _FinitePoint(0);
  }
}

// ---------------------------------------------------------------------------
// Sealed types for limit point classification
// ---------------------------------------------------------------------------

abstract class _LimitPointResult {}

class _FinitePoint extends _LimitPointResult {
  final double value;
  _FinitePoint(this.value);
}

class _LimitPoint extends _LimitPointResult {
  static final positiveInfinity = _LimitPoint._('positiveInfinity');
  static final negativeInfinity = _LimitPoint._('negativeInfinity');
  final String _name;
  _LimitPoint._(this._name);

  @override
  bool operator ==(Object other) =>
      other is _LimitPoint && other._name == _name;
  @override
  int get hashCode => _name.hashCode;
}
