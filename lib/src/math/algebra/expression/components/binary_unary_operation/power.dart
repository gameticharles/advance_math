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
    if (leftEval is Complex || rightEval is Complex) {
      return Complex(leftEval).pow(Complex(rightEval)).simplify();
    }
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
    // throw Exception('Unsupported evaluation scenario in Pow.evaluate');
    return simplify();
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
    // Generalized power rule: d/dv(f^g) = f^g * (g' * ln(f) + g * f'/f)
    // But we handle special cases for efficiency:

    // Case 1: (x^n)' where x is the variable and n is constant = n * x^(n-1) * x'
    if (exponent is Literal) {
      var n = exponent.evaluate();
      // Chain rule: n * base^(n-1) * base'
      return Multiply(Multiply(Literal(n), Pow(base, Literal(n - 1))),
          base.differentiate(v));
    }

    // Case 2: (a^x)' where a is constant and x is the variable = a^x * ln(a) * x'
    if (base is Literal) {
      var a = base.evaluate();
      // Chain rule: a^x * ln(a) * exponent'
      return Multiply(
          Multiply(Literal(log(a)), this), exponent.differentiate(v));
    }

    // Case 3: General case (f^g)' = f^g * (g' * ln(f) + g * f'/f)
    // This uses logarithmic differentiation
    return Multiply(
        this,
        Add(Multiply(exponent.differentiate(v), Ln(base)),
            Divide(Multiply(exponent, base.differentiate(v)), base)));
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
  Expression simplifyBasic() {
    var simplifiedBase = base.simplify();
    var simplifiedExponent = exponent.simplify();

    if (simplifiedExponent is Literal) {
      var exponentValue = simplifiedExponent.evaluate();
      if (exponentValue == 0) return Literal(1);
      if (exponentValue == 1) return simplifiedBase;
    }

    if (simplifiedBase is Literal && simplifiedBase.evaluate() == 0) {
      if (simplifiedExponent is Literal && simplifiedExponent.evaluate() > 0) {
        return Literal(0);
      }
      throw Exception('0 raised to a non-positive power is undefined.');
    }

    if (simplifiedBase is Literal && simplifiedExponent is Literal) {
      var b = simplifiedBase.value;
      var e = simplifiedExponent.value;
      if (b is num && e is num) {
        return Literal(pow(b, e));
      }
    }

    // (x^a)^b = x^(a*b)
    if (simplifiedBase is Pow) {
      var newExponent =
          Multiply(simplifiedBase.exponent, simplifiedExponent).simplifyBasic();
      return Pow(simplifiedBase.base, newExponent).simplifyBasic();
    }

    return Pow(simplifiedBase, simplifiedExponent);
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
    var baseStr = base.toString();
    if (base is Add || base is Subtract || base is Multiply || base is Divide) {
      baseStr = '($baseStr)';
    }
    return "$baseStr^${exponent.toString()}";
  }
}
