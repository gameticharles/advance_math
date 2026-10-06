import 'package:advance_math/src/math/algebra/expression/expression.dart';

void main() {
  final parser = ExpressionParser();
  // Construct poly
  int n = 5;
  List<dynamic> coeffs = List.filled(n + 1, Literal(0));
  coeffs[0] = Literal(1);
  coeffs[n] = Literal(1);
  Polynomial poly = Polynomial.fromList(coeffs, variable: Variable('x'));
  final r = poly.roots();
  print('Roots expressions:');
  for (int i = 0; i < r.length; i++) {
    final e = r[i];
    print('root $i: $e (${e.runtimeType})');
    print('  toString(): ${e.toString()}');
    print('  simplify(): ${e.simplify()}');
    print('  evaluate(): ${e.evaluate()} (${e.evaluate().runtimeType})');
  }
}
