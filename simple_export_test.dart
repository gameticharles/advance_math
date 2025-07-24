// Simple test to verify exports work
import 'lib/advance_math.dart';

void main() {
  try {
    // Test that NumToExpressionExtension is accessible
    final expr1 = 5.toExpression();
    print('✓ toExpression() works: ${expr1.runtimeType}');

    // Test that global ex() function is accessible
    final expr2 = ex(10);
    print('✓ ex() function works: ${expr2.runtimeType}');

    print('✓ All enhanced methods are properly exported!');
  } catch (e) {
    print('✗ Error: $e');
  }
}
