part of '../../../expression.dart';

class Sin extends TrigonometricExpression {
  Sin(super.operand);

  @override
  num evaluate([dynamic arg]) {
    return sin(operand.evaluate(arg));
  }

  @override
  Expression differentiate() {
    return Multiply(operand.differentiate(), Cos(operand));
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
  Expression simplify() {
    return this;
  }

  @override
  String toString() {
    return "sin(${operand.toString()})";
  }
}
