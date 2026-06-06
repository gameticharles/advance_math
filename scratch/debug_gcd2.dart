import 'package:advance_math/advance_math.dart';

void main() {
  var poly0 = Polynomial.fromString('5*x^6+5*x^5+27*x^4+27*x^3+28*x^2+28*x');
  var poly1 = Polynomial.fromString('5*x^3+7*x');
  print('Poly0 coeffs: ${poly0.coefficients}');
  print('Poly1 coeffs: ${poly1.coefficients}');

  try {
    var remainder = poly0 % poly1;
    print('Remainder: $remainder (${remainder.runtimeType})');
    if (remainder is Polynomial) {
      print('Remainder coeffs: ${(remainder).coefficients}');
    }
  } catch (e, st) {
    print('Remainder Error: $e');
    print(st);
  }

  try {
    var gcdResult = poly0.gcd(poly1);
    print('GCD: $gcdResult');
  } catch (e, st) {
    print('GCD Error: $e');
    var lines = st.toString().split('\n');
    for (var i = 0; i < lines.length && i < 20; i++) {
      print(lines[i]);
    }
  }
}
