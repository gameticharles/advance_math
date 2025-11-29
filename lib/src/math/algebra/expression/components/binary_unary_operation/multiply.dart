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
    throw Exception('Unsupported evaluation scenario in Multiply.evaluate');
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

    // Basic simplification: if both operands are literals, evaluate and return a new Literal.
    if (simpleLeft is Literal && simpleRight is Literal) {
      return Literal(simpleLeft.evaluate() * simpleRight.evaluate());
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
      return Pow(simpleLeft, Literal(2));
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

    // Associativity: c1 * (c2 * x) = (c1 * c2) * x
    if (simpleLeft is Literal &&
        simpleRight is Multiply &&
        simpleRight.left is Literal) {
      var c1 = simpleLeft.evaluate();
      var c2 = (simpleRight.left as Literal).evaluate();
      return Multiply(Literal(c1 * c2), simpleRight.right).simplifyBasic();
    }

    // Multiplication of similar terms: ax * bx = abx^2
    if (simpleLeft is Multiply && simpleRight is Multiply) {
      if ((simpleLeft).right.toString() == (simpleRight).right.toString() &&
          (simpleLeft).left is Literal &&
          (simpleRight).left is Literal) {
        var newCoefficient =
            (simpleLeft).left.evaluate() * (simpleRight).left.evaluate();
        var newBase = (simpleLeft).right;
        return Multiply(Literal(newCoefficient), Pow(newBase, Literal(2)));
      }
    }

    // Associative and Commutative Property: For now, ensure multiplication is represented in a standard order
    if (simpleLeft is Variable && simpleRight is Literal) {
      return Multiply(
          simpleRight, simpleLeft); // make sure variable comes first
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

    // If operands changed but no rule matched, return new Multiply
    if (simpleLeft != left || simpleRight != right) {
      return Multiply(simpleLeft, simpleRight);
    }

    return this; // If no simplifications apply, return the original expression.
  }

  @override
  Expression expand() {
    // Expansion for (a+b)(c+d) = ac + ad + bc + bd
    if (left is Add && right is Add) {
      return Add(
          Add(Multiply((left as Add).left, (right as Add).left),
              Multiply((left as Add).left, (right as Add).right)),
          Add(Multiply((left as Add).right, (right as Add).left),
              Multiply((left as Add).right, (right as Add).right)));
    }

    // Expansion for a(b+c) = ab + ac
    if (left is! Add && right is Add) {
      return Add(Multiply(left, (right as Add).left),
          Multiply(left, (right as Add).right));
    }

    if (left is Add && right is! Add) {
      return Add(Multiply((left as Add).left, right),
          Multiply((left as Add).right, right));
    }

    // Expansion for (a+b)^2 = a^2 + 2ab + b^2
    if (left is Add && left.toString() == right.toString()) {
      var a = (left as Add).left;
      var b = (left as Add).right;
      return Add(Add(Multiply(a, a), Multiply(Multiply(Literal(2), a), b)),
          Multiply(b, b));
    }

    return this; // If no expansion rules apply, return the original expression.
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
    return "(${left.toString()} * ${right.toString()})";
  }
}
