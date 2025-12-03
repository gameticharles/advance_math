part of '../../expression.dart';

class UnaryExpression extends Expression {
  final String operator;

  final Expression operand;

  final bool prefix;

  UnaryExpression(this.operator, this.operand, {this.prefix = true});

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
      case '%':
        if (!prefix) {
          if (operandVal is num) {
            return operandVal * 0.01;
          }
          // If operand is expression, return Multiply(operand, 0.01)?
          // But evaluate returns dynamic (value).
          // If operandVal is not num, we can't multiply.
          // Unless we return an Expression?
          // evaluate() usually returns num or Complex.
          throw Exception('Percentage is only valid for numbers.');
        }
        throw Exception('Percentage operator % must be a suffix.');
      default:
        throw Exception('Unknown unary operator: $operator');
    }
  }

  @override
  Expression differentiate([Variable? v]) {
    // Differentiation logic for unary operations.
    switch (operator) {
      case '-':
        return UnaryExpression('-', operand.differentiate(v));
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
  bool isPoly([bool strict = false]) {
    if (operator == '-' || operator == '+') {
      return operand.isPoly(strict);
    }
    return false;
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
  Expression simplifyBasic() {
    var simplifiedOperand = operand.simplifyBasic();

    if (operator == '-' && prefix) {
      if (simplifiedOperand is Literal) {
        var val = simplifiedOperand.value;
        if (val is num) {
          return Literal(-val);
        }
      }
    }
    if (operator == '+' && prefix) {
      return simplifiedOperand;
    }

    if (simplifiedOperand != operand) {
      return UnaryExpression(operator, simplifiedOperand, prefix: prefix);
    }
    return this;
  }

  @override
  Expression simplify() {
    return simplifyBasic();
  }

  @override
  String toString() {
    if (prefix) {
      // Avoid parens if operand is simple
      if (operand is Literal || operand is Variable) {
        return "$operator$operand";
      }
      return "$operator($operand)";
    }
    return "$operand$operator";
  }
}
