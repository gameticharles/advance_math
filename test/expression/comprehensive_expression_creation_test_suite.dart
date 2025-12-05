import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  group('Comprehensive Expression Creation Methods Test Suite', () {
    late Variable x;
    late Variable y;
    late Variable z;

    setUp(() {
      x = Variable(Identifier('x'));
      y = Variable(Identifier('y'));
      z = Variable(Identifier('z'));
    });

    group('Integration Tests - All Three Approaches Comparison', () {
      test('should produce equivalent results for simple expressions', () {
        final testValues = {'x': 3};

        // Test addition: 5 + x
        final literalAdd = Literal(5) + x;
        final extensionAdd = 5.toExpression() + x;
        final helperAdd = ex(5) + x;

        expect(literalAdd.evaluate(testValues), equals(8));
        expect(extensionAdd.evaluate(testValues), equals(8));
        expect(helperAdd.evaluate(testValues), equals(8));

        // Test subtraction: 10 - x
        final literalSub = Literal(10) - x;
        final extensionSub = 10.toExpression() - x;
        final helperSub = ex(10) - x;

        expect(literalSub.evaluate(testValues), equals(7));
        expect(extensionSub.evaluate(testValues), equals(7));
        expect(helperSub.evaluate(testValues), equals(7));

        // Test multiplication: 4 * x
        final literalMul = Literal(4) * x;
        final extensionMul = 4.toExpression() * x;
        final helperMul = ex(4) * x;

        expect(literalMul.evaluate(testValues), equals(12));
        expect(extensionMul.evaluate(testValues), equals(12));
        expect(helperMul.evaluate(testValues), equals(12));

        // Test division: 12 / x
        final literalDiv = Literal(12) / x;
        final extensionDiv = 12.toExpression() / x;
        final helperDiv = ex(12) / x;

        expect(literalDiv.evaluate(testValues), equals(4));
        expect(extensionDiv.evaluate(testValues), equals(4));
        expect(helperDiv.evaluate(testValues), equals(4));

        // Test power: 2 ^ x
        final literalPow = Literal(2) ^ x;
        final extensionPow = 2.toExpression() ^ x;
        final helperPow = ex(2) ^ x;

        expect(literalPow.evaluate(testValues), equals(8));
        expect(extensionPow.evaluate(testValues), equals(8));
        expect(helperPow.evaluate(testValues), equals(8));
      });

      test('should produce equivalent string representations', () {
        // Test that all three approaches produce the same string output
        final literalExpr = Literal(3) * x + Literal(2);
        final extensionExpr = 3.toExpression() * x + 2.toExpression();
        final helperExpr = ex(3) * x + ex(2);

        expect(literalExpr.toString(), equals(extensionExpr.toString()));
        expect(literalExpr.toString(), equals(helperExpr.toString()));
        expect(extensionExpr.toString(), equals(helperExpr.toString()));
      });

      test('should produce equivalent expression types', () {
        // Test that all approaches create the same expression types
        final literalExpr = Literal(5) + x;
        final extensionExpr = 5.toExpression() + x;
        final helperExpr = ex(5) + x;

        expect(literalExpr.runtimeType, equals(extensionExpr.runtimeType));
        expect(literalExpr.runtimeType, equals(helperExpr.runtimeType));
        expect(extensionExpr.runtimeType, equals(helperExpr.runtimeType));

        expect(literalExpr, isA<Add>());
        expect(extensionExpr, isA<Add>());
        expect(helperExpr, isA<Add>());
      });

      test('should handle numeric type preservation consistently', () {
        // Test int preservation
        final intLiteral = Literal(42);
        final intExtension = 42.toExpression();
        final intHelper = ex(42);

        expect((intLiteral).value, isA<int>());
        expect((intExtension as Literal).value, isA<int>());
        expect((intHelper as Literal).value, isA<int>());

        // Test double preservation
        final doubleLiteral = Literal(3.14);
        final doubleExtension = 3.14.toExpression();
        final doubleHelper = ex(3.14);

        expect((doubleLiteral).value, isA<double>());
        expect((doubleExtension as Literal).value, isA<double>());
        expect((doubleHelper as Literal).value, isA<double>());
      });
    });

    group('Complex Expressions with Mixed Approaches', () {
      test('should handle polynomial expressions with mixed creation methods',
          () {
        // Create: 2*x^2 + 3*x + 1 using mixed approaches
        final expr = Literal(2) * (x ^ ex(2)) + 3.toExpression() * x + ex(1);

        expect(expr, isA<Add>());

        final testValues = {'x': 2};
        final result = expr.evaluate(testValues);
        expect(result, equals(15)); // 2*4 + 3*2 + 1 = 15
      });

      test('should handle multivariate expressions with mixed approaches', () {
        // Create: 2*x + 3*y - 4*z using mixed approaches
        final expr = ex(2) * x + Literal(3) * y - 4.toExpression() * z;

        expect(expr, isA<Subtract>());

        final testValues = {'x': 1, 'y': 2, 'z': 1};
        final result = expr.evaluate(testValues);
        expect(result, equals(4)); // 2*1 + 3*2 - 4*1 = 4
      });

      test('should handle nested expressions with mixed approaches', () {
        // Create: (ex(2) + x) * (3.toExpression() - y) / Literal(4)
        final expr = (ex(2) + x) * (3.toExpression() - y) / Literal(4);

        expect(expr, isA<Divide>());

        final testValues = {'x': 1, 'y': 1};
        final result = expr.evaluate(testValues);
        expect(result, equals(1.5)); // (2+1) * (3-1) / 4 = 6/4 = 1.5
      });

      test('should handle complex mathematical expressions', () {
        // Create: ex(3) * (x^Literal(2)) - 2.toExpression() * x + ex(1)
        final expr = ex(3) * (x ^ Literal(2)) - 2.toExpression() * x + ex(1);

        final testValues = {'x': 3};
        final result = expr.evaluate(testValues);
        expect(result, equals(22)); // 3*9 - 2*3 + 1 = 27 - 6 + 1 = 22
      });

      test(
          'should handle expressions with multiple operations and mixed approaches',
          () {
        // Create: (ex(5) * x + Literal(3)) / (2.toExpression() * y - ex(1))
        final numerator = ex(5) * x + Literal(3);
        final denominator = 2.toExpression() * y - ex(1);
        final expr = numerator / denominator;

        final testValues = {'x': 2, 'y': 3};
        final result = expr.evaluate(testValues);
        expect(result, equals(2.6)); // (5*2 + 3) / (2*3 - 1) = 13/5 = 2.6
      });
    });

    group('Performance Benchmarks and Comparisons', () {
      test('should measure creation time for different approaches', () {
        const iterations = 10000;

        // Benchmark Literal constructor
        final literalStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          Literal(i.toDouble());
        }
        literalStopwatch.stop();

        // Benchmark toExpression() method
        final extensionStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          i.toDouble().toExpression();
        }
        extensionStopwatch.stop();

        // Benchmark ex() helper function
        final helperStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          ex(i.toDouble());
        }
        helperStopwatch.stop();

        // All approaches should complete in reasonable time
        expect(literalStopwatch.elapsedMilliseconds, lessThan(1000));
        expect(extensionStopwatch.elapsedMilliseconds, lessThan(1000));
        expect(helperStopwatch.elapsedMilliseconds, lessThan(1000));

        // Print performance comparison for manual inspection
        print('Performance Comparison ($iterations iterations):');
        print('Literal constructor: ${literalStopwatch.elapsedMicroseconds}μs');
        print(
            'toExpression() method: ${extensionStopwatch.elapsedMicroseconds}μs');
        print('ex() helper function: ${helperStopwatch.elapsedMicroseconds}μs');
      });

      test(
          'should measure evaluation performance for different creation methods',
          () {
        const iterations = 1000;
        final testValues = {'x': 2.5};

        // Create expressions using different methods
        final literalExpr = Literal(3) * x + Literal(2);
        final extensionExpr = 3.toExpression() * x + 2.toExpression();
        final helperExpr = ex(3) * x + ex(2);

        // Benchmark evaluation of Literal-created expression
        final literalStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          literalExpr.evaluate(testValues);
        }
        literalStopwatch.stop();

        // Benchmark evaluation of extension-created expression
        final extensionStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          extensionExpr.evaluate(testValues);
        }
        extensionStopwatch.stop();

        // Benchmark evaluation of helper-created expression
        final helperStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          helperExpr.evaluate(testValues);
        }
        helperStopwatch.stop();

        // All approaches should have similar evaluation performance
        expect(literalStopwatch.elapsedMilliseconds, lessThan(100));
        expect(extensionStopwatch.elapsedMilliseconds, lessThan(100));
        expect(helperStopwatch.elapsedMilliseconds, lessThan(100));

        print('Evaluation Performance Comparison ($iterations iterations):');
        print('Literal-created: ${literalStopwatch.elapsedMicroseconds}μs');
        print('Extension-created: ${extensionStopwatch.elapsedMicroseconds}μs');
        print('Helper-created: ${helperStopwatch.elapsedMicroseconds}μs');
      });
    });
    group('Backward Compatibility Tests', () {
      test('should maintain compatibility with existing Literal usage', () {
        // Test that existing Literal usage patterns still work
        final oldStyleExpr = Literal(5) + Literal(3) * Literal(2);
        expect(oldStyleExpr.evaluate(), equals(11)); // 5 + 3*2 = 11

        final oldStyleWithVar = Literal(2) * x + Literal(1);
        expect(oldStyleWithVar.evaluate({'x': 3}), equals(7)); // 2*3 + 1 = 7
      });

      test('should maintain compatibility with existing Expression operations',
          () {
        // Test that existing Expression operations work with new literal creation
        final expr1 = ex(5) + x;
        final expr2 = 3.toExpression() * x;

        // Test that expressions can be combined
        final combined = expr1 + expr2;
        expect(combined.evaluate({'x': 2}),
            equals(13)); // (5+2) + (3*2) = 7 + 6 = 13

        // Test differentiation
        final derivative = expr2.differentiate();
        expect(derivative.evaluate({'x': 1}), equals(3)); // d/dx(3*x) = 3

        // Test integration
        final integral = ex(3).integrate();
        expect(integral, isA<Expression>());
      });

      test('should work with existing parser functionality', () {
        // Test that parsed expressions work with new literal creation methods
        final parsedExpr = Expression.parse('x + 2');
        final newStyleExpr = x + ex(2);

        final testValues = {'x': 5};
        expect(parsedExpr.evaluate(testValues), equals(7));
        expect(newStyleExpr.evaluate(testValues), equals(7));
      });

      test('should allow mixing old and new literal creation methods', () {
        // Test that old Literal() can be mixed with new methods
        final expr1 = Literal(2) + ex(3); // Old + Helper
        final expr2 = 4.toExpression() * Literal(5); // Extension + Old
        final expr3 = ex(6) - 7.toExpression() + Literal(8); // All three

        expect(expr1.evaluate(), equals(5));
        expect(expr2.evaluate(), equals(20));
        expect(expr3.evaluate(), equals(7)); // 6 - 7 + 8 = 7
      });

      test('should maintain same behavior across all creation methods', () {
        // Test that all methods produce equivalent results
        final testValues = {'x': 3, 'y': 2};

        // Create same expression using different methods
        final oldExpr = Literal(2) * x + Literal(3) * y + Literal(1);
        final newExpr1 =
            2.toExpression() * x + 3.toExpression() * y + 1.toExpression();
        final newExpr2 = ex(2) * x + ex(3) * y + ex(1);
        final mixedExpr = Literal(2) * x + ex(3) * y + 1.toExpression();

        final result1 = oldExpr.evaluate(testValues);
        final result2 = newExpr1.evaluate(testValues);
        final result3 = newExpr2.evaluate(testValues);
        final result4 = mixedExpr.evaluate(testValues);

        expect(result1, equals(13)); // 2*3 + 3*2 + 1 = 13
        expect(result2, equals(result1));
        expect(result3, equals(result1));
        expect(result4, equals(result1));
      });
    });

    group('Type Safety and Consistency Tests', () {
      test('should maintain type consistency across all creation methods', () {
        final intValue = 42;
        final doubleValue = 3.14;

        // Test int consistency
        final intLiteral = Literal(intValue);
        final intExtension = intValue.toExpression();
        final intHelper = ex(intValue);

        expect(intLiteral.runtimeType, equals(intExtension.runtimeType));
        expect(intLiteral.runtimeType, equals(intHelper.runtimeType));

        // Test double consistency
        final doubleLiteral = Literal(doubleValue);
        final doubleExtension = doubleValue.toExpression();
        final doubleHelper = ex(doubleValue);

        expect(doubleLiteral.runtimeType, equals(doubleExtension.runtimeType));
        expect(doubleLiteral.runtimeType, equals(doubleHelper.runtimeType));
      });

      test('should handle type coercion consistently', () {
        // Test that type coercion works the same way for all methods
        final expr1 = ex(5) + 3.14.toExpression();
        final expr2 = Literal(5) + Literal(3.14);
        final expr3 = 5.toExpression() + ex(3.14);

        final result1 = expr1.evaluate();
        final result2 = expr2.evaluate();
        final result3 = expr3.evaluate();

        expect(result1, equals(result2));
        expect(result1, equals(result3));
        expect(result2, equals(result3));

        // All results should be doubles due to type promotion
        expect(result1, isA<double>());
        expect(result2, isA<double>());
        expect(result3, isA<double>());
      });

      test('should maintain operator precedence consistently', () {
        // Test that operator precedence works the same for all creation methods
        final expr1 = ex(2) + ex(3) * ex(4); // Should be 2 + (3 * 4) = 14
        final expr2 = Literal(2) + Literal(3) * Literal(4);
        final expr3 = 2.toExpression() + 3.toExpression() * 4.toExpression();

        expect(expr1.evaluate(), equals(14));
        expect(expr2.evaluate(), equals(14));
        expect(expr3.evaluate(), equals(14));

        expect(expr1.toString(), equals(expr2.toString()));
        expect(expr1.toString(), equals(expr3.toString()));
      });
    });

    group('Comprehensive Integration Tests', () {
      test('should work in real-world mathematical scenarios', () {
        // Test quadratic formula components: ax² + bx + c
        // For 2x² + 5x + 3 = 0
        final a = ex(2);
        final b = ex(5);
        final c = ex(3);

        // Calculate discriminant: b² - 4ac
        final discriminant = b * b - ex(4) * a * c;
        expect(discriminant.evaluate(), equals(1)); // 25 - 24 = 1
      });

      test('should work with calculus operations', () {
        // Test differentiation of polynomial created with mixed methods
        final poly = ex(3) * (x ^ ex(2)) + 2.toExpression() * x + Literal(1);
        final derivative = poly.differentiate();

        // d/dx(3x² + 2x + 1) = 6x + 2
        expect(derivative.evaluate({'x': 1}), equals(8)); // 6*1 + 2 = 8
        expect(derivative.evaluate({'x': 2}), equals(14)); // 6*2 + 2 = 14
      });

      test('should handle multi-step expression building', () {
        // Build expression step by step using different methods
        var expr = ex(1); // Start with 1

        // Add terms one by one
        expr = expr + 2.toExpression() * x; // 1 + 2x
        expr = expr + Literal(3) * (x ^ ex(2)); // 1 + 2x + 3x²
        expr = expr - ex(4); // 1 + 2x + 3x² - 4 = -3 + 2x + 3x²

        final testValues = {'x': 2};
        final result = expr.evaluate(testValues);
        expect(result, equals(13)); // -3 + 2*2 + 3*4 = -3 + 4 + 12 = 13
      });

      test('should work with expression substitution chains', () {
        // Create expression with one variable, then substitute with another expression
        final originalExpr = ex(2) * x + ex(1);
        final substitutionExpr = y ^ ex(2); // x = y²

        final substitutedExpr = originalExpr.substitute(x, substitutionExpr);
        // Result: 2*(y²) + 1 = 2y² + 1

        final testValues = {'y': 3};
        final result = substitutedExpr.evaluate(testValues);
        expect(result, equals(19)); // 2*9 + 1 = 19
      });
    });
  });
}
