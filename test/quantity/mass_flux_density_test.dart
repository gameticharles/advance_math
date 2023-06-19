import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('MassFluxDensity', () {
    test('constructors', () {
      var q = MassFluxDensity();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, MassFluxDensity.massFluxDensityDimensions);
      expect(
          q.preferredUnits, MassFluxDensity.kilogramsPerSecondPerSquareMeter);
      expect(q.relativeUncertainty, 0);

      q = MassFluxDensity(kilogramsPerSecondPerSquareMeter: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, MassFluxDensity.massFluxDensityDimensions);
      expect(
          q.preferredUnits, MassFluxDensity.kilogramsPerSecondPerSquareMeter);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
