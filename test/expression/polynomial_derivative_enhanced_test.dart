import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  group('Polynomial Operations with Enhanced Expression Creation', () {
    late Variable x, y, z;

    setUp(() {
      x = Variable('x');
      y = Variable('y');
      z = Variable('z');
    });

    group('Polynomial Creation Tests', () {
      test('should create polynomial using toExpression() method', () {
        // Create polynomial: 2x^2 + 3x + 1
        final poly = Polynomial([
          2.toExpression(),
          3.toExpression(),
          1.toExpression()
        ].map((e) => (e as Literal).value).toList());

        expect(poly.coefficients.length, equals(3));
        expect(poly.degree, equals(2));

        // Test evaluation
        final result = poly.evaluate(2);
        expect(result.real, closeTo(15, 0.001)); // 2*4 + 3*2 + 1 = 15
      });

      test('should create polynomial using ex() helper function', () {
        // Create polynomial: 3x^3 - 2x^2 + 4x - 1
        final poly = Polynomial([
          (ex(3) as Literal).value,
          (ex(-2) as Literal).value,
          (ex(4) as Literal).value,
          (ex(-1) as Literal).value
        ]);

        expect(poly.coefficients.length, equals(4));
        expect(poly.degree, equals(3));

        // Test evaluation at x = 1
        final result = poly.evaluate(1);
        expect(result.real, closeTo(4, 0.001)); // 3 - 2 + 4 - 1 = 4
      });

      test('should create polynomial using explicit Literal objects', () {
        // Create polynomial: x^2 - 5x + 6
        final poly =
            Polynomial([Literal(1).value, Literal(-5).value, Literal(6).value]);

        expect(poly.coefficients.length, equals(3));
        expect(poly.degree, equals(2));

        // Test evaluation at x = 2
        final result = poly.evaluate(2);
        expect(result.real, closeTo(0, 0.001)); // 4 - 10 + 6 = 0
      });

      test('should create polynomial with mixed creation approaches', () {
        // Mix different approaches in coefficient creation
        final poly = Polynomial([
          2.toExpression().evaluate(), // toExpression approach
          (ex(-3) as Literal).value, // ex() helper approach
          Literal(1).value // explicit Literal approach
        ]);

        expect(poly.coefficients.length, equals(3));
        expect(poly.degree, equals(2));

        // Test evaluation at x = 3
        final result = poly.evaluate(3);
        expect(
            result.real, closeTo(10, 0.001)); // 2*9 - 3*3 + 1 = 18 - 9 + 1 = 10
      });
    });

    group('Polynomial Expression Operations', () {
      test(
          'should perform arithmetic with polynomials created using enhanced methods',
          () {
        // Create two polynomials using different methods
        final poly1 = Polynomial(
            [2.toExpression().evaluate(), (-1).toExpression().evaluate()]);

        final poly2 =
            Polynomial([(ex(1) as Literal).value, (ex(3) as Literal).value]);

        // Test addition
        final sum = poly1 + poly2;
        expect(sum, isA<Polynomial>());
        final sumPoly = sum as Polynomial;
        expect(sumPoly.coefficients.length, equals(2));

        // Test multiplication
        final product = poly1 * poly2;
        expect(product, isA<Polynomial>());
        final productPoly = product as Polynomial;
        expect(productPoly.coefficients.length, equals(3));
      });

      test(
          'should create complex polynomial expressions with enhanced literals',
          () {
        // Create expression: (2x + 1) * (x - 3) using enhanced methods
        final expr1 = 2.toExpression() * x + 1.toExpression();
        final expr2 = x - ex(3);
        final product = expr1 * expr2;

        expect(product, isA<Expression>());

        // Evaluate at x = 2
        final result = product.evaluate({'x': 2});
        expect(
            result, closeTo(-5, 0.001)); // (2*2 + 1) * (2 - 3) = 5 * (-1) = -5
      });
    });

    group('Differentiation Tests with Enhanced Expression Creation', () {
      test('should differentiate polynomial created with toExpression()', () {
        // Create polynomial: 3x^2 + 2x + 1
        final poly = Polynomial([
          3.toExpression().evaluate(),
          2.toExpression().evaluate(),
          1.toExpression().evaluate()
        ]);

        final derivative = poly.differentiate() as Polynomial;
        expect(derivative, isA<Polynomial>());

        // Derivative should be: 6x + 2
        expect(derivative.coefficients.length, equals(2));

        // Test evaluation of derivative at x = 1
        final result = derivative.evaluate(1);
        expect(result.real, closeTo(8, 0.001)); // 6*1 + 2 = 8
      });

      test('should differentiate polynomial created with ex() helper', () {
        // Create polynomial: 4x^3 - 3x^2 + 2x - 1
        final poly = Polynomial([
          (ex(4) as Literal).value,
          (ex(-3) as Literal).value,
          (ex(2) as Literal).value,
          (ex(-1) as Literal).value
        ]);

        final derivative = poly.differentiate() as Polynomial;
        expect(derivative, isA<Polynomial>());

        // Derivative should be: 12x^2 - 6x + 2
        expect(derivative.coefficients.length, equals(3));

        // Test evaluation of derivative at x = 2
        final result = derivative.evaluate(2);
        expect(result.real,
            closeTo(38, 0.001)); // 12*4 - 6*2 + 2 = 48 - 12 + 2 = 38
      });

      test(
          'should differentiate expressions with mixed literal creation methods',
          () {
        // Create expression: 2x^3 + 3x^2 - 4x + 5
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

      test('should handle chain rule differentiation with enhanced literals',
          () {
        // Create expression: sin(2x + 1)
        final innerExpr = 2.toExpression() * x + ex(1);
        final sinExpr = Sin(innerExpr);

        final derivative = sinExpr.differentiate();
        expect(derivative, isA<Expression>());

        // Test evaluation
        final result = derivative.evaluate({'x': 0});
        expect(result, isA<num>());
      });
    });

    group('Integration Tests with Enhanced Expression Creation', () {
      test('should integrate polynomial created with toExpression()', () {
        // Create polynomial: 2x + 3
        final poly = Polynomial(
            [2.toExpression().evaluate(), 3.toExpression().evaluate()]);

        final integral = poly.integrate();
        expect(integral, isA<Expression>());

        // Integral should be: x^2 + 3x + C
        // The integration method adds coefficients at beginning and end
        if (integral is Polynomial) {
          expect(integral.coefficients.length, equals(4));
        }
      });

      test('should integrate polynomial created with ex() helper', () {
        // Create polynomial: 3x^2 - 2x + 1
        final poly = Polynomial([
          (ex(3) as Literal).value,
          (ex(-2) as Literal).value,
          (ex(1) as Literal).value
        ]);

        final integral = poly.integrate();
        expect(integral, isA<Expression>());

        // Integral should be: x^3 - x^2 + x + C
        // The integration method adds coefficients at beginning and end
        if (integral is Polynomial) {
          expect(integral.coefficients.length, equals(5));
        }
      });

      test('should integrate expressions with mixed literal creation methods',
          () {
        // Create expression: x^2 + 2x + 1
        final expr = (x ^ 2.toExpression()) + ex(2) * x + Literal(1);

        final integral = expr.integrate();
        expect(integral, isA<Expression>());

        // Test that integral can be evaluated
        final result = integral.evaluate({'x': 2});
        expect(result, isA<num>());
      });
    });

    group('Multivariate Expression Tests', () {
      test('should create multivariate expressions with enhanced literals', () {
        // Create expression: 2xy + 3x^2 - y^2 + 5
        final expr = 2.toExpression() * x * y +
            ex(3) * (x ^ 2.toExpression()) -
            (y ^ 2.toExpression()) +
            Literal(5);

        expect(expr, isA<Expression>());

        // Test evaluation
        final result = expr.evaluate({'x': 2, 'y': 3});
        expect(result, isA<num>());
      });

      test('should handle multivariate polynomial operations', () {
        // Create two multivariate expressions
        final expr1 = x * y + 2.toExpression() * x;
        final expr2 = ex(3) * y - Literal(1);

        final sum = expr1 + expr2;
        final product = expr1 * expr2;

        expect(sum, isA<Expression>());
        expect(product, isA<Expression>());

        // Test evaluation of sum
        final sumResult = sum.evaluate({'x': 1, 'y': 2});
        expect(sumResult, isA<num>());

        // Test evaluation of product
        final productResult = product.evaluate({'x': 1, 'y': 2});
        expect(productResult, isA<num>());
      });

      test('should create three-variable expressions with enhanced literals',
          () {
        // Create expression: xyz + 2x^2y - 3xz^2 + 4
        final expr = x * y * z +
            2.toExpression() * (x ^ 2.toExpression()) * y -
            ex(3) * x * (z ^ 2.toExpression()) +
            Literal(4);

        expect(expr, isA<Expression>());

        // Test evaluation
        final result = expr.evaluate({'x': 1, 'y': 2, 'z': 3});
        expect(result, isA<num>());
      });

      test(
          'should differentiate multivariate expressions with enhanced literals',
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
    });

    group('Complex Expression Combinations', () {
      test('should handle nested expressions with enhanced literals', () {
        // Create nested expression: sin(2x + 1) * cos(3x - 2)
        final sinPart = Sin(2.toExpression() * x + ex(1));
        final cosPart = Cos(ex(3) * x - 2.toExpression());
        final product = sinPart * cosPart;

        expect(product, isA<Expression>());

        // Test evaluation
        final result = product.evaluate({'x': 0});
        expect(result, isA<num>());
      });

      test('should handle rational expressions with enhanced literals', () {
        // Create rational expression: (2x + 1) / (x - 3)
        final numerator = 2.toExpression() * x + ex(1);
        final denominator = x - 3.toExpression();
        final rational = numerator / denominator;

        expect(rational, isA<Expression>());

        // Test evaluation (avoiding x = 3 to prevent division by zero)
        final result = rational.evaluate({'x': 2});
        expect(result, isA<num>());
      });

      test('should handle power expressions with enhanced literals', () {
        // Create power expression: (x + 1)^3
        final base = x + 1.toExpression();
        final power = base ^ ex(3);

        expect(power, isA<Expression>());

        // Test evaluation
        final result = power.evaluate({'x': 2});
        expect(result, closeTo(27, 0.001)); // (2 + 1)^3 = 27
      });

      test('should handle logarithmic expressions with enhanced literals', () {
        // Create logarithmic expression: ln(2x + 1)
        final innerExpr = 2.toExpression() * x + ex(1);
        final lnExpr = Ln(innerExpr);

        expect(lnExpr, isA<Expression>());

        // Test evaluation
        final result = lnExpr.evaluate({'x': 2});
        expect(result, isA<num>());
      });
    });

    group('Performance and Equivalence Tests', () {
      test('should produce equivalent results across all creation methods', () {
        final value = 5;

        // Create same polynomial using different methods
        final poly1 = Polynomial([value.toExpression().evaluate(), 1]);
        final poly2 = Polynomial([(ex(value) as Literal).value, 1]);
        final poly3 = Polynomial([Literal(value).value, 1]);

        // All should evaluate to the same result
        final testValue = 2;
        final result1 = poly1.evaluate(testValue);
        final result2 = poly2.evaluate(testValue);
        final result3 = poly3.evaluate(testValue);

        expect(result1.real, closeTo(result2.real, 0.001));
        expect(result2.real, closeTo(result3.real, 0.001));
        expect(result1.real, closeTo(result3.real, 0.001));
      });

      test('should handle edge cases with enhanced literals', () {
        // Test with zero coefficients
        final zeroExpr = 0.toExpression() * x + ex(0);
        expect(zeroExpr, isA<Expression>());

        final result = zeroExpr.evaluate({'x': 5});
        expect(result, equals(0));

        // Test with negative coefficients
        final negExpr = (-2).toExpression() * x + ex(-3);
        expect(negExpr, isA<Expression>());

        final negResult = negExpr.evaluate({'x': 1});
        expect(negResult, equals(-5));

        // Test with decimal coefficients
        final decimalExpr = 2.5.toExpression() * x + ex(1.5);
        expect(decimalExpr, isA<Expression>());

        final decimalResult = decimalExpr.evaluate({'x': 2});
        expect(decimalResult, closeTo(6.5, 0.001));
      });
    });
  });
}
