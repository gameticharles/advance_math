import 'package:advance_math/src/math/algebra/expression/expression.dart';

void main() {
  void check(String source) {
    try {
      print('Parsing "$source"...');
      var poly = Polynomial.fromString(source);
      print('Success: $poly');
      print('Coefficients: ${poly.coefficients}');
    } catch (e) {
      print('Failed: $e');
    }
  }

  check('x^2-1-0');
  check('x^2+2x+1-0');
  check('2x');
  check('-1');
  check('x');
  check('x^2');
  check('x^2 - 1');
  check('x^2-1');
  check('x^2-1=0'
      .replaceAll('=', '-')); // Simulate equation to subtract conversion
  check('x/2');
  check('x+a');
}
