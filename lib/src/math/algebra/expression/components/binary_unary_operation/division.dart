part of '../../expression.dart';

class Divide extends BinaryOperationsExpression {
  Divide(super.left, super.right);

  @override
  dynamic evaluate([dynamic arg]) {
    dynamic leftEval = left.evaluate(arg);
    dynamic rightEval = right.evaluate(arg);

    if (leftEval is Expression || rightEval is Expression) {
      return Divide(
        leftEval is Expression ? leftEval : Literal(leftEval),
        rightEval is Expression ? rightEval : Literal(rightEval),
      ).simplify();
    }

    if (leftEval is Matrix) {
      return (leftEval / rightEval);
    }
    if (rightEval is Matrix) {
      return (leftEval / rightEval);
    }

    if ((leftEval is num || leftEval is Complex || leftEval is Rational) &&
        (rightEval is num || rightEval is Complex || rightEval is Rational)) {
      final rC = rightEval is Complex ? rightEval : Complex(rightEval);
      if (rC == Complex.zero()) {
        throw Exception('Division by zero!');
      }
      // Integer division optimization
      if (leftEval is int && rightEval is int) {
        if (leftEval % rightEval == 0) {
          return leftEval ~/ rightEval;
        }
        return Rational(leftEval, rightEval);
      }
      final lC = leftEval is Complex ? leftEval : Complex(leftEval);
      return _normalizeResult(lC / rC);
    }

    dynamic result = Divide(Literal(leftEval), Literal(rightEval)).simplify();
    return _normalizeResult(result);
  }

  @override
  Expression differentiate([Variable? v]) {
    // Optimization: Constant Multiple Rule
    if (right.getVariableTerms().isEmpty) {
      return Divide(left.differentiate(v), right).simplify();
    }

    // Applying the quotient rule: (u / v)' = (u' * v - u * v') / v^2
    // where u and v are functions of x.
    var uPrime = left.differentiate(v);
    var vPrime = right.differentiate(v);
    var vSquared = Multiply(right, right);

    return Divide(
        Subtract(Multiply(uPrime, right), Multiply(left, vPrime)), vSquared);
  }

  @override
  Expression integrate() {
    // 1. Denominator is a constant: ∫ f(x)/c dx = (1/c) * ∫ f(x) dx
    if (right.getVariableTerms().isEmpty) {
      return Multiply(Divide(Literal(1), right), left.integrate()).simplify();
    }

    // 2. Numerator is a constant, denominator is a single variable: ∫ c/x dx = c * ln|x|
    if (left.getVariableTerms().isEmpty && right is Variable) {
      return Multiply(left, Ln(Abs(right))).simplify();
    }

    // 3. Logarithmic integration: ∫ f'(x)/f(x) dx = ln|f(x)|
    final u = right.simplify();
    final du = u.differentiate().simplify();
    if (left.simplify() == du) {
      return Ln(Abs(u));
    }

    // 4. Rational function integration via Polynomial Long Division & Partial Fractions
    try {
      final result =
          _integrateRationalFunction(left.simplify(), right.simplify());
      if (result != null) return result.simplify();
    } catch (_) {
      // Fall through to unimplemented error if rational integration fails
    }

    throw UnimplementedError(
        'Advanced rational integration (complex roots or irreducible quadratics) is not yet supported.');
  }

