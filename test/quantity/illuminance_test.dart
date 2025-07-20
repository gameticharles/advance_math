import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Illuminance', () {
    test('constructors', () {
      var q = Illuminance();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Illuminance.illuminanceDimensions);
      expect(q.preferredUnits, Illuminance.lux);
      expect(q.relativeUncertainty, 0);

      q = Illuminance(lux: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Illuminance.illuminanceDimensions);
      expect(q.preferredUnits, Illuminance.lux);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
