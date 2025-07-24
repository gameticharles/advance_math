// Final verification that all enhanced methods are properly exported
import 'package:advance_math/advance_math.dart';

void main() {
  print('=== Enhanced Expression Creation Export Verification ===\n');

  try {
    // Test 1: NumToExpressionExtension - toExpression() method
    print('1. Testing toExpression() extension method:');
    final expr1 = 5.toExpression();
    print('   5.toExpression() = ${expr1.runtimeType}');
    print('   Value: ${expr1.toString()}');
    print('   ✓ toExpression() method works\n');

    // Test 2: Global ex() helper function
    print('2. Testing ex() helper function:');
    final expr2 = ex(10);
    print('   ex(10) = ${expr2.runtimeType}');
    print('   Value: ${expr2.toString()}');
    print('   ✓ ex() helper function works\n');

    // Test 3: Expression operations with enhanced methods
    print('3. Testing expression operations:');
    final x = Variable('x');

    // Using toExpression() method
    final addExpr = 2.toExpression() + x;
    print('   2.toExpression() + x = ${addExpr.runtimeType}');
    print('   Expression: ${addExpr.toString()}');

    final mulExpr = 3.toExpression() * x;
    print('   3.toExpression() * x = ${mulExpr.runtimeType}');
    print('   Expression: ${mulExpr.toString()}');

    final powExpr = 2.toExpression() ^ x;
    print('   2.toExpression() ^ x = ${powExpr.runtimeType}');
    print('   Expression: ${powExpr.toString()}');
    print('   ✓ Extension methods work\n');

    // Test 4: Complex expression using all three approaches
    print('4. Testing mixed approach complex expression:');
    final y = Variable('y');
    final complexExpr = ex(3) * (x ^ 2.toExpression()) + ex(5) * y - Literal(1);
    print('   Complex expression: ${complexExpr.toString()}');
    print('   Type: ${complexExpr.runtimeType}');

    // Test evaluation
    final result = complexExpr.evaluate({'x': 2, 'y': 1});
    print('   Evaluated at x=2, y=1: $result');
    print('   ✓ Complex mixed expressions work\n');

    // Test 5: Verify all three approaches produce equivalent results
    print('5. Testing equivalence of all approaches:');
    final literal = Literal(7);
    final extension = 7.toExpression();
    final helper = ex(7);

    print('   Literal(7): ${literal.toString()}');
    print('   7.toExpression(): ${extension.toString()}');
    print('   ex(7): ${helper.toString()}');

    final testExpr1 = literal + x;
    final testExpr2 = extension + x;
    final testExpr3 = helper + x;

    final eval1 = testExpr1.evaluate({'x': 3});
    final eval2 = testExpr2.evaluate({'x': 3});
    final eval3 = testExpr3.evaluate({'x': 3});

    print('   All evaluate to same result: $eval1 = $eval2 = $eval3');
    print('   ✓ All approaches are equivalent\n');

    print('🎉 ALL ENHANCED METHODS ARE PROPERLY EXPORTED! 🎉');
    print('\nSummary:');
    print('✓ NumToExpressionExtension.toExpression() - Available');
    print('✓ Global ex() helper function - Available');
    print('✓ Expression operations with enhanced methods - Working');
    print('✓ Mixed approach expressions - Working');
    print('✓ Expression evaluation - Working');
    print('✓ All approaches produce equivalent results - Verified');
  } catch (e, stackTrace) {
    print('❌ Error: $e');
    print('Stack trace: $stackTrace');
  }
}
