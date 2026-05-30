import 'package:advance_math/advance_math.dart';

Expression _normalizeForPoly(Expression e) {
  if (e is Subtract) {
    return Add(_normalizeForPoly(e.left),
        Multiply(Literal(-1), _normalizeForPoly(e.right)));
  }
  if (e is Add) {
    return Add(_normalizeForPoly(e.left), _normalizeForPoly(e.right));
  }
  if (e is Multiply) {
    return Multiply(_normalizeForPoly(e.left), _normalizeForPoly(e.right));
  }
  if (e is Divide) {
    return Divide(_normalizeForPoly(e.left), _normalizeForPoly(e.right));
  }
  if (e is Pow) {
    return Pow(_normalizeForPoly(e.left), _normalizeForPoly(e.right));
  }
  if (e is UnaryExpression) {
    if (e.operator == '-') {
      return Multiply(Literal(-1), _normalizeForPoly(e.operand));
    }
    if (e.operator == '+') {
      return _normalizeForPoly(e.operand);
    }
    return UnaryExpression(e.operator, _normalizeForPoly(e.operand),
        prefix: e.prefix);
  }
  if (e is GroupExpression) {
    return _normalizeForPoly(e.expression);
  }
  return e;
}

void main() {
  final equation = Expression.parse('((x+1)*((x+1)+1))/2=n');
  print('equation = $equation');
  
  final normalized = _normalizeForPoly(equation).simplify();
  print('normalized = $normalized');
  
  final simplified = normalized.expand().simplify();
  print('simplified = $simplified');
  print('simplified.runtimeType = ${simplified.runtimeType}');
}
