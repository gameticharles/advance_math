import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('AbsorbedDoseRate', () {
    test('constructors', () {
      var q = AbsorbedDoseRate();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, AbsorbedDoseRate.absorbedDoseRateDimensions);
      expect(q.preferredUnits, AbsorbedDoseRate.graysPerSecond);
      expect(q.relativeUncertainty, 0);

      q = AbsorbedDoseRate(graysPerSecond: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, AbsorbedDoseRate.absorbedDoseRateDimensions);
      expect(q.preferredUnits, AbsorbedDoseRate.graysPerSecond);
      expect(q.relativeUncertainty, 0.001);

      q = AbsorbedDoseRate(radsPerSecond: 1);
      expect(q.valueSI.toDouble(), 0.01);
      expect(q.valueSI is Double, true);
      expect(q.dimensions, AbsorbedDoseRate.absorbedDoseRateDimensions);
      expect(q.preferredUnits, AbsorbedDoseRate.radsPerSecond);
      expect(q.relativeUncertainty, 0);
    });
  });
}
