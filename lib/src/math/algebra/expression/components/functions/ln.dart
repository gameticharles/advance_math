part of '../../expression.dart';

class Ln extends Expression {
  final Expression operand;

  Ln(this.operand);

  @override
  num evaluate([dynamic arg]) {
    return log(operand.evaluate(arg));
  }

  @override
  Expression differentiate([Variable? v]) {
    // Chain rule: d/dv[ln(f(x))] = f'(x) / f(x)
    return Divide(operand.differentiate(v), operand);
  }

  @override
  Expression integrate() {
    // The integral of ln(x) is x*ln(x) - x.
    // But the integral of ln(f(x)) in general can be more complex.
    // For this simple implementation, we'll only handle the case of ln(x).
    if (operand is Variable) {
      return Subtract(Multiply(operand, this), operand);
    }
    throw UnimplementedError(
        "Integration for Ln of this operand not implemented yet.");
  }

  @override
  Expression simplify() {
    // If the operand is a literal, evaluate and return a new Literal with the ln value.
    if (operand is Literal) {
      return Literal(evaluate());
    }
    // More complex simplification, like ln(e) = 1, can be added later.
    return this;
  }

  @override
  Expression expand() {
    return this;
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
    return Abs(operand.substitute(oldExpr, newExpr));
  }

  @override
  bool isIndeterminate(num x) {
    throw UnimplementedError();
  }

  @override
  bool isInfinity(num x) {
    throw UnimplementedError();
  }

  @override
  bool isPoly([bool strict = false]) => false;

  // Calculating the depth
  @override
  int depth() {
    return 1 + operand.depth();
  }

  // Calculating the size
  @override
  int size() {
    return 1 + operand.size();
  }

  @override
  String toString() {
    return "ln(${operand.toString()})";
  }
}
