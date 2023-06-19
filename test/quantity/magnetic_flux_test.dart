import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('MagneticFlux', () {
    test('constructors', () {
      var q = MagneticFlux();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, MagneticFlux.magneticFluxDimensions);
      expect(q.preferredUnits, MagneticFlux.webers);
      expect(q.relativeUncertainty, 0);

      q = MagneticFlux(Wb: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, MagneticFlux.magneticFluxDimensions);
      expect(q.preferredUnits, MagneticFlux.webers);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
