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
        (left.getVariableTerms().isNotEmpty ||
            right.getVariableTerms().isNotEmpty)) {
      result = simplify();
    } else if (leftEval is Expression && rightEval is Expression) {
      result = Modulo(leftEval, rightEval).simplify();
    } else {
      throw Exception('Unsupported evaluation scenario in Modulo.evaluate');
    }
    return _normalizeResult(result);
  }

  @override
  Expression differentiate([Variable? v]) {
    if (v == null) return Literal(0);

    final leftHasVar = left.getVariableTerms().contains(v);
    final rightHasVar = right.getVariableTerms().contains(v);

    // If no variables, derivative is 0
    if (!leftHasVar && !rightHasVar) return Literal(0);

    // FIX 3: d/dx (f(x) % c) = f'(x) (almost everywhere, ignoring discontinuities)
    if (leftHasVar && !rightHasVar) {
      return left.differentiate(v);
    }

    // d/dx (c % f(x)) is technically -c*f'(x)/f(x)^2 between jumps,
    // but usually treated as 0 or undefined in basic CAS.
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

    // FIX 2: Catch Modulo by Zero during simplification
    if (simplifiedRight is Literal) {
      final rVal = simplifiedRight.evaluate();
      if (rVal is num && rVal == 0) {
        throw Exception('Modulo by zero is undefined.');
      }
    }

    // FIX 4a: 0 % x = 0
    if (simplifiedLeft is Literal) {
      final lVal = simplifiedLeft.evaluate();
      if (lVal is num && lVal == 0) return Literal(0);
    }

    // FIX 4b: x % x = 0
    if (simplifiedLeft == simplifiedRight) {
      return Literal(0);
    }

    // Literal % Literal evaluation
    if (simplifiedLeft is Literal && simplifiedRight is Literal) {
      final lVal = simplifiedLeft.evaluate();
      final rVal = simplifiedRight.evaluate();

      if (lVal is num && rVal is num) {
        return Literal(lVal % rVal);
      }

      //If your Rational class supports the % operator, uncomment this:
      if (lVal is Rational && rVal is Rational) {
        return Literal(lVal % rVal);
      }
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
