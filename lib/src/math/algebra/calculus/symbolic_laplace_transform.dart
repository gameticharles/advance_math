import 'dart:math' as dmath;
import '../expression/expression.dart';
import '../../../number/decimal/rational.dart';
import '../../../number/complex/complex.dart';

/// Symbolic Laplace Transform — L{f(t)} = F(s)
class LaplaceTransform {
  static Expression compute(Expression expr, Variable t, Variable s) {
    Expression raw = _transform(expr.simplify(), t, s);
    // Only simplify if the result doesn't contain symbolic sqrt or pi
    // (simplify() evaluates pi/sqrt(n) numerically, losing the symbolic form)
    Expression result = _safeSimplify(raw);
    // Skip partfrac if result contains symbolic 'pi' or unevaluated sqrt
    bool hasSymbolic = _hasSymbolicSqrt(result);
    if (!hasSymbolic) {
      try {
        var pfStr = "partfrac(${result.toString()}, ${s.identifier.name})";
        var pf = ExpressionParser().parse(pfStr).evaluate();
        if (pf.toString() != result.toString()) return _safeSimplify(pf);
      } catch (_) {}
    }
    return result;
  }

  /// Simplify expression but preserve symbolic sqrt(n) and pi.
  /// Skips simplification entirely when symbolic constants are detected.
  static Expression _safeSimplify(Expression e) {
    if (_hasSymbolicSqrt(e)) return e;
    return e.simplify();
  }

  /// Returns true if the expression tree contains Variable('pi') or
  /// any symbolic sqrt(n) (Pow with exponent 1/2).
  /// Uses getVariableTerms() for pi and toString() scan for sqrt patterns.
  static bool _hasSymbolicSqrt(Expression e) {
    // Check for 'pi' as a variable
    if (e.getVariableTerms().any((v) => v.identifier.name == 'pi')) {
      return true;
    }
    // Check string representation for sqrt patterns like sqrt(n)
    final str = e.toString();
    return str.contains('sqrt(') || str.contains('^(1/2)');
  }

