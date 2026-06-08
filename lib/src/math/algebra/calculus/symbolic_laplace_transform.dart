import '../expression/expression.dart';
import '../../../number/decimal/rational.dart';

class LaplaceTransform {
  static Expression compute(Expression expr, Variable t, Variable s) {
    var result = _transform(expr.simplify(), t, s).simplify();

    // Attempt partial fraction decomposition to match expected canonical forms
    try {
      var partFracStr = "partfrac(${result.toString()}, ${s.identifier.name})";
      var partFrac = ExpressionParser().parse(partFracStr).evaluate();
      if (partFrac.toString() != result.toString()) {
        return partFrac.simplify();
      }
    } catch (_) {}

    return result;
  }

  static Expression _transform(Expression expr, Variable t, Variable s) {
    if (expr is Add) {
      return Add(_transform(expr.left, t, s), _transform(expr.right, t, s));
    }
    if (expr is Subtract) {
      return Subtract(
          _transform(expr.left, t, s), _transform(expr.right, t, s));
    }

    bool hasT(Expression e) =>
        e.getVariableTerms().any((v) => v.identifier.name == t.identifier.name);

    if (!hasT(expr)) return Multiply(expr, Pow(s, Literal(-1))).simplify();

    if (expr is Multiply) {
      if (!hasT(expr.left)) {
        return Multiply(expr.left, _transform(expr.right, t, s)).simplify();
      }
      if (!hasT(expr.right)) {
        return Multiply(expr.right, _transform(expr.left, t, s)).simplify();
      }
    }

    if (expr is Sin ||
        expr is Cos ||
        (expr is Trigonometric &&
            (expr.functionName == 'sin' || expr.functionName == 'cos'))) {
      var expanded = _expandTrig(expr, t);
      if (expanded != expr) return _transform(expanded, t, s);
    }

    if (expr is Pow && expr.base == t && expr.exponent is Literal) {
      var n = (expr.exponent as Literal).value;
      if (n is num && n > 0 && n % 1 == 0) {
        int fact = 1;
        for (int i = 2; i <= n; i++) {
          fact *= i;
        }
        return Multiply(Literal(fact), Pow(s, Literal(-(n + 1)))).simplify();
      }
      if (n is Rational &&
          n.numerator == BigInt.one &&
          n.denominator == BigInt.two) {
        return Divide(
                Multiply(
                    Pow(Variable('pi'), Literal(0.5)), Pow(s, Literal(-1.5))),
                Literal(2))
            .simplify();
      }
    }
    if (expr == t) return Pow(s, Literal(-2)).simplify();

    var expA = _extractExpCoeff(expr, t);
    if (expA != null) return Pow(Subtract(s, expA), Literal(-1)).simplify();

    var sinA = _extractTrigCoeff(expr, t, 'sin');
    if (sinA != null) {
      return Divide(sinA, Add(Pow(s, Literal(2)), Pow(sinA, Literal(2))))
          .simplify();
    }

    var cosA = _extractTrigCoeff(expr, t, 'cos');
    if (cosA != null) {
      return Divide(s, Add(Pow(s, Literal(2)), Pow(cosA, Literal(2))))
          .simplify();
    }

    var sinhA = _extractTrigCoeff(expr, t, 'sinh');
    if (sinhA != null) {
      return Divide(sinhA, Subtract(Pow(s, Literal(2)), Pow(sinhA, Literal(2))))
          .simplify();
    }

    var coshA = _extractTrigCoeff(expr, t, 'cosh');
    if (coshA != null) {
      return Divide(s, Subtract(Pow(s, Literal(2)), Pow(coshA, Literal(2))))
          .simplify();
    }

    if (expr is Multiply) {
      if (expr.left == t) {
        return Negate(_transform(expr.right, t, s).differentiate(s)).simplify();
      }
      if (expr.right == t) {
        return Negate(_transform(expr.left, t, s).differentiate(s)).simplify();
      }

      if (expr.left is Pow && (expr.left as Pow).base == t) {
        var n = ((expr.left as Pow).exponent as Literal).value;
        if (n is num && n > 0 && n % 1 == 0) {
          var F = _transform(expr.right, t, s);
          for (int i = 0; i < n; i++) {
            F = F.differentiate(s);
          }
          return Multiply(Literal(n % 2 == 0 ? 1 : -1), F).simplify();
        }
      }
      if (expr.right is Pow && (expr.right as Pow).base == t) {
        var n = ((expr.right as Pow).exponent as Literal).value;
        if (n is num && n > 0 && n % 1 == 0) {
          var F = _transform(expr.left, t, s);
          for (int i = 0; i < n; i++) {
            F = F.differentiate(s);
          }
          return Multiply(Literal(n % 2 == 0 ? 1 : -1), F).simplify();
        }
      }

      var shift = _extractExpShift(expr, t);
      if (shift != null) {
        var a = shift['a'] as Expression;
        var f = shift['f'] as Expression;
        var F = _transform(f, t, s);
        return F.substitute(s, Subtract(s, a)).simplify();
      }
    }

    return CallExpression(Variable(Identifier('laplace')), [expr, t, s]);
  }

