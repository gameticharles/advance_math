import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Resistance', () {
    test('constructors', () {
      var q = Resistance();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Resistance.electricResistanceDimensions);
      expect(q.preferredUnits, Resistance.ohms);
      expect(q.relativeUncertainty, 0);

      q = Resistance(ohms: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Resistance.electricResistanceDimensions);
      expect(q.preferredUnits, Resistance.ohms);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
