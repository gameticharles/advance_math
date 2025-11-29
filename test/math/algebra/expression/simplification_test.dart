import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  group('Simplification Tests', () {
    test('Basic Arithmetic Simplification', () {
      var expr = Add(Literal(2), Literal(3));
      expect(expr.simplify().evaluate(), equals(5));

      var expr2 = Multiply(Literal(4), Literal(5));
      expect(expr2.simplify().evaluate(), equals(20));
    });

    test('Fraction Simplification (GCD)', () {
      // 2/4 -> 1/2
      var expr = Divide(Literal(2), Literal(4));
      var simplified = expr.simplify();
      expect(simplified, isA<Divide>());
      expect((simplified as Divide).left.evaluate(), equals(1));
      expect((simplified).right.evaluate(), equals(2));

      // 10/25 -> 2/5
      var expr2 = Divide(Literal(10), Literal(25));
      var simplified2 = expr2.simplify();
      expect((simplified2 as Divide).left.evaluate(), equals(2));
      expect((simplified2).right.evaluate(), equals(5));
    });

    test('Trigonometric Simplification (Pythagorean Identity)', () {
      // sin^2(x) + cos^2(x) = 1
      var x = Variable('x');
      var sinSq = Pow(Sin(x), Literal(2));
      var cosSq = Pow(Cos(x), Literal(2));
      var expr = Add(sinSq, cosSq);

      expect(expr.simplify().evaluate(), equals(1));

      // cos^2(x) + sin^2(x) = 1
      var expr2 = Add(cosSq, sinSq);
      expect(expr2.simplify().evaluate(), equals(1));
    });

    test('Rational Simplification (Common Denominators)', () {
      // (a/c) + (b/c) = (a+b)/c
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
}
