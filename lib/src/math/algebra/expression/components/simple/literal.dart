part of '../../expression.dart';

class Literal extends Expression {
  final dynamic value;
  final String raw;

  // Constructor to initialize the literal's value
  Literal(dynamic val, [String? raw])
      : value = (val is Complex) ? val.simplify() : val,
        raw = raw ?? (val is String ? '"$val"' : (val is Complex ? '${val.simplify()}' : '$val'));

  @override
  dynamic evaluate([dynamic arg]) {
    if (value is List) {
      final mapped = (value as List)
          .map((e) {
            if (e is Expression) {
              if (e.getVariableTerms().isEmpty) {
                try {
                  return e.evaluate(arg);
                } catch (_) {
                  return e;
                }
              }
              if (arg is Map &&
                  e.getVariableTerms().every((v) => arg.containsKey(v.identifier.name))) {
                try {
                  return e.evaluate(arg);
                } catch (_) {
                  return e;
                }
              }
              return e;
            }
            return e;
          })
          .toList();
      if (value is SolverList) {
        return SolverList(mapped, (value as SolverList)._customString);
      }
      return mapped;
    }
    if (value is Map) {
      return (value as Map).map((key, value) => MapEntry(
          (key is Expression) ? key.evaluate(arg) : key,
          (value is Expression) ? value.evaluate(arg) : value));
    }
    if (value is num || value is Rational) {
      return _normalizeResult(Complex(value));
    }
    return value;
  }

  @override
  Expression differentiate([Variable? v]) {
    if (value is List) {
      final diffList = (value as List).map((e) {
        if (e is Expression) return e.differentiate(v).simplify();
        return Literal(0);
      }).toList();
      return Literal(diffList, diffList.toString());
    }
    // The derivative of a constant is always 0
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
  bool isIndeterminate(dynamic x) {
    if (value is Complex) return (value as Complex).isNaN;
    if (value is num) return (value as num).isNaN;
    return false;
  }

  @override
  bool isInfinity(dynamic x) {
    if (value is Complex) return (value as Complex).isInfinite;
    if (value is num) return (value as num).isInfinite;
    return false;
  }

  @override
  bool isPoly([bool strict = false]) => true;

  @override
  int depth() {
    return 1;
  }

  @override
  int size() {
    return 1;
  }

  @override
  String toString() => raw;

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) => other is Literal && other.value == value;
}
