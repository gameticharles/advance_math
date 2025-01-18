part of '../../expression.dart';

class Literal extends Expression {
  final dynamic value;
  final String raw;

  // Constructor to initialize the literal's value
  Literal(this.value, [String? raw])
      : raw = raw ?? (value is String ? '"$value"' : '$value');

  @override
  dynamic evaluate([dynamic arg]) {
    if (value is List) return value.map((e) => e.evaluate(arg)).toList();
    if (value is Map) {
      return value.map(
          (key, value) => MapEntry(key.evaluate(arg), value.evaluate(arg)));
    }
    return value;
  }

  @override
  Expression differentiate() {
    // The derivative of a constant is 0
    return Literal(0);
  }

  @override
  Expression integrate() {
    // The integral of a constant is the constant times the variable.
    // We'll represent this by multiplying the Literal with a generic Variable.
    // For now, we'll use 'x' as the default integration variable.
    // Placeholder: Literal times Variable('x').
    // This might be further expanded in future to support custom integration variables.
    return Multiply(this, Variable(Identifier('x')));
  }

  @override
  Expression simplify() {
    // A literal is already in its simplest form
    return this;
  }

  @override
  Expression expand() {
    // A literal is already in its expanded form
    return this;
  }

  @override
  Set<Variable> getVariableTerms() {
    return {};
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    // No substitution possible for a Literal
    return this;
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
    return 1;
  }

  @override
  int size() {
    return 1;
  }

  @override
  String toString() => (value is num && value < 0) ? '($raw)' : raw;

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) => other is Literal && other.value == value;
}
