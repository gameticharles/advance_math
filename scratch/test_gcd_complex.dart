import 'package:advance_math/advance_math.dart';

void main() {
  var parser = ExpressionParser();
  try {
    var parsed = parser.parse('gcd(6*x^9+24*x^8+15*x^7+6*x^2+24*x+15, (2*x^2+8*x+5))');
    print('Parsed type: ${parsed.runtimeType}');
    print('Parsed toString: $parsed');
    var eval = parsed.evaluate();
    print('Evaluated type: ${eval.runtimeType}');
    print('Evaluated toString: $eval');
  } catch (e, st) {
    print('Error: $e');
    print(st);
  }
}
