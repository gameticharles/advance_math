import 'package:advance_math/advance_math.dart';
import 'package:test/test.dart';

void main() {
  group('Polynomial Tests', () {
    test('fromString method', () {
      var polynomial = Polynomial.fromString("x^2 + 2x + 1");
      expect(polynomial.toString(), equals("x² + 2x + 1"));

      polynomial =
          Polynomial.fromString("- 20x⁴ + 163x³ - 676x² + 1424x - 1209");
      expect(polynomial.toString(),
          equals("-20x⁴ + 163x³ - 676x² + 1424x - 1209"));

      polynomial = Polynomial.fromString("-1 + 2x + x^4");
      expect(polynomial.toString(), equals("x⁴ + 2x - 1"));

      polynomial = Polynomial.fromString("x + 1");
      expect(polynomial.toString(), equals("x + 1"));
    });

    test('fromList method', () {
      var polynomial = Polynomial.fromList([1, 2, 1]);
      expect(polynomial.toString(), equals("x² + 2x + 1"));
    });

    test('addition operation', () {
      var p1 = Polynomial.fromList([1, 2, 1]);
      var p2 = Polynomial.fromList([1, 2, 3]);
      var result = p1 + p2;
      expect(result.toString(), equals("2x² + 4x + 4"));
    });

    test('subtraction operation', () {
      var p1 = Polynomial.fromList([1, 2, 1]);
      var p2 = Polynomial.fromList([1, 2, 3]);
      var result = p1 - p2;
      expect(result.toString(), equals("-2"));
    });

    test('multiplication operation', () {
      var p1 = Polynomial.fromList([1, 2]);
      var p2 = Polynomial.fromList([1, 2]);
      var result = p1 * p2;
      expect(result.toString(), equals("x² + 4x + 4"));
    });

    test('differentiate method', () {
      var polynomial = Polynomial.fromList([1, 2, 1]);
      var result = polynomial.differentiate();
      expect(result.toString(), equals("2x + 2"));
    });

    test('integrate method', () {
      var polynomial = Polynomial.fromList([1, 2, 1]);
      var result = polynomial.integrate();
      expect(result.toString(), equals("0.3333333333333333x³ + x² + x"));
    });

    test('roots method', () {
      // Depending on the implementation of the roots() method
      var polynomial = Polynomial.fromList([1, 2, 1]);
      var roots = polynomial.roots();
      // Assuming the roots method returns the roots as a list of numbers
      // As the roots for x^2 + 2x + 1 are -1 and -1
      expect(roots.toString(), equals('[-1, -1]'));
    });
  });
}