  /// Attempts to integrate a rational function N(x)/D(x) using the existing Polynomial class.
  Expression? _integrateRationalFunction(
      Expression numExpr, Expression denExpr) {
    final vars = denExpr.getVariableTerms();
    if (vars.length != 1) return null; // Multivariate not supported
    final v = vars.first;

    // Convert Expression trees to Polynomial objects
    final numPoly = _toPolynomial(numExpr, v);
    final denPoly = _toPolynomial(denExpr, v);

    if (numPoly == null || denPoly == null || _isZeroPoly(denPoly)) return null;

    Expression integral = Literal(0);
    Polynomial remPoly = numPoly;

    // STEP A: Polynomial Long Division (if improper fraction)
    if (numPoly.degree >= denPoly.degree) {
      // Leverage Polynomial's operator / which returns Add(Quotient, RationalFunction)
      Expression divResult = numPoly / denPoly;
      Polynomial? quotPoly;

      if (divResult is Add && divResult.left is Polynomial) {
        quotPoly = divResult.left as Polynomial;
      } else if (divResult is Polynomial) {
        quotPoly = divResult;
      }

      if (quotPoly != null) {
        // Integrate the polynomial quotient using Polynomial's built-in integrate()
        integral = Add(integral, quotPoly.integrate()).simplify();
      }

      // Get the remainder using Polynomial's operator %
      remPoly = (numPoly % denPoly) as Polynomial;
    }

    if (_isZeroPoly(remPoly)) return integral;

    // STEP B: Partial Fraction Decomposition (for proper fraction remPoly / denPoly)
    List<dynamic> roots = denPoly.roots();
    if (roots.isEmpty) return null;

    // Group roots to find multiplicities (only support real roots for standard real calculus)
    Map<num, int> rootMult = {};
    for (var r in roots) {
      num? realVal;
      if (r is num) {
        realVal = r;
      } else if (r is Complex && r.imaginary == 0) {
        realVal = r.real;
      } else {
        // Abort on complex or symbolic roots
        return null;
      }

      // Round slightly to group identical floating point roots
      num rounded = double.parse(realVal!.toStringAsFixed(8));
      rootMult[rounded] = (rootMult[rounded] ?? 0) + 1;
    }

    // Process each distinct root using the derivative formula for coefficients
    for (var entry in rootMult.entries) {
      num r = entry.key;
      int m = entry.value; // Multiplicity

      // Divide denominator by (x - r)^m using synthetic division
      Polynomial denReduced = denPoly;
      for (int i = 0; i < m; i++) {
        denReduced = _syntheticDiv(denReduced, r);
      }

      // F(x) = Remainder / Reduced_Denominator
      Expression fExpr = Divide(remPoly, denReduced).simplify();

      // Calculate coefficients: A_k = F^(k)(r) / k!
      for (int k = 0; k < m; k++) {
        int j = m - k; // The power in the denominator (x - r)^j

        Expression fK = fExpr;
        for (int d = 0; d < k; d++) {
          fK = fK.differentiate(v).simplify();
        }

        // Evaluate the k-th derivative at x = r
        dynamic evalVal = fK.evaluate({v.identifier.name: r});
        num val = 0;
        if (evalVal is num) {
          val = evalVal;
        } else if (evalVal is Complex) {
          val = evalVal.toDouble();
        } else if (evalVal is Rational) {
          val = evalVal.toDouble();
        } else {
          return null;
        }

        num coeff = val / factorial(k);
        if (coeff.abs() < 1e-10) continue; // Skip effectively zero coefficients

        if (j == 1) {
          // Integral of A / (x - r) is A * ln|x - r|
          integral = Add(integral,
                  Multiply(Literal(coeff), Ln(Abs(Subtract(v, Literal(r))))))
              .simplify();
        } else {
          // Integral of A / (x - r)^j is A * (x - r)^(-j + 1) / (-j + 1)
          num power = -j + 1;
          num newCoeff = coeff / power;
          integral = Add(
                  integral,
                  Multiply(Literal(newCoeff),
                      Pow(Subtract(v, Literal(r)), Literal(power))))
              .simplify();
        }
      }
    }

    return integral;
  }

  // ==========================================
  // HELPER METHODS FOR RATIONAL INTEGRATION
  // ==========================================

  /// Recursively converts an Expression tree into a Polynomial object.
  Polynomial? _toPolynomial(Expression expr, Variable v) {
    if (expr is Literal) {
      return Polynomial.fromList([expr], variable: v);
    }
    if (expr is Variable) {
      if (expr == v || expr.identifier.name == v.identifier.name) {
        return Polynomial.fromList([Literal(1), Literal(0)],
            variable: v); // Represents 'x'
      }
      return null; // Different variable
    }
    if (expr is Add) {
      final left = _toPolynomial(expr.left, v);
      final right = _toPolynomial(expr.right, v);
      if (left == null || right == null) return null;
      return (left + right) as Polynomial;
    }
    if (expr is Subtract) {
      final left = _toPolynomial(expr.left, v);
      final right = _toPolynomial(expr.right, v);
      if (left == null || right == null) return null;
      return (left - right) as Polynomial;
    }
    if (expr is Multiply) {
      final left = _toPolynomial(expr.left, v);
      final right = _toPolynomial(expr.right, v);
      if (left == null || right == null) return null;
      return (left * right) as Polynomial;
    }
    if (expr is Negate) {
      final inner = _toPolynomial(expr.operand, v);
      if (inner == null) return null;
      return (Polynomial.fromList([Literal(0)], variable: v) - inner)
          as Polynomial;
    }
    if (expr is Pow) {
      final base = _toPolynomial(expr.left, v);
      if (base == null) return null;
      if (expr.right is Literal) {
        final expVal = (expr.right as Literal).evaluate();
        num? expNum;
        if (expVal is num) {
          expNum = expVal;
        } else if (expVal is Complex && expVal.imaginary == 0) {
          expNum = expVal.real;
        } else if (expVal is Rational) {
          expNum = expVal.toDouble();
        }

        if (expNum != null && expNum >= 0 && expNum % 1 == 0) {
          Polynomial res = Polynomial.fromList([Literal(1)], variable: v);
          for (int i = 0; i < expNum.toInt(); i++) {
            res = (res * base) as Polynomial;
          }
          return res;
        }
      }
      return null;
    }

    // Fallback: Try parsing from string representation
    try {
      return Polynomial.fromString(expr.toString(), variable: v);
    } catch (_) {
      return null;
    }
  }

