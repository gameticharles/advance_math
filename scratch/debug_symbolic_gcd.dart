import 'package:advance_math/advance_math.dart';

void main() {
  var parser = ExpressionParser();
  
  print('Testing gcd(a, b, c):');
  try {
    var result = parser.parse('gcd(a, b, c)');
    print('  result: $result');
    print('  type: ${result.runtimeType}');
  } catch(e, st) {
    print('  Error: $e');
    print(st.toString().split('\n').take(5).join('\n'));
  }
  
  print('');
  print('Testing gcd(a,a,b,b,gcd(c,c)):');
  try {
    var result = parser.parse('gcd(a,a,b,b,gcd(c,c))');
    print('  result: $result');
    print('  type: ${result.runtimeType}');
  } catch(e, st) {
    print('  Error: $e');
    print(st.toString().split('\n').take(5).join('\n'));
  }
}
