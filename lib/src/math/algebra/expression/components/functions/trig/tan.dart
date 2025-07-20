part of '../../../expression.dart';

class Tan extends TrigonometricExpression {
  Tan(super.operand);

  @override
  num evaluate([dynamic arg]) {
    return tan(operand.evaluate(arg));
  }

  @override
  Expression differentiate() {
    return Multiply(operand.differentiate(), Pow(Sec(operand), Literal(2)));
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
