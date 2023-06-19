import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Capacitance', () {
    test('constructors', () {
      var q = Capacitance();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Capacitance.electricCapacitanceDimensions);
      expect(q.preferredUnits, Capacitance.farads);
      expect(q.relativeUncertainty, 0);

      q = Capacitance(F: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Capacitance.electricCapacitanceDimensions);
      expect(q.preferredUnits, Capacitance.farads);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
