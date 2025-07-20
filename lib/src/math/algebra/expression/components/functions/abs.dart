part of '../../expression.dart';

class Abs extends Expression {
  final Expression operand;

  Abs(this.operand);

  @override
  num evaluate([dynamic arg]) {
    return operand.evaluate(arg).abs();
  }

  @override
  Expression differentiate() {
    // The derivative of the absolute value function is a piecewise function.
    // For this simple implementation, we'll return a `Literal` indicating it's not directly differentiable.
    // In practice, you'd handle this with a conditional representation or using signum/sgn function.
    throw Exception('Absolute value is not directly differentiable.');
  }

  @override
  Expression integrate() {
    // Integration of absolute value can be complex and often involves breaking it down based on its zero points.
    // For this simple implementation, we'll throw an error.
    throw UnimplementedError(
        "Integration for AbsoluteValue not implemented yet.");
  }

  @override
  Expression simplify() {
    // If the operand is a literal, evaluate and return a new Literal with the absolute value.
    if (operand is Literal) {
      return Literal(operand.evaluate().abs());
    }
    return this; // More complex simplification can be added later.
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
    return "|${operand.toString()}|";
  }
}
