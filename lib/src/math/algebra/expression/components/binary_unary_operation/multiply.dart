part of '../../expression.dart';

class Multiply extends BinaryOperationsExpression {
  Multiply(super.left, super.right);

  @override
  dynamic evaluate([dynamic arg]) {
    dynamic leftEval = left.evaluate(arg);
    dynamic rightEval = right.evaluate(arg);

    if (leftEval is Expression || rightEval is Expression) {
      return Multiply(
        leftEval is Expression ? leftEval : Literal(leftEval),
        rightEval is Expression ? rightEval : Literal(rightEval),
      ).simplify();
    }

    if (leftEval is Matrix) {
      return (leftEval * rightEval);
    }
    if (rightEval is Matrix) {
      return (leftEval * rightEval);
    }

    if ((leftEval is num || leftEval is Complex || leftEval is Rational) &&
        (rightEval is num || rightEval is Complex || rightEval is Rational)) {
      bool isZero(dynamic val) {
        if (val is num) return val == 0;
        if (val is Complex) return val.isZero;
        if (val is Rational) return val == Rational.zero;
        return false;
      }

      if (isZero(leftEval) || isZero(rightEval)) {
        return _normalizeResult(Complex.zero());
      }
      return _normalizeResult(Complex(leftEval) * Complex(rightEval));
    }

    dynamic result = Multiply(Literal(leftEval), Literal(rightEval)).simplify();
    return _normalizeResult(result);
  }

// Helper method to check if an expression contains a Variable
  // bool _containsVariable(Expression expr) {
  //   if (expr is Variable) {
  //     return true;
  //   } else if (expr is BinaryOperationsExpression) {
  //     return _containsVariable(expr.left) || _containsVariable(expr.right);
  //   }
  //   return false;
  // }

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

