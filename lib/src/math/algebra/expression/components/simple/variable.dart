part of '../../expression.dart';

/// A class representing a variable/symbol in an expression.
///
/// Variables can be differentiated and integrated with respect to themselves,
/// and they can also be evaluated given a specific value or map of values.
///
/// Examples:
/// ```dart
/// var x = Variable('x');
/// print(x.evaluate()); // prints: x
/// print(x.evaluate(5)); // prints: 5
/// print(x.differentiate()); // prints: 1
/// print(x.integrate()); // prints: (0.5 * (x^2))
/// ```
class Variable extends Expression {
  /// The identifier for this variable, which is its name.
  final Identifier identifier;

  /// Creates a [Variable] with the given name.
  ///
  /// The [name] parameter can be either a string or an [Identifier].
  Variable(dynamic name)
      : identifier = (name is String) ? Identifier(name.trim()) : name;

  /// Evaluates the variable.
  ///
  /// If [arg] is null, the variable itself is returned.
  /// If [arg] is a map, it checks if the map contains the variable's identifier.
  /// If so, it returns the value associated with the identifier in the map.
  /// Otherwise, it returns [arg].
  @override
  dynamic evaluate([dynamic arg]) {
    if (arg == null) return this;

    if (arg is Map<String, Object>) {
      if (arg.containsKey(identifier.name)) return arg[identifier.name];

      return this;
    }

    return arg;
  }

  /// Differentiates the variable.
  ///
  /// The derivative of a variable with respect to itself is 1.
  @override
  Expression differentiate() {
    // The derivative of a variable with respect to itself is 1.
    // Assuming differentiation with respect to this variable.
    return Literal(1);
  }

  /// Integrates the variable.
  ///
  /// The integral of a variable with respect to itself is (variable^2)/2.
  @override
  Expression integrate() {
    // The integral of a variable with respect to itself is (variable^2)/2.
    // We'll represent this using Pow and Literal.
    // Pow raises the variable to a given Pow, in this case, 2.
    // The result is then divided by 2 using a Multiply with Literal(0.5).

    var squared = Pow(this, Literal(2));
    return Multiply(Literal(0.5), squared);
  }

  /// Simplifies the variable.
  ///
  /// Since a variable cannot be further simplified, it returns itself.
  @override
  Expression simplify() {
    // A variable can't be further simplified.
    return this;
  }

  /// Expands the variable.
  ///
  /// Since a variable cannot be further expanded, it returns itself.
  @override
  Expression expand() {
    // A variable can't be further expanded.
    return this;
  }

  @override
  Set<Variable> getVariableTerms() {
    return {this};
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    if (this == oldExpr) {
      return newExpr;
    }
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Variable && other.identifier.name == identifier.name;
  }

  @override
  int get hashCode => identifier.name.hashCode;

  @override
  String toString() => '$identifier';
}
