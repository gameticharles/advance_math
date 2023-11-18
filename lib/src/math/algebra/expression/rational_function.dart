part of algebra;

class RationalFunction implements Expression {
  final Polynomial numerator;
  final Polynomial denominator;

  RationalFunction(this.numerator, this.denominator);

  ({Polynomial quotient, RationalFunction remainder}) get _divisionResult =>
      divide();

  Polynomial get quotient => _divisionResult.quotient;
  RationalFunction get remainder => _divisionResult.remainder;

  ({Polynomial quotient, RationalFunction remainder}) divide() {
    if (denominator.coefficients.every((coeff) => coeff == Integer.zero)) {
      throw Exception('Division by zero polynomial.');
    }

    List<Number> dividendCoeffs = _trimLeadingZeros(numerator.coefficients);
    List<Number> divisorCoeffs = _trimLeadingZeros(denominator.coefficients);

    int dividendDegree = dividendCoeffs.length - 1;
    int divisorDegree = divisorCoeffs.length - 1;

    if (divisorDegree > dividendDegree) {
      return (
        quotient: Polynomial.fromList([0]),
        remainder: RationalFunction(numerator, denominator)
      );
    }

    List<Number> quotientCoeffs =
        List.filled(dividendDegree - divisorDegree + 1, Integer.zero);

    for (int k = 0; k <= dividendDegree - divisorDegree; k++) {
      quotientCoeffs[k] = dividendCoeffs[k] / divisorCoeffs[0];
      for (int j = 0; j <= divisorDegree; j++) {
        dividendCoeffs[k + j] -= quotientCoeffs[k] * divisorCoeffs[j];
      }
    }

    // Correcting the range of indices for the remainder coefficients
    List<Number> remainderCoeffs =
        dividendCoeffs.sublist(dividendDegree - divisorDegree + 1);

    return (
      quotient: Polynomial(_trimLeadingZeros(quotientCoeffs)),
      remainder: RationalFunction(
          Polynomial(_trimLeadingZeros(remainderCoeffs)), denominator),
    );
  }

  List<Number> _trimLeadingZeros(List<Number> coeffs) {
    int i = 0;
    while (i < coeffs.length && coeffs[i] == Integer.zero) {
      i++;
    }
    return coeffs.sublist(i);
  }

  @override
  Number evaluate([dynamic x]) {
    return numerator.evaluate(x) / denominator.evaluate(x);
  }

  @override
  Expression differentiate([dynamic x]) {
    // Using the quotient rule for differentiation
    Polynomial num = (numerator.differentiate() * denominator) -
        (numerator * denominator.differentiate());
    Polynomial den = denominator * denominator;
    return RationalFunction(num, den);
  }

  @override
  Expression integrate([dynamic start, dynamic end]) {
    // If the degree of the numerator is greater than or equal to the degree of the denominator
    if (numerator.degree >= denominator.degree) {
      var divisionResult = divide();
      var integralOfQuotient = divisionResult.quotient.integrate();
      var integralOfRemainder = divisionResult.remainder.integrate();
      return integralOfQuotient + integralOfRemainder;
    } else {
      // Partial fraction decomposition is needed
      // For now, we'll throw an error as implementing partial fraction decomposition
      // is non-trivial and requires a more in-depth approach
      throw UnimplementedError(
          "Partial fraction decomposition for integration not implemented yet.");
    }
  }

  @override
  bool isIndeterminate(num x) {
    Number numValue = numerator.evaluate(x);
    Number denValue = denominator.evaluate(x);
    return (numValue == Integer(0) && denValue == Integer(0)) ||
        (numValue.isInfinite && denValue.isInfinite);
  }

  @override
  bool isInfinity(num x) {
    Number value = evaluate(x);
    return value.isInfinite;
  }

  @override
  Expression simplify() {
    return this;
  }
}
