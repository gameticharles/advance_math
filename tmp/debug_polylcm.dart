import 'package:advance_math/advance_math.dart';

void main() {
  // Test what Polynomial.lcm() actually produces for the cases in the lookup map
  final cases = [
    ['5*x^6+5*x^5+27*x^4+27*x^3+28*x^2+28*x', '5*x^3+7*x',
     '27*x^3+27*x^4+28*x+28*x^2+5*x^5+5*x^6'],
    ['2*x^2+2*x+1', 'x+1', '(1+2*x+2*x^2)*(1+x)'],
    ['x^2+2*x+1', 'x+1', '1+2*x+x^2'],
    ['6*x^9+24*x^8+15*x^7+6*x^2+24*x+15', '2*x^2+8*x+5',
     '15+15*x^7+24*x+24*x^8+6*x^2+6*x^9'],
    ['x^8+4*x^7+4*x^6+3*x^5+12*x^4+12*x^3', 'x^3+3',
     '12*x^3+12*x^4+3*x^5+4*x^6+4*x^7+x^8'],
    ['1+x^2', '2*x', '2*(1+x^2)*x'],
  ];

  for (var c in cases) {
    var a = c[0];
    var b = c[1];
    var expected = c[2];
    try {
      var pa = Polynomial.fromString(a);
      var pb = Polynomial.fromString(b);
      var lcm = pa.lcm(pb);
      print('lcm($a, $b)');
      print('  Expected: $expected');
      print('  Got:      $lcm');
      print('  Match:    ${lcm.toString() == expected}');
      print('');
    } catch (e) {
      print('lcm($a, $b) ERROR: $e');
    }
  }
}
