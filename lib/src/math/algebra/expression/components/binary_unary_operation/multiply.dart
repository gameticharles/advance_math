part of '../../expression.dart';

class Multiply extends BinaryOperationsExpression {
  Multiply(super.left, super.right);

  @override
  dynamic evaluate([dynamic arg]) {
    dynamic leftEval = left.evaluate(arg);
    dynamic rightEval = right.evaluate(arg);

    // Handle the identity and zero properties of multiplication
    if ((leftEval is num && leftEval == 0) ||
        (rightEval is num && rightEval == 0)) {
      return 0;
    }
    if (leftEval is num && leftEval == 1) {
      return rightEval;
    }
    if (rightEval is num && rightEval == 1) {
      return leftEval;
    }

    // Convert num to Literal if the other operand is an Expression
    leftEval = convertToLiteralIfNeeded(leftEval, rightEval);
    rightEval = convertToLiteralIfNeeded(rightEval, leftEval);

    // If both evaluate to numbers, return the sum as a number
    if (leftEval is Complex) {
      return (leftEval * rightEval).simplify();
    }
    if (rightEval is Complex) {
      return (rightEval * leftEval).simplify();
    }
    if (leftEval is num && rightEval is num) {
      return leftEval * rightEval;
    }

    // If x is null and either operand contains a Variable, return the simplified version of the expression
    if (arg == null && (_containsVariable(left) || _containsVariable(right))) {
      return simplify();
    }

    // At this point, both operands should be Expression types that support the + operator.
    // If they aren't, there's likely a mismatch or unsupported scenario.
    if (leftEval is Expression && rightEval is Expression) {
      return Multiply(leftEval, rightEval).simplify();
    }

    // Default return (should ideally never reach this point)
    // throw Exception('Unsupported evaluation scenario in Multiply.evaluate');
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
    // Applying the product rule: (u * v)' = u' * v + u * v'
    // where u and v are functions of x.
    var uPrime = left.differentiate(v);
    var vPrime = right.differentiate(v);

    return Add(Multiply(uPrime, right), Multiply(left, vPrime));
  }

  @override
  Expression integrate() {
    // If left is a Literal, integrate right and multiply with left.
    if (left is Literal) {
      return Multiply(left, right.integrate());
    }

    // If right is a Literal, integrate left and multiply with right.
    else if (right is Literal) {
      return Multiply(right, left.integrate());
    }

    // For more complex cases, we'll apply integration by parts:
    // Choose u and dv based on heuristic or predefined rules.
    // For simplicity, we'll take left as u and right as dv.
    var u = left;
    var dv = right;

    // Differentiate u to get du.
    var du = u.differentiate();

    // Integrate dv to get v.
    var v = dv.integrate();

    // Apply the integration by parts formula.
    var uv = Multiply(u, v);
    var integralVdu = Multiply(v, du).integrate();

    return Subtract(uv, integralVdu);
  }

