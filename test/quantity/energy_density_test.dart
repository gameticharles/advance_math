import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('EnergyDensity', () {
    test('constructors', () {
      var q = EnergyDensity();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, EnergyDensity.energyDensityDimensions);
      expect(q.preferredUnits, EnergyDensity.joulesPerCubicMeter);
      expect(q.relativeUncertainty, 0);

      q = EnergyDensity(joulesPerCubicMeter: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, EnergyDensity.energyDensityDimensions);
      expect(q.preferredUnits, EnergyDensity.joulesPerCubicMeter);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
