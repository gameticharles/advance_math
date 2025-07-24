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
        expect(expr.toString(), equals('(-7)'));
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
        expect(expr.toString(), equals('2 + x'));
        final result = expr.evaluate({'x': 3});
        expect(result, equals(5));
      });

      test('should work in subtraction with variables', () {
        final expr = ex(10) - x;
        expect(expr, isA<Subtract>());
        expect(expr.toString(), equals('10 - x'));
        final result = expr.evaluate({'x': 3});
        expect(result, equals(7));
      });

      test('should work in multiplication with variables', () {
        final expr = ex(3) * x;
        expect(expr, isA<Multiply>());
        expect(expr.toString(), equals('3 * x'));
        final result = expr.evaluate({'x': 4});
        expect(result, equals(12));
      });

      test('should work in division with variables', () {
        final expr = ex(12) / x;
        expect(expr, isA<Divide>());
        expect(expr.toString(), equals('12 / x'));
        final result = expr.evaluate({'x': 3});
        expect(result, equals(4));
      });

      test('should work in power operations with variables', () {
        final expr = ex(2) ^ x;
        expect(expr, isA<Pow>());
        expect(expr.toString(), equals('2 ^ x'));
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
        expect((expr as Literal).value, isA<int>());
      });

      test('should work with double literals', () {
        final expr = ex(42.5);
        expect(expr, isA<Literal>());
        expect((expr as Literal).value, equals(42.5));
        expect((expr as Literal).value, isA<double>());
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
          expect((exExpr as Literal).value,
              equals((literalExpr as Literal).value));
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
  });

  group('NumToExpressionExtension Tests', () {
    late Variable x;
    late Variable y;

    setUp(() {
      x = Variable(Identifier('x'));
      y = Variable(Identifier('y'));
    });

    group('toExpression() method', () {
      test('should convert int to Literal expression', () {
        final expr = 5.toExpression();
        expect(expr, isA<Literal>());
        expect((expr as Literal).value, equals(5));
        expect(expr.toString(), equals('5'));
      });

      test('should convert double to Literal expression', () {
        final expr = 3.14.toExpression();
        expect(expr, isA<Literal>());
        expect((expr as Literal).value, equals(3.14));
        expect(expr.toString(), equals('3.14'));
      });

      test('should convert negative numbers to Literal expression', () {
        final expr = (-7).toExpression();
        expect(expr, isA<Literal>());
        expect((expr as Literal).value, equals(-7));
        expect(expr.toString(), equals('(-7)'));
      });

      test('should convert zero to Literal expression', () {
        final expr = 0.toExpression();
        expect(expr, isA<Literal>());
        expect((expr as Literal).value, equals(0));
        expect(expr.toString(), equals('0'));
      });
    });

    group('Addition operator (+)', () {
      test('should create Add expression with num + Variable', () {
        final expr = ex(2) + x;
        expect(expr, isA<Add>());
        expect(expr.toString(), equals('2 + x'));
      });

      test('should create Add expression with double + Variable', () {
        final expr = ex(3.5) + x;
        expect(expr, isA<Add>());
        expect(expr.toString(), equals('3.5 + x'));
      });

      test('should create Add expression with negative num + Variable', () {
        final expr = ex(-4) + x;
        expect(expr, isA<Add>());
        expect(expr.toString(), equals('(-4) + x'));
      });

      test('should evaluate correctly', () {
        final expr = ex(2) + x;
        final result = expr.evaluate({'x': 3});
        expect(result, equals(5));
      });

      test('should work with complex expressions', () {
        final expr = ex(1) + (x * y);
        expect(expr, isA<Add>());
        final result = expr.evaluate({'x': 2, 'y': 3});
        expect(result, equals(7)); // 1 + (2 * 3) = 7
      });
    });

    group('Subtraction operator (-)', () {
      test('should create Subtract expression with num - Variable', () {
        final expr = ex(10) - x;
        expect(expr, isA<Subtract>());
        expect(expr.toString(), equals('10 - x'));
      });

      test('should create Subtract expression with double - Variable', () {
        final expr = ex(7.5) - x;
        expect(expr, isA<Subtract>());
        expect(expr.toString(), equals('7.5 - x'));
      });

      test('should evaluate correctly', () {
        final expr = ex(10) - x;
        final result = expr.evaluate({'x': 3});
        expect(result, equals(7));
      });

      test('should handle negative results', () {
        final expr = ex(2) - x;
        final result = expr.evaluate({'x': 5});
        expect(result, equals(-3));
      });
    });

    group('Multiplication operator (*)', () {
      test('should create Multiply expression with num * Variable', () {
        final expr = ex(3) * x;
        expect(expr, isA<Multiply>());
        expect(expr.toString(), equals('3 * x'));
      });

      test('should create Multiply expression with double * Variable', () {
        final expr = Literal(2.5) * x;
        expect(expr, isA<Multiply>());
        expect(expr.toString(), equals('2.5 * x'));
      });

      test('should evaluate correctly', () {
        final expr = ex(4) * x;
        final result = expr.evaluate({'x': 5});
        expect(result, equals(20));
      });

      test('should handle zero multiplication', () {
        final expr = ex(0) * x;
        final result = expr.evaluate({'x': 100});
        expect(result, equals(0));
      });

      test('should work with fractional results', () {
        final expr = ex(3) * x;
        final result = expr.evaluate({'x': 1.5});
        expect(result, equals(4.5));
      });
    });

    group('Division operator (/)', () {
      test('should create Divide expression with num / Variable', () {
        final expr = ex(12) / x;
        expect(expr, isA<Divide>());
        expect(expr.toString(), equals('12 / x'));
      });

      test('should create Divide expression with double / Variable', () {
        final expr = ex(15.5) / x;
        expect(expr, isA<Divide>());
        expect(expr.toString(), equals('15.5 / x'));
      });

      test('should evaluate correctly', () {
        final expr = ex(20) / x;
        final result = expr.evaluate({'x': 4});
        expect(result, equals(5));
      });

      test('should handle fractional results', () {
        final expr = ex(7) / x;
        final result = expr.evaluate({'x': 2});
        expect(result, equals(3.5));
      });
    });

    group('Power operator (^)', () {
      test('should create Pow expression with num ^ Variable', () {
        final expr = Literal(2) ^ x;
        expect(expr, isA<Pow>());
        expect(expr.toString(), equals('2 ^ x'));
      });

      test('should create Pow expression with double ^ Variable', () {
        final expr = ex(3.5) ^ x;
        expect(expr, isA<Pow>());
        expect(expr.toString(), equals('3.5 ^ x'));
      });

      test('should evaluate correctly', () {
        final expr = ex(2) ^ x;
        final result = expr.evaluate({'x': 3});
        expect(result, equals(8)); // 2^3 = 8
      });

      test('should handle power of 1', () {
        final expr = ex(5) ^ x;
        final result = expr.evaluate({'x': 1});
        expect(result, equals(5));
      });

      test('should handle power of 0', () {
        final expr = ex(7) ^ x;
        final result = expr.evaluate({'x': 0});
        expect(result, equals(1));
      });
    });

    group('Complex expressions', () {
      test('should work with multiple operators', () {
        // (2 + x) * (3 - y)
        final expr = (ex(2)+ x) * (ex(3)- y);
        expect(expr, isA<Multiply>());
        final result = expr.evaluate({'x': 1, 'y': 1});
        expect(result, equals(6)); // (2 + 1) * (3 - 1) = 3 * 2 = 6
      });

      test('should work with nested expressions', () {
        // 2 * (x + (3 * y))
        final expr = ex(2) * (x + (ex(3)* y));
        expect(expr, isA<Multiply>());
        final result = expr.evaluate({'x': 1, 'y': 2});
        expect(result, equals(14)); // 2 * (1 + (3 * 2)) = 2 * 7 = 14
      });

      test('should work with polynomial-like expressions', () {
        // 2*x^2 + 3*x + 1
        final expr = (ex(2)* (x ^ 2.toExpression())) + (ex(3)* x) + 1.toExpression();
        expect(expr, isA<Add>());
        final result = expr.evaluate({'x': 2});
        expect(result, equals(15)); // 2*4 + 3*2 + 1 = 8 + 6 + 1 = 15
      });
    });

    group('Edge cases', () {
      test('should handle very large numbers', () {
        final expr = ex(1000000) * x;
        expect(expr, isA<Multiply>());
        final result = expr.evaluate({'x': 2});
        expect(result, equals(2000000));
      });

      test('should handle very small numbers', () {
        final expr = ex(0.001) * x;
        expect(expr, isA<Multiply>());
        final result = expr.evaluate({'x': 1000});
        expect(result, equals(1.0));
      });

      test('should work with multiple variables', () {
        final z = Variable(Identifier('z'));
        final expr = ex(2) * x + ex(3) * y - ex(1) * z;
        expect(expr, isA<Subtract>());
        final result = expr.evaluate({'x': 1, 'y': 2, 'z': 3});
        expect(result, equals(5)); // 2*1 + 3*2 - 1*3 = 2 + 6 - 3 = 5
      });
    });

    group('Type consistency', () {
      test('should produce same result as explicit Literal construction', () {
        final expr1 = ex(5) + x; // Using extension
        final expr2 = Literal(5) + x; // Explicit construction

        final result1 = expr1.evaluate({'x': 3});
        final result2 = expr2.evaluate({'x': 3});

        expect(result1, equals(result2));
        expect(expr1.toString(), equals(expr2.toString()));
      });

      test('should work consistently across all operators', () {
        final testValue = {'x': 4};

        // Test all operators with both approaches
        expect((ex(2)+ x).evaluate(testValue),
            equals((Literal(2) + x).evaluate(testValue)));
        expect((ex(2)- x).evaluate(testValue),
            equals((Literal(2) - x).evaluate(testValue)));
        expect((ex(2)* x).evaluate(testValue),
            equals((Literal(2) * x).evaluate(testValue)));
        expect((ex(2)/ x).evaluate(testValue),
            equals((Literal(2) / x).evaluate(testValue)));
        expect((ex(2)^ x).evaluate(testValue),
            equals((Literal(2) ^ x).evaluate(testValue)));
      });
    });

    group('Expression operations', () {
      test('should support differentiation', () {
        final expr = 3.toExpression() * x;
        final derivative = expr.differentiate();
        expect(derivative, isA<Expression>());
        // The derivative of 3*x should be 3
        expect(derivative.evaluate({'x': 1}), equals(3));
      });

      test('should support integration', () {
        final expr = 2.toExpression();
        final integral = expr.integrate();
        expect(integral, isA<Expression>());
        // The integral of a constant should be constant * x
        expect(integral, isA<Multiply>());
      });

      test('should support simplification', () {
        final expr = 5.toExpression() + x;
        final simplified = expr.simplify();
        expect(simplified, isA<Expression>());
        // Should return the same expression since it's already simple
        expect(simplified.toString(), equals(expr.toString()));
      });
    });
  });
}
