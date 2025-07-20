import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('SpecificEnergy', () {
    test('constructors', () {
      var q = SpecificEnergy();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, SpecificEnergy.specificEnergyDimensions);
      expect(q.preferredUnits, SpecificEnergy.joulesPerKilogram);
      expect(q.relativeUncertainty, 0);

      q = SpecificEnergy(joulesPerKilogram: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, SpecificEnergy.specificEnergyDimensions);
      expect(q.preferredUnits, SpecificEnergy.joulesPerKilogram);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
