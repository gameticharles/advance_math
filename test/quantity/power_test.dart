import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Power', () {
    test('constructors', () {
      var q = Power();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Power.powerDimensions);
      expect(q.preferredUnits, Power.watts);
      expect(q.relativeUncertainty, 0);

      q = Power(W: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Power.powerDimensions);
      expect(q.preferredUnits, Power.watts);
      expect(q.relativeUncertainty, 0.001);

      q = Power(kW: 1);
      expect(q.valueSI.toDouble(), 1000);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Power.powerDimensions);
      expect(q.preferredUnits, Power.kilowatts);
      expect(q.relativeUncertainty, 0);

      q = Power(MW: 1);
      expect(q.valueSI.toDouble(), 1000000);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Power.powerDimensions);
      expect(q.preferredUnits, Power.megawatts);
      expect(q.relativeUncertainty, 0);
    });
  });
}
