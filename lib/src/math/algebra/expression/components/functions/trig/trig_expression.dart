part of '../../../expression.dart';

abstract class TrigonometricExpression extends Expression {
  final Expression operand;

  TrigonometricExpression(this.operand);

  @override
  Set<Variable> getVariableTerms() {
    return {...operand.getVariableTerms()};
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
}
