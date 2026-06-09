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

    // Standard Trig
    if (this is Sin) return Sin(subOp);
    if (this is Cos) return Cos(subOp);
    if (this is Tan) return Tan(subOp);
    if (this is Csc) return Csc(subOp);
    if (this is Sec) return Sec(subOp);
    if (this is Cot) return Cot(subOp);

    // Inverse Trig
    if (this is Asin) return Asin(subOp);
    if (this is Acos) return Acos(subOp);
    if (this is Atan) return Atan(subOp);
    if (this is Acsc) return Acsc(subOp);
    if (this is Asec) return Asec(subOp);
    if (this is Acot) return Acot(subOp);

    // Hyperbolic Trig
    if (this is Sinh) return Sinh(subOp);
    if (this is Cosh) return Cosh(subOp);
    if (this is Tanh) return Tanh(subOp);
    if (this is Csch) return Csch(subOp);
    if (this is Sech) return Sech(subOp);
    if (this is Coth) return Coth(subOp);

    // Inverse Hyperbolic Trig
    if (this is Asinh) return Asinh(subOp);
    if (this is Acosh) return Acosh(subOp);
    if (this is Atanh) return Atanh(subOp);
    if (this is Acsch) return Acsch(subOp);
    if (this is Asech) return Asech(subOp);
    if (this is Acoth) return Acoth(subOp);

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
