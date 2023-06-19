import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Charge', () {
    test('constructors', () {
      var q = Charge();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Charge.electricChargeDimensions);
      expect(q.preferredUnits, Charge.coulombs);
      expect(q.relativeUncertainty, 0);

      q = Charge(C: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Charge.electricChargeDimensions);
      expect(q.preferredUnits, Charge.coulombs);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
