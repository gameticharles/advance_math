part of '../../../expression.dart';

class Sec extends TrigonometricExpression {
  Sec(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var val = operand.evaluate(arg);
    if (val is Complex) {
      return Complex.one() / val.cos();
    }
    return 1 / cos(val);
  }

  @override
  Expression differentiate([Variable? v]) {
    // Chain rule: d/dv(sec(f)) = sec(f)*tan(f) * df/dv
    return Multiply(
        Multiply(Sec(operand), Tan(operand)), operand.differentiate(v));
  }

  @override
  Expression integrate() {
    // ∫sec(ax + b) dx = (1/a) * ln|sec(ax + b) + tan(ax + b)|
    dynamic a = 1;

    if (operand is Add) {
      if ((operand as Add).left is Multiply) {
        a = ((operand as Add).left as Multiply).left.evaluate();
      }
    } else if (operand is Multiply) {
      a = (operand as Multiply).left.evaluate();
    }

    dynamic invA;
    if (a is Complex) {
      invA = Complex.one() / a;
    } else {
      invA = 1 / a;
    }

    return Multiply(Literal(invA), Ln(Abs(Add(Sec(operand), Tan(operand)))));
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
    return "sec(${operand.toString()})";
  }
}
