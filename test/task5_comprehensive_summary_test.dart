import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

/// Comprehensive test suite for Task 5: Test polynomial and derivative operations
/// with enhanced expression creation
///
/// This test file demonstrates all the requirements for task 5:
/// - Write tests for polynomial expressions created using enhanced methods
/// - Test differentiation of expressions created with new literal conversion approaches
/// - Test integration of expressions using mixed literal creation methods
/// - Verify multivariate expressions work correctly with enhanced literal handling
void main() {
  group(
      'Task 5: Polynomial and Derivative Operations with Enhanced Expression Creation',
      () {
    late Variable x, y, z;

    setUp(() {
      x = Variable('x');
      y = Variable('y');
      z = Variable('z');
    });

    group('Requirement 3.1: Polynomial expressions with enhanced methods', () {
      test('should create and evaluate polynomials using toExpression()', () {
        // Create polynomial: 3x^2 + 2x + 1 using toExpression()
        final poly = Polynomial([
          3.toExpression().evaluate(),
          2.toExpression().evaluate(),
          1.toExpression().evaluate()
        ]);

        expect(poly.degree, equals(2));

        // Test evaluation at x = 2: 3*4 + 2*2 + 1 = 17
        final result = poly.evaluate(2);
        expect(result.real, closeTo(17, 0.001));
      });

      test('should create and evaluate polynomials using ex() helper', () {
        // Create polynomial: 2x^3 - x^2 + 4x - 3 using ex()
        final poly = Polynomial([
          (ex(2) as Literal).value,
          (ex(-1) as Literal).value,
          (ex(4) as Literal).value,
          (ex(-3) as Literal).value
        ]);

        expect(poly.degree, equals(3));

        // Test evaluation at x = 1: 2 - 1 + 4 - 3 = 2
        final result = poly.evaluate(1);
        expect(result.real, closeTo(2, 0.001));
      });

      test('should create polynomials with mixed enhanced methods', () {
        // Mix toExpression(), ex(), and Literal approaches
        final poly = Polynomial([
          2.toExpression().evaluate(), // toExpression
          (ex(-3) as Literal).value, // ex() helper
          Literal(5).value // explicit Literal
        ]);

        expect(poly.degree, equals(2));

        // Test evaluation at x = 2: 2*4 - 3*2 + 5 = 8 - 6 + 5 = 7
        final result = poly.evaluate(2);
        expect(result.real, closeTo(7, 0.001));
      });

      test('should perform polynomial arithmetic with enhanced methods', () {
        final poly1 = Polynomial(
            [2.toExpression().evaluate(), 1.toExpression().evaluate()]);

        final poly2 =
            Polynomial([(ex(1) as Literal).value, (ex(-2) as Literal).value]);

        // Test addition
        final sum = poly1 + poly2;
        expect(sum, isA<Polynomial>());

        // Test multiplication
        final product = poly1 * poly2;
        expect(product, isA<Polynomial>());
      });
    });

    group(
        'Requirement 3.2: Differentiation with new literal conversion approaches',
        () {
      test('should differentiate polynomials created with toExpression()', () {
        // Create polynomial: 4x^3 + 3x^2 + 2x + 1
        final poly = Polynomial([
          4.toExpression().evaluate(),
          3.toExpression().evaluate(),
          2.toExpression().evaluate(),
          1.toExpression().evaluate()
        ]);

        final derivative = poly.differentiate();
        expect(derivative, isA<Polynomial>());

        // Derivative should be: 12x^2 + 6x + 2
        // Test at x = 1: 12 + 6 + 2 = 20
        final result = derivative.evaluate(1);
        expect(result.real, closeTo(20, 0.001));
      });

      test('should differentiate polynomials created with ex() helper', () {
        // Create polynomial: 5x^2 - 3x + 7
        final poly = Polynomial([
          (ex(5) as Literal).value,
          (ex(-3) as Literal).value,
          (ex(7) as Literal).value
        ]);

        final derivative = poly.differentiate();
        expect(derivative, isA<Polynomial>());

        // Derivative should be: 10x - 3
        // Test at x = 2: 20 - 3 = 17
        final result = derivative.evaluate(2);
        expect(result.real, closeTo(17, 0.001));
      });

      test('should differentiate complex expressions with enhanced literals',
          () {
        // Create expression: 2x^3 + 3x^2 - 4x + 5 using mixed methods
        final expr = 2.toExpression() * (x ^ ex(3)) +
            ex(3) * (x ^ 2.toExpression()) -
            4.toExpression() * x +
            Literal(5);

        final derivative = expr.differentiate();
        expect(derivative, isA<Expression>());

        // Test that derivative can be evaluated
        final result = derivative.evaluate({'x': 1});
        expect(result, isA<num>());
      });

      test(
          'should differentiate trigonometric expressions with enhanced literals',
          () {
        // Create expression: sin(2x + 1) using enhanced literals
        final innerExpr = 2.toExpression() * x + ex(1);
        final sinExpr = Sin(innerExpr);

        final derivative = sinExpr.differentiate();
        expect(derivative, isA<Expression>());

        // Test evaluation
        final result = derivative.evaluate({'x': 0});
        expect(result, isA<num>());
      });
    });

    group('Requirement 3.2: Integration with mixed literal creation methods',
        () {
      test('should integrate polynomials created with toExpression()', () {
        // Create polynomial: 3x^2 + 2x using toExpression()
        final poly = Polynomial(
            [3.toExpression().evaluate(), 2.toExpression().evaluate()]);

        final integral = poly.integrate();
        expect(integral, isA<Expression>());

        // Integration adds coefficients, so expect more terms
        if (integral is Polynomial) {
          expect(integral.coefficients.length, greaterThan(2));
        }
      });

      test('should integrate polynomials created with ex() helper', () {
        // Create polynomial: 4x^3 - 2x^2 + x using ex()
        final poly = Polynomial([
          (ex(4) as Literal).value,
          (ex(-2) as Literal).value,
          (ex(1) as Literal).value
        ]);

        final integral = poly.integrate();
        expect(integral, isA<Expression>());

        if (integral is Polynomial) {
          expect(integral.coefficients.length, greaterThan(3));
        }
      });

      test('should integrate expressions with mixed literal creation methods',
          () {
        // Create expression: x^2 + 2x + 1 using mixed methods
        final expr = (x ^ 2.toExpression()) + ex(2) * x + Literal(1);

        final integral = expr.integrate();
        expect(integral, isA<Expression>());

        // Test that integral can be evaluated
        final result = integral.evaluate({'x': 2});
        expect(result, isA<num>());
      });
    });

    group(
        'Requirement 3.3: Multivariate expressions with enhanced literal handling',
        () {
      test('should create two-variable expressions with enhanced literals', () {
        // Create expression: 3xy + 2x^2 - y^2 + 4
        final expr = 3.toExpression() * x * y +
            ex(2) * (x ^ 2.toExpression()) -
            (y ^ 2.toExpression()) +
            Literal(4);

        expect(expr, isA<Expression>());

        // Test evaluation at x=2, y=1: 3*2*1 + 2*4 - 1 + 4 = 6 + 8 - 1 + 4 = 17
        final result = expr.evaluate({'x': 2, 'y': 1});
        expect(result, closeTo(17, 0.001));
      });

      test('should create three-variable expressions with enhanced literals',
          () {
        // Create expression: 2xyz + x^2y - 3xz^2 + 5
        final expr = 2.toExpression() * x * y * z +
            (x ^ 2.toExpression()) * y -
            ex(3) * x * (z ^ 2.toExpression()) +
            Literal(5);

        expect(expr, isA<Expression>());

        // Test evaluation at x=1, y=2, z=1: 2*1*2*1 + 1*2 - 3*1*1 + 5 = 4 + 2 - 3 + 5 = 8
        final result = expr.evaluate({'x': 1, 'y': 2, 'z': 1});
        expect(result, closeTo(8, 0.001));
      });

      test('should perform multivariate arithmetic with enhanced literals', () {
        // Create two multivariate expressions
        final expr1 = 2.toExpression() * x * y + ex(3) * x;
        final expr2 = y - 1.toExpression();

        final sum = expr1 + expr2;
        final product = expr1 * expr2;

        expect(sum, isA<Expression>());
        expect(product, isA<Expression>());

        // Test evaluation of sum at x=1, y=2: (2*1*2 + 3*1) + (2 - 1) = 7 + 1 = 8
        final sumResult = sum.evaluate({'x': 1, 'y': 2});
        expect(sumResult, closeTo(8, 0.001));

        // Test evaluation of product at x=1, y=2: (2*1*2 + 3*1) * (2 - 1) = 7 * 1 = 7
        final productResult = product.evaluate({'x': 1, 'y': 2});
        expect(productResult, closeTo(7, 0.001));
      });

      test(
          'should differentiate multivariate expressions with enhanced literals',
          () {
        // Create expression: x^2y + 3xy^2 - 2x + y
        final expr = (x ^ 2.toExpression()) * y +
            ex(3) * x * (y ^ 2.toExpression()) -
            2.toExpression() * x +
            y;

        final derivative = expr.differentiate();
        expect(derivative, isA<Expression>());

        // Test evaluation of derivative
        final result = derivative.evaluate({'x': 1, 'y': 2});
        expect(result, isA<num>());
      });

      test('should handle complex nested multivariate expressions', () {
        // Create nested expression: (x + y)^2 * (2x - y) using enhanced literals
        final sum = x + y;
        final diff = 2.toExpression() * x - y;
        final squared = sum ^ 2.toExpression();
        final product = squared * diff;

        expect(product, isA<Expression>());

        // Test evaluation at x=2, y=1: (2+1)^2 * (4-1) = 9 * 3 = 27
        final result = product.evaluate({'x': 2, 'y': 1});
        expect(result, closeTo(27, 0.001));
      });

      test(
          'should handle rational multivariate expressions with enhanced literals',
          () {
        // Create rational expression: (x^2 + 2y) / (x + y)
        final numerator = (x ^ 2.toExpression()) + 2.toExpression() * y;
        final denominator = x + y;
        final rational = numerator / denominator;

        expect(rational, isA<Expression>());

        // Test evaluation at x=3, y=1: (9 + 2) / (3 + 1) = 11 / 4 = 2.75
        final result = rational.evaluate({'x': 3, 'y': 1});
        expect(result, closeTo(2.75, 0.001));
      });
    });

    group('Cross-Method Equivalence and Performance', () {
      test(
          'should produce equivalent results across all enhanced creation methods',
          () {
        final coeff = 5;

        // Create same expression using different methods
        final expr1 = coeff.toExpression() * x + 3.toExpression();
        final expr2 = ex(coeff) * x + ex(3);
        final expr3 = Literal(coeff) * x + Literal(3);

        // All should evaluate to the same result
        final testValue = {'x': 2};
        final result1 = expr1.evaluate(testValue);
        final result2 = expr2.evaluate(testValue);
        final result3 = expr3.evaluate(testValue);

        expect(result1, closeTo(result2, 0.001));
        expect(result2, closeTo(result3, 0.001));
        expect(result1, closeTo(result3, 0.001));

        // All should equal 5*2 + 3 = 13
        expect(result1, closeTo(13, 0.001));
      });

      test('should handle edge cases with enhanced literals', () {
        // Test with zero coefficients
        final zeroExpr = 0.toExpression() * x + ex(0);
        final result = zeroExpr.evaluate({'x': 5});
        expect(result, equals(0));

        // Test with negative coefficients
        final negExpr = (-2).toExpression() * x + ex(-3);
        final negResult = negExpr.evaluate({'x': 1});
        expect(negResult, equals(-5));

        // Test with decimal coefficients
        final decimalExpr = 2.5.toExpression() * x + ex(1.5);
        final decimalResult = decimalExpr.evaluate({'x': 2});
        expect(decimalResult, closeTo(6.5, 0.001));
      });

      test(
          'should maintain backward compatibility with existing Expression system',
          () {
        // Test that enhanced literals work with existing Variable objects
        final existingVar = Variable('t');
        final expr = 2.toExpression() * existingVar + ex(3);

        expect(expr, isA<Expression>());

        final result = expr.evaluate({'t': 4});
        expect(result, equals(11)); // 2*4 + 3 = 11
      });
    });

    group('Advanced Mathematical Operations', () {
      test('should handle logarithmic expressions with enhanced literals', () {
        // Create expression: ln(2x + 1)
        final innerExpr = 2.toExpression() * x + ex(1);
        final lnExpr = Ln(innerExpr);

        expect(lnExpr, isA<Expression>());

        // Test evaluation
        final result = lnExpr.evaluate({'x': 2});
        expect(result, isA<num>());
      });

      test('should handle power expressions with enhanced literals', () {
        // Create expression: (x + 1)^3
        final base = x + 1.toExpression();
        final power = base ^ ex(3);

        expect(power, isA<Expression>());

        // Test evaluation at x=2: (2+1)^3 = 27
        final result = power.evaluate({'x': 2});
        expect(result, closeTo(27, 0.001));
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
    });
  });
}
