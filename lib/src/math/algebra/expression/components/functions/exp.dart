part of '../../expression.dart';

/// Represents the exponential function e^x in mathematical expressions.
///
/// The exponential function is the inverse of the natural logarithm and is
/// defined as e raised to the power of the operand, where e ≈ 2.718281828.
///
/// Example usage:
/// ```dart
/// final x = Variable('x');
/// final expr = Exp(x); // e^x
/// final result = expr.evaluate({'x': 1}); // ≈ 2.718281828
///
/// // Differentiation: d/dx[e^f(x)] = f'(x) * e^f(x)
/// final derivative = expr.differentiate(); // e^x
///
/// // Integration: ∫e^x dx = e^x + C
/// final integral = expr.integrate(); // e^x
/// ```
class Exp extends Expression {
  /// The operand of the exponential function.
  final Expression operand;

  /// Creates an exponential expression e^operand.
  Exp(this.operand);

  @override
  num evaluate([dynamic arg]) {
    final operandValue = operand.evaluate(arg);
    return math.exp(operandValue);
  }

  @override
  Expression differentiate([Variable? v]) {
    // Chain rule: d/dv[e^f(x)] = f'(x) * e^f(x)
    return Multiply(operand.differentiate(v), this);
  }

  @override
  Expression integrate() {
    // The integral of e^x is e^x.
    // For e^f(x), it's more complex and depends on f(x).
    if (operand is Variable) {
      return this;
    }

    // For linear functions like e^(ax + b), the integral is (1/a) * e^(ax + b)
    if (operand is Add) {
      final add = operand as Add;
      if (add.left is Multiply && add.right is Literal) {
        final multiply = add.left as Multiply;
        if (multiply.left is Literal && multiply.right is Variable) {
          final coefficient = multiply.left as Literal;
          return Divide(this, coefficient);
        }
      }
    }

    // For e^(ax) where a is a constant
    if (operand is Multiply) {
      final multiply = operand as Multiply;
      if (multiply.left is Literal && multiply.right is Variable) {
        final coefficient = multiply.left as Literal;
        return Divide(this, coefficient);
      }
    }

    throw UnimplementedError(
        "Integration for Exp of this operand not implemented yet.");
  }

  @override
  Expression simplify() {
    final simplifiedOperand = operand.simplify();

    // If the operand is a literal, evaluate and return a new Literal.
    if (simplifiedOperand is Literal) {
      final value = simplifiedOperand.value;
      if (value == 0) {
        return Literal(1); // e^0 = 1
      }
      if (value == 1) {
        return Literal(math.e); // e^1 = e
      }
      return Literal(math.exp(value));
    }

    // If the operand is ln(x), then e^ln(x) = x
    if (simplifiedOperand is Ln) {
      return simplifiedOperand.operand;
    }

    // If operand changed during simplification, return new Exp
    if (simplifiedOperand != operand) {
      return Exp(simplifiedOperand);
    }

    return this;
  }

  @override
  bool isPoly([bool strict = false]) => false;

  @override
  Expression expand() {
    return Exp(operand.expand());
  }

  @override
  Set<Variable> getVariableTerms() {
    return operand.getVariableTerms();
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    if (this == oldExpr) {
      return newExpr;
    }
    return Exp(operand.substitute(oldExpr, newExpr));
  }

  @override
  bool isIndeterminate(num x) {
    return operand.isIndeterminate(x);
  }

  @override
  bool isInfinity(num x) {
    final operandValue = operand.evaluate({'x': x});
    return operandValue == double.infinity;
  }

  @override
  int depth() {
    return 1 + operand.depth();
  }

  @override
  int size() {
    return 1 + operand.size();
  }

  @override
  String toString() {
    return "exp(${operand.toString()})";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Exp && operand == other.operand;
  }

  @override
  int get hashCode => operand.hashCode;
}
