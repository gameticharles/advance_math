import 'package:advance_math/advance_math.dart';

void main() {
  final context = {...defaultContext};
  final parser = ExpressionParser();

  final tests = [
    'sinh(1)',
    'cosh(1)',
    'tanh(1)',
    'csch(1)',
    'sech(1)',
    'coth(1)',
    'asinh(1)',
    'acosh(1)',
    'atanh(0.5)',
    'vers(pi/2)',
    'covers(pi/2)',
    'havers(pi/2)',
    'exsec(pi/3)',
    'excsc(pi/6)',
    'mod(10, 3)',
    'sinc(pi/2)',
    'i * i',
    'exp(i * pi) + 1', // Euler's identity
  ];

  for (var expr in tests) {
    try {
      var result = parser.parse(expr).evaluate(context);
      print('Expression: $expr => $result');
    } catch (e) {
      print('FAILED: $expr - $e');
    }
  }
}
