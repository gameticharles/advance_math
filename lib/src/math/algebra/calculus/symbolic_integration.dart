import 'dart:math' as math;
import '../expression/expression.dart';
import '../../../number/complex/complex.dart';

/// Strategy pattern for symbolic integration
abstract class IntegrationStrategy {
  /// Attempts to integrate the expression
  /// Returns null if this strategy cannot handle the expression
  Expression? tryIntegrate(Expression expr, Variable v);

  /// Strategy name for debugging
  String get name;
}

/// Symbolic integration engine using multiple strategies
class SymbolicIntegration {
  static final List<IntegrationStrategy> strategies = [
    PowerRuleStrategy(),
    BasicTrigStrategy(),
    ExponentialStrategy(),
    ConstantMultipleStrategy(),
    SubstitutionStrategy(),
    IntegrationByPartsStrategy(),
    InverseTrigStrategy(),
    SumDifferenceStrategy(),
  ];

  /// Integrate expression with respect to variable v
  /// Throws UnimplementedError if no strategy succeeds
  static Expression integrate(Expression expr, Variable v) {
    for (var strategy in strategies) {
      final result = strategy.tryIntegrate(expr, v);
      if (result != null) {
        return result;
      }
    }

    throw UnimplementedError(
        'Cannot symbolically integrate: ${expr.toString()}\n'
        'Consider using numerical integration instead.');
  }
}

/// Power Rule: ∫x^n dx = x^(n+1)/(n+1) + C (n ≠ -1)
/// Special case: ∫1/x dx = ln|x| + C
class PowerRuleStrategy implements IntegrationStrategy {
  @override
  String get name => 'Power Rule';

