part of '../../../expression.dart';

class Cos extends TrigonometricExpression {
  /// The power to which csc is raised.
  final int n;

  /// Creates an instance of the Csc class with the given [operand] and [n].
  Cos(super.operand, {this.n = 1});

  /// Returns the periodicity of the csc function raised to the power of n.
  double get periodicity {
    if (n % 2 == 0) {
      // If n is even
      return pi / 2;
    } else {
      // If n is odd
      return pi;
    }
  }

  @override
  num evaluate([dynamic arg]) {
    return cos(operand.evaluate(arg));
  }

  @override
  Expression differentiate() {
    return Negate(Multiply(operand.differentiate(), Sin(operand)));
  }

  @override
  Expression integrate() {
    return Sin(operand);
  }

  @override
  Expression expand() {
    return this;
  }

  @override
  Expression simplify() {
    return this;
  }

  @override
  String toString() {
    return "cos(${operand.toString()})";
  }
}
