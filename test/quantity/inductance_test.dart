import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Inductance', () {
    test('constructors', () {
      var q = Inductance();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Inductance.inductanceDimensions);
      expect(q.preferredUnits, Inductance.henries);
      expect(q.relativeUncertainty, 0);

      q = Inductance(H: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Inductance.inductanceDimensions);
      expect(q.preferredUnits, Inductance.henries);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
