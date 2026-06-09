part of '../../../expression.dart';

/// Represents the inverse cosecant (arccsc) function.
/// Derivative: -1 / (|x| * sqrt(x^2 - 1))
class Acsc extends TrigonometricExpression {
  Acsc(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var eval = operand.evaluate(arg);
    if (eval is Matrix) return eval.acsc();
    if (eval is num || eval is Complex) return acsc(eval);
    return Acsc(eval);
  }

  @override
  Expression differentiate([Variable? v]) {
    final sqrtPart =
        Pow(Subtract(Pow(operand, Literal(2)), Literal(1)), Literal(0.5));
    final denom = Multiply(Abs(operand), sqrtPart);
    return Negate(Divide(operand.differentiate(v), denom));
  }

  @override
  Expression integrate() {
    throw UnimplementedError('Integral of acsc is not yet implemented.');
  }

  @override
  Expression expand() => this;

  @override
  Expression simplifyBasic() {
    var simplifiedOperand = operand.simplify();
    if (simplifiedOperand is Negate) {
      return Negate(Acsc(simplifiedOperand.operand)).simplifyBasic();
    }
    if (simplifiedOperand != operand) return Acsc(simplifiedOperand);
    return this;
  }

  @override
  String toString() => "acsc(${operand.toString()})";
}
