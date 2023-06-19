import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Volume', () {
    test('constructors', () {
      var q = Volume();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Volume.volumeDimensions);
      expect(q.preferredUnits, Volume.cubicMeters);
      expect(q.relativeUncertainty, 0);

      q = Volume(m3: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Volume.volumeDimensions);
      expect(q.preferredUnits, Volume.cubicMeters);
      expect(q.relativeUncertainty, 0.001);

      q = Volume(L: 1);
      expect(q.valueSI.toDouble(), 0.001);
      expect(q.valueSI is Double, true);
      expect(q.dimensions, Volume.volumeDimensions);
      expect(q.preferredUnits, Volume.liters);
      expect(q.relativeUncertainty, 0);
    });
  });
}
