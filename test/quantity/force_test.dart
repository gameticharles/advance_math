import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Force', () {
    test('constructors', () {
      var q = Force();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Force.forceDimensions);
      expect(q.preferredUnits, Force.newtons);
      expect(q.relativeUncertainty, 0);

      q = Force(N: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Force.forceDimensions);
      expect(q.preferredUnits, Force.newtons);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
