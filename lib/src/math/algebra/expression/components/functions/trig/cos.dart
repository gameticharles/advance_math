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
    if (eval is Matrix) {
      return eval.cos();
    }
    if (eval is num || eval is Complex) {
      return cos(eval);
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
    var simplifiedOperand = operand.simplify();

    // Constant folding for known values
    if (simplifiedOperand is Literal) {
      var val = simplifiedOperand.value;
      if (val is num) {
        if (val == 0) return Literal(1); // cos(0) = 1
        // cos(π) = -1
        if ((val - pi).abs() < 1e-15) return Literal(-1);
        // cos(π/2) = 0
        if ((val - pi / 2).abs() < 1e-15) return Literal(0);
        // cos(-π/2) = 0
        if ((val + pi / 2).abs() < 1e-15) return Literal(0);
        // Evaluate numeric literals
        return Literal(cos(val));
      }
    }

    // Parity: cos(-x) = cos(x) (even function)
    if (simplifiedOperand is Negate) {
      return Cos(simplifiedOperand.operand).simplifyBasic();
    }
    if (simplifiedOperand is Multiply &&
        simplifiedOperand.left is Literal &&
        (simplifiedOperand.left as Literal).value == -1) {
      return Cos(simplifiedOperand.right).simplifyBasic();
    }

    if (simplifiedOperand != operand) {
      return Cos(simplifiedOperand);
    }
    return this;
  }

  @override
  String toString() {
    return "cos(${operand.toString()})";
  }
}
