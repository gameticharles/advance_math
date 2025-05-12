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
    throw Exception('Unsupported evaluation scenario in Subtract.evaluate');
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
  Expression differentiate() {
    // The derivative of a difference is the difference of the derivatives.
    return Subtract(left.differentiate(), right.differentiate());
  }

  @override
  Expression integrate() {
    // The integral of a difference is the difference of the integrals.
    return Subtract(left.integrate(), right.integrate());
  }

  @override
  Expression simplify() {
    Expression simplifiedLeft = left.simplify();
    Expression simplifiedRight = right.simplify();

    // If both operands are literals, evaluate and return a new Literal.
    if (simplifiedLeft is Literal && simplifiedRight is Literal) {
      return Literal(simplifiedLeft.evaluate() - simplifiedRight.evaluate());
    }

    // Check if one of the operands is 0 (identity for addition).
    // Identity Element
    if (simplifiedRight is Literal && simplifiedRight.evaluate() == 0) {
      return simplifiedLeft;
    }
    if (simplifiedLeft is Literal && simplifiedLeft.evaluate() == 0) {
      return simplifiedRight;
    }

    // Negation
    if (simplifiedLeft == simplifiedRight) {
      return Literal(0);
    }

    // Flattening nested subtractions
    List<Expression> terms = [];
    if (simplifiedLeft is Subtract) {
      terms.addAll([
        simplifiedLeft.left,
        Multiply(Literal(-1), simplifiedLeft.right).simplify()
      ]);
    } else {
      terms.add(simplifiedLeft);
    }
    if (simplifiedRight is Subtract) {
      terms.addAll([
        Multiply(Literal(-1), simplifiedRight.left).simplify(),
        simplifiedRight.right
      ]);
    } else {
      terms.add(Multiply(Literal(-1), simplifiedRight).simplify());
    }

    // Grouping like terms and constants
    Map<String, num> likeTerms = {};
    num constantTerm = 0;
    for (var term in terms) {
      if (term is Literal) {
        constantTerm += term.evaluate();
      } else if (term is Variable) {
        likeTerms.update(
          term.toString(),
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      } else if (term is Multiply && term.left is Literal) {
        String variablePart = term.right.toString();
        num coefficient = (term.left as Literal).evaluate();
        likeTerms.update(
          variablePart,
          (value) => value + coefficient,
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
        simplifiedTerms.add(Variable(entry.key));
      } else {
        simplifiedTerms
            .add(Multiply(Literal(entry.value), Variable(entry.key)));
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
    // Subtraction doesn't have a more expanded form, return as-is.
    return this;
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
    return "(${left.toString()} - ${right.toString()})";
  }
}
