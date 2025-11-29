part of '../expression.dart';

/// Orchestrates multiple simplification passes to reduce expressions.
class Simplifier {
  /// Main entry point for simplification.
  static Expression simplify(Expression expression) {
    var current = expression;

    // Pass 1: Basic arithmetic simplification
    current = current.simplifyBasic();

    // Pass 2: Fraction Simplification (GCD)
    current = _fracSimp(current);

    // Pass 3: Trigonometric Simplification
    current = _trigSimp(current);

    // Pass 4: Rational Simplification (Common Denominators)
    current = _ratSimp(current);

    return current;
  }

  /// Fraction Simplification: Reduces fractions by dividing numerator and denominator by their GCD.
  static Expression _fracSimp(Expression expr) {
    if (expr is Divide) {
      // Recursively simplify operands first
      var num = simplify(expr.left);
      var den = simplify(expr.right);

      if (num is Literal && den is Literal) {
        if (num.value is int && den.value is int) {
          if (num.value % den.value == 0) {
            return Literal(num.value / den.value);
          }
          var gcdVal = num.value.gcd(den.value);
          if (gcdVal > 1) {
            return Divide(
                Literal(num.value / gcdVal), Literal(den.value / gcdVal));
          }
        } else {
          return Literal(num.value / den.value);
        }
      }

      return Divide(num, den);
    }
    // Recursively apply to other binary expressions
    if (expr is BinaryOperationsExpression) {
      // This is a bit generic, specific types would be better
      // But for now, we just want to traverse
      // We need a way to reconstruct the expression with new children
      // Since Expression is immutable-ish, we might need a visitor or specific handling
      // For now, let's just handle the top level or rely on the fact that
      // specific classes call simplify() on their children
      return expr;
    }
    return expr;
  }

  /// Trigonometric Simplification: Applies identities like sin^2 + cos^2 = 1.
  static Expression _trigSimp(Expression expr) {
    return TrigSimplifier.simplify(expr);
  }

  /// Rational Simplification: Combines terms with common denominators.
  static Expression _ratSimp(Expression expr) {
    if (expr is Add) {
      var left = simplify(expr.left);
      var right = simplify(expr.right);

      if (left is Divide && right is Divide) {
        if (left.right.toString() == right.right.toString()) {
          // Same denominator: (a/c) + (b/c) = (a+b)/c
          return Divide(Add(left.left, right.left), left.right).simplify();
        }
      }
      // Handle (a/b) + c = (a + b*c) / b
      if (left is Divide && right is! Divide) {
        return Divide(Add(left.left, Multiply(right, left.right)), left.right)
            .simplify();
      }
      if (left is! Divide && right is Divide) {
        return Divide(Add(Multiply(left, right.right), right.left), right.right)
            .simplify();
      }

      return Add(left, right).simplifyBasic();
    }
    // Similar logic for Subtract
    if (expr is Subtract) {
      var left = simplify(expr.left);
      var right = simplify(expr.right);

      if (left is Divide && right is Divide) {
        if (left.right.toString() == right.right.toString()) {
          return Divide(Subtract(left.left, right.left), left.right).simplify();
        }
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

      return Subtract(left, right).simplifyBasic();
    }
    return expr;
  }
}
