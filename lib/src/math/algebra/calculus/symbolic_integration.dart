import 'dart:math' as math;
import '../expression/expression.dart';
import '../../../number/complex/complex.dart';
import '../../../number/decimal/rational.dart';

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

/// Checks if [a] is a constant multiple of [b] with respect to variable [v].
/// Returns the constant factor `k` (where a = k * b) if true, or `null` if false.
Expression? _getConstantFactor(Expression a, Expression b, Variable v) {
  try {
    final ratio = Divide(a, b).simplify();
    final hasVar = ratio
        .getVariableTerms()
        .any((t) => t.identifier.name == v.identifier.name);
    if (!hasVar) return ratio;
  } catch (_) {}
  return null;
}

/// Safely checks if an expression contains the integration variable.
bool _containsVariable(Expression expr, Variable v) {
  try {
    return expr
        .getVariableTerms()
        .any((variable) => variable.identifier.name == v.identifier.name);
  } catch (e) {
    return false;
  }
}

/// Flattens nested Multiply and Divide expressions into a list of factors.
List<Expression> _flattenMultiply(Expression expr) {
  if (expr is Multiply) {
    return [..._flattenMultiply(expr.left), ..._flattenMultiply(expr.right)];
  }
  if (expr is Divide) {
    final denom = expr.right;
    Expression invDenom = Pow(denom, Literal(-1)).simplify();
    return [..._flattenMultiply(expr.left), ..._flattenMultiply(invDenom)];
  }
  return [expr];
}

// ============================================================================
// STRATEGY PATTERN INTERFACE
// ============================================================================

abstract class IntegrationStrategy {
  Expression? tryIntegrate(
      Expression expr, Variable v, Expression originalExpr);
  String get name;
}

// ============================================================================
// SYMBOLIC INTEGRATION ENGINE
// ============================================================================

class SymbolicIntegration {
  static final List<IntegrationStrategy> strategies = [
    SumDifferenceStrategy(),
    ConstantMultipleStrategy(),
    PowerRuleStrategy(),
    ExponentialStrategy(),
    BasicTrigStrategy(),
    TrigPowerStrategy(),
    InverseTrigStrategy(),
    InverseHyperbolicStrategy(),
    CompletingTheSquareStrategy(),
    // LinearSubstitutionStrategy(),
    RationalFunctionStrategy(),
    SubstitutionStrategy(),
    TrigProductStrategy(),
    IntegrationByPartsStrategy(),
  ];

  static Expression integrate(Expression expr, Variable v) {
    final simplifiedExpr = expr.simplify();

    for (var strategy in strategies) {
      final result = strategy.tryIntegrate(simplifiedExpr, v, simplifiedExpr);
      if (result != null) {
        return result.simplify();
      }
    }

    throw UnimplementedError(
        'Cannot symbolically integrate: ${expr.toString()}\n'
        'Consider using numerical integration (e.g., defint) instead.');
  }
}

// ============================================================================
// CALCULUS I: LINEARITY & BASIC FORMS
// ============================================================================

class SumDifferenceStrategy implements IntegrationStrategy {
  @override
  String get name => 'Sum/Difference Rule';

