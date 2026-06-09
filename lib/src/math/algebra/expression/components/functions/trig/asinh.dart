part of '../../../expression.dart';

/// Represents the inverse hyperbolic sine function.
/// Derivative: 1 / sqrt(x^2 + 1)
class Asinh extends TrigonometricExpression {
  Asinh(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var eval = operand.evaluate(arg);
    if (eval is Matrix) return eval.asinh();
    if (eval is num || eval is Complex) return asinh(eval);
    return Asinh(eval);
  }

  @override
  Expression differentiate([Variable? v]) {
    final sqrtPart =
        Pow(Add(Pow(operand, Literal(2)), Literal(1)), Literal(0.5));
    return Divide(operand.differentiate(v), sqrtPart);
  }

  @override
  Expression integrate() {
    final u = operand;
    final du = u.differentiate().simplify();
    Expression integral = Subtract(
      Multiply(u, Asinh(u)),
      Pow(Add(Pow(u, Literal(2)), Literal(1)), Literal(0.5)),
    );
    if (du is Literal) return Divide(integral, du).simplify();
    throw UnimplementedError('Integral of asinh(f(x)) requires substitution.');
  }

  @override
  Expression expand() => this;

  @override
  Expression simplifyBasic() {
    var simplifiedOperand = operand.simplify();
    if (simplifiedOperand is Negate) {
      return Negate(Asinh(simplifiedOperand.operand)).simplifyBasic();
    }
    if (simplifiedOperand != operand) return Asinh(simplifiedOperand);
    return this;
  }

  @override
  String toString() => "asinh(${operand.toString()})";
}
