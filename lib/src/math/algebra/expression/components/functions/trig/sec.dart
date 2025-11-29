part of '../../../expression.dart';

class Sec extends TrigonometricExpression {
  Sec(super.operand);

  @override
  num evaluate([dynamic arg]) {
    return 1 / cos(operand.evaluate(arg));
  }

  @override
  Expression differentiate([Variable? v]) {
    // Chain rule: d/dv(sec(f)) = sec(f)*tan(f) * df/dv
    return Multiply(
        Multiply(Sec(operand), Tan(operand)), operand.differentiate(v));
  }

  @override
  Expression integrate() {
    // Return the natural logarithm of the absolute value of (sec(x) + tan(x))
    return Ln(Abs(Add(Sec(operand), Tan(operand))));
  }

  @override
  Expression expand() {
    return this;
  }

  @override
  Expression simplify() {
    return this;
  }

  @override
  String toString() {
    return "sec(${operand.toString()})";
  }
}
