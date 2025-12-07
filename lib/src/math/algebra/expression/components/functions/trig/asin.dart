part of '../../../expression.dart';

/// Represents the inverse sine (arcsin) function.
///
/// Domain: `[-1, 1]`
/// Range: `[-π/2, π/2]`
/// Derivative: d/dx(asin(x)) = 1/√(1-x²)
class Asin extends TrigonometricExpression {
  Asin(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var eval = operand.evaluate(arg);
    if (eval is num) {
      if (eval < -1 || eval > 1) {
        throw ArgumentError('asin domain error: $eval not in [-1, 1]');
      }
      return asin(eval);
    }
    if (eval is Complex) {
      return eval.asin();
    }
    return Asin(eval);
  }

  @override
  Expression differentiate([Variable? v]) {
    // Chain rule: d/dv(asin(f)) = (1/√(1-f²)) * df/dv
    // = df/dv / √(1-f²)
    final oneMinusFSquared = Subtract(Literal(1), Pow(operand, Literal(2)));
    final sqrtPart = Pow(oneMinusFSquared, Literal(0.5));

    return Divide(operand.differentiate(v), sqrtPart);
  }

  @override
  Expression integrate() {
    // ∫asin(x)dx = x·asin(x) + √(1-x²) + C
    // This is complex, returning placeholder
    throw UnimplementedError('Integration of asin not yet implemented');
  }

  @override
  Expression expand() {
    return this;
  }

  @override
  Expression simplifyBasic() {
    return this;
  }

  @override
  String toString() {
    return "asin(${operand.toString()})";
  }
}
