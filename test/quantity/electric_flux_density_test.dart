import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('ElectricFluxDensity', () {
    test('constructors', () {
      var q = ElectricFluxDensity();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, ElectricFluxDensity.electricFluxDensityDimensions);
      expect(q.preferredUnits, ElectricFluxDensity.coulombsPerSquareMeter);
      expect(q.relativeUncertainty, 0);

      q = ElectricFluxDensity(coulombsPerSquareMeter: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, ElectricFluxDensity.electricFluxDensityDimensions);
      expect(q.preferredUnits, ElectricFluxDensity.coulombsPerSquareMeter);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
