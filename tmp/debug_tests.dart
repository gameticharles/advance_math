import 'package:advance_math/advance_math.dart';

void main() {
  var ep = ExpressionParser();

  // Debug deg
  print('=== DEG ===');
  print('deg(x^2+2*x+x^5): ${ep.parse('deg(x^2+2*x+x^5)')}');
  print('deg(x^2+2*x+x^x): ${ep.parse('deg(x^2+2*x+x^x)')}');
  print('deg(x^2+2*x+cos(x)): ${ep.parse('deg(x^2+2*x+cos(x))')}');
  print('deg(x^a+x^b+x^c,x): ${ep.parse('deg(x^a+x^b+x^c,x)')}');
  print('deg(a*x^2+b*x+c,x): ${ep.parse('deg(a*x^2+b*x+c,x)')}');

  // Debug pfactor - understand the evaluate() behavior
  print('\n=== PFACTOR ===');
  var factExpr = ep.parse('100!');
  print('100! type: ${factExpr.runtimeType}');
  print('100! toString: $factExpr');
  try {
    var v = factExpr.evaluate();
    print('100! eval result: $v');
    print('100! eval type: ${v.runtimeType}');
  } catch (e) {
    print('100! eval error: $e');
  }

  var pfact8 = ep.parse('pfactor(8)');
  print('pfactor(8) toString: $pfact8');
  try {
    print('pfactor(8) eval: ${pfact8.evaluate()}');
  } catch (e) {
    print('pfactor(8) eval error: $e');
  }

  var pfact100 = ep.parse('pfactor(100)');
  print('pfactor(100) toString: $pfact100');
  try {
    print('pfactor(100) eval: ${pfact100.evaluate()}');
  } catch (e) {
    print('pfactor(100) eval error: $e');
  }

  // Test pfactor(15!+1)
  print('\n=== PFACTOR EXPRESSIONS ===');
  var pf15 = ep.parse('pfactor(15!+1)');
  print('pfactor(15!+1) toString: $pf15');

  // Try to understand 15!+1
  var expr15 = ep.parse('15!+1');
  print('15!+1 type: ${expr15.runtimeType}');
  try {
    var v = expr15.evaluate();
    print('15!+1 eval: $v type: ${v.runtimeType}');
  } catch (e) {
    print('15!+1 eval error: $e');
  }

  // factorial(15)
  print('factorial(15) = ${factorial(15)}');
  print('factorial(15)+1 = ${factorial(15) + 1}');
}
