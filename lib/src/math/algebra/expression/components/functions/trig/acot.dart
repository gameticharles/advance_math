part of '../../../expression.dart';

/// Represents the inverse cotangent (arccot) function.
/// Derivative: -1 / (x^2 + 1)
class Acot extends TrigonometricExpression {
  Acot(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var eval = operand.evaluate(arg);
    if (eval is Matrix) return eval.acot();
    if (eval is num || eval is Complex) return acot(eval);
    return Acot(eval);
  }

  @override
  Expression differentiate([Variable? v]) {
    final denom = Add(Pow(operand, Literal(2)), Literal(1));
    return Negate(Divide(operand.differentiate(v), denom));
  }

  @override
  Expression integrate() {
    throw UnimplementedError('Integral of acot is not yet implemented.');
  }

  @override
  Expression expand() => this;

  @override
  Expression simplifyBasic() {
    var simplifiedOperand = operand.simplify();
    if (simplifiedOperand is Negate) {
      return Negate(Acot(simplifiedOperand.operand)).simplifyBasic();
    }
    if (simplifiedOperand != operand) return Acot(simplifiedOperand);
    return this;
  }

  @override
  String toString() => "acot(${operand.toString()})";
}
