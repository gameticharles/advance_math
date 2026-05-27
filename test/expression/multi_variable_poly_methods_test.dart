import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';
// MultiVariablePolynomial and Term are available via advance_math.dart (or expression.dart)

void main() {
  group('MultiVariablePolynomial Methods', () {
    test('depth() returns 1', () {
      final poly = MultiVariablePolynomial.fromString("2x + 3y");
      expect(poly.depth(), 1);
    });

    test('size() returns number of terms', () {
      final poly = MultiVariablePolynomial.fromString("2x + 3y + 4z");
      expect(poly.size(), 3);
    });

    test('getVariableTerms() returns unique variables', () {
      final poly = MultiVariablePolynomial.fromString("2x^2 + 3xy + 4y");
      final vars = poly.getVariableTerms();
      expect(vars.map((v) => v.toString()).toSet(), {'x', 'y'});
    });

    test('simplify() combines like terms', () {
      final t1 = Term(2, {'x': 1});
      final t2 = Term(3, {'x': 1});
      final t3 = Term(4, {'y': 1});
      final poly = MultiVariablePolynomial([t1, t2, t3]);
      final simplified = poly.simplify() as MultiVariablePolynomial;

      expect(simplified.terms.length, 2);
      // Check for 5x
      final xTerm = simplified.terms.firstWhere(
          (t) => t.variables.containsKey('x') && t.variables.length == 1);
      expect(xTerm.coefficient, 5);
    });

    test('differentiate() works for single variable x', () {
      final poly = MultiVariablePolynomial.fromString("3x^2 + 2x + 5");
      final diff = poly.differentiate() as MultiVariablePolynomial;
      // 6x + 2
      expect(diff.toString(), contains("6x"));
      expect(diff.toString(), contains("2"));
      expect(diff.terms.length, 2);
    });

    test('differentiate() works for specified variable if unambiguous', () {
      final poly = MultiVariablePolynomial.fromString("3y^2 + 2y");
      final diff = poly.differentiate() as MultiVariablePolynomial;
      // 6y + 2
      expect(diff.toString(), contains("6y"));
    });

    test('differentiate() throws if ambiguous', () {
      final poly = MultiVariablePolynomial.fromString("x^2 + y^2");
      // Contains x, so it should default to x
      final diff = poly.differentiate() as MultiVariablePolynomial;
      // 2x
      expect(diff.toString(), "2x");

      final poly2 = MultiVariablePolynomial.fromString("a^2 + b^2");
      expect(() => poly2.differentiate(), throwsArgumentError);
    });

    test('integrate() works for single variable x', () {
      final poly = MultiVariablePolynomial.fromString("3x^2");
      final integrated = poly.integrate() as MultiVariablePolynomial;
      // x^3 (represented as 1x^3 by toString)
      expect(integrated.toString(), "1x³");
    });

    test('isIndeterminate() works for univariate', () {
      final poly = MultiVariablePolynomial.fromString("x");
      expect(poly.isIndeterminate(double.nan), isTrue);
      expect(poly.isIndeterminate(1), isFalse);
    });

    test('isIndeterminate() throws for multivariate', () {
      final poly = MultiVariablePolynomial.fromString("x + y");
      expect(() => poly.isIndeterminate(1), throwsArgumentError);
    });

    test('isInfinity() works for univariate', () {
      final poly = MultiVariablePolynomial.fromString("x");
      expect(poly.isInfinity(double.infinity), isTrue);
      expect(poly.isInfinity(1), isFalse);
    });
  });
}
