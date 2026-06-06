part of '../../expression.dart';

class Subtract extends BinaryOperationsExpression {
  Subtract(super.left, super.right);

  @override
  dynamic evaluate([dynamic arg]) {
    dynamic leftEval = left.evaluate(arg);
    dynamic rightEval = right.evaluate(arg);

    if (leftEval is Expression || rightEval is Expression) {
      return Subtract(
        leftEval is Expression ? leftEval : Literal(leftEval),
        rightEval is Expression ? rightEval : Literal(rightEval),
      ).simplify();
    }

    if (leftEval is Matrix) {
      return (leftEval - rightEval);
    }
    if (rightEval is Matrix) {
      return (leftEval - rightEval);
    }
    
    if ((leftEval is num || leftEval is Complex || leftEval is Rational) &&
        (rightEval is num || rightEval is Complex || rightEval is Rational)) {
      return _normalizeResult(Complex(leftEval) - Complex(rightEval));
    }
    
    dynamic result = Subtract(Literal(leftEval), Literal(rightEval)).simplify();
    return _normalizeResult(result);
  }

// // Helper method to check if an expression contains a Variable
//   bool _containsVariable(Expression expr) {
//     if (expr is Variable) {
//       return true;
//     } else if (expr is BinaryOperationsExpression) {
//       return _containsVariable(expr.left) || _containsVariable(expr.right);
//     }
//     return false;
//   }

  @override
  Expression differentiate([Variable? v]) {
    // The derivative of a difference is the difference of the derivatives.
    return Subtract(left.differentiate(v), right.differentiate(v));
  }

  @override
  Expression integrate() {
    // The integral of a difference is the difference of the integrals.
    return Subtract(left.integrate(), right.integrate());
  }

