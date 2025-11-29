part of '../../../expression.dart';

class Sin extends TrigonometricExpression {
  Sin(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var eval = operand.evaluate(arg);
    if (eval is num) {
      return sin(eval);
    }
    return Sin(eval);
  }

  @override
  Expression differentiate([Variable? v]) {
    // Chain rule: d/dv(sin(f)) = cos(f) * df/dv
    return Multiply(operand.differentiate(v), Cos(operand));
  }

  @override
  Expression integrate() {
    return Negate(Cos(operand));
  }

  @override
  Expression expand() {
    return this;
  }

  @override
  Expression simplifyBasic() {
    return this;
  }

  @override
  String toString() {
    return "sin(${operand.toString()})";
  }
}
