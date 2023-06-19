import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('MassDensity', () {
    test('constructors', () {
      var q = MassDensity();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, MassDensity.massDensityDimensions);
      expect(q.preferredUnits, MassDensity.kilogramsPerCubicMeter);
      expect(q.relativeUncertainty, 0);

      q = MassDensity(kilogramsPerCubicMeter: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, MassDensity.massDensityDimensions);
      expect(q.preferredUnits, MassDensity.kilogramsPerCubicMeter);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
