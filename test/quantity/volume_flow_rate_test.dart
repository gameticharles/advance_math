import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('VolumeFlowRate', () {
    test('constructors', () {
      var q = VolumeFlowRate();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, VolumeFlowRate.volumeFlowRateDimensions);
      expect(q.preferredUnits, VolumeFlowRate.cubicMetersPerSecond);
      expect(q.relativeUncertainty, 0);

      q = VolumeFlowRate(cubicMetersPerSecond: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, VolumeFlowRate.volumeFlowRateDimensions);
      expect(q.preferredUnits, VolumeFlowRate.cubicMetersPerSecond);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
