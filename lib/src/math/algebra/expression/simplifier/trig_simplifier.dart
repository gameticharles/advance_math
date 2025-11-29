part of '../expression.dart';

class TrigSimplifier {
  static Expression simplify(Expression expr) {
    // Basic implementation of sin^2(x) + cos^2(x) = 1
    if (expr is Add) {
      var left = expr.left;
      var right = expr.right;

      // Check for sin^2(x) + cos^2(x)
      if (_isSinSquared(left) && _isCosSquared(right)) {
        var arg1 = (left as Pow).left as Sin;
        var arg2 = (right as Pow).left as Cos;
        if (arg1.operand.toString() == arg2.operand.toString()) {
          return Literal(1);
        }
      }
      // Check for cos^2(x) + sin^2(x)
      if (_isCosSquared(left) && _isSinSquared(right)) {
        var arg1 = (left as Pow).left as Cos;
        var arg2 = (right as Pow).left as Sin;
        if (arg1.operand.toString() == arg2.operand.toString()) {
          return Literal(1);
        }
      }
    }
    return expr;
  }

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
}
