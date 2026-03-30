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
    switch (functionName) {
      case 'sin':
        return Trigonometric('cos', operand);
      case 'cos':
        // Note: Actually negative sine, but for simplicity, we keep it as sine here.
        return Negate(Trigonometric('sin', operand));
      case 'tan':
        return Pow(Sec(operand), Literal(2));
      // Other differentiation rules can be added for csc, sec, and cot.
      default:
        throw Exception(
            'Differentiation not implemented for trigonometric function: $functionName');
    }
  }

  @override
  Trigonometric integrate() {
    // Integration rules for trigonometric functions.
    // Placeholder for now.
    return this;
  }

  @override
  Trigonometric simplify() {
    // Simplification can involve rules like sin(0) = 0, cos(0) = 1, etc.
    // Placeholder for now.
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
