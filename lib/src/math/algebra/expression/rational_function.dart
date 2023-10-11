part of algebra;

class RationalFunction implements Expression {
  final Polynomial numerator;
  final Polynomial denominator;

  RationalFunction(this.numerator, this.denominator);

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
    // Integration of rational functions can be complex and often involves partial fraction decomposition.
    // This is just a placeholder. You'd need a robust algorithm or library for handling this.
    throw UnimplementedError(
        "Integration for RationalFunction not implemented yet.");
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
