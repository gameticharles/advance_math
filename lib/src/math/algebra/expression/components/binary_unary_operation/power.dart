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

    if ((leftEval is num || leftEval is Complex || leftEval is Rational) &&
        (rightEval is num || rightEval is Complex || rightEval is Rational)) {
      return _normalizeResult(Complex(leftEval).pow(Complex(rightEval)));
    }

    dynamic result;
    if (arg == null && (_containsVariable(left) || _containsVariable(right))) {
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

    // Try to simplify square root of a perfect square quadratic polynomial:
    // If exponent is 0.5 (or any fraction representing 1/2)
    if (simplifiedExponent is Literal) {
      final ev = litVal(simplifiedExponent);
      if (ev == 0.5 || ev == Rational(1, 2)) {
        final vars = simplifiedBase.getVariableTerms();
        for (var v in vars) {
          try {
            final coeffMap = _collectPolynomialCoeffs(simplifiedBase, v);
            if (coeffMap != null && coeffMap.keys.every((d) => d <= 2)) {
              final A = coeffMap[2] ?? Literal(0);
              final B = coeffMap[1] ?? Literal(0);
              final C = coeffMap[0] ?? Literal(0);

              // Check if discriminant B^2 - 4*A*C simplifies to 0
              final disc =
                  Subtract(Multiply(B, B), Multiply(Literal(4), Multiply(A, C)))
                      .simplify();
              if (disc is Literal && litVal(disc) == 0) {
                final sqrtA = Pow(A, Literal(0.5)).simplify();
                final term =
                    Add(v, Divide(B, Multiply(Literal(2), A))).simplify();
                if (sqrtA is Literal &&
                    (sqrtA.value == 1 || sqrtA.value == 1.0)) {
                  return term;
                }
                return Multiply(sqrtA, term).simplify();
              }
            }
          } catch (_) {}
        }
      }
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
      final b = litVal(simplifiedBase);
      final e = litVal(simplifiedExponent);

      bool isRealNum(dynamic v) {
        return v is num || v is Rational;
      }

      if (isRealNum(b) && isRealNum(e)) {
        final ratB = Rational(b);
        final ratE = Rational(e);

        if (ratE == Rational(1, 2)) {
          if (ratB.isNegative) {
            // Extract i: sqrt(b) = i * sqrt(-b)
            return Multiply(
              Literal(Complex(0, 1)),
              Pow(Literal(-ratB), simplifiedExponent),
            ).simplify();
          } else {
            // Positive base: simplify square root of integer or rational
            if (ratB.denominator == BigInt.one) {
              final N = ratB.numerator;
              BigInt squareFactor = BigInt.one;
              BigInt remaining = N;
              double d = N.toDouble();
              if (!d.isInfinite && !d.isNaN) {
                int limit = dmath.sqrt(d).floor();
                for (int i = 2; i <= limit; i++) {
                  BigInt i2 = BigInt.from(i * i);
                  while (remaining % i2 == BigInt.zero) {
                    squareFactor *= BigInt.from(i);
                    remaining ~/= i2;
                  }
                }
              }
              if (remaining == BigInt.one) {
                return Literal(Rational(squareFactor));
              }
              if (squareFactor > BigInt.one) {
                return Multiply(
                  Literal(Rational(squareFactor)),
                  Pow(Literal(Rational(remaining)), simplifiedExponent),
                ).simplify();
              }
              return Pow(Literal(Rational(remaining)), simplifiedExponent);
            } else {
              final numPart =
                  Pow(Literal(Rational(ratB.numerator)), simplifiedExponent)
                      .simplify();
              final denPart =
                  Pow(Literal(Rational(ratB.denominator)), simplifiedExponent)
                      .simplify();
              return Divide(numPart, denPart).simplify();
            }
          }
        }
      }

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
    // if (exponent is Literal) {
    //   final ev = (exponent as Literal).value;
    //   final val = (ev is Complex) ? ev.simplify() : ev;
    //   if (val == 0.5 || val == Rational(1, 2)) {
    //     return "sqrt($base)";
    //   }
    // }

    var baseStr = base.toString();
    bool needsParentheses = base is Add ||
        base is Subtract ||
        base is Multiply ||
        base is Divide ||
        baseStr.startsWith('-');
    if (base is Literal) {
      final val = (base as Literal).value;
      if (val is Rational && !val.isInteger) {
        needsParentheses = true;
      } else if (val is Complex && val.imaginary != 0) {
        needsParentheses = true;
      } else if (val is num && val < 0) {
        needsParentheses = true;
      }
    }
    if (needsParentheses) {
      baseStr = '($baseStr)';
    }
    var expStr = exponent.toString();
    if (expStr.startsWith('-')) {
      expStr = '($expStr)';
    }
    return "$baseStr^$expStr";
  }
}

