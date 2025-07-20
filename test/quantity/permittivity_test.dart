import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Permittivity', () {
    test('constructors', () {
      var q = Permittivity();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Permittivity.permittivityDimensions);
      expect(q.preferredUnits, Permittivity.faradsPerMeter);
      expect(q.relativeUncertainty, 0);

      q = Permittivity(faradsPerMeter: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Permittivity.permittivityDimensions);
      expect(q.preferredUnits, Permittivity.faradsPerMeter);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
