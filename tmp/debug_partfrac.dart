import 'package:advance_math/advance_math.dart';

void main() {
  // Test case: partfrac((3*x+2)/(x^2+x), x)
  // Expected: (1+x)^(-1)+2*x^(-1)
  // Denominator: x^2+x = x*(x+1)

  var den = 'x^2+x';
  print('Testing denominator: $den');
  try {
    var poly = Polynomial.fromString(den);
    print('  Degree: ${poly.degree}');
    print('  Coefficients: ${poly.coefficients}');
    try {
      var factors = poly.factorize();
      print('  Factors: $factors');
    } catch (e) {
      print('  factorize() error: $e');
    }
  } catch (e) {
    print('  fromString error: $e');
  }

  print('');
  print('Testing denominator: x^2-2*x-15');
  try {
    var poly = Polynomial.fromString('x^2-2*x-15');
    print('  Degree: ${poly.degree}');
    var factors = poly.factorize();
    print('  Factors: $factors');
  } catch (e) {
    print('  Error: $e');
  }

  print('');
  print('Testing denominator: (x+1)^2');
  try {
    var poly = Polynomial.fromString('(x+1)^2');
    print('  Degree: ${poly.degree}');
    var factors = poly.factorize();
    print('  Factors: $factors');
  } catch (e) {
    print('  Error: $e');
  }

  print('');
  print('Testing numerator parse: 3*x+2');
  try {
    var poly = Polynomial.fromString('3*x+2');
    print('  Degree: ${poly.degree}');
    print('  Coefficients: ${poly.coefficients}');
  } catch (e) {
    print('  Error: $e');
  }

  print('');
  print('Testing Divide detection in parse:');
  var expr = ExpressionParser().parse('(3*x+2)/(x^2+x)');
  print('  Expression type: ${expr.runtimeType}');
  print('  Expression: $expr');
  if (expr is Divide) {
    print('  Left: ${expr.left} (${expr.left.runtimeType})');
    print('  Right: ${expr.right} (${expr.right.runtimeType})');
  }

  print('');
  print('Testing full partfrac parse:');
  try {
    var result = ExpressionParser().parse('partfrac((3*x+2)/(x^2+x), x)');
    print('  Result type: ${result.runtimeType}');
    print('  Result: $result');
    try {
      print('  Evaluated: ${result.evaluate()}');
    } catch (e) {
      print('  evaluate() error: $e');
    }
  } catch (e) {
    print('  parse error: $e');
  }
}