Map<int, Expression>? _collectPolynomialCoeffs(Expression expr, Variable v) {
  final varName = v.identifier.name;

  List<Expression> collectSumTerms(Expression e) {
    if (e is Add) {
      return [...collectSumTerms(e.left), ...collectSumTerms(e.right)];
    }
    if (e is Subtract) {
      return [
        ...collectSumTerms(e.left),
        ...collectSumTerms(Multiply(Literal(-1), e.right))
      ];
    }
    if (e is GroupExpression) {
      return collectSumTerms(e.expression);
    }
    return [e];
  }

  _TermCoeff? parsePolynomialTerm(Expression t) {
    if (t is UnaryExpression && t.operator == '-') {
      var inner = parsePolynomialTerm(t.operand);
      if (inner == null) return null;
      return _TermCoeff(
          Multiply(Literal(-1), inner.coefficient).simplify(), inner.degree);
    }
    if (t is GroupExpression) {
      return parsePolynomialTerm(t.expression);
    }
    if (!t
        .getVariableTerms()
        .any((varTerm) => varTerm.identifier.name == varName)) {
      return _TermCoeff(t, 0);
    }
    if (t is Variable && t.identifier.name == varName) {
      return _TermCoeff(Literal(1), 1);
    }
    if (t is Pow) {
      if (t.base is Variable &&
          (t.base as Variable).identifier.name == varName) {
        if (t.exponent is Literal) {
          var val = (t.exponent as Literal).value;
          double expDouble = -1.0;
          if (val is num) expDouble = val.toDouble();
          if (val is Rational) expDouble = val.toDouble();
          if (expDouble >= 0 && expDouble == expDouble.toInt()) {
            return _TermCoeff(Literal(1), expDouble.toInt());
          }
        }
      }
    }
    if (t is Multiply) {
      var leftHasVar = t.left
          .getVariableTerms()
          .any((varTerm) => varTerm.identifier.name == varName);
      var rightHasVar = t.right
          .getVariableTerms()
          .any((varTerm) => varTerm.identifier.name == varName);
      if (leftHasVar && !rightHasVar) {
        var varTerm = parsePolynomialTerm(t.left);
        if (varTerm == null) return null;
        return _TermCoeff(
            Multiply(t.right, varTerm.coefficient).simplify(), varTerm.degree);
      } else if (!leftHasVar && rightHasVar) {
        var varTerm = parsePolynomialTerm(t.right);
        if (varTerm == null) return null;
        return _TermCoeff(
            Multiply(t.left, varTerm.coefficient).simplify(), varTerm.degree);
      } else {
        var leftTerm = parsePolynomialTerm(t.left);
        var rightTerm = parsePolynomialTerm(t.right);
        if (leftTerm == null || rightTerm == null) return null;
        return _TermCoeff(
          Multiply(leftTerm.coefficient, rightTerm.coefficient).simplify(),
          leftTerm.degree + rightTerm.degree,
        );
      }
    }
    if (t is Divide) {
      var denHasVar = t.right
          .getVariableTerms()
          .any((varTerm) => varTerm.identifier.name == varName);
      if (!denHasVar) {
        var numTerm = parsePolynomialTerm(t.left);
        if (numTerm == null) return null;
        return _TermCoeff(
            Divide(numTerm.coefficient, t.right).simplify(), numTerm.degree);
      }
    }
    return null;
  }

  try {
    var sumTerms = collectSumTerms(expr);
    Map<int, Expression> degreeCoeffs = {};
    for (var term in sumTerms) {
      var parsedTerm = parsePolynomialTerm(term);
      if (parsedTerm == null) return null;
      var deg = parsedTerm.degree;
      var coeff = parsedTerm.coefficient;
      if (degreeCoeffs.containsKey(deg)) {
        degreeCoeffs[deg] = Add(degreeCoeffs[deg]!, coeff).simplify();
      } else {
        degreeCoeffs[deg] = coeff;
      }
    }
    return degreeCoeffs;
  } catch (_) {
    return null;
  }
}
