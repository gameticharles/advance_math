part of '../../expression.dart';

// Helper method to convert num or Complex to Literal if the other operand is an Expression
dynamic convertToLiteralIfNeeded(dynamic val, dynamic other) {
  if ((val is num || val is Complex) && other is Expression) {
    return Literal(val);
  }
  return val;
}

abstract class BinaryOperationsExpression extends Expression {
  final Expression left;
  final Expression right;

  BinaryOperationsExpression(this.left, this.right);

  @override
  Set<Variable> getVariableTerms() {
    return {...left.getVariableTerms(), ...right.getVariableTerms()};
  }

  @override
  bool isIndeterminate(dynamic x) {
    try {
      final val = evaluate(x);
      if (val is Complex) return val.isNaN;
      if (val is num) return val.isNaN;
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  bool isInfinity(dynamic x) {
    try {
      final val = evaluate(x);
      if (val is Complex) return val.isInfinite;
      if (val is num) return val.isInfinite;
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  int depth() {
    return 1 + (max(left.depth(), right.depth()) as num).toInt();
  }

  @override
  int size() {
    return 1 + left.size() + right.size();
  }

  @override
  bool isPoly([bool strict = false]) {
    if (this is Add || this is Subtract || this is Multiply) {
      return left.isPoly(strict) && right.isPoly(strict);
    }
    if (this is Divide) {
      if (right is Literal) return left.isPoly(strict);
      return false;
    }
    if (this is Pow) {
      if (!left.isPoly(strict)) return false;
      if (right is Literal) {
        final val = (right as Literal).value;
        if (val is int && val >= 0) return true;
        if (val is double && val == val.toInt() && val >= 0) return true;
      }
      return false;
    }
    return false;
  }
}
