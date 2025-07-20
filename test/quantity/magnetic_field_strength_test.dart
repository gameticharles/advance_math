import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('MagneticFieldStrength', () {
    test('constructors', () {
      var q = MagneticFieldStrength();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(
          q.dimensions, MagneticFieldStrength.magneticFieldStrengthDimensions);
      expect(q.preferredUnits, MagneticFieldStrength.amperesPerMeter);
      expect(q.relativeUncertainty, 0);

      q = MagneticFieldStrength(amperesPerMeter: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(
          q.dimensions, MagneticFieldStrength.magneticFieldStrengthDimensions);
      expect(q.preferredUnits, MagneticFieldStrength.amperesPerMeter);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
