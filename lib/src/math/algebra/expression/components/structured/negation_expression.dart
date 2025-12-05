part of '../../expression.dart';

class Negate extends Expression {
  final Expression operand;

  Negate(this.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    return -operand.evaluate(arg);
  }

  @override
  Expression differentiate([Variable? v]) {
    // The derivative of negation is just the negation of the derivative.
    return Negate(operand.differentiate(v));
  }

  @override
  Expression integrate() {
    // The integral of negation is the negation of the integral.
    return Negate(operand.integrate());
  }

  @override
  Expression simplifyBasic() {
    // Convert Negate(x) to -1 * x and simplify that
    return Multiply(Literal(-1), operand).simplifyBasic();
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
    return operand.isInfinity(x);
  }

  @override
  bool isPoly([bool strict = false]) => operand.isPoly(strict);

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
