part of '../../../expression.dart';

class Sec extends TrigonometricExpression {
  Sec(super.operand);

  @override
  num evaluate([dynamic arg]) {
    return 1 / cos(operand.evaluate(arg));
  }

  @override
  Expression differentiate() {
    return Multiply(Sec(operand), Tan(operand));
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
