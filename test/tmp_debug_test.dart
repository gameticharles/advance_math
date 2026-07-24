import 'package:advance_math/advance_math.dart';

void main() {
  var expression = ExpressionParser();
  var result = expression.parse('partfrac((3*x+2)/(x^2+x), x)');
  print('Result: $result');
  print('Evaluated: ${result.evaluate()}');
  
  // Also test factor
  var f1 = Polynomial.fromString('x^2+x');
  print('Factors: ${f1.factorize()}');
  
  // Test expand/factor
  var r2 = expression.parse('expand((x+5)(x-3)-x^2)');
  print('Expand parse: $r2');
  var r3 = r2.expand().simplify();
  print('Expand result: $r3');
  
  // Test factor(x^2+x+1/4)
  var r4 = expression.parse('factor(x^2+x+1/4)');
  print('Factor: $r4');
  print('Factor simplified: ${r4.simplify()}');
  
  // Test factor(x^2+2*x+1)
  var r5 = expression.parse('factor(x^2+2*x+1)');
  print('Factor 2: $r5');
  
  // Test solve
  var r6 = expression.parse('solve(8*x^3-26*x^2+3*x+9, x)');
  print('Solve: $r6');
  
  // Test roots
  var r7 = expression.parse('roots((-1)^(1/5))');
  print('Roots: $r7');
  print('Roots evaluated: ${r7.evaluate()}');
}
