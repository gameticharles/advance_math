part of '../../../expression.dart';

class Sin extends TrigonometricExpression {
  Sin(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var eval = operand.evaluate(arg);
    if (eval is Matrix) {
      return eval.sin();
    }
    if (eval is num || eval is Complex) {
      return sin(eval);
    }
    return Sin(eval);
  }

  @override
  Expression differentiate([Variable? v]) {
    // Chain rule: d/dv(sin(f)) = cos(f) * df/dv
    return Multiply(operand.differentiate(v), Cos(operand));
  }

  @override
  Expression integrate() {
    // ∫sin(ax + b) dx = -(1/a) * cos(ax + b)
    dynamic a = 1;

    if (operand is Add) {
      if ((operand as Add).left is Multiply) {
        a = ((operand as Add).left as Multiply).left.evaluate();
      }
    } else if (operand is Multiply) {
      a = (operand as Multiply).left.evaluate();
    }

    dynamic negInvA;
    if (a is Complex) {
      negInvA = Complex(-1, 0) / a;
    } else {
      negInvA = -1 / a;
    }

    return Multiply(Literal(negInvA), Cos(operand));
  }

  @override
  Expression expand() {
    return this;
  }

  @override
  Expression simplifyBasic() {
    return this;
  }

  @override
  String toString() {
    return "sin(${operand.toString()})";
  }
}