  static Expression _expandTrig(Expression expr, Variable t) {
    bool hasT(Expression e) =>
        e.getVariableTerms().any((v) => v.identifier.name == t.identifier.name);
    bool isSin(Expression e) =>
        e is Sin || (e is Trigonometric && e.functionName == 'sin');
    bool isCos(Expression e) =>
        e is Cos || (e is Trigonometric && e.functionName == 'cos');

    Expression getOp(Expression e) => (e as dynamic).operand;

    if ((isSin(expr) || isCos(expr)) && getOp(expr) is Add) {
      var add = getOp(expr) as Add;
      if (hasT(add.left) && !hasT(add.right)) {
        if (isSin(expr)) {
          return Add(Multiply(Sin(add.left), Cos(add.right)),
                  Multiply(Cos(add.left), Sin(add.right)))
              .simplify();
        }
        if (isCos(expr)) {
          return Subtract(Multiply(Cos(add.left), Cos(add.right)),
                  Multiply(Sin(add.left), Sin(add.right)))
              .simplify();
        }
      }
      if (!hasT(add.left) && hasT(add.right)) {
        if (isSin(expr)) {
          return Add(Multiply(Cos(add.left), Sin(add.right)),
                  Multiply(Sin(add.left), Cos(add.right)))
              .simplify();
        }
        if (isCos(expr)) {
          return Subtract(Multiply(Cos(add.left), Cos(add.right)),
                  Multiply(Sin(add.left), Sin(add.right)))
              .simplify();
        }
      }
    }
    return expr;
  }

  static Expression? _extractTrigCoeff(
      Expression expr, Variable t, String func) {
    bool isFunc(Expression e, String name) {
      if (name == 'sin' && e is Sin) return true;
      if (name == 'cos' && e is Cos) return true;
      if (e is Trigonometric && e.functionName.toLowerCase() == name) {
        return true;
      }
      return false;
    }

    if (isFunc(expr, func)) {
      var op = (expr as dynamic).operand;
      if (op is Multiply) {
        if (op.left == t) return op.right;
        if (op.right == t) return op.left;
      }
      if (op == t) return Literal(1);
    }
    return null;
  }

  static Expression? _extractExpCoeff(Expression expr, Variable t) {
    bool isExp(Expression e) {
      if (e is Exp) return true;
      if (e is Pow) {
        var b = e.base;
        if (b is Variable && b.identifier.name == 'e') return true;
      }
      return false;
    }

    if (isExp(expr)) {
      var op = (expr is Pow) ? expr.exponent : (expr as dynamic).operand;
      if (op is Multiply) {
        if (op.left == t) return op.right;
        if (op.right == t) return op.left;
      }
      if (op == t) return Literal(1);
    }
    return null;
  }

  static Map<String, Expression>? _extractExpShift(
      Expression expr, Variable t) {
    if (expr is Multiply) {
      var left = expr.left;
      var right = expr.right;
      var a = _extractExpCoeff(left, t);
      if (a != null) return {'a': a, 'f': right};
      a = _extractExpCoeff(right, t);
      if (a != null) return {'a': a, 'f': left};
    }
    return null;
  }
}

class InverseLaplaceTransform {
  static Expression compute(Expression expr, Variable s, Variable t) {
    Expression? inverted;
    try {
      var partFracStr = "partfrac(${expr.toString()}, ${s.identifier.name})";
      var partFrac = ExpressionParser().parse(partFracStr).evaluate();
      inverted = _invert(partFrac, s, t).simplify();
    } catch (_) {
      inverted = _invert(expr.simplify(), s, t).simplify();
    }
    return inverted;
  }

