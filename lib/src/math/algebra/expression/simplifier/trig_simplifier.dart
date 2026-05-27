part of '../expression.dart';

/// Extended trigonometric simplifier that applies a comprehensive set of
/// trigonometric identities recursively over the expression tree.
class TrigSimplifier {
  /// Main entry point — applies all trig identities and recurses into children.
  static Expression simplify(Expression expr) {
    // First, recursively simplify children
    expr = _recurse(expr);

    // Then apply top-level identities
    expr = _applyIdentities(expr);

    return expr;
  }

  /// Recursively apply trig simplification to sub-expressions.
  static Expression _recurse(Expression expr) {
    if (expr is Add) {
      return Add(_recurse(expr.left), _recurse(expr.right));
    }
    if (expr is Subtract) {
      return Subtract(_recurse(expr.left), _recurse(expr.right));
    }
    if (expr is Multiply) {
      return Multiply(_recurse(expr.left), _recurse(expr.right));
    }
    if (expr is Divide) {
      return Divide(_recurse(expr.left), _recurse(expr.right));
    }
    if (expr is Pow) {
      return Pow(_recurse(expr.base), _recurse(expr.exponent));
    }
    if (expr is Negate) {
      return Negate(_recurse(expr.operand));
    }
    if (expr is GroupExpression) {
      return _recurse(expr.expression);
    }
    return expr;
  }

  /// Apply all trigonometric identities to a single expression node.
  static Expression _applyIdentities(Expression expr) {
    // =====================================================================
    // Identity 1: sin²(x) + cos²(x) = 1
    // =====================================================================
    if (expr is Add) {
      var left = expr.left;
      var right = expr.right;

      // Check for sin²(x) + cos²(x)
      if (_isSinSquared(left) && _isCosSquared(right)) {
        var arg1 = (left as Pow).left as Sin;
        var arg2 = (right as Pow).left as Cos;
        if (arg1.operand.toString() == arg2.operand.toString()) {
          return Literal(1);
        }
      }
      // Check for cos²(x) + sin²(x)
      if (_isCosSquared(left) && _isSinSquared(right)) {
        var arg1 = (left as Pow).left as Cos;
        var arg2 = (right as Pow).left as Sin;
        if (arg1.operand.toString() == arg2.operand.toString()) {
          return Literal(1);
        }
      }

      // =================================================================
      // Identity 2: 1 + tan²(x) = sec²(x)
      // =================================================================
      if (_isLiteralValue(left, 1) && _isTanSquared(right)) {
        var tanArg = ((right as Pow).left as Tan).operand;
        return Pow(Sec(tanArg), Literal(2));
      }
      if (_isTanSquared(left) && _isLiteralValue(right, 1)) {
        var tanArg = ((left as Pow).left as Tan).operand;
        return Pow(Sec(tanArg), Literal(2));
      }

      // =================================================================
      // Identity 3: 1 + cot²(x) = csc²(x)
      // =================================================================
      if (_isLiteralValue(left, 1) && _isCotSquared(right)) {
        var cotArg = ((right as Pow).left as Cot).operand;
        return Pow(Csc(cotArg), Literal(2));
      }
      if (_isCotSquared(left) && _isLiteralValue(right, 1)) {
        var cotArg = ((left as Pow).left as Cot).operand;
        return Pow(Csc(cotArg), Literal(2));
      }

      // =================================================================
      // Identity 4: Recognize 2*sin(x)*cos(x) = sin(2x)
      // =================================================================
      var doubleAngle = _matchDoubleAngleSin(expr);
      if (doubleAngle != null) return doubleAngle;
    }

    // =====================================================================
    // Identity: sin²(x) - cos²(x) → -cos(2x) equivalent patterns
    // For subtraction: cos²(x) - sin²(x) = cos(2x) (but leave structural)
    // =====================================================================

    return expr;
  }

  /// Try to match 2*sin(x)*cos(x) in an Add expression and return sin(2x).
  static Expression? _matchDoubleAngleSin(Add expr) {
    // Look for patterns like: 2 * sin(x) * cos(x)
    // This can appear as Multiply(Literal(2), Multiply(Sin(x), Cos(x)))
    // or Add(Multiply(Sin(x), Cos(x)), Multiply(Sin(x), Cos(x)))

    // Check if the entire Add is: sin(x)*cos(x) + sin(x)*cos(x) = 2sin(x)cos(x) = sin(2x)
    if (expr.left.toString() == expr.right.toString()) {
      var term = expr.left;
      var sinCos = _extractSinCos(term);
      if (sinCos != null) {
        return Sin(Multiply(Literal(2), sinCos));
      }
    }
    return null;
  }

  /// If expr is sin(x)*cos(x) or cos(x)*sin(x), return x.
  static Expression? _extractSinCos(Expression expr) {
    if (expr is Multiply) {
      if (expr.left is Sin && expr.right is Cos) {
        var sinArg = (expr.left as Sin).operand;
        var cosArg = (expr.right as Cos).operand;
        if (sinArg.toString() == cosArg.toString()) return sinArg;
      }
      if (expr.left is Cos && expr.right is Sin) {
        var cosArg = (expr.left as Cos).operand;
        var sinArg = (expr.right as Sin).operand;
        if (sinArg.toString() == cosArg.toString()) return sinArg;
      }
    }
    return null;
  }

  // ===========================================================================
  // Helper predicates
  // ===========================================================================

  static bool _isSinSquared(Expression expr) {
    return expr is Pow &&
        expr.left is Sin &&
        expr.right is Literal &&
        (expr.right as Literal).value == 2;
  }

  static bool _isCosSquared(Expression expr) {
    return expr is Pow &&
        expr.left is Cos &&
        expr.right is Literal &&
        (expr.right as Literal).value == 2;
  }

  static bool _isTanSquared(Expression expr) {
    return expr is Pow &&
        expr.left is Tan &&
        expr.right is Literal &&
        (expr.right as Literal).value == 2;
  }

  static bool _isCotSquared(Expression expr) {
    return expr is Pow &&
        expr.left is Cot &&
        expr.right is Literal &&
        (expr.right as Literal).value == 2;
  }

  static bool _isLiteralValue(Expression expr, num value) {
    if (expr is Literal) {
      var v = expr.value;
      if (v is num) return v == value;
      if (v is Complex && v.isReal) {
        var r = v.simplify();
        if (r is num) return r == value;
      }
    }
    return false;
  }
}
