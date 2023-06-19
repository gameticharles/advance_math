import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('CurrentDensity', () {
    test('constructors', () {
      var q = CurrentDensity();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, CurrentDensity.electricCurrentDensityDimensions);
      expect(q.preferredUnits, CurrentDensity.amperesPerSquareMeter);
      expect(q.relativeUncertainty, 0);

      q = CurrentDensity(amperesPerSquareMeter: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, CurrentDensity.electricCurrentDensityDimensions);
      expect(q.preferredUnits, CurrentDensity.amperesPerSquareMeter);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
