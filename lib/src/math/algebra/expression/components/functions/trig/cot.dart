part of '../../../expression.dart';

class Cot extends TrigonometricExpression {
  Cot(super.operand);

  @override
  num evaluate([dynamic arg]) {
    // Check if tan(x) is zero because cot(x) is undefined at these points.
    var tangentValue = tan(operand.evaluate(arg));
    if (tangentValue == 0) {
      throw Exception(
          'Cotangent is undefined for operand: ${operand.evaluate(arg)}');
    }
    return 1 / tangentValue;
  }

  @override
  Expression differentiate() {
    // Derivative of cot(x) is -csc^2(x)
    return Multiply(Literal(-1), Pow(Csc(operand), Literal(2)));
  }

  @override
  Expression integrate() {
    // Integral of cot(x) is ln|sin(x)|
    return Ln(Abs(Sin(operand)));
  }

  @override
  Expression simplify() {
    // If the operand is a literal, evaluate and return a new Literal with the csc value.
    if (operand is Literal) {
      return Literal(evaluate());
    }
    return this;
  }

  @override
  Expression expand() {
    return this;
  }

  @override
  String toString() {
    return "cot(${operand.toString()})";
  }
}
