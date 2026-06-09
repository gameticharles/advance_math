part of '../../../expression.dart';

/// Represents the inverse hyperbolic cotangent function.
/// Derivative: 1 / (1 - x^2)
class Acoth extends TrigonometricExpression {
  Acoth(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var eval = operand.evaluate(arg);
    if (eval is Matrix) return eval.acoth();
    if (eval is num || eval is Complex) return acoth(eval);
    return Acoth(eval);
  }

  @override
  Expression differentiate([Variable? v]) {
    final denom = Subtract(Literal(1), Pow(operand, Literal(2)));
    return Divide(operand.differentiate(v), denom);
  }

  @override
  Expression integrate() {
    final u = operand;
    final du = u.differentiate().simplify();
    Expression integral = Add(
      Multiply(u, Acoth(u)),
      Multiply(Literal(0.5), Ln(Subtract(Pow(u, Literal(2)), Literal(1)))),
    );
    if (du is Literal) return Divide(integral, du).simplify();
    throw UnimplementedError('Integral of acoth(f(x)) requires substitution.');
  }

  @override
  Expression expand() => this;

  @override
  Expression simplifyBasic() {
    var simplifiedOperand = operand.simplify();
    if (simplifiedOperand is Negate) {
      return Negate(Acoth(simplifiedOperand.operand)).simplifyBasic();
    }
    if (simplifiedOperand != operand) return Acoth(simplifiedOperand);
    return this;
  }

  @override
  String toString() => "acoth(${operand.toString()})";
}
