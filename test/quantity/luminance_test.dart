import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Luminance', () {
    test('constructors', () {
      var q = Luminance();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Luminance.luminanceDimensions);
      expect(q.preferredUnits, Luminance.candelasPerSquareMeter);
      expect(q.relativeUncertainty, 0);

      q = Luminance(candelasPerSquareMeter: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Luminance.luminanceDimensions);
      expect(q.preferredUnits, Luminance.candelasPerSquareMeter);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
