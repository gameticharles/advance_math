part of '../../expression.dart';

class Divide extends BinaryOperationsExpression {
  Divide(super.left, super.right);

  @override
  dynamic evaluate([dynamic arg]) {
    // Helper method to convert num to Literal if the other operand is an Expression
    dynamic convertToLiteralIfNeeded(dynamic val, dynamic other) {
      if (val is num && other is Expression) {
        return Literal(val);
      }
      return val;
    }

    dynamic leftEval = left.evaluate(arg);
    dynamic rightEval = right.evaluate(arg);

    if (rightEval == 0) {
      throw Exception('Division by zero!');
    }

    // Convert num to Literal if the other operand is an Expression
    leftEval = convertToLiteralIfNeeded(leftEval, rightEval);
    rightEval = convertToLiteralIfNeeded(rightEval, leftEval);

    // If both evaluate to numbers, return the sum as a number
    if (leftEval is num && rightEval is num) {
      return leftEval / rightEval;
    }

    if (leftEval is Complex || rightEval is Complex) {
      if (Complex(rightEval) == Complex.zero()) {
        throw Exception('Division by zero!');
      }
      return (Complex(leftEval) / Complex(rightEval)).simplify();
    }

    // If x is null and either operand contains a Variable, return the simplified version of the expression
    if (arg == null && (_containsVariable(left) || _containsVariable(right))) {
      return simplify();
    }

    // At this point, both operands should be Expression types that support the + operator.
    // If they aren't, there's likely a mismatch or unsupported scenario.
    if (leftEval is Expression && rightEval is Expression) {
      return Divide(leftEval, rightEval).simplify();
    }

    // Default return (should ideally never reach this point)
    // throw Exception('Unsupported evaluation scenario in Divide.evaluate');
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
    // Applying the quotient rule: (u / v)' = (u' * v - u * v') / v^2
    // where u and v are functions of x.
    var uPrime = left.differentiate(v);
    var vPrime = right.differentiate(v);
    var vSquared = Multiply(right, right);

    return Divide(
        Subtract(Multiply(uPrime, right), Multiply(left, vPrime)), vSquared);
  }

  @override
  Expression integrate() {
    // If numerator (left) is a Literal or Variable, perform a simple integration of the denominator.
    if (left is Literal || left is Variable) {
      return Divide(left, right.integrate());
    }

    // If denominator (right) is a Literal or Variable, perform a simple integration of the numerator.
    else if (right is Literal || right is Variable) {
      return Divide(left.integrate(), right);
    }

    // If the numerator is a derivative of the denominator, then the integral is a log of the denominator.
    if (left.differentiate().simplify() == right) {
      return Multiply(Literal(log(right.evaluate())), right);
    }

    // If the numerator and denominator are both polynomials
    if (left is Polynomial && right is Polynomial) {
      var numerator = left as Polynomial;
      var denominator = right as Polynomial;

      // If degree of numerator >= degree of denominator
      if (numerator.degree >= denominator.degree) {
        // Perform polynomial long division
        var result = numerator / denominator as Add;

        // Integrate the quotient and remainder separately
        var quotientIntegral = Multiply(result.left, denominator).integrate();
        var remainderIntegral = Divide(result.right, denominator).integrate();

        return Add(quotientIntegral, remainderIntegral);
      } else {
        // Apply partial fraction decomposition
        var decomposed = _partialFractionDecomposition(numerator, denominator);

        // Integrate each term separately
        return decomposed
            .map(
                (fraction) => Divide(fraction.left, fraction.right).integrate())
            .reduce((a, b) => Add(a, b));
      }
    }
    return this;
  }

  List<Divide> _partialFractionDecomposition(
      Polynomial numerator, Polynomial denominator) {
    // First, factorize the denominator into its linear factors
    // This is a complex step and requires a polynomial factorization algorithm
    // For simplicity, let's assume a method `factorize()` that gives us linear factors
    List<Polynomial> factors = denominator.factorize();

    // For each factor, we'll have a corresponding fraction with an unknown coefficient in the numerator
    // e.g., for (x^2 + 3x + 2) we might have: A/(x + 1) + B/(x + 2)
    // We'll then form equations to solve for A, B, etc.

    // For simplicity, let's assume we have a method `solveCoefficients()`
    // that gives us the coefficients for each factor
    List<Literal> coefficients = _solveCoefficients(numerator, factors);

    // Now form the decomposed fractions
    List<Divide> decomposed = [];
    for (int i = 0; i < factors.length; i++) {
      decomposed.add(Divide(coefficients[i], factors[i]));
    }

    return decomposed;
  }

