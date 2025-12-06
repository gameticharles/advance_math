part of '../../../expression.dart';

class Cos extends TrigonometricExpression {
  /// The power to which csc is raised.
  final int n;

  /// Creates an instance of the Csc class with the given [operand] and [n].
  Cos(super.operand, {this.n = 1});

  /// Returns the periodicity of the csc function raised to the power of n.
  double get periodicity {
    if (n % 2 == 0) {
      // If n is even
      return pi / 2;
    } else {
      // If n is odd
      return pi;
    }
  }

  @override
  dynamic evaluate([dynamic arg]) {
    var eval = operand.evaluate(arg);
    if (eval is num) {
      return cos(eval);
    }
    if (eval is Complex) {
      return eval.cos();
    }
    return Cos(eval);
  }

  @override
  Expression differentiate([Variable? v]) {
    // Chain rule: d/dv(cos(f)) = -sin(f) * df/dv
    return Negate(Multiply(operand.differentiate(v), Sin(operand)));
  }

  @override
  Expression integrate() {
    // ∫cos(ax + b) dx = (1/a) * sin(ax + b)
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

    return Multiply(Literal(invA), Sin(operand));
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
    return "cos(${operand.toString()})";
  }
}
