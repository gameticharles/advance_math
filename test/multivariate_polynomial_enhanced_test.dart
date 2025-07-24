import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  group('Multivariate Polynomial Tests with Enhanced Expression Creation', () {
    late Variable x, y, z;

    setUp(() {
      x = Variable('x');
      y = Variable('y');
      z = Variable('z');
    });

    group('Multivariate Expression Creation', () {
      test('should create multivariate expressions using toExpression()', () {
        // Create expression: 2xy + 3x - y + 5
        final expr = 2.toExpression() * x * y +
            3.toExpression() * x -
            y +
            5.toExpression();

        expect(expr, isA<Expression>());

        // Test evaluation
        final result = expr.evaluate({'x': 2, 'y': 3});
        expect(result, isA<num>());
        // 2*2*3 + 3*2 - 3 + 5 = 12 + 6 - 3 + 5 = 20
        expect(result, closeTo(20, 0.001));
      });

      test('should create multivariate expressions using ex() helper', () {
        // Create expression: 3x^2y - 2xy^2 + x - y + 1
        final expr = ex(3) * (x ^ 2.toExpression()) * y -
            ex(2) * x * (y ^ 2.toExpression()) +
            x -
            y +
            ex(1);

        expect(expr, isA<Expression>());

        // Test evaluation
        final result = expr.evaluate({'x': 1, 'y': 2});
        expect(result, isA<num>());
        // 3*1*2 - 2*1*4 + 1 - 2 + 1 = 6 - 8 + 1 - 2 + 1 = -2
        expect(result, closeTo(-2, 0.001));
      });

      test('should create multivariate expressions using mixed methods', () {
        // Create expression: 4x^2y^2 - 3xy + 2x - y + 7
        final expr =
            4.toExpression() * (x ^ 2.toExpression()) * (y ^ 2.toExpression()) -
                ex(3) * x * y +
                2.toExpression() * x -
                y +
                Literal(7);

        expect(expr, isA<Expression>());

        // Test evaluation
        final result = expr.evaluate({'x': 1, 'y': 1});
        expect(result, isA<num>());
        // 4*1*1 - 3*1*1 + 2*1 - 1 + 7 = 4 - 3 + 2 - 1 + 7 = 9
        expect(result, closeTo(9, 0.001));
      });
    });

    group('Three Variable Expressions', () {
      test('should create three-variable expressions with enhanced literals',
          () {
        // Create expression: 2xyz + x^2y - 3xz^2 + 4y^2z - 5
        final expr = 2.toExpression() * x * y * z +
            (x ^ 2.toExpression()) * y -
            ex(3) * x * (z ^ 2.toExpression()) +
            4.toExpression() * (y ^ 2.toExpression()) * z -
            Literal(5);

        expect(expr, isA<Expression>());

        // Test evaluation
        final result = expr.evaluate({'x': 1, 'y': 2, 'z': 1});
        expect(result, isA<num>());
        // 2*1*2*1 + 1*2 - 3*1*1 + 4*4*1 - 5 = 4 + 2 - 3 + 16 - 5 = 14
        expect(result, closeTo(14, 0.001));
      });

      test('should handle complex three-variable polynomial operations', () {
        // Create two three-variable expressions
        final expr1 = x * y * z + 2.toExpression() * x;
        final expr2 = ex(3) * y * z - Literal(1);

        final sum = expr1 + expr2;
        final product = expr1 * expr2;

        expect(sum, isA<Expression>());
        expect(product, isA<Expression>());

        // Test evaluation of sum
        final sumResult = sum.evaluate({'x': 1, 'y': 2, 'z': 3});
        expect(sumResult, isA<num>());
        // (1*2*3 + 2*1) + (3*2*3 - 1) = (6 + 2) + (18 - 1) = 8 + 17 = 25
        expect(sumResult, closeTo(25, 0.001));

        // Test evaluation of product
        final productResult = product.evaluate({'x': 1, 'y': 2, 'z': 3});
        expect(productResult, isA<num>());
        // (1*2*3 + 2*1) * (3*2*3 - 1) = 8 * 17 = 136
        expect(productResult, closeTo(136, 0.001));
      });
    });

    group('Multivariate Differentiation', () {
      test('should differentiate multivariate expressions with respect to x',
          () {
        // Create expression: x^2y + 3xy^2 - 2x + y
        final expr = (x ^ 2.toExpression()) * y +
            ex(3) * x * (y ^ 2.toExpression()) -
            2.toExpression() * x +
            y;

        // Differentiate with respect to x
        final dxExpr = expr.differentiate();
        expect(dxExpr, isA<Expression>());

        // Test evaluation of derivative
        final result = dxExpr.evaluate({'x': 1, 'y': 2});
        expect(result, isA<num>());
      });

      test('should handle partial derivatives in multivariate expressions', () {
        // Create expression: 2x^3y^2 + xy - 3y^2 + 5
        final expr = 2.toExpression() * (x ^ ex(3)) * (y ^ 2.toExpression()) +
            x * y -
            ex(3) * (y ^ 2.toExpression()) +
            Literal(5);

        // Differentiate (this will be with respect to the default variable)
        final derivative = expr.differentiate();
        expect(derivative, isA<Expression>());

        // Test that derivative can be evaluated
        final result = derivative.evaluate({'x': 1, 'y': 2});
        expect(result, isA<num>());
      });
    });

    group('Complex Multivariate Operations', () {
      test('should handle nested multivariate expressions', () {
        // Create nested expression: (x + y)^2 * (x - y)
        final sum = x + y;
        final diff = x - y;
        final squared = sum ^ 2.toExpression();
        final product = squared * diff;

        expect(product, isA<Expression>());

        // Test evaluation
        final result = product.evaluate({'x': 3, 'y': 1});
        expect(result, isA<num>());
        // (3 + 1)^2 * (3 - 1) = 16 * 2 = 32
        expect(result, closeTo(32, 0.001));
      });

      test('should handle rational multivariate expressions', () {
        // Create rational expression: (x^2 + y^2) / (x + y)
        final numerator = (x ^ 2.toExpression()) + (y ^ 2.toExpression());
        final denominator = x + y;
        final rational = numerator / denominator;

        expect(rational, isA<Expression>());

        // Test evaluation (avoiding x + y = 0)
        final result = rational.evaluate({'x': 3, 'y': 1});
        expect(result, isA<num>());
        // (9 + 1) / (3 + 1) = 10 / 4 = 2.5
        expect(result, closeTo(2.5, 0.001));
      });

      test('should handle trigonometric multivariate expressions', () {
        // Create expression: sin(xy) + cos(x + y)
        final sinPart = Sin(x * y);
        final cosPart = Cos(x + y);
        final sum = sinPart + cosPart;

        expect(sum, isA<Expression>());

        // Test evaluation
        final result = sum.evaluate({'x': 0, 'y': 1});
        expect(result, isA<num>());
      });

      test('should handle exponential multivariate expressions', () {
        // Create expression: (x + y)^(x - y)
        final base = x + y;
        final exponent = x - y;
        final power = base ^ exponent;

        expect(power, isA<Expression>());

        // Test evaluation
        final result = power.evaluate({'x': 2, 'y': 1});
        expect(result, isA<num>());
        // (2 + 1)^(2 - 1) = 3^1 = 3
        expect(result, closeTo(3, 0.001));
      });
    });

    group('Multivariate Expression Equivalence', () {
      test('should produce equivalent results across creation methods', () {
        final coeff = 3;

        // Create same multivariate expression using different methods
        final expr1 = coeff.toExpression() * x * y + 2.toExpression();
        final expr2 = ex(coeff) * x * y + ex(2);
        final expr3 = Literal(coeff) * x * y + Literal(2);

        // All should evaluate to the same result
        final testValues = {'x': 2, 'y': 3};
        final result1 = expr1.evaluate(testValues);
        final result2 = expr2.evaluate(testValues);
        final result3 = expr3.evaluate(testValues);

        expect(result1, closeTo(result2, 0.001));
        expect(result2, closeTo(result3, 0.001));
        expect(result1, closeTo(result3, 0.001));
      });

      test('should handle edge cases in multivariate expressions', () {
        // Test with zero coefficients
        final zeroExpr = 0.toExpression() * x * y + ex(0) * x;
        expect(zeroExpr, isA<Expression>());

        final result = zeroExpr.evaluate({'x': 5, 'y': 3});
        expect(result, equals(0));

        // Test with negative coefficients
        final negExpr = (-2).toExpression() * x * y + ex(-3) * x;
        expect(negExpr, isA<Expression>());

        final negResult = negExpr.evaluate({'x': 1, 'y': 2});
        expect(negResult, equals(-7)); // -2*1*2 + (-3)*1 = -4 - 3 = -7

        // Test with decimal coefficients
        final decimalExpr = 2.5.toExpression() * x * y + ex(1.5) * x;
        expect(decimalExpr, isA<Expression>());

        final decimalResult = decimalExpr.evaluate({'x': 2, 'y': 2});
        expect(
            decimalResult, closeTo(13, 0.001)); // 2.5*2*2 + 1.5*2 = 10 + 3 = 13
      });
    });

    group('Integration with Existing Expression System', () {
      test('should work seamlessly with existing Variable system', () {
        // Test that enhanced literals work with existing Variable objects
        final existingVar = Variable('t');
        final expr = 2.toExpression() * existingVar + ex(3);

        expect(expr, isA<Expression>());

        final result = expr.evaluate({'t': 4});
        expect(result, equals(11)); // 2*4 + 3 = 11
      });

      test('should maintain type safety with enhanced literals', () {
        // Test that type safety is maintained
        final expr = 2.toExpression() * x + ex(3) * y;

        expect(expr, isA<Expression>());

        // Should work with all variables provided
        final result = expr.evaluate({'x': 2, 'y': 3});
        expect(result, equals(13)); // 2*2 + 3*3 = 4 + 9 = 13

        // Test with partial variable substitution
        final partialResult = expr.evaluate({'x': 2});
        expect(partialResult,
            isA<Expression>()); // Should return an expression with y still symbolic
      });

      test('should handle complex nested multivariate scenarios', () {
        // Create a complex nested expression using all three methods
        final complex =
            (2.toExpression() * x + ex(1)) * (y - 3.toExpression()) +
                Literal(4) * (x ^ 2.toExpression()) * y;

        expect(complex, isA<Expression>());

        // Test evaluation
        final result = complex.evaluate({'x': 1, 'y': 2});
        expect(result, isA<num>());
        // (2*1 + 1) * (2 - 3) + 4 * 1 * 2 = 3 * (-1) + 8 = -3 + 8 = 5
        expect(result, closeTo(5, 0.001));
      });
    });
  });
}
