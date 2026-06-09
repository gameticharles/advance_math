part of '../../../expression.dart';

/// Represents the hyperbolic cotangent function.
/// Derivative: -csch^2(x)
/// Integral: (1/a) * ln|sinh(ax + b)|
class Coth extends TrigonometricExpression {
  Coth(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var eval = operand.evaluate(arg);
    if (eval is Matrix) return eval.coth();
    if (eval is num || eval is Complex) return coth(eval);
    return Coth(eval);
  }

  @override
  Expression differentiate([Variable? v]) {
    return Negate(
        Multiply(Pow(Csch(operand), Literal(2)), operand.differentiate(v)));
  }

  @override
  Expression integrate() {
    final u = operand;
    final du = u.differentiate().simplify();
    if (du is Literal) {
      return Divide(Ln(Abs(Sinh(u))), du).simplify();
    }
    throw UnimplementedError('Integral of coth(f(x)) requires substitution.');
  }

  @override
  Expression expand() => this;

  @override
  Expression simplifyBasic() {
    var simplifiedOperand = operand.simplify();
    if (simplifiedOperand is Literal) {
      var val = simplifiedOperand.value;
      if (val is num || val is Complex) return Literal(coth(val));
    }
    if (simplifiedOperand is Negate) {
      return Negate(Coth(simplifiedOperand.operand)).simplifyBasic();
    }
    if (simplifiedOperand != operand) return Coth(simplifiedOperand);
    return this;
  }

  @override
  String toString() => "coth(${operand.toString()})";
}
