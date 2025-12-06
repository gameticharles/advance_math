part of '../../../expression.dart';

class Tan extends TrigonometricExpression {
  Tan(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var val = operand.evaluate(arg);
    if (val is Complex) return val.tan();
    return tan(val);
  }

  @override
  Expression differentiate([Variable? v]) {
    // Chain rule: d/dv(tan(f)) = sec^2(f) * df/dv
    return Multiply(operand.differentiate(v), Pow(Sec(operand), Literal(2)));
  }

  @override
  Expression integrate() {
    // ∫tan(ax + b) dx = -(1/a) * ln|cos(ax + b)|
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

    return Multiply(Literal(negInvA), Ln(Abs(Cos(operand))));
  }

  @override
  Expression expand() {
    return this;
  }

  @override
  Expression simplify() {
    return this;
  }

  @override
  String toString() {
    return "tan(${operand.toString()})";
  }
}
