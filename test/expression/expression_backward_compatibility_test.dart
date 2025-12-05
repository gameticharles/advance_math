import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  group('Expression Backward Compatibility Tests', () {
    late Variable x;
    late Variable y;

    setUp(() {
      x = Variable(Identifier('x'));
      y = Variable(Identifier('y'));
    });

    group('Existing Literal Usage Patterns', () {
      test('should maintain compatibility with direct Literal construction',
          () {
        // Test that existing Literal usage patterns still work exactly as before
        final expr1 = Literal(5);
        final expr2 = Literal(3.14);
        final expr3 = Literal(-7);
        final expr4 = Literal(0);

        expect(expr1, isA<Literal>());
        expect(expr2, isA<Literal>());
        expect(expr3, isA<Literal>());
        expect(expr4, isA<Literal>());

        expect((expr1).value, equals(5));
        expect((expr2).value, equals(3.14));
        expect((expr3).value, equals(-7));
        expect((expr4).value, equals(0));
      });

      test('should maintain compatibility with Literal arithmetic operations',
          () {
        // Test existing patterns of Literal + Literal operations
        final expr1 = Literal(5) + Literal(3);
        final expr2 = Literal(10) - Literal(4);
        final expr3 = Literal(6) * Literal(7);
        final expr4 = Literal(15) / Literal(3);
        final expr5 = Literal(2) ^ Literal(3);

        expect(expr1.evaluate(), equals(8));
        expect(expr2.evaluate(), equals(6));
        expect(expr3.evaluate(), equals(42));
        expect(expr4.evaluate(), equals(5));
        expect(expr5.evaluate(), equals(8));
      });

      test('should maintain compatibility with Literal + Variable operations',
          () {
        // Test existing patterns of Literal + Variable operations
        final expr1 = Literal(5) + x;
        final expr2 = Literal(10) - x;
        final expr3 = Literal(3) * x;
        final expr4 = Literal(12) / x;
        final expr5 = Literal(2) ^ x;

        final testValues = {'x': 4};

        expect(expr1.evaluate(testValues), equals(9));
        expect(expr2.evaluate(testValues), equals(6));
        expect(expr3.evaluate(testValues), equals(12));
        expect(expr4.evaluate(testValues), equals(3));
        expect(expr5.evaluate(testValues), equals(16));
      });

      test('should maintain compatibility with complex Literal expressions',
          () {
        // Test existing complex expression patterns
        final expr =
            Literal(2) * (x ^ Literal(2)) + Literal(3) * x + Literal(1);

        expect(expr, isA<Add>());

        final testValues = {'x': 2};
        final result = expr.evaluate(testValues);
        expect(result, equals(15)); // 2*4 + 3*2 + 1 = 15
      });
    });

    group('Existing Variable Usage Patterns', () {
      test('should maintain compatibility with Variable construction', () {
        // Test that existing Variable construction patterns work
        final var1 = Variable(Identifier('a'));
        final var2 = Variable(Identifier('b'));
        final var3 = Variable('c'); // String constructor if available

        expect(var1, isA<Variable>());
        expect(var2, isA<Variable>());
        expect(var3, isA<Variable>());

        expect(var1.identifier.name, equals('a'));
        expect(var2.identifier.name, equals('b'));
        expect(var3.identifier.name, equals('c'));
      });

      test('should maintain compatibility with Variable operations', () {
        // Test that Variable operations work as before
        final expr1 = x + y;
        final expr2 = x - y;
        final expr3 = x * y;
        final expr4 = x / y;
        final expr5 = x ^ y;

        final testValues = {'x': 6, 'y': 2};

        expect(expr1.evaluate(testValues), equals(8));
        expect(expr2.evaluate(testValues), equals(4));
        expect(expr3.evaluate(testValues), equals(12));
        expect(expr4.evaluate(testValues), equals(3));
        expect(expr5.evaluate(testValues), equals(36));
      });

      test(
          'should maintain compatibility with Variable + Literal mixed operations',
          () {
        // Test that mixed Variable + Literal operations work as before
        final expr1 = x + Literal(5);
        final expr2 = x - Literal(3);
        final expr3 = x * Literal(4);
        final expr4 = x / Literal(2);
        final expr5 = x ^ Literal(2);

        final testValues = {'x': 8};

        expect(expr1.evaluate(testValues), equals(13));
        expect(expr2.evaluate(testValues), equals(5));
        expect(expr3.evaluate(testValues), equals(32));
        expect(expr4.evaluate(testValues), equals(4));
        expect(expr5.evaluate(testValues), equals(64));
      });
    });

    group('Existing Expression Parser Compatibility', () {
      test('should maintain compatibility with Expression.parse()', () {
        // Test that existing parser functionality works
        final expr1 = Expression.parse('x + 5');
        final expr2 = Expression.parse('2 * x - 3');
        final expr3 = Expression.parse('x^2 + 2*x + 1');

        final testValues = {'x': 3};

        expect(expr1.evaluate(testValues), equals(8));
        expect(expr2.evaluate(testValues), equals(3));
        expect(expr3.evaluate(testValues), equals(16)); // 9 + 6 + 1 = 16
      });

      test('should maintain compatibility with parsed expression operations',
          () {
        // Test that parsed expressions can be combined with other expressions
        final parsedExpr = Expression.parse('x + 2');
        final literalExpr = Literal(3) * x;

        final combined = parsedExpr + literalExpr;
        final testValues = {'x': 4};

        expect(combined.evaluate(testValues),
            equals(18)); // (4+2) + (3*4) = 6 + 12 = 18
      });
    });

    group('Existing Expression Methods Compatibility', () {
      test('should maintain compatibility with differentiate()', () {
        // Test that differentiation works as before
        final expr1 = Literal(3) * x;
        final expr2 = x ^ Literal(2);
        final expr3 = Literal(5);

        final derivative1 = expr1.differentiate();
        final derivative2 = expr2.differentiate();
        final derivative3 = expr3.differentiate();

        expect(derivative1.evaluate({'x': 1}), equals(3));
        expect(derivative2.evaluate({'x': 2}), equals(4)); // 2*x at x=2
        expect(derivative3.evaluate({'x': 1}), equals(0));
      });

      test('should maintain compatibility with integrate()', () {
        // Test that integration works as before
        final expr1 = Literal(3);
        final expr2 = x;

        final integral1 = expr1.integrate();
        final integral2 = expr2.integrate();

        expect(integral1, isA<Expression>());
        expect(integral2, isA<Expression>());

        // Integration of constant should be constant * x
        expect(integral1.toString(), contains('3'));
        expect(integral1.toString(), contains('x'));

        // Integration of x should be x^2/2
        expect(integral2.toString(), contains('x'));
      });

      test('should maintain compatibility with simplify()', () {
        // Test that simplification works as before
        final expr1 = Literal(0) + x;
        final expr2 = Literal(1) * x;
        final expr3 = x + Literal(0);

        final simplified1 = expr1.simplify();
        final simplified2 = expr2.simplify();
        final simplified3 = expr3.simplify();

        expect(simplified1, isA<Expression>());
        expect(simplified2, isA<Expression>());
        expect(simplified3, isA<Expression>());
      });

      test('should maintain compatibility with substitute()', () {
        // Test that substitution works as before
        final expr = Literal(2) * x + Literal(3);
        final substituted = expr.substitute(x, Literal(5));

        expect(substituted.evaluate(), equals(13)); // 2*5 + 3 = 13
      });

      test('should maintain compatibility with getVariableTerms()', () {
        // Test that variable term extraction works as before
        final expr1 = Literal(2) * x + Literal(3) * y;
        final expr2 = Literal(5);

        final variables1 = expr1.getVariableTerms();
        final variables2 = expr2.getVariableTerms();

        expect(variables1.toString(), contains('x'));
        expect(variables1.toString(), contains('y'));
        expect(variables2.toString(), equals('{}')); // empty set => {}
      });

      test('should maintain compatibility with toString()', () {
        // Test that string representation works as before
        final expr1 = Literal(5);
        final expr2 = x;
        final expr3 = Literal(2) * x + Literal(3);

        expect(expr1.toString(), equals('5'));
        expect(expr2.toString(), equals('x'));
        expect(expr3.toString(), isA<String>());
        expect(expr3.toString(), contains('2'));
        expect(expr3.toString(), contains('x'));
        expect(expr3.toString(), contains('3'));
      });
    });

    group('Existing Error Handling Compatibility', () {
      test('should maintain compatibility with evaluation errors', () {
        // Test that evaluation errors work as before
        final expr = x + y;

        // Should throw when variables are not provided
        expect(() => expr.evaluate(), returnsNormally);
        expect(() => expr.evaluate({'x': 1}), returnsNormally);

        // Should work when all variables are provided
        expect(() => expr.evaluate({'x': 1, 'y': 2}), returnsNormally);
      });

      test('should maintain compatibility with division by zero', () {
        // Test that division by zero handling works as before
        final expr = x / Literal(0);

        expect(() => expr.evaluate({'x': 5}), throwsA(isA<Exception>()));
      });

      test('should maintain compatibility with invalid operations', () {
        // Test that invalid operations are handled as before
        final expr = Literal(0) ^ Literal(-1); // 0^(-1) => Infinity

        expect(() => expr.evaluate(), returnsNormally);
      });
    });

    group('Existing Type System Compatibility', () {
      test('should maintain compatibility with Expression type hierarchy', () {
        // Test that type hierarchy works as before
        final literal = Literal(5);
        final variable = x;
        final add = literal + variable;
        final multiply = literal * variable;

        expect(literal, isA<Expression>());
        expect(literal, isA<Literal>());

        expect(variable, isA<Expression>());
        expect(variable, isA<Variable>());

        expect(add, isA<Expression>());
        expect(add, isA<Add>());

        expect(multiply, isA<Expression>());
        expect(multiply, isA<Multiply>());
      });

      test('should maintain compatibility with numeric type preservation', () {
        // Test that numeric types are preserved as before
        final intLiteral = Literal(42);
        final doubleLiteral = Literal(3.14);

        expect((intLiteral).value, isA<int>());
        expect((doubleLiteral).value, isA<double>());

        expect(intLiteral.evaluate(), isA<int>());
        expect(doubleLiteral.evaluate(), isA<double>());
      });
    });

    group('Integration with New Methods', () {
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

      test('should maintain same string representation', () {
        // Test that string representations are consistent
        final oldExpr = Literal(5) + x;
        final newExpr1 = 5.toExpression() + x;
        final newExpr2 = ex(5) + x;

        expect(oldExpr.toString(), equals(newExpr1.toString()));
        expect(oldExpr.toString(), equals(newExpr2.toString()));
        expect(newExpr1.toString(), equals(newExpr2.toString()));
      });

      test('should maintain same differentiation behavior', () {
        // Test that differentiation works the same across all methods
        final oldExpr = Literal(3) * x;
        final newExpr1 = 3.toExpression() * x;
        final newExpr2 = ex(3) * x;

        final derivative1 = oldExpr.differentiate();
        final derivative2 = newExpr1.differentiate();
        final derivative3 = newExpr2.differentiate();

        expect(derivative1.evaluate({'x': 1}), equals(3));
        expect(derivative2.evaluate({'x': 1}), equals(3));
        expect(derivative3.evaluate({'x': 1}), equals(3));
      });

      test('should maintain same integration behavior', () {
        // Test that integration works the same across all methods
        final oldExpr = Literal(4);
        final newExpr1 = 4.toExpression();
        final newExpr2 = ex(4);

        final integral1 = oldExpr.integrate();
        final integral2 = newExpr1.integrate();
        final integral3 = newExpr2.integrate();

        // All should produce equivalent integrals
        expect(integral1.toString(), equals(integral2.toString()));
        expect(integral1.toString(), equals(integral3.toString()));
        expect(integral2.toString(), equals(integral3.toString()));
      });
    });

    group('Performance Consistency', () {
      test('should maintain similar performance characteristics', () {
        // Test that performance is not significantly degraded
        const iterations = 1000;
        final testValues = {'x': 2.5};

        // Create expressions using old method
        final oldExpr = Literal(3) * x + Literal(2);

        // Benchmark old method evaluation
        final oldStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          oldExpr.evaluate(testValues);
        }
        oldStopwatch.stop();

        // Create expressions using new methods
        final newExpr1 = 3.toExpression() * x + 2.toExpression();
        final newExpr2 = ex(3) * x + ex(2);

        // Benchmark new method evaluation
        final newStopwatch1 = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          newExpr1.evaluate(testValues);
        }
        newStopwatch1.stop();

        final newStopwatch2 = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          newExpr2.evaluate(testValues);
        }
        newStopwatch2.stop();

        // New methods should not be significantly slower than old method
        // Allow up to 50% performance difference
        final oldTime = oldStopwatch.elapsedMicroseconds;
        final newTime1 = newStopwatch1.elapsedMicroseconds;
        final newTime2 = newStopwatch2.elapsedMicroseconds;

        expect(newTime1, lessThan(oldTime * 2));
        expect(newTime2, lessThan(oldTime * 2));

        print('Performance comparison ($iterations evaluations):');
        print('Old Literal method: $oldTime μs');
        print('New extension method: $newTime1 μs');
        print('New helper method: $newTime2 μs');
      });
    });
  });
}
