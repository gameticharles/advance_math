part of '../../expression.dart';

// Helper method to convert num to Literal if the other operand is an Expression
dynamic convertToLiteralIfNeeded(dynamic val, dynamic other) {
  if (val is num && other is Expression) {
    return Literal(val);
  }
  return val;
}

abstract class BinaryOperationsExpression extends Expression {
  final Expression left;
  final Expression right;

  BinaryOperationsExpression(this.left, this.right);

  @override
  Set<Variable> getVariableTerms() {
    return {...left.getVariableTerms(), ...right.getVariableTerms()};
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
    return 1 + max(left.depth(), right.depth());
  }

  @override
  int size() {
    return 1 + left.size() + right.size();
  }
}
