import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Speed', () {
    test('constructors', () {
      var q = Speed();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Speed.speedDimensions);
      expect(q.preferredUnits, Speed.metersPerSecond);
      expect(q.relativeUncertainty, 0);

      q = Speed(metersPerSecond: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Speed.speedDimensions);
      expect(q.preferredUnits, Speed.metersPerSecond);
      expect(q.relativeUncertainty, 0.001);

      q = Speed(knots: 1);
      expect(q.valueSI.toDouble(), 5.144444444e-1);
      expect(q.valueSI is Double, true);
      expect(q.dimensions, Speed.speedDimensions);
      expect(q.preferredUnits, Speed.knots);
      expect(q.relativeUncertainty, 0);
    });
  });
}
