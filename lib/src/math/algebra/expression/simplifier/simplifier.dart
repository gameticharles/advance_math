part of '../expression.dart';

/// Orchestrates multiple simplification passes to reduce expressions.
///
/// The simplifier uses a **fixed-point iteration** strategy: it runs all passes
/// in sequence and repeats until the expression stabilizes (no further changes)
/// or a maximum iteration count is reached.
class Simplifier {
  /// Maximum number of fixed-point iterations to prevent infinite loops.
  static const int _maxIterations = 20;

  /// Main entry point for simplification.
  static Expression simplify(Expression expression) {
    // Try constant folding first: if no variables, evaluate directly.
    if (expression.getVariableTerms().isEmpty) {
      try {
        final val = expression.evaluate();

        // Keep symbolic expressions (functions, sqrt, etc.) in symbolic form
        if (_isSymbolicExpression(expression)) {
          // But still try to simplify the structure
        } else {
          if (val is Complex) {
            if (val.imaginary == 0) {
              return Literal(val.real);
            }
            return Literal(val);
          } else {
            return Literal(val);
          }
        }
      } catch (e) {
        // Fall back to structural simplification
      }
    }

    var current = expression;
    String previousForm = '';

    // Fixed-point iteration: keep applying passes until stable
    for (int iteration = 0; iteration < _maxIterations; iteration++) {
      String currentForm = current.toString();
      if (currentForm == previousForm) break; // Converged
      previousForm = currentForm;

      print('--- Iteration $iteration ---');

      // Pass 1: Recursive deep simplification (simplify children first)
      current = _deepSimp(current);
      print('After Pass 1 (Deep): $current, eval: ${current.getVariableTerms().isEmpty ? current.evaluate() : "has var"}');

      // Pass 2: Basic arithmetic simplification
      current = current.simplifyBasic();
      print('After Pass 2 (Basic): $current, eval: ${current.getVariableTerms().isEmpty ? current.evaluate() : "has var"}');

      // Pass 3: Fraction Simplification (GCD)
      current = _fracSimp(current);
      print('After Pass 3 (Frac): $current, eval: ${current.getVariableTerms().isEmpty ? current.evaluate() : "has var"}');

      // Pass 4: Trigonometric Simplification
      current = _trigSimp(current);
      print('After Pass 4 (Trig): $current, eval: ${current.getVariableTerms().isEmpty ? current.evaluate() : "has var"}');

      // Pass 5: Rational Simplification (Common Denominators)
      current = _ratSimp(current);
      print('After Pass 5 (Rat): $current, eval: ${current.getVariableTerms().isEmpty ? current.evaluate() : "has var"}');

      // Pass 6: Logarithmic Simplification
      current = _logSimp(current);
      print('After Pass 6 (Log): $current, eval: ${current.getVariableTerms().isEmpty ? current.evaluate() : "has var"}');

      // Pass 7: Exponential Simplification
      current = _expSimp(current);
      print('After Pass 7 (Exp): $current, eval: ${current.getVariableTerms().isEmpty ? current.evaluate() : "has var"}');

      // Pass 8: Power Algebra
      current = _powSimp(current);
      print('After Pass 8 (Pow): $current, eval: ${current.getVariableTerms().isEmpty ? current.evaluate() : "has var"}');
    }

    return current;
  }

  /// Checks if an expression is symbolic (should be kept in symbolic form).
  /// Uses type-based checking instead of fragile string matching.
  static bool _isSymbolicExpression(Expression expr) {
    if (expr is Ln || expr is Log || expr is Exp || expr is Abs) {
      return true;
    }
    if (expr is TrigonometricExpression) {
      return true;
    }
    if (expr is Sin ||
        expr is Cos ||
        expr is Tan ||
        expr is Sec ||
        expr is Csc ||
        expr is Cot) {
      return true;
    }
    if (expr is Pow) {
      final exp = expr.exponent;
      if (exp is Literal) {
        final val = exp.value;
        if (val is num && val % 1 != 0) return true;
        if (val is Rational && !val.isInteger) return true;
      } else {
        return true;
      }
    }
    if (expr is BinaryOperationsExpression) {
      return _isSymbolicExpression(expr.left) ||
          _isSymbolicExpression(expr.right);
    }
    if (expr is Negate) {
      return _isSymbolicExpression(expr.operand);
    }
    if (expr is GroupExpression) {
      return _isSymbolicExpression(expr.expression);
    }
    if (expr is UnaryExpression) {
      return _isSymbolicExpression(expr.operand);
    }
    return false;
  }

