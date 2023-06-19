import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('ElectricPotentialDifference', () {
    test('constructors', () {
      var q = ElectricPotentialDifference();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions,
          ElectricPotentialDifference.electricPotentialDifferenceDimensions);
      expect(q.preferredUnits, ElectricPotentialDifference.volts);
      expect(q.relativeUncertainty, 0);

      q = ElectricPotentialDifference(V: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions,
          ElectricPotentialDifference.electricPotentialDifferenceDimensions);
      expect(q.preferredUnits, ElectricPotentialDifference.volts);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