  /// Performs synthetic division to divide a Polynomial by (x - r).
  Polynomial _syntheticDiv(Polynomial poly, num r) {
    List<Expression> coeffs = poly.coefficients;
    if (coeffs.length <= 1) {
      return Polynomial.fromList([Literal(0)], variable: poly.variable);
    }

    List<Expression> out = [];
    Expression carry = Literal(0);
    for (int i = 0; i < coeffs.length - 1; i++) {
      Expression current = Add(coeffs[i], carry).simplify();
      out.add(current);
      carry = Multiply(current, Literal(r)).simplify();
    }
    return Polynomial.fromList(out, variable: poly.variable);
  }

  /// Checks if a Polynomsial is effectively zero.
  bool _isZeroPoly(Polynomial p) {
    if (p.coefficients.isEmpty) return true;
    return p.coefficients.every((c) {
      if (c is Literal) {
        final v = c.value;
        if (v is Complex) return v == Complex.zero();
        if (v is Rational) return v == Rational.zero;
        if (v is num) return v == 0;
      }
      return false;
    });
  }

  @override
  Expression simplifyBasic() {
    var numerator = left.simplify();
    var denominator = right.simplify();

    // Helper to extract numeric value from Literal (may be Complex wrapping a real)
    dynamic extractNum(Literal lit) {
      final v = lit.value;
      if (v is num) return v;
      if (v is Complex && v.isReal) {
        return v.simplify(); // returns int or double
      }
      return v;
    }

    bool fitsInInt(dynamic val) {
      if (val is int) return true;
      if (val is Rational) return val.isInteger && val.numerator.isValidInt;
      if (val is double) return val == val.toInt();
      if (val is Complex && val.isReal) {
        final r = val.real;
        if (r is Rational) return r.isInteger && r.numerator.isValidInt;
        if (r is int) return true;
        if (r is double) return r == r.toInt();
      }
      return false;
    }

    bool isIntegerVal(dynamic val) {
      if (val is int) return true;
      if (val is Rational) return val.isInteger;
      if (val is double) return val == val.toInt();
      if (val is Complex && val.isReal) {
        final r = val.real;
        if (r is Rational) return r.isInteger;
        if (r is int) return true;
        if (r is double) return r == r.toInt();
      }
      return false;
    }

    int toIntVal(dynamic val) {
      if (val is int) return val;
      if (val is Rational) return val.toInt();
      if (val is double) return val.toInt();
      if (val is Complex && val.isReal) {
        final r = val.real;
        if (r is Rational) return r.toInt();
        if (r is int) return r;
        if (r is double) return r.toInt();
      }
      throw ArgumentError('Not an integer val');
    }

    // Basic simplification: if both operands are literals, evaluate and return a new Literal.
    if (numerator is Literal && denominator is Literal) {
      var l = extractNum(numerator);
      var r = extractNum(denominator);

      if ((l is num || l is Rational) && (r is num || r is Rational)) {
        if (isIntegerVal(l) &&
            isIntegerVal(r) &&
            fitsInInt(l) &&
            fitsInInt(r)) {
          final intL = toIntVal(l);
          final intR = toIntVal(r);
          if (intR == 0) throw Exception('Division by zero');
          if (intL % intR == 0) {
            return Literal(intL ~/ intR);
          }
          return Literal(_normalizeResult(Rational(intL, intR)));
        } else if (l is double || r is double) {
          final dL = l is Rational ? l.toDouble() : (l as num).toDouble();
          final dR = r is Rational ? r.toDouble() : (r as num).toDouble();
          if (dR == 0) throw Exception('Division by zero');
          return Literal(dL / dR);
        } else {
          final rationalL = Rational(l);
          final rationalR = Rational(r);
          if (rationalR == Rational.zero) throw Exception('Division by zero');
          final res = rationalL / rationalR;
          return Literal(_normalizeResult(res));
        }
      }

      // Handle Complex division
      if (l is Complex || r is Complex) {
        var lC = Complex(l);
        var rC = Complex(r);
        if (rC == Complex.zero()) throw Exception('Division by zero');
        return Literal(_normalizeResult(lC / rC));
      }
    }

    // x / 1 -> x
    if (denominator is Literal) {
      final dv = extractNum(denominator);
      if (dv == 1) return numerator;
      // x / -1 -> -x
      if (dv == -1) return Multiply(Literal(-1), numerator).simplify();
      // 0 / x -> 0 (but only if numerator is 0)
      if (numerator is Literal) {
        final nv = extractNum(numerator);
        if (nv == 0) return Literal(0);
      }
    }

    // 0 / x -> 0
    if (numerator is Literal) {
      final nv = extractNum(numerator);
      if (nv == 0) return Literal(0);
    }

    // x / x -> 1
    if (numerator.toString() == denominator.toString()) return Literal(1);

    // Convert division by literal to multiplication by reciprocal
    // x / c -> x * (1/c)
    if (denominator is Literal) {
      final dv = extractNum(denominator);
      if (dv is num) {
        if (dv == 0) throw Exception('Division by zero');
        //return Multiply(Literal(1 / dv), numerator).simplify();
        final reciprocal = (dv is int) ? Rational(1, dv) : 1 / dv;
        return Multiply(Literal(reciprocal), numerator).simplify();
      }
    }

    // Cancellation: A / (c * A) -> 1/c
    if (denominator is Multiply &&
        (denominator.left is Literal || denominator.right is Literal)) {
      Expression c;
      Expression terms;
      if (denominator.left is Literal) {
        c = denominator.left;
        terms = denominator.right;
      } else {
        c = denominator.right;
        terms = denominator.left;
      }
      if (terms.toString() == numerator.toString()) {
        return Divide(Literal(1), c).simplify();
      }
    }

    // Cancellation: (c * A) / A -> c
    if (numerator is Multiply &&
        (numerator.left is Literal || numerator.right is Literal)) {
      Expression c;
      Expression terms;
      if (numerator.left is Literal) {
        c = numerator.left;
        terms = numerator.right;
      } else {
        c = numerator.right;
        terms = numerator.left;
      }
      if (terms.toString() == denominator.toString()) {
        return c;
      }
    }

    // Cancellation: (c * A) / d -> (c/d) * A
    if (numerator is Multiply &&
        numerator.left is Literal &&
        denominator is Literal) {
      final cVal = extractNum(numerator.left as Literal);
      final dVal = extractNum(denominator);
      if ((cVal is num || cVal is Rational || cVal is Complex) &&
          (dVal is num || dVal is Rational || dVal is Complex)) {
        final Complex compC = Complex(cVal);
        final Complex compD = Complex(dVal);
        if (compD != Complex.zero()) {
          final res = _normalizeResult(compC / compD);
          if (res == 1 || res == 1.0 || res == Complex(1, 0)) {
            return numerator.right;
          }
          if (res == -1 || res == -1.0 || res == Complex(-1, 0)) {
            return Negate(numerator.right);
          }
          if (res is Complex && res.isImaginary) {
            var imag = res.imaginary.toDouble();
            if (imag is double && imag != imag.toInt()) {
              imag = Rational(imag);
            } else if (imag is num && imag % 1 != 0) {
              imag = Rational(imag);
            }
            final coef = Multiply(Literal(imag), Literal(Complex(0, 1)));
            return Multiply(coef, numerator.right).simplify();
          }
          return Multiply(Literal(res), numerator.right).simplify();
        }
      }
    }

    if (denominator is! Literal) {
      return Multiply(Pow(denominator, Literal(-1)), numerator).simplifyBasic();
    }

    return Divide(numerator, denominator);
  }