  List<Literal> _solveCoefficients(
      Polynomial numerator, List<Polynomial> factors) {
    int n = factors.length;
    List<Literal> coefficients = List.filled(n, Literal(0));

    // Form the expression for the sum of the simpler fractions
    Expression sum = Literal(0);
    for (int i = 0; i < n; i++) {
      // Using a new variable as the coefficient for each factor
      Variable coefficient = Variable('A${i + 1}');
      sum = Add(sum, Divide(coefficient, factors[i]));
    }

    // Clear the denominators
    var commonDenominator = factors.reduce((a, b) => (a * b) as Polynomial);
    var multipliedNumerator = (numerator * commonDenominator) as Polynomial;
    var multipliedSum = Multiply(sum, commonDenominator);

    // Equate the coefficients of the powers of x on both sides
    for (int i = 0; i < n; i++) {
      coefficients[i] = Literal(Subtract(
          multipliedNumerator.coefficient(i) as Expression,
          (multipliedSum as Polynomial).coefficient(i) as Expression));
    }

    // At this point, we'd typically solve the system of equations for the coefficients
    // This requires methods for systems of linear equations, which can be complex
    // For now, we'll return the coefficients as they are, but in practice,
    // you'd need to solve this system to get the actual coefficients

    return coefficients;
  }

  @override
  Expression simplifyBasic() {
    var numerator = left.simplify();
    var denominator = right.simplify();

    // Basic simplification: if both operands are literals, evaluate and return a new Literal.
    if (numerator is Literal && denominator is Literal) {
      var l = numerator.value;
      var r = denominator.value;
      if (l is num && r is num) {
        if (r == 0) throw Exception('Division by zero');
        // If result is integer, return integer
        if (l % r == 0) return Literal(l ~/ r);
        return Literal(l / r);
      }

      // Handle Complex division
      if (l is Complex || r is Complex) {
        var lC = (l is num) ? Complex(l, 0) : l as Complex;
        var rC = (r is num) ? Complex(r, 0) : r as Complex;
        if (rC == Complex.zero()) throw Exception('Division by zero');
        return Literal(lC / rC);
      }
    }

    // x / 1 -> x
    if (denominator is Literal && denominator.value == 1) return numerator;

    // x / -1 -> -x
    if (denominator is Literal && denominator.value == -1) {
      return Multiply(Literal(-1), numerator).simplify();
    }

    // 0 / x -> 0
    if (numerator is Literal && numerator.value == 0) return Literal(0);

    // x / x -> 1
    if (numerator.toString() == denominator.toString()) return Literal(1);

    // Convert division by literal to multiplication by reciprocal
    // x / c -> x * (1/c)
    if (denominator is Literal && denominator.value is num) {
      num val = denominator.value;
      if (val == 0) throw Exception('Division by zero');
      return Multiply(Literal(1 / val), numerator).simplify();
    }

    return Divide(numerator, denominator);
  }

  @override
  Expression expand() {
    // Division doesn't have a direct expanded form, return as-is.
    return this;
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    return Divide(
      left.substitute(oldExpr, newExpr),
      right.substitute(oldExpr, newExpr),
    );
  }

  @override
  String toString() {
    var leftStr = left.toString();
    var rightStr = right.toString();

    // Wrap left if it has lower precedence (Add/Subtract)
    if (left is Add || left is Subtract) {
      leftStr = '($leftStr)';
    }
    // Wrap right if it has lower or equal precedence (Add/Subtract/Multiply/Divide)
    // Actually, for division, right operand needs parens if it's mul or div too?
    // a / (b * c) vs a / b * c.
    // Standard precedence: * and / are equal, left associative.
    // a / b * c = (a / b) * c.
    // a / (b * c).
    // So if right is Multiply or Divide, we need parens.
    if (right is Add ||
        right is Subtract ||
        right is Multiply ||
        right is Divide) {
      rightStr = '($rightStr)';
    }

    return "$leftStr/$rightStr";
  }
}
