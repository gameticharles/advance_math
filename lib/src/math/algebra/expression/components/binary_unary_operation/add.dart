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
    if (leftEval is Complex) {
      return (leftEval + rightEval).simplify();
    }
    if (rightEval is Complex) {
      return (rightEval + leftEval).simplify();
    }
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
    // throw Exception('Unsupported evaluation scenario in Add.evaluate');
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
      var leftVal = simplifiedLeft.evaluate();
      var rightVal = simplifiedRight.evaluate();
      if (leftVal is num && rightVal is Complex) {
        return Literal(Complex(leftVal, 0) + rightVal);
      }
      if (leftVal is Complex || rightVal is Complex) {
        return Literal((Complex(leftVal) + Complex(rightVal)));
      }
      return Literal(leftVal + rightVal);
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
    void flatten(Expression expr) {
      if (expr is Add) {
        flatten(expr.left);
        flatten(expr.right);
      } else {
        terms.add(expr);
      }
    }

    flatten(simplifiedLeft);
    flatten(simplifiedRight);

    // Grouping like terms and constants
    Map<String, dynamic> likeTerms = {};
    Map<String, Expression> termExpressions = {}; // Store original expressions
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
        String key = term.toString();
        likeTerms.update(key, (val) => val + 1, ifAbsent: () => 1);
        termExpressions.putIfAbsent(key, () => term);
      } else if (term is Multiply && term.left is Literal) {
        String key = term.right.toString();
        dynamic coefficient = (term.left as Literal).evaluate();
        likeTerms.update(key, (val) {
          if (val is num && coefficient is Complex) {
            return coefficient + val;
          }
          return val + coefficient;
        }, ifAbsent: () => coefficient);
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

    // Special simplification for quadratic discriminant pattern: (A-B)^2 + 4AB = (A+B)^2
    // We look for Pow(..., 2) and other terms
    for (var i = 0; i < simplifiedTerms.length; i++) {
      var term1 = simplifiedTerms[i];
      if (term1 is Pow &&
          term1.exponent is Literal &&
          (term1.exponent as Literal).value == 2) {
        // Unwrap GroupExpression
        var base = term1.base;
        while (base is GroupExpression) {
          base = base.expression;
        }

        // Check if base is Subtract(A, B) or Add(A, -B)
        Expression? A, B;
        if (base is Subtract) {
          A = base.left;
          B = base.right;
        } else if (base is Add) {
          // A + (-B)
          var baseAdd = base;

          if (baseAdd.right is Multiply &&
              (baseAdd.right as Multiply).left.evaluate() == -1) {
            A = baseAdd.left;
            B = (baseAdd.right as Multiply).right;
          } else if (baseAdd.left is UnaryExpression &&
              (baseAdd.left as UnaryExpression).operator == '-') {
            A = baseAdd.right;
            B = (baseAdd.left as UnaryExpression).operand;
          } else if (baseAdd.left is Multiply) {
            var leftMul = baseAdd.left as Multiply;
            try {
              var val = leftMul.left.evaluate();
              if (val == -1) {
                A = baseAdd.right;
                B = leftMul.right;
              }
            } catch (e) {
              // Ignore evaluation errors
            }
          }
        }

        if (A != null && B != null) {
          // Look for +4AB
          for (var j = 0; j < simplifiedTerms.length; j++) {
            if (i == j) continue;
            var term2 = simplifiedTerms[j];
            // term2 should be 4*A*B
            // It might be simplified to 4*A*B or 4*B*A or 4*...
            // Let's construct 4*A*B and simplify it to compare
            var target4AB =
                Multiply(Literal(4), Multiply(A, B)).simplifyBasic();
            var target4BA =
                Multiply(Literal(4), Multiply(B, A)).simplifyBasic();

            if (term2.toString() == target4AB.toString() ||
                term2.toString() == target4BA.toString()) {
              // Found it! Replace term1 and term2 with (A+B)^2
              simplifiedTerms.removeAt(max(i, j));
              simplifiedTerms.removeAt(min(i, j));
              simplifiedTerms.add(Pow(Add(A, B), Literal(2)).simplifyBasic());
              // Restart or break? Restart to be safe
              return Add(
                      simplifiedTerms[0],
                      simplifiedTerms.length > 1
                          ? simplifiedTerms[1]
                          : Literal(0))
                  .simplifyBasic(); // Recursive call to handle list reconstruction
            }
          }
        }
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
    return Add(left.expand(), right.expand());
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
    var leftStr = left.toString();
    var rightStr = right.toString();

    // If right starts with -, don't add +
    if (rightStr.startsWith('-')) {
      return "$leftStr$rightStr";
    }
    return "$leftStr+$rightStr";
  }
}
