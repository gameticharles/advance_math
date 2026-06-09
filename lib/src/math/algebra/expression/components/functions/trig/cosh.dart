part of '../../../expression.dart';

/// Represents the hyperbolic cosine function.
/// Definition: cosh(x) = (e^x + e^-x) / 2
/// Derivative: sinh(x)
/// Integral: (1/a) * sinh(ax + b)
class Cosh extends TrigonometricExpression {
  Cosh(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var eval = operand.evaluate(arg);
    if (eval is Matrix) return eval.cosh();
    if (eval is num || eval is Complex) return cosh(eval);
    return Cosh(eval);
  }

  @override
  Expression differentiate([Variable? v]) {
    return Multiply(Sinh(operand), operand.differentiate(v));
  }

  @override
  Expression integrate() {
    final u = operand;
    final du = u.differentiate().simplify();
    if (du is Literal) {
      return Divide(Sinh(u), du).simplify();
    }
    throw UnimplementedError('Integral of cosh(f(x)) requires substitution.');
  }

  @override
  Expression expand() => this;

  @override
  Expression simplifyBasic() {
    var simplifiedOperand = operand.simplify();
    if (simplifiedOperand is Literal) {
      var val = simplifiedOperand.value;
      if (val is num && val == 0) return Literal(1);
      if (val is num || val is Complex) return Literal(cosh(val));
    }
    if (simplifiedOperand is Negate) {
      return Cosh(simplifiedOperand.operand).simplifyBasic();
    }
    if (simplifiedOperand is Multiply &&
        simplifiedOperand.left is Literal &&
        (simplifiedOperand.left as Literal).value == -1) {
      return Cosh(simplifiedOperand.right).simplifyBasic();
    }
    if (simplifiedOperand != operand) return Cosh(simplifiedOperand);
    return this;
  }

  @override
  String toString() => "cosh(${operand.toString()})";
}
