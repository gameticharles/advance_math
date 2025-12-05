import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  group('Enhanced Error Handling Integration Tests', () {
    late Variable x, y;

    setUp(() {
      x = Variable('x');
      y = Variable('y');
    });

    group('Valid operations should still work', () {
      test('should handle valid Expression + Expression operations', () {
        final expr = x + y;
        expect(expr, isA<Add>());
        expect(expr.evaluate({'x': 2, 'y': 3}), equals(5));
      });

      test('should handle valid Expression + num operations', () {
        final expr = x + 5;
        expect(expr, isA<Add>());
        expect(expr.evaluate({'x': 3}), equals(8));
      });

      test('should handle valid Literal operations', () {
        final expr = Literal(2) + Literal(3);
        expect(expr, isA<Add>());
        expect(expr.evaluate(), equals(5));
      });

      test('should handle complex valid expressions', () {
        final expr = (x + 2) * (y - 1);
        expect(expr, isA<Multiply>());
        expect(expr.evaluate({'x': 3, 'y': 4}),
            equals(15)); // (3+2) * (4-1) = 5 * 3 = 15
      });

      test('should handle all arithmetic operations with valid operands', () {
        expect((x + 1).evaluate({'x': 2}), equals(3));
        expect((x - 1).evaluate({'x': 2}), equals(1));
        expect((x * 2).evaluate({'x': 3}), equals(6));
        expect((x / 2).evaluate({'x': 6}), equals(3));
        expect((x ^ 2).evaluate({'x': 3}), equals(9));
      });
    });

    group('Enhanced error handling should work', () {
      test('should throw enhanced errors for invalid types', () {
        expect(
            () => x + "invalid", throwsA(isA<ExpressionOperationException>()));
        expect(() => x - true, throwsA(isA<ExpressionOperationException>()));
        expect(() => x * [1, 2], throwsA(isA<ExpressionOperationException>()));
        expect(() => x / {'key': 'value'},
            throwsA(isA<ExpressionOperationException>()));
        expect(() => x ^ null, throwsA(isA<ExpressionOperationException>()));
      });

      test('should throw validation errors for invalid numeric values', () {
        expect(() => x + double.nan,
            throwsA(isA<ExpressionValidationException>()));
        expect(() => x * double.infinity,
            throwsA(isA<ExpressionValidationException>()));
        expect(() => x / double.negativeInfinity,
            throwsA(isA<ExpressionValidationException>()));
      });

      test('should provide helpful error messages', () {
        try {
          x + "test";
          fail('Expected exception');
        } catch (e) {
          expect(e.toString(), contains('Invalid operands for + operation'));
          expect(e.toString(), contains('Suggested solutions'));
        }
      });
    });

    group('Backward compatibility', () {
      test('should maintain compatibility with existing Expression usage', () {
        // Test that existing patterns still work
        final expr1 = Add(x, Literal(5));
        final expr2 = Multiply(Literal(2), y);
        final expr3 = Pow(x, Literal(2));

        expect(expr1.evaluate({'x': 3}), equals(8));
        expect(expr2.evaluate({'y': 4}), equals(8));
        expect(expr3.evaluate({'x': 3}), equals(9));
      });

      test('should maintain compatibility with expression parsing', () {
        final expr = Expression.parse('x + 5');
        expect(expr.evaluate({'x': 3}), equals(8));
      });

      test('should maintain compatibility with differentiation', () {
        final expr = x * x; // x^2
        final derivative = expr.differentiate();
        // The derivative should be mathematically correct, even if not simplified
        expect(derivative.toString(), contains('x'));
        expect(derivative.toString(), contains('1'));
      });
    });

    group('Edge cases', () {
      test('should handle zero correctly', () {
        expect((x + 0).evaluate({'x': 5}), equals(5));
        expect((x * 0).evaluate({'x': 5}), equals(0));
        expect((Literal(0) + x).evaluate({'x': 5}), equals(5));
      });

      test('should handle negative numbers correctly', () {
        expect((x + (-3)).evaluate({'x': 5}), equals(2));
        expect((x * (-2)).evaluate({'x': 3}), equals(-6));
      });

      test('should handle very large numbers', () {
        expect(() => x + 1e100, returnsNormally);
        expect(() => x * 1e-100, returnsNormally);
      });

      test('should handle decimal numbers correctly', () {
        expect((x + 3.14).evaluate({'x': 1.86}), closeTo(5.0, 0.001));
        expect((x * 2.5).evaluate({'x': 4}), equals(10.0));
      });
    });
  });
}
