import 'package:advance_math/src/math/algebra/expression/expression.dart';
import 'dart:math' as math;
import 'package:advance_math/src/number/complex/complex.dart';

List<Expression> getFactors(Expression expr) {
  if (expr is Multiply) {
    return getFactors(expr.left) + getFactors(expr.right);
  }
  if (expr is Pow && expr.right is Literal) {
    var p = (expr.right as Literal).value;
    if (p is num && p == p.roundToDouble() && p > 0) {
      return List.filled(p.round(), expr.left);
    }
  }
  return [expr];
}

Expression product(List<Expression> factors) {
  if (factors.isEmpty) return Literal(1);
  return factors.reduce(Multiply.new);
}

Expression? squareRoot(Expression expr) {
  if (expr is Literal) {
    var val = expr.value;
    if (val is num && val >= 0) {
      var s = math.sqrt(val);
      if (s == s.roundToDouble()) return Literal(s.round());
      return Literal(s);
    }
  }
  if (expr is Pow && expr.right is Literal) {
    var p = (expr.right as Literal).value;
    if (p == 2) return expr.left;
  }
  if (expr is Multiply) {
    var l = squareRoot(expr.left);
    var r = squareRoot(expr.right);
    if (l != null && r != null) return Multiply(l, r).simplify();
  }
  var factored = factorExpression(expr);
  if (factored.toString() != expr.toString()) {
    return squareRoot(factored);
  }
  return null;
}

bool isEquivalent(Expression e1, Expression e2, List<Variable> vars) {
  Expression sub1 = e1;
  Expression sub2 = e2;
  for (int i = 0; i < vars.length; i++) {
    final val = Literal(i + 2.3);
    sub1 = sub1.substitute(vars[i], val);
    sub2 = sub2.substitute(vars[i], val);
  }
  try {
    final val1 = sub1.evaluate();
    final val2 = sub2.evaluate();
    if (val1 is num && val2 is num) {
      return (val1 - val2).abs() < 1e-9;
    }
    if (val1 is Complex && val2 is Complex) {
      return (val1.real - val2.real).abs() < 1e-9 &&
          (val1.imaginary - val2.imaginary).abs() < 1e-9;
    }
    return val1.toString() == val2.toString();
  } catch (_) {
    return false;
  }
}

Expression factorExpression(Expression expr) {
  expr = expr.simplify();
  final vars = expr.getVariableTerms().map((e) => e).toList();
  if (vars.isEmpty) return expr;
  if (vars.length == 1) {
    try {
      final poly = Polynomial.fromString(expr.toString());
      final factors = poly.factorize();
      return factors.isEmpty
          ? Literal(1)
          : factors.cast<Expression>().reduce(Multiply.new);
    } catch (_) {
      return expr;
    }
  }

  // Multi-variable
  for (final v in vars) {
    final expr0 = expr.substitute(v, Literal(0)).simplify();
    final expr1 = expr.substitute(v, Literal(1)).simplify();
    final exprNeg1 = expr.substitute(v, Literal(-1)).simplify();

    final C = expr0;
    final A =
        Divide(Add(Add(expr1, exprNeg1), Multiply(Literal(-2), C)), Literal(2))
            .simplify();
    final B = Divide(Subtract(expr1, exprNeg1), Literal(2)).simplify();

    final reconstructed =
        Add(Add(Multiply(A, Pow(v, Literal(2))), Multiply(B, v)), C).simplify();
    if (!isEquivalent(reconstructed, expr, vars)) {
      continue; // Degree might be > 2 in v, or subscription failed
    }

    // Case 1: Linear in v (A == 0)
    if (A.toString() == '0') {
      final bFactored = factorExpression(B);
      final cFactored = factorExpression(C);
      final bFactors = getFactors(bFactored);
      final cFactors = getFactors(cFactored);

      final common = <Expression>[];
      final remainingC = List<Expression>.from(cFactors);
      for (final bf in bFactors) {
        int matchIndex =
            remainingC.indexWhere((cf) => cf.toString() == bf.toString());
        if (matchIndex != -1) {
          common.add(bf);
          remainingC.removeAt(matchIndex);
        }
      }

      if (common.isNotEmpty) {
        final commonExpr = product(common);
        final bRem = Divide(B, commonExpr).simplify();
        final cRem = Divide(C, commonExpr).simplify();
        return Multiply(commonExpr, Add(Multiply(bRem, v), cRem).simplify())
            .simplify();
      }
    }

    // Case 2: Quadratic in v with B == 0
    if (B.toString() == '0' && A.toString() != '0') {
      final negA = Multiply(Literal(-1), A).simplify();
      final ratio = Divide(C, negA).simplify();
      final D = squareRoot(ratio);
      if (D != null) {
        final factor1 = Subtract(v, D).simplify();
        final factor2 = Add(v, D).simplify();
        if (A.toString() == '1') {
          return Multiply(factor1, factor2).simplify();
        }
        if (A.toString() == '-1') {
          return Multiply(Literal(-1), Multiply(factor1, factor2)).simplify();
        }
        return Multiply(A, Multiply(factor1, factor2)).simplify();
      }
    }
  }

  return expr;
}

void main() {
  final parser = ExpressionParser();
  final cases = [
    '(x^2+4x+4)-y^2',
    '81-(16a^2-56a+49)',
    '(9x^2-12x+4)-25',
    '(x^2+4x+4)+x*y+2y',
    '(4x^2+24x+36)-14x*y-42y',
    '35a*b-15b+(49a^2-42a+9)',
    '1-6a^2+9a^4',
    '1-6a^2+9a^4-49b^2'
  ];
  for (var c in cases) {
    var expr = parser.parse(c);
    var factored = factorExpression(expr);
    print('$c  =>  $factored');
  }
}
