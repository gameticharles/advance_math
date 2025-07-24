import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  group('NumToExpressionExtension Basic Tests', () {
    test('toExpression method should work', () {
      final expr = 5.toExpression();
      expect(expr, isA<Literal>());
      expect((expr as Literal).value, equals(5));
    });

    test('Extension methods are available', () {
      // Test that the extension methods exist and can be called
      final expr1 = 5.toExpression();
      final expr2 = 3.14.toExpression();
      final expr3 = (-7).toExpression();
      
      expect(expr1, isA<Literal>());
      expect(expr2, isA<Literal>());
      expect(expr3, isA<Literal>());
      
      expect((expr1 as Literal).value, equals(5));
      expect((expr2 as Literal).value, equals(3.14));
      expect((expr3 as Literal).value, equals(-7));
    });

    test('Operator overloads exist and work with Variables', () {
      final x = Variable(Identifier('x'));
      
      // These should work because the extension provides operator overloads
      // that take Expression parameters
      Expression addExpr = 2.toExpression() + x;
      Expression subExpr = 5.toExpression() - x;
      Expression mulExpr = 3.toExpression() * x;
      Expression divExpr = 10.toExpression() / x;
      Expression powExpr = 2.toExpression() ^ x;
      
      expect(addExpr, isA<Add>());
      expect(subExpr, isA<Subtract>());
      expect(mulExpr, isA<Multiply>());
      expect(divExpr, isA<Divide>());
      expect(powExpr, isA<Pow>());
    });

    test('Type consistency between extension and explicit Literal', () {
      final x = Variable(Identifier('x'));
      
      // Compare extension usage with explicit Literal construction
      final expr1 = 5.toExpression() + x; // Using extension
      final expr2 = Literal(5) + x; // Explicit construction
      
      expect(expr1.toString(), equals(expr2.toString()));
      expect(expr1.runtimeType, equals(expr2.runtimeType));
    });

    test('Extension works with different numeric types', () {
      // Test with int
      final intExpr = 42.toExpression();
      expect((intExpr as Literal).value, equals(42));
      
      // Test with double
      final doubleExpr = 3.14159.toExpression();
      expect((doubleExpr as Literal).value, equals(3.14159));
      
      // Test with negative numbers
      final negExpr = (-100).toExpression();
      expect((negExpr as Literal).value, equals(-100));
      
      // Test with zero
      final zeroExpr = 0.toExpression();
      expect((zeroExpr as Literal).value, equals(0));
    });
  });
}