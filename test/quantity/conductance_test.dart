import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Conductance', () {
    test('constructors', () {
      var q = Conductance();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Conductance.electricConductanceDimensions);
      expect(q.preferredUnits, Conductance.siemens);
      expect(q.relativeUncertainty, 0);

      q = Conductance(S: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Conductance.electricConductanceDimensions);
      expect(q.preferredUnits, Conductance.siemens);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
