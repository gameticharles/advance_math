part of '../../expression.dart';

class Pow extends BinaryOperationsExpression {
  final Expression base;
  final Expression exponent;
  Pow(this.base, this.exponent) : super(base, exponent);

  @override
  dynamic evaluate([dynamic arg]) {
    dynamic leftEval = left.evaluate(arg);
    dynamic rightEval = right.evaluate(arg);

    // Convert num to Literal if the other operand is an Expression
    leftEval = convertToLiteralIfNeeded(leftEval, rightEval);
    rightEval = convertToLiteralIfNeeded(rightEval, leftEval);

    // If both evaluate to numbers, return the sum as a number
    if (leftEval is num && rightEval is num) {
      return pow(leftEval, rightEval);
    }

    // If x is null and either operand contains a Variable, return the simplified version of the expression
    if (arg == null && (_containsVariable(left) || _containsVariable(right))) {
      return simplify();
    }

    // At this point, both operands should be Expression types that support the + operator.
    // If they aren't, there's likely a mismatch or unsupported scenario.
    if (leftEval is Expression && rightEval is Expression) {
      return Pow(leftEval, rightEval).simplify();
    }

    // Default return (should ideally never reach this point)
    throw Exception('Unsupported evaluation scenario in Pow.evaluate');
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
  Expression differentiate() {
    // Case: (x^n)' = n * x^(n-1)
    if (base is Variable && exponent is Literal) {
      var n = exponent.evaluate();
      return Multiply(Literal(n), Pow(base, Literal(n - 1)));
    }

    // Case: (a^x)' where a is a constant
    if (base is Literal && exponent is Variable) {
      var a = base.evaluate();
      return Multiply(Literal(log(a)), this);
    }

    // Placeholder for more complex cases
    return this;
  }

  @override
  Expression integrate() {
    // Integration rules for exponents depend on the specific forms of the base and exponent.
    // For simplicity, we'll handle the case where the base is a variable (e.g., x) and the exponent is a constant.
    // ∫x^n dx = (x^(n+1))/(n+1)
    if (left is Variable && right is Literal) {
      var n = right.evaluate() + 1;
      return Divide(Pow(left, Literal(n)), Literal(n));
    }
    // For other cases, it can be complex.
    // Placeholder for the more general case:
    return this; // Placeholder for actual implementation.
  }

  @override
  Expression simplify() {
    if (exponent is Literal) {
      var exponentValue = exponent.evaluate();
      if (exponentValue == 0) return Literal(1);
      if (exponentValue == 1) return base;
    }

    if (base is Literal && base.evaluate() == 0) {
      if (exponent is Literal && exponent.evaluate() > 0) {
        return Literal(0);
      }
      throw Exception('0 raised to a non-positive power is undefined.');
    }

    return this;
  }

  @override
  Expression expand() {
    // Expansion for Pows can be non-trivial, so for now, we'll keep it simple.
    return this; // Placeholder for advanced expansion.
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    return Pow(
      left.substitute(oldExpr, newExpr),
      right.substitute(oldExpr, newExpr),
    );
  }

  @override
  String toString() {
    return "(${base.toString()}^${exponent.toString()})";
  }
}
