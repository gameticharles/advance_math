part of '../../expression.dart';

class Modulo extends BinaryOperationsExpression {
  Modulo(super.left, super.right);

  @override
  dynamic evaluate([dynamic arg]) {
    dynamic leftEval = left.evaluate(arg);
    dynamic rightEval = right.evaluate(arg);

    // Convert num to Literal if the other operand is an Expression
    leftEval = convertToLiteralIfNeeded(leftEval, rightEval);
    rightEval = convertToLiteralIfNeeded(rightEval, leftEval);

    // If both evaluate to numbers, return the modulo as a number
    dynamic result;
    if (leftEval is Complex || rightEval is Complex) {
      result = (Complex(leftEval) % Complex(rightEval));
    } else if (leftEval is num && rightEval is num) {
      result = Complex(leftEval % rightEval);
    } else if (arg == null &&
        (_containsVariable(left) || _containsVariable(right))) {
      result = simplify();
    } else if (leftEval is Expression && rightEval is Expression) {
      result = Modulo(leftEval, rightEval).simplify();
    } else {
      throw Exception('Unsupported evaluation scenario in Modulo.evaluate');
    }
    return _normalizeResult(result);
  }

// Helper method to check if an expression contains a Variable
  bool _containsVariable(Expression expr) {
    if (expr is Variable) {
      return true;
    } else if (expr is BinaryOperationsExpression) {
      return _containsVariable(expr.left) || _containsVariable(expr.right);
    }
    return false;
  }

  @override
  Expression differentiate([Variable? v]) {
    // Derivative of modulo is generally not well-defined in continuous calculus context
    // or is 0 piecewise. For now, we return 0 or throw.
    // Let's return 0 assuming step function behavior where defined.
    return Literal(0);
  }

  @override
  Expression integrate() {
    throw UnimplementedError('Integration of modulo is not supported.');
  }

  @override
  Expression simplifyBasic() {
    Expression simplifiedLeft = left.simplify();
    Expression simplifiedRight = right.simplify();

    // If both operands are literals, evaluate and return a new Literal.
    if (simplifiedLeft is Literal && simplifiedRight is Literal) {
      return Literal(simplifiedLeft.evaluate() % simplifiedRight.evaluate());
    }

    return Modulo(simplifiedLeft, simplifiedRight);
  }

  @override
  Expression expand() {
    return this;
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    return Modulo(
      left.substitute(oldExpr, newExpr),
      right.substitute(oldExpr, newExpr),
    );
  }

  @override
  String toString() {
    return "(${left.toString()} % ${right.toString()})";
  }
}
