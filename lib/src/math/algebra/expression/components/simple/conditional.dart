part of '../../expression.dart';

class ConditionalExpression extends Expression {
  final Expression condition;
  final Expression ifTrue;
  final Expression ifFalse;

  ConditionalExpression(
      {required this.condition, required this.ifTrue, required this.ifFalse});

  @override
  dynamic evaluate([dynamic arg]) =>
      condition.evaluate(arg) ? ifTrue.evaluate(arg) : ifFalse.evaluate(arg);

  @override
  Expression differentiate([Variable? v]) {
    // The differentiation of a conditional is also conditional.
    return ConditionalExpression(
        condition: condition,
        ifTrue: ifTrue.differentiate(v),
        ifFalse: ifFalse.differentiate(v));
  }

  @override
  Expression integrate() {
    // Integration of a conditional node is also conditional.
    return ConditionalExpression(
        condition: condition,
        ifTrue: ifTrue.integrate(),
        ifFalse: ifFalse.integrate());
  }

  @override
  Expression simplify() {
    // A condition is already in its simplest form
    return this;
  }

  @override
  Expression expand() {
    // A condition is already in its expanded form
    return this;
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    if (this == oldExpr) {
      return newExpr;
    }
    return ConditionalExpression(
      condition: condition.substitute(oldExpr, newExpr),
      ifTrue: ifTrue.substitute(oldExpr, newExpr),
      ifFalse: ifFalse.substitute(oldExpr, newExpr),
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
    return 1 + [condition.depth(), ifTrue.depth(), ifFalse.depth()].reduce(max);
  }

  @override
  int size() {
    return 1 + condition.size() + ifTrue.size() + ifFalse.size();
  }

  @override
  Set<Variable> getVariableTerms() {
    return {
      ...condition.getVariableTerms(),
      ...ifTrue.getVariableTerms(),
      ...ifFalse.getVariableTerms()
    };
  }

  @override
  String toString() => '($condition ? $ifTrue : $ifFalse)';
}
