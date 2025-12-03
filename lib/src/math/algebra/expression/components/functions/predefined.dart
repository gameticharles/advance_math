part of '../../expression.dart';

class PredefinedFunctionExpression extends Expression {
  final String functionName;
  final Expression operand;

  PredefinedFunctionExpression(this.functionName, this.operand);

  @override
  double evaluate([dynamic arg]) {
    switch (functionName) {
      case 'sqrt':
        return sqrt(operand.evaluate());
      // You can add more predefined functions here.
      default:
        throw Exception('Unsupported function: $functionName');
    }
  }

  @override
  Expression differentiate([Variable? v]) {
    // Placeholder for differentiation of predefined functions.
    throw Exception(
        'Differentiation not implemented for function: $functionName');
  }

  @override
  Expression integrate() {
    // Placeholder for integration of predefined functions.
    throw Exception('Integration not implemented for function: $functionName');
  }

  @override
  Expression simplify() {
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
    return PredefinedFunctionExpression(
      functionName,
      operand.substitute(oldExpr, newExpr),
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
  bool isPoly([bool strict = false]) => false;

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
    return "$functionName(${operand.toString()})";
  }
}
