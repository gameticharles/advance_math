part of '../../../expression.dart';

/// Represents the inverse cosine (arccos) function.
///
/// Domain: [-1, 1]
/// Range: [0, π]
/// Derivative: d/dx(acos(x)) = -1/√(1-x²)
class Acos extends TrigonometricExpression {
  Acos(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var eval = operand.evaluate(arg);
    if (eval is num) {
      if (eval < -1 || eval > 1) {
        throw ArgumentError('acos domain error: $eval not in [-1, 1]');
      }
      return acos(eval);
    }
    if (eval is Complex) {
      return eval.acos();
    }
    return Acos(eval);
  }

  @override
  Expression differentiate([Variable? v]) {
    // Chain rule: d/dv(acos(f)) = (-1/√(1-f²)) * df/dv
    // = -df/dv / √(1-f²)
    final oneMinusFSquared = Subtract(Literal(1), Pow(operand, Literal(2)));
    final sqrtPart = Pow(oneMinusFSquared, Literal(0.5));

    return Negate(Divide(operand.differentiate(v), sqrtPart));
  }

  @override
  Expression integrate() {
    // ∫acos(x)dx = x·acos(x) - √(1-x²) + C
    // This is complex, returning placeholder
    throw UnimplementedError('Integration of acos not yet implemented');
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
    return "acos(${operand.toString()})";
  }
}
