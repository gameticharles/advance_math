part of '../../expression.dart';

class RationalFunction extends Expression {
  final Expression numerator;
  final Expression denominator;

  RationalFunction(this.numerator, this.denominator);

  ({Expression quotient, RationalFunction remainder}) get _divisionResult =>
      divide();

  Expression get quotient => _divisionResult.quotient;
  RationalFunction get remainder => _divisionResult.remainder;

  // Modify the divide() method to handle polynomial division
  ({Expression quotient, RationalFunction remainder}) divide() {
    if (numerator is Polynomial && denominator is Polynomial) {
      Add result =
          (numerator as Polynomial) / (denominator as Polynomial) as Add;
      return (
        quotient: result.left,
        remainder: result.right as RationalFunction
      );
    }
    // Handle other cases or throw an exception
    throw UnimplementedError("Division not implemented for given expressions.");
  }

  @override
  dynamic evaluate([dynamic arg]) {
    return Divide(numerator, denominator).evaluate(arg);
  }

  @override
  Expression differentiate([Variable? v]) {
    // Apply quotient rule: (f/g)' = (f'g - fg')/g^2
    Expression fPrime = numerator.differentiate(v);
    Expression gPrime = denominator.differentiate(v);
    Expression gSquare = Multiply(denominator, denominator);

    return Divide(
        Subtract(Multiply(fPrime, denominator), Multiply(numerator, gPrime)),
        gSquare);
  }

  @override
  Expression integrate([dynamic start, dynamic end]) {
    return Divide(numerator, denominator).integrate();
  }

  @override
  bool isIndeterminate(num x) {
    dynamic numValue = numerator.evaluate(x);
    dynamic denValue = denominator.evaluate(x);
    return (numValue == 0 && denValue == 0) ||
        (numValue.isInfinite && denValue.isInfinite);
  }

  @override
  bool isInfinity(num x) {
    dynamic value = evaluate(x);
    return value.isInfinite;
  }

  @override
  bool isPoly([bool strict = false]) => false;

  @override
  Expression simplify() {
    Expression numSimplified = numerator.simplify();
    Expression denSimplified = denominator.simplify();

    if (numSimplified is Polynomial && denSimplified is Polynomial) {
      // Try to divide
      try {
        var result = (numSimplified / denSimplified);
        if (result is Polynomial) {
          return result;
        }
        // If result is Add(Polynomial, RationalFunction), check if remainder is zero
        if (result is Add) {
          var remainder = result.right;
          if (remainder is RationalFunction) {
            var remNum = remainder.numerator;
            if (remNum is Polynomial &&
                remNum.coefficients.length == 1 &&
                remNum.coefficients[0] == Complex.zero()) {
              // Remainder is zero, return quotient
              return result.left;
            }
            // Also check if numerator is Literal(0)
            if (remNum is Literal && remNum.value == Complex.zero()) {
              return result.left;
            }
          }
        }

        // Let's check Polynomial.gcd
        Polynomial gcd = numSimplified.gcd(denSimplified);
        if (gcd.coefficients.length > 1 ||
            (gcd.coefficients.isNotEmpty &&
                gcd.coefficients[0] != Complex.one())) {
          // Divide both by GCD
          var newNum = (numSimplified / gcd);
          var newDen = (denSimplified / gcd);

          // Extract Polynomials if they are wrapped in Add(Poly, Rational(0))
          if (newNum is Add && newNum.left is Polynomial) newNum = newNum.left;
          if (newDen is Add && newDen.left is Polynomial) newDen = newDen.left;

          // If division by GCD returns Polynomial (which it should), use it
          if (newNum is Polynomial && newDen is Polynomial) {
            if (newDen.coefficients.length == 1) {
              var coeff = newDen.coefficients[0];
              if (coeff is Literal && coeff.value == Complex.one()) {
                return newNum;
              }
            }
            return RationalFunction(newNum, newDen);
          }
        }
      } catch (e) {
        // Ignore errors
      }
    }

    return RationalFunction(numSimplified, denSimplified);
  }

  @override
  Expression expand() {
    return this;
  }

  @override
  Set<Variable> getVariableTerms() {
    return {
      ...numerator.getVariableTerms(),
      ...denominator.getVariableTerms(),
    };
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    return RationalFunction(
      numerator.substitute(oldExpr, newExpr),
      denominator.substitute(oldExpr, newExpr),
    );
  }

  @override
  int depth() {
    return 1 + max(numerator.depth(), denominator.depth());
  }

  @override
  int size() {
    return 1 + numerator.size() + denominator.size();
  }

  @override
  String toString() {
    return '($numerator / $denominator)';
  }
}
