import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  group('Expression Creation Performance Benchmarks', () {
    late Variable x;
    late Variable y;

    setUp(() {
      x = Variable(Identifier('x'));
      y = Variable(Identifier('y'));
    });

    group('Creation Performance Benchmarks', () {
      test('should benchmark literal creation methods', () {
        const iterations = 50000;

        // Benchmark Literal constructor
        final literalStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          Literal(i % 1000);
        }
        literalStopwatch.stop();

        // Benchmark toExpression() method
        final extensionStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          (i % 1000).toExpression();
        }
        extensionStopwatch.stop();

        // Benchmark ex() helper function
        final helperStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          ex(i % 1000);
        }
        helperStopwatch.stop();

        print(
            '\n=== Literal Creation Performance ($iterations iterations) ===');
        print('Literal constructor: ${literalStopwatch.elapsedMicroseconds}μs');
        print(
            'toExpression() method: ${extensionStopwatch.elapsedMicroseconds}μs');
        print('ex() helper function: ${helperStopwatch.elapsedMicroseconds}μs');

        // Calculate relative performance
        final baseTime = literalStopwatch.elapsedMicroseconds;
        final extensionRatio =
            extensionStopwatch.elapsedMicroseconds / baseTime;
        final helperRatio = helperStopwatch.elapsedMicroseconds / baseTime;

        print('Performance ratios (relative to Literal):');
        print('toExpression(): ${extensionRatio.toStringAsFixed(2)}x');
        print('ex(): ${helperRatio.toStringAsFixed(2)}x');

        // All approaches should complete in reasonable time
        expect(literalStopwatch.elapsedMilliseconds, lessThan(5000));
        expect(extensionStopwatch.elapsedMilliseconds, lessThan(5000));
        expect(helperStopwatch.elapsedMilliseconds, lessThan(5000));
      });

      test('should benchmark complex expression creation', () {
        const iterations = 5000;

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
            '\n=== Complex Expression Creation Performance ($iterations iterations) ===');
        print('Literal approach: ${literalStopwatch.elapsedMicroseconds}μs');
        print(
            'Extension approach: ${extensionStopwatch.elapsedMicroseconds}μs');
        print('Helper approach: ${helperStopwatch.elapsedMicroseconds}μs');

        // Calculate relative performance
        final baseTime = literalStopwatch.elapsedMicroseconds;
        final extensionRatio =
            extensionStopwatch.elapsedMicroseconds / baseTime;
        final helperRatio = helperStopwatch.elapsedMicroseconds / baseTime;

        print('Performance ratios (relative to Literal):');
        print('Extension: ${extensionRatio.toStringAsFixed(2)}x');
        print('Helper: ${helperRatio.toStringAsFixed(2)}x');

        // All should complete in reasonable time
        expect(literalStopwatch.elapsedMilliseconds, lessThan(5000));
        expect(extensionStopwatch.elapsedMilliseconds, lessThan(5000));
        expect(helperStopwatch.elapsedMilliseconds, lessThan(5000));
      });
    });

    group('Evaluation Performance Benchmarks', () {
      test('should benchmark expression evaluation performance', () {
        const iterations = 10000;
        final testValues = {'x': 2.5, 'y': 1.5};

        // Create expressions using different methods
        final literalExpr = Literal(3) * x + Literal(2) * y + Literal(1);
        final extensionExpr =
            3.toExpression() * x + 2.toExpression() * y + 1.toExpression();
        final helperExpr = ex(3) * x + ex(2) * y + ex(1);

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

        print(
            '\n=== Expression Evaluation Performance ($iterations iterations) ===');
        print('Literal-created: ${literalStopwatch.elapsedMicroseconds}μs');
        print('Extension-created: ${extensionStopwatch.elapsedMicroseconds}μs');
        print('Helper-created: ${helperStopwatch.elapsedMicroseconds}μs');

        // Calculate relative performance
        final baseTime = literalStopwatch.elapsedMicroseconds;
        final extensionRatio =
            extensionStopwatch.elapsedMicroseconds / baseTime;
        final helperRatio = helperStopwatch.elapsedMicroseconds / baseTime;

        print('Performance ratios (relative to Literal):');
        print('Extension: ${extensionRatio.toStringAsFixed(2)}x');
        print('Helper: ${helperRatio.toStringAsFixed(2)}x');

        // All approaches should have similar evaluation performance
        expect(literalStopwatch.elapsedMilliseconds, lessThan(1000));
        expect(extensionStopwatch.elapsedMilliseconds, lessThan(1000));
        expect(helperStopwatch.elapsedMilliseconds, lessThan(1000));

        // Verify all produce the same result
        final expectedResult = 3 * 2.5 + 2 * 1.5 + 1; // 7.5 + 3 + 1 = 11.5
        expect(literalExpr.evaluate(testValues), equals(expectedResult));
        expect(extensionExpr.evaluate(testValues), equals(expectedResult));
        expect(helperExpr.evaluate(testValues), equals(expectedResult));
      });

      test('should benchmark polynomial evaluation performance', () {
        const iterations = 5000;
        final testValues = {'x': 2.0};

        // Create polynomial: ax^3 + bx^2 + cx + d
        final literalPoly = Literal(2) * (x ^ Literal(3)) +
            Literal(3) * (x ^ Literal(2)) +
            Literal(4) * x +
            Literal(5);

        final extensionPoly = 2.toExpression() * (x ^ 3.toExpression()) +
            3.toExpression() * (x ^ 2.toExpression()) +
            4.toExpression() * x +
            5.toExpression();

        final helperPoly =
            ex(2) * (x ^ ex(3)) + ex(3) * (x ^ ex(2)) + ex(4) * x + ex(5);

        // Benchmark polynomial evaluation
        final literalStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          literalPoly.evaluate(testValues);
        }
        literalStopwatch.stop();

        final extensionStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          extensionPoly.evaluate(testValues);
        }
        extensionStopwatch.stop();

        final helperStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          helperPoly.evaluate(testValues);
        }
        helperStopwatch.stop();

        print(
            '\n=== Polynomial Evaluation Performance ($iterations iterations) ===');
        print('Literal polynomial: ${literalStopwatch.elapsedMicroseconds}μs');
        print(
            'Extension polynomial: ${extensionStopwatch.elapsedMicroseconds}μs');
        print('Helper polynomial: ${helperStopwatch.elapsedMicroseconds}μs');

        // Calculate relative performance
        final baseTime = literalStopwatch.elapsedMicroseconds;
        final extensionRatio =
            extensionStopwatch.elapsedMicroseconds / baseTime;
        final helperRatio = helperStopwatch.elapsedMicroseconds / baseTime;

        print('Performance ratios (relative to Literal):');
        print('Extension: ${extensionRatio.toStringAsFixed(2)}x');
        print('Helper: ${helperRatio.toStringAsFixed(2)}x');

        // Verify all produce the same result
        final expectedResult =
            2 * 8 + 3 * 4 + 4 * 2 + 5; // 16 + 12 + 8 + 5 = 41
        expect(literalPoly.evaluate(testValues), equals(expectedResult));
        expect(extensionPoly.evaluate(testValues), equals(expectedResult));
        expect(helperPoly.evaluate(testValues), equals(expectedResult));
      });
    });

    group('Memory Usage Benchmarks', () {
      test('should benchmark memory usage patterns', () {
        const count = 10000;

        final literalExpressions = <Expression>[];
        final extensionExpressions = <Expression>[];
        final helperExpressions = <Expression>[];

        // Create expressions using different methods
        final literalStopwatch = Stopwatch()..start();
        for (int i = 0; i < count; i++) {
          literalExpressions.add(Literal(i % 100) + x);
        }
        literalStopwatch.stop();

        final extensionStopwatch = Stopwatch()..start();
        for (int i = 0; i < count; i++) {
          extensionExpressions.add((i % 100).toExpression() + x);
        }
        extensionStopwatch.stop();

        final helperStopwatch = Stopwatch()..start();
        for (int i = 0; i < count; i++) {
          helperExpressions.add(ex(i % 100) + x);
        }
        helperStopwatch.stop();

        print('\n=== Memory Usage Pattern Creation ($count expressions) ===');
        print('Literal creation: ${literalStopwatch.elapsedMicroseconds}μs');
        print(
            'Extension creation: ${extensionStopwatch.elapsedMicroseconds}μs');
        print('Helper creation: ${helperStopwatch.elapsedMicroseconds}μs');

        // Verify all collections have the same size
        expect(literalExpressions.length, equals(count));
        expect(extensionExpressions.length, equals(count));
        expect(helperExpressions.length, equals(count));

        // Test that expressions are functionally equivalent
        final testValues = {'x': 5};
        for (int i = 0; i < 100; i += 10) {
          // Test every 10th expression for performance
          final literalResult = literalExpressions[i].evaluate(testValues);
          final extensionResult = extensionExpressions[i].evaluate(testValues);
          final helperResult = helperExpressions[i].evaluate(testValues);

          expect(literalResult, equals(extensionResult));
          expect(literalResult, equals(helperResult));
        }

        print(
            'Memory usage verification: All expressions functionally equivalent');
      });
    });

    group('Scalability Benchmarks', () {
      test('should benchmark performance with increasing complexity', () {
        final complexities = [10, 50, 100, 200];

        print('\n=== Scalability Benchmark ===');

        for (final complexity in complexities) {
          final testValues = {'x': 2.0};

          // Create polynomial of given complexity using helper function
          Expression expr = ex(0);
          for (int i = 1; i <= complexity; i++) {
            expr = expr + ex(i) * (x ^ ex(i));
          }

          // Benchmark evaluation
          const iterations = 100;
          final stopwatch = Stopwatch()..start();
          for (int i = 0; i < iterations; i++) {
            expr.evaluate(testValues);
          }
          stopwatch.stop();

          final avgTime = stopwatch.elapsedMicroseconds / iterations;
          print(
              'Complexity $complexity: ${avgTime.toStringAsFixed(1)}μs per evaluation');

          // Ensure reasonable performance even at high complexity
          expect(avgTime, lessThan(10000)); // Less than 10ms per evaluation
        }
      });
    });
  });
}