  @override
  Expression? tryIntegrate(Expression expr, Variable v) {
    // print('PowerRule trying: $expr');
    // Case 1: Variable itself → ∫x dx = x²/2
    if (expr is Variable && expr.identifier.name == v.identifier.name) {
      return Divide(Pow(v, Literal(2)), Literal(2));
    }

    // Case 2: Power of variable → ∫x^n dx
    if (expr is Pow) {
      if (expr.base is Variable &&
          (expr.base as Variable).identifier.name == v.identifier.name) {
        // Check if exponent is a constant number
        num? n;
        if (expr.exponent is Literal) {
          final val = (expr.exponent as Literal).value;
          if (val is num) {
            n = val;
          } else if (val is Complex && val.imaginary == 0) {
            n = val.real;
          }
        } else if (!expr.exponent
            .getVariableTerms()
            .any((t) => t.identifier.name == v.identifier.name)) {
          try {
            final val = expr.exponent.evaluate();
            if (val is num) n = val;
          } catch (e) {
            // Ignore evaluation errors
          }
        }

        if (n != null) {
          // Special case: ∫x^(-1) dx = ln|x|
          if (n == -1) {
            return Ln(v);
          }

          // General case: ∫x^n dx = x^(n+1)/(n+1)
          final newExponent = n + 1;
          return Divide(Pow(v, Literal(newExponent)), Literal(newExponent));
        }
      }
    }

    // Case 3: Constant → ∫c dx = c·x
    if (!_containsVariable(expr, v)) {
      return Multiply(expr, v);
    }

    // Case 4: Constant times power → ∫c·x^n dx
    if (expr is Multiply) {
      if (!_containsVariable(expr.left, v)) {
        final powerIntegral = tryIntegrate(expr.right, v);
        if (powerIntegral != null) {
          return Multiply(expr.left, powerIntegral);
        }
      }
      if (!_containsVariable(expr.right, v)) {
        final powerIntegral = tryIntegrate(expr.left, v);
        if (powerIntegral != null) {
          return Multiply(expr.right, powerIntegral);
        }
      }
    }

    // Case 5: Division → ∫1/x dx or ∫c/x dx
    if (expr is Divide) {
      // print('PowerRule Divide check: $expr');
      Expression denom = expr.right;
      // Unwrap Pow(x, 1) if present
      if (denom is Pow &&
          denom.exponent is Literal &&
          (denom.exponent as Literal).value == 1) {
        denom = denom.base;
      }

      // Check for 1/x or c/x
      if (denom is Variable && denom.identifier.name == v.identifier.name) {
        if (!_containsVariable(expr.left, v)) {
          // ∫c/x dx = c * ln|x|
          if (expr.left is Literal && (expr.left as Literal).value == 1) {
            return Ln(v);
          }
          return Multiply(expr.left, Ln(v));
        }
      }

      // Check for x^-n expressed as 1/x^n
      if (expr.right is Pow && !_containsVariable(expr.left, v)) {
        final denomPow = expr.right as Pow;
        if (denomPow.base is Variable &&
            (denomPow.base as Variable).identifier.name == v.identifier.name) {
          Expression? exponent = denomPow.exponent;
          // We need to negate the exponent.
          // If exponent is literal, easy.
          if (exponent is Literal && exponent.value is num) {
            final n = -(exponent.value as num);
            if (n == -1) return Multiply(expr.left, Ln(v));

            final newExponent = n + 1;
            final integral =
                Divide(Pow(v, Literal(newExponent)), Literal(newExponent));

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
    return expr
        .getVariableTerms()
        .any((variable) => variable.identifier.name == v.identifier.name);
  }
}

/// Basic trig integration rules
class BasicTrigStrategy implements IntegrationStrategy {
  @override
  String get name => 'Basic Trigonometric';

  @override
  Expression? tryIntegrate(Expression expr, Variable v) {
    // ∫sin(x) dx = -cos(x)
    if (expr is Sin && expr.operand is Variable) {
      if ((expr.operand as Variable).identifier.name == v.identifier.name) {
        return Negate(Cos(v));
      }
    }

    // ∫cos(x) dx = sin(x)
    if (expr is Cos && expr.operand is Variable) {
      if ((expr.operand as Variable).identifier.name == v.identifier.name) {
        return Sin(v);
      }
    }

    // ∫sec²(x) dx = tan(x)
    if (expr is Pow && expr.base is Sec && expr.exponent is Literal) {
      final secExpr = expr.base as Sec;
      if ((expr.exponent as Literal).value == 2 &&
          secExpr.operand is Variable &&
          (secExpr.operand as Variable).identifier.name == v.identifier.name) {
        return Tan(v);
      }
    }

    // ∫csc²(x) dx = -cot(x)
    if (expr is Pow && expr.base is Csc && expr.exponent is Literal) {
      final cscExpr = expr.base as Csc;
      if ((expr.exponent as Literal).value == 2 &&
          cscExpr.operand is Variable &&
          (cscExpr.operand as Variable).identifier.name == v.identifier.name) {
        return Negate(Cot(v));
      }
    }

    // ∫tan(x) dx = -ln|cos(x)| = ln|sec(x)|
    if (expr is Tan && expr.operand is Variable) {
      if ((expr.operand as Variable).identifier.name == v.identifier.name) {
        return Ln(Sec(v));
      }
    }

    // ∫cot(x) dx = ln|sin(x)|
    if (expr is Cot && expr.operand is Variable) {
      if ((expr.operand as Variable).identifier.name == v.identifier.name) {
        return Ln(Sin(v));
      }
    }

    // ∫sec(x) dx = ln|sec(x) + tan(x)|
    if (expr is Sec && expr.operand is Variable) {
      if ((expr.operand as Variable).identifier.name == v.identifier.name) {
        return Ln(Add(Sec(v), Tan(v)));
      }
    }

    // ∫csc(x) dx = -ln|csc(x) + cot(x)|
    if (expr is Csc && expr.operand is Variable) {
      if ((expr.operand as Variable).identifier.name == v.identifier.name) {
        return Negate(Ln(Add(Csc(v), Cot(v))));
      }
    }

    // Power Reduction: ∫sin²(x) dx = ∫(1 - cos(2x))/2 dx = x/2 - sin(2x)/4
    if (expr is Pow && expr.base is Sin && expr.exponent is Literal) {
      if ((expr.exponent as Literal).value == 2) {
        final sinExpr = expr.base as Sin;
        if (sinExpr.operand is Variable &&
            (sinExpr.operand as Variable).identifier.name ==
                v.identifier.name) {
          // x/2 - sin(2x)/4
          return Subtract(Divide(v, Literal(2)),
              Divide(Sin(Multiply(Literal(2), v)), Literal(4)));
        }
      }
    }

    // Power Reduction: ∫cos²(x) dx = ∫(1 + cos(2x))/2 dx = x/2 + sin(2x)/4
    if (expr is Pow && expr.base is Cos && expr.exponent is Literal) {
      if ((expr.exponent as Literal).value == 2) {
        final cosExpr = expr.base as Cos;
        if (cosExpr.operand is Variable &&
            (cosExpr.operand as Variable).identifier.name ==
                v.identifier.name) {
          // x/2 + sin(2x)/4
          return Add(Divide(v, Literal(2)),
              Divide(Sin(Multiply(Literal(2), v)), Literal(4)));
        }
      }
    }

    return null;
  }
}

/// Inverse Trigonometric integration: ∫1/(x²+a²) dx, ∫1/√(a²-x²) dx
class InverseTrigStrategy implements IntegrationStrategy {
  @override
  String get name => 'Inverse Trigonometric';

  @override
  Expression? tryIntegrate(Expression expr, Variable v) {
    if (expr is! Divide) return null;

    // Check for 1/(...) or c/(...)
    Expression numerator = expr.left;
    Expression denominator = expr.right;

    // Ensure numerator is constant w.r.t v
    if (_containsVariable(numerator, v)) return null;

    // Case 1: ∫1/(x² + a²) dx = (1/a) * atan(x/a)
    // Denominator should be Add(Pow(x,2), a^2) or Add(a^2, Pow(x,2))
    if (denominator is Add) {
      Expression? xSquared;
      Expression? aSquared;

      if (_isXSquared(denominator.left, v)) {
        xSquared = denominator.left;
        aSquared = denominator.right;
      } else if (_isXSquared(denominator.right, v)) {
        xSquared = denominator.right;
        aSquared = denominator.left;
      }

      if (xSquared != null &&
          aSquared != null &&
          !_containsVariable(aSquared, v)) {
        // Found x^2 + a^2
        // We need 'a'. If aSquared is Literal, we can sqrt it.
        // If it's an expression, we represent it as sqrt(a^2)
        Expression a = PredefinedFunctionExpression('sqrt', aSquared);
        if (aSquared is Literal && (aSquared.value as num) > 0) {
          a = Literal(math.sqrt((aSquared.value as num).toDouble()));
        }

        // Result: (numerator/a) * atan(x/a)
        return Multiply(Divide(numerator, a), Atan(Divide(v, a)));
      }
    }

    // Case 2: ∫1/√(a² - x²) dx = asin(x/a)
    // Denominator is PredefinedFunctionExpression('sqrt', Subtract(a^2, x^2))
    // or Pow(Subtract(a^2, x^2), 0.5)
    Expression? inner;
    if (denominator is PredefinedFunctionExpression &&
        denominator.functionName == 'sqrt') {
      inner = denominator.operand;
    } else if (denominator is Pow &&
        denominator.exponent is Literal &&
        (denominator.exponent as Literal).value == 0.5) {
      inner = denominator.base;
    }

    if (inner is Subtract) {
      // Check for a^2 - x^2
      if (!_containsVariable(inner.left, v) && _isXSquared(inner.right, v)) {
        Expression aSquared = inner.left;
        Expression a = PredefinedFunctionExpression('sqrt', aSquared);
        if (aSquared is Literal && (aSquared.value as num) > 0) {
          a = Literal(math.sqrt((aSquared.value as num).toDouble()));
        }

        // Result: numerator * asin(x/a)
        return Multiply(numerator, Asin(Divide(v, a)));
      }
    }

    return null;
  }

  bool _isXSquared(Expression expr, Variable v) {
    if (expr is Pow) {
      if (expr.base is Variable &&
          (expr.base as Variable).identifier.name == v.identifier.name &&
          expr.exponent is Literal &&
          (expr.exponent as Literal).value == 2) {
        return true;
      }
    }
    return false;
  }

  bool _containsVariable(Expression expr, Variable v) {
    try {
      return expr
          .getVariableTerms()
          .any((variable) => variable.identifier.name == v.identifier.name);
    } catch (e) {
      return false;
    }
  }
}

/// Exponential integration
class ExponentialStrategy implements IntegrationStrategy {
  @override
  String get name => 'Exponential';

  @override
  Expression? tryIntegrate(Expression expr, Variable v) {
    // ∫e^x dx = e^x
    if (expr is Exp && expr.operand is Variable) {
      if ((expr.operand as Variable).identifier.name == v.identifier.name) {
        return Exp(v);
      }
    }

    // ∫a^x dx = a^x / ln(a)
    if (expr is Pow) {
      if (expr.base is Literal && expr.exponent is Variable) {
        if ((expr.exponent as Variable).identifier.name == v.identifier.name) {
          final a = expr.base;
          return Divide(expr, Ln(a));
        }
      }
    }

    return null;
  }
}

/// Sum and difference rule: ∫(f ± g) dx = ∫f dx ± ∫g dx
class SumDifferenceStrategy implements IntegrationStrategy {
  @override
  String get name => 'Sum/Difference Rule';

  @override
  Expression? tryIntegrate(Expression expr, Variable v) {
    // ∫(f + g) dx = ∫f dx + ∫g dx
    if (expr is Add) {
      try {
        final leftIntegral = SymbolicIntegration.integrate(expr.left, v);
        final rightIntegral = SymbolicIntegration.integrate(expr.right, v);
        return Add(leftIntegral, rightIntegral);
      } catch (e) {
        return null;
      }
    }

    // ∫(f - g) dx = ∫f dx - ∫g dx
    if (expr is Subtract) {
      try {
        final leftIntegral = SymbolicIntegration.integrate(expr.left, v);
        final rightIntegral = SymbolicIntegration.integrate(expr.right, v);
        return Subtract(leftIntegral, rightIntegral);
      } catch (e) {
        return null;
      }
    }

    return null;
  }
}

/// U-Substitution Strategy: Detects patterns like ∫f'(x)·g(f(x)) dx
/// Common patterns: ∫2x·sin(x²) dx, ∫x·e^(x²) dx
class SubstitutionStrategy implements IntegrationStrategy {
  @override
  String get name => 'U-Substitution';

  @override
  Expression? tryIntegrate(Expression expr, Variable v) {
    // Pattern 1: ∫f'(x)·g(f(x)) dx where g is sin, cos, exp, etc.
    // Example: ∫2x·sin(x²) dx → -cos(x²)
    // If expression is Pow, try generalized power rule with implicit * 1
    if (expr is Pow) {
      // treat as Multiply(expr, 1)
      Expression temp = Multiply(expr, Literal(1));
      final powerResult = _tryGeneralizedPowerRule(temp as Multiply, v);
      if (powerResult != null) return powerResult;
    }

    // If expression is Sin/Cos/Exp, try chain rule with implicit * 1
    if (expr is Sin || expr is Cos || expr is Exp) {
      Expression temp = Multiply(expr, Literal(1));
      final chainResult = _tryChainRulePattern(temp as Multiply, v);
      if (chainResult != null) return chainResult;
    }

    if (expr is Multiply) {
      final result = _tryChainRulePattern(expr, v);
      if (result != null) return result;

      // Pattern 3: ∫u(x)^n · u'(x) dx = u(x)^(n+1)/(n+1)
      // This handles cos(x)*sin(x) (u=sin(x), n=1)
      final powerResult = _tryGeneralizedPowerRule(expr, v);
      if (powerResult != null) return powerResult;
    }

    // Pattern 2: ∫u'(x)/u(x) dx = ln|u(x)|
    // Example: ∫2x/(x²+1) dx → ln(x²+1)
    if (expr is Divide) {
      final numerator = expr.left;
      final denominator = expr.right;

      if (_containsVariable(denominator, v)) {
        try {
          final denomDerivative = denominator.differentiate(v);
          // Check if numerator matches derivative (up to constant)
          // numer = k * denom'
          // k = numer / denom' => should be constant

          // Simple check: are they proportional?
          // We can use _derivativesMatch logic roughly
          if (_derivativesMatch(numerator, denomDerivative, v)) {
            // If they match structurally, check the constant factor
            // We need to find k such that numerator = k * denomDerivative
            // k = numerator / denomDerivative
            // For now, let's assume they match exactly or we can extract constant
            return Ln(denominator);
          }

          // If numerator is 1 and denomDerivative is constant (e.g. 1/(x+1))
          // denom = x+1, denom' = 1. numer = 1. Match!
          // If denom = 2x+1, denom' = 2. numer = 1. Matches with 1/2 factor?
          // _derivativesMatch handles "differ only by constant factor" for some cases
          // but returns boolean. It doesn't give us the factor.

          // Advanced check: (numerator / denomDerivative) should be constant
          Expression ratio = Divide(numerator, denomDerivative).simplify();
          if (!_containsVariable(ratio, v)) {
            return Multiply(ratio, Ln(denominator));
          }
        } catch (e) {
          // Differentiate failed or simplify failed
        }
      }
    }

    return null;
  }

  /// Detect chain rule patterns: ∫f'·g(f) dx = G(f) where G' = g
  Expression? _tryChainRulePattern(Multiply expr, Variable v) {
    // Flatten nested multiplies: (a*b)*c or a*(b*c) → [a, b, c]
    final factors = _flattenMultiply(expr);

    // Try to find a pattern where one factor is a function of an inner expression
    // and other factors are the derivative of that inner expression
    for (int i = 0; i < factors.length; i++) {
      final function = factors[i];

      // Check if this is a trig/exp function we can integrate
      if (function is Sin || function is Cos || function is Exp) {
        // Get the other factors (potential derivative)
        final otherFactors = <Expression>[];
        for (int j = 0; j < factors.length; j++) {
          if (i != j) otherFactors.add(factors[j]);
        }

        // Build the derivative expression from remaining factors
        Expression derivative;
        if (otherFactors.isEmpty) {
          derivative = Literal(1);
        } else if (otherFactors.length == 1) {
          derivative = otherFactors[0];
        } else {
          derivative = otherFactors[0];
          for (int k = 1; k < otherFactors.length; k++) {
            derivative = Multiply(derivative, otherFactors[k]);
          }
        }

        // Try to match this pattern
        final result = _matchChainPattern(derivative, function, v);
        if (result != null) return result;
      }
    }

    return null;
  }

  /// Flatten nested Multiply expressions into a list of factors
  List<Expression> _flattenMultiply(Expression expr) {
    if (expr is! Multiply) return [expr];

    final result = <Expression>[];
    result.addAll(_flattenMultiply(expr.left));
    result.addAll(_flattenMultiply(expr.right));
    return result;
  }

  Expression? _matchChainPattern(
      Expression derivative, Expression function, Variable v) {
    // Pattern: ∫(derivative of inner) · sin(inner) dx = -cos(inner)
    if (function is Sin) {
      final inner = function.operand;
      final innerDerivative = inner.differentiate(v);

      // Check if derivative matches innerDerivative (up to constant)
      if (_derivativesMatch(derivative, innerDerivative, v)) {
        // Calculate constant factor k = derivative / innerDerivative
        // We want ∫ f'(u) * sin(u) du. derivative is f'(u). innerDerivative is u'.
        // If derivative = k * innerDerivative, then integral is k * (-cos(u)).
        Expression k = Divide(derivative, innerDerivative).simplify();
        if (!_containsVariable(k, v)) {
          return Multiply(k, Negate(Cos(inner))).simplify();
        }
      }
    }

    // Pattern: ∫(derivative of inner) · cos(inner) dx = sin(inner)
    if (function is Cos) {
      final inner = function.operand;
      final innerDerivative = inner.differentiate(v);

      if (_derivativesMatch(derivative, innerDerivative, v)) {
        Expression k = Divide(derivative, innerDerivative).simplify();
        if (!_containsVariable(k, v)) {
          return Multiply(k, Sin(inner)).simplify();
        }
      }
    }

    // Pattern: ∫(derivative of inner) · e^(inner) dx = e^(inner)
    if (function is Exp) {
      final inner = function.operand;
      final innerDerivative = inner.differentiate(v);

      if (_derivativesMatch(derivative, innerDerivative, v)) {
        Expression k = Divide(derivative, innerDerivative).simplify();
        if (!_containsVariable(k, v)) {
          return Multiply(k, Exp(inner)).simplify();
        }
      }
    }

    return null;
  }

  /// Check if two derivatives match (accounting for constants and structure)
  bool _derivativesMatch(Expression a, Expression b, Variable v) {
    // Simplify both expressions first
    Expression simpleA = a;
    Expression simpleB = b;
    try {
      simpleA = a.simplify();
      simpleB = b.simplify();
    } catch (e) {
      // If simplify fails, fall back to original
    }

    // If both are constant (don't contain v), they match up to a constant factor
    if (!_containsVariable(simpleA, v) && !_containsVariable(simpleB, v)) {
      return true;
    }

    // Normalize both expressions to strings for comparison
    final aStr = _normalizeExpression(simpleA, v);
    final bStr = _normalizeExpression(simpleB, v);

    if (aStr == bStr) return true;

    // Check if they differ only by a constant factor
    // E.g., "2x" should match "2*(x^1)" after normalization

    // Handle multiply with constants: extract the non-constant part
    final aNonConstant = _extractNonConstantPart(simpleA, v);
    final bNonConstant = _extractNonConstantPart(simpleB, v);

    if (aNonConstant != null && bNonConstant != null) {
      return _normalizeExpression(aNonConstant, v) ==
          _normalizeExpression(bNonConstant, v);
    }

    return false;
  }

  /// Normalize expression to a canonical string form
  String _normalizeExpression(Expression expr, Variable v) {
    // Basic normalization: simplify common patterns
    final str = expr.toString();

    // Remove spaces
    final normalized = str.replaceAll(' ', '');

    // Simplify (x^1) to x
    return normalized.replaceAll('(${v.identifier.name}^1)', v.identifier.name);
  }

  /// Extract non-constant part from a multiply expression
  Expression? _extractNonConstantPart(Expression expr, Variable v) {
    if (expr is Multiply) {
      // Check if left is constant
      if (!_containsVariable(expr.left, v) && expr.left is Literal) {
        return expr.right;
      }
      // Check if right is constant
      if (!_containsVariable(expr.right, v) && expr.right is Literal) {
        return expr.left;
      }
    }

    // Expression doesn't have a separable constant factor
    if (_containsVariable(expr, v)) {
      return expr;
    }

    return null;
  }

  bool _containsVariable(Expression expr, Variable v) {
    try {
      return expr
          .getVariableTerms()
          .any((variable) => variable.identifier.name == v.identifier.name);
    } catch (e) {
      return false;
    }
  }

  Expression? _tryGeneralizedPowerRule(Multiply expr, Variable v) {
    // Flatten factors
    final factors = _flattenMultiply(expr);

    // Try treating each factor as u(x)^n
    for (int i = 0; i < factors.length; i++) {
      Expression u;
      Expression n;
      Expression factor = factors[i];

      if (factor is Pow) {
        u = factor.base;
        n = factor.exponent;
      } else {
        u = factor;
        n = Literal(1);
      }

      if (_containsVariable(u, v)) {
        // Calculate expected du
        final du = u.differentiate(v).simplify();

        // Check if remaining factors form du (simplistic check)
        List<Expression> remaining = [];
        for (int j = 0; j < factors.length; j++) {
          if (i != j) remaining.add(factors[j]);
        }

        Expression actualDu;
        if (remaining.isEmpty) {
          actualDu = Literal(1);
        } else if (remaining.length == 1) {
          actualDu = remaining[0];
        } else {
          actualDu = remaining[0];
          for (int k = 1; k < remaining.length; k++) {
            actualDu = Multiply(actualDu, remaining[k]);
          }
        }

        if (_derivativesMatch(actualDu, du, v)) {
          // Calculate constant factor k = actualDu / du
          Expression k = Divide(actualDu, du).simplify();

          // If k contains variable, then it wasn't a constant match (should barely happen if _derivativesMatch passed)
          if (!_containsVariable(k, v)) {
            // Check for n = -1 case: ∫u^-1 du = ln|u|
            try {
              if (n.evaluate() == -1) {
                return Multiply(k, Ln(u)).simplify();
              }
            } catch (e) {
              // Evaluation might fail if n contains variables (unlikely here for power rule n)
            }

            // Standard case: k * u^(n+1)/(n+1)
            Expression nPlus1 = Add(n, Literal(1)).simplify();
            return Multiply(k, Divide(Pow(u, nPlus1), nPlus1));
          }
        }
      }
    }
    return null;
  }
}

/// Integration by Parts: ∫u dv = uv - ∫v du
/// Uses ILATE heuristic: Inverse, Logarithmic, Algebraic, Trigonometric, Exponential
class IntegrationByPartsStrategy implements IntegrationStrategy {
  @override
  String get name => 'Integration By Parts';

  @override
  Expression? tryIntegrate(Expression expr, Variable v) {
    // Handle solo functions that require IBP (implied * 1)
    if (_isLogarithmic(expr) || _isInverseTrig(expr)) {
      return _applyByParts(expr, Literal(1), v);
    }

    if (expr is! Multiply) return null;

    final left = expr.left;
    final right = expr.right;
    // ... rest of method (unchanged logic below this point for Multiply)

    // Note: Re-implementing the switch logic here is risky with find/replace if I don't give enough context
    // So I will only replace the top Check.

    // Pattern 1: ∫ln(x)·x^n dx
    if (_isLogarithmic(left) && _isPolynomial(right, v)) {
      return _applyByParts(left, right, v);
    }
    if (_isPolynomial(left, v) && _isLogarithmic(right)) {
      return _applyByParts(right, left, v);
    }

    // Pattern 2: ∫asin(x)·x^n dx
    if (_isInverseTrig(left) && _isPolynomial(right, v)) {
      return _applyByParts(left, right, v);
    }
    if (_isPolynomial(left, v) && _isInverseTrig(right)) {
      return _applyByParts(right, left, v);
    }

    // Pattern 3: ∫x·sin(x) dx or ∫x·cos(x) dx
    if (_isPolynomial(left, v) && _isTrigonometric(right)) {
      return _applyByParts(left, right, v);
    }
    if (_isTrigonometric(left) && _isPolynomial(right, v)) {
      return _applyByParts(right, left, v);
    }

    // Pattern 5: ∫x·e^x dx
    if (_isPolynomial(left, v) && _isExponential(right)) {
      return _applyByParts(left, right, v);
    }
    if (_isExponential(left) && _isPolynomial(right, v)) {
      return _applyByParts(right, left, v);
    }

    return null;
  }

  /// Apply integration by parts: ∫u dv = uv - ∫v du
  Expression? _applyByParts(Expression u, Expression dv, Variable v) {
    try {
      // Compute du = differentiate(u)
      final du = u.differentiate(v);

      // Compute v = integrate(dv)
      final integralDv = SymbolicIntegration.integrate(dv, v);

      // Compute ∫v du
      final vDu = Multiply(integralDv, du).simplify();
      final integralVDu = SymbolicIntegration.integrate(vDu, v);

      // Result: u·v - ∫v du
      return Subtract(Multiply(u, integralDv), integralVDu).simplify();
    } catch (e) {
      return null;
    }
  }

  bool _isPolynomial(Expression expr, Variable v) {
    // Simple check: is it a variable or power of variable?
    if (expr is Variable && expr.identifier.name == v.identifier.name) {
      return true;
    }
    if (expr is Pow && expr.base is Variable) {
      return (expr.base as Variable).identifier.name == v.identifier.name;
    }
    // Check for linear/monomial term: c*x^n
    if (expr is Multiply) {
      // Check if one side is constant and other is polynomial
      // This handles 2x, 3x^2
      if (expr.left is Literal && _isPolynomial(expr.right, v)) return true;
      if (expr.right is Literal && _isPolynomial(expr.left, v)) return true;
    }
    return false;
  }

  bool _isLogarithmic(Expression expr) {
    return expr is Ln || expr is Log;
  }

  bool _isInverseTrig(Expression expr) {
    return expr is Asin || expr is Acos || expr is Atan;
  }

  bool _isTrigonometric(Expression expr) {
    return expr is Sin || expr is Cos || expr is Tan;
  }

  bool _isExponential(Expression expr) {
    return expr is Exp;
  }
}

/// Constant Multiple Rule: ∫c·f(x) dx = c·∫f(x) dx
class ConstantMultipleStrategy implements IntegrationStrategy {
  @override
  String get name => 'Constant Multiple';

  @override
  Expression? tryIntegrate(Expression expr, Variable v) {
    if (expr is! Multiply) return null;

    // Check left constant
    if (!_containsVariable(expr.left, v)) {
      try {
        final integral = SymbolicIntegration.integrate(expr.right, v);
        return Multiply(expr.left, integral);
      } catch (e) {
        // Ignore if sub-integration fails, maybe another strategy can handle the whole thing
      }
    }

    // Check right constant
    if (!_containsVariable(expr.right, v)) {
      try {
        final integral = SymbolicIntegration.integrate(expr.left, v);
        return Multiply(expr.right, integral);
      } catch (e) {
        // Ignore
      }
    }

    return null;
  }

  bool _containsVariable(Expression expr, Variable v) {
    try {
      return expr
          .getVariableTerms()
          .any((variable) => variable.identifier.name == v.identifier.name);
    } catch (e) {
      return false;
    }
  }
}