  static Expression _invert(Expression expr, Variable s, Variable t) {
    if (expr is Add) {
      return Add(_invert(expr.left, s, t), _invert(expr.right, s, t));
    }
    if (expr is Subtract) {
      return Subtract(_invert(expr.left, s, t), _invert(expr.right, s, t));
    }

    bool hasS(Expression e) =>
        e.getVariableTerms().any((v) => v.identifier.name == s.identifier.name);
    if (!hasS(expr)) return expr;

    if (expr is Multiply) {
      if (!hasS(expr.left)) {
        return Multiply(expr.left, _invert(expr.right, s, t)).simplify();
      }
      if (!hasS(expr.right)) {
        return Multiply(expr.right, _invert(expr.left, s, t)).simplify();
      }
    }

    if (expr is Pow && expr.base == s && expr.exponent is Literal) {
      var n = (expr.exponent as Literal).value;
      if (n is num && n < 0 && n % 1 == 0) {
        int power = -n.toInt() - 1;
        int fact = 1;
        for (int i = 2; i <= power; i++) {
          fact *= i;
        }
        return Divide(Pow(t, Literal(power)), Literal(fact)).simplify();
      }
      if (n is Rational &&
          n.numerator == BigInt.from(-3) &&
          n.denominator == BigInt.two) {
        return Multiply(Literal(2),
                Divide(Pow(t, Literal(0.5)), Pow(Variable('pi'), Literal(0.5))))
            .simplify();
      }
    }

    if (expr is Divide &&
        expr.left is Literal &&
        (expr.left as Literal).value == 1 &&
        expr.right == s) {
      return Literal(1);
    }

    if (expr is Divide) {
      var nume = expr.left;
      var den = expr.right;

      if (den is Add) {
        var sSquared = _findSSquared(den, s);
        var aSquared = _findConstant(den, s);
        if (sSquared != null && aSquared != null) {
          var a = Pow(aSquared, Literal(0.5)).simplify();
          if (nume == s) return Cos(Multiply(a, t)).simplify();
          if (nume.toString() == a.toString()) {
            return Sin(Multiply(a, t)).simplify();
          }
          if (!nume
              .getVariableTerms()
              .any((v) => v.identifier.name == s.identifier.name)) {
            return Multiply(Divide(nume, a), Sin(Multiply(a, t))).simplify();
          }
        }
      }

      if (den is Pow && den.exponent is Literal) {
        var n = (den.exponent as Literal).value;
        if (n is num && n > 0 && n % 1 == 0) {
          var base = den.base;
          Expression? a;
          if (base is Subtract && base.left == s) a = base.right;
          if (base is Add && base.left == s) a = Negate(base.right).simplify();

          if (a != null) {
            int power = n.toInt() - 1;
            int fact = 1;
            for (int i = 2; i <= power; i++) {
              fact *= i;
            }
            return Multiply(Divide(Pow(t, Literal(power)), Literal(fact)),
                    Exp(Multiply(a, t)))
                .simplify();
          }
        }
      }

      Expression? a;
      if (den is Subtract && den.left == s) {
        a = den.right;
      } else if (den is Add && den.left == s) {
        a = Negate(den.right).simplify();
      } else if (den == s) {
        a = Literal(0);
      }

      if (a != null) {
        return Multiply(nume, Exp(Multiply(a, t))).simplify();
      }
    }

    return CallExpression(Variable(Identifier('ilt')), [expr, s, t]);
  }

  static Expression? _findSSquared(Expression expr, Variable s) {
    if (expr is Pow &&
        expr.base == s &&
        expr.exponent is Literal &&
        (expr.exponent as Literal).value == 2) {
      return expr;
    }
    if (expr is Add) {
      var l = _findSSquared(expr.left, s);
      if (l != null) return l;
      return _findSSquared(expr.right, s);
    }
    return null;
  }

  static Expression? _findConstant(Expression expr, Variable s) {
    bool hasS(Expression e) =>
        e.getVariableTerms().any((v) => v.identifier.name == s.identifier.name);
    if (!hasS(expr)) return expr;
    if (expr is Add) {
      var l = _findConstant(expr.left, s);
      if (l != null && !hasS(l)) return l;
      var r = _findConstant(expr.right, s);
      if (r != null && !hasS(r)) return r;
    }
    return null;
  }
}
