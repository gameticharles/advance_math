part of '../../../expression.dart';

class Cot extends TrigonometricExpression {
  Cot(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var val = operand.evaluate(arg);
    dynamic tangentValue;
    if (val is Complex) {
      tangentValue = val.tan();
    } else {
      tangentValue = tan(val);
    }

    if (tangentValue == 0 ||
        (tangentValue is Complex && tangentValue == Complex.zero())) {
      throw Exception('Cotangent is undefined for operand: $val');
    }

    if (tangentValue is Complex) {
      return Complex.one() / tangentValue;
    }
    return 1 / tangentValue;
  }

  @override
  Expression differentiate([Variable? v]) {
    // Chain rule: d/dv(cot(f)) = -csc^2(f) * df/dv
    return Multiply(Multiply(Literal(-1), Pow(Csc(operand), Literal(2))),
        operand.differentiate(v));
  }

  @override
  Expression integrate() {
    // ∫cot(ax + b) dx = (1/a) * ln|sin(ax + b)|
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

    return Multiply(Literal(invA), Ln(Abs(Sin(operand))));
  }

  @override
  Expression simplify() {
    // If the operand is a literal, evaluate and return a new Literal with the csc value.
    if (operand is Literal) {
      return Literal(evaluate());
    }
    return this;
  }

  @override
  Expression expand() {
    return this;
  }

  @override
  String toString() {
    return "cot(${operand.toString()})";
  }
}