  // ===========================================================================
  // Pass 1: Deep recursive simplification — simplify children before parent
  // ===========================================================================

  /// Recursively walks the expression tree and rebuilds every node with
  /// simplified children.
  static Expression _deepSimp(Expression expr) {
    if (expr is Literal || expr is Variable) return expr;

    if (expr is GroupExpression) {
      return _deepSimp(expr.expression);
    }

    if (expr is Negate) {
      return Negate(_deepSimp(expr.operand)).simplifyBasic();
    }

    if (expr is UnaryExpression) {
      return UnaryExpression(expr.operator, _deepSimp(expr.operand),
              prefix: expr.prefix)
          .simplifyBasic();
    }

    if (expr is Add) {
      return Add(_deepSimp(expr.left), _deepSimp(expr.right));
    }
    if (expr is Subtract) {
      return Subtract(_deepSimp(expr.left), _deepSimp(expr.right));
    }
    if (expr is Multiply) {
      return Multiply(_deepSimp(expr.left), _deepSimp(expr.right));
    }
    if (expr is Divide) {
      return Divide(_deepSimp(expr.left), _deepSimp(expr.right));
    }
    if (expr is Pow) {
      return Pow(_deepSimp(expr.base), _deepSimp(expr.exponent));
    }
    if (expr is Modulo) {
      return Modulo(_deepSimp(expr.left), _deepSimp(expr.right));
    }

    // Functions
    if (expr is Ln) return Ln(_deepSimp(expr.operand));
    if (expr is Exp) return Exp(_deepSimp(expr.operand));
    if (expr is Abs) return Abs(_deepSimp(expr.operand));
    if (expr is Log) return Log(_deepSimp(expr.base), _deepSimp(expr.operand));

    // Trig
    if (expr is Sin) return Sin(_deepSimp(expr.operand));
    if (expr is Cos) return Cos(_deepSimp(expr.operand));
    if (expr is Tan) return Tan(_deepSimp(expr.operand));
    if (expr is Sec) return Sec(_deepSimp(expr.operand));
    if (expr is Csc) return Csc(_deepSimp(expr.operand));
    if (expr is Cot) return Cot(_deepSimp(expr.operand));

    return expr;
  }

  // ===========================================================================
  // Pass 3: Fraction Simplification — GCD and recursive traversal
  // ===========================================================================

