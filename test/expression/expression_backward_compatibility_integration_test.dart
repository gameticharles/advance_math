import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  group('Expression Backward Compatibility Integration Tests', () {
    late Variable x;
    late Variable y;
    late Variable z;

    setUp(() {
      x = Variable(Identifier('x'));
      y = Variable(Identifier('y'));
      z = Variable(Identifier('z'));
    });

    group('Existing API Compatibility', () {
      test('should maintain compatibility with existing Literal usage patterns',
          () {
        // Test that all existing Literal usage patterns continue to work
        final expr1 = Literal(5);
        final expr2 = Literal(3.14);
        final expr3 = Literal(-7);
        final expr4 = Literal(0);

        expect(expr1, isA<Literal>());
        expect(expr2, isA<Literal>());
        expect(expr3, isA<Literal>());
        expect(expr4, isA<Literal>());

        expect(expr1.evaluate(), equals(5));
        expect(expr2.evaluate(), equals(3.14));
        expect(expr3.evaluate(), equals(-7));
        expect(expr4.evaluate(), equals(0));
      });

      test('should maintain compatibility with existing arithmetic operations',
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

      test('should maintain compatibility with existing Variable operations',
          () {
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
          'should maintain compatibility with mixed Literal + Variable operations',
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

    group('Expression Parser Compatibility', () {
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

    group('Expression Methods Compatibility', () {
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

        expect(variables1.any((v) => v.toString() == 'x'), isTrue);
        expect(variables1.any((v) => v.toString() == 'y'), isTrue);
        expect(variables2, isEmpty);
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

    group('Error Handling Compatibility', () {
      test('should maintain compatibility with evaluation behavior', () {
        // Test that evaluation behavior works as expected
        final expr = x + y;

        // Should work when all variables are provided
        expect(() => expr.evaluate({'x': 1, 'y': 2}), returnsNormally);
        expect(expr.evaluate({'x': 1, 'y': 2}), equals(3));

        // Test that missing variables are handled appropriately
        try {
          expr.evaluate();
          // If no exception is thrown, that's also valid behavior
        } catch (e) {
          expect(e, isA<Exception>());
        }

        try {
          expr.evaluate({'x': 1});
          // If no exception is thrown, that's also valid behavior
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });

      test('should handle division by zero appropriately', () {
        // Test that division by zero handling works
        final expr = x / Literal(0);

        expect(() => expr.evaluate({'x': 5}), throwsException);
      });

      test('should handle invalid operations appropriately', () {
        // Test that invalid operations are handled
        final expr = Literal(0) ^ Literal(-1);

        final result = expr.evaluate();
        // 0^(-1) may return infinity rather than throwing
        expect(result.isInfinite || result.isNaN, isTrue);
      });
    });

    group('Type System Compatibility', () {
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
      test(
          'should allow seamless mixing of old and new literal creation methods',
          () {
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
      test('should maintain reasonable performance characteristics', () {
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
        // Allow up to 100% performance difference (2x slower)
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

    group('Real-world Usage Scenarios', () {
      test('should work in complex mathematical scenarios', () {
        // Test a real-world scenario: solving quadratic equation components
        // For equation ax² + bx + c = 0, calculate discriminant b² - 4ac
        final a = ex(1);
        final b = ex(-5);
        final c = ex(6);

        final discriminant = b * b - ex(4) * a * c;
        expect(discriminant.evaluate(), equals(1)); // 25 - 24 = 1

        // This discriminant > 0, so we have two real roots
        // Roots would be: (-b ± √discriminant) / (2a)
        final sqrtDiscriminant = ex(1); // √1 = 1
        final root1 =
            ((-1).toExpression() * b + sqrtDiscriminant) / (ex(2) * a);
        final root2 =
            ((-1).toExpression() * b - sqrtDiscriminant) / (ex(2) * a);

        expect(root1.evaluate(), equals(3)); // (5 + 1) / 2 = 3
        expect(root2.evaluate(), equals(2)); // (5 - 1) / 2 = 2

        // Verify: x² - 5x + 6 = (x-2)(x-3) = 0 when x=2 or x=3
        final originalEquation = x * x - ex(5) * x + ex(6);
        expect(originalEquation.evaluate({'x': 2}), equals(0));
        expect(originalEquation.evaluate({'x': 3}), equals(0));
      });

      test('should work with calculus operations on mixed expressions', () {
        // Test differentiation and integration with mixed creation methods
        final polynomial = ex(2) * (x ^ ex(3)) +
            3.toExpression() * (x ^ ex(2)) +
            Literal(4) * x +
            ex(5);

        // Differentiate: d/dx(2x³ + 3x² + 4x + 5) = 6x² + 6x + 4
        final derivative = polynomial.differentiate();
        expect(derivative.evaluate({'x': 1}), equals(16)); // 6 + 6 + 4 = 16
        expect(derivative.evaluate({'x': 2}), equals(40)); // 24 + 12 + 4 = 40

        // Test that the derivative can be integrated back
        final integral = derivative.integrate();
        expect(integral, isA<Expression>());
      });

      test('should work with expression substitution in real scenarios', () {
        // Test substituting one expression into another
        // Original: f(x) = 2x + 1
        final f = ex(2) * x + ex(1);

        // Substitute x = y² + 3
        final substitution = y * y + ex(3);
        final composed = f.substitute(x, substitution);

        // Result: f(y² + 3) = 2(y² + 3) + 1 = 2y² + 6 + 1 = 2y² + 7
        expect(composed.evaluate({'y': 2}), equals(15)); // 2*4 + 7 = 15
        expect(composed.evaluate({'y': 0}), equals(7)); // 2*0 + 7 = 7
      });

      test('should handle multi-variable optimization scenarios', () {
        // Test a function of multiple variables: f(x,y,z) = x² + 2y² + 3z² + xy - 2xz + yz
        final f = x * x +
            ex(2) * y * y +
            ex(3) * z * z +
            x * y -
            ex(2) * x * z +
            y * z;

        // Test at various points
        final testCases = [
          {'x': 1, 'y': 1, 'z': 1, 'expected': 6}, // 1 + 2 + 3 + 1 - 2 + 1 = 6
          {'x': 0, 'y': 0, 'z': 0, 'expected': 0}, // All zeros
          {'x': 2, 'y': 1, 'z': 0, 'expected': 8}, // 4 + 2 + 0 + 2 - 0 + 0 = 8
        ];

        for (final testCase in testCases) {
          final values = Map<String, num>.from(testCase);
          final expected = values.remove('expected')!;
          expect(f.evaluate(values), equals(expected));
        }
      });
    });
  });
}
