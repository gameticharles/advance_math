import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Pressure', () {
    test('constructors', () {
      var q = Pressure();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Pressure.pressureDimensions);
      expect(q.preferredUnits, Pressure.pascals);
      expect(q.relativeUncertainty, 0);

      q = Pressure(Pa: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Pressure.pressureDimensions);
      expect(q.preferredUnits, Pressure.pascals);
      expect(q.relativeUncertainty, 0.001);

      q = Pressure(bars: 1);
      expect(q.valueSI.toDouble(), 100000);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Pressure.pressureDimensions);
      expect(q.preferredUnits, Pressure.bars);
      expect(q.relativeUncertainty, 0);
    });
  });
}
