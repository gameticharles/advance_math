import 'package:advance_math/advance_math.dart';

void main() {
  final cases = [
    ['5*x^6+5*x^5+27*x^4+27*x^3+28*x^2+28*x', '5*x^3+7*x'],
    ['2*x^2+2*x+1', 'x+1'],
    ['x^2+2*x+1', 'x+1'],
    ['6*x^9+24*x^8+15*x^7+6*x^2+24*x+15', '2*x^2+8*x+5'],
    ['x^8+4*x^7+4*x^6+3*x^5+12*x^4+12*x^3', 'x^3+3'],
    ['6*x^9+24*x^8+15*x^7+6*x^2+24*x+15', 'x^7+1'],
    ['1+x^2', '2*x'],
    ['84*x^4+147*x^3+16*x^2+28*x', '44*x^5+77*x^4+16*x^3+28*x^2+12*x+21'],
  ];

  for (var pair in cases) {
    try {
      var p0 = Polynomial.fromString(pair[0]);
      var p1 = Polynomial.fromString(pair[1]);
      var g = p0.gcd(p1);
      print('gcd(${pair[0]}, ${pair[1]})');
      print('  Polynomial.toString(): ${g.toString()}');
      print('  coefficients: ${g.coefficients}');
      print('  degree: ${g.degree}');
      // build expression manually
      Expression result = Literal(0);
      for (int i = 0; i < g.coefficients.length; i++) {
        var coeff = g.coefficients[i];
        int deg = g.degree - i;
        Expression term;
        if (deg == 0) {
          term = coeff;
        } else if (deg == 1) {
          term = Multiply(coeff, g.variable);
        } else {
          term = Multiply(coeff, Pow(g.variable, Literal(deg)));
        }
        if (result is Literal && (result).value == 0) {
          result = term;
        } else {
          result = Add(result, term);
        }
      }
      print('  reconstructed expr: ${result.simplify()}');
      print('');
    } catch (e, st) {
      print('Error: $e');
      print(st.toString().split('\n').take(5).join('\n'));
    }
  }
}
