part of '../../expression.dart';

class Subtract extends BinaryOperationsExpression {
  Subtract(super.left, super.right);

  @override
  dynamic evaluate([dynamic arg]) {
    dynamic leftEval = left.evaluate(arg);
    dynamic rightEval = right.evaluate(arg);

    // Convert num to Literal if the other operand is an Expression
    leftEval = convertToLiteralIfNeeded(leftEval, rightEval);
    rightEval = convertToLiteralIfNeeded(rightEval, leftEval);

    // If both evaluate to numbers, return the sum as a number
    if (leftEval is num && rightEval is num) {
      return leftEval - rightEval;
    }

    // If x is null and either operand contains a Variable, return the simplified version of the expression
    if (arg == null && (_containsVariable(left) || _containsVariable(right))) {
      return simplify();
    }

    // At this point, both operands should be Expression types that support the + operator.
    // If they aren't, there's likely a mismatch or unsupported scenario.
    if (leftEval is Expression && rightEval is Expression) {
      return Subtract(leftEval, rightEval).simplify();
    }

    // Default return (should ideally never reach this point)
    // throw Exception('Unsupported evaluation scenario in Subtract.evaluate');
    return simplify();
  }

// Helper method to check if an expression contains a Variable
  bool _containsVariable(Expression expr) {
    if (expr is Variable) {
      return true;
    } else if (expr is BinaryOperationsExpression) {
      return _containsVariable(expr.left) || _containsVariable(expr.right);
    }
    return false;
  }

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
      } else if (leftVal is Complex && rightVal is num) {
        return Literal(leftVal - Complex(rightVal, 0));
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
    Map<String, dynamic> likeTerms = {};
    dynamic constantTerm = 0;
    for (var term in terms) {
      if (term is Literal) {
        var val = term.evaluate();
        if (constantTerm is num && val is Complex) {
          constantTerm = val + constantTerm;
        } else {
          constantTerm += val;
        }
      } else if (term is Variable) {
        likeTerms.update(
          term.toString(),
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      } else if (term is Multiply && term.left is Literal) {
        String variablePart = term.right.toString();
        dynamic coefficient = (term.left as Literal).evaluate();
        likeTerms.update(
          variablePart,
          (value) {
            if (value is num && coefficient is Complex) {
              return coefficient + value;
            }
            return value + coefficient;
          },
          ifAbsent: () => coefficient,
        );
      }
      // Handle terms of type x^2y, x^3, etc.
      else if (term is Multiply || term is Pow) {
        likeTerms.update(
          term.toString(),
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
    }

    // Reconstruct the simplified expression from the likeTerms map and constant term
    List<Expression> simplifiedTerms = [];
    if (constantTerm != 0) {
      simplifiedTerms.add(Literal(constantTerm));
    }

    for (var entry in likeTerms.entries) {
      if (entry.value == 1) {
        simplifiedTerms.add(Expression.parse(entry.key));
      } else {
        simplifiedTerms
            .add(Multiply(Literal(entry.value), Expression.parse(entry.key)));
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
