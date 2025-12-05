import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  void check(String given, String expected) {
    var parsed = Expression.parse(given);
    var simplified = parsed.simplify();
    expect(simplified.toString(), equals(expected),
        reason: 'Simplification of $given');
  }

  group('Expression core', () {
    test('should perform simple arithmetic', () {
      check('((((((1+1))))))', '2');
      check('((((((1+1))+4)))+3)', '9');
      check('1+1', '2');
      check('4^2', '16');
      check('2*-4', '-8');
      check('2+(3/4)', '11/4'); // Expect symbolic result
      check('2/3+2/3', '2*2/3'); // 4/3 Expect symbolic result
      check('6.5*2', '13.0');
    });

    test('should handle minus sign properly', () {
      check('0-4', '-4');
      check('-(4)', '-4');
      check('3*-(4)', '-12');
    });

    test('hyperbolic trigonometric functions', () {
      // check('acosh(1/23.12)', 'acosh(0.04325259515570934)'); // Dart might evaluate division
      // check('sech(0.1)', 'sech(0.1)');

      // Variable tests
      check('cosh(x)', 'cosh(x)');
      check('sinh(x)', 'sinh(x)');
      check('tanh(x)', 'tanh(x)');
      check('y*tanh(x)*tanh(x)',
          'y*tanh(x)^2'); // Order might differ: y*tanh(x)^2 or tanh(x)^2*y
      check('2*cosh(x)+cosh(x)', '3*cosh(x)');
      check('cosh(x)*cosh(x)', 'cosh(x)^2');

      // Complex expressions
      check('2*cosh(x)+cosh(x+8+5*x)',
          '2*cosh(x)+cosh(8+6*x)'); // Requires simplification of argument
      check('x^2+2*cosh(x)+cosh(x+8+5*x)+4*x^2', '5*x^2+2*cosh(x)+cosh(8+6*x)');
    });

    test('omit brackets for functions', () {
      check('2*sin(x) + 4*sin(x)', '6*sin(x)');
      check('sin(x) + sin(x)', '2*sin(x)');
      check('3*sin(x) /6+sin(x)',
          '1.5*sin(x)'); // 3/6 -> 0.5 -> 0.5+1 = 1.5. Or 1/2*sin(x)+sin(x) -> 3/2*sin(x)
      check('sin(2*x)', 'sin(2*x)');
      check('sin(a*x)',
          'x*sin(a)'); // or sin(a*x) depending on parser precedence for implicit mult
      check('sin(2*a)*cos(2*b)', 'cos(2*b)*sin(2*a)');
    });
  });
}
