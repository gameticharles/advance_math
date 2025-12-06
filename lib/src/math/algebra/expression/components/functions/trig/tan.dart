part of '../../../expression.dart';

class Tan extends TrigonometricExpression {
  Tan(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var val = operand.evaluate(arg);
    if (val is Complex) return val.tan();
    return tan(val);
  }

  @override
  Expression differentiate([Variable? v]) {
    // Chain rule: d/dv(tan(f)) = sec^2(f) * df/dv
    return Multiply(operand.differentiate(v), Pow(Sec(operand), Literal(2)));
  }

  @override
  Expression integrate() {
    return Negate(Ln(Abs(Cos(operand))));
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
    return "tan(${operand.toString()})";
  }
}