  @override
  Expression? tryIntegrate(Expression expr, Variable v, Expression original) {
    if (expr is Add) {
      try {
        final leftInt = SymbolicIntegration.integrate(expr.left, v);
        final rightInt = SymbolicIntegration.integrate(expr.right, v);
        return Add(leftInt, rightInt);
      } catch (_) {
        return null;
      }
    }
    if (expr is Subtract) {
      try {
        final leftInt = SymbolicIntegration.integrate(expr.left, v);
        final rightInt = SymbolicIntegration.integrate(expr.right, v);
        return Subtract(leftInt, rightInt);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}

class ConstantMultipleStrategy implements IntegrationStrategy {
  @override
  String get name => 'Constant Multiple';

  @override
  Expression? tryIntegrate(Expression expr, Variable v, Expression original) {
    if (expr is! Multiply) return null;
    if (!_containsVariable(expr.left, v)) {
      try {
        return Multiply(
            expr.left, SymbolicIntegration.integrate(expr.right, v));
      } catch (_) {}
    }
    if (!_containsVariable(expr.right, v)) {
      try {
        return Multiply(
            expr.right, SymbolicIntegration.integrate(expr.left, v));
      } catch (_) {}
    }
    return null;
  }
}

class PowerRuleStrategy implements IntegrationStrategy {
  @override
  String get name => 'Power Rule';

  @override
  Expression? tryIntegrate(Expression expr, Variable v, Expression original) {
    Rational? toRational(dynamic val) {
      if (val is Rational) return val;
      if (val is num) {
        if (val == 0.5) return Rational(1, 2);
        if (val == -0.5) return Rational(-1, 2);
        if (val % 1 == 0) return Rational(val.toInt());
        return Rational(val);
      }
      if (val is Complex && val.isReal) return toRational(val.real);
      return null;
    }

    if (expr is Variable && expr.identifier.name == v.identifier.name) {
      return Multiply(Literal(Rational(1, 2)), Pow(v, Literal(2)));
    }

    if (expr is Pow) {
      if (expr.base is Variable &&
          (expr.base as Variable).identifier.name == v.identifier.name) {
        Expression expExpr = expr.exponent;

        // Check if exponent contains the integration variable
        if (!_containsVariable(expExpr, v)) {
          bool isMinusOne = false;
          if (expExpr is Literal) {
            final val = toRational(expExpr.value);
            if (val == Rational(-1)) isMinusOne = true;
          } else {
            try {
              final val = toRational(expExpr.evaluate());
              if (val == Rational(-1)) isMinusOne = true;
            } catch (_) {}
          }

          if (isMinusOne) {
            return Ln(v);
          }

          // FIX: Handle symbolic exponents algebraically (e.g., x^n -> x^(n+1)/(n+1))
          final newExponent = Add(expExpr, Literal(1)).simplify();
          return Divide(Pow(v, newExponent), newExponent);
        }
      }
    }

    if (!_containsVariable(expr, v)) return Multiply(expr, v);

    if (expr is Multiply) {
      if (!_containsVariable(expr.left, v)) {
        final powerIntegral = tryIntegrate(expr.right, v, original);
        if (powerIntegral != null) return Multiply(expr.left, powerIntegral);
      }
      if (!_containsVariable(expr.right, v)) {
        final powerIntegral = tryIntegrate(expr.left, v, original);
        if (powerIntegral != null) return Multiply(expr.right, powerIntegral);
      }
    }

    if (expr is Divide) {
      Expression denom = expr.right;
      if (denom is Pow &&
          denom.exponent is Literal &&
          (denom.exponent as Literal).value == 1) {
        denom = denom.base;
      }
      if (denom is Variable && denom.identifier.name == v.identifier.name) {
        if (!_containsVariable(expr.left, v)) {
          if (expr.left is Literal && (expr.left as Literal).value == 1) {
            return Ln(v);
          }
          return Multiply(expr.left, Ln(v));
        }
      }
      if (expr.right is Pow && !_containsVariable(expr.left, v)) {
        final denomPow = expr.right as Pow;
        if (denomPow.base is Variable &&
            (denomPow.base as Variable).identifier.name == v.identifier.name) {
          final val = denomPow.exponent is Literal
              ? (denomPow.exponent as Literal).value
              : null;
          final ratN = toRational(val);
          if (ratN != null) {
            final n = Rational.zero - ratN;
            if (n == Rational(-1)) return Multiply(expr.left, Ln(v));
            final newExponent = n + Rational.one;
            final integral = Multiply(Literal(Rational.one / newExponent),
                Pow(v, Literal(newExponent)));
            if (expr.left is Literal && (expr.left as Literal).value == 1) {
              return integral;
            }
            return Multiply(expr.left, integral);
          }
        }
      }
    }
    return null;
  }

  bool _containsVariable(Expression expr, Variable v) {
    try {
      return expr
          .getVariableTerms()
          .any((variable) => variable.identifier.name == v.identifier.name);
    } catch (_) {
      return false;
    }
  }
}

class ExponentialStrategy implements IntegrationStrategy {
  @override
  String get name => 'Exponential';

  @override
  Expression? tryIntegrate(Expression expr, Variable v, Expression original) {
    if (expr is Exp &&
        expr.operand is Variable &&
        (expr.operand as Variable).identifier.name == v.identifier.name) {
      return Exp(v);
    }
    if (expr is Pow) {
      final base = expr.base;
      final exponent = expr.exponent;
      if (exponent is Variable &&
          exponent.identifier.name == v.identifier.name) {
        // FIX: Recognize Euler's number 'e'
        bool isE = false;
        if (base is Variable && base.identifier.name == 'e') isE = true;
        if (base is Literal && (base.value == 'e' || base.value == math.e)) {
          isE = true;
        }

        if (isE) return expr; // ∫e^x dx = e^x

        final a = base;
        return Divide(expr, Ln(a));
      }
    }
    return null;
  }
}

// ============================================================================
// CALCULUS I & II: TRIGONOMETRIC & HYPERBOLIC FUNCTIONS
// ============================================================================

class BasicTrigStrategy implements IntegrationStrategy {
  @override
  String get name => 'Basic Trig & Hyperbolic';

  @override
  Expression? tryIntegrate(Expression expr, Variable v, Expression original) {
    bool isV(Expression op) =>
        op is Variable && op.identifier.name == v.identifier.name;

    if (expr is Sin && isV(expr.operand)) return Negate(Cos(v));
    if (expr is Cos && isV(expr.operand)) return Sin(v);
    if (expr is Tan && isV(expr.operand)) return Ln(Abs(Sec(v)));
    if (expr is Cot && isV(expr.operand)) return Ln(Abs(Sin(v)));
    if (expr is Sec && isV(expr.operand)) return Ln(Abs(Add(Sec(v), Tan(v))));
    if (expr is Csc && isV(expr.operand)) {
      return Negate(Ln(Abs(Add(Csc(v), Cot(v)))));
    }

    if (expr is Pow &&
        expr.exponent is Literal &&
        (expr.exponent as Literal).value == 2) {
      if (expr.base is Sec && isV((expr.base as Sec).operand)) return Tan(v);
      if (expr.base is Csc && isV((expr.base as Csc).operand)) {
        return Negate(Cot(v));
      }
      if (expr.base is Sin && isV((expr.base as Sin).operand)) {
        return Subtract(Divide(v, Literal(2)),
            Divide(Sin(Multiply(Literal(2), v)), Literal(4)));
      }
      if (expr.base is Cos && isV((expr.base as Cos).operand)) {
        return Add(Divide(v, Literal(2)),
            Divide(Sin(Multiply(Literal(2), v)), Literal(4)));
      }
    }

    if (expr is Sinh && isV(expr.operand)) return Cosh(v);
    if (expr is Cosh && isV(expr.operand)) return Sinh(v);
    if (expr is Tanh && isV(expr.operand)) return Ln(Cosh(v));
    if (expr is Coth && isV(expr.operand)) return Ln(Abs(Sinh(v)));
    if (expr is Sech && isV(expr.operand)) return Atan(Sinh(v));
    if (expr is Csch && isV(expr.operand)) {
      return Ln(Abs(Tanh(Multiply(Literal(0.5), v))));
    }

    if (expr is Pow &&
        expr.exponent is Literal &&
        (expr.exponent as Literal).value == 2) {
      if (expr.base is Sech && isV((expr.base as Sech).operand)) return Tanh(v);
      if (expr.base is Csch && isV((expr.base as Csch).operand)) {
        return Negate(Coth(v));
      }
    }
    return null;
  }
}

class InverseTrigStrategy implements IntegrationStrategy {
  @override
  String get name => 'Inverse Trigonometric';

  Expression _unwrap(Expression e) {
    while (e is GroupExpression) {
      e = e.expression;
    }
    return e;
  }

  @override
  Expression? tryIntegrate(Expression expr, Variable v, Expression original) {
    expr = _unwrap(expr);
    Expression num = Literal(1);
    Expression den = expr;

    if (expr is Divide) {
      num = _unwrap(expr.left);
      den = _unwrap(expr.right);
    } else if (expr is Pow) {
      final expVal = _extractNum(expr.exponent);
      if (expVal != null && expVal == -1.0) {
        den = _unwrap(expr.base);
      } else {
        return null;
      }
    } else if (expr is Multiply) {
      final factors = _flattenMultiply(expr);
      final numFactors = <Expression>[];
      final denFactors = <Expression>[];
      for (var f in factors) {
        f = _unwrap(f);
        if (f is Pow) {
          final expVal = _extractNum(f.exponent);
          if (expVal != null && expVal < 0) {
            denFactors.add(Pow(f.base, Literal(-expVal)).simplify());
          } else {
            numFactors.add(f);
          }
        } else {
          numFactors.add(f);
        }
      }
      num = numFactors.isEmpty
          ? Literal(1)
          : numFactors.reduce((a, b) => Multiply(a, b).simplify());
      den = denFactors.isEmpty
          ? Literal(1)
          : denFactors.reduce((a, b) => Multiply(a, b).simplify());
    } else {
      return null;
    }

    num = _unwrap(num);
    den = _unwrap(den);
    if (_containsVariable(num, v)) return null;

    if (den is Add || den is Subtract) {
      final parts = _extractXSquaredAndConstant(den, v);
      if (parts != null && parts['xSq'] != null && parts['const'] != null) {
        final aSq = parts['const']!;
        final aVal = _tryPositiveSqrt(aSq);
        if (aVal != null) {
          return Multiply(Divide(num, aVal), Atan(Divide(v, aVal))).simplify();
        }
      }
    }

    if (den is Pow) {
      final expVal = _extractNum(den.exponent);
      if (expVal != null && expVal == 0.5) {
        final inner = _unwrap(den.base);
        if (inner is Subtract) {
          final parts = _extractXSquaredAndConstant(
              Multiply(inner, Literal(-1)).simplify(), v);
          if (parts != null && parts['xSq'] != null && parts['const'] != null) {
            final aSq = parts['const']!;
            final aVal = _tryPositiveSqrt(aSq);
            if (aVal != null && !_containsVariable(aSq, v)) {
              return Multiply(num, Asin(Divide(v, aVal))).simplify();
            }
          }
        }
      }
    }
    return null;
  }

  Map<String, Expression>? _extractXSquaredAndConstant(
      Expression expr, Variable v) {
    Expression? xSq, c;
    if (expr is Add) {
      if (_isXSquared(expr.left, v)) {
        xSq = expr.left;
        c = expr.right;
      } else if (_isXSquared(expr.right, v)) {
        xSq = expr.right;
        c = expr.left;
      }
    } else if (expr is Subtract) {
      if (_isXSquared(expr.left, v)) {
        xSq = expr.left;
        c = expr.right;
      }
    }
    if (xSq != null && c != null && !_containsVariable(c, v)) {
      return {'xSq': xSq, 'const': c};
    }
    return null;
  }

  bool _isXSquared(Expression expr, Variable v) {
    if (expr is Pow &&
        expr.base is Variable &&
        (expr.base as Variable).identifier.name == v.identifier.name) {
      final expVal = _extractNum(expr.exponent);
      return expVal != null && expVal == 2.0;
    }
    if (expr is Multiply &&
        expr.left == expr.right &&
        expr.left is Variable &&
        (expr.left as Variable).identifier.name == v.identifier.name) {
      return true;
    }
    return false;
  }

  Expression? _tryPositiveSqrt(Expression expr) {
    try {
      final val = expr.evaluate();
      if (val is num && val > 0) {
        final sqrtVal = math.sqrt(val);
        if (sqrtVal == sqrtVal.roundToDouble()) return Literal(sqrtVal.toInt());
        return Literal(sqrtVal);
      }
      if (val is Rational && val > Rational.zero) {
        return Pow(expr, Literal(Rational(1, 2))).simplify();
      }
      if (val is Complex && val.imaginary == 0 && val.real > 0) {
        final r = val.real;
        if (r is num) {
          final sqrtVal = math.sqrt(r);
          if (sqrtVal == sqrtVal.roundToDouble()) {
            return Literal(sqrtVal.toInt());
          }
          return Literal(sqrtVal);
        }
      }
    } catch (_) {}
    return Pow(expr, Literal(Rational(1, 2))).simplify();
  }

  double? _extractNum(Expression e) {
    try {
      final val = e.evaluate();
      if (val is num) return val.toDouble();
      if (val is Rational) return val.toDouble();
      if (val is Complex && val.imaginary == 0) {
        final r = val.real;
        if (r is num) return r.toDouble();
        if (r is Rational) return r.toDouble();
      }
    } catch (_) {}
    return null;
  }
}

// ============================================================================
// CALCULUS II: RATIONAL FUNCTIONS & PARTIAL FRACTIONS
// ============================================================================

class RationalFunctionStrategy implements IntegrationStrategy {
  @override
  String get name => 'Rational Function (Partial Fractions)';

  @override
  Expression? tryIntegrate(Expression expr, Variable v, Expression original) {
    if (expr is! Divide &&
        !(expr is Pow && _isNegative(_extractNum(expr.exponent)))) {
      if (expr is Multiply) {
        final factors = _flattenMultiply(expr);
        bool hasNegPow = factors
            .any((f) => f is Pow && _isNegative(_extractNum(f.exponent)));
        if (!hasNegPow) return null;
      } else {
        return null;
      }
    }
    try {
      final exprStr = original.toString();
      final varName = v.identifier.name;
      final partFracExpr =
          ExpressionParser().parse("partfrac($exprStr, $varName)");
      final decomposed = partFracExpr.simplify();
      if (decomposed.toString() != exprStr) {
        return SymbolicIntegration.integrate(decomposed, v);
      }
    } catch (_) {}
    return null;
  }

  bool _isNegative(double? val) => val != null && val < 0;
  double? _extractNum(Expression e) {
    try {
      final v = e.evaluate();
      if (v is num) return v.toDouble();
      if (v is Rational) return v.toDouble();
    } catch (_) {}
    return null;
  }
}

// ============================================================================
// CALCULUS I & II: U-SUBSTITUTION & TRIG PRODUCTS
// ============================================================================

class SubstitutionStrategy implements IntegrationStrategy {
  @override
  String get name => 'U-Substitution';

  @override
  Expression? tryIntegrate(Expression expr, Variable v, Expression original) {
    final factors = _flattenMultiply(expr);
    for (int i = 0; i < factors.length; i++) {
      final outerFunc = factors[i];
      Expression? inner;
      if (outerFunc is Sin ||
          outerFunc is Cos ||
          outerFunc is Exp ||
          outerFunc is Ln ||
          outerFunc is Sinh ||
          outerFunc is Cosh) {
        inner = (outerFunc as dynamic).operand;
      } else if (outerFunc is Pow &&
          !_containsVariable(outerFunc.exponent, v)) {
        inner = outerFunc.base;
      } else {
        continue;
      }
      if (inner == null || !_containsVariable(inner, v)) continue;
      final du = inner.differentiate(v).simplify();
      final remaining = [...factors]..removeAt(i);
      Expression actualDu = remaining.isEmpty
          ? Literal(1)
          : remaining.reduce((a, b) => Multiply(a, b).simplify());
      final k = _getConstantFactor(actualDu, du, v);
      if (k != null) {
        final integralOuter = _integrateOuter(outerFunc, inner, v);
        if (integralOuter != null) return Multiply(k, integralOuter).simplify();
      }
    }
    return null;
  }

  Expression? _integrateOuter(Expression func, Expression inner, Variable v) {
    if (func is Sin) return Negate(Cos(inner));
    if (func is Cos) return Sin(inner);
    if (func is Exp) return Exp(inner);
    if (func is Ln) return Subtract(Multiply(inner, Ln(inner)), inner);
    if (func is Sinh) return Cosh(inner);
    if (func is Cosh) return Sinh(inner);
    if (func is Pow) {
      final n = _extractNum(func.exponent);
      if (n != null) {
        if (n == -1 || n == -1.0) return Ln(inner); // Removed Abs

        // Force exact rational formatting for fractional exponents
        Expression nPlus1Lit;
        if (n == 0.5) {
          nPlus1Lit = Literal(Rational(3, 2));
        } else if (n == -0.5) {
          nPlus1Lit = Literal(Rational(1, 2));
        } else if (n == n.toInt()) {
          nPlus1Lit = Literal(n.toInt() + 1);
        } else {
          nPlus1Lit = Literal(n + 1);
        }

        return Divide(Pow(inner, nPlus1Lit), nPlus1Lit);
      }
    }
    return null;
  }

  num? _extractNum(Expression e) {
    try {
      final val = e.evaluate();
      if (val is num) return val;
      if (val is Rational) return val.toDouble();
      if (val is Complex && val.imaginary == 0) {
        final r = val.real;
        if (r is num) return r;
        if (r is Rational) return r.toDouble();
      }
    } catch (_) {}
    return null;
  }
}

class TrigProductStrategy implements IntegrationStrategy {
  @override
  String get name => 'Trig Products (sin^m cos^n)';

  @override
  Expression? tryIntegrate(Expression expr, Variable v, Expression original) {
    // Left as placeholder for advanced reduction formulas
    return null;
  }
}

// ============================================================================
// CALCULUS II: INTEGRATION BY PARTS (WITH CYCLIC DETECTION)
// ============================================================================

class IntegrationByPartsStrategy implements IntegrationStrategy {
  @override
  String get name => 'Integration By Parts';

  @override
  Expression? tryIntegrate(Expression expr, Variable v, Expression original) {
    // FIX: Restore solo function handling for IBP (implied * 1)
    if (_isLogarithmic(expr) || _isInverseTrig(expr)) {
      return _applyIBP(expr, Literal(1), v, original);
    }

    if (expr is! Multiply) return null;
    final left = expr.left;
    final right = expr.right;

    if (_isLogarithmic(left) && _isAlgebraic(right, v)) {
      return _applyIBP(left, right, v, original);
    }
    if (_isAlgebraic(left, v) && _isLogarithmic(right)) {
      return _applyIBP(right, left, v, original);
    }
    if (_isInverseTrig(left) && _isAlgebraic(right, v)) {
      return _applyIBP(left, right, v, original);
    }
    if (_isAlgebraic(left, v) && _isInverseTrig(right)) {
      return _applyIBP(right, left, v, original);
    }
    if (_isAlgebraic(left, v) && _isTrig(right)) {
      return _applyIBP(left, right, v, original);
    }
    if (_isTrig(left) && _isAlgebraic(right, v)) {
      return _applyIBP(right, left, v, original);
    }
    if (_isAlgebraic(left, v) && _isExponential(right, v)) {
      return _applyIBP(left, right, v, original);
    }
    if (_isExponential(left, v) && _isAlgebraic(right, v)) {
      return _applyIBP(right, left, v, original);
    }
    if ((_isExponential(left, v) && _isTrig(right)) ||
        (_isTrig(left) && _isExponential(right, v))) {
      return _applyIBP(left, right, v, original);
    }
    return null;
  }

  Expression? _applyIBP(
      Expression u, Expression dv, Variable v, Expression original) {
    try {
      final du = u.differentiate(v).simplify();
      final integralDv = SymbolicIntegration.integrate(dv, v);
      final vDu = Multiply(integralDv, du).simplify();
      final k = _getConstantFactor(vDu, original, v);
      if (k != null) {
        final uv = Multiply(u, integralDv).simplify();
        final onePlusK = Add(Literal(1), k).simplify();
        return Divide(uv, onePlusK).simplify();
      }
      final integralVDu = SymbolicIntegration.integrate(vDu, v);
      return Subtract(Multiply(u, integralDv), integralVDu).simplify();
    } catch (_) {
      return null;
    }
  }

  bool _isLogarithmic(Expression e) => e is Ln || e is Log;
  bool _isInverseTrig(Expression e) => e is Asin || e is Acos || e is Atan;

  bool _isAlgebraic(Expression e, Variable v) {
    if (e is Variable && e.identifier.name == v.identifier.name) return true;
    if (e is Pow &&
        e.base is Variable &&
        (e.base as Variable).identifier.name == v.identifier.name) {
      return !_containsVariable(e.exponent, v);
    }
    if (e is Multiply) {
      return (e.left is Literal && _isAlgebraic(e.right, v)) ||
          (e.right is Literal && _isAlgebraic(e.left, v));
    }
    if (e is Add || e is Subtract) {
      return _isAlgebraic((e as BinaryOperationsExpression).left, v) &&
          _isAlgebraic(e.right, v);
    }
    return false;
  }

  bool _isTrig(Expression e) =>
      e is Sin || e is Cos || e is Tan || e is Sinh || e is Cosh;

  bool _isExponential(Expression e, Variable v) {
    if (e is Exp) return true;
    if (e is Pow &&
        !_containsVariable(e.base, v) &&
        e.exponent is Variable &&
        (e.exponent as Variable).identifier.name == v.identifier.name) {
      return true;
    }
    return false;
  }

  bool _containsVariable(Expression expr, Variable v) {
    try {
      return expr
          .getVariableTerms()
          .any((variable) => variable.identifier.name == v.identifier.name);
    } catch (_) {
      return false;
    }
  }
}

// ============================================================================
// CALCULUS II: TRIGONOMETRIC POWERS & PRODUCTS
// ============================================================================

class TrigPowerStrategy implements IntegrationStrategy {
  @override
  String get name => 'Trig Powers & Products';

  // FIXED: Added missing 'original' parameter
  @override
  Expression? tryIntegrate(Expression expr, Variable v, Expression original) {
    final factors = _flattenMultiply(expr);
    int sinPow = 0, cosPow = 0;
    Expression? sinArg, cosArg;
    List<Expression> otherFactors = [];

    for (var f in factors) {
      if (f is Sin &&
          f.operand is Variable &&
          (f.operand as Variable).identifier.name == v.identifier.name) {
        sinPow++;
        sinArg = f.operand;
      } else if (f is Pow &&
          f.base is Sin &&
          (f.base as Sin).operand is Variable &&
          ((f.base as Sin).operand as Variable).identifier.name ==
              v.identifier.name) {
        sinPow += _extractInt(f.exponent);
        sinArg = (f.base as Sin).operand;
      } else if (f is Cos &&
          f.operand is Variable &&
          (f.operand as Variable).identifier.name == v.identifier.name) {
        cosPow++;
        cosArg = f.operand;
      } else if (f is Pow &&
          f.base is Cos &&
          (f.base as Cos).operand is Variable &&
          ((f.base as Cos).operand as Variable).identifier.name ==
              v.identifier.name) {
        cosPow += _extractInt(f.exponent);
        cosArg = (f.base as Cos).operand;
      } else {
        otherFactors.add(f);
      }
    }

    if (otherFactors.any((f) => _containsVariable(f, v))) return null;
    Expression constantMultiplier = otherFactors.isEmpty
        ? Literal(1)
        : otherFactors.reduce((a, b) => Multiply(a, b).simplify());

    if (sinPow > 0 &&
        cosPow >= 0 &&
        sinArg != null &&
        cosArg != null &&
        sinArg.toString() == cosArg.toString()) {
      if (sinPow % 2 != 0) {
        return _integrateSinOddCosEven(
            sinPow, cosPow, sinArg, constantMultiplier, v);
      }
      if (cosPow % 2 != 0) {
        return _integrateCosOddSinEven(
            sinPow, cosPow, sinArg, constantMultiplier, v);
      }
    }

    if (sinPow > 0 && cosPow == 0) {
      if (sinPow == 2) {
        return Multiply(
                constantMultiplier,
                Subtract(Divide(v, Literal(2)),
                    Divide(Sin(Multiply(Literal(2), v)), Literal(4))))
            .simplify();
      }
    }
    if (cosPow > 0 && sinPow == 0) {
      if (cosPow == 2) {
        return Multiply(
                constantMultiplier,
                Add(Divide(v, Literal(2)),
                    Divide(Sin(Multiply(Literal(2), v)), Literal(4))))
            .simplify();
      }
    }
    return null;
  }

  Expression? _integrateSinOddCosEven(
      int m, int n, Expression arg, Expression constant, Variable v) {
    int k = (m - 1) ~/ 2;
    Expression integral = Literal(0);
    for (int i = 0; i <= k; i++) {
      int coeff = _binomial(k, i) * (i % 2 == 0 ? 1 : -1);
      int powerOfU = n + 2 * i;
      Expression term = Multiply(Literal(Rational(coeff, powerOfU + 1)),
          Pow(Cos(arg), Literal(powerOfU + 1)));
      integral = Add(integral, term).simplify();
    }
    return Multiply(Negate(constant), integral).simplify();
  }

  Expression? _integrateCosOddSinEven(
      int m, int n, Expression arg, Expression constant, Variable v) {
    int kCos = (n - 1) ~/ 2;
    Expression integral = Literal(0);
    for (int i = 0; i <= kCos; i++) {
      int coeff = _binomial(kCos, i) * (i % 2 == 0 ? 1 : -1);
      int powerOfU = m + 2 * i;
      Expression term = Multiply(Literal(Rational(coeff, powerOfU + 1)),
          Pow(Sin(arg), Literal(powerOfU + 1)));
      integral = Add(integral, term).simplify();
    }
    return Multiply(constant, integral).simplify();
  }

  int _extractInt(Expression e) {
    try {
      final val = e.evaluate();
      if (val is num) return val.toInt();
    } catch (_) {}
    return 0;
  }

  int _binomial(int n, int k) {
    if (k < 0 || k > n) return 0;
    if (k == 0 || k == n) return 1;
    int res = 1;
    for (int i = 0; i < k; i++) {
      res = res * (n - i) ~/ (i + 1);
    }
    return res;
  }
}

// ============================================================================
// CALCULUS II: INVERSE HYPERBOLIC FORMS
// ============================================================================

class InverseHyperbolicStrategy implements IntegrationStrategy {
  @override
  String get name => 'Inverse Hyperbolic';

  Expression _unwrap(Expression e) {
    while (e is GroupExpression) {
      e = e.expression;
    }
    return e;
  }

  @override
  Expression? tryIntegrate(Expression expr, Variable v, Expression original) {
    expr = _unwrap(expr);
    Expression num = Literal(1);
    Expression den = expr;

    if (expr is Divide) {
      num = _unwrap(expr.left);
      den = _unwrap(expr.right);
    } else if (expr is Pow) {
      final expVal = _extractNum(expr.exponent);
      if (expVal != null && expVal == -0.5) {
        den = _unwrap(expr.base);
      } else {
        return null;
      }
    } else if (expr is Multiply) {
      final factors = _flattenMultiply(expr);
      final numFactors = <Expression>[];
      final denFactors = <Expression>[];
      for (var f in factors) {
        f = _unwrap(f);
        if (f is Pow) {
          final expVal = _extractNum(f.exponent);
          if (expVal != null && expVal == -0.5) {
            denFactors.add(_unwrap(f.base));
          } else {
            numFactors.add(f);
          }
        } else {
          numFactors.add(f);
        }
      }
      num = numFactors.isEmpty
          ? Literal(1)
          : numFactors.reduce((a, b) => Multiply(a, b).simplify());
      den = denFactors.isEmpty
          ? Literal(1)
          : denFactors.reduce((a, b) => Multiply(a, b).simplify());
    } else {
      return null;
    }

    num = _unwrap(num);
    den = _unwrap(den);
    if (_containsVariable(num, v)) return null;

    if (den is Add || den is Subtract) {
      final parts = _extractXSquaredAndConstant(den, v);
      if (parts != null && parts['xSq'] != null && parts['const'] != null) {
        final aSq = parts['const']!;
        final a = Pow(aSq, Literal(Rational(1, 2))).simplify();
        if (den is Add) return Multiply(num, Asinh(Divide(v, a))).simplify();
        if (den is Subtract) {
          return Multiply(num, Acosh(Divide(v, a))).simplify();
        }
      }
    }
    return null;
  }

  Map<String, Expression>? _extractXSquaredAndConstant(
      Expression expr, Variable v) {
    Expression? xSq, c;
    if (expr is Add) {
      if (_isXSquared(expr.left, v)) {
        xSq = expr.left;
        c = expr.right;
      } else if (_isXSquared(expr.right, v)) {
        xSq = expr.right;
        c = expr.left;
      }
    } else if (expr is Subtract) {
      if (_isXSquared(expr.left, v)) {
        xSq = expr.left;
        c = expr.right;
      }
    }
    if (xSq != null && c != null && !_containsVariable(c, v)) {
      return {'xSq': xSq, 'const': c};
    }
    return null;
  }

  bool _isXSquared(Expression expr, Variable v) {
    return expr is Pow &&
        expr.base is Variable &&
        (expr.base as Variable).identifier.name == v.identifier.name &&
        expr.exponent is Literal &&
        _extractNum(expr.exponent) == 2.0;
  }

  double? _extractNum(Expression e) {
    try {
      final val = e.evaluate();
      if (val is num) return val.toDouble();
      if (val is Rational) return val.toDouble();
    } catch (_) {}
    return null;
  }
}

// ============================================================================
// CALCULUS II: COMPLETING THE SQUARE
// ============================================================================

class CompletingTheSquareStrategy implements IntegrationStrategy {
  @override
  String get name => 'Completing the Square';

  // FIXED: Added missing 'original' parameter & exact symbolic square roots
  @override
  Expression? tryIntegrate(Expression expr, Variable v, Expression original) {
    if (expr is! Divide) return null;
    Expression num = expr.left;
    Expression den = expr.right;
    if (_containsVariable(num, v)) return null;

    final coeffs = _extractQuadraticCoeffs(den, v);
    if (coeffs == null) return null;

    final A = coeffs['A']!;
    final B = coeffs['B']!;
    final C = coeffs['C']!;

    final twoA = Multiply(Literal(2), A).simplify();
    final bOver2A = Divide(B, twoA).simplify();
    final u = Add(v, bOver2A).simplify();

    final cOverA = Divide(C, A).simplify();
    final bOver2ASq = Pow(bOver2A, Literal(2)).simplify();
    final k = Subtract(cOverA, bOver2ASq).simplify();

    final newNum = Divide(num, A).simplify();
    final kVal = _tryNumericEval(k);

    if (kVal != null) {
      if (kVal > 0) {
        final sqrtK = _perfectSquareRoot(kVal);
        final a = sqrtK != null
            ? Literal(sqrtK)
            : Pow(k, Literal(Rational(1, 2))).simplify();
        return Multiply(Divide(newNum, a), Atan(Divide(u, a))).simplify();
      } else if (kVal < 0) {
        final sqrtK = _perfectSquareRoot(-kVal);
        final a = sqrtK != null
            ? Literal(sqrtK)
            : Pow(Negate(k), Literal(Rational(1, 2))).simplify();
        final twoAVal = Multiply(Literal(2), a).simplify();
        final logArg = Divide(Subtract(u, a), Add(u, a)).simplify();
        return Multiply(Divide(newNum, twoAVal), Ln(Abs(logArg))).simplify();
      } else {
        return Multiply(newNum, Negate(Pow(u, Literal(-1)))).simplify();
      }
    }

    final a = Pow(k, Literal(Rational(1, 2))).simplify();
    return Multiply(Divide(newNum, a), Atan(Divide(u, a))).simplify();
  }

  double? _perfectSquareRoot(double val) {
    if (val < 0) return null;
    final root = math.sqrt(val);
    if ((root - root.roundToDouble()).abs() < 1e-9) return root.roundToDouble();
    return null;
  }

  double? _tryNumericEval(Expression e) {
    try {
      final val = e.evaluate();
      if (val is num) return val.toDouble();
      if (val is Rational) return val.toDouble();
      if (val is Complex && val.imaginary == 0) return val.real.toDouble();
    } catch (_) {}
    return null;
  }

  Map<String, Expression>? _extractQuadraticCoeffs(
      Expression expr, Variable v) {
    try {
      final expanded = expr.expand().simplify();
      final poly = Polynomial.fromString(expanded.toString(), variable: v);
      if (poly.degree == 2) {
        Expression wrap(dynamic c) => c is Expression ? c : Literal(c);
        return {
          'A': wrap(poly.coefficients[0]),
          'B': wrap(poly.coefficients[1]),
          'C': wrap(poly.coefficients[2]),
        };
      }
    } catch (_) {}
    return null;
  }
}

// ============================================================================
// CALCULUS II: LINEAR SUBSTITUTION (Handles P(x) * (ax+b)^n)
// ============================================================================

class LinearSubstitutionStrategy implements IntegrationStrategy {
  @override
  String get name => 'Linear Substitution';

  @override
  Expression? tryIntegrate(Expression expr, Variable v, Expression original) {
    final factors = _flattenMultiply(expr);

    Expression? linearBase;
    Expression? powerExpr;
    List<Expression> polyFactors = [];

    // 1. Separate the linear base (ax+b)^n from the polynomial factors P(x)
    for (var f in factors) {
      if (f is Pow) {
        final base = f.base;
        final exp = f.exponent;
        if (_isLinear(base, v) && !_containsVariable(exp, v)) {
          if (linearBase != null) return null; // Only one linear base allowed
          linearBase = base;
          powerExpr = exp;
        } else {
          polyFactors.add(f);
        }
      } else if (_isLinear(f, v) && _containsVariable(f, v)) {
        if (linearBase != null) {
          polyFactors.add(f);
        } else {
          linearBase = f;
          powerExpr = Literal(1);
        }
      } else {
        polyFactors.add(f);
      }
    }

    if (linearBase == null || powerExpr == null) return null;

    Expression polyExpr = polyFactors.isEmpty
        ? Literal(1)
        : polyFactors.reduce((a, b) => Multiply(a, b).simplify());

    // 2. Extract 'a' and 'b' from the linear base (a*x + b)
    final aCoeff = _extractLinearCoeff(linearBase, v);
    final bCoeff = _extractLinearConst(linearBase, v);

    if (aCoeff == null || bCoeff == null) return null;

    // 3. Perform substitution: u = a*x + b  =>  x = (u - b) / a
    Variable u = Variable('_u_');
    Expression xInTermsOfU = Divide(Subtract(u, bCoeff), aCoeff).simplify();

    // Substitute x in P(x) and expand
    Expression polyInU =
        polyExpr.substitute(v, xInTermsOfU).expand().simplify();

    // 4. Build the new integrand: P(u) * u^n / a
    Expression integrandInU =
        Multiply(polyInU, Pow(u, powerExpr)).expand().simplify();
    integrandInU = Divide(integrandInU, aCoeff).simplify();

    // 5. Integrate with respect to u, then substitute back
    try {
      Expression integralInU = SymbolicIntegration.integrate(integrandInU, u);
      Expression finalIntegral =
          integralInU.substitute(u, linearBase).simplify();
      return finalIntegral;
    } catch (_) {
      return null;
    }
  }

  bool _isLinear(Expression expr, Variable v) {
    expr = expr.simplify();
    if (expr is Variable && expr.identifier.name == v.identifier.name) {
      return true;
    }
    if (expr is Multiply) {
      if (!_containsVariable(expr.left, v) && _isLinear(expr.right, v)) {
        return true;
      }
      if (!_containsVariable(expr.right, v) && _isLinear(expr.left, v)) {
        return true;
      }
    }
    if (expr is Add || expr is Subtract) {
      bool leftLin = _isLinear((expr as BinaryOperationsExpression).left, v);
      bool rightConst = !_containsVariable(expr.right, v);
      bool rightLin = _isLinear(expr.right, v);
      bool leftConst = !_containsVariable(expr.left, v);
      return (leftLin && rightConst) || (rightLin && leftConst);
    }
    return false;
  }

  Expression? _extractLinearCoeff(Expression expr, Variable v) {
    expr = expr.simplify();
    if (expr is Variable && expr.identifier.name == v.identifier.name) {
      return Literal(1);
    }
    if (expr is Multiply) {
      if (!_containsVariable(expr.left, v)) {
        final inner = _extractLinearCoeff(expr.right, v);
        if (inner != null) return Multiply(expr.left, inner).simplify();
      }
      if (!_containsVariable(expr.right, v)) {
        final inner = _extractLinearCoeff(expr.left, v);
        if (inner != null) return Multiply(expr.right, inner).simplify();
      }
    }
    if (expr is Add || expr is Subtract) {
      if (_isLinear((expr as BinaryOperationsExpression).left, v) &&
          !_containsVariable(expr.right, v)) {
        return _extractLinearCoeff(expr.left, v);
      }
      if (_isLinear(expr.right, v) && !_containsVariable(expr.left, v)) {
        return _extractLinearCoeff(expr.right, v);
      }
    }
    return null;
  }

  Expression? _extractLinearConst(Expression expr, Variable v) {
    expr = expr.simplify();
    if (expr is Variable && expr.identifier.name == v.identifier.name) {
      return Literal(0);
    }
    if (expr is Multiply) {
      if (!_containsVariable(expr.left, v)) {
        final inner = _extractLinearConst(expr.right, v);
        if (inner != null) return Multiply(expr.left, inner).simplify();
      }
      if (!_containsVariable(expr.right, v)) {
        final inner = _extractLinearConst(expr.left, v);
        if (inner != null) return Multiply(expr.right, inner).simplify();
      }
    }
    if (expr is Add) {
      if (_isLinear(expr.left, v) && !_containsVariable(expr.right, v)) {
        return expr.right;
      }
      if (_isLinear(expr.right, v) && !_containsVariable(expr.left, v)) {
        return expr.left;
      }
    }
    if (expr is Subtract) {
      if (_isLinear(expr.left, v) && !_containsVariable(expr.right, v)) {
        return Negate(expr.right).simplify();
      }
      if (_isLinear(expr.right, v) && !_containsVariable(expr.left, v)) {
        return expr.left;
      }
    }
    return null;
  }
}
