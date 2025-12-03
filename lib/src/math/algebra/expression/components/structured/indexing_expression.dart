part of '../../expression.dart';

class IndexExpression extends Expression {
  final Expression object;
  final Expression index;

  IndexExpression(this.object, this.index);

  @override
  dynamic evaluate([dynamic arg]) {
    var obj = object.evaluate(arg);
    var idx = index.evaluate(arg);

    if (obj is List) {
      if (idx is int) {
        if (idx < 0) {
          idx += obj.length;
        }
        return obj[idx];
      }
      if (idx is Range) {
        var indices = idx.toList();
        return indices.map((i) {
          if (i < 0) i += obj.length;
          return obj[i.toInt()];
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
  bool isIndeterminate(num x) {
    throw UnimplementedError();
  }

  @override
  bool isInfinity(num x) {
    throw UnimplementedError();
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
