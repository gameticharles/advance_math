part of '../../../expression.dart';

/// Represents the cosecant trigonometric function.
///
/// The [Csc] class provides methods to evaluate, differentiate, and integrate
/// expressions in the form of cosecant. The integration follows the general formula:
///
///   ∫csc(ax + b) dx = (1/a) * ln|tan((ax+b)/2)| + C
///
/// Examples:
/// ```dart
/// var expr1 = Csc(Variable('x'));
/// print(expr1.integrate());  // ln|tan(x/2)| + C
///
/// var expr2 = Csc(Multiply(Literal(2), Variable('x')));
/// print(expr2.integrate());  // 1/2 * ln|tan(x)| + C
///
/// var expr3 = Csc(Add(Multiply(Literal(4), Variable('x')), Literal(1)));
/// print(expr3.integrate());  // 1/4 * ln|tan((4x+1)/2)| + C
/// ```
class Csc extends TrigonometricExpression {
  /// The power to which csc is raised.
  final int n;

  /// Creates an instance of the Csc class with the given [operand] and [n].
  Csc(super.operand, {this.n = 1});

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

  /// Evaluates the csc of the operand.
  ///
  /// Throws an exception if the sine of the operand is zero since csc is undefined at such points.
  @override
  dynamic evaluate([dynamic arg]) {
    var val = operand.evaluate(arg);
    if (val is num || val is Complex) {
      final res = csc(val);
      if (n == 1) return res;
      return (res is Complex) ? res.pow(n) : math.pow(res, n);
    }
    return Csc(val, n: n);
  }

  /// Returns the derivative of the csc function.
  ///
  /// The derivative of csc(x) is -csc(x)cot(x).
  @override
  Expression differentiate([Variable? v]) {
    if (n == 1) {
      // Chain rule: d/dv(csc(f)) = -csc(f)*cot(f) * df/dv
      return Multiply(Literal(-1),
          Multiply(Multiply(this, Cot(operand)), operand.differentiate(v)));
    } else {
      // For higher powers, the derivative can be found using the chain rule and power rule.
      return Multiply(
          Literal(-n),
          Multiply(Pow(Csc(operand), Literal(n - 1)),
              Multiply(Cot(operand), operand.differentiate(v))));
    }
  }

  /// Integrates the csc function.
  ///
  /// Uses the general formula for the integral of csc(ax + b).
  @override
  Expression integrate() {
    // Assuming operand is of form: Multiply(a, Variable) + b
    dynamic a = 1;
    dynamic b = 0;

    if (operand is Add) {
      var sum = operand as Add;
      if (sum.left is Multiply) {
        a = (sum.left as Multiply).left.evaluate();
      }
      if (sum.right is Literal) {
        b = sum.right.evaluate();
      }
    } else if (operand is Multiply) {
      a = (operand as Multiply).left.evaluate();
    } else if (operand is Literal) {
      b = operand.evaluate();
    }

    // Calculate 1/a safely
    dynamic invA;
    if (a is Complex) {
      invA = Complex.one() / a;
    } else {
      invA = 1 / a;
    }

    if (n == 1) {
      // ∫csc(ax + b) dx = (1/a) * ln|tan((ax+b)/2)|
      return Multiply(
          Literal(invA),
          Ln(Abs(Tan(Multiply(Literal(0.5),
              Add(Multiply(Literal(a), Variable('x')), Literal(b)))))));
    } else if (n == 2) {
      // ∫csc^2(ax + b) dx = -(1/a) * cot(ax + b)
      dynamic negInvA;
      if (invA is Complex) {
        negInvA = -invA;
      } else {
        negInvA = -invA;
      }
      return Multiply(Literal(negInvA), Cot(operand));
    } else {
      throw UnimplementedError('Integration of csc^$n is not yet supported');
    }
  }

  /// Simplifies the csc expression.
  ///
  /// If the operand is a literal, evaluates and returns a new Literal with the csc value.
  @override
  Expression simplify() {
    // If the operand is a literal, evaluate and return a new Literal with the csc value.
    if (operand is Literal) {
      return Literal(evaluate());
    }
    return this;
  }

  /// Returns the csc expression as-is since there's no expanded form.
  @override
  Expression expand() {
    return this;
  }

  /// Returns the string representation of the csc function.
  @override
  String toString() {
    return n == 1
        ? "csc(${operand.toString()})"
        : "(csc(${operand.toString()}))^$n";
  }
}
