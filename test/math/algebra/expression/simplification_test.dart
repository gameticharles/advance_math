import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';
import 'dart:math' as dmath;

void main() {
  // ==========================================================================
  // Group 1: Basic Arithmetic Simplification
  // ==========================================================================
  group('Arithmetic Simplification', () {
    test('Literal + Literal evaluates', () {
      expect(Add(Literal(2), Literal(3)).simplify().evaluate(), equals(5));
      expect(
          Multiply(Literal(4), Literal(5)).simplify().evaluate(), equals(20));
      expect(Subtract(Literal(10), Literal(3)).simplify().evaluate(), equals(7));
    });

    test('Identity: x + 0 = x', () {
      var x = Variable('x');
      var expr = Add(x, Literal(0));
      expect(expr.simplify().toString(), equals('x'));
    });

    test('Identity: 0 + x = x', () {
      var x = Variable('x');
      var expr = Add(Literal(0), x);
      expect(expr.simplify().toString(), equals('x'));
    });

    test('Identity: x - 0 = x', () {
      var x = Variable('x');
      var expr = Subtract(x, Literal(0));
      expect(expr.simplify().toString(), equals('x'));
    });

    test('Self-subtraction: x - x = 0', () {
      var x = Variable('x');
      var expr = Subtract(x, x);
      expect(expr.simplify().evaluate(), equals(0));
    });

    test('Zero product: x * 0 = 0', () {
      var x = Variable('x');
      var expr = Multiply(x, Literal(0));
      expect(expr.simplify().evaluate(), equals(0));
    });

    test('Multiplicative identity: x * 1 = x', () {
      var x = Variable('x');
      var expr = Multiply(x, Literal(1));
      expect(expr.simplify().toString(), equals('x'));
    });

    test('Multiplicative identity: 1 * x = x', () {
      var x = Variable('x');
      var expr = Multiply(Literal(1), x);
      expect(expr.simplify().toString(), equals('x'));
    });
  });

  // ==========================================================================
  // Group 2: Power Simplification
  // ==========================================================================
  group('Power Simplification', () {
    test('x^0 = 1', () {
      var x = Variable('x');
      var expr = Pow(x, Literal(0));
      expect(expr.simplify().evaluate(), equals(1));
    });

    test('x^1 = x', () {
      var x = Variable('x');
      var expr = Pow(x, Literal(1));
      expect(expr.simplify().toString(), equals('x'));
    });

    test('1^x = 1', () {
      var x = Variable('x');
      var expr = Pow(Literal(1), x);
      expect(expr.simplify().evaluate(), equals(1));
    });

    test('(x^2)^3 = x^6', () {
      var x = Variable('x');
      var expr = Pow(Pow(x, Literal(2)), Literal(3));
      var simplified = expr.simplify();
      // Should be Pow(x, 6)
      expect(simplified, isA<Pow>());
      expect((simplified as Pow).exponent.evaluate(), equals(6));
    });

    test('x^a * x^b = x^(a+b)', () {
      var x = Variable('x');
      var expr = Multiply(Pow(x, Literal(2)), Pow(x, Literal(3)));
      var simplified = expr.simplify();
      expect(simplified, isA<Pow>());
      expect((simplified as Pow).exponent.evaluate(), equals(5));
    });

    test('Numeric power evaluation: 2^3 = 8', () {
      var expr = Pow(Literal(2), Literal(3));
      expect(expr.simplify().evaluate(), equals(8));
    });
  });

  // ==========================================================================
  // Group 3: Fraction Simplification
  // ==========================================================================
  group('Fraction Simplification', () {
    test('2/4 simplifies (GCD reduction)', () {
      var expr = Divide(Literal(2), Literal(4));
      var simplified = expr.simplify();
      // The simplifier should reduce 2/4 to 1/2 (as Rational or 0.5)
      var val = simplified.evaluate();
      expect(val, equals(0.5));
    });

    test('10/25 = 2/5', () {
      var expr = Divide(Literal(10), Literal(25));
      var simplified = expr.simplify();
      var val = simplified.evaluate();
      expect(val, equals(0.4));
    });

    test('6/3 = 2', () {
      var expr = Divide(Literal(6), Literal(3));
      var simplified = expr.simplify();
      expect(simplified.evaluate(), equals(2));
    });

    test('x / x = 1', () {
      var x = Variable('x');
      var expr = Divide(x, x);
      expect(expr.simplify().evaluate(), equals(1));
    });

    test('x / 1 = x', () {
      var x = Variable('x');
      var expr = Divide(x, Literal(1));
      expect(expr.simplify().toString(), equals('x'));
    });

    test('0 / x = 0', () {
      var x = Variable('x');
      var expr = Divide(Literal(0), x);
      expect(expr.simplify().evaluate(), equals(0));
    });
  });

  // ==========================================================================
  // Group 4: Logarithm Simplification
  // ==========================================================================
  group('Logarithm Simplification', () {
    test('ln(1) = 0', () {
      var expr = Ln(Literal(1));
      expect(expr.simplify().evaluate(), equals(0));
    });

    test('ln(e) = 1', () {
      var expr = Ln(Literal(dmath.e));
      expect(expr.simplify().evaluate(), closeTo(1.0, 1e-10));
    });

    test('ln(Exp(x)) = x', () {
      var x = Variable('x');
      var expr = Ln(Exp(x));
      var simplified = expr.simplify();
      expect(simplified.toString(), equals('x'));
    });

    test('log_a(1) = 0', () {
      var expr = Log(Literal(10), Literal(1));
      expect(expr.simplify().evaluate(), equals(0));
    });

    test('log_a(a) = 1', () {
      var expr = Log(Literal(10), Literal(10));
      expect(expr.simplify().evaluate(), closeTo(1.0, 1e-10));
    });
  });

  // ==========================================================================
  // Group 5: Exponential Simplification
  // ==========================================================================
  group('Exponential Simplification', () {
    test('e^0 = 1', () {
      var expr = Exp(Literal(0));
      expect(expr.simplify().evaluate(), equals(1));
    });

    test('e^1 = e', () {
      var expr = Exp(Literal(1));
      expect(expr.simplify().evaluate(), closeTo(dmath.e, 1e-10));
    });

    test('e^ln(x) = x', () {
      var x = Variable('x');
      var expr = Exp(Ln(x));
      var simplified = expr.simplify();
      expect(simplified.toString(), equals('x'));
    });
  });

  // ==========================================================================
  // Group 6: Trigonometric Simplification
  // ==========================================================================
  group('Trigonometric Simplification', () {
    test('sin²(x) + cos²(x) = 1 (Pythagorean Identity)', () {
      var x = Variable('x');
      var sinSq = Pow(Sin(x), Literal(2));
      var cosSq = Pow(Cos(x), Literal(2));
      var expr = Add(sinSq, cosSq);
      expect(expr.simplify().evaluate(), equals(1));
    });

    test('cos²(x) + sin²(x) = 1 (reversed order)', () {
      var x = Variable('x');
      var sinSq = Pow(Sin(x), Literal(2));
      var cosSq = Pow(Cos(x), Literal(2));
      var expr = Add(cosSq, sinSq);
      expect(expr.simplify().evaluate(), equals(1));
    });

    test('sin(0) = 0', () {
      var expr = Sin(Literal(0));
      expect(expr.simplify().evaluate(), equals(0));
    });

    test('cos(0) = 1', () {
      var expr = Cos(Literal(0));
      expect(expr.simplify().evaluate(), equals(1));
    });

    test('tan(0) = 0', () {
      var expr = Tan(Literal(0));
      expect(expr.simplify().evaluate(), equals(0));
    });
  });

  // ==========================================================================
  // Group 7: Rational Expression Simplification
  // ==========================================================================
  group('Rational Expression Simplification', () {
    test('(a/c) + (b/c) = (a+b)/c — same denominator', () {
      var a = Variable('a');
      var b = Variable('b');
      var c = Variable('c');

      var term1 = Divide(a, c);
      var term2 = Divide(b, c);
      var expr = Add(term1, term2);

      var simplified = expr.simplify();
      expect(simplified, isA<Divide>());
      expect((simplified as Divide).right.toString(), equals(c.toString()));
      expect((simplified).left, isA<Add>());
    });
  });

  // ==========================================================================
  // Group 8: Nested / Complex Simplification
  // ==========================================================================
  group('Nested and Complex Simplification', () {
    test('Deeply nested addition simplifies', () {
      // ((2 + 3) + 4) + 5 = 14
      var expr =
          Add(Add(Add(Literal(2), Literal(3)), Literal(4)), Literal(5));
      expect(expr.simplify().evaluate(), equals(14));
    });

    test('Mixed operations simplify', () {
      // 2 * (3 + 4) = 14
      var expr = Multiply(Literal(2), Add(Literal(3), Literal(4)));
      expect(expr.simplify().evaluate(), equals(14));
    });

    test('Like terms: x + x = 2*x', () {
      var x = Variable('x');
      var expr = Add(x, x);
      var simplified = expr.simplify();
      // Should be 2*x
      expect(simplified, isA<Multiply>());
      expect(simplified.toString(), equals('2*x'));
    });

    test('Like terms: 3*x + 2*x = 5*x', () {
      var x = Variable('x');
      var expr = Add(Multiply(Literal(3), x), Multiply(Literal(2), x));
      var simplified = expr.simplify();
      expect(simplified.toString(), equals('5*x'));
    });
  });

  // ==========================================================================
  // Group 9: Edge Cases
  // ==========================================================================
  group('Edge Cases', () {
    test('Division by zero throws', () {
      var expr = Divide(Literal(1), Literal(0));
      expect(() => expr.simplify(), throwsA(isA<Exception>()));
    });

    test('Deeply nested expressions converge without infinite loop', () {
      // x + 0 + 0 + 0 + 0 = x
      var x = Variable('x');
      Expression expr = x;
      for (int i = 0; i < 50; i++) {
        expr = Add(expr, Literal(0));
      }
      expect(expr.simplify().toString(), equals('x'));
    });

    test('Negate simplification: -(-x) = x', () {
      var x = Variable('x');
      var expr = Negate(Negate(x));
      var simplified = expr.simplify();
      expect(simplified.toString(), equals('x'));
    });

    test('Expression.parse simplification round-trip', () {
      var expr = Expression.parse('2 + 3');
      expect(expr.simplify().evaluate(), equals(5));
    });
  });
}
