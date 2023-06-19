import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('AmountOfSubstance', () {
    test('constructors', () {
      var q = AmountOfSubstance();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, AmountOfSubstance.amountOfSubstanceDimensions);
      expect(q.preferredUnits, AmountOfSubstance.moles);
      expect(q.relativeUncertainty, 0);

      q = AmountOfSubstance(mol: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, AmountOfSubstance.amountOfSubstanceDimensions);
      expect(q.preferredUnits, AmountOfSubstance.moles);
      expect(q.relativeUncertainty, 0.001);

      q = AmountOfSubstance(kmol: 1);
      expect(q.valueSI.toDouble(), 1000);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, AmountOfSubstance.amountOfSubstanceDimensions);
      expect(q.preferredUnits, AmountOfSubstance.kilomoles);
      expect(q.relativeUncertainty, 0);
    });
  });
}