  @override
  Expression simplifyBasic() {
    Expression simplifiedLeft = left.simplify();
    Expression simplifiedRight = right.simplify();

    // If both operands are literals, evaluate and return a new Literal.
    if (simplifiedLeft is Literal && simplifiedRight is Literal) {
      var leftVal = simplifiedLeft.evaluate();
      var rightVal = simplifiedRight.evaluate();
      if (leftVal is num && rightVal is Complex) {
        return Literal(Complex(leftVal, 0) - rightVal);
      }
      if (leftVal is Complex || rightVal is Complex) {
        return Literal(Complex(leftVal) - Complex(rightVal)).simplify();
      }
      if (leftVal is Rational || rightVal is Rational) {
        return Literal(Rational(leftVal) - Rational(rightVal));
      }
      return Literal(leftVal - rightVal);
    }

    // Check if one of the operands is 0 (identity for addition).
    // Identity Element
    if (simplifiedRight is Literal && simplifiedRight.evaluate() == 0) {
      return simplifiedLeft;
    }
    if (simplifiedLeft is Literal && simplifiedLeft.evaluate() == 0) {
      return Multiply(Literal(-1), simplifiedRight).simplify();
    }

    // Negation
    if (simplifiedLeft.toString() == simplifiedRight.toString()) {
      return Literal(0);
    }

    // Flattening nested subtractions and additions
    List<Expression> terms = [];
    void flatten(Expression expr, bool negate) {
      if (expr is Add) {
        flatten(expr.left, negate);
        flatten(expr.right, negate);
      } else if (expr is Subtract) {
        flatten(expr.left, negate);
        flatten(expr.right, !negate);
      } else {
        if (negate) {
          terms.add(Multiply(Literal(-1), expr).simplify());
        } else {
          terms.add(expr);
        }
      }
    }

    flatten(simplifiedLeft, false);
    flatten(simplifiedRight, true);

    // Grouping like terms and constants
    // likeTerms maps string key -> coefficient
    // termExpressions maps string key -> canonical Expression (avoids re-parsing)
    Map<String, dynamic> likeTerms = {};
    Map<String, Expression> termExpressions = {};
    dynamic constantTerm = 0;

    // Helper for safe addition of numeric, rational, and complex types
    dynamic addValues(dynamic a, dynamic b) {
      if (a is Complex || b is Complex) {
        return Complex(a) + Complex(b);
      }
      if (a is Rational || b is Rational) {
        return Rational(a) + Rational(b);
      }
      return a + b;
    }

    void registerTerm(Expression termExpr, String key, dynamic coeff) {
      termExpressions.putIfAbsent(key, () => termExpr);
      likeTerms.update(key, (value) => addValues(value, coeff),
          ifAbsent: () => coeff);
    }

    for (var term in terms) {
      if (term is Literal) {
        var val = term.evaluate();
        constantTerm = addValues(constantTerm, val);
      } else if (term is Variable) {
        registerTerm(term, term.toString(), 1);
      } else if (term is Multiply && term.left is Literal) {
        final coefficient = (term.left as Literal).evaluate();
        registerTerm(term.right, term.right.toString(), coefficient);
      } else if (term is Multiply || term is Pow) {
        registerTerm(term, term.toString(), 1);
      } else {
        // Fallback for other types (e.g., CallExpression, UnaryExpression)
        registerTerm(term, term.toString(), 1);
      }
    }

    bool isZeroVal(dynamic val) {
      if (val is num) return val == 0;
      if (val is Rational) return val == Rational.zero;
      if (val is Complex) return val.real == 0 && val.imaginary == 0;
      return false;
    }

    bool isOneVal(dynamic val) {
      if (val is num) return val == 1;
      if (val is Rational) return val == Rational.one;
      if (val is Complex) return val.real == 1 && val.imaginary == 0;
      return false;
    }

    bool isMinusOneVal(dynamic val) {
      if (val is num) return val == -1;
      if (val is Rational) return val == Rational.fromInt(-1);
      if (val is Complex) return val.real == -1 && val.imaginary == 0;
      return false;
    }

    // Reconstruct the simplified expression from the likeTerms map and constant term
    List<Expression> simplifiedTerms = [];
    if (!isZeroVal(constantTerm)) {
      simplifiedTerms.add(Literal(constantTerm));
    }

    for (var entry in likeTerms.entries) {
      final val = entry.value;
      if (isZeroVal(val)) continue;
      // Retrieve the stored Expression object; fall back to parsing only if missing
      final termExpr = termExpressions[entry.key];
      Expression baseExpr;
      try {
        baseExpr = termExpr ?? Expression.parse(entry.key);
      } catch (_) {
        // If parse also fails, skip this term rather than crash
        continue;
      }
      if (isOneVal(val)) {
        simplifiedTerms.add(baseExpr);
      } else if (isMinusOneVal(val)) {
        simplifiedTerms.add(Multiply(Literal(-1), baseExpr));
      } else {
        simplifiedTerms.add(Multiply(Literal(val), baseExpr));
      }
    }

    // If there's no term left after simplification, return 0.
    if (simplifiedTerms.isEmpty) {
      return Literal(0);
    }

    // If there's only one term left after simplification, return it directly
    if (simplifiedTerms.length == 1) {
      return simplifiedTerms.first;
    }

    // Construct the final expression
    Expression simplifiedExpression = simplifiedTerms.first;
    for (int i = 1; i < simplifiedTerms.length; i++) {
      simplifiedExpression = Add(simplifiedExpression, simplifiedTerms[i]);
    }

    return simplifiedExpression;
  }

  @override
  Expression expand() {
    return Subtract(left.expand(), right.expand());
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    return Subtract(
      left.substitute(oldExpr, newExpr),
      right.substitute(oldExpr, newExpr),
    );
  }

  @override
  String toString() {
    var leftStr = left.toString();
    var rightStr = right.toString();

    // If right is Add or Subtract, wrap in parens (subtraction is not associative)
    // a - (b + c) != a - b + c
    // a - (b - c) != a - b - c
    if (right is Add || right is Subtract) {
      rightStr = '($rightStr)';
    }

    return "$leftStr-$rightStr";
  }
}
