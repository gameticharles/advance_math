import 'package:advance_math/advance_math.dart';

void main() {
  print('Test 1: Parse equation');
  var eq = Expression.parse('x^2-1=0');
  print('Parsed: $eq (type: ${eq.runtimeType})');

  print('\nTest 2: Expand and simplify');
  var expanded = eq.expand();
  print('Expanded: $expanded');
  var simplified = expanded.simplify();
  print('Simplified: $simplified');

  print('\nTest 3: Convert to string');
  var str = simplified.toString();
  print('String: $str');

  print('\nTest 4: Clean up string');
  str = str.replaceAll('*', '');
  str = str.replaceAll(RegExp(r'\.0(?!\d)'), '');
  print('Cleaned: $str');

  print('\nTest 5: Check isPolynomial');
  var isPoly = Polynomial.isPolynomial(str, varName: 'x');
  print('Is polynomial: $isPoly');

  if (isPoly) {
    print('\n Test 6: Parse as Polynomial');
    try {
      var poly = Polynomial.fromString(str, variable: Variable('x'));
      print('Polynomial: $poly');
      print('Coefficients: ${poly.coefficients}');

      print('\nTest 7: Get roots');
      var roots = poly.roots();
      print('Roots: $roots');
    } catch (e, s) {
      print('Error: $e');
      print(s);
    }
  }
}
