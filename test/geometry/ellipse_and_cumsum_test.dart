import 'package:advance_math/advance_math.dart';
import 'package:test/test.dart';

void main() {
  group('Phase 2 Enhancements Tests', () {
    group('Iterable.cumsum() Tests', () {
      test('Standard integer cumsum', () {
        final list = [1, 2, 3, 4];
        final result = list.cumsum().toList();
        expect(result, equals([1, 3, 6, 10]));
      });

      test('Standard double and negative cumsum', () {
        final list = [1.5, -0.5, 2.0, -3.0];
        final result = list.cumsum().toList();
        expect(result, equals([1.5, 1.0, 3.0, 0.0]));
      });

      test('Empty iterable cumsum', () {
        final list = <num>[];
        final result = list.cumsum().toList();
        expect(result, isEmpty);
      });

      test('Complex cumsum promotion', () {
        final list = [1, Complex(2, 3), 4];
        final result = list.cumsum().toList();
        expect(result[0], equals(Complex(1, 0)));
        expect(result[1], equals(Complex(3, 3)));
        expect(result[2], equals(Complex(7, 3)));
      });

      test('Complex simplify utility', () {
        final c1 = Complex(5, 0);
        final c2 = Complex(5, 2);
        expect(c1.simplify(), equals(5));
        expect(c2.simplify(), isA<Complex>());
      });
    });

    group('Ellipse.from Solver Tests', () {
      test('Create from semiMajorAxis and semiMinorAxis', () {
        final ellipse = Ellipse.from(semiMajorAxis: 5, semiMinorAxis: 3);
        expect(ellipse.semiMajorAxis, equals(5));
        expect(ellipse.semiMinorAxis, equals(3));
      });

      test('Create from radiusX and radiusY', () {
        final ellipse = Ellipse.from(radiusX: 3, radiusY: 5);
        expect(ellipse.semiMajorAxis, equals(5));
        expect(ellipse.semiMinorAxis, equals(3));
      });

      test('Create from focusDistance and sumOfDistances', () {
        // sumOfDistances = 2a = 10 -> a = 5
        // focusDistance = c = 4
        // b = sqrt(5*5 - 4*4) = 3
        final ellipse = Ellipse.from(focusDistance: 4, sumOfDistances: 10);
        expect(ellipse.semiMajorAxis, equals(5));
        expect(ellipse.semiMinorAxis, equals(3));
      });

      test('Create from area and one axis', () {
        // Area = pi * a * b = 15 * pi
        // semiMajorAxis = 5 -> b = 3
        final ellipse = Ellipse.from(area: 15 * pi, semiMajorAxis: 5);
        expect(ellipse.semiMajorAxis, equals(5));
        expect(ellipse.semiMinorAxis, closeTo(3, 1e-9));
      });

      test('Create from area only (assumes circle)', () {
        // Area = pi * a * a = 25 * pi -> a = 5, b = 5
        final ellipse = Ellipse.from(area: 25 * pi);
        expect(ellipse.semiMajorAxis, closeTo(5, 1e-9));
        expect(ellipse.semiMinorAxis, closeTo(5, 1e-9));
      });

      test('Create from perimeter and semiMajorAxis', () {
        // Let's create an ellipse with a=5, b=3, get its perimeter, and solve it back!
        final original = Ellipse(5, 3);
        final p = original.perimeter();

        final solved = Ellipse.from(perimeter: p, semiMajorAxis: 5);
        expect(solved.semiMajorAxis, equals(5));
        expect(solved.semiMinorAxis, closeTo(3, 1e-5));
      });

      test('Create from perimeter and semiMinorAxis', () {
        final original = Ellipse(5, 3);
        final p = original.perimeter();

        final solved = Ellipse.from(perimeter: p, semiMinorAxis: 3);
        expect(solved.semiMinorAxis, equals(3));
        expect(solved.semiMajorAxis, closeTo(5, 1e-5));
      });

      test('Create from perimeter only (assumes circle)', () {
        // P = 2 * pi * r = 10 * pi -> r = 5
        final ellipse = Ellipse.from(perimeter: 10 * pi);
        expect(ellipse.semiMajorAxis, closeTo(5, 1e-9));
        expect(ellipse.semiMinorAxis, closeTo(5, 1e-9));
      });
    });
  });
}