  /// Fraction Simplification: Reduces fractions by dividing numerator and
  /// denominator by their GCD. Now traverses the tree recursively.
  static Expression _fracSimp(Expression expr) {
    if (expr is Divide) {
      var leftExpr = _fracSimp(expr.left);
      var rightExpr = _fracSimp(expr.right);

      if (leftExpr is Literal && rightExpr is Literal) {
        final numVal = leftExpr.value;
        final denVal = rightExpr.value;
        if (numVal is int && denVal is int) {
          if (denVal == 0) return Divide(leftExpr, rightExpr);
          // Handle negative signs: normalize to (-a)/b form
          int n = numVal;
          int d = denVal;
          if (d < 0) {
            n = -n;
            d = -d;
          }
          if (n % d == 0) {
            return Literal(n ~/ d);
          }
          var gcdVal = n.gcd(d).abs();
          if (gcdVal > 1) {
            return Divide(Literal(n ~/ gcdVal), Literal(d ~/ gcdVal));
          }
          return Divide(Literal(n), Literal(d));
        } else if (numVal is Rational || denVal is Rational) {
          try {
            var result = Rational(numVal) / Rational(denVal);
            if (result.denominator == BigInt.one) {
              return Literal(result.toInt());
            }
            return Literal(result);
          } catch (e) {
            // Fall back
          }
        } else if (numVal is num && denVal is num) {
          if (denVal == 0) return Divide(leftExpr, rightExpr);
          return Literal(numVal / denVal);
        } else {
          try {
            return Literal(numVal / denVal);
          } catch (e) {
            // Fall back
          }
        }
      }

      // Symbolic cancellation: A / A → 1
      if (leftExpr.toString() == rightExpr.toString()) {
        return Literal(1);
      }

      // Symbolic cancellation: (c * A) / A → c
      if (leftExpr is Multiply) {
        if (leftExpr.right.toString() == rightExpr.toString()) {
          return leftExpr.left;
        }
        if (leftExpr.left.toString() == rightExpr.toString()) {
          return leftExpr.right;
        }
      }

      // Symbolic cancellation: A / (c * A) → 1/c
      if (rightExpr is Multiply) {
        if (rightExpr.right.toString() == leftExpr.toString()) {
          return Divide(Literal(1), rightExpr.left).simplifyBasic();
        }
        if (rightExpr.left.toString() == leftExpr.toString()) {
          return Divide(Literal(1), rightExpr.right).simplifyBasic();
        }
      }

      // Power cancellation: x^a / x^b → x^(a-b)
      if (leftExpr is Pow && rightExpr is Pow) {
        if (leftExpr.base.toString() == rightExpr.base.toString()) {
          return Pow(leftExpr.base,
                  Subtract(leftExpr.exponent, rightExpr.exponent).simplify())
              .simplifyBasic();
        }
      }

      // x^a / x → x^(a-1)
      if (leftExpr is Pow &&
          leftExpr.base.toString() == rightExpr.toString()) {
        return Pow(
                rightExpr, Subtract(leftExpr.exponent, Literal(1)).simplify())
            .simplifyBasic();
      }

      // x / x^a → x^(1-a)
      if (rightExpr is Pow &&
          rightExpr.base.toString() == leftExpr.toString()) {
        return Pow(
                leftExpr, Subtract(Literal(1), rightExpr.exponent).simplify())
            .simplifyBasic();
      }

      // Negative sign normalization: (-a)/b → -(a/b)
      if (leftExpr is Negate) {
        return Negate(Divide(leftExpr.operand, rightExpr)).simplifyBasic();
      }

      return Divide(leftExpr, rightExpr);
    }

    // Recursively apply to binary expressions
    if (expr is Add) {
      return Add(_fracSimp(expr.left), _fracSimp(expr.right));
    }
    if (expr is Subtract) {
      return Subtract(_fracSimp(expr.left), _fracSimp(expr.right));
    }
    if (expr is Multiply) {
      return Multiply(_fracSimp(expr.left), _fracSimp(expr.right));
    }
    if (expr is Pow) {
      return Pow(_fracSimp(expr.base), _fracSimp(expr.exponent));
    }

    return expr;
  }

  // ===========================================================================
  // Pass 4: Trigonometric Simplification
  // ===========================================================================

  /// Trigonometric Simplification: Applies identities like sin^2 + cos^2 = 1.
  static Expression _trigSimp(Expression expr) {
    return TrigSimplifier.simplify(expr);
  }

  // ===========================================================================
  // Pass 5: Rational Simplification — Common Denominators
  // ===========================================================================

  /// Rational Simplification: Combines terms with common denominators and
  /// performs cross-multiplication for different denominators.
  static Expression _ratSimp(Expression expr) {
    if (expr is Add) {
      var left = _ratSimp(expr.left);
      var right = _ratSimp(expr.right);

      if (left is Divide && right is Divide) {
        if (left.right.toString() == right.right.toString()) {
          // Same denominator: (a/c) + (b/c) = (a+b)/c
          return Divide(Add(left.left, right.left), left.right).simplify();
        }
        // Different denominators: (a/b) + (c/d) = (a*d + b*c) / (b*d)
        return Divide(
          Add(Multiply(left.left, right.right),
              Multiply(left.right, right.left)),
          Multiply(left.right, right.right),
        ).simplify();
      }
      // Handle (a/b) + c = (a + b*c) / b
      if (left is Divide && right is! Divide) {
        return Divide(Add(left.left, Multiply(right, left.right)), left.right)
            .simplify();
      }
      if (left is! Divide && right is Divide) {
        return Divide(
                Add(Multiply(left, right.right), right.left), right.right)
            .simplify();
      }

      return Add(left, right);
    }
    // Similar logic for Subtract
    if (expr is Subtract) {
      var left = _ratSimp(expr.left);
      var right = _ratSimp(expr.right);

      if (left is Divide && right is Divide) {
        if (left.right.toString() == right.right.toString()) {
          return Divide(Subtract(left.left, right.left), left.right).simplify();
        }
        // Different denominators: (a/b) - (c/d) = (a*d - b*c) / (b*d)
        return Divide(
          Subtract(Multiply(left.left, right.right),
              Multiply(left.right, right.left)),
          Multiply(left.right, right.right),
        ).simplify();
      }
      if (left is Divide && right is! Divide) {
        return Divide(
                Subtract(left.left, Multiply(right, left.right)), left.right)
            .simplify();
      }
      if (left is! Divide && right is Divide) {
        return Divide(
                Subtract(Multiply(left, right.right), right.left), right.right)
            .simplify();
      }

      return Subtract(left, right);
    }
    return expr;
  }

