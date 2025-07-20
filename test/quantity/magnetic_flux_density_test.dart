import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('MagneticFluxDensity', () {
    test('constructors', () {
      var q = MagneticFluxDensity();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, MagneticFluxDensity.magneticFluxDensityDimensions);
      expect(q.preferredUnits, MagneticFluxDensity.teslas);
      expect(q.relativeUncertainty, 0);

      q = MagneticFluxDensity(T: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, MagneticFluxDensity.magneticFluxDensityDimensions);
      expect(q.preferredUnits, MagneticFluxDensity.teslas);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
