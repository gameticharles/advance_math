part of '../../expression.dart';

/// A wrapper for expressions in parentheses to preserve grouping information.
class GroupExpression extends Expression {
  final Expression expression;

  GroupExpression(this.expression);

  @override
  dynamic evaluate([dynamic arg]) => expression.evaluate(arg);

  @override
  Expression differentiate([Variable? v]) => expression.differentiate(v);

  @override
  Expression integrate() => expression.integrate();

  @override
  Expression simplify() => expression.simplify();

  @override
  Expression simplifyBasic() => expression.simplifyBasic();

  @override
  Expression expand() => expression.expand();

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    if (this == oldExpr) return newExpr;
    return GroupExpression(expression.substitute(oldExpr, newExpr));
  }

  @override
  bool isIndeterminate(dynamic x) => expression.isIndeterminate(x);

  @override
  bool isInfinity(dynamic x) => expression.isInfinity(x);

  @override
  bool isPoly([bool strict = false]) => expression.isPoly(strict);

  @override
  int depth() => expression.depth();

  @override
  int size() => expression.size();

  @override
  Set<Variable> getVariableTerms() => expression.getVariableTerms();

  @override
  String toString() => '($expression)';
}
