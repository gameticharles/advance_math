part of '../../expression.dart';

//http://integral-table.com/downloads/LaplaceTable.pdf
//Laplace assumes all coefficients to be positive

/// An abstract representation of a mathematical expression.
///
/// The `Expression` class provides a framework for representing,
/// evaluating, differentiating, and integrating mathematical expressions.
/// Each specific type of expression (e.g., polynomial, symbolic, function)
/// should extend this class and provide concrete implementations of the
/// required methods.
abstract class Expression {
  static final ExpressionParser _parser = ExpressionParser();

  static Expression? tryParse(String formattedString) {
    final result = _parser.expression.trim().end().parse(formattedString);
    return result is Success ? result.value : null;
  }

  static Expression parse(String formattedString) =>
      _parser.expression.trim().end().parse(formattedString).value;

  // Basic operations.
  /// Add operator. Creates a [Add] expression.
  Expression operator +(Expression other) => Add(this, other);

  /// Subtract operator. Creates a [Subtract] expression.
  Expression operator -(Expression other) => Subtract(this, other);

  /// Multiply operator. Creates a [Multiply] expression.
  Expression operator *(Expression other) => Multiply(this, other);

  /// Divide operator. Creates a [Divide] expression.
  Expression operator /(Expression other) => Divide(this, other);

  /// Modulo operator. Creates a [Modulo] expression.
  // Expression operator %(Expression exp) => Modulo(this, exp);

  /// Power operator. Creates a [Power] expression.
  Expression operator ^(Expression other) => Pow(this, other);

  /// Unary minus operator. Creates a [UnaryMinus] expression.
  Expression operator -() => Negate(this);

  /// Evaluates the expression for a given value of [x].
  ///
  /// This method returns the value of the expression when evaluated at [x].
  /// If [x] is not provided, the method should return the general form of the
  /// expression or a representative value.
  ///
  /// Returns:
  ///   - A `dynamic` representing the evaluated value of the expression.
  dynamic evaluate([dynamic arg]);

  /// Differentiates the expression with respect to a variable.
  ///
  /// This method returns the derivative of the expression. For expressions
  /// involving multiple variables, the differentiation is typically done
  /// with respect to the main variable of the expression.
  ///
  /// Returns:
  ///   - An `Expression` representing the derivative of the expression.
  Expression differentiate();

  /// Integrates the expression with respect to a variable.
  ///
  /// This method returns the integral of the expression. For expressions
  /// involving multiple variables, the integration is typically done
  /// with respect to the main variable of the expression.
  ///
  /// Returns:
  ///   - An `Expression` representing the integral of the expression.
  Expression integrate();

  /// Simplifies the expression, if possible, and returns a new simplified expression.
  Expression simplify();

  /// Expands the expression, if applicable, and returns a new expanded expression.
  Expression expand();

  /// Retrieves all variables present in the expression, including composite
  /// variables like `x^2` or `x*y`.
  ///
  /// Returns:
  ///   A [Set] containing all distinct [Variable] objects found in the expression.
  Set<Variable> getVariableTerms();

  /// Retrieves the base variables present in the expression, effectively
  /// decomposing composite variables into their constituent parts.
  /// For instance, for an expression containing `x^2`, it returns `x`, and
  /// for `x*y`, it returns both `x` and `y`.
  ///
  /// Returns:
  ///   A [Set] containing all distinct base [Variable] objects found in the expression.
  Set<Variable> getVariables() {
    Set<Variable> variables = {};

    void extractBaseVariables(Expression expr) {
      if (expr is Variable) {
        if (expr.toString().contains('^')) {
          var v = expr.toString().split('^');

          extractBaseVariables(Pow(Expression.parse(v[0].substring(1)),
              Expression.parse(v[1].substring(0, v[1].length - 1))));
        } else if (expr.toString().contains('*')) {
          var components = expr.toString().split('*');
          for (var i = 0; i < components.length - 1; i++) {
            for (var j = i + 1; j < components.length; j++) {
              var leftComponent = Expression.parse(
                  components[i].trim().replaceAll(RegExp(r'^\(|\)$'), ''));
              var rightComponent = Expression.parse(
                  components[j].trim().replaceAll(RegExp(r'^\(|\)$'), ''));
              extractBaseVariables(Multiply(leftComponent, rightComponent));
            }
          }
        } else {
          variables.add(expr);
        }
      } else if (expr is BinaryOperationsExpression) {
        extractBaseVariables(expr.left);
        extractBaseVariables(expr.right);
      } else if (expr is UnaryExpression) {
        extractBaseVariables(expr.operand);
      } else if (expr is TrigonometricExpression) {
        extractBaseVariables(expr.operand);
      }
    }

    extractBaseVariables(this);
    return variables;
  }

