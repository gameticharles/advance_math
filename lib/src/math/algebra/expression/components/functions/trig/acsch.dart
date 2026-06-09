part of '../../../expression.dart';

/// Represents the inverse hyperbolic cosecant function.
/// Derivative: -1 / (|x| * sqrt(x^2 + 1))
class Acsch extends TrigonometricExpression {
  Acsch(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var eval = operand.evaluate(arg);
    if (eval is Matrix) return eval.acsch();
    if (eval is num || eval is Complex) return acsch(eval);
    return Acsch(eval);
  }

  @override
  Expression differentiate([Variable? v]) {
    // Corrected formula: -1 / (|x| * sqrt(1 + x^-2))
    final denom = Multiply(
      Abs(operand),
      Pow(Add(Literal(1), Pow(operand, Literal(-2))), Literal(0.5)),
    );
    return Negate(Divide(operand.differentiate(v), denom));
  }

  @override
  Expression integrate() {
    throw UnimplementedError('Integral of acsch is not yet implemented.');
  }

  @override
  Expression expand() => this;

  @override
  Expression simplifyBasic() {
    var simplifiedOperand = operand.simplify();
    if (simplifiedOperand is Negate) {
      return Negate(Acsch(simplifiedOperand.operand)).simplifyBasic();
    }
    if (simplifiedOperand != operand) return Acsch(simplifiedOperand);
    return this;
  }

  @override
  String toString() => "acsch(${operand.toString()})";
}
