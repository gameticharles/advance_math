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

      test('should handle trigonometric expressions with mixed approaches', () {
        // Create expressions that would use trigonometric functions if available
        // For now, test with basic arithmetic that could represent coefficients
        final expr = ex(2) * x + Literal(1) * y + 3.toExpression();

        final testValues = {'x': 0, 'y': 1}; // Simulating sin(0) and cos(0)
        final result = expr.evaluate(testValues);
        expect(result, equals(4)); // 2*0 + 1*1 + 3 = 4
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

      test('should measure memory usage patterns', () {
        // Create large numbers of expressions to test memory patterns
        const count = 1000;

        final literalExpressions = <Expression>[];
        final extensionExpressions = <Expression>[];
        final helperExpressions = <Expression>[];

        // Create expressions using different methods
        for (int i = 0; i < count; i++) {
          literalExpressions.add(Literal(i) + x);
          extensionExpressions.add(i.toExpression() + x);
          helperExpressions.add(ex(i) + x);
        }

        // Verify all collections have the same size
        expect(literalExpressions.length, equals(count));
        expect(extensionExpressions.length, equals(count));
        expect(helperExpressions.length, equals(count));

        // Test that expressions are functionally equivalent
        final testValues = {'x': 5};
        for (int i = 0; i < 10; i++) {
          // Test first 10 for performance
          final literalResult = literalExpressions[i].evaluate(testValues);
          final extensionResult = extensionExpressions[i].evaluate(testValues);
          final helperResult = helperExpressions[i].evaluate(testValues);

          expect(literalResult, equals(extensionResult));
          expect(literalResult, equals(helperResult));
        }
      });

      test('should compare performance of complex expression creation', () {
        const iterations = 100;

        // Benchmark complex expression creation with Literal
        final literalStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          final expr =
              Literal(2) * (x ^ Literal(2)) + Literal(3) * x + Literal(1);
          expr.toString(); // Force expression tree construction
        }
        literalStopwatch.stop();

        // Benchmark complex expression creation with extension
        final extensionStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          final expr = 2.toExpression() * (x ^ 2.toExpression()) +
              3.toExpression() * x +
              1.toExpression();
          expr.toString(); // Force expression tree construction
        }
        extensionStopwatch.stop();

        // Benchmark complex expression creation with helper
        final helperStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          final expr = ex(2) * (x ^ ex(2)) + ex(3) * x + ex(1);
          expr.toString(); // Force expression tree construction
        }
        helperStopwatch.stop();

        print(
            'Complex Expression Creation Performance ($iterations iterations):');
        print('Literal approach: ${literalStopwatch.elapsedMicroseconds}μs');
        print(
            'Extension approach: ${extensionStopwatch.elapsedMicroseconds}μs');
        print('Helper approach: ${helperStopwatch.elapsedMicroseconds}μs');

        // All should complete in reasonable time
        expect(literalStopwatch.elapsedMilliseconds, lessThan(1000));
        expect(extensionStopwatch.elapsedMilliseconds, lessThan(1000));
        expect(helperStopwatch.elapsedMilliseconds, lessThan(1000));
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

      test('should maintain compatibility with existing Variable usage', () {
        // Test that Variables work the same way with all literal creation methods
        final var1 = Variable(Identifier('a'));
        final var2 = Variable(Identifier('b'));

        final expr1 = Literal(2) * var1 + Literal(3) * var2;
        final expr2 = 2.toExpression() * var1 + 3.toExpression() * var2;
        final expr3 = ex(2) * var1 + ex(3) * var2;

        final testValues = {'a': 4, 'b': 5};
        expect(expr1.evaluate(testValues), equals(23)); // 2*4 + 3*5 = 23
        expect(expr2.evaluate(testValues), equals(23));
        expect(expr3.evaluate(testValues), equals(23));
      });

      test(
          'should maintain compatibility with existing expression tree operations',
          () {
        // Test that expression tree operations work with new creation methods
        final expr = ex(2) * x + 3.toExpression();

        // Test toString
        expect(expr.toString(), isA<String>());

        // Test getVariableTerms
        final variables = expr.getVariableTerms();
        expect(variables, contains('x'));

        // Test substitution
        final substituted = expr.substitute(x, ex(5));
        expect(substituted.evaluate(), equals(13)); // 2*5 + 3 = 13

        // Test simplification
        final simplified = expr.simplify();
        expect(simplified, isA<Expression>());
      });

      test('should work with existing polynomial operations', () {
        // Test that polynomial operations work with new literal creation
        final coefficients = [ex(1), ex(2), ex(3)]; // 1 + 2x + 3x^2

        // Create polynomial-like expression manually
        final polyExpr = coefficients[0] +
            coefficients[1] * x +
            coefficients[2] * (x ^ ex(2));

        final testValues = {'x': 2};
        final result = polyExpr.evaluate(testValues);
        expect(result, equals(17)); // 1 + 2*2 + 3*4 = 1 + 4 + 12 = 17
      });

      test('should maintain compatibility with existing error handling', () {
        // Test that error handling works the same way
        expect(() => x.evaluate(), throwsA(isA<Exception>()));
        expect(() => ex(5).evaluate({'y': 1}), returnsNormally);

        // Test that invalid operations still throw appropriate errors
        final expr = ex(5) / ex(0);
        expect(() => expr.evaluate(), throwsA(isA<Exception>()));
      });
    });

    group('Edge Cases and Robustness Tests', () {
      test('should handle extreme numeric values consistently', () {
        final extremeValues = [
          double.maxFinite,
          -double.maxFinite,
          double.minPositive,
          -double.minPositive,
          0.0,
          -0.0,
          1e100,
          1e-100,
        ];

        for (final value in extremeValues) {
          final literalExpr = Literal(value);
          final extensionExpr = value.toExpression();
          final helperExpr = ex(value);

          expect((literalExpr).value, equals(value));
          expect((extensionExpr as Literal).value, equals(value));
          expect((helperExpr as Literal).value, equals(value));

          // Test evaluation
          expect(literalExpr.evaluate(), equals(value));
          expect(extensionExpr.evaluate(), equals(value));
          expect(helperExpr.evaluate(), equals(value));
        }
      });

      test('should handle integer boundary values', () {
        final intValues = [
          0,
          1,
          -1,
          2147483647, // Max 32-bit int
          -2147483648, // Min 32-bit int
          9223372036854775807, // Max 64-bit int
          -9223372036854775808, // Min 64-bit int
        ];

        for (final value in intValues) {
          final literalExpr = Literal(value);
          final extensionExpr = value.toExpression();
          final helperExpr = ex(value);

          expect((literalExpr).value, equals(value));
          expect((extensionExpr as Literal).value, equals(value));
          expect((helperExpr as Literal).value, equals(value));
        }
      });

      test('should handle mixed integer and double operations', () {
        // Test mixing int and double in expressions
        final expr1 = ex(5) + 3.14.toExpression(); // int + double
        final expr2 = 2.5.toExpression() * ex(4); // double * int

        expect(expr1.evaluate(), equals(8.14));
        expect(expr2.evaluate(), equals(10.0));
      });

      test('should handle complex nested expressions', () {
        // Create deeply nested expression
        final expr =
            ((ex(2) + x) * (3.toExpression() - y)) / (Literal(4) + (ex(1) * z));

        final testValues = {'x': 1, 'y': 1, 'z': 1};
        final result = expr.evaluate(testValues);
        expect(
            result, equals(1.2)); // ((2+1) * (3-1)) / (4 + (1*1)) = 6/5 = 1.2
      });

      test('should handle expressions with many variables', () {
        final variables = List.generate(10, (i) => Variable(Identifier('x$i')));

        // Create expression: sum of all variables with different coefficients
        Expression expr = ex(0);
        for (int i = 0; i < variables.length; i++) {
          expr = expr + ex(i + 1) * variables[i];
        }

        // Create test values
        final testValues = <String, num>{};
        for (int i = 0; i < variables.length; i++) {
          testValues['x$i'] = i + 1;
        }

        final result = expr.evaluate(testValues);
        // Expected: 1*1 + 2*2 + 3*3 + ... + 10*10 = sum of i^2 from 1 to 10 = 385
        expect(result, equals(385));
      });

      test('should handle rapid creation and disposal', () {
        // Test creating and discarding many expressions quickly
        for (int i = 0; i < 1000; i++) {
          final expr1 = ex(i) + x;
          final expr2 = i.toExpression() * y;
          final expr3 = Literal(i) - z;

          // Use expressions briefly
          expr1.toString();
          expr2.toString();
          expr3.toString();
        }

        // If we get here without memory issues, the test passes
        expect(true, isTrue);
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
        expect((intLiteral).value.runtimeType,
            equals((intExtension as Literal).value.runtimeType));
        expect((intLiteral).value.runtimeType,
            equals((intHelper as Literal).value.runtimeType));

        // Test double consistency
        final doubleLiteral = Literal(doubleValue);
        final doubleExtension = doubleValue.toExpression();
        final doubleHelper = ex(doubleValue);

        expect(doubleLiteral.runtimeType, equals(doubleExtension.runtimeType));
        expect(doubleLiteral.runtimeType, equals(doubleHelper.runtimeType));
        expect((doubleLiteral).value.runtimeType,
            equals((doubleExtension as Literal).value.runtimeType));
        expect((doubleLiteral).value.runtimeType,
            equals((doubleHelper as Literal).value.runtimeType));
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
  });
}
