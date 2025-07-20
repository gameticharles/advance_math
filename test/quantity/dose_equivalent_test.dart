import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('DoseEquivalent', () {
    test('constructors', () {
      var q = DoseEquivalent();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, DoseEquivalent.doseEquivalentDimensions);
      expect(q.preferredUnits, DoseEquivalent.seiverts);
      expect(q.relativeUncertainty, 0);

      q = DoseEquivalent(Sv: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, DoseEquivalent.doseEquivalentDimensions);
      expect(q.preferredUnits, DoseEquivalent.seiverts);
      expect(q.relativeUncertainty, 0.001);

      q = DoseEquivalent(rems: 1);
      expect(q.valueSI.toDouble(), 0.01);
      expect(q.valueSI is Double, true);
      expect(q.dimensions, DoseEquivalent.doseEquivalentDimensions);
      expect(q.preferredUnits, DoseEquivalent.rems);
      expect(q.relativeUncertainty, 0);
    });
  });
}
