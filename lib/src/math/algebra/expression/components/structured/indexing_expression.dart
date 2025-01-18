part of '../../expression.dart';

class IndexExpression extends Expression {
  final Expression object;
  final Expression index;

  IndexExpression(this.object, this.index);

  @override
  dynamic evaluate([dynamic arg]) {
    return object.evaluate(arg)[index.evaluate(arg)];
  }

  @override
  Expression differentiate() {
    // The derivative of index is just the negation of the derivative.
    return this;
  }

  @override
  Expression integrate() {
    // The integral of index is the negation of the integral.
    return this;
  }

  @override
  Expression simplify() {
    return this;
  }

  @override
  Expression expand() {
    // Index doesn't expand further, return as-is.
    return this;
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    if (this == oldExpr) {
      return newExpr;
    }
    return IndexExpression(
      object.substitute(oldExpr, newExpr),
      index.substitute(oldExpr, newExpr),
    );
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
    return 1 + max(object.depth(), index.depth());
  }

  @override
  int size() {
    return 1 + object.size() + index.size();
  }

  @override
  Set<Variable> getVariableTerms() {
    return {...object.getVariableTerms(), ...index.getVariableTerms()};
  }

  @override
  String toString() => '${object.toString()}[$index]';
}
