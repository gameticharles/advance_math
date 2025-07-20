part of '../../expression.dart';

class MemberExpression extends Expression {
  final Expression object;
  final Identifier property;
  final List<MemberAccessor> memberAccessors;

  MemberExpression(this.object, this.property,
      {this.memberAccessors = const []});

  @override
  dynamic evaluate([dynamic arg]) {
    var obj = object.evaluate(arg);
    return _getMember(obj, property.name);
  }

  @override
  Expression differentiate() {
    // The derivative of call is just the derivative.
    return MemberExpression(object.differentiate(), property);
  }

  @override
  Expression integrate() {
    // The integral of call the integral.
    return MemberExpression(object.integrate(), property);
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

  dynamic _getMember(dynamic obj, String member) {
    for (var a in memberAccessors) {
      if (a.canHandle(obj, member)) {
        return a.getMember(obj, member);
      }
    }
    throw ExpressionEvaluatorException.memberAccessNotSupported(
        obj.runtimeType, member);
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    if (this == oldExpr) {
      return newExpr;
    }
    return MemberExpression(object.substitute(oldExpr, newExpr), property,
        memberAccessors: memberAccessors);
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
    return 1 + object.depth();
  }

  @override
  int size() {
    return 1 + object.size();
  }

  @override
  Set<Variable> getVariableTerms() {
    return object.getVariableTerms();
  }

  @override
  String toString() => '${object.toString()}.$property';
}
