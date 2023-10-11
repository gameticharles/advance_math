part of algebra;

/// An abstract representation of a mathematical expression.
///
/// The `Expression` class provides a framework for representing,
/// evaluating, differentiating, and integrating mathematical expressions.
/// Each specific type of expression (e.g., polynomial, symbolic, function)
/// should extend this class and provide concrete implementations of the
/// required methods.
abstract class Expression {
  /// Evaluates the expression for a given value of [x].
  ///
  /// This method returns the value of the expression when evaluated at [x].
  /// If [x] is not provided, the method should return the general form of the
  /// expression or a representative value.
  ///
  /// Returns:
  ///   - A `dynamic` representing the evaluated value of the expression.
  dynamic evaluate([dynamic x]);

  /// Differentiates the expression with respect to a variable.
  ///
  /// This method returns the derivative of the expression. For expressions
  /// involving multiple variables, the differentiation is typically done
  /// with respect to the main variable of the expression.
  ///
  /// Returns:
  ///   - An `Expression` representing the derivative of the expression.
  dynamic differentiate([dynamic x]);

  /// Integrates the expression with respect to a variable.
  ///
  /// This method returns the integral of the expression. For expressions
  /// involving multiple variables, the integration is typically done
  /// with respect to the main variable of the expression.
  ///
  /// Returns:
  ///   - An `Expression` representing the integral of the expression.
  dynamic integrate([dynamic start, dynamic end]);

  // Future methods for determining specific properties of the expression.
  bool isIndeterminate(num x);
  bool isInfinity(num x);

  /// Returns the simple form of the expression
  Expression simplify();

  /// Returns the string representation of the expression.
  ///
  /// This method should provide a human-readable format of the expression,
  /// suitable for display or printing.
  ///
  /// Returns:
  ///   - A `String` representing the expression.
  @override
  String toString();
}
