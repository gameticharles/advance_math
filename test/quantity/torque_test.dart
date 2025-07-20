import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Torque', () {
    test('constructors', () {
      var q = Torque();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Torque.torqueDimensions);
      expect(q.preferredUnits, Torque.newtonMeters);
      expect(q.relativeUncertainty, 0);

      q = Torque(Nm: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Torque.torqueDimensions);
      expect(q.preferredUnits, Torque.newtonMeters);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
