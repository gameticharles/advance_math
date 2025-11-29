part of '../../../expression.dart';

/// Represents the inverse tangent (arctan) function.
///
/// Domain: (-∞, ∞)
/// Range: (-π/2, π/2)
/// Derivative: d/dx(atan(x)) = 1/(1+x²)
class Atan extends TrigonometricExpression {
  Atan(super.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var eval = operand.evaluate(arg);
    if (eval is num) {
      return atan(eval);
    }
    return Atan(eval);
  }

  @override
  Expression differentiate([Variable? v]) {
    // Chain rule: d/dv(atan(f)) = (1/(1+f²)) * df/dv
    // = df/dv / (1+f²)
    final onePlusFSquared = Add(Literal(1), Pow(operand, Literal(2)));

    return Divide(operand.differentiate(v), onePlusFSquared);
  }

  @override
  Expression integrate() {
    // ∫atan(x)dx = x·atan(x) - (1/2)ln(1+x²) + C
    // This is complex, returning placeholder
    throw UnimplementedError('Integration of atan not yet implemented');
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
    return "atan(${operand.toString()})";
  }
}
