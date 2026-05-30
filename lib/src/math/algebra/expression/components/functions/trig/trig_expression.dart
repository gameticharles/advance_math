part of '../../../expression.dart';

abstract class TrigonometricExpression extends Expression {
  final Expression operand;

  TrigonometricExpression(this.operand);

  @override
  Set<Variable> getVariableTerms() {
    return {...operand.getVariableTerms()};
  }

  @override
  bool isIndeterminate(dynamic x) {
    try {
      final val = evaluate(x);
      if (val is Complex) return val.isNaN;
      if (val is num) return val.isNaN;
      return false;
    } catch (_) {
      return true; // If evaluation fails, it might be indeterminate
    }
  }

  @override
  bool isInfinity(dynamic x) {
    return evaluate(x).isInfinite;
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    if (this == oldExpr) return newExpr;
    final subOp = operand.substitute(oldExpr, newExpr);
    if (this is Sin) return Sin(subOp);
    if (this is Cos) return Cos(subOp);
    if (this is Tan) return Tan(subOp);
    if (this is Sec) return Sec(subOp);
    if (this is Csc) return Csc(subOp);
    if (this is Cot) return Cot(subOp);
    if (this is Asin) return Asin(subOp);
    if (this is Acos) return Acos(subOp);
    if (this is Atan) return Atan(subOp);
    return this;
  }

  @override
  bool isPoly([bool strict = false]) => false;

  @override
  int depth() {
    return 1 + operand.depth();
  }

  @override
  int size() {
    return 1 + operand.size();
  }
}
