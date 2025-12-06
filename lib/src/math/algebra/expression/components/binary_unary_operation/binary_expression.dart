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
      case '%':
        // Modulo operator
        final leftVal = left.evaluate(arg);
        final rightVal = right.evaluate(arg);
        if (leftVal is num && rightVal is num) {
          return leftVal % rightVal;
        }
        // For non-numeric types, delegate to Modulo expression
        return Modulo(left, right).evaluate(arg);
      case ':':
        // Check for assignment: vector[index]:value
        if (left is IndexExpression) {
          var idxExpr = left as IndexExpression;
          var obj = idxExpr.object.evaluate(arg);
          var idx = idxExpr.index.evaluate(arg);

          if (idx is Complex && idx.isReal && idx.imaginary == 0) {
            idx = idx.real;
          }
          if (idx is num && idx == idx.toInt()) {
            idx = idx.toInt();
          }

          var val = right.evaluate(arg);

          if (obj is List && idx is int) {
            if (idx < 0) idx += obj.length;
            if (idx >= 0 && idx < obj.length) {
              obj[idx] = val;
              return obj;
            }
          }
        }
        var start = left.evaluate(arg);
        var end = right.evaluate(arg);

        if (start is Complex && start.isReal && start.imaginary == 0) {
          start = start.real;
        }
        if (end is Complex && end.isReal && end.imaginary == 0) {
          end = end.real;
        }

        return Range(start, end);
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
  bool isIndeterminate(dynamic x) {
    throw UnimplementedError();
  }

  @override
  bool isInfinity(dynamic x) {
    throw UnimplementedError();
  }

  @override
  bool isPoly([bool strict = false]) {
    switch (operator) {
      case '+':
      case '-':
      case '*':
        return left.isPoly(strict) && right.isPoly(strict);
      case '/':
        // Division is only allowed if dividing by a constant (or if strict is false?)
        // Nerdamer says: isPoly(51/x) -> false
        // isPoly(x^2+1/x) -> false
        // So division by variable makes it not a poly.
        // Division by constant is fine: x/2 = 0.5*x -> poly
        if (right is Literal) return left.isPoly(strict);
        // If strict is false, maybe we allow more? But definition of poly usually excludes division by variable.
        return false;
      case '^':
        // Base must be poly
        if (!left.isPoly(strict)) return false;
        // Exponent must be non-negative integer
        if (right is Literal) {
          final val = (right as Literal).value;
          if (val is int && val >= 0) return true;
          if (val is double && val == val.toInt() && val >= 0) return true;
        }
        return false;
      default:
        return false;
    }
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
