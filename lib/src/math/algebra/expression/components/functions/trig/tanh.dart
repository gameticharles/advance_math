part of '../../../expression.dart';

/// Represents the hyperbolic tangent function.
/// Derivative: sech^2(x)
/// Integral: (1/a) * ln(cosh(ax + b))
class Tanh extends TrigonometricExpression {
  Tanh(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var eval = operand.evaluate(arg);
    if (eval is Matrix) return eval.tanh();
    if (eval is num || eval is Complex) return tanh(eval);
    return Tanh(eval);
  }

  @override
  Expression differentiate([Variable? v]) {
    return Multiply(Pow(Sech(operand), Literal(2)), operand.differentiate(v));
  }

  @override
  Expression integrate() {
    final u = operand;
    final du = u.differentiate().simplify();
    if (du is Literal) {
      return Divide(Ln(Cosh(u)), du).simplify();
    }
    throw UnimplementedError('Integral of tanh(f(x)) requires substitution.');
  }

  @override
  Expression expand() => this;

  @override
  Expression simplifyBasic() {
    var simplifiedOperand = operand.simplify();
    if (simplifiedOperand is Literal) {
      var val = simplifiedOperand.value;
      if (val is num && val == 0) return Literal(0);
      if (val is num || val is Complex) return Literal(tanh(val));
    }
    if (simplifiedOperand is Negate) {
      return Negate(Tanh(simplifiedOperand.operand)).simplifyBasic();
    }
    if (simplifiedOperand != operand) return Tanh(simplifiedOperand);
    return this;
  }

  @override
  String toString() => "tanh(${operand.toString()})";
}
