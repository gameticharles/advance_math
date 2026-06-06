import 'package:advance_math/advance_math.dart';

void main() {
  var parser = ExpressionParser();
  
  var tests = [
    '2*x^2+8*x+5',
    '4*x+7',
    '1+4*x+7*x^3',
    '7+4*x',
    '5+2*x^2+8*x',
    '1+7*x^3+4*x',
  ];
  
  for (var t in tests) {
    var e = parser.parse(t);
    print('parse("$t").toString() = ${e.toString()}');
    print('parse("$t").simplify().toString() = ${e.simplify().toString()}');
    print('');
  }
}
