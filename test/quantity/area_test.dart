import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Area', () {
    test('constructors', () {
      var q = Area();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Area.areaDimensions);
      expect(q.preferredUnits, Area.squareMeters);
      expect(q.relativeUncertainty, 0);

      q = Area(m2: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Area.areaDimensions);
      expect(q.preferredUnits, Area.squareMeters);
      expect(q.relativeUncertainty, 0.001);

      q = Area(b: 1);
      expect(q.valueSI.toDouble(), 1.0e-28);
      expect(q.valueSI is Double, true);
      expect(q.dimensions, Area.areaDimensions);
      expect(q.preferredUnits, Area.barns);
      expect(q.relativeUncertainty, 0);

      q = Area(ha: 1);
      expect(q.valueSI.toDouble(), 10000);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Area.areaDimensions);
      expect(q.preferredUnits, Area.hectares);
      expect(q.relativeUncertainty, 0);
    });
  });
}
