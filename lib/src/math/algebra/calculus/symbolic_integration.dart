import '../expression/expression.dart';

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
          n = (expr.exponent as Literal).value as num;
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

    return null;
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
    if (expr is Multiply) {
      final result = _tryChainRulePattern(expr, v);
      if (result != null) return result;
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
        return Negate(Cos(inner));
      }
    }

    // Pattern: ∫(derivative of inner) · cos(inner) dx = sin(inner)
    if (function is Cos) {
      final inner = function.operand;
      final innerDerivative = inner.differentiate(v);

      if (_derivativesMatch(derivative, innerDerivative, v)) {
        return Sin(inner);
      }
    }

    // Pattern: ∫(derivative of inner) · e^(inner) dx = e^(inner)
    if (function is Exp) {
      final inner = function.operand;
      final innerDerivative = inner.differentiate(v);

      if (_derivativesMatch(derivative, innerDerivative, v)) {
        return Exp(inner);
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
}

/// Integration by Parts: ∫u dv = uv - ∫v du
/// Uses ILATE heuristic: Inverse, Logarithmic, Algebraic, Trigonometric, Exponential
class IntegrationByPartsStrategy implements IntegrationStrategy {
  @override
  String get name => 'Integration By Parts';

  @override
  Expression? tryIntegrate(Expression expr, Variable v) {
    if (expr is! Multiply) return null;

    final left = expr.left;
    final right = expr.right;

    // Try different u/dv assignments based on ILATE priority

    // Pattern 1: ∫x·sin(x) dx or ∫x·cos(x) dx
    // u = x, dv = sin(x) or cos(x)
    if (_isPolynomial(left, v) && _isTrigonometric(right)) {
      return _applyByParts(left, right, v);
    }

    // Pattern 2: ∫sin(x)·x dx (reverse)
    if (_isTrigonometric(left) && _isPolynomial(right, v)) {
      return _applyByParts(right, left, v);
    }

    // Pattern 3: ∫x·e^x dx
    // u = x, dv = e^x
    if (_isPolynomial(left, v) && _isExponential(right)) {
      return _applyByParts(left, right, v);
    }

    // Pattern 4: ∫e^x·x dx (reverse)
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
      final vDu = Multiply(integralDv, du);
      final integralVDu = SymbolicIntegration.integrate(vDu, v);

      // Result: u·v - ∫v du
      return Subtract(Multiply(u, integralDv), integralVDu);
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
    return false;
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
