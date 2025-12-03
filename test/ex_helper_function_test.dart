import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  group('Global ex() Helper Function Tests', () {
    late Variable x;
    late Variable y;

    setUp(() {
      x = Variable(Identifier('x'));
      y = Variable(Identifier('y'));
    });

    group('Basic ex() function tests', () {
      test('should convert int to Literal expression', () {
        final expr = ex(5);
        expect(expr, isA<Literal>());
        expect((expr as Literal).value, equals(5));
        expect(expr.toString(), equals('5'));
      });

      test('should convert double to Literal expression', () {
        final expr = ex(3.14);
        expect(expr, isA<Literal>());
        expect((expr as Literal).value, equals(3.14));
        expect(expr.toString(), equals('3.14'));
      });

      test('should convert negative numbers to Literal expression', () {
        final expr = ex(-7);
        expect(expr, isA<Literal>());
        expect((expr as Literal).value, equals(-7));
        expect(expr.toString(), equals('-7'));
      });

      test('should convert zero to Literal expression', () {
        final expr = ex(0);
        expect(expr, isA<Literal>());
        expect((expr as Literal).value, equals(0));
        expect(expr.toString(), equals('0'));
      });

      test('should convert very large numbers', () {
        final expr = ex(1000000);
        expect(expr, isA<Literal>());
        expect((expr as Literal).value, equals(1000000));
        expect(expr.toString(), equals('1000000'));
      });

      test('should convert very small decimal numbers', () {
        final expr = ex(0.001);
        expect(expr, isA<Literal>());
        expect((expr as Literal).value, equals(0.001));
        expect(expr.toString(), equals('0.001'));
      });

      test('should handle scientific notation numbers', () {
        final expr = ex(1e6);
        expect(expr, isA<Literal>());
        expect((expr as Literal).value, equals(1000000.0));
      });

      test('should handle negative scientific notation', () {
        final expr = ex(-1e-3);
        expect(expr, isA<Literal>());
        expect((expr as Literal).value, equals(-0.001));
      });
    });

    group('ex() function in arithmetic operations', () {
      test('should work in addition with variables', () {
        final expr = ex(2) + x;
        expect(expr, isA<Add>());
        expect(expr.toString(), equals('2+x'));
        final result = expr.evaluate({'x': 3});
        expect(result, equals(5));
      });

      test('should work in subtraction with variables', () {
        final expr = ex(10) - x;
        expect(expr, isA<Subtract>());
        expect(expr.toString(), equals('10-x'));
        final result = expr.evaluate({'x': 3});
        expect(result, equals(7));
      });

      test('should work in multiplication with variables', () {
        final expr = ex(3) * x;
        expect(expr, isA<Multiply>());
        expect(expr.toString(), equals('3*x'));
        final result = expr.evaluate({'x': 4});
        expect(result, equals(12));
      });

      test('should work in division with variables', () {
        final expr = ex(12) / x;
        expect(expr, isA<Divide>());
        expect(expr.toString(), equals('12/x'));
        final result = expr.evaluate({'x': 3});
        expect(result, equals(4));
      });

      test('should work in power operations with variables', () {
        final expr = ex(2) ^ x;
        expect(expr, isA<Pow>());
        expect(expr.toString(), equals('2^x'));
        final result = expr.evaluate({'x': 3});
        expect(result, equals(8));
      });
    });

    group('ex() function in complex expressions', () {
      test('should work in polynomial expressions', () {
        // 2*x^2 + 3*x + 1
        final expr = ex(2) * (x ^ ex(2)) + ex(3) * x + ex(1);
        expect(expr, isA<Add>());
        final result = expr.evaluate({'x': 2});
        expect(result, equals(15)); // 2*4 + 3*2 + 1 = 15
      });

      test('should work with multiple variables', () {
        // 2*x + 3*y - 4
        final expr = ex(2) * x + ex(3) * y - ex(4);
        expect(expr, isA<Subtract>());
        final result = expr.evaluate({'x': 1, 'y': 2});
        expect(result, equals(4)); // 2*1 + 3*2 - 4 = 4
      });

      test('should work in nested expressions', () {
        // ex(2) * (ex(3) + x)
        final expr = ex(2) * (ex(3) + x);
        expect(expr, isA<Multiply>());
        final result = expr.evaluate({'x': 4});
        expect(result, equals(14)); // 2 * (3 + 4) = 14
      });

      test('should work with mixed ex() and Literal usage', () {
        final expr1 = ex(5) + x;
        final expr2 = Literal(5) + x;

        final result1 = expr1.evaluate({'x': 3});
        final result2 = expr2.evaluate({'x': 3});

        expect(result1, equals(result2));
        expect(expr1.toString(), equals(expr2.toString()));
      });

      test('should work in complex mathematical expressions', () {
        // (ex(2) + x) * (ex(3) - y) / ex(4)
        final expr = (ex(2) + x) * (ex(3) - y) / ex(4);
        expect(expr, isA<Divide>());
        final result = expr.evaluate({'x': 1, 'y': 1});
        expect(result, equals(1.5)); // (2 + 1) * (3 - 1) / 4 = 6 / 4 = 1.5
      });
    });

    group('ex() function with different numeric types', () {
      test('should work with int literals', () {
        final expr = ex(42);
        expect(expr, isA<Literal>());
        expect((expr as Literal).value, equals(42));
        expect((expr).value, isA<int>());
      });

      test('should work with double literals', () {
        final expr = ex(42.5);
        expect(expr, isA<Literal>());
        expect((expr as Literal).value, equals(42.5));
        expect((expr).value, isA<double>());
      });

      test('should preserve numeric type in evaluation', () {
        final intExpr = ex(5);
        final doubleExpr = ex(5.0);

        expect(intExpr.evaluate(), equals(5));
        expect(doubleExpr.evaluate(), equals(5.0));
        expect(intExpr.evaluate(), isA<int>());
        expect(doubleExpr.evaluate(), isA<double>());
      });
    });

    group('ex() function edge cases', () {
      test('should handle infinity', () {
        final expr = ex(double.infinity);
        expect(expr, isA<Literal>());
        expect((expr as Literal).value, equals(double.infinity));
      });

      test('should handle negative infinity', () {
        final expr = ex(double.negativeInfinity);
        expect(expr, isA<Literal>());
        expect((expr as Literal).value, equals(double.negativeInfinity));
      });

      test('should handle NaN', () {
        final expr = ex(double.nan);
        expect(expr, isA<Literal>());
        expect((expr as Literal).value.isNaN, isTrue);
      });

      test('should handle maximum integer values', () {
        final expr = ex(9223372036854775807); // Max int64
        expect(expr, isA<Literal>());
        expect((expr as Literal).value, equals(9223372036854775807));
      });

      test('should handle minimum integer values', () {
        final expr = ex(-9223372036854775808); // Min int64
        expect(expr, isA<Literal>());
        expect((expr as Literal).value, equals(-9223372036854775808));
      });
    });

    group('ex() function expression operations', () {
      test('should support differentiation', () {
        final expr = ex(5);
        final derivative = expr.differentiate();
        expect(derivative, isA<Literal>());
        expect((derivative as Literal).value, equals(0));
      });

      test('should support integration', () {
        final expr = ex(3);
        final integral = expr.integrate();
        expect(integral, isA<Multiply>());
        // Integration of constant should be constant * x
        expect(integral.toString(), contains('3'));
        expect(integral.toString(), contains('x'));
      });

      test('should support simplification', () {
        final expr = ex(7);
        final simplified = expr.simplify();
        expect(simplified, isA<Literal>());
        expect((simplified as Literal).value, equals(7));
        expect(simplified.toString(), equals('7'));
      });

      test('should support expansion', () {
        final expr = ex(9);
        final expanded = expr.expand();
        expect(expanded, isA<Literal>());
        expect((expanded as Literal).value, equals(9));
        expect(expanded.toString(), equals('9'));
      });

      test('should return empty set for variable terms', () {
        final expr = ex(4);
        final variables = expr.getVariableTerms();
        expect(variables, isEmpty);
      });

      test('should support substitution (no-op for literals)', () {
        final expr = ex(6);
        final substituted = expr.substitute(x, ex(10));
        expect(substituted, isA<Literal>());
        expect((substituted as Literal).value, equals(6));
      });
    });

    group('ex() function performance and consistency', () {
      test('should be equivalent to Literal constructor', () {
        final values = [0, 1, -1, 42, -42, 3.14, -3.14, 0.001, 1000000];

        for (final value in values) {
          final exExpr = ex(value);
          final literalExpr = Literal(value);

          expect(exExpr.toString(), equals(literalExpr.toString()));
          expect(exExpr.evaluate(), equals(literalExpr.evaluate()));
          expect((exExpr as Literal).value, equals((literalExpr).value));
        }
      });

      test('should maintain consistency in complex expressions', () {
        // Test that ex() produces same results as Literal() in complex expressions
        final testCases = [
          {'x': 1, 'y': 2},
          {'x': 0, 'y': 5},
          {'x': -3, 'y': 4},
          {'x': 2.5, 'y': -1.5},
        ];

        for (final testCase in testCases) {
          final exExpr = ex(2) * x + ex(3) * y + ex(1);
          final literalExpr = Literal(2) * x + Literal(3) * y + Literal(1);

          final exResult = exExpr.evaluate(testCase);
          final literalResult = literalExpr.evaluate(testCase);

          expect(exResult, equals(literalResult));
        }
      });
    });

    group('ex() function documentation examples', () {
      test('should work with basic example from documentation', () {
        // Example from the documentation comment
        final expr = ex(2) * x + ex(3);
        expect(expr, isA<Add>());
        expect(expr.toString(), equals('2*x+3'));

        final result = expr.evaluate({'x': 5});
        expect(result, equals(13)); // 2*5 + 3 = 13
      });

      test('should work with more complex example', () {
        // More complex polynomial: ex(3)*x^ex(2) - ex(4)/x + ex(1)
        final expr = ex(3) * (x ^ ex(2)) - ex(4) / x + ex(1);
        expect(expr, isA<Add>());

        final result = expr.evaluate({'x': 2});
        expect(result, equals(11)); // 3*4 - 4/2 + 1 = 12 - 2 + 1 = 11
      });

      test('should demonstrate conciseness compared to Literal', () {
        // Show that ex() is more concise than Literal()
        final exExpr = ex(2) * x + ex(3) * (x ^ ex(2)) - ex(1);
        final literalExpr =
            Literal(2) * x + Literal(3) * (x ^ Literal(2)) - Literal(1);

        // Both should produce the same result
        final testValue = {'x': 3};
        expect(exExpr.evaluate(testValue),
            equals(literalExpr.evaluate(testValue)));
        expect(exExpr.toString(), equals(literalExpr.toString()));
      });
    });
  });
}
