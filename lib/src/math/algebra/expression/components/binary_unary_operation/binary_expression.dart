// LogicalExpression.dart

part of '../../expression.dart';

class BinaryExpression extends Expression {
  final Expression left;
  final Expression right;
  final String operator;

  BinaryExpression(this.operator, this.left, this.right);

  @override
  dynamic evaluate([dynamic arg]) {
    switch (operator) {
      case 'P':
        return permutations(left.evaluate(arg), right.evaluate(arg)).length;
      case 'C':
        return combinations(left.evaluate(arg), right.evaluate(arg)).length;
      case '||':
      case 'or':
        return left.evaluate(arg) || right.evaluate(arg);
      case '&&':
      case 'and':
        return left.evaluate(arg) && right.evaluate(arg);
      case '==':
        return left.evaluate(arg) == right.evaluate(arg);
      case '!=':
        return left.evaluate(arg) != right.evaluate(arg);
      case '>':
        return left.evaluate(arg) > right.evaluate(arg);
      case '>=':
        return left.evaluate(arg) >= right.evaluate(arg);
      case '<':
        return left.evaluate(arg) < right.evaluate(arg);
      case '<=':
        return left.evaluate(arg) <= right.evaluate(arg);
      case '??':
        return left.evaluate(arg) ?? right.evaluate(arg);
      case '<<':
        return left.evaluate(arg) << right.evaluate(arg);
      case '>>':
        return left.evaluate(arg) >> right.evaluate(arg);
      case '|':
        return left.evaluate(arg) | right.evaluate(arg);
      case '&':
        return left.evaluate(arg) & right.evaluate(arg);
      // Parse the actual expression
      case '^':
        return pow(left.evaluate(arg), right.evaluate(arg));
      case '+':
        return left.evaluate(arg) + right.evaluate(arg);
      case '-':
        return left.evaluate(arg) - right.evaluate(arg);
      case '*':
        return left.evaluate(arg) * right.evaluate(arg);
      case '/':
        return left.evaluate(arg) / right.evaluate(arg);
      default:
        throw Exception('Unsupported binary operator: $operator');
    }
  }

  @override
  Expression differentiate([Variable? v]) {
    switch (operator) {
      case '^':
        return Pow(left, right).differentiate(v);
      case '+':
        return Add(left, right).differentiate(v);
      case '-':
        return Subtract(left, right).differentiate(v);
      case '*':
        return Multiply(left, right).differentiate(v);
      case '/':
        return Divide(left, right).differentiate(v);
      default:
        throw Exception(
            'Differentiation with unsupported binary operator: $operator');
    }
  }

  @override
  Expression integrate() {
    switch (operator) {
      case '^':
        return Pow(left, right).integrate();
      case '+':
        return Add(left, right).integrate();
      case '-':
        return Subtract(left, right).integrate();
      case '*':
        return Multiply(left, right).integrate();
      case '/':
        return Divide(left, right).integrate();
      default:
        throw Exception(
            'Integration with unsupported binary operator: $operator');
    }
  }

  @override
  Expression simplify() {
    return this; // Logical expressions generally don't simplify further.
  }

  @override
  Expression expand() {
    return this; // Logical expressions don't expand.
  }

  static int precedenceForOperator(String operator) =>
      ExpressionParser.binaryOperations[operator]!;

  int get precedence => precedenceForOperator(operator);

  @override
  Set<Variable> getVariableTerms() {
    return {...left.getVariableTerms(), ...right.getVariableTerms()};
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    return Add(
        left.substitute(oldExpr, newExpr), right.substitute(oldExpr, newExpr));
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

  @override
  String toString() {
    var l = (left is BinaryExpression &&
            (left as BinaryExpression).precedence < precedence)
        ? '($left)'
        : '$left';
    var r = (right is BinaryExpression &&
            (right as BinaryExpression).precedence < precedence)
        ? '($right)'
        : '$right';
    return '$l $operator $r';
  }
}
