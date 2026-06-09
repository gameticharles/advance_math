part of '../../../expression.dart';

/// Represents the hyperbolic cosecant function.
/// Derivative: -csch(x) * coth(x)
/// Integral: (1/a) * ln|tanh((ax+b)/2)|
class Csch extends TrigonometricExpression {
  Csch(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var eval = operand.evaluate(arg);
    if (eval is Matrix) return eval.csch();
    if (eval is num || eval is Complex) return csch(eval);
    return Csch(eval);
  }

  @override
  Expression differentiate([Variable? v]) {
    return Negate(Multiply(
        Multiply(Csch(operand), Coth(operand)), operand.differentiate(v)));
  }

  @override
  Expression integrate() {
    final u = operand;
    final du = u.differentiate().simplify();
    if (du is Literal) {
      return Divide(Ln(Abs(Tanh(Multiply(Literal(0.5), u)))), du).simplify();
    }
    throw UnimplementedError('Integral of csch(f(x)) requires substitution.');
  }

  @override
  Expression expand() => this;

  @override
  Expression simplifyBasic() {
    var simplifiedOperand = operand.simplify();
    if (simplifiedOperand is Literal) {
      var val = simplifiedOperand.value;
      if (val is num || val is Complex) return Literal(csch(val));
    }
    if (simplifiedOperand is Negate) {
      return Negate(Csch(simplifiedOperand.operand)).simplifyBasic();
    }
    if (simplifiedOperand != operand) return Csch(simplifiedOperand);
    return this;
  }

  @override
  String toString() => "csch(${operand.toString()})";
}
