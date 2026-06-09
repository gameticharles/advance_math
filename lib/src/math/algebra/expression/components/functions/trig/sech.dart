part of '../../../expression.dart';

/// Represents the hyperbolic secant function.
/// Derivative: -sech(x) * tanh(x)
/// Integral: (1/a) * atan(sinh(ax + b))  [Gudermannian function]
class Sech extends TrigonometricExpression {
  Sech(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var eval = operand.evaluate(arg);
    if (eval is Matrix) return eval.sech();
    if (eval is num || eval is Complex) return sech(eval);
    return Sech(eval);
  }

  @override
  Expression differentiate([Variable? v]) {
    return Negate(Multiply(
        Multiply(Sech(operand), Tanh(operand)), operand.differentiate(v)));
  }

  @override
  Expression integrate() {
    final u = operand;
    final du = u.differentiate().simplify();
    if (du is Literal) {
      return Divide(Atan(Sinh(u)), du).simplify();
    }
    throw UnimplementedError('Integral of sech(f(x)) requires substitution.');
  }

  @override
  Expression expand() => this;

  @override
  Expression simplifyBasic() {
    var simplifiedOperand = operand.simplify();
    if (simplifiedOperand is Literal) {
      var val = simplifiedOperand.value;
      if (val is num && val == 0) return Literal(1);
      if (val is num || val is Complex) return Literal(sech(val));
    }
    if (simplifiedOperand is Negate) {
      return Sech(simplifiedOperand.operand).simplifyBasic();
    }
    if (simplifiedOperand != operand) return Sech(simplifiedOperand);
    return this;
  }

  @override
  String toString() => "sech(${operand.toString()})";
}
