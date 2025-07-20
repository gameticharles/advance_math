import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('AbsorbedDose', () {
    test('constructors', () {
      var q = AbsorbedDose();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, AbsorbedDose.absorbedDoseDimensions);
      expect(q.preferredUnits, AbsorbedDose.grays);
      expect(q.relativeUncertainty, 0);

      q = AbsorbedDose(Gy: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, AbsorbedDose.absorbedDoseDimensions);
      expect(q.preferredUnits, AbsorbedDose.grays);
      expect(q.relativeUncertainty, 0.001);

      q = AbsorbedDose(rads: 1);
      expect(q.valueSI.toDouble(), 0.01);
      expect(q.valueSI is Double, true);
      expect(q.dimensions, AbsorbedDose.absorbedDoseDimensions);
      expect(q.preferredUnits, AbsorbedDose.rads);
      expect(q.relativeUncertainty, 0);
    });
  });
}