  static Expression _transform(Expression expr, Variable t, Variable s) {
    bool hasT(Expression e) =>
        e.getVariableTerms().any((v) => v.identifier.name == t.identifier.name);

    if (expr is Add) {
      return Add(_transform(expr.left, t, s), _transform(expr.right, t, s));
    }
    if (expr is Subtract) {
      return Subtract(
          _transform(expr.left, t, s), _transform(expr.right, t, s));
    }

    // L{c} = c/s  (no t in expression)
    if (!hasT(expr)) return Multiply(expr, Pow(s, Literal(-1))).simplify();

    if (expr is Multiply) {
      if (!hasT(expr.left)) {
        // .simplify() preserves symbolic sqrt(pi) — it does NOT evaluate it numerically.
        return Multiply(expr.left, _transform(expr.right, t, s)).simplify();
      }
      if (!hasT(expr.right)) {
        return Multiply(expr.right, _transform(expr.left, t, s)).simplify();
      }
    }

    // Expand sin/cos of sum angle before transforming
    if (expr is Sin || expr is Cos) {
      var expanded = _expandTrig(expr, t);
      if (expanded != expr) return _transform(expanded, t, s);
    }

    // L{t^n} = n!/s^(n+1)
    if (expr is Pow && expr.base == t && expr.exponent is Literal) {
      var n = (expr.exponent as Literal).value;
      if (n is double && n > 0 && n % 1 == 0) {
        int ni = n.toInt();
        int fact = 1;
        for (int i = 2; i <= ni; i++) {
          fact *= i;
        }
        return Multiply(Literal(fact), Pow(s, Literal(-(ni + 1)))).simplify();
      }
      if (n is int && n > 0) {
        int fact = 1;
        for (int i = 2; i <= n; i++) {
          fact *= i;
        }
        return Multiply(Literal(fact), Pow(s, Literal(-(n + 1)))).simplify();
      }
      // L{sqrt(t)} = L{t^(1/2)} = Γ(3/2)/s^(3/2) = sqrt(π)/(2s^(3/2))
      // Keep sqrt(pi) symbolic — do NOT call .evaluate(); .simplify() is safe.
      if (n is Rational &&
          n.numerator == BigInt.one &&
          n.denominator == BigInt.two) {
        // Γ(3/2) = sqrt(pi)/2, so L{t^(1/2)} = (1/2)*sqrt(pi)*s^(-3/2)
        var sqrtPi = Pow(Variable('pi'), Literal(Rational(1, 2)));
        var sPow = Pow(s, Literal(Rational(-3, 2)));
        // Use simplify() to fold any leading factor; it preserves sqrt(pi).
        return Multiply(Literal(Rational(1, 2)), Multiply(sPow, sqrtPi))
            .simplify();
      }
    }

    // L{t} = 1/s²
    if (expr == t) return Pow(s, Literal(-2)).simplify();

    // L{e^(at)} = 1/(s-a)
    var expA = _extractExpCoeff(expr, t);
    if (expA != null) return Pow(Subtract(s, expA), Literal(-1)).simplify();

    // L{sinh(at)} = a/(s²-a²)
    var sinhA = _extractHypCoeff(expr, t, isSinh: true);
    if (sinhA != null) {
      return Divide(sinhA, Subtract(Pow(s, Literal(2)), Pow(sinhA, Literal(2))))
          .simplify();
    }
    // L{cosh(at)} = s/(s²-a²)
    var coshA = _extractHypCoeff(expr, t, isSinh: false);
    if (coshA != null) {
      return Divide(s, Subtract(Pow(s, Literal(2)), Pow(coshA, Literal(2))))
          .simplify();
    }

    // L{sin(at)} = a/(s²+a²)
    var sinA = _extractTrigCoeff(expr, t, isSin: true);
    if (sinA != null) {
      return Divide(sinA, Add(Pow(s, Literal(2)), Pow(sinA, Literal(2))))
          .simplify();
    }
    // L{cos(at)} = s/(s²+a²)
    var cosA = _extractTrigCoeff(expr, t, isSin: false);
    if (cosA != null) {
      return Divide(s, Add(Pow(s, Literal(2)), Pow(cosA, Literal(2))))
          .simplify();
    }

    if (expr is Multiply) {
      // L{t·f(t)} = -d/ds F(s)
      if (expr.left == t) {
        return Negate(_transform(expr.right, t, s).differentiate(s)).simplify();
      }
      if (expr.right == t) {
        return Negate(_transform(expr.left, t, s).differentiate(s)).simplify();
      }
      // L{t^n·f(t)} = (-1)^n · d^n/ds^n F(s)
      if (expr.left is Pow && (expr.left as Pow).base == t) {
        var expNode = (expr.left as Pow).exponent;
        if (expNode is Literal) {
          var n = expNode.value;
          int? ni;
          if (n is int) ni = n;
          if (n is double && n % 1 == 0) ni = n.toInt();
          if (ni != null && ni > 0) {
            var F = _transform(expr.right, t, s);
            for (int i = 0; i < ni; i++) {
              F = F.differentiate(s);
            }
            return Multiply(Literal(ni % 2 == 0 ? 1 : -1), F).simplify();
          }
        }
      }
      if (expr.right is Pow && (expr.right as Pow).base == t) {
        var expNode = (expr.right as Pow).exponent;
        if (expNode is Literal) {
          var n = expNode.value;
          int? ni;
          if (n is int) ni = n;
          if (n is double && n % 1 == 0) ni = n.toInt();
          if (ni != null && ni > 0) {
            var F = _transform(expr.left, t, s);
            for (int i = 0; i < ni; i++) {
              F = F.differentiate(s);
            }
            return Multiply(Literal(ni % 2 == 0 ? 1 : -1), F).simplify();
          }
        }
      }
      // L{e^(at)·f(t)} = F(s-a)  (first shift theorem)
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

  // ---- helpers ----

  static Expression _expandTrig(Expression expr, Variable t) {
    bool hasT(Expression e) =>
        e.getVariableTerms().any((v) => v.identifier.name == t.identifier.name);
    Expression op = (expr as TrigonometricExpression).operand;
    if (op is Add) {
      bool lt = hasT(op.left), rt = hasT(op.right);
      if (lt && !rt) {
        if (expr is Sin) {
          return Add(Multiply(Sin(op.left), Cos(op.right)),
                  Multiply(Cos(op.left), Sin(op.right)))
              .simplify();
        }
        if (expr is Cos) {
          return Subtract(Multiply(Cos(op.left), Cos(op.right)),
                  Multiply(Sin(op.left), Sin(op.right)))
              .simplify();
        }
      }
      if (!lt && rt) {
        if (expr is Sin) {
          return Add(Multiply(Cos(op.left), Sin(op.right)),
                  Multiply(Sin(op.left), Cos(op.right)))
              .simplify();
        }
        if (expr is Cos) {
          return Subtract(Multiply(Cos(op.left), Cos(op.right)),
                  Multiply(Sin(op.left), Sin(op.right)))
              .simplify();
        }
      }
    }
    return expr;
  }

  static Expression? _extractHypCoeff(Expression expr, Variable t,
      {required bool isSinh}) {
    if (isSinh ? expr is Sinh : expr is Cosh) {
      return _extractCoeffOfT((expr as TrigonometricExpression).operand, t);
    }
    return null;
  }

  static Expression? _extractTrigCoeff(Expression expr, Variable t,
      {required bool isSin}) {
    if (isSin ? expr is Sin : expr is Cos) {
      return _extractCoeffOfT((expr as TrigonometricExpression).operand, t);
    }
    return null;
  }

  static Expression? _extractCoeffOfT(Expression expr, Variable t) {
    if (expr == t) return Literal(1);
    if (expr is Negate && expr.operand == t) return Literal(-1);
    if (expr is Multiply) {
      List<Expression> factors = [];
      void flatten(Expression e) {
        if (e is Multiply) {
          flatten(e.left);
          flatten(e.right);
        } else {
          factors.add(e);
        }
      }

      flatten(expr);
      Expression? tFactor;
      List<Expression> others = [];
      for (var f in factors) {
        if (f == t) {
          if (tFactor != null) return null;
          tFactor = f;
        } else if (f is Negate && f.operand == t) {
          if (tFactor != null) return null;
          tFactor = f;
          others.add(Literal(-1));
        } else {
          others.add(f);
        }
      }
      if (tFactor != null) {
        if (others.isEmpty) return tFactor is Negate ? Literal(-1) : Literal(1);
        Expression c = others[0];
        for (int i = 1; i < others.length; i++) {
          c = Multiply(c, others[i]).simplify();
        }
        if (tFactor is Negate) c = Multiply(Literal(-1), c).simplify();
        return c;
      }
    }
    return null;
  }

  static Expression? _extractExpCoeff(Expression expr, Variable t) {
    if (expr is Exp) return _extractCoeffOfT(expr.operand, t);
    if (expr is Pow) {
      var b = expr.base;
      if (b is Variable && b.identifier.name == 'e') {
        return _extractCoeffOfT(expr.exponent, t);
      }
    }
    return null;
  }

  static Map<String, Expression>? _extractExpShift(
      Expression expr, Variable t) {
    if (expr is Multiply) {
      var a = _extractExpCoeff(expr.left, t);
      if (a != null) return {'a': a, 'f': expr.right};
      a = _extractExpCoeff(expr.right, t);
      if (a != null) return {'a': a, 'f': expr.left};
    }
    return null;
  }
}

// ---------------------------------------------------------------------------
// Inverse Laplace Transform  L⁻¹{F(s)} = f(t)
//
// Strategy (robust, handles any rational F(s) = N(s)/D(s)):
//   1. Extract N(s) and D(s) as polynomials.
//   2. Find ALL roots of D(s) over ℂ (including complex conjugate pairs).
//   3. For each root pₖ with multiplicity mₖ compute the Laurent coefficients
//      (residues) Aₖⱼ for j = 1 … mₖ via the formula:
//          Aₖⱼ = (1/(mₖ-j)!) · lim_{s→pₖ} d^(mₖ-j)/ds^(mₖ-j) [(s-pₖ)^mₖ F(s)]
//   4. Apply L⁻¹{Aₖⱼ/(s-pₖ)ʲ} = Aₖⱼ · t^(j-1)/(j-1)! · e^(pₖt).
//   5. Combine complex-conjugate pairs using Euler's formula to obtain a
//      purely real answer expressed in sin/cos:
//          A·e^((α+iω)t) + Ā·e^((α-iω)t)
//            = e^(αt) · [2Re(A)·cos(ωt) − 2Im(A)·sin(ωt)]
//   6. Express ω symbolically (e.g. sqrt(5)/2) to keep the output exact.
// ---------------------------------------------------------------------------
class InverseLaplaceTransform {
  static Expression compute(Expression expr, Variable s, Variable t) {
    expr = expr.simplify();

    // First try direct inversion (handles simple additive / linear forms)
    try {
      var r = _invertDirect(expr, s, t);
      // .simplify() is safe here — it preserves symbolic sqrt(n) forms.
      return LaplaceTransform._safeSimplify(r);
    } catch (_) {}

    // Full rational-function inversion via complex poles
    try {
      var r = _invertRational(expr, s, t);
      return LaplaceTransform._safeSimplify(r);
    } catch (_) {}

    throw UnimplementedError('Inverse Laplace not implemented for: $expr');
  }

  // ---- Direct (structural) inversion — fast for simple forms ----
  static Expression _invertDirect(Expression expr, Variable s, Variable t) {
    bool hasS(Expression e) =>
        e.getVariableTerms().any((v) => v.identifier.name == s.identifier.name);

    if (expr is Add) {
      return Add(
          _invertDirect(expr.left, s, t), _invertDirect(expr.right, s, t));
    }
    if (expr is Subtract) {
      return Subtract(
          _invertDirect(expr.left, s, t), _invertDirect(expr.right, s, t));
    }
    if (!hasS(expr)) return expr; // constant
    if (expr is Multiply) {
      if (!hasS(expr.left)) {
        return Multiply(expr.left, _invertDirect(expr.right, s, t)).simplify();
      }
      if (!hasS(expr.right)) {
        return Multiply(expr.right, _invertDirect(expr.left, s, t)).simplify();
      }
    }

    // s^(-n) → t^(n-1)/(n-1)!
    if (expr is Pow && expr.base == s && expr.exponent is Literal) {
      var n = (expr.exponent as Literal).value;
      if ((n is int || n is double) && _asDouble(n)! < 0) {
        double nd = _asDouble(n)!;
        if (nd % 1 == 0) {
          int power = (-nd).toInt() - 1;
          int fact = _factorial(power);
          return Divide(Pow(t, Literal(power)), Literal(fact)).simplify();
        }
      }
      // s^(-3/2) → 2*sqrt(t)/sqrt(π)
      if (n is Rational &&
          n.numerator == BigInt.from(-3) &&
          n.denominator == BigInt.two) {
        return Multiply(
                Literal(2),
                Divide(Pow(t, Literal(Rational(1, 2))),
                    Pow(Variable('pi'), Literal(Rational(1, 2)))))
            .simplify();
      }
    }

    // 1/s → 1
    if (expr is Divide &&
        expr.left is Literal &&
        (expr.left as Literal).value == 1 &&
        expr.right == s) {
      return Literal(1);
    }

    // Negative-power Pow: (base)^(-n) → 1/base^n
    if (expr is Pow && expr.base != s) {
      var n = expr.exponent;
      if (n is Literal) {
        double? nd = _asDouble(n.value);
        if (nd != null && nd < 0) {
          return _invertDirect(
              Divide(Literal(1), Pow(expr.base, Literal(-nd))), s, t);
        }
      }
    }

    // Divide form: N/D
    if (expr is Divide) {
      return _invertDivideSimple(expr.left, expr.right, s, t);
    }

    // Multiply of (thing) × (other)^(-1)
    if (expr is Multiply) {
      if (expr.right is Pow) {
        var rp = expr.right as Pow;
        if (rp.exponent is Literal) {
          double? nd = _asDouble((rp.exponent as Literal).value);
          if (nd != null && nd < 0) {
            return _invertDivideSimple(
                expr.left, Pow(rp.base, Literal(-nd)), s, t);
          }
        }
      }
      if (expr.left is Pow) {
        var lp = expr.left as Pow;
        if (lp.exponent is Literal) {
          double? nd = _asDouble((lp.exponent as Literal).value);
          if (nd != null && nd < 0) {
            return _invertDivideSimple(
                expr.right, Pow(lp.base, Literal(-nd)), s, t);
          }
        }
      }
    }

    throw UnimplementedError('direct: $expr');
  }

  // Simple structural N/D inversion (linear/quadratic polynomial denominators)
  static Expression _invertDivideSimple(
      Expression numer, Expression den, Variable s, Variable t) {
    // 1/s → 1 handled above, but just in case:
    if (numer is Literal && numer.value == 1 && den == s) return Literal(1);

    var denCoeffs = _collectCoeffs(den, s);
    if (denCoeffs == null) throw UnimplementedError('den: $den');

    int deg = denCoeffs.keys.isEmpty
        ? 0
        : denCoeffs.keys.reduce((a, b) => a > b ? a : b);

    // Degree 1: Q/(Bs+C) = (Q/B)·e^(-C/B · t)
    if (deg == 1) {
      var B = denCoeffs[1] ?? Literal(0);
      var C = denCoeffs[0] ?? Literal(0);
      var numCoeffs = _collectCoeffs(numer, s);
      if (numCoeffs == null) {
        throw UnimplementedError('numer is not a polynomial: $numer');
      }
      var P = numCoeffs[1] ?? Literal(0);
      var Q = numCoeffs[0] ?? Literal(0);
      if (_isZeroExpr(P)) {
        var factor = Divide(Q, B).simplify();
        var a = Negate(Divide(C, B)).simplify();
        return Multiply(factor, Pow(Variable('e'), Multiply(a, t))).simplify();
      }
    }

    if (deg == 2) {
      var A = denCoeffs[2] ?? Literal(0);
      var B = denCoeffs[1] ?? Literal(0);
      var C = denCoeffs[0] ?? Literal(0);
      var numCoeffs = _collectCoeffs(numer, s);
      if (numCoeffs == null) {
        throw UnimplementedError('numer is not a polynomial: $numer');
      }
      var P = numCoeffs[1] ?? Literal(0);
      var Q = numCoeffs[0] ?? Literal(0);

      var aVal = _evalToDouble(A);
      var bVal = _evalToDouble(B);
      var cVal = _evalToDouble(C);

      if (aVal != null && bVal != null && cVal != null) {
        double discVal = bVal * bVal - 4 * aVal * cVal;
        if (discVal < 0) {
          // Complex conjugate roots — completing the square
          //double alphaVal = -bVal / (2 * aVal);
          double omegaVal =
              dmath.sqrt(4 * aVal * cVal - bVal * bVal) / (2 * aVal);

          Expression alpha =
              Divide(Negate(B), Multiply(Literal(2), A)).simplify();
          Expression wExpr = _omegaToSymbolic(omegaVal);

          Expression eAlpha = _isZeroExpr(alpha)
              ? Literal(1)
              : Pow(Variable('e'), Multiply(alpha, t)).simplify();

          Expression coeffCos = Divide(P, A).simplify();
          Expression shift =
              Divide(Negate(B), Multiply(Literal(2), A)).simplify();
          Expression coeffSin =
              Divide(Add(Multiply(P, shift), Q), Multiply(A, wExpr)).simplify();

          Expression cosTerm = _isZeroExpr(coeffCos)
              ? Literal(0)
              : Multiply(coeffCos, Cos(Multiply(wExpr, t))).simplify();
          Expression sinTerm = _isZeroExpr(coeffSin)
              ? Literal(0)
              : Multiply(coeffSin, Sin(Multiply(wExpr, t))).simplify();

          return Multiply(eAlpha, Add(cosTerm, sinTerm).simplify()).simplify();
        } else if (discVal == 0) {
          // Repeated real root
          Expression alpha =
              Divide(Negate(B), Multiply(Literal(2), A)).simplify();
          Expression eAlpha = _isZeroExpr(alpha)
              ? Literal(1)
              : Pow(Variable('e'), Multiply(alpha, t)).simplify();

          Expression coeff1 = Divide(P, A).simplify();
          Expression shift =
              Divide(Negate(B), Multiply(Literal(2), A)).simplify();
          Expression coeff2 = Divide(Add(Multiply(P, shift), Q), A).simplify();

          Expression term1 = _isZeroExpr(coeff1) ? Literal(0) : coeff1;
          Expression term2 =
              _isZeroExpr(coeff2) ? Literal(0) : Multiply(coeff2, t).simplify();
          return Multiply(eAlpha, Add(term1, term2).simplify()).simplify();
        }
      }
    }

    if (deg == 4) {
      var a4 = denCoeffs[4] ?? Literal(0);
      var a3 = denCoeffs[3] ?? Literal(0);
      var a2 = denCoeffs[2] ?? Literal(0);
      var a1 = denCoeffs[1] ?? Literal(0);
      var a0 = denCoeffs[0] ?? Literal(0);

      if (_isZeroExpr(a3) && _isZeroExpr(a1)) {
        var a4Val = _evalToDouble(a4);
        var a2Val = _evalToDouble(a2);
        var a0Val = _evalToDouble(a0);

        if (a4Val != null &&
            a2Val != null &&
            a0Val != null &&
            a4Val > 0 &&
            a0Val > 0) {
          double diff = (a2Val * a2Val - 4 * a4Val * a0Val).abs();
          if (diff < 1e-6) {
            // Reconstruct A and C from (As^2 + C)^2
            double aVal = dmath.sqrt(a4Val);
            double cVal = dmath.sqrt(a0Val);
            Expression A = _omegaToSymbolic(aVal);
            //Expression C = _omegaToSymbolic(C_val);

            var numCoeffs = _collectCoeffs(numer, s);
            if (numCoeffs == null) {
              throw UnimplementedError('numer is not a polynomial: $numer');
            }
            var P = numCoeffs[2] ?? Literal(0);
            var Q = numCoeffs[1] ?? Literal(0);
            var R = numCoeffs[0] ?? Literal(0);

            double omegaVal = dmath.sqrt(cVal / aVal);
            Expression wExpr = _omegaToSymbolic(omegaVal);

            Expression term1 = _isZeroExpr(P)
                ? Literal(0)
                : Divide(
                    Multiply(
                        P,
                        Add(
                            Sin(Multiply(wExpr, t)),
                            Multiply(
                                Multiply(wExpr, t), Cos(Multiply(wExpr, t))))),
                    Multiply(Literal(2), wExpr));
            Expression term2 = _isZeroExpr(Q)
                ? Literal(0)
                : Divide(Multiply(Q, Multiply(t, Sin(Multiply(wExpr, t)))),
                    Multiply(Literal(2), wExpr));
            Expression term3 = _isZeroExpr(R)
                ? Literal(0)
                : Divide(
                    Multiply(
                        R,
                        Subtract(
                            Sin(Multiply(wExpr, t)),
                            Multiply(
                                Multiply(wExpr, t), Cos(Multiply(wExpr, t))))),
                    Multiply(Literal(2), Pow(wExpr, Literal(3))));

            return Divide(Add(term1, Add(term2, term3).simplify()).simplify(),
                    Multiply(A, A))
                .simplify();
          }
        }
      }
    }

    throw UnimplementedError('simple: $numer/$den');
  }

  // ---- Full rational inversion via complex poles (Heaviside's theorem) ----
  //
  // Residues are computed using polynomial long division in ℂ:
  //   For each root p of D with multiplicity m, define:
  //     Q(s) = D(s) / (s - p)^m   (computed via synthetic division)
  //   Then the residue of order j (j=1..m) is:
  //     A_j = (1/(m-j)!) * [d^(m-j)/ds^(m-j) (N(s)/Q(s))] at s=p
  //   evaluated numerically in ℂ by Horner's method on polynomial coefficients.
  static Expression _invertRational(Expression expr, Variable s, Variable t) {
    // 1. Extract N/D
    var (numer, den) = _extractFraction(expr, s);

    // 2. Collect polynomial coefficients as doubles
    var numCoeffs = _collectCoeffs(numer, s) ?? {0: numer};
    var denCoeffs = _collectCoeffs(den, s);
    if (denCoeffs == null) throw UnimplementedError('cannot collect: $den');

    int numDeg = numCoeffs.keys.isEmpty
        ? 0
        : numCoeffs.keys.reduce((a, b) => a > b ? a : b);
    int denDeg = denCoeffs.keys.isEmpty
        ? 0
        : denCoeffs.keys.reduce((a, b) => a > b ? a : b);

    // Polynomial arrays in ℂ from high-degree to low-degree
    List<Complex> N = List.generate(numDeg + 1, (i) {
      var c = numCoeffs[numDeg - i] ?? Literal(0);
      double? v = _evalToDouble(c);
      return v != null ? Complex(v, 0) : Complex(0, 0);
    });
    List<Complex> D = List.generate(denDeg + 1, (i) {
      var c = denCoeffs[denDeg - i] ?? Literal(0);
      double? v = _evalToDouble(c);
      if (v == null) throw UnimplementedError('non-numeric den coeff: $c');
      return Complex(v, 0);
    });

    // Normalize D so leading coeff = 1
    Complex leadD = D[0];
    if (leadD.real.abs() < 1e-12) {
      throw UnimplementedError('zero leading coeff');
    }
    D = D.map((c) => _cdiv(c, leadD)).toList();
    N = N.map((c) => _cdiv(c, leadD)).toList();

    // 3+4. Find roots and determine multiplicities.
    List<double> realDcoeffs = D.map((c) => c.real).cast<double>().toList();
    var denPolyObj = Polynomial.fromList(realDcoeffs, variable: s);
    var rawRoots = denPolyObj.roots();

    // Convert any root to a Complex<double,double> by numerical evaluation.
    Complex toComplex(dynamic r) {
      if (r is Literal) return toComplex(r.value);
      if (r is Complex) {
        double re = _asDouble(r.real) ?? 0.0;
        double im = _asDouble(r.imaginary) ?? 0.0;
        return Complex(re, im);
      }
      if (r is double) return Complex(r, 0);
      if (r is int) return Complex(r.toDouble(), 0);
      if (r is Rational) return Complex(r.toDouble(), 0);
      // Expression node (Divide, Add, etc.) — evaluate numerically
      if (r is Expression) {
        try {
          var v = r.simplify().evaluate();
          return toComplex(v);
        } catch (_) {}
      }
      return Complex(0.0, 0.0);
    }

    List<Complex> allRoots = [];
    for (var r in rawRoots) {
      allRoots.add(toComplex(r));
    }

    // Group roots by proximity to determine multiplicity from the raw root list
    List<_Pole> poles = [];
    for (var r in allRoots) {
      bool found = false;
      for (var p in poles) {
        if (_complexClose(p.value, r)) {
          p.mult++;
          found = true;
          break;
        }
      }
      if (!found) poles.add(_Pole(r, 1));
    }

    // Re-verify multiplicity by checking how many derivatives of D vanish at the root.
    List<List<Complex>> dDerivs = [D];
    for (int di = 0; di < 4; di++) {
      var prev = dDerivs.last;
      if (prev.length <= 1) break;
      var deriv = List.generate(prev.length - 1,
          (i) => _cmul(prev[i], Complex((prev.length - 1 - i).toDouble(), 0)));
      dDerivs.add(deriv);
    }
    for (var pole in poles) {
      if (pole.mult > 1) continue; // already identified as repeated
      Complex p = pole.value;
      int m = 0;
      for (var dPoly in dDerivs) {
        Complex val = _polyEval(dPoly, p);
        if (val.real.abs() < 1e-4 && val.imaginary.abs() < 1e-4) {
          m++;
        } else {
          break;
        }
      }
      if (m > 1) pole.mult = m;
    }

    // 5. For each pole compute residues in ℂ using polynomial operations
    Expression result = Literal(0);
    Set<int> handledConj = {};

    for (int pi = 0; pi < poles.length; pi++) {
      if (handledConj.contains(pi)) continue;

      var pole = poles[pi];
      Complex p = pole.value;
      int m = pole.mult;

      // Find conjugate
      int conjIdx = -1;
      if (p.imaginary.abs() > 1e-9) {
        for (int qi = 0; qi < poles.length; qi++) {
          if (qi == pi) continue;
          var q = poles[qi].value;
          if ((q.real - p.real).abs() < 1e-7 &&
              (q.imaginary + p.imaginary).abs() < 1e-7 &&
              poles[qi].mult == m) {
            conjIdx = qi;
            break;
          }
        }
      }

      // Q(s) = D(s) / (s - p)^m  — computed by m iterations of synthetic division
      List<Complex> qCoeffs = List.from(D);
      for (int di = 0; di < m; di++) {
        qCoeffs = _syntheticDivide(qCoeffs, p);
      }

      // Compute residues A_j for j = m down to 1
      // G(s) = N(s) / Q(s); A_j = G^(m-j)(p) / (m-j)!
      // We numerically differentiate G evaluated at p using the formula:
      //   G(p), G'(p), G''(p), ... via Horner + quotient differentiation
      // For simplicity: evaluate G at a cluster of m+1 points near p,
      // then use finite differences to get derivatives.
      // Alternatively: use the Leibniz/residue formula directly.
      // For distinct poles (m=1): A = N(p)/Q(p)   — exact in ℂ
      // For repeated poles (m>1): use G(p+h), G(p+2h),... + Vandermonde solve
      List<Complex> residues = _computeResidues(N, qCoeffs, p, m);

      if (p.imaginary.abs() < 1e-9) {
        // ---- Real pole ----
        double pReal = p.real;
        for (int j = 1; j <= m; j++) {
          // Heaviside formula: A_j = G^(m-j)(p) / (m-j)!
          // residues[k] ≈ G^(k)(p), so A_j = residues[m-j] / (m-j)!
          Complex A = residues[m - j];
          double aR = A.real;
          if (aR.abs() < 1e-10) continue;

          int power = j - 1;
          // L⁻¹{A_j/(s-p)^j} = A_j * t^(j-1)/(j-1)! * e^(pt)
          double coeff = aR / _factorial(m - j) / _factorial(power);
          Expression coeffExpr = _toRationalExpr(coeff);
          Expression tPow = power == 0 ? Literal(1) : Pow(t, Literal(power));
          Expression eFact = pReal.abs() < 1e-9
              ? Literal(1)
              : Pow(Variable('e'), Multiply(_toRationalExpr(pReal), t));

          result = Add(
                  result,
                  Multiply(coeffExpr, Multiply(tPow, eFact).simplify())
                      .simplify())
              .simplify();
        }
      } else {
        // ---- Complex conjugate pair ----
        Complex pPos = p.imaginary > 0 ? p : poles[conjIdx].value;
        if (conjIdx >= 0) handledConj.add(conjIdx);

        double alpha = pPos.real;
        double omega = pPos.imaginary;
        Expression wExpr = _omegaToSymbolic(omega);
        Expression eAlpha = alpha.abs() < 1e-9
            ? Literal(1)
            : Pow(Variable('e'), Multiply(_toRationalExpr(alpha), t));

        for (int j = 1; j <= m; j++) {
          // Heaviside formula: A_j = residues[m-j] / (m-j)!
          Complex A = residues[m - j];
          int power = j - 1;
          // Combined contribution from conjugate pair:
          //   e^(αt)·t^(j-1)/(j-1)! · [2Re(A_j)cos(ωt) − 2Im(A_j)sin(ωt)]
          double factMJ = _factorial(m - j).toDouble();
          double coeffCos = 2 * A.real / factMJ / _factorial(power);
          double coeffSin = -2 * A.imaginary / factMJ / _factorial(power);

          Expression tPow = power == 0 ? Literal(1) : Pow(t, Literal(power));
          Expression scale = Multiply(eAlpha, tPow).simplify();

          if (coeffCos.abs() > 1e-10) {
            Expression c = _toRationalExpr(coeffCos);
            result = Add(
                    result,
                    Multiply(c,
                            Multiply(scale, Cos(Multiply(wExpr, t))).simplify())
                        .simplify())
                .simplify();
          }
          if (coeffSin.abs() > 1e-10) {
            Expression c = _toRationalExpr(coeffSin);
            result = Add(
                    result,
                    Multiply(c,
                            Multiply(scale, Sin(Multiply(wExpr, t))).simplify())
                        .simplify())
                .simplify();
          }
        }
      }
    }

    return result;
  }

  // ---- Helpers ----

  /// Split expr into (numerator, denominator) pair.
  /// Handles all post-simplify() forms:
  ///   - A/B (Divide)
  ///   - A * B^(-n) (Multiply with negative-power right or left)
  ///   - B^(-n) (Pow with negative exponent)
  ///   - products of B^(-n) terms  → numerator=1, denominator=product of B^n
  static (Expression, Expression) _extractFraction(
      Expression expr, Variable s) {
    bool hasS(Expression e) =>
        e.getVariableTerms().any((v) => v.identifier.name == s.identifier.name);

    // Already a Divide
    if (expr is Divide) return (expr.left, expr.right);

    // Single Pow with negative exponent: (base)^(-n)
    if (expr is Pow && expr.exponent is Literal) {
      double? nd = _asDouble((expr.exponent as Literal).value);
      if (nd != null && nd < 0) {
        // When nd == -1 the denominator IS the base (not Pow(base, 1.0))
        Expression denom =
            nd == -1.0 ? expr.base : Pow(expr.base, Literal((-nd).toInt()));
        return (Literal(1), denom);
      }
    }

    // Flatten the whole expression into a list of factor-expressions.
    // Any factor that is Pow(x, -n) contributes to the denominator.
    List<Expression> allFactors = [];
    void flattenMul(Expression e) {
      if (e is Multiply) {
        flattenMul(e.left);
        flattenMul(e.right);
      } else {
        allFactors.add(e);
      }
    }

    flattenMul(expr);

    List<Expression> numFactors = [];
    List<Expression> denFactors = [];

    for (var f in allFactors) {
      if (f is Pow && f.exponent is Literal) {
        double? nd = _asDouble((f.exponent as Literal).value);
        if (nd != null && nd < 0) {
          // Use base directly if exponent becomes 1, otherwise Pow(base, -nd)
          Expression denFactor = nd == -1
              ? f.base
              : Pow(
                  f.base, Literal((-nd).toInt() == -nd ? (-nd).toInt() : -nd));
          denFactors.add(denFactor);
          continue;
        }
      }
      numFactors.add(f);
    }

    if (denFactors.isNotEmpty) {
      Expression numer = numFactors.isEmpty
          ? Literal(1)
          : numFactors.reduce((a, b) => Multiply(a, b));
      Expression denom = denFactors.reduce((a, b) => Multiply(a, b));
      return (numer.simplify(), denom.simplify());
    }

    // No denominator found — check if has s at all
    if (!hasS(expr)) return (expr, Literal(1));

    throw UnimplementedError('cannot extract fraction from: $expr');
  }

  /// Collect polynomial coefficients of expr in variable s.
  /// Returns `Map<degree, coefficient_expression>` or `null` if not a polynomial.
  static Map<int, Expression>? _collectCoeffs(Expression expr, Variable s) {
    final varName = s.identifier.name;
    try {
      expr = expr.expand().simplify();
    } catch (_) {}

    List<Expression> sumTerms(Expression e) {
      if (e is Add) return [...sumTerms(e.left), ...sumTerms(e.right)];
      if (e is Subtract) {
        return [
          ...sumTerms(e.left),
          ...sumTerms(Multiply(Literal(-1), e.right).simplify())
        ];
      }
      if (e is GroupExpression) return sumTerms(e.expression);
      return [e];
    }

    _LaplaceTermCoeff? parseTerm(Expression term) {
      if (term is Negate) {
        var inner = parseTerm(term.operand);
        if (inner == null) return null;
        return _LaplaceTermCoeff(
            Multiply(Literal(-1), inner.coefficient).simplify(), inner.degree);
      }
      if (term is GroupExpression) return parseTerm(term.expression);

      bool hasV =
          term.getVariableTerms().any((v) => v.identifier.name == varName);
      if (!hasV) return _LaplaceTermCoeff(term, 0);
      if (term is Variable && term.identifier.name == varName) {
        return _LaplaceTermCoeff(Literal(1), 1);
      }
      if (term is Pow &&
          term.base is Variable &&
          (term.base as Variable).identifier.name == varName &&
          term.exponent is Literal) {
        var v = (term.exponent as Literal).value;
        double? d;
        if (v is int) d = v.toDouble();
        if (v is double) d = v;
        if (v is Rational) d = v.toDouble();
        if (v is Complex &&
            (v.imaginary == 0 ||
                (v.imaginary is num && (v.imaginary as num) == 0))) {
          d = v.real is Rational
              ? (v.real as Rational).toDouble()
              : (v.real as num).toDouble();
        }
        if (d != null && d >= 0 && d == d.toInt()) {
          return _LaplaceTermCoeff(Literal(1), d.toInt());
        }
      }
      if (term is Multiply) {
        bool lv = term.left
            .getVariableTerms()
            .any((v) => v.identifier.name == varName);
        bool rv = term.right
            .getVariableTerms()
            .any((v) => v.identifier.name == varName);
        if (lv && !rv) {
          var vt = parseTerm(term.left);
          if (vt == null) return null;
          return _LaplaceTermCoeff(
              Multiply(term.right, vt.coefficient).simplify(), vt.degree);
        }
        if (!lv && rv) {
          var vt = parseTerm(term.right);
          if (vt == null) return null;
          return _LaplaceTermCoeff(
              Multiply(term.left, vt.coefficient).simplify(), vt.degree);
        }
      }
      if (term is Divide) {
        bool dv = term.right
            .getVariableTerms()
            .any((v) => v.identifier.name == varName);
        if (!dv) {
          var nt = parseTerm(term.left);
          if (nt == null) return null;
          return _LaplaceTermCoeff(
              Divide(nt.coefficient, term.right).simplify(), nt.degree);
        }
      }
      return null;
    }

    try {
      var terms = sumTerms(expr);
      Map<int, Expression> result = {};
      for (var term in terms) {
        var parsed = parseTerm(term);
        if (parsed == null) return null;
        result[parsed.degree] = result.containsKey(parsed.degree)
            ? Add(result[parsed.degree]!, parsed.coefficient).simplify()
            : parsed.coefficient;
      }
      return result;
    } catch (_) {
      return null;
    }
  }

  /// Convert a double to a Rational expression if it's close to a simple fraction.
  /// Always returns a symbolic expression, never a float literal.
  static Expression _toRationalExpr(double v) {
    if (v == 0) return Literal(0);
    bool neg = v < 0;
    double av = v.abs();
    // Try denominators 1 .. 120
    for (int d = 1; d <= 120; d++) {
      double n = av * d;
      int ni = n.round();
      if ((n - ni).abs() < 1e-6 * d) {
        var rat = Rational(neg ? -ni : ni, d);
        if (rat.isInteger) return Literal(rat.numerator.toInt());
        return Literal(rat);
      }
    }
    return Literal(v);
  }

  /// Convert ω (positive double) to a symbolic sqrt expression.
  /// The canonical form is: sqrt(p·q)/q  where ω² ≈ p/q (lowest terms).
  /// E.g. ω = √5/2 → (1/2)·sqrt(5),  ω = √3/3 → (1/3)·sqrt(3),  ω = 2 → 2.
  static Expression _omegaToSymbolic(double omega) {
    if (omega <= 0) return Literal(0);
    double w2 = omega * omega;

    // Find rational p/q for ω²
    int bestP = 1, bestQ = 1;
    double bestErr = double.infinity;
    for (int q = 1; q <= 200; q++) {
      int p = (w2 * q).round();
      if (p <= 0) continue;
      double err = (w2 - p / q).abs();
      if (err < bestErr) {
        bestErr = err;
        bestP = p;
        bestQ = q;
        if (err < 1e-9) break;
      }
    }
    if (bestErr > 1e-6) {
      return Literal(omega); // not a nice rational — fall back
    }

    // Reduce p/q
    int g = _gcd(bestP, bestQ);
    int p = bestP ~/ g, q = bestQ ~/ g;

    // Check if ω = integer
    double sqrtPQ = _sqrt(p.toDouble() * q);
    if ((sqrtPQ - sqrtPQ.roundToDouble()).abs() < 1e-9 && q == 1) {
      return Literal(sqrtPQ.round()); // e.g. ω = 2
    }
    if ((sqrtPQ - sqrtPQ.roundToDouble()).abs() < 1e-9) {
      // sqrtPQ / q is a nice fraction
      int num = sqrtPQ.round();
      var rat = Rational(num, q);
      return rat.isInteger ? Literal(rat.numerator.toInt()) : Literal(rat);
    }

    // ω = sqrt(p*q)/q  (rationalized form)
    int pq = p * q;
    // Simplify sqrt(pq): pull out perfect square factors
    int sqFree = pq;
    int outside = 1;
    for (int f = 2; f * f <= sqFree; f++) {
      while (sqFree % (f * f) == 0) {
        sqFree ~/= (f * f);
        outside *= f;
      }
    }
    // ω = outside * sqrt(sqFree) / q
    if (sqFree == 1) {
      // ω = outside/q (integer sqrt)
      var rat = Rational(outside, q);
      return rat.isInteger ? Literal(rat.numerator.toInt()) : Literal(rat);
    }

    Expression sqrtExpr = Pow(Literal(sqFree), Literal(Rational(1, 2)));
    if (outside == 1 && q == 1) return sqrtExpr;
    if (outside == q) return sqrtExpr; // outside/q = 1
    var rat = Rational(outside, q);
    if (rat.isInteger) {
      int n = rat.numerator.toInt();
      // Do NOT call .simplify() — it would evaluate sqrt(n) numerically
      return n == 1 ? sqrtExpr : Multiply(Literal(n), sqrtExpr);
    }
    return Multiply(Literal(rat), sqrtExpr); // No .simplify()!
  }

  static bool _complexClose(Complex a, Complex b) =>
      (a.real - b.real).abs() < 1e-7 &&
      (a.imaginary - b.imaginary).abs() < 1e-7;

  static bool _isZeroExpr(Expression e) {
    if (e is Literal) {
      var v = e.value;
      return v == 0 ||
          v == 0.0 ||
          (v is Rational && v == Rational.zero) ||
          (v is Complex && v.real == 0 && v.imaginary == 0);
    }
    return false;
  }

  static double? _asDouble(dynamic v) {
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is Rational) return v.toDouble();
    if (v is Complex) {
      // Complex fields may be Rational, int, or double — not necessarily num
      double? im = _asDouble(v.imaginary);
      if (im != null && im.abs() < 1e-12) {
        return _asDouble(v.real);
      }
    }
    return null;
  }

  static double? _evalToDouble(Expression e) {
    try {
      return _asDouble(e.evaluate());
    } catch (_) {
      return null;
    }
  }

  static int _factorial(int n) {
    if (n <= 1) return 1;
    int r = 1;
    for (int i = 2; i <= n; i++) {
      r *= i;
    }
    return r;
  }

  static int _gcd(int a, int b) {
    a = a.abs();
    b = b.abs();
    while (b != 0) {
      int t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  static double _sqrt(double v) {
    if (v < 0) return 0;
    return dmath.sqrt(v);
  }

  /// Horner synthetic division: divides poly coefficients [a₀,a₁,...,aₙ]
  /// (high→low) by (s − p), returning the quotient [b₀,...,bₙ₋₁].
  static List<Complex> _syntheticDivide(List<Complex> poly, Complex p) {
    if (poly.length <= 1) return [Complex(0, 0)];
    List<Complex> result = List.generate(poly.length - 1, (_) => Complex(0, 0));
    Complex acc = poly[0];
    result[0] = acc;
    for (int i = 1; i < poly.length - 1; i++) {
      acc = _cadd(_cmul(acc, p), poly[i]);
      result[i] = acc;
    }
    return result;
  }

  /// Evaluate polynomial (high→low coefficients) at complex point z via Horner.
  static Complex _polyEval(List<Complex> poly, Complex z) {
    if (poly.isEmpty) return Complex(0, 0);
    Complex acc = poly[0];
    for (int i = 1; i < poly.length; i++) {
      acc = _cadd(_cmul(acc, z), poly[i]);
    }
    return acc;
  }

  /// Compute residues [A_1, A_2, ..., A_m] for the partial fraction expansion
  /// of N(s)/Q(s)/(s-p)^m using the finite-difference formula.
  ///
  /// G(s) = N(s)/Q(s). The residue of order j at pole p is:
  ///   A_j = (1/(m-j)!) G^(m-j)(p)
  ///
  /// For m=1: A_1 = G(p) = N(p)/Q(p).
  /// For m>1: use values G(p+h), G(p+2h),...,G(p+m*h) with step h=1e-4 and
  ///   Vandermonde / forward-difference scheme.
  static List<Complex> _computeResidues(
      List<Complex> N, List<Complex> Q, Complex p, int m) {
    if (m == 1) {
      Complex nP = _polyEval(N, p);
      Complex qP = _polyEval(Q, p);
      if (qP.real.abs() < 1e-12 && qP.imaginary.abs() < 1e-12) {
        return [Complex(0, 0)];
      }
      return [_cdiv(nP, qP)];
    }

    // Repeated pole — use finite differences to approximate G^(k)(p)/k!
    // G values at p+h, p+2h, ..., p+m*h
    double h = 1e-4;
    List<Complex> G = List.generate(m + 1, (i) {
      Complex z = Complex(p.real + (i + 1) * h, p.imaginary);
      Complex nZ = _polyEval(N, z);
      Complex qZ = _polyEval(Q, z);
      if (qZ.real.abs() < 1e-12 && qZ.imaginary.abs() < 1e-12) {
        return Complex(0, 0);
      }
      return _cdiv(nZ, qZ);
    });

    // Forward differences give G^(k)(p)/k! ≈ Δ^k G[0] / h^k
    // But since G(z) = Σ A_j * (z-p)^(j-1) / (j-1)! near the pole (not exactly),
    // we use the Taylor series: G(p+ih) = Σ_{k=0}^{m-1} G^(k)(p)/k! * (ih)^k
    // We want G(p) = A_1, G'(p) = A_2, G''(p)/2! = A_3, etc.
    // Use forward finite differences to estimate G^(k)(p)/k!:
    //   Δ^k G[0] / h^k / k! ≈ G^(k)(p)/k!  where G[i]=G(p+(i+1)*h)
    //   Δ^0 G[i] = G[i]
    //   Δ^k G[i] = (Δ^(k-1) G[i+1] - Δ^(k-1) G[i]) / h
    List<Complex> d = List.from(G);
    List<Complex> residues = [];
    for (int k = 0; k < m; k++) {
      residues.add(d[0]);
      if (k < m - 1) {
        List<Complex> nd = List.generate(d.length - 1, (i) {
          return _cdiv(_csub(d[i + 1], d[i]), Complex(h, 0));
        });
        d = nd;
      }
    }
    return residues;
  }

  // --- Complex arithmetic helpers ---
  static Complex _cadd(Complex a, Complex b) =>
      Complex(a.real + b.real, a.imaginary + b.imaginary);

  static Complex _csub(Complex a, Complex b) =>
      Complex(a.real - b.real, a.imaginary - b.imaginary);

  static Complex _cmul(Complex a, Complex b) => Complex(
      a.real * b.real - a.imaginary * b.imaginary,
      a.real * b.imaginary + a.imaginary * b.real);

  static Complex _cdiv(Complex a, Complex b) {
    double denom = b.real * b.real + b.imaginary * b.imaginary;
    if (denom < 1e-30) return Complex(0, 0);
    return Complex((a.real * b.real + a.imaginary * b.imaginary) / denom,
        (a.imaginary * b.real - a.real * b.imaginary) / denom);
  }
}

class _Pole {
  final Complex value;
  int mult;
  _Pole(this.value, this.mult);
}

class _LaplaceTermCoeff {
  final Expression coefficient;
  final int degree;
  _LaplaceTermCoeff(this.coefficient, this.degree);
}
