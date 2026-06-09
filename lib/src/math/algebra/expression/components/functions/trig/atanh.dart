part of '../../../expression.dart';

/// Represents the inverse hyperbolic tangent function.
/// Derivative: 1 / (1 - x^2)
class Atanh extends TrigonometricExpression {
  Atanh(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var eval = operand.evaluate(arg);
    if (eval is Matrix) return eval.atanh();
    if (eval is num || eval is Complex) return atanh(eval);
    return Atanh(eval);
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
      Multiply(u, Atanh(u)),
      Multiply(Literal(0.5), Ln(Subtract(Literal(1), Pow(u, Literal(2))))),
    );
    if (du is Literal) return Divide(integral, du).simplify();
    throw UnimplementedError('Integral of atanh(f(x)) requires substitution.');
  }

  @override
  Expression expand() => this;

  @override
  Expression simplifyBasic() {
    var simplifiedOperand = operand.simplify();
    if (simplifiedOperand is Negate) {
      return Negate(Atanh(simplifiedOperand.operand)).simplifyBasic();
    }
    if (simplifiedOperand != operand) return Atanh(simplifiedOperand);
    return this;
  }

  @override
  String toString() => "atanh(${operand.toString()})";
}
