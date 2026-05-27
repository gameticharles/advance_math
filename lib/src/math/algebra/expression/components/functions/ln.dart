part of '../../expression.dart';

class Ln extends Expression {
  final Expression operand;

  Ln(this.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    var val = operand.evaluate(arg);
    if (val is Matrix) {
      return val.log();
    }
    if (val is Complex) {
      return val.ln();
    }
    return math.log(val);
  }

  @override
  Expression differentiate([Variable? v]) {
    // Chain rule: d/dv[ln(f(x))] = f'(x) / f(x)
    return Divide(operand.differentiate(v), operand);
  }

  @override
  Expression integrate() {
    // The integral of ln(x) is x*ln(x) - x.
    // But the integral of ln(f(x)) in general can be more complex.
    // For this simple implementation, we'll only handle the case of ln(x).
    if (operand is Variable) {
      return Subtract(Multiply(operand, this), operand);
    }
    throw UnimplementedError(
        "Integration for Ln of this operand not implemented yet.");
  }

  @override
  Expression simplify() {
    var simplifiedOperand = operand.simplify();

    // ln(1) = 0
    if (simplifiedOperand is Literal) {
      var val = simplifiedOperand.value;
      if (val is num) {
        if (val == 1) return Literal(0);
        // ln(e) = 1
        if ((val - dmath.e).abs() < 1e-15) return Literal(1);
        // Evaluate positive numeric literals
        if (val > 0) return Literal(math.log(val));
      }
    }

    // ln(e^x) = x — when operand is Pow with base e
    if (simplifiedOperand is Pow) {
      var base = simplifiedOperand.base;
      if (base is Literal) {
        var bv = base.value;
        if (bv is num && (bv - dmath.e).abs() < 1e-15) {
          return simplifiedOperand.exponent;
        }
      }
    }

    // ln(Exp(x)) = x
    if (simplifiedOperand is Exp) {
      return simplifiedOperand.operand;
    }

    // ln(a * b) = ln(a) + ln(b) — for positive numeric literals
    if (simplifiedOperand is Multiply) {
      if (simplifiedOperand.left is Literal &&
          simplifiedOperand.right is Literal) {
        var lv = (simplifiedOperand.left as Literal).value;
        var rv = (simplifiedOperand.right as Literal).value;
        if (lv is num && rv is num && lv > 0 && rv > 0) {
          return Add(Ln(simplifiedOperand.left), Ln(simplifiedOperand.right))
              .simplify();
        }
      }
    }

    // ln(a / b) = ln(a) - ln(b) — for positive numeric literals
    if (simplifiedOperand is Divide) {
      if (simplifiedOperand.left is Literal &&
          simplifiedOperand.right is Literal) {
        var lv = (simplifiedOperand.left as Literal).value;
        var rv = (simplifiedOperand.right as Literal).value;
        if (lv is num && rv is num && lv > 0 && rv > 0) {
          return Subtract(
                  Ln(simplifiedOperand.left), Ln(simplifiedOperand.right))
              .simplify();
        }
      }
    }

    if (simplifiedOperand != operand) {
      return Ln(simplifiedOperand);
    }
    return this;
  }

  @override
  Expression expand() {
    return this;
  }

  @override
  Set<Variable> getVariableTerms() {
    return operand.getVariableTerms();
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    if (this == oldExpr) {
      return newExpr;
    }
    return Ln(operand.substitute(oldExpr, newExpr));
  }

  @override
  bool isIndeterminate(dynamic x) {
    return operand.isIndeterminate(x);
  }

  @override
  bool isInfinity(dynamic x) {
    try {
      final val = evaluate(x);
      if (val is Complex) return val.isInfinite;
      if (val is num) return val.isInfinite;
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  bool isPoly([bool strict = false]) => false;

  // Calculating the depth
  @override
  int depth() {
    return 1 + operand.depth();
  }

  // Calculating the size
  @override
  int size() {
    return 1 + operand.size();
  }

  @override
  String toString() {
    return "ln(${operand.toString()})";
  }
}
