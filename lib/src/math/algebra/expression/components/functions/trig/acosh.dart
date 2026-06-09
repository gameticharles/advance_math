part of '../../../expression.dart';

/// Represents the inverse hyperbolic cosine function.
/// Derivative: 1 / sqrt(x^2 - 1)
class Acosh extends TrigonometricExpression {
  Acosh(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var eval = operand.evaluate(arg);
    if (eval is Matrix) return eval.acosh();
    if (eval is num || eval is Complex) return acosh(eval);
    return Acosh(eval);
  }

  @override
  Expression differentiate([Variable? v]) {
    // Corrected formula: 1 / (sqrt(x-1) * sqrt(x+1))
    final denom = Multiply(
      Pow(Subtract(operand, Literal(1)), Literal(0.5)),
      Pow(Add(operand, Literal(1)), Literal(0.5)),
    );
    return Divide(operand.differentiate(v), denom);
  }

  @override
  Expression integrate() {
    final u = operand;
    final du = u.differentiate().simplify();
    Expression integral = Subtract(
      Multiply(u, Acosh(u)),
      Multiply(
        Pow(Subtract(u, Literal(1)), Literal(0.5)),
        Pow(Add(u, Literal(1)), Literal(0.5)),
      ),
    );
    if (du is Literal) return Divide(integral, du).simplify();
    throw UnimplementedError('Integral of acosh(f(x)) requires substitution.');
  }

  @override
  Expression expand() => this;

  @override
  Expression simplifyBasic() {
    var simplifiedOperand = operand.simplify();
    if (simplifiedOperand != operand) return Acosh(simplifiedOperand);
    return this;
  }

  @override
  String toString() => "acosh(${operand.toString()})";
}
