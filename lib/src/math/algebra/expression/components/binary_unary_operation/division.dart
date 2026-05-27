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

// // Helper method to check if an expression contains a Variable
//   bool _containsVariable(Expression expr) {
//     if (expr is Variable) {
//       return true;
//     } else if (expr is BinaryOperationsExpression) {
//       return _containsVariable(expr.left) || _containsVariable(expr.right);
//     }
//     return false;
//   }

  @override
  Expression differentiate([Variable? v]) {
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
    // If numerator (left) is a Literal or Variable, perform a simple integration of the denominator.
    if (left is Literal || left is Variable) {
      return Divide(left, right.integrate());
    }

    // If denominator (right) is a Literal or Variable, perform a simple integration of the numerator.
    else if (right is Literal || right is Variable) {
      return Divide(left.integrate(), right);
    }

    // If the numerator is a derivative of the denominator, then the integral is a log of the denominator.
    if (left.differentiate().simplify() == right) {
      return Multiply(Literal(log(right.evaluate())), right);
    }

    // If the numerator and denominator are both polynomials
    if (left is Polynomial && right is Polynomial) {
      var numerator = left as Polynomial;
      var denominator = right as Polynomial;

      // If degree of numerator >= degree of denominator
      if (numerator.degree >= denominator.degree) {
        // Perform polynomial long division
        var result = numerator / denominator as Add;

        // Integrate the quotient and remainder separately
        var quotientIntegral = Multiply(result.left, denominator).integrate();
        var remainderIntegral = Divide(result.right, denominator).integrate();

        return Add(quotientIntegral, remainderIntegral);
      } else {
        // Apply partial fraction decomposition
        var decomposed = _partialFractionDecomposition(numerator, denominator);

        // Integrate each term separately
        return decomposed
            .map(
                (fraction) => Divide(fraction.left, fraction.right).integrate())
            .reduce((a, b) => Add(a, b));
      }
    }
    return this;
  }

  List<Divide> _partialFractionDecomposition(
      Polynomial numerator, Polynomial denominator) {
    // First, factorize the denominator into its linear factors
    // This is a complex step and requires a polynomial factorization algorithm
    // For simplicity, let's assume a method `factorize()` that gives us linear factors
    List<Polynomial> factors = denominator.factorize();

    // For each factor, we'll have a corresponding fraction with an unknown coefficient in the numerator
    // e.g., for (x^2 + 3x + 2) we might have: A/(x + 1) + B/(x + 2)
    // We'll then form equations to solve for A, B, etc.

    // For simplicity, let's assume we have a method `solveCoefficients()`
    // that gives us the coefficients for each factor
    List<Literal> coefficients = _solveCoefficients(numerator, factors);

    // Now form the decomposed fractions
    List<Divide> decomposed = [];
    for (int i = 0; i < factors.length; i++) {
      decomposed.add(Divide(coefficients[i], factors[i]));
    }

    return decomposed;
  }

  List<Literal> _solveCoefficients(
      Polynomial numerator, List<Polynomial> factors) {
    int n = factors.length;
    List<Literal> coefficients = List.filled(n, Literal(0));

    // Form the expression for the sum of the simpler fractions
    Expression sum = Literal(0);
    for (int i = 0; i < n; i++) {
      // Using a new variable as the coefficient for each factor
      Variable coefficient = Variable('A${i + 1}');
      sum = Add(sum, Divide(coefficient, factors[i]));
    }

    // Clear the denominators
    var commonDenominator = factors.reduce((a, b) => (a * b) as Polynomial);
    var multipliedNumerator = (numerator * commonDenominator) as Polynomial;
    var multipliedSum = Multiply(sum, commonDenominator);

    // Equate the coefficients of the powers of x on both sides
    for (int i = 0; i < n; i++) {
      coefficients[i] = Literal(Subtract(
          multipliedNumerator.coefficient(i) as Expression,
          (multipliedSum as Polynomial).coefficient(i) as Expression));
    }

    // At this point, we'd typically solve the system of equations for the coefficients
    // This requires methods for systems of linear equations, which can be complex
    // For now, we'll return the coefficients as they are, but in practice,
    // you'd need to solve this system to get the actual coefficients

    return coefficients;
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
        if (isIntegerVal(l) && isIntegerVal(r) && fitsInInt(l) && fitsInInt(r)) {
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
    if (numerator is Multiply && numerator.left is Literal && denominator is Literal) {
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
    // Division doesn't have a direct expanded form, return as-is.
    return this;
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
    if (right is Add ||
        right is Subtract ||
        right is Multiply ||
        right is Divide) {
      rightStr = '($rightStr)';
    }

    return "$leftStr/$rightStr";
  }
}
