part of '../../../expression.dart';

abstract class TrigonometricExpression extends Expression {
  final Expression operand;

  TrigonometricExpression(this.operand);

  @override
  Set<Variable> getVariableTerms() {
    return {...operand.getVariableTerms()};
  }

  @override
  bool isIndeterminate(dynamic x) {
    try {
      final val = evaluate(x);
      if (val is Complex) return val.isNaN;
      if (val is num) return val.isNaN;
      return false;
    } catch (_) {
      return true; // If evaluation fails, it might be indeterminate
    }
  }

  @override
  bool isInfinity(dynamic x) {
    return evaluate(x).isInfinite;
  }

  @override
  bool isPoly([bool strict = false]) => false;

  @override
  int depth() {
    return 1 + operand.depth();
  }

  @override
  int size() {
    return 1 + operand.size();
  }
}
