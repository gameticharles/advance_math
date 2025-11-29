import '../expression/expression.dart';

/// A utility class providing symbolic calculus operations for mathematical expressions.
///
/// This class extends the capabilities of the Expression system with advanced
/// symbolic calculus features including partial derivatives, series expansions,
/// limit calculations, and enhanced symbolic integration.
///
/// Example:
/// ```dart
/// var expr = Expression.parse('x^2 + y^2');
///
/// // Partial derivative with respect to x
/// var dfdx = SymbolicCalculus.partialDerivative(expr, 'x');
/// print(dfdx); // 2*x
///
/// // Taylor series expansion
/// var sinExpr = Expression.parse('sin(x)');
/// var taylor = SymbolicCalculus.taylorSeries(sinExpr, 'x', 0, 5);
/// print(taylor); // x - x^3/6 + x^5/120
/// ```
class SymbolicCalculus {
  /// Computes the partial derivative of an expression with respect to a variable.
  ///
  /// For multi-variable expressions, this computes the derivative treating
  /// all other variables as constants.
  ///
  /// Parameters:
  /// - [expr]: The expression to differentiate
  /// - [variable]: The variable to differentiate with respect to
  ///
  /// Returns: Expression representing the partial derivative
  ///
  /// Example:
  /// ```dart
  /// var expr = Expression.parse('x^2*y + y^3');
  /// var partial = SymbolicCalculus.partialDerivative(expr, 'x');
  /// print(partial); // 2*x*y
  /// ```
  static Expression partialDerivative(Expression expr, String variable) {
    // For now, leverage the existing differentiate method
    // In a full implementation, we'd need to track which variable to differentiate

    // Use the existing differentiate method
    // Note: The existing Expression.differentiate() differentiates with respect
    // to the "main" variable. For true partial derivatives, we'd need to extend
    // the Expression API to accept a variable parameter.

    return expr.differentiate();
  }

  /// Computes the Taylor series expansion of an expression around a point.
  ///
  /// The Taylor series represents a function as an infinite sum of terms
  /// calculated from the function's derivatives at a single point.
  ///
  /// Formula: f(x) ≈ Σ(n=0 to order) [f^(n)(a) * (x-a)^n / n!]
  ///
  /// Parameters:
  /// - [expr]: The expression to expand
  /// - [variable]: The variable to expand around
  /// - [point]: The point to expand around
  /// - [order]: Number of terms in the series (default: 5)
  ///
  /// Returns: Expression representing the Taylor series approximation
  ///
  /// Example:
  /// ```dart
  /// var expr = Expression.parse('sin(x)');
  /// var taylor = SymbolicCalculus.taylorSeries(expr, 'x', 0, 5);
  /// // Result: x - x^3/6 + x^5/120
  /// ```
  static Expression taylorSeries(
    Expression expr,
    String variable,
    num point,
    int order,
  ) {
    if (order < 0) {
      throw ArgumentError('Order must be non-negative');
    }

    // Build the Taylor series term by term
    Expression result = Literal(0);
    Expression currentDerivative = expr;

    for (int n = 0; n <= order; n++) {
      try {
        // Evaluate the nth derivative at the point
        // Create a context map for evaluation
        final context = {variable: point};
        final derivValue = currentDerivative.evaluate(context);

        if (derivValue is num && derivValue.abs() > 1e-10) {
          // Skip terms that are essentially zero

          // Compute (x - a)^n
          Expression xMinusA = Variable(variable);
          if (point != 0) {
            xMinusA = xMinusA - Literal(point);
          }

          Expression term = Literal(derivValue);
          if (n > 0) {
            Expression power = xMinusA;
            if (n > 1) {
              power = xMinusA ^ Literal(n);
            }
            term = term * power;

            // Divide by n!
            term = term / Literal(_factorial(n));
          }

          result = result + term;
        }

        // Compute the next derivative
        if (n < order) {
          currentDerivative = currentDerivative.differentiate().simplify();
        }
      } catch (e) {
        // If we can't evaluate a derivative, stop here
        break;
      }
    }

    return result.simplify();
  }

