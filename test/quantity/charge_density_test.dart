import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('ChargeDensity', () {
    test('constructors', () {
      var q = ChargeDensity();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, ChargeDensity.electricChargeDensityDimensions);
      expect(q.preferredUnits, ChargeDensity.coulombsPerCubicMeter);
      expect(q.relativeUncertainty, 0);

      q = ChargeDensity(coulombsPerCubicMeter: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, ChargeDensity.electricChargeDensityDimensions);
      expect(q.preferredUnits, ChargeDensity.coulombsPerCubicMeter);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
