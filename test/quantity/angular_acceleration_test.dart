import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('AngularAcceleration', () {
    test('constructors', () {
      var q = AngularAcceleration();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, AngularAcceleration.angularAccelerationDimensions);
      expect(q.preferredUnits, AngularAcceleration.radiansPerSecondSquared);
      expect(q.relativeUncertainty, 0);

      q = AngularAcceleration(radiansPerSecondSquared: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, AngularAcceleration.angularAccelerationDimensions);
      expect(q.preferredUnits, AngularAcceleration.radiansPerSecondSquared);
      expect(q.relativeUncertainty, 0.001);

      q = AngularAcceleration(degreesPerSecondSquared: 1);
      expect(q.valueSI.toDouble(), 0.017453292519943);
      expect(q.valueSI is Double, true);
      expect(q.dimensions, AngularAcceleration.angularAccelerationDimensions);
      expect(q.preferredUnits, AngularAcceleration.degreesPerSecondSquared);
      expect(q.relativeUncertainty, 0);
    });
  });
}
