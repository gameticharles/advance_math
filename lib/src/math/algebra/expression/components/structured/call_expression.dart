part of '../../expression.dart';

class CallExpression extends Expression {
  final Expression callee;
  final List<Expression> arguments;

  CallExpression(this.callee, this.arguments);

  @override
  dynamic evaluate([dynamic arg]) {
    var evCallee = callee.evaluate(arg);
    var aevArguments = arguments.map((e) => e.evaluate(arg)).toList();
    return Function.apply(evCallee, aevArguments);
  }

  @override
  Expression differentiate([Variable? v]) {
    // The derivative of call is just the derivative.
    return CallExpression(callee.differentiate(v), arguments);
  }

  @override
  Expression integrate() {
    // The integral of call the integral.
    return CallExpression(callee.integrate(), arguments);
  }

  @override
  Expression simplify() {
    return this;
  }

  @override
  Expression expand() {
    // Call doesn't expand further, return as-is.
    return this;
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    if (this == oldExpr) {
      return newExpr;
    }
    return CallExpression(
      callee.substitute(oldExpr, newExpr),
      arguments.map((arg) => arg.substitute(oldExpr, newExpr)).toList(),
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
    return 1 +
        [callee.depth(), ...arguments.map((arg) => arg.depth())].reduce(max);
  }

  @override
  int size() {
    return 1 +
        callee.size() +
        arguments.fold(0, (acc, arg) => acc + arg.size());
  }

  @override
  Set<Variable> getVariableTerms() {
    return {
      ...callee.getVariableTerms(),
      ...arguments.expand((arg) => arg.getVariableTerms())
    };
  }

  @override
  String toString() => '${callee.toString()}(${arguments.join(', ')})';
}