  // ===========================================================================
  // Pass 6: Logarithmic Simplification
  // ===========================================================================

  /// Logarithmic Simplification: Applies logarithmic identities.
  static Expression _logSimp(Expression expr) {
    // ln(1) = 0
    if (expr is Ln) {
      var operand = expr.operand;
      if (operand is Literal) {
        var val = operand.value;
        if (val is num && val == 1) return Literal(0);
      }
      // ln(Exp(x)) = x
      if (operand is Exp) return operand.operand;
      // ln(e^x) = x
      if (operand is Pow && operand.base is Literal) {
        var bv = (operand.base as Literal).value;
        if (bv is num && (bv - dmath.e).abs() < 1e-15) {
          return operand.exponent;
        }
      }
    }

    // log_a(1) = 0
    if (expr is Log) {
      var operand = expr.operand;
      if (operand is Literal) {
        var val = operand.value;
        if (val is num && val == 1) return Literal(0);
      }
      // log_a(a) = 1
      if (expr.base.toString() == operand.toString()) return Literal(1);
      // log_a(a^x) = x
      if (operand is Pow && operand.base.toString() == expr.base.toString()) {
        return operand.exponent;
      }
    }

    // Recursively apply to children
    if (expr is Add) return Add(_logSimp(expr.left), _logSimp(expr.right));
    if (expr is Subtract) {
      return Subtract(_logSimp(expr.left), _logSimp(expr.right));
    }
    if (expr is Multiply) {
      return Multiply(_logSimp(expr.left), _logSimp(expr.right));
    }
    if (expr is Divide) {
      return Divide(_logSimp(expr.left), _logSimp(expr.right));
    }
    if (expr is Pow) return Pow(_logSimp(expr.base), _logSimp(expr.exponent));

    return expr;
  }

  // ===========================================================================
  // Pass 7: Exponential Simplification
  // ===========================================================================

  /// Exponential Simplification: Applies exponential identities.
  static Expression _expSimp(Expression expr) {
    if (expr is Exp) {
      var operand = expr.operand;

      // e^0 = 1
      if (operand is Literal) {
        var val = operand.value;
        if (val is num && val == 0) return Literal(1);
        if (val is num && val == 1) return Literal(dmath.e);
      }

      // e^ln(x) = x
      if (operand is Ln) return operand.operand;
    }

    // Recursively apply to children
    if (expr is Add) return Add(_expSimp(expr.left), _expSimp(expr.right));
    if (expr is Subtract) {
      return Subtract(_expSimp(expr.left), _expSimp(expr.right));
    }
    if (expr is Multiply) {
      return Multiply(_expSimp(expr.left), _expSimp(expr.right));
    }
    if (expr is Divide) {
      return Divide(_expSimp(expr.left), _expSimp(expr.right));
    }
    if (expr is Pow) return Pow(_expSimp(expr.base), _expSimp(expr.exponent));

    return expr;
  }

  // ===========================================================================
  // Pass 8: Power Algebra
  // ===========================================================================

  /// Power Algebra: Applies power-related identities.
  static Expression _powSimp(Expression expr) {
    if (expr is Pow) {
      var base = expr.base;
      var exponent = expr.exponent;

      // x^0 = 1
      if (exponent is Literal) {
        var ev = exponent.value;
        if (ev is num && ev == 0) return Literal(1);
        if (ev is num && ev == 1) return base;
      }

      // (x^a)^b = x^(a*b)
      if (base is Pow) {
        return Pow(base.base, Multiply(base.exponent, exponent).simplify())
            .simplifyBasic();
      }

      // x^a * x^b is handled in Multiply.simplifyBasic
      // x^a / x^b is handled in _fracSimp
    }

    // Recursively apply to children
    if (expr is Add) return Add(_powSimp(expr.left), _powSimp(expr.right));
    if (expr is Subtract) {
      return Subtract(_powSimp(expr.left), _powSimp(expr.right));
    }
    if (expr is Multiply) {
      return Multiply(_powSimp(expr.left), _powSimp(expr.right));
    }
    if (expr is Divide) {
      return Divide(_powSimp(expr.left), _powSimp(expr.right));
    }

    return expr;
  }
}