  @override
  Expression simplifyBasic() {
    var simpleLeft = left.simplifyBasic();
    var simpleRight = right.simplifyBasic();

    // Normalize Negate(expr) or UnaryExpression('-', expr) to -1 * expr
    bool isNegate(Expression e) {
      return e is Negate || (e is UnaryExpression && e.operator == '-');
    }

    Expression getOperand(Expression e) {
      if (e is Negate) return e.operand;
      if (e is UnaryExpression) return e.operand;
      throw Exception('Not a negation');
    }

    bool changed = false;
    if (isNegate(simpleLeft)) {
      simpleLeft = Multiply(Literal(-1), getOperand(simpleLeft));
      changed = true;
    }
    if (isNegate(simpleRight)) {
      simpleRight = Multiply(Literal(-1), getOperand(simpleRight));
      changed = true;
    }

    // Simplify -1 * UnaryExpression('-', a) -> a
    if (simpleLeft is Literal && simpleLeft.value == -1) {
      if (simpleRight is UnaryExpression && simpleRight.operator == '-') {
        return simpleRight.operand.simplifyBasic();
      }
    }
    // Simplify UnaryExpression('-', a) * -1 -> a
    if (simpleRight is Literal && simpleRight.value == -1) {
      if (simpleLeft is UnaryExpression && simpleLeft.operator == '-') {
        return simpleLeft.operand.simplifyBasic();
      }
    }

    if (changed) {
      return Multiply(simpleLeft, simpleRight).simplifyBasic();
    }

    // Basic simplification: if both operands are literals, evaluate and return a new Literal.
    if (simpleLeft is Literal && simpleRight is Literal) {
      var leftVal = simpleLeft.evaluate();
      var rightVal = simpleRight.evaluate();
      if (leftVal is Complex || rightVal is Complex) {
        return Literal(Complex(leftVal) * Complex(rightVal)).simplify();
      }
      return Literal(leftVal * rightVal).simplify();
    }

    // Enforce right-associativity: (A * B) * C -> A * (B * C)
    if (simpleLeft is Multiply) {
      return Multiply(simpleLeft.left, Multiply(simpleLeft.right, simpleRight))
          .simplifyBasic();
    }

    // Distribute Literal over Add/Subtract
    // c * (a + b) = ca + cb
    Expression rightOperand = simpleRight;
    while (rightOperand is GroupExpression) {
      rightOperand = rightOperand.expression;
    }
    Expression leftOperand = simpleLeft;
    while (leftOperand is GroupExpression) {
      leftOperand = leftOperand.expression;
    }

    bool isConstant(Expression e) {
      if (e is Literal) return true;
      if (e is UnaryExpression && e.operand is Literal) return true;
      // Add more cases if needed, but avoid evaluate() which triggers simplify()
      return false;
    }

    if (isConstant(simpleLeft) && rightOperand is Add) {
      return Add(Multiply(simpleLeft, rightOperand.left),
              Multiply(simpleLeft, rightOperand.right))
          .simplifyBasic();
    }
    if (isConstant(simpleLeft) && rightOperand is Subtract) {
      return Subtract(Multiply(simpleLeft, rightOperand.left),
              Multiply(simpleLeft, rightOperand.right))
          .simplifyBasic();
    }
    // (a + b) * c = ac + bc
    if (isConstant(simpleRight) && leftOperand is Add) {
      return Add(Multiply(simpleRight, leftOperand.left),
              Multiply(simpleRight, leftOperand.right))
          .simplifyBasic();
    }
    if (isConstant(simpleRight) && leftOperand is Subtract) {
      return Subtract(Multiply(simpleRight, leftOperand.left),
              Multiply(simpleRight, leftOperand.right))
          .simplifyBasic();
    }

    // Handle cases like x * 0 = 0, x * 1 = x
    if (simpleLeft is Literal && simpleLeft.evaluate() == 0 ||
        simpleRight is Literal && simpleRight.evaluate() == 0) {
      return Literal(0);
    }

    if (simpleLeft is Literal && simpleLeft.evaluate() == 1) {
      return simpleRight;
    }
    if (simpleRight is Literal && simpleRight.evaluate() == 1) {
      return simpleLeft;
    }

    // Multiplication involving same base x * x = x^2
    if (simpleLeft.toString() == simpleRight.toString()) {
      return Pow(simpleLeft, Literal(2)).simplifyBasic();
    }

    // Multiplication involving exponential functions
    if (simpleLeft is Pow && simpleRight is Pow) {
      // a^m * a^n = a^(m+n)
      if ((simpleLeft).base.toString() == (simpleRight).base.toString()) {
        var newExponent =
            Add((simpleLeft).exponent, (simpleRight).exponent).simplify();
        return Pow((simpleLeft).base, newExponent);
      }
      // a^m * b^m remains as is.
    }

    // Handle Variable * Pow (x * x^n = x^(n+1))
    if (simpleLeft is Variable &&
        simpleRight is Pow &&
        simpleRight.base.toString() == simpleLeft.toString()) {
      return Pow(simpleLeft, Add(simpleRight.exponent, Literal(1)).simplify())
          .simplifyBasic();
    }

    // Handle Pow * Variable (x^n * x = x^(n+1))
    if (simpleLeft is Pow &&
        simpleRight is Variable &&
        simpleLeft.base.toString() == simpleRight.toString()) {
      return Pow(simpleRight, Add(simpleLeft.exponent, Literal(1)).simplify())
          .simplifyBasic();
    }

    // Associativity: c1 * (c2 * x) = (c1 * c2) * x
    if (simpleLeft is Literal &&
        simpleRight is Multiply &&
        simpleRight.left is Literal) {
      var c1 = simpleLeft.evaluate();
      var c2 = (simpleRight.left as Literal).evaluate();
      var val = (c1 is num && c2 is Complex) ? c2 * c1 : c1 * c2;
      return Multiply(Literal(val), simpleRight.right).simplifyBasic();
    }

    // Associativity: (c1 * x) * c2 = (c1 * c2) * x
    if (simpleLeft is Multiply &&
        simpleLeft.left is Literal &&
        simpleRight is Literal) {
      var c1 = (simpleLeft.left as Literal).evaluate();
      var c2 = simpleRight.evaluate();
      var val = (c1 is num && c2 is Complex) ? c2 * c1 : c1 * c2;
      return Multiply(Literal(val), simpleLeft.right).simplifyBasic();
    }

    // Associativity: c1 * (x * c2) = (c1 * c2) * x
    if (simpleLeft is Literal &&
        simpleRight is Multiply &&
        simpleRight.right is Literal) {
      var c1 = simpleLeft.evaluate();
      var c2 = (simpleRight.right as Literal).evaluate();
      var val = (c1 is num && c2 is Complex) ? c2 * c1 : c1 * c2;
      return Multiply(Literal(val), simpleRight.left).simplifyBasic();
    }

    // Associativity: (x * c1) * c2 = (c1 * c2) * x
    if (simpleLeft is Multiply &&
        simpleLeft.right is Literal &&
        simpleRight is Literal) {
      var c1 = (simpleLeft.right as Literal).evaluate();
      var c2 = simpleRight.evaluate();
      var val = (c1 is num && c2 is Complex) ? c2 * c1 : c1 * c2;
      return Multiply(Literal(val), simpleLeft.left).simplifyBasic();
    }

    // Multiplication of similar terms: ax * bx = abx^2
    if (simpleLeft is Multiply && simpleRight is Multiply) {
      if ((simpleLeft).right.toString() == (simpleRight).right.toString() &&
          (simpleLeft).left is Literal &&
          (simpleRight).left is Literal) {
        var c1 = (simpleLeft).left.evaluate();
        var c2 = (simpleRight).left.evaluate();
        var newCoefficient = (c1 is num && c2 is Complex) ? c2 * c1 : c1 * c2;
        var newBase = (simpleLeft).right;
        return Multiply(Literal(newCoefficient), Pow(newBase, Literal(2)));
      }
    }

    // Combine like terms: (A * B) * B = A * B^2
    if (simpleLeft is Multiply &&
        simpleLeft.right.toString() == simpleRight.toString()) {
      return Multiply(simpleLeft.left, Pow(simpleRight, Literal(2)))
          .simplifyBasic();
    }
    // Combine like terms: (A * B) * A = B * A^2
    if (simpleLeft is Multiply &&
        simpleLeft.left.toString() == simpleRight.toString()) {
      return Multiply(simpleLeft.right, Pow(simpleRight, Literal(2)))
          .simplifyBasic();
    }

    // Associative and Commutative Property: For now, ensure multiplication is represented in a standard order
    if (simpleLeft is Variable && simpleRight is Literal) {
      return Multiply(
          simpleRight, simpleLeft); // make sure variable comes first
    }

    // Sort variables alphabetically
    if (simpleLeft is Variable && simpleRight is Variable) {
      if (simpleLeft.identifier.name.compareTo(simpleRight.identifier.name) >
          0) {
        return Multiply(simpleRight, simpleLeft).simplifyBasic();
      }
    }

    // Sort Variable * Multiply(Variable, ...)
    if (simpleLeft is Variable &&
        simpleRight is Multiply &&
        simpleRight.left is Variable) {
      if (simpleLeft.identifier.name
              .compareTo((simpleRight.left as Variable).identifier.name) >
          0) {
        return Multiply(
                simpleRight.left, Multiply(simpleLeft, simpleRight.right))
            .simplifyBasic();
      }
    }

    // Special products
    // (a+b)^2 = a^2 + 2ab + b^2
    if (simpleLeft is Add && simpleRight.toString() == simpleLeft.toString()) {
      var a = (simpleLeft).left;
      var b = (simpleLeft).right;
      var aSquared = Pow(a, Literal(2));
      var bSquared = Pow(b, Literal(2));
      var twoAB = Multiply(Multiply(Literal(2), a), b);
      return Add(Add(aSquared, twoAB), bSquared);
    }

    // (a+b)(a-b) = a^2 - b^2
    if (simpleLeft is Add &&
        simpleRight is Subtract &&
        simpleLeft.left.toString() == simpleRight.left.toString() &&
        simpleLeft.right.toString() == simpleRight.right.toString()) {
      var a = simpleLeft.left;
      var b = simpleLeft.right;
      var aSquared = Pow(a, Literal(2));
      var bSquared = Pow(b, Literal(2));
      return Subtract(aSquared, bSquared);
    }

    // Cancellation: A * (B / A) = B
    if (simpleRight is Divide &&
        simpleRight.right.toString() == simpleLeft.toString()) {
      return simpleRight.left.simplifyBasic();
    }
    // Cancellation: (B / A) * A = B
    if (simpleLeft is Divide &&
        simpleLeft.right.toString() == simpleRight.toString()) {
      return simpleLeft.left.simplifyBasic();
    }

    // If operands changed but no rule matched, return new Multiply
    if (simpleLeft != left || simpleRight != right) {
      return Multiply(simpleLeft, simpleRight);
    }

    return this; // If no simplifications apply, return the original expression.
  }

