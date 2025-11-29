// Sum.dart

part of '../../expression.dart';

class Add extends BinaryOperationsExpression {
  Add(super.left, super.right);

  @override
  dynamic evaluate([dynamic arg]) {
    dynamic leftEval = left.evaluate(arg);
    dynamic rightEval = right.evaluate(arg);

    // Convert num to Literal if the other operand is an Expression
    leftEval = convertToLiteralIfNeeded(leftEval, rightEval);
    rightEval = convertToLiteralIfNeeded(rightEval, leftEval);

    // If both evaluate to numbers, return the sum as a number
    if (leftEval is num && rightEval is num) {
      return leftEval + rightEval;
    }

    // If x is null and either operand contains a Variable, return the simplified version of the expression
    if (arg == null && (_containsVariable(left) || _containsVariable(right))) {
      return simplify();
    }

    // At this point, both operands should be Expression types that support the + operator.
    // If they aren't, there's likely a mismatch or unsupported scenario.
    if (leftEval is Expression && rightEval is Expression) {
      return Add(leftEval, rightEval).simplify();
    }

    // Default return (should ideally never reach this point)
    throw Exception('Unsupported evaluation scenario in Add.evaluate');
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
    // The derivative of a sum is the sum of the derivatives.
    return Add(left.differentiate(v), right.differentiate(v));
  }

  @override
  Expression integrate() {
    // The integral of a sum is the sum of the integrals.
    return Add(left.integrate(), right.integrate());
  }

  @override
  Expression simplifyBasic() {
    Expression simplifiedLeft = left.simplify();
    Expression simplifiedRight = right.simplify();

    // If both operands are literals, evaluate and return a new Literal.
    if (simplifiedLeft is Literal && simplifiedRight is Literal) {
      return Literal(simplifiedLeft.evaluate() + simplifiedRight.evaluate());
    }

    // Check if one of the operands is 0 (identity for addition).
    // Identity Element
    if (simplifiedRight is Literal) {
      if (simplifiedRight.evaluate() == 0) return simplifiedLeft;
    }
    if (simplifiedLeft is Literal) {
      if (simplifiedLeft.evaluate() == 0) return simplifiedRight;
    }

    // Negation
    if (simplifiedLeft is Multiply && simplifiedRight is Variable) {
      if (simplifiedLeft.left.evaluate() == -1 &&
          simplifiedLeft.right == simplifiedRight) {
        return Literal(0);
      }
    }
    if (simplifiedRight is Multiply && simplifiedLeft is Variable) {
      if (simplifiedRight.left.evaluate() == -1 &&
          simplifiedRight.right == simplifiedLeft) {
        return Literal(0);
      }
    }
    // Direct negation without multiplication
    try {
      if (simplifiedLeft is Literal || simplifiedRight is Literal) {
        // If one is literal, we might want to evaluate to check for cancellation if the other evaluates to a number
        // But generally, we shouldn't evaluate symbolic expressions here.
      }

      // Only evaluate if we are sure it won't crash or if we catch it.
      // For now, let's skip this check for complex symbolic expressions that might crash evaluate()
      var leftValue = simplifiedLeft.evaluate();
      var rightValue = simplifiedRight.evaluate();
      if (leftValue != null && rightValue != null && leftValue == -rightValue) {
        return Literal(0);
      }
    } catch (e) {
      // Ignore evaluation errors
    }

    // Flattening nested additions
    List<Expression> terms = [];
    if (simplifiedLeft is Add) {
      terms.addAll([simplifiedLeft.left, simplifiedLeft.right]);
    } else {
      terms.add(simplifiedLeft);
    }
    if (simplifiedRight is Add) {
      terms.addAll([simplifiedRight.left, simplifiedRight.right]);
    } else {
      terms.add(simplifiedRight);
    }

    // Grouping like terms and constants
    Map<String, num> likeTerms = {};
    Map<String, Expression> termExpressions = {}; // Store original expressions
    num constantTerm = 0;

    for (var term in terms) {
      if (term is Literal) {
        constantTerm += term.evaluate();
      } else if (term is Variable) {
        String key = term.toString();
        likeTerms.update(key, (val) => val + 1, ifAbsent: () => 1);
        termExpressions.putIfAbsent(key, () => term);
      } else if (term is Multiply && term.left is Literal) {
        String key = term.right.toString();
        num coefficient = (term.left as Literal).evaluate();
        likeTerms.update(key, (val) => val + coefficient,
            ifAbsent: () => coefficient);
        termExpressions.putIfAbsent(key, () => term.right);
      }
      // Handle terms of type x^2y, x^3, etc.
      else if (term is Multiply || term is Pow) {
        String key = term.toString();
        likeTerms.update(key, (val) => val + 1, ifAbsent: () => 1);
        termExpressions.putIfAbsent(key, () => term);
      } else {
        // Fallback for other types
        String key = term.toString();
        likeTerms.update(key, (val) => val + 1, ifAbsent: () => 1);
        termExpressions.putIfAbsent(key, () => term);
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
    // Addition doesn't have a more expanded form, return as-is.
    return this;
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    return Add(
      left.substitute(oldExpr, newExpr),
      right.substitute(oldExpr, newExpr),
    );
  }

  @override
  String toString() {
    return "(${left.toString()} + ${right.toString()})";
  }
}
