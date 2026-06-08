import '../expression/expression.dart';
import '../../../number/decimal/rational.dart';
import '../../../number/complex/complex.dart';

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

    if (expr is Pow && expr.base != s) {
      var exp = expr.exponent;
      try {
        var val = exp.evaluate();
        var numVal = val is Complex ? val.real : val;
        if (numVal is Rational) numVal = numVal.toDouble();
        if (numVal is num && numVal < 0) {
          if (numVal == -1) {
            return _invert(Divide(Literal(1), expr.base), s, t);
          } else {
            return _invert(
                Divide(Literal(1), Pow(expr.base, Literal(-numVal))), s, t);
          }
        }
      } catch (_) {}
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

      var denCoeffs = _collectCoeffs(den, s);
      if (denCoeffs != null) {
        var deg = denCoeffs.keys.isEmpty
            ? 0
            : denCoeffs.keys.reduce((a, b) => a > b ? a : b);

        if (deg == 1) {
          // Linear denominator: B*s + C
          var B = denCoeffs[1] ?? Literal(0);
          var C = denCoeffs[0] ?? Literal(0);
          var numCoeffs = _collectCoeffs(nume, s) ?? {};
          var P = numCoeffs[1] ?? Literal(0);
          var Q = numCoeffs[0] ?? Literal(0);

          if (P is Literal && P.value == 0) {
            var factor = Divide(Q, B).simplify();
            var a = Negate(Divide(C, B)).simplify();
            return Multiply(factor, Exp(Multiply(a, t))).simplify();
          }
        }

        if (deg == 2) {
          // Quadratic denominator: A*s^2 + B*s + C
          var A = denCoeffs[2] ?? Literal(0);
          var B = denCoeffs[1] ?? Literal(0);
          var C = denCoeffs[0] ?? Literal(0);

          var numCoeffs = _collectCoeffs(nume, s) ?? {};
          var P = numCoeffs[1] ?? Literal(0);
          var Q = numCoeffs[0] ?? Literal(0);

          var a = Negate(Divide(B, Multiply(Literal(2), A))).simplify();
          var wSquared = Subtract(Divide(C, A),
                  Divide(Multiply(B, B), Multiply(Literal(4), Multiply(A, A))))
              .simplify();

          dynamic wSqVal;
          try {
            wSqVal = wSquared.evaluate();
          } catch (_) {}

          if (wSqVal != null) {
            bool isZeroWSq = wSqVal == 0 ||
                wSqVal == 0.0 ||
                (wSqVal is Complex && wSqVal == Complex.zero()) ||
                (wSqVal is Rational && wSqVal == Rational.zero);
            if (isZeroWSq) {
              var term1 = Divide(P, A).simplify();
              var term2 = Divide(Add(Q, Multiply(P, a)), A).simplify();
              var inside = Add(term1, Multiply(term2, t)).simplify();
              if (a is Literal && a.value == 0) return inside;
              return Multiply(inside, Exp(Multiply(a, t))).simplify();
            } else {
              var w = Pow(wSquared, Literal(0.5)).simplify();
              var coeffCos = P;
              var coeffSin = Divide(Add(Q, Multiply(P, a)), w).simplify();

              Expression termCos = coeffCos is Literal && coeffCos.value == 0
                  ? Literal(0)
                  : Multiply(coeffCos, Cos(Multiply(w, t)));
              Expression termSin = coeffSin is Literal && coeffSin.value == 0
                  ? Literal(0)
                  : Multiply(coeffSin, Sin(Multiply(w, t)));

              var inside = Divide(Add(termCos, termSin), A).simplify();
              if (a is Literal && a.value == 0) return inside;
              return Multiply(inside, Exp(Multiply(a, t))).simplify();
            }
          }
        }
      }
      if (den is Pow && den.exponent is Literal) {
        var n = (den.exponent as Literal).value;
        if (n is num && n > 0 && n % 1 == 0) {
          if (n == 2) {
            var base = den.base;
            var baseCoeffs = _collectCoeffs(base, s);
            if (baseCoeffs != null) {
              var deg = baseCoeffs.keys.isEmpty
                  ? 0
                  : baseCoeffs.keys.reduce((a, b) => a > b ? a : b);
              if (deg == 2) {
                var A = baseCoeffs[2] ?? Literal(0);
                var C = baseCoeffs[0] ?? Literal(0);

                var numCoeffs = _collectCoeffs(nume, s) ?? {};
                var Q = numCoeffs[2] ?? Literal(0);
                var R = numCoeffs[1] ?? Literal(0);
                var S = numCoeffs[0] ?? Literal(0);

                var a2 = Multiply(A, A).simplify();
                var q = Divide(Q, a2).simplify();
                var r = Divide(R, a2).simplify();
                var ss = Divide(S, a2).simplify();

                var wSquared = Divide(C, A).simplify();
                var w = Pow(wSquared, Literal(0.5)).simplify();

                var term1 = Divide(q, Multiply(Literal(2), w)).simplify();
                var term2 = Divide(ss, Multiply(Literal(2), Pow(w, Literal(3))))
                    .simplify();
                var coeffSin = Add(term1, term2).simplify();

                var coeffSinT = Divide(r, Multiply(Literal(2), w)).simplify();

                var term3 = Divide(q, Literal(2)).simplify();
                var term4 =
                    Divide(ss, Multiply(Literal(2), wSquared)).simplify();
                var coeffCosT = Subtract(term3, term4).simplify();

                Expression t1 = coeffSin is Literal && coeffSin.value == 0
                    ? Literal(0)
                    : Multiply(coeffSin, Sin(Multiply(w, t)));
                Expression t2 = coeffSinT is Literal && coeffSinT.value == 0
                    ? Literal(0)
                    : Multiply(Multiply(coeffSinT, Sin(Multiply(w, t))), t);
                Expression t3 = coeffCosT is Literal && coeffCosT.value == 0
                    ? Literal(0)
                    : Multiply(Multiply(coeffCosT, Cos(Multiply(w, t))), t);

                return Add(Add(t1, t2), t3).simplify();
              }
            }
          }
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
      } else if (den is Add) {
        if (den.left == s) {
          a = Negate(den.right).simplify();
        } else if (den.right == s) {
          a = Negate(den.left).simplify();
        }
      } else if (den == s) {
        a = Literal(0);
      }
      if (a != null) {
        return Multiply(nume, Exp(Multiply(a, t))).simplify();
      }
    }
    return CallExpression(Variable(Identifier('ilt')), [expr, s, t]);
  }

  static Map<int, Expression>? _collectCoeffs(Expression expr, Variable s) {
    final varName = s.identifier.name;
    List<Expression> collectSumTerms(Expression e) {
      if (e is Add) {
        return [...collectSumTerms(e.left), ...collectSumTerms(e.right)];
      }
      if (e is Subtract) {
        return [
          ...collectSumTerms(e.left),
          ...collectSumTerms(Multiply(Literal(-1), e.right))
        ];
      }
      if (e is GroupExpression) {
        return collectSumTerms(e.expression);
      }
      return [e];
    }

    _LaplaceTermCoeff? parseTerm(Expression t) {
      if (t is Negate) {
        var inner = parseTerm(t.operand);
        if (inner == null) return null;
        return _LaplaceTermCoeff(
            Multiply(Literal(-1), inner.coefficient).simplify(), inner.degree);
      }
      if (t is GroupExpression) {
        return parseTerm(t.expression);
      }
      if (!t
          .getVariableTerms()
          .any((varTerm) => varTerm.identifier.name == varName)) {
        return _LaplaceTermCoeff(t, 0);
      }
      if (t is Variable && t.identifier.name == varName) {
        return _LaplaceTermCoeff(Literal(1), 1);
      }
      if (t is Pow) {
        if (t.base is Variable &&
            (t.base as Variable).identifier.name == varName) {
          if (t.exponent is Literal) {
            var val = (t.exponent as Literal).value;
            double expDouble = -1.0;
            if (val is num) expDouble = val.toDouble();
            if (val is Rational) expDouble = val.toDouble();
            if (expDouble >= 0 && expDouble == expDouble.toInt()) {
              return _LaplaceTermCoeff(Literal(1), expDouble.toInt());
            }
          }
        }
      }
      if (t is Multiply) {
        var leftHasVar = t.left
            .getVariableTerms()
            .any((varTerm) => varTerm.identifier.name == varName);
        var rightHasVar = t.right
            .getVariableTerms()
            .any((varTerm) => varTerm.identifier.name == varName);
        if (leftHasVar && !rightHasVar) {
          var varTerm = parseTerm(t.left);
          if (varTerm == null) return null;
          return _LaplaceTermCoeff(
              Multiply(t.right, varTerm.coefficient).simplify(),
              varTerm.degree);
        } else if (!leftHasVar && rightHasVar) {
          var varTerm = parseTerm(t.right);
          if (varTerm == null) return null;
          return _LaplaceTermCoeff(
              Multiply(t.left, varTerm.coefficient).simplify(), varTerm.degree);
        } else {
          var leftTerm = parseTerm(t.left);
          var rightTerm = parseTerm(t.right);
          if (leftTerm == null || rightTerm == null) return null;
          return _LaplaceTermCoeff(
            Multiply(leftTerm.coefficient, rightTerm.coefficient).simplify(),
            leftTerm.degree + rightTerm.degree,
          );
        }
      }
      if (t is Divide) {
        var denHasVar = t.right
            .getVariableTerms()
            .any((varTerm) => varTerm.identifier.name == varName);
        if (!denHasVar) {
          var numTerm = parseTerm(t.left);
          if (numTerm == null) return null;
          return _LaplaceTermCoeff(
              Divide(numTerm.coefficient, t.right).simplify(), numTerm.degree);
        }
      }
      return null;
    }

    try {
      var sumTerms = collectSumTerms(expr);
      Map<int, Expression> degreeCoeffs = {};
      for (var term in sumTerms) {
        var parsedTerm = parseTerm(term);
        if (parsedTerm == null) return null;
        var deg = parsedTerm.degree;
        var coeff = parsedTerm.coefficient;
        if (degreeCoeffs.containsKey(deg)) {
          degreeCoeffs[deg] = Add(degreeCoeffs[deg]!, coeff).simplify();
        } else {
          degreeCoeffs[deg] = coeff;
        }
      }
      return degreeCoeffs;
    } catch (_) {
      return null;
    }
  }
}

class _LaplaceTermCoeff {
  final Expression coefficient;
  final int degree;
  _LaplaceTermCoeff(this.coefficient, this.degree);
}
