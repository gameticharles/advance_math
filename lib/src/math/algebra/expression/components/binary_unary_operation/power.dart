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
    if (leftEval is Matrix) {
      int exp = rightEval is Complex
          ? rightEval.real.toInt()
          : (rightEval as num).toInt();
      return (leftEval ^ exp);
    }
    if (rightEval is Matrix) {
      int exp = leftEval is Complex
          ? leftEval.real.toInt()
          : (leftEval as num).toInt();
      return (rightEval ^ exp);
    }
    dynamic result;
    if (leftEval is Complex || rightEval is Complex) {
      result = Complex(leftEval).pow(Complex(rightEval));
    } else if (leftEval is num && rightEval is num) {
      if (leftEval < 0 && rightEval % 1 != 0) {
        result = Complex(leftEval).pow(rightEval);
      } else {
        result = Complex(pow(leftEval, rightEval));
      }
    } else if (arg == null &&
        (_containsVariable(left) || _containsVariable(right))) {
      result = simplify();
    } else if (leftEval is Expression && rightEval is Expression) {
      result = Pow(leftEval, rightEval).simplify();
    } else {
      result = simplify();
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

    // Helper to extract real numeric value from Literal (which may wrap Complex)
    dynamic litVal(Literal lit) {
      final v = lit.value;
      if (v is num) return v;
      if (v is Complex && v.isReal) return v.simplify();
      return v;
    }

    if (simplifiedExponent is Literal) {
      var exponentValue = litVal(simplifiedExponent);
      if (exponentValue == 0) return Literal(1);
      if (exponentValue == 1) return simplifiedBase;
    }

    if (simplifiedBase is Literal) {
      final bv = litVal(simplifiedBase);
      if (bv == 0) {
        if (simplifiedExponent is Literal && litVal(simplifiedExponent) > 0) {
          return Literal(0);
        }
        throw Exception('0 raised to a non-positive power is undefined.');
      }
    }

    if (simplifiedBase is Literal && simplifiedExponent is Literal) {
      var b = litVal(simplifiedBase);
      var e = litVal(simplifiedExponent);
      if (b is num && e is num) {
        if (b < 0 && e % 1 != 0) {
          return Literal(Complex(b).pow(e));
        }
        return Literal(pow(b, e));
      }
    }

    // (x^a)^b = x^(a*b)
    if (simplifiedBase is Pow) {
      var newExponent =
          Multiply(simplifiedBase.exponent, simplifiedExponent).simplifyBasic();
      return Pow(simplifiedBase.base, newExponent).simplifyBasic();
    }

    // 1^x = 1 for any x
    if (simplifiedBase is Literal) {
      final bv = litVal(simplifiedBase);
      if (bv == 1) return Literal(1);
    }

    // (a * b)^n = a^n * b^n for literal integer n
    if (simplifiedBase is Multiply && simplifiedExponent is Literal) {
      var ev = litVal(simplifiedExponent);
      if (ev is int || (ev is num && ev == ev.toInt())) {
        return Multiply(
          Pow(simplifiedBase.left, simplifiedExponent),
          Pow(simplifiedBase.right, simplifiedExponent),
        ).simplifyBasic();
      }
    }

    // (a / b)^n = a^n / b^n for literal integer n
    if (simplifiedBase is Divide && simplifiedExponent is Literal) {
      var ev = litVal(simplifiedExponent);
      if (ev is int || (ev is num && ev == ev.toInt())) {
        return Divide(
          Pow(simplifiedBase.left, simplifiedExponent),
          Pow(simplifiedBase.right, simplifiedExponent),
        ).simplifyBasic();
      }
    }

    return Pow(simplifiedBase, simplifiedExponent);
  }

  @override
  Expression expand() {
    final simplifiedExponent = exponent.simplify();
    if (simplifiedExponent is Literal && simplifiedExponent.value is num) {
      final val = (simplifiedExponent.value as num).toInt();
      if (val > 1 && val <= 10) {
        final expandedBase = base.expand();
        Expression result = expandedBase;
        for (int i = 1; i < val; i++) {
          result = Multiply(result, expandedBase).expand();
        }
        return result.simplify();
      }
    }
    return Pow(base.expand(), exponent.expand());
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
    var expStr = exponent.toString();
    if (expStr.startsWith('-')) {
      expStr = '($expStr)';
    }
    return "$baseStr^$expStr";
  }
}
