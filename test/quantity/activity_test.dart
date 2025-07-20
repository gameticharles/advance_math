import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Activity', () {
    test('constructors', () {
      var q = Activity();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Activity.activityDimensions);
      expect(q.preferredUnits, Activity.becquerels);
      expect(q.relativeUncertainty, 0);

      q = Activity(Bq: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Activity.activityDimensions);
      expect(q.preferredUnits, Activity.becquerels);
      expect(q.relativeUncertainty, 0.001);

      q = Activity(Ci: 1);
      expect(q.valueSI.toDouble(), 3.7e10);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Activity.activityDimensions);
      expect(q.preferredUnits, Activity.curies);
      expect(q.relativeUncertainty, 0);
    });
  });
}
