part of '../../../expression.dart';

/// Represents the inverse hyperbolic secant function.
/// Derivative: -1 / (x * sqrt(1 - x^2))
class Asech extends TrigonometricExpression {
  Asech(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var eval = operand.evaluate(arg);
    if (eval is Matrix) return eval.asech();
    if (eval is num || eval is Complex) return asech(eval);
    return Asech(eval);
  }

  @override
  Expression differentiate([Variable? v]) {
    final sqrtPart =
        Pow(Subtract(Literal(1), Pow(operand, Literal(2))), Literal(0.5));
    final denom = Multiply(operand, sqrtPart);
    return Negate(Divide(operand.differentiate(v), denom));
  }

  @override
  Expression integrate() {
    throw UnimplementedError('Integral of asech is not yet implemented.');
  }

  @override
  Expression expand() => this;

  @override
  Expression simplifyBasic() {
    var simplifiedOperand = operand.simplify();
    if (simplifiedOperand != operand) return Asech(simplifiedOperand);
    return this;
  }

  @override
  String toString() => "asech(${operand.toString()})";
}
