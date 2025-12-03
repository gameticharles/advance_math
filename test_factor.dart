import 'package:advance_math/advance_math.dart';

void main() {
  print('--- Test (x-1)*(x-2)=0 ---');
  var eq = Expression.parse('(x-1)*(x-2)=0');
  print('Equation: $eq');

  // Expand and Simplify
  var expanded = eq.expand().simplify();
  print('Expanded & Simplified: $expanded');

  // Stringify
  var str = expanded.toString();
  print('String: $str');

  // Clean up
  str = str.replaceAll('*', '');
  str = str.replaceAll(RegExp(r'\.0(?!\d)'), '');
  print('Cleaned: $str');

  // Check isPolynomial
  var isPoly = Polynomial.isPolynomial(str, varName: 'x');
  print('Is polynomial: $isPoly');
  print(Polynomial.fromString(str, variable: Variable('x')));

  // Factorize
  print(Polynomial.fromString(str, variable: Variable('x')).factorize());

  // Roots
  print(Polynomial.fromString(str, variable: Variable('x')).roots());

  // Evaluate
  print(Polynomial.fromString(str, variable: Variable('x')).evaluate(5));
}
