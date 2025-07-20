import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('HeatFluxDensity', () {
    test('constructors', () {
      var q = HeatFluxDensity();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, HeatFluxDensity.heatFluxDensityDimensions);
      expect(q.preferredUnits, HeatFluxDensity.wattsPerSquareMeter);
      expect(q.relativeUncertainty, 0);

      q = HeatFluxDensity(wattsPerSquareMeter: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, HeatFluxDensity.heatFluxDensityDimensions);
      expect(q.preferredUnits, HeatFluxDensity.wattsPerSquareMeter);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
