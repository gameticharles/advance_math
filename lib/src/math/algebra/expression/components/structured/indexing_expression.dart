part of '../../expression.dart';

class IndexExpression extends Expression {
  final Expression object;
  final Expression index;

  IndexExpression(this.object, this.index);

  @override
  dynamic evaluate([dynamic arg]) {
    var obj = object.evaluate(arg);
    var idx = index.evaluate(arg);

    if (idx is Complex && idx.isReal && idx.imaginary == 0) {
      idx = idx.real;
    }
    if (idx is num && idx == idx.toInt()) {
      idx = idx.toInt();
    }

    if (obj is List) {
      if (idx is int) {
        if (idx < 0) {
          idx += obj.length;
        }
        return obj[idx];
      }
      if (idx is Range) {
        var indices = idx.toList();
        return indices.map((dynamic i) {
          if (i is Complex && i.isReal && i.imaginary == 0) i = i.real;
          if (i is num) {
            if (i < 0) i += obj.length;
            return obj[i.toInt()];
          }
          throw Exception('Invalid index type in range: ${i.runtimeType}');
        }).toList();
      }
    }
    return obj[idx];
  }

  @override
  Expression differentiate([Variable? v]) {
    // The derivative of index is just the negation of the derivative.
    return this;
  }

  @override
  Expression integrate() {
    // The integral of index is the negation of the integral.
    return this;
  }

  @override
  Expression simplify() {
    return this;
  }

  @override
  Expression expand() {
    // Index doesn't expand further, return as-is.
    return this;
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    if (this == oldExpr) {
      return newExpr;
    }
    return IndexExpression(
      object.substitute(oldExpr, newExpr),
      index.substitute(oldExpr, newExpr),
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
  bool isPoly([bool strict = false]) => false;

  @override
  int depth() {
    return 1 + max(object.depth(), index.depth());
  }

  @override
  int size() {
    return 1 + object.size() + index.size();
  }

  @override
  Set<Variable> getVariableTerms() {
    return {...object.getVariableTerms(), ...index.getVariableTerms()};
  }

  @override
  String toString() => '${object.toString()}[$index]';
}
