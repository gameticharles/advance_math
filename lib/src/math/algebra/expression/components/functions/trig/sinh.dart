part of '../../../expression.dart';

/// Represents the hyperbolic sine function.
/// Definition: sinh(x) = (e^x - e^-x) / 2
/// Derivative: cosh(x)
/// Integral: (1/a) * cosh(ax + b)
class Sinh extends TrigonometricExpression {
  Sinh(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var eval = operand.evaluate(arg);
    if (eval is Matrix) return eval.sinh();
    if (eval is num || eval is Complex) return sinh(eval);
    return Sinh(eval);
  }

  @override
  Expression differentiate([Variable? v]) {
    return Multiply(Cosh(operand), operand.differentiate(v));
  }

  @override
  Expression integrate() {
    final u = operand;
    final du = u.differentiate().simplify();
    if (du is Literal) {
      return Divide(Cosh(u), du).simplify();
    }
    throw UnimplementedError('Integral of sinh(f(x)) requires substitution.');
  }

  @override
  Expression expand() => this;

  @override
  Expression simplifyBasic() {
    var simplifiedOperand = operand.simplify();
    if (simplifiedOperand is Literal) {
      var val = simplifiedOperand.value;
      if (val is num && val == 0) return Literal(0);
      if (val is num || val is Complex) return Literal(sinh(val));
    }
    if (simplifiedOperand is Negate) {
      return Negate(Sinh(simplifiedOperand.operand)).simplifyBasic();
    }
    if (simplifiedOperand is Multiply &&
        simplifiedOperand.left is Literal &&
        (simplifiedOperand.left as Literal).value == -1) {
      return Negate(Sinh(simplifiedOperand.right)).simplifyBasic();
    }
    if (simplifiedOperand != operand) return Sinh(simplifiedOperand);
    return this;
  }

  @override
  String toString() => "sinh(${operand.toString()})";
}
