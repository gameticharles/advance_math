part of '../../expression.dart';

class CallExpression extends Expression {
  final Expression callee;
  final List<Expression> arguments;

  CallExpression(this.callee, this.arguments);

  Expression? _asImplicitMultiplication() {
    if (arguments.length == 1) {
      final c = callee.simplify();
      if (c is Literal) {
        final val = c.value;
        if (val is num || val is Complex || val is Rational) {
          return Multiply(c, arguments.first);
        }
      }
    }
    return null;
  }

  @override
  dynamic evaluate([dynamic arg]) {
    final impl = _asImplicitMultiplication();
    if (impl != null) {
      return impl.evaluate(arg);
    }

    var evCallee = callee.evaluate(arg);
    var aevArguments = arguments.map((e) => e.evaluate(arg)).toList();

    // Check if the callee is a function-like object
    if (evCallee is VarArgsFunction) {
      return evCallee(aevArguments, kwargs: <String, dynamic>{});
    }

    if (evCallee is Function) {
      try {
        if (aevArguments.any((e) => e is Expression)) {
          return CallExpression(
            callee,
            aevArguments.map((e) => e is Expression ? e : Literal(e)).toList(),
          );
        }
        return Function.apply(evCallee, aevArguments);
      } on NoSuchMethodError catch (e) {
        throw ExpressionEvaluatorException(
            "Function call mismatched for '$callee': $e");
      } catch (e) {
        return CallExpression(
          callee,
          aevArguments.map((e) => e is Expression ? e : Literal(e)).toList(),
        );
      }
    }

    throw ExpressionEvaluatorException(
        "Identifier '$callee' evaluated to '${evCallee.runtimeType}' and is not a function.");
  }

  @override
  Expression differentiate([Variable? v]) {
    final impl = _asImplicitMultiplication();
    if (impl != null) {
      return impl.differentiate(v);
    }
    // The derivative of call is just the derivative.
    return CallExpression(callee.differentiate(v), arguments);
  }

  @override
  Expression integrate() {
    final impl = _asImplicitMultiplication();
    if (impl != null) {
      return impl.integrate();
    }
    // The integral of call the integral.
    return CallExpression(callee.integrate(), arguments);
  }

  @override
  Expression simplify() {
    final impl = _asImplicitMultiplication();
    if (impl != null) {
      return impl.simplify();
    }
    return CallExpression(
      callee.simplify(),
      arguments.map((arg) => arg.simplify()).toList(),
    );
  }

  @override
  Expression expand() {
    final impl = _asImplicitMultiplication();
    if (impl != null) {
      return impl.expand();
    }
    return CallExpression(
      callee.expand(),
      arguments.map((arg) => arg.expand()).toList(),
    );
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    if (this == oldExpr) {
      return newExpr;
    }
    final impl = _asImplicitMultiplication();
    if (impl != null) {
      return impl.substitute(oldExpr, newExpr);
    }
    return CallExpression(
      callee.substitute(oldExpr, newExpr),
      arguments.map((arg) => arg.substitute(oldExpr, newExpr)).toList(),
    );
  }

  @override
  bool isIndeterminate(dynamic x) {
    try {
      final val = evaluate(x);
      if (val is Complex) return val.isNaN;
      if (val is num) return val.isNaN;
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  bool isInfinity(dynamic x) {
    try {
      final val = evaluate(x);
      if (val is Complex) return val.isInfinite;
      if (val is num) return val.isInfinite;
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  bool isPoly([bool strict = false]) {
    final impl = _asImplicitMultiplication();
    if (impl != null) {
      return impl.isPoly(strict);
    }
    return false;
  }

  @override
  int depth() {
    final impl = _asImplicitMultiplication();
    if (impl != null) {
      return impl.depth();
    }
    return 1 +
        [callee.depth(), ...arguments.map((arg) => arg.depth())].reduce(dmath.max);
  }

  @override
  int size() {
    final impl = _asImplicitMultiplication();
    if (impl != null) {
      return impl.size();
    }
    return 1 +
        callee.size() +
        arguments.fold(0, (acc, arg) => acc + arg.size());
  }

  @override
  Set<Variable> getVariableTerms() {
    final impl = _asImplicitMultiplication();
    if (impl != null) {
      return impl.getVariableTerms();
    }
    return {
      ...callee.getVariableTerms(),
      ...arguments.expand((arg) => arg.getVariableTerms())
    };
  }

  @override
  String toString() => '${callee.toString()}(${arguments.join(', ')})';
}
