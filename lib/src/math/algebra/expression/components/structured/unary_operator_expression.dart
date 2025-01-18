part of '../../expression.dart';

class UnaryExpression extends Expression {
  final String operator;

  final Expression operand;

  final bool prefix;

  UnaryExpression(this.operator, this.operand, {this.prefix = true});

  @override
  @override
  dynamic evaluate([dynamic arg]) {
    final operandVal = operand.evaluate(arg);

    if (!prefix && operator == '!') {
      // Handle factorial
      if (operandVal is int && operandVal >= 0) {
        return factorial(operandVal);
      } else {
        throw Exception('Factorial is only defined for non-negative integers.');
      }
    }

    switch (operator) {
      case '-':
        return -operandVal;
      case '+':
        return operandVal;
      case '!':
        if (prefix) {
          return !operandVal;
        } else {
          // Shouldn't reach here, as factorial is handled above
          throw Exception('Unexpected use of ! operator.');
        }
      case '~':
        if (operandVal is int) {
          return ~operandVal;
        } else {
          throw Exception('Bitwise NOT is only valid for integers.');
        }
      default:
        throw Exception('Unknown unary operator: $operator');
    }
  }

  @override
  Expression differentiate() {
    // Differentiation logic for unary operations.
    switch (operator) {
      case '-':
        return UnaryExpression('-', operand.differentiate());
      // For other unary operators, differentiation might need specific logic or might not be defined.
      default:
        throw Exception(
            'Differentiation for $operator is not implemented yet.');
    }
  }

  @override
  Expression integrate() {
    // Integration logic for unary operations.
    switch (operator) {
      case '-':
        return UnaryExpression('-', operand.integrate());
      // For other unary operators, integration might need specific logic or might not be defined.
      default:
        throw Exception('Integration for $operator is not implemented yet.');
    }
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
    return UnaryExpression(operator, operand.substitute(oldExpr, newExpr),
        prefix: prefix);
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
  int depth() {
    return 1 + operand.depth();
  }

  @override
  int size() {
    return 1 + operand.size();
  }

  @override
  Expression simplify() {
    return this;
  }

  @override
  String toString() {
    return "$operator($operand)";
  }
}
