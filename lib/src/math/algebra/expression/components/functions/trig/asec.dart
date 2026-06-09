part of '../../../expression.dart';

/// Represents the inverse secant (arcsec) function.
/// Derivative: 1 / (|x| * sqrt(x^2 - 1))
class Asec extends TrigonometricExpression {
  Asec(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var eval = operand.evaluate(arg);
    if (eval is Matrix) return eval.asec();
    if (eval is num || eval is Complex) return asec(eval);
    return Asec(eval);
  }

  @override
  Expression differentiate([Variable? v]) {
    final sqrtPart =
        Pow(Subtract(Pow(operand, Literal(2)), Literal(1)), Literal(0.5));
    final denom = Multiply(Abs(operand), sqrtPart);
    return Divide(operand.differentiate(v), denom);
  }

  @override
  Expression integrate() {
    throw UnimplementedError('Integral of asec is not yet implemented.');
  }

  @override
  Expression expand() => this;

  @override
  Expression simplifyBasic() {
    var simplifiedOperand = operand.simplify();
    if (simplifiedOperand != operand) return Asec(simplifiedOperand);
    return this;
  }

  @override
  String toString() => "asec(${operand.toString()})";
}
