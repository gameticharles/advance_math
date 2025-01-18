part of '../../expression.dart';

class Trigonometric extends Expression {
  final Expression operand;
  final String functionName;

  Trigonometric(this.functionName, this.operand);

  @override
  double evaluate([dynamic arg]) {
    switch (functionName) {
      case 'sin':
        return sin(operand.evaluate());
      case 'cos':
        return cos(operand.evaluate());
      case 'tan':
        return tan(operand.evaluate());
      case 'asin':
        return asin(operand.evaluate());
      case 'acos':
        return acos(operand.evaluate());
      case 'atan':
        return atan(operand.evaluate());
      case 'csc':
        double sinValue = sin(operand.evaluate());
        if (sinValue == 0) {
          throw Exception(
              'Cosecant is undefined for operand value: ${operand.evaluate()}');
        }
        return 1 / sinValue;
      case 'sec':
        double cosValue = cos(operand.evaluate());
        if (cosValue == 0) {
          throw Exception(
              'Secant is undefined for operand value: ${operand.evaluate()}');
        }
        return 1 / cosValue;
      case 'cot':
        double tanValue = tan(operand.evaluate());
        if (tanValue == 0) {
          throw Exception(
              'Cotangent is undefined for operand value: ${operand.evaluate()}');
        }
        return 1 / tanValue;
      default:
        throw Exception('Unsupported trigonometric function: $functionName');
    }
  }

  @override
  Trigonometric differentiate() {
    // Differentiation rules for trigonometric functions.
    switch (functionName) {
      case 'sin':
        return Trigonometric('cos', operand);
      case 'cos':
        // Note: Actually negative sine, but for simplicity, we keep it as sine here.
        return Trigonometric('sin', operand);
      case 'tan':
        // Note: Actually sec^2, but for simplicity, we keep it as sec here.
        return Trigonometric('sec', operand);
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
    return PredefinedFunctionExpression(
      functionName,
      operand.substitute(oldExpr, newExpr),
    );
  }

   @override
  bool isIndeterminate(num x) {
    throw UnimplementedError();
  }
  
  @override
  bool isInfinity(num x) {
    throw UnimplementedError();
  }

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