  /// Replace a sub-expression or a variable with another expression.
  Expression substitute(Expression oldExpr, Expression newExpr) {
    if (this == oldExpr) {
      return newExpr;
    }
    return this; // Override this method in subclasses to handle more complex cases.
  }

  /// Calculate the depth of the expression tree.
  int depth();

  /// Compute the size of the expression based on the number of nodes in its tree.
  int size();

    // Future methods for determining specific properties of the expression.
  bool isIndeterminate(num x);
  bool isInfinity(num x);

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

extension ExpressionExtension on Expression {
   
}

abstract class SimpleExpression extends Expression {
  @override
  String toString() => toString();
}

abstract class CompoundExpression extends Expression {
  @override
  String toString() => '($this)';
}

class ExpressionEvaluatorException implements Exception {
  final String message;

  ExpressionEvaluatorException(this.message);

  ExpressionEvaluatorException.memberAccessNotSupported(
      Type type, String member)
      : this(
            'Access of member `$member` not supported for objects of type `$type`: have you defined a member accessor in the ExpressionEvaluator?');

  @override
  String toString() {
    return 'ExpressionEvaluatorException: $message';
  }
}

class ThisExpression extends Expression {
  @override
  Expression differentiate() => this;

  @override
  evaluate([arg]) => evaluate(arg);

  @override
  Expression expand() => expand();

  @override
  Expression integrate() => integrate();

  @override
  Expression simplify() => simplify();

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    return substitute(oldExpr, newExpr);
  }

  @override
  bool isIndeterminate(num x) => isIndeterminate(x);

  @override
  bool isInfinity(num x) => isInfinity(x);

  @override
  int depth() => depth();

  @override
  int size() => size();

  @override
  Set<Variable> getVariableTerms() => getVariableTerms();
}

typedef SingleMemberAccessor<T> = dynamic Function(T);
typedef AnyMemberAccessor<T> = dynamic Function(T, String member);

abstract class MemberAccessor<T> {
  static const MemberAccessor<Map> mapAccessor =
      MemberAccessor<Map>.fallback(_getMapItem);

  static dynamic _getMapItem(Map map, String key) => map[key];

  const factory MemberAccessor(Map<String, SingleMemberAccessor<T>> accessors) =
      _MemberAccessor;

  const factory MemberAccessor.fallback(AnyMemberAccessor<T> accessor) =
      _MemberAccessorFallback;

  dynamic getMember(T object, String member);

  bool canHandle(dynamic object, String member);
}

class _MemberAccessorFallback<T> implements MemberAccessor<T> {
  final AnyMemberAccessor<T> accessor;

  const _MemberAccessorFallback(this.accessor);
  @override
  bool canHandle(object, String member) {
    if (object is! T) return false;
    return true;
  }

  @override
  dynamic getMember(T object, String member) {
    return accessor(object, member);
  }
}

class _MemberAccessor<T> implements MemberAccessor<T> {
  final Map<String, SingleMemberAccessor<T>> accessors;

  const _MemberAccessor(this.accessors);

  @override
  bool canHandle(object, String member) {
    if (object is! T) return false;
    if (accessors.containsKey(member)) return true;
    return false;
  }

  @override
  dynamic getMember(T object, String member) {
    return accessors[member]!(object);
  }
}

