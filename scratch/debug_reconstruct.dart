import 'package:advance_math/advance_math.dart';

// Reconstruct expression from polynomial
Expression reconstructExpr(Polynomial g) {
  // Build in HIGH to LOW degree order (like the parser does)
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
  return result.simplify();
}

void main() {
  var cases = [
    ['5*x^3+7*x', '5*x^3+7*x'],
    ['2*x^2+8*x+5', '2*x^2+8*x+5'],
    ['x^3+3', '3+x^3'],
    ['x^7+1', '1+x^7'],
    ['4*x+7', '4*x+7'],
    ['5*x^5+x', '5*x^5+x'],
    ['7*x^3+4*x+1', '1+4*x+7*x^3'],
  ];

  for (var pair in cases) {
    try {
      var p = Polynomial.fromString(pair[0]);
      var result = reconstructExpr(p);
      print('Input: ${pair[0]}');
      print('  expected:  ${pair[1]}');
      print('  got:       $result');
      print('  match: ${result.toString() == pair[1]}');
      print('');
    } catch (e) {
      print('Error for ${pair[0]}: $e\n');
    }
  }
}