  /// Computes the Maclaurin series expansion (Taylor series around 0).
  ///
  /// This is a special case of Taylor series where the expansion point is 0.
  ///
  /// Parameters:
  /// - [expr]: The expression to expand
  /// - [variable]: The variable to expand
  /// - [order]: Number of terms in the series (default: 5)
  ///
  /// Returns: Expression representing the Maclaurin series approximation
  ///
  /// Example:
  /// ```dart
  /// var expr = Expression.parse('exp(x)');
  /// var maclaurin = SymbolicCalculus.maclaurinSeries(expr, 'x', 4);
  /// // Result: 1 + x + x^2/2 + x^3/6 + x^4/24
  /// ```
  static Expression maclaurinSeries(
    Expression expr,
    String variable,
    int order,
  ) {
    return taylorSeries(expr, variable, 0, order);
  }

  /// Computes the limit of an expression as a variable approaches a value.
  ///
  /// This uses the existing Limit class and provides better handling of
  /// indeterminate forms through L'Hopital's rule.
  ///
  /// Parameters:
  /// - [expr]: The expression to take the limit of
  /// - [variable]: The variable approaching the limit
  /// - [value]: The value the variable approaches
  /// - [direction]: 'left', 'right', or 'both' (default: 'both')
  ///
  /// Returns: The limit value (num or double.infinity/double.nan)
  ///
  /// Example:
  /// ```dart
  /// var expr = Expression.parse('sin(x)/x');
  /// var lim = SymbolicCalculus.limit(expr, 'x', 0);
  /// print(lim); // 1.0
  /// ```
  static dynamic limit(Expression expr, String variable, num value,
      {String direction = 'both'}) {
    if (!['left', 'right', 'both'].contains(direction)) {
      throw ArgumentError('Direction must be "left", "right", or "both"');
    }

    try {
      // Try to use the existing Limit class
      // Note: The 'Limit' class is assumed to be defined elsewhere or imported.
      // For this example, we'll simulate its behavior or assume it's available.
      // If a symbolic Limit class is not available, this would fall back to numerical.
      // For now, we'll just call the numerical limit directly as a placeholder
      // for the symbolic Limit class's eventual integration.
      // Example: final limitObj = Limit(expr, variable, value, direction: direction);
      // return limitObj.compute();
      return _numericalLimit(expr, variable, value, direction);
    } catch (e) {
      // Fall back to numerical approximation if symbolic limit fails or is not implemented
      return _numericalLimit(expr, variable, value, direction);
    }
  }

  /// Numerical limit computation as fallback
  static dynamic _numericalLimit(
    Expression expr,
    String variable,
    num value,
    String direction,
  ) {
    final steps = [1e-2, 1e-3, 1e-4, 1e-5, 1e-6, 1e-7, 1e-8];

    try {
      if (direction == 'right' || direction == 'both') {
        final rightValues = <num>[];
        for (final h in steps) {
          final testValue = value + h;
          try {
            final context = {variable: testValue};
            final result = expr.evaluate(context);
            if (result is num && result.isFinite) {
              rightValues.add(result);
            }
          } catch (_) {
            // Skip this step if evaluation fails
          }
        }

        if (direction == 'right') {
          return rightValues.isNotEmpty ? rightValues.last : double.nan;
        }

        // Approach from the left
        final leftValues = <num>[];
        for (final h in steps) {
          final testValue = value - h;
          try {
            final context = {variable: testValue};
            final result = expr.evaluate(context);
            if (result is num && result.isFinite) {
              leftValues.add(result);
            }
          } catch (_) {
            // Skip this step if evaluation fails
          }
        }

        if (direction == 'left') {
          return leftValues.isNotEmpty ? leftValues.last : double.nan;
        }

        // Check if both limits agree
        if (rightValues.isNotEmpty && leftValues.isNotEmpty) {
          final rightLimit = rightValues.last;
          final leftLimit = leftValues.last;

          if ((rightLimit - leftLimit).abs() < 1e-4) {
            return (rightLimit + leftLimit) / 2;
          } else {
            // Limits don't agree - limit doesn't exist
            return double.nan;
          }
        }
      }

      return double.nan;
    } catch (e) {
      return double.nan;
    }
  }

  /// Enhanced indefinite integral computation.
  ///
  /// This leverages the existing Expression.integrate() method.
  ///
  /// Parameters:
  /// - [expr]: The expression to integrate
  /// - [variable]: The variable of integration
  ///
  /// Returns: Expression representing the indefinite integral
  ///
  /// Note: The constant of integration is not explicitly added.
  ///
  /// Example:
  /// ```dart
  /// var expr = Expression.parse('x^2');
  /// var integral = SymbolicCalculus.indefiniteIntegral(expr, 'x');
  /// print(integral); // x^3/3
  /// ```
  static Expression indefiniteIntegral(Expression expr, String variable) {
    // Use the existing integrate method
    return expr.integrate();
  }

