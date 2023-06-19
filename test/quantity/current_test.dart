import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Current', () {
    test('constructors', () {
      var q = Current();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Current.electricCurrentDimensions);
      expect(q.preferredUnits, Current.amperes);
      expect(q.relativeUncertainty, 0);

      q = Current(A: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Current.electricCurrentDimensions);
      expect(q.preferredUnits, Current.amperes);
      expect(q.relativeUncertainty, 0.001);

      q = Current(mA: 1);
      expect(q.valueSI.toDouble(), 0.001);
      expect(q.valueSI is Double, true);
      expect(q.dimensions, Current.electricCurrentDimensions);
      expect(q.preferredUnits, Current.milliamperes);
      expect(q.relativeUncertainty, 0);
    });
  });
}