  @override
  Expression expand() {
    var expandedLeft = left.expand();
    var expandedRight = right.expand();
    if (expandedRight is Literal) {
      final v = expandedRight.value;
      if (v is num || v is Rational || v is Complex) {
        try {
          final c = Complex(v);
          if (c != Complex.zero()) {
            final reciprocal = _normalizeResult(Complex.one() / c);
            return Multiply(Literal(reciprocal), expandedLeft).expand();
          }
        } catch (_) {}
      }
    }
    return Divide(expandedLeft, expandedRight);
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    return Divide(
      left.substitute(oldExpr, newExpr),
      right.substitute(oldExpr, newExpr),
    );
  }

  @override
  String toString() {
    var leftStr = left.toString();
    var rightStr = right.toString();

    // Wrap left if it has lower precedence (Add/Subtract)
    if (left is Add || left is Subtract) {
      leftStr = '($leftStr)';
    }
    // Wrap right if it has lower or equal precedence (Add/Subtract/Multiply/Divide)
    // Actually, for division, right operand needs parens if it's mul or div too?
    // a / (b * c) vs a / b * c.
    // Standard precedence: * and / are equal, left associative.
    // a / b * c = (a / b) * c.
    // a / (b * c).
    // So if right is Multiply or Divide, we need parens.
    final val = right is Literal ? (right as Literal).value : null;
    final isNonIntRational = val is Rational && !val.isInteger;
    if (right is Add ||
        right is Subtract ||
        right is Multiply ||
        right is Divide ||
        isNonIntRational) {
      rightStr = '($rightStr)';
    }

    return "$leftStr/$rightStr";
  }
}