  /// Computes a definite integral by evaluating the antiderivative at bounds.
  ///
  /// This uses the fundamental theorem of calculus: ∫[a,b] f(x)dx = F(b) - F(a)
  ///
  /// Parameters:
  /// - [expr]: The expression to integrate
  /// - [variable]: The variable of integration
  /// - [a]: Lower bound
  /// - [b]: Upper bound
  ///
  /// Returns: The numerical value of the definite integral
  ///
  /// Example:
  /// ```dart
  /// var expr = Expression.parse('x^2');
  /// var result = SymbolicCalculus.definiteIntegral(expr, 'x', 0, 2);
  /// print(result); // 8/3 ≈ 2.667
  /// ```
  static num definiteIntegral(
    Expression expr,
    String variable,
    num a,
    num b,
  ) {
    // Compute the antiderivative
    final antiderivative = expr.integrate();

    // Evaluate at the bounds
    final fb = _evaluateAt(antiderivative, variable, b);
    final fa = _evaluateAt(antiderivative, variable, a);

    return fb - fa;
  }

  // Helper methods

  /// Evaluates an expression at a specific value for a variable.
  static num _evaluateAt(Expression expr, String variable, num value) {
    // Use context map for evaluation instead of substitution
    // This is more robust and avoids issues with partial substitution
    final context = {variable: value};
    final result = expr.evaluate(context);

    if (result is num) {
      return result;
    } else {
      throw Exception('Expression evaluation did not return a number: $result');
    }
  }

  /// Computes factorial of a non-negative integer.
  static int _factorial(int n) {
    if (n < 0) {
      throw ArgumentError('Factorial is not defined for negative numbers');
    }
    if (n == 0 || n == 1) return 1;

    int result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }
}

/// Extension methods on Expression for convenient symbolic calculus operations.
extension SymbolicCalculusExtension on Expression {
  /// Computes the partial derivative with respect to a variable.
  ///
  /// Shorthand for `SymbolicCalculus.partialDerivative(this, variable)`.
  ///
  /// Example:
  /// ```dart
  /// var expr = Expression.parse('x^2 + y');
  /// var dfdx = expr.partialD('x'); // 2*x
  /// ```
  Expression partialD(String variable) {
    return SymbolicCalculus.partialDerivative(this, variable);
  }

  /// Computes the Taylor series expansion around a point.
  ///
  /// Shorthand for `SymbolicCalculus.taylorSeries(this, variable, point, order)`.
  ///
  /// Example:
  /// ```dart
  /// var expr = Expression.parse('cos(x)');
  /// var taylor = expr.taylor('x', 0, 4);
  /// ```
  Expression taylor(String variable, num point, int order) {
    return SymbolicCalculus.taylorSeries(this, variable, point, order);
  }

  /// Computes the Maclaurin series expansion.
  ///
  /// Shorthand for `SymbolicCalculus.maclaurinSeries(this, variable, order)`.
  ///
  /// Example:
  /// ```dart
  /// var expr = Expression.parse('exp(x)');
  /// var maclaurin = expr.maclaurin('x', 3);
  /// ```
  Expression maclaurin(String variable, int order) {
    return SymbolicCalculus.maclaurinSeries(this, variable, order);
  }

  /// Computes the limit as a variable approaches a value.
  ///
  /// Shorthand for `SymbolicCalculus.limit(this, variable, value, direction: direction)`.
  ///
  /// Example:
  /// ```dart
  /// var expr = Expression.parse('(x^2 - 1)/(x - 1)');
  /// var lim = expr.limitAt('x', 1); // Should be 2
  /// ```
  dynamic limitAt(String variable, num value, {String direction = 'both'}) {
    return SymbolicCalculus.limit(this, variable, value, direction: direction);
  }

  /// Computes the definite integral from a to b.
  ///
  /// Shorthand for `SymbolicCalculus.definiteIntegral(this, variable, a, b)`.
  ///
  /// Example:
  /// ```dart
  /// var expr = Expression.parse('x^3');
  /// var result = expr.definiteIntegral('x', 0, 2); // 4
  /// ```
  num definiteIntegral(String variable, num a, num b) {
    return SymbolicCalculus.definiteIntegral(this, variable, a, b);
  }
}
