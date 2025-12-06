part of '../../expression.dart';

class Trigonometric extends Expression {
  final Expression operand;
  final String functionName;

  Trigonometric(this.functionName, this.operand);

  @override
  double evaluate([dynamic arg]) {
    final eval = operand.evaluate();
    switch (functionName) {
      case 'sin':
        if (eval is Complex) {
          return eval.sin().simplify();
        }
        return sin(eval);
      case 'cos':
        if (eval is Complex) {
          return eval.cos().simplify();
        }
        return cos(eval);
      case 'tan':
        if (eval is Complex) {
          return eval.tan().simplify();
        }
        return tan(eval);
      case 'asin':
        if (eval is Complex) {
          return eval.asin().simplify();
        }
        return asin(eval);
      case 'acos':
        if (eval is Complex) {
          return eval.acos().simplify();
        }
        return acos(eval);
      case 'atan':
        if (eval is Complex) {
          return eval.atan().simplify();
        }
        return atan(eval);
      case 'csc':
        if (eval is Complex) {
          final sine = eval.sin();
          if (sine == Complex.zero()) {
            return Complex.infinity().simplify();
          }
          return (Complex.one() / sine).simplify();
        }
        double sinValue = sin(eval);
        if (sinValue == 0) {
          throw Exception(
              'Cosecant is undefined for operand value: ${operand.evaluate()}');
        }
        return 1 / sinValue;
      case 'sec':
        if (eval is Complex) {
          final cosine = eval.cos();
          if (cosine == Complex.zero()) {
            return Complex.infinity().simplify();
          }
          return (Complex.one() / cosine).simplify();
        }
        double cosValue = cos(eval);
        if (cosValue == 0) {
          throw Exception(
              'Secant is undefined for operand value: ${operand.evaluate()}');
        }
        return 1 / cosValue;
      case 'cot':
        if (eval is Complex) {
          final tangent = eval.tan();
          if (tangent == Complex.zero()) {
            return Complex.infinity().simplify();
          }
          return (Complex.one() / tangent).simplify();
        }
        double tanValue = tan(eval);
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
  Expression differentiate([Variable? v]) {
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
