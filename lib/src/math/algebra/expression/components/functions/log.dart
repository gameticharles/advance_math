part of '../../expression.dart';

/// Represents the logarithm function with arbitrary base in mathematical expressions.
///
/// The logarithm function log_base(operand) returns the power to which the base
/// must be raised to produce the operand. If no base is specified, it defaults
/// to base 10 (common logarithm).
///
/// Example usage:
/// ```dart
/// final x = Variable('x');
/// final log10 = Log(ex(10), x); // log₁₀(x)
/// final log2 = Log(ex(2), x);   // log₂(x)
/// final logE = Log(Literal(math.e), x); // ln(x) - natural logarithm
///
/// final result = log10.evaluate({'x': 100}); // 2.0
///
/// // Differentiation: d/dx[log_a(f(x))] = f'(x) / (f(x) * ln(a))
/// final derivative = log10.differentiate();
///
/// // Integration is complex and depends on the specific form
/// ```
class Log extends Expression {
  /// The base of the logarithm.
  final Expression base;

  /// The operand (argument) of the logarithm.
  final Expression operand;

  /// Creates a logarithm expression log_base(operand).
  /// If base is not provided, defaults to base 10.
  Log(this.base, this.operand);

  /// Creates a base-10 logarithm (common logarithm).
  Log.base10(this.operand) : base = Literal(10);

  /// Creates a base-2 logarithm (binary logarithm).
  Log.base2(this.operand) : base = Literal(2);

  /// Creates a natural logarithm (base e).
  Log.natural(this.operand) : base = Literal(math.e);

  @override
  num evaluate([dynamic arg]) {
    final baseValue = base.evaluate(arg);
    final operandValue = operand.evaluate(arg);

    if (baseValue <= 0 || baseValue == 1) {
      throw ArgumentError('Logarithm base must be positive and not equal to 1');
    }
    if (operandValue <= 0) {
      throw ArgumentError('Logarithm operand must be positive');
    }

    // Use change of base formula: log_a(x) = ln(x) / ln(a)
    return math.log(operandValue) / math.log(baseValue);
  }

  @override
  Expression differentiate([Variable? v]) {
    // Chain rule: d/dv[log_a(f(x))] = f'(x) / (f(x) * ln(a))
    final lnBase = Ln(base);
    return Divide(operand.differentiate(v), Multiply(operand, lnBase));
  }

  @override
  Expression integrate() {
    // Integration of logarithms is complex and depends on the specific form.
    // For log(x), the integral is x*log(x) - x/ln(base).
    if (operand is Variable) {
      final lnBase = Ln(base);
      return Subtract(Multiply(operand, this), Divide(operand, lnBase));
    }

    throw UnimplementedError(
        "Integration for Log of this operand not implemented yet.");
  }

  @override
  Expression simplify() {
    final simplifiedBase = base.simplify();
    final simplifiedOperand = operand.simplify();

    // If both base and operand are literals, evaluate
    if (simplifiedBase is Literal && simplifiedOperand is Literal) {
      try {
        return Literal(evaluate());
      } catch (e) {
        // If evaluation fails (e.g., negative values), return as is
        return this;
      }
    }

    // log_a(1) = 0 for any valid base a
    if (simplifiedOperand is Literal && simplifiedOperand.value == 1) {
      return Literal(0);
    }

    // log_a(a) = 1 for any valid base a
    if (simplifiedBase == simplifiedOperand) {
      return Literal(1);
    }

    // log_a(a^x) = x for any valid base a
    if (simplifiedOperand is Pow && simplifiedOperand.base == simplifiedBase) {
      return simplifiedOperand.exponent;
    }

    // If base is e, convert to natural logarithm (Ln)
    if (simplifiedBase is Literal &&
        (simplifiedBase.value - math.e).abs() < 1e-10) {
      return Ln(simplifiedOperand);
    }

    // If operands changed during simplification, return new Log
    if (simplifiedBase != base || simplifiedOperand != operand) {
      return Log(simplifiedBase, simplifiedOperand);
    }

    return this;
  }

  @override
  Expression expand() {
    return Log(base.expand(), operand.expand());
  }

  @override
  Set<Variable> getVariableTerms() {
    final variables = <Variable>{};
    variables.addAll(base.getVariableTerms());
    variables.addAll(operand.getVariableTerms());
    return variables;
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    if (this == oldExpr) {
      return newExpr;
    }
    return Log(base.substitute(oldExpr, newExpr),
        operand.substitute(oldExpr, newExpr));
  }

  @override
  bool isIndeterminate(num x) {
    return base.isIndeterminate(x) || operand.isIndeterminate(x);
  }

  @override
  bool isInfinity(num x) {
    final baseValue = base.evaluate({'x': x});
    final operandValue = operand.evaluate({'x': x});

    // log_a(0) approaches -∞
    if (operandValue == 0) return true;

    // log_a(∞) = ∞ for a > 1
    if (operandValue == double.infinity && baseValue > 1) return true;

    return false;
  }

  @override
  bool isPoly([bool strict = false]) => false;

  @override
  int depth() {
    return 1 + math.max(base.depth(), operand.depth());
  }

  @override
  int size() {
    return 1 + base.size() + operand.size();
  }

  @override
  String toString() {
    // Special formatting for common bases
    if (base is Literal) {
      final baseValue = (base as Literal).value;
      if (baseValue == 10) {
        return "log(${operand.toString()})";
      } else if (baseValue == 2) {
        return "log₂(${operand.toString()})";
      } else if ((baseValue - math.e).abs() < 1e-10) {
        return "ln(${operand.toString()})";
      }
    }

    return "log_{${base.toString()}}(${operand.toString()})";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Log && base == other.base && operand == other.operand;
  }

  @override
  int get hashCode => Object.hash(base, operand);
}