    // Helper to extract real numeric value from Literal (which may wrap Complex)
    dynamic litVal(Literal lit) {
      final v = lit.value;
      if (v is num) return v;
      if (v is Complex && v.isReal) return v.simplify();
      return v;
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

    bool fitsInInt(dynamic val) {
      if (val is int) return true;
      if (val is Rational) return val.isInteger && val.numerator.isValidInt;
      if (val is double) return val == val.toInt();
      if (val is Complex && val.isReal) {
        final r = val.real;
        if (r is Rational) return r.isInteger && r.numerator.isValidInt;
        if (r is int) return true;
        if (r is double) return r == r.toInt();
      }
      return false;
    }

    bool isIntegerVal(dynamic val) {
      if (val is int) return true;
      if (val is Rational) return val.isInteger;
      if (val is double) return val == val.toInt();
      if (val is Complex && val.isReal) {
        final r = val.real;
        if (r is Rational) return r.isInteger;
        if (r is int) return true;
        if (r is double) return r == r.toInt();
      }
      return false;
    }

    int toIntVal(dynamic val) {
      if (val is int) return val;
      if (val is Rational) return val.toInt();
      if (val is double) return val.toInt();
      if (val is Complex && val.isReal) {
        final r = val.real;
        if (r is Rational) return r.toInt();
        if (r is int) return r;
        if (r is double) return r.toInt();
      }
      throw ArgumentError('Not an integer val');
    }

    dynamic multiplyVals(dynamic v1, dynamic v2) {
      dynamic val;
      if ((v1 is num || v1 is Rational) && (v2 is num || v2 is Rational)) {
        if (isIntegerVal(v1) &&
            isIntegerVal(v2) &&
            fitsInInt(v1) &&
            fitsInInt(v2)) {
          val = toIntVal(v1) * toIntVal(v2);
        } else if (v1 is double || v2 is double) {
          final d1 = v1 is Rational ? v1.toDouble() : (v1 as num).toDouble();
          final d2 = v2 is Rational ? v2.toDouble() : (v2 as num).toDouble();
          val = d1 * d2;
        } else {
          val = Rational(v1) * Rational(v2);
        }
      } else {
        val = Complex(v1) * Complex(v2);
      }
      return _normalizeResult(val);
    }

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
    if (simpleLeft is Literal && isMinusOneVal(litVal(simpleLeft))) {
      if (simpleRight is UnaryExpression && simpleRight.operator == '-') {
        return simpleRight.operand.simplifyBasic();
      }
    }
    // Simplify UnaryExpression('-', a) * -1 -> a
    if (simpleRight is Literal && isMinusOneVal(litVal(simpleRight))) {
      if (simpleLeft is UnaryExpression && simpleLeft.operator == '-') {
        return simpleLeft.operand.simplifyBasic();
      }
    }

    if (changed) {
      return Multiply(simpleLeft, simpleRight).simplifyBasic();
    }

    // Basic simplification: if both operands are literals, evaluate and return a new Literal.
    if (simpleLeft is Literal && simpleRight is Literal) {
      var leftVal = litVal(simpleLeft);
      var rightVal = litVal(simpleRight);

      if (leftVal is double && leftVal != leftVal.toInt()) {
        leftVal = Rational(leftVal);
        simpleLeft = Literal(leftVal);
      }
      if (rightVal is double && rightVal != rightVal.toInt()) {
        rightVal = Rational(rightVal);
        simpleRight = Literal(rightVal);
      }

      bool isFraction(dynamic v) => v is Rational && !v.isInteger;
      bool isImaginaryUnit(dynamic v) {
        if (v is! Complex || !v.isImaginary) return false;
        final img = v.imaginary;
        double imgVal = 0.0;
        if (img is num) imgVal = img.toDouble();
        if (img is Rational) imgVal = img.toDouble();
        return imgVal == 1.0 || imgVal == -1.0;
      }

      if ((isFraction(leftVal) && isImaginaryUnit(rightVal)) ||
          (isFraction(rightVal) && isImaginaryUnit(leftVal))) {
        // Do not fold fractional Rational and imaginary unit i into a single complex literal
        return Multiply(simpleLeft, simpleRight);
      } else {
        var val = multiplyVals(leftVal, rightVal);
        if (val is Complex && val.isReal) val = val.simplify();
        return Literal(val).simplify();
      }
    }

    // Enforce right-associativity: (A * B) * C -> A * (B * C)
    if (simpleLeft is Multiply) {
      return Multiply(simpleLeft.left, Multiply(simpleLeft.right, simpleRight))
          .simplifyBasic();
    }

    // Swap constant to the left: x * c -> c * x
    if (simpleRight is Literal && simpleLeft is! Literal) {
      return Multiply(simpleRight, simpleLeft).simplifyBasic();
    }

    // Commutativity / Associativity: x * (c * y) = c * (x * y)
    if (simpleLeft is! Literal &&
        simpleRight is Multiply &&
        simpleRight.left is Literal) {
      return Multiply(simpleRight.left, Multiply(simpleLeft, simpleRight.right))
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
    if (simpleLeft is Literal && isZeroVal(litVal(simpleLeft)) ||
        simpleRight is Literal && isZeroVal(litVal(simpleRight))) {
      return Literal(0);
    }

    if (simpleLeft is Literal && isOneVal(litVal(simpleLeft))) {
      return simpleRight;
    }
    if (simpleRight is Literal && isOneVal(litVal(simpleRight))) {
      return simpleLeft;
    }

    // Associative simplification for Multiply(Multiply(A, B), C)
    if (simpleLeft is Multiply) {
      final bc = Multiply(simpleLeft.right, simpleRight).simplifyBasic();
      if (bc is Literal ||
          bc.size() < simpleLeft.right.size() + simpleRight.size()) {
        return Multiply(simpleLeft.left, bc).simplifyBasic();
      }
      final ac = Multiply(simpleLeft.left, simpleRight).simplifyBasic();
      if (ac is Literal ||
          ac.size() < simpleLeft.left.size() + simpleRight.size()) {
        return Multiply(simpleLeft.right, ac).simplifyBasic();
      }
    }

    // Associative simplification for Multiply(C, Multiply(A, B))
    if (simpleRight is Multiply) {
      final ca = Multiply(simpleLeft, simpleRight.left).simplifyBasic();
      if (ca is Literal ||
          ca.size() < simpleLeft.size() + simpleRight.left.size()) {
        return Multiply(ca, simpleRight.right).simplifyBasic();
      }
      final cb = Multiply(simpleLeft, simpleRight.right).simplifyBasic();
      if (cb is Literal ||
          cb.size() < simpleLeft.size() + simpleRight.right.size()) {
        return Multiply(cb, simpleRight.left).simplifyBasic();
      }
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

    // Handle Base * Pow (base * base^n = base^(n+1))
    if (simpleLeft is! Literal &&
        simpleRight is Pow &&
        simpleRight.base.toString() == simpleLeft.toString()) {
      return Pow(simpleLeft, Add(simpleRight.exponent, Literal(1)).simplify())
          .simplifyBasic();
    }

    // Handle Pow * Base (base^n * base = base^(n+1))
    if (simpleRight is! Literal &&
        simpleLeft is Pow &&
        simpleLeft.base.toString() == simpleRight.toString()) {
      return Pow(simpleRight, Add(simpleLeft.exponent, Literal(1)).simplify())
          .simplifyBasic();
    }

    Expression buildSimplifiedProduct(dynamic val, Expression x) {
      if (val is Complex && val.isImaginary) {
        var img = val.imaginary.toDouble();
        if (img is double && img != img.toInt()) {
          img = Rational(img);
        } else if (img is num && img % 1 != 0) {
          img = Rational(img);
        }
        if (img is Rational && !img.isInteger) {
          final coef = Multiply(Literal(img), Literal(Complex(0, 1)));
          return Multiply(coef, x);
        }
      }
      if (isOneVal(val)) {
        return x;
      }
      if (isMinusOneVal(val)) {
        return Multiply(Literal(-1), x).simplifyBasic();
      }
      return Multiply(Literal(val), x).simplifyBasic();
    }

    // Guard: do not merge two literal coefficients if one is a fraction and
    // the other is an imaginary unit (±i). Merging would produce a
    // fractional-imaginary Complex that buildSimplifiedProduct immediately
    // decomposes back, creating an infinite loop.
    bool _wouldProduceFracI(dynamic v1, dynamic v2) {
      bool isFrac(dynamic v) => v is Rational && !v.isInteger;
      bool isIUnit(dynamic v) {
        if (v is! Complex || !v.isImaginary) return false;
        final img = v.imaginary;
        double iv = 0.0;
        if (img is num) iv = img.toDouble();
        if (img is Rational) iv = img.toDouble();
        return iv == 1.0 || iv == -1.0;
      }

      return (isFrac(v1) && isIUnit(v2)) || (isFrac(v2) && isIUnit(v1));
    }

    // Associativity: c1 * (c2 * x) = (c1 * c2) * x
    if (simpleLeft is Literal &&
        simpleRight is Multiply &&
        simpleRight.left is Literal) {
      var c1 = litVal(simpleLeft);
      var c2 = litVal(simpleRight.left as Literal);
      if (!_wouldProduceFracI(c1, c2)) {
        var val = multiplyVals(c1, c2);
        if (val is Complex && val.isReal) val = val.simplify();
        return buildSimplifiedProduct(val, simpleRight.right);
      }
    }

    // Associativity: (c1 * x) * c2 = (c1 * c2) * x
    if (simpleLeft is Multiply &&
        simpleLeft.left is Literal &&
        simpleRight is Literal) {
      var c1 = litVal(simpleLeft.left as Literal);
      var c2 = litVal(simpleRight);
      if (!_wouldProduceFracI(c1, c2)) {
        var val = multiplyVals(c1, c2);
        if (val is Complex && val.isReal) val = val.simplify();
        return buildSimplifiedProduct(val, simpleLeft.right);
      }
    }

    // Associativity: c1 * (x * c2) = (c1 * c2) * x
    if (simpleLeft is Literal &&
        simpleRight is Multiply &&
        simpleRight.right is Literal) {
      var c1 = litVal(simpleLeft);
      var c2 = litVal(simpleRight.right as Literal);
      if (!_wouldProduceFracI(c1, c2)) {
        var val = multiplyVals(c1, c2);
        if (val is Complex && val.isReal) val = val.simplify();
        return buildSimplifiedProduct(val, simpleRight.left);
      }
    }

    // Associativity: (x * c1) * c2 = (c1 * c2) * x
    if (simpleLeft is Multiply &&
        simpleLeft.right is Literal &&
        simpleRight is Literal) {
      var c1 = litVal(simpleLeft.right as Literal);
      var c2 = litVal(simpleRight);
      if (!_wouldProduceFracI(c1, c2)) {
        var val = multiplyVals(c1, c2);
        if (val is Complex && val.isReal) val = val.simplify();
        return buildSimplifiedProduct(val, simpleLeft.left);
      }
    }

    // Combine constant coefficients: c1 * (c2 * A) -> (c1 * c2) * A
    if (simpleLeft is Literal &&
        simpleRight is Multiply &&
        simpleRight.left is Literal) {
      var c1 = litVal(simpleLeft);
      var c2 = litVal(simpleRight.left as Literal);
      if (!_wouldProduceFracI(c1, c2)) {
        var val = multiplyVals(c1, c2);
        if (val is Complex && val.isReal) val = val.simplify();
        return buildSimplifiedProduct(val, simpleRight.right);
      }
    }

    // Multiplication of similar terms: ax * bx = abx^2
    if (simpleLeft is Multiply && simpleRight is Multiply) {
      if ((simpleLeft).right.toString() == (simpleRight).right.toString() &&
          (simpleLeft).left is Literal &&
          (simpleRight).left is Literal) {
        var c1 = litVal((simpleLeft).left as Literal);
        var c2 = litVal((simpleRight).left as Literal);
        var newCoefficient = multiplyVals(c1, c2);
        if (newCoefficient is Complex && newCoefficient.isReal) {
          newCoefficient = newCoefficient.simplify();
        }
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
    var leftStr = left.toString();
    var rightStr = right.toString();

    // Clean formatting for coefficient -1: -1 * x -> -x
    if (left is Literal) {
      final val = (left as Literal).value;
      if (val == -1) {
        if (right is Add || right is Subtract) {
          return "-($rightStr)";
        }
        return "-$rightStr";
      }
      if (val == 1) {
        return rightStr;
      }
    }
    if (right is Literal) {
      final val = (right as Literal).value;
      if (val == -1) {
        if (left is Add || left is Subtract) {
          return "-($leftStr)";
        }
        return "-$leftStr";
      }
      if (val == 1) {
        return leftStr;
      }
    }

    if (left is Literal) {
      final val = (left as Literal).value;
      if (val is Rational && !val.isInteger) {
        // Always wrap non-integer rational fractions in parens to avoid ambiguity.
        // e.g. (1/4)*log(y) instead of 1/4*log(y), which could be read as 1/(4*log(y)).
        leftStr = '($leftStr)';
      }
    }
    if (right is Literal) {
      final val = (right as Literal).value;
      if (val is Rational && !val.isInteger) {
        if (leftStr == 'i' ||
            leftStr.startsWith('i*') ||
            leftStr.startsWith('i^')) {
          rightStr = '($rightStr)';
        }
      }
    }


    // Avoid excessive parentheses
    if (left is Add || left is Subtract) {
      leftStr = '($leftStr)';
    }
    if (right is Add || right is Subtract) {
      rightStr = '($rightStr)';
    }

    // Display  Variable^(-1) * numerator  as  numerator/variable (e.g. b/a instead of a^(-1)*b)
    // Also display  numerator * Variable^(-1)  as  numerator/variable.
    // Only applies when the Pow has a plain Variable base with exponent exactly -1.
    bool isPowVarMinusOne(Expression e) {
      if (e is! Pow) return false;
      final pow = e;
      if (pow.base is! Variable) return false;
      if (pow.exponent is! Literal) return false;
      final expVal = (pow.exponent as Literal).value;
      if (expVal == -1) return true;
      if (expVal is Complex && (expVal).isReal) {
        final r = (expVal).real;
        return (r is num && r == -1) ||
            (r is Rational && r == Rational.fromInt(-1));
      }
      return false;
    }

    if (isPowVarMinusOne(right)) {
      final baseStr = (right as Pow).base.toString();
      return "$leftStr/$baseStr";
    }
    if (isPowVarMinusOne(left)) {
      final baseStr = (left as Pow).base.toString();
      return "$rightStr/$baseStr";
    }

    return "$leftStr*$rightStr";
  }
}
