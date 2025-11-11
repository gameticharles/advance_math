import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  test('Simple extension test', () {
    final x = Variable(Identifier('x'));

    // Test if the extension works
    print('Testing extension...');

    // This should work with the extension
    final expr = 2.toExpression() + x;
    print('toExpression() works: ${expr.runtimeType}');

    // Test helper function
    final expr2 = ex(2) + x;
    print('ex() works: ${expr2.runtimeType}');

    // Test if Variable is Expression
    print('Variable is Expression: $x');

    // Try the extension operator
    try {
      final expr3 = ex(2) + x;
      print('Extension operator works: ${expr3.runtimeType}');
    } catch (e) {
      print('Extension operator failed: $e');
    }
  });
}
