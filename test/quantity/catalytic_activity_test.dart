import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('CatalyticActivity', () {
    test('constructors', () {
      var q = CatalyticActivity();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, CatalyticActivity.catalyticActivityDimensions);
      expect(q.preferredUnits, CatalyticActivity.katals);
      expect(q.relativeUncertainty, 0);

      q = CatalyticActivity(kat: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, CatalyticActivity.catalyticActivityDimensions);
      expect(q.preferredUnits, CatalyticActivity.katals);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
