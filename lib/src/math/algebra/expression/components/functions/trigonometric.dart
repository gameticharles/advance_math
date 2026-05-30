part of '../../expression.dart';

class Trigonometric extends Expression {
  final Expression operand;
  final String functionName;

  Trigonometric(this.functionName, this.operand);

  @override
  dynamic evaluate([dynamic arg]) {
    final eval = operand.evaluate(arg);
    if (eval is num || eval is Complex) {
      switch (functionName.toLowerCase()) {
        case 'sin':
          return sin(eval);
        case 'cos':
          return cos(eval);
        case 'tan':
          return tan(eval);
        case 'asin':
          return asin(eval);
        case 'acos':
          return acos(eval);
        case 'atan':
          return atan(eval);
        case 'csc':
          return csc(eval);
        case 'sec':
          return sec(eval);
        case 'cot':
          return cot(eval);
        case 'acsc':
          return acsc(eval);
        case 'asec':
          return asec(eval);
        case 'acot':
          return acot(eval);
        case 'sinh':
          return sinh(eval);
        case 'cosh':
          return cosh(eval);
        case 'tanh':
          return tanh(eval);
        case 'csch':
          return csch(eval);
        case 'sech':
          return sech(eval);
        case 'coth':
          return coth(eval);
        case 'asinh':
          return asinh(eval);
        case 'acosh':
          return acosh(eval);
        case 'atanh':
          return atanh(eval);
        case 'acsch':
          return acsch(eval);
        case 'asech':
          return asech(eval);
        case 'acoth':
          return acoth(eval);
        case 'vers':
          return vers(eval);
        case 'covers':
          return covers(eval);
        case 'havers':
          return havers(eval);
        case 'exsec':
          return exsec(eval);
        case 'excsc':
          return excsc(eval);
        default:
          throw Exception('Unsupported trigonometric function: $functionName');
      }
    }
    return Trigonometric(functionName, eval);
  }

  @override
  Expression differentiate([Variable? v]) {
    // Differentiation rules for trigonometric functions.
    Expression der;
    switch (functionName.toLowerCase()) {
      case 'sin':
        der = Cos(operand);
        break;
      case 'cos':
        der = Negate(Sin(operand));
        break;
      case 'tan':
        der = Pow(Sec(operand), Literal(2));
        break;
      case 'sec':
        der = Multiply(Sec(operand), Tan(operand));
        break;
      case 'csc':
        der = Negate(Multiply(Csc(operand), Cot(operand)));
        break;
      case 'cot':
        der = Negate(Pow(Csc(operand), Literal(2)));
        break;
      case 'sinh':
        der = Trigonometric('cosh', operand);
        break;
      case 'cosh':
        der = Trigonometric('sinh', operand);
        break;
      case 'tanh':
        der = Pow(Trigonometric('sech', operand), Literal(2));
        break;
      case 'sech':
        der = Negate(Multiply(Trigonometric('sech', operand), Trigonometric('tanh', operand)));
        break;
      case 'csch':
        der = Negate(Multiply(Trigonometric('csch', operand), Trigonometric('coth', operand)));
        break;
      case 'coth':
        der = Negate(Pow(Trigonometric('csch', operand), Literal(2)));
        break;
      default:
        throw Exception(
            'Differentiation not implemented for trigonometric function: $functionName');
    }
    return Multiply(der, operand.differentiate(v));
  }

  @override
  Trigonometric integrate() {
    // Integration rules for trigonometric functions.
    // Placeholder for now.
    return this;
  }

  @override
  Expression simplify() {
    var simplifiedOperand = operand.simplify();

    // Constant folding: if operand is a numeric literal, evaluate directly
    if (simplifiedOperand is Literal) {
      var val = simplifiedOperand.value;
      if (val is num || val is Complex) {
        try {
          var result = Trigonometric(functionName, simplifiedOperand).evaluate();
          if (result is num || result is Complex) {
            return Literal(result);
          }
        } catch (_) {
          // Fall through if evaluation fails (e.g., domain errors)
        }
      }
    }

    if (simplifiedOperand != operand) {
      return Trigonometric(functionName, simplifiedOperand);
    }
    return this;
  }

  @override
  Trigonometric expand() {
    // Trigonometric expressions generally don't have a more expanded form.
    return this;
  }

  @override
  Set<Variable> getVariableTerms() {
    return operand.getVariableTerms();
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    if (this == oldExpr) return newExpr;
    return Trigonometric(
      functionName,
      operand.substitute(oldExpr, newExpr),
    );
  }

  @override
  bool isIndeterminate(dynamic x) {
    throw UnimplementedError();
  }

  @override
  bool isInfinity(dynamic x) {
    throw UnimplementedError();
  }

  @override
  bool isPoly([bool strict = false]) => false;

  @override
  int depth() {
    return 1 + operand.depth();
  }

  @override
  int size() {
    return 1 + operand.size();
  }

  @override
  String toString() {
    return "$functionName(${operand.toString()})";
  }
}
