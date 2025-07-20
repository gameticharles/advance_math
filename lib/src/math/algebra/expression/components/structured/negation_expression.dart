part of '../../expression.dart';

class Negate extends Expression {
  final Expression operand;

  Negate(this.operand);

  @override
  num evaluate([dynamic arg]) {
    return -operand.evaluate();
  }

  @override
  Expression differentiate() {
    // The derivative of negation is just the negation of the derivative.
    return Negate(operand.differentiate());
  }

  @override
  Expression integrate() {
    // The integral of negation is the negation of the integral.
    return Negate(operand.integrate());
  }

  @override
  Expression simplify() {
    // If operand is a literal, we can directly negate its value.
    if (operand is Literal) {
      return Literal(-operand.evaluate());
    }
    return this;
  }

  @override
  Expression expand() {
    // Negation doesn't expand further, return as-is.
    return this;
  }

  /// Returns the variables in this expression
  @override
  Set<Variable> getVariableTerms() {
    return operand.getVariableTerms();
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    if (this == oldExpr) {
      return newExpr;
    }
    return Negate(operand.substitute(oldExpr, newExpr));
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
  int depth() {
    return 1 + operand.depth();
  }

  @override
  int size() {
    return 1 + operand.size();
  }

  @override
  String toString() {
    return "-(${operand.toString()})";
  }
}
