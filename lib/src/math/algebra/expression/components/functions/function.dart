part of '../../expression.dart';

class FunctionExpression extends Expression {
  final String name;
  final List<Expression> parameters;
  final Expression body;

  FunctionExpression(this.name, this.parameters, this.body);

  @override
  dynamic evaluate([dynamic arg]) {
    // To evaluate a function, we need to evaluate its body.
    // However, since this is a generic function representation, a real-world use case would involve
    // substituting actual values for its parameters before evaluation.
    return body.evaluate(arg);
  }

  @override
  Expression differentiate([Variable? v]) {
    // Differentiating a function involves differentiating its body with respect to its parameters.
    // A complete implementation would be more complex and involve chain rules, etc.
    // For simplicity, let's differentiate the body for now.
    return FunctionExpression(name, parameters, body.differentiate(v));
  }

  @override
  FunctionExpression integrate() {
    // Integration for generic functions can be complex.
    // For now, we'll return the function itself as a placeholder.
    return FunctionExpression(name, parameters, body.integrate());
  }

  @override
  FunctionExpression simplify() {
    // Simplification will involve simplifying the body of the function.
    return FunctionExpression(name, parameters, body.simplify());
  }

  @override
  FunctionExpression expand() {
    // Expansion will involve expanding the body of the function.
    return FunctionExpression(name, parameters, body.expand());
  }

  // Implementing the substitution method
  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    if (this == oldExpr) {
      return newExpr;
    }
    List<Expression> substitutedParameters =
        parameters.map((param) => param.substitute(oldExpr, newExpr)).toList();
    Expression substitutedBody = body.substitute(oldExpr, newExpr);
    return FunctionExpression(name, substitutedParameters, substitutedBody);
  }

  // Calculating the depth
  @override
  int depth() {
    int maxDepth = body.depth();
    for (var param in parameters) {
      int paramDepth = param.depth();
      if (paramDepth > maxDepth) {
        maxDepth = paramDepth;
      }
    }
    return 1 + maxDepth;
  }

  // Calculating the size
  @override
  int size() {
    int totalSize = 1; // for the function itself
    for (var param in parameters) {
      totalSize += param.size();
    }
    totalSize += body.size();
    return totalSize;
  }

  @override
  Set<Variable> getVariableTerms() {
    Set<Variable> variableSet = {};
    for (var param in parameters) {
      variableSet.addAll(param.getVariableTerms());
    }
    variableSet.addAll(body.getVariableTerms());
    return variableSet;
  }

  @override
  String toString() {
    var paramString = parameters.map((p) => p.toString()).join(', ');
    return "$name($paramString) = ${body.toString()}";
  }

  @override
  bool isIndeterminate(num x) {
    throw UnimplementedError();
  }

  @override
  bool isInfinity(num x) {
    throw UnimplementedError();
  }
}