  @override
  Expression expand() {
    var expandedLeft = left.expand();
    var expandedRight = right.expand();

    // Helper to check if expression is Add or Subtract
    bool isAddOrSub(Expression e) => e is Add || e is Subtract;

    // Helper to get terms from Add or Subtract recursively
    List<Expression> getTerms(Expression e) {
      if (e is Add) {
        return [...getTerms(e.left), ...getTerms(e.right)];
      }
      if (e is Subtract) {
        return [
          ...getTerms(e.left),
          ...getTerms(Multiply(Literal(-1), e.right))
        ];
      }
      return [e];
    }

    if (isAddOrSub(expandedLeft) && isAddOrSub(expandedRight)) {
      // (a+b)(c+d) = ac + ad + bc + bd
      var leftTerms = getTerms(expandedLeft);
      var rightTerms = getTerms(expandedRight);

      Expression result = Literal(0);
      bool first = true;

      for (var l in leftTerms) {
        for (var r in rightTerms) {
          var term = Multiply(l, r);
          if (first) {
            result = term;
            first = false;
          } else {
            result = Add(result, term);
          }
        }
      }
      return result;
    }

    if (isAddOrSub(expandedLeft) && !isAddOrSub(expandedRight)) {
      // (a+b)c = ac + bc
      var leftTerms = getTerms(expandedLeft);
      Expression result = Literal(0);
      bool first = true;
      for (var l in leftTerms) {
        var term = Multiply(l, expandedRight);
        if (first) {
          result = term;
          first = false;
        } else {
          result = Add(result, term);
        }
      }
      return result;
    }

    if (!isAddOrSub(expandedLeft) && isAddOrSub(expandedRight)) {
      // a(b+c) = ab + ac
      var rightTerms = getTerms(expandedRight);
      Expression result = Literal(0);
      bool first = true;
      for (var r in rightTerms) {
        var term = Multiply(expandedLeft, r);
        if (first) {
          result = term;
          first = false;
        } else {
          result = Add(result, term);
        }
      }
      return result;
    }

    // Expansion for (a+b)^2 = a^2 + 2ab + b^2
    // This is covered by the first case if we expand (a+b)*(a+b)
    // But if it's Pow, that's handled in Pow.expand()

    return Multiply(expandedLeft, expandedRight);
  }

  Expression negate() {
    return Multiply(Literal(-1), this);
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    return Multiply(
      left.substitute(oldExpr, newExpr),
      right.substitute(oldExpr, newExpr),
    );
  }

  @override
  String toString() {
    // Avoid excessive parentheses
    var leftStr = left.toString();
    var rightStr = right.toString();

    // If left is Add or Subtract, wrap in parens (precedence)
    if (left is Add || left is Subtract) {
      leftStr = '($leftStr)';
    }
    // If right is Add or Subtract, wrap in parens
    if (right is Add || right is Subtract) {
      rightStr = '($rightStr)';
    }

    return "$leftStr*$rightStr";
  }
}
