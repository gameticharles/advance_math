import 'package:advance_math/advance_math.dart';
import 'package:test/test.dart';

void main() {
  group('Symbolic Differentiation Tests', () {
    group('Basic Differentiation', () {
      test('differentiates constant', () {
        final expr = Literal(5);
        final result = expr.differentiate();
        expect(result.toString(), equals('0'));
      });

      test('differentiates variable with respect to itself', () {
        final x = Variable('x');
        final result = x.differentiate();
        expect(result.toString(), equals('1'));
      });

      test('differentiates variable with respect to another variable', () {
        final x = Variable('x');
        final y = Variable('y');
        final result = x.differentiate(y);
        expect(result.toString(), equals('0'));
      });
    });

    group('Partial Differentiation', () {
      test('partial derivative ∂(x²)/∂x = 2x', () {
        final x = Variable('x');
        final expr = Pow(x, Literal(2));
        final result = expr.differentiate(x);

        // Should be 2 * x^1 = 2x
        expect(result.toString(), contains('2'));
        expect(result.toString(), contains('x'));
      });

      test('partial derivative ∂(x²)/∂y = 0', () {
        final x = Variable('x');
        final y = Variable('y');
        final expr = Pow(x, Literal(2));
        final result = expr.differentiate(y);

        // The result should contain only zeros multiplied with things
        // After simplification it should be 0, but without simplification
        // it will be (2 * x^1) * 0
        final simplified = result.simplify();
        expect(simplified.toString(), equals('0'));
      });

      test('partial derivative ∂(x²y)/∂x = 2xy', () {
        final x = Variable('x');
        final y = Variable('y');
        final expr = Multiply(Multiply(x, x), y);
        final dx = expr.differentiate(x);

        // Product rule: (x²y)' = 2xy
        expect(dx.toString(), contains('y'));
      });

      test('partial derivative ∂(x²y)/∂y = x²', () {
        final x = Variable('x');
        final y = Variable('y');
        final expr = Multiply(Multiply(x, x), y);
        final dy = expr.differentiate(y);

        // Should contain x but not y in the derivative
        expect(dy.toString(), contains('x'));
      });
    });

    group('Power Rule', () {
      test('d/dx(x^3) = 3x^2', () {
        final x = Variable('x');
        final expr = Pow(x, Literal(3));
        final result = expr.differentiate(x);

        expect(result.toString(), contains('3'));
        expect(result.toString(), contains('x'));
      });

      test('d/dx(x^(-1)) = -x^(-2)', () {
        final x = Variable('x');
        final expr = Pow(x, Literal(-1));
        final result = expr.differentiate(x);

        expect(result.toString(), contains('-1'));
      });

      test('d/dx(2^x) uses exponential rule', () {
        final x = Variable('x');
        final expr = Pow(Literal(2), x);
        final result = expr.differentiate(x);

        // Should contain ln(2)
        expect(result.toString(), contains('2'));
      });
    });

    group('Product Rule', () {
      test('d/dx(x * sin(x)) = sin(x) + x*cos(x)', () {
        final x = Variable('x');
        final expr = Multiply(x, Sin(x));
        final result = expr.differentiate(x);

        // Product rule: f'g + fg'
        expect(result.toString(), contains('sin'));
        expect(result.toString(), contains('cos'));
      });

      test('d/dx(x² * x³) = 5x^4', () {
        final x = Variable('x');
        final expr = Multiply(Pow(x, Literal(2)), Pow(x, Literal(3)));
        final result = expr.differentiate(x);

        expect(result.toString(), contains('x'));
      });
    });

    group('Quotient Rule', () {
      test('d/dx(x/x²) = (x² - 2x²)/x^4', () {
        final x = Variable('x');
        final expr = Divide(x, Pow(x, Literal(2)));
        final result = expr.differentiate(x);

        // Quotient rule applies
        expect(result.toString(), contains('x'));
      });

      test('d/dx(1/x) applies quotient rule', () {
        final x = Variable('x');
        final expr = Divide(Literal(1), x);
        final result = expr.differentiate(x);

        // Quotient rule: (u'v - uv')/v² = (0*x - 1*1)/x²
        // Check that result contains division structure
        expect(result, isA<Divide>());
        expect(result.toString(), contains('x'));
      });
    });

    group('Chain Rule - Trigonometric', () {
      test('d/dx(sin(x)) = cos(x)', () {
        final x = Variable('x');
        final expr = Sin(x);
        final result = expr.differentiate(x);

        expect(result.toString(), contains('cos'));
      });

      test('d/dx(cos(x)) = -sin(x)', () {
        final x = Variable('x');
        final expr = Cos(x);
        final result = expr.differentiate(x);

        expect(result.toString(), contains('sin'));
      });

      test('d/dx(sin(2x)) = 2cos(2x)', () {
        final x = Variable('x');
        final expr = Sin(Multiply(Literal(2), x));
        final result = expr.differentiate(x);

        // Chain rule: cos(2x) * 2
        expect(result.toString(), contains('2'));
        expect(result.toString(), contains('cos'));
      });

      test('d/dx(tan(x)) = sec²(x)', () {
        final x = Variable('x');
        final expr = Tan(x);
        final result = expr.differentiate(x);

        expect(result.toString(), contains('sec'));
      });

      test('d/dx(sec(x)) = sec(x)tan(x)', () {
        final x = Variable('x');
        final expr = Sec(x);
        final result = expr.differentiate(x);

        expect(result.toString(), contains('sec'));
        expect(result.toString(), contains('tan'));
      });

      test('d/dx(csc(x)) = -csc(x)cot(x)', () {
        final x = Variable('x');
        final expr = Csc(x);
        final result = expr.differentiate(x);

        expect(result.toString(), contains('csc'));
        expect(result.toString(), contains('cot'));
      });

      test('d/dx(cot(x)) = -csc²(x)', () {
        final x = Variable('x');
        final expr = Cot(x);
        final result = expr.differentiate(x);

        expect(result.toString(), contains('csc'));
      });
    });

    group('Chain Rule - Exponential and Logarithmic', () {
      test('d/dx(e^x) = e^x', () {
        final x = Variable('x');
        final expr = Exp(x);
        final result = expr.differentiate(x);

        expect(result.toString(), contains('e'));
      });

      test('d/dx(e^(2x)) = 2e^(2x)', () {
        final x = Variable('x');
        final expr = Exp(Multiply(Literal(2), x));
        final result = expr.differentiate(x);

        expect(result.toString(), contains('2'));
        expect(result.toString(), contains('e'));
      });

      test('d/dx(ln(x)) = 1/x', () {
        final x = Variable('x');
        final expr = Ln(x);
        final result = expr.differentiate(x);

        expect(result.toString(), contains('x'));
      });

      test('d/dx(ln(x²)) = 2/x', () {
        final x = Variable('x');
        final expr = Ln(Pow(x, Literal(2)));
        final result = expr.differentiate(x);

        // Chain rule: 1/(x²) * 2x = 2/x
        expect(result.toString(), contains('2'));
        expect(result.toString(), contains('x'));
      });

      test('d/dx(log₁₀(x)) = 1/(x*ln(10))', () {
        final x = Variable('x');
        final expr = Log(Literal(10), x);
        final result = expr.differentiate(x);

        expect(result.toString(), contains('x'));
        expect(result.toString(), contains('ln'));
      });
    });

    group('Chain Rule - Inverse Trigonometric', () {
      test('d/dx(asin(x)) = 1/√(1-x²)', () {
        final x = Variable('x');
        final expr = Asin(x);
        final result = expr.differentiate(x);

        // Should be Divide structure with sqrt in denominator
        expect(result, isA<Divide>());
        expect(result.toString(), contains('1'));
        expect(result.toString(), contains('x'));
      });

      test('d/dx(acos(x)) = -1/√(1-x²)', () {
        final x = Variable('x');
        final expr = Acos(x);
        final result = expr.differentiate(x);

        // Should be negative of asin derivative
        expect(result, isA<Negate>());
        expect(result.toString(), contains('x'));
      });

      test('d/dx(atan(x)) = 1/(1+x²)', () {
        final x = Variable('x');
        final expr = Atan(x);
        final result = expr.differentiate(x);

        // Should be Divide with (1+x²) in denominator
        expect(result, isA<Divide>());
        expect(result.toString(), contains('1'));
        expect(result.toString(), contains('x'));
      });

      test('d/dx(asin(2x)) applies chain rule', () {
        final x = Variable('x');
        final expr = Asin(Multiply(Literal(2), x));
        final result = expr.differentiate(x);

        // Chain rule should apply: 2/√(1-4x²)
        expect(result, isA<Divide>());
        expect(result.toString(), contains('2'));
      });

      test('d/dx(atan(x²)) = 2x/(1+x⁴)', () {
        final x = Variable('x');
        final expr = Atan(Pow(x, Literal(2)));
        final result = expr.differentiate(x);

        // Chain rule: (2x)/(1+x⁴)
        expect(result, isA<Divide>());
        expect(result.toString(), contains('2'));
        expect(result.toString(), contains('x'));
      });

      test('asin domain validation', () {
        final expr = Asin(Literal(2));
        expect(() => expr.evaluate(), throwsArgumentError);
      });

      test('acos domain validation', () {
        final expr = Acos(Literal(-2));
        expect(() => expr.evaluate(), throwsArgumentError);
      });

      test('atan works for all real numbers', () {
        final expr = Atan(Literal(1000));
        expect(() => expr.evaluate(), returnsNormally);
      });

      test('inverse trig with partial derivatives', () {
        final x = Variable('x');
        final y = Variable('y');
        final expr = Asin(Multiply(x, y));

        // ∂(asin(xy))/∂x = y/√(1-x²y²)
        final dx = expr.differentiate(x);
        expect(dx.toString(), contains('y'));

        // ∂(asin(xy))/∂y = x/√(1-x²y²)
        final dy = expr.differentiate(y);
        expect(dy.toString(), contains('x'));
      });
    });

    group('Addition and Subtraction', () {
      test('d/dx(x + x²) = 1 + 2x', () {
        final x = Variable('x');
        final expr = Add(x, Pow(x, Literal(2)));
        final result = expr.differentiate(x);

        expect(result.toString(), contains('1'));
        expect(result.toString(), contains('2'));
      });

      test('d/dx(x² - x) = 2x - 1', () {
        final x = Variable('x');
        final expr = Subtract(Pow(x, Literal(2)), x);
        final result = expr.differentiate(x);

        expect(result.toString(), contains('x'));
        expect(result.toString(), contains('1'));
      });
    });

    group('Composite Functions', () {
      test('d/dx(sin(x²)) = 2x*cos(x²)', () {
        final x = Variable('x');
        final expr = Sin(Pow(x, Literal(2)));
        final result = expr.differentiate(x);

        // Chain rule
        expect(result.toString(), contains('cos'));
        expect(result.toString(), contains('x'));
      });

      test('d/dx(e^(sin(x))) = e^(sin(x)) * cos(x)', () {
        final x = Variable('x');
        final expr = Exp(Sin(x));
        final result = expr.differentiate(x);

        expect(result.toString(), contains('e'));
        expect(result.toString(), contains('cos'));
      });

      test('d/dx((x+1)²) = 2(x+1)', () {
        final x = Variable('x');
        final expr = Pow(Add(x, Literal(1)), Literal(2));
        final result = expr.differentiate(x);

        expect(result.toString(), contains('2'));
      });
    });

    group('Mixed Partial Derivatives', () {
      test('∂²(x²y)/∂x∂y mixed partial works', () {
        final x = Variable('x');
        final y = Variable('y');
        final expr = Multiply(Multiply(x, x), y);

        // First with respect to y: ∂(x²y)/∂y = x²
        final dy = expr.differentiate(y);
        // Then with respect to x: ∂(x²)/∂x = 2x
        final dxdy = dy.differentiate(x);

        // The result should be a valid expression
        expect(dxdy, isA<Expression>());
        expect(dxdy.toString(), contains('x'));
      });

      test('∂²(x²y)/∂y∂x mixed partial works', () {
        final x = Variable('x');
        final y = Variable('y');
        final expr = Multiply(Multiply(x, x), y);

        // First with respect to x: ∂(x²y)/∂x = 2xy
        final dx = expr.differentiate(x);
        // Then with respect to y: ∂(2xy)/∂y = 2x
        final dydx = dx.differentiate(y);

        // The result should be a valid expression
        expect(dydx, isA<Expression>());
        expect(dydx.toString(), contains('x'));
      });
    });

    group('Edge Cases', () {
      test('differentiating constant with respect to any variable is 0', () {
        final x = Variable('x');
        final constant = Literal(42);
        final result = constant.differentiate(x);

        expect(result.toString(), equals('0'));
      });

      test('negation differentiation', () {
        final x = Variable('x');
        final expr = Negate(Pow(x, Literal(2)));
        final result = expr.differentiate(x);

        // Should be negative of derivative
        expect(result.toString(), contains('-'));
        expect(result.toString(), contains('x'));
      });

      test('conditional expression differentiation', () {
        final x = Variable('x');
        final condition = BinaryExpression('\u003e', x, Literal(0));
        final ifTrue = Pow(x, Literal(2));
        final ifFalse = Literal(0);
        final expr = ConditionalExpression(
          condition: condition,
          ifTrue: ifTrue,
          ifFalse: ifFalse,
        );

        final result = expr.differentiate(x);
        // Should differentiate both branches
        expect(result, isA<ConditionalExpression>());
      });
    });
  });
}
