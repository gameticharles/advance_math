import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('EnergyFlux', () {
    test('constructors', () {
      var q = EnergyFlux();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, EnergyFlux.energyFluxDimensions);
      expect(q.preferredUnits, EnergyFlux.wattsPerSquareMeter);
      expect(q.relativeUncertainty, 0);

      q = EnergyFlux(wattsPerSquareMeter: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, EnergyFlux.energyFluxDimensions);
      expect(q.preferredUnits, EnergyFlux.wattsPerSquareMeter);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
