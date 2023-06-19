import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('TimeInstant', () {
    test('constructors', () {
      var q = TimeInstant();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, TimeInstant.timeInstantDimensions);
      expect(q.preferredUnits, TimeInstant.TAI);
      expect(q.relativeUncertainty, 0);

      q = TimeInstant(TAI: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, TimeInstant.timeInstantDimensions);
      expect(q.preferredUnits, TimeInstant.TAI);
      expect(q.relativeUncertainty, 0.001);

      q = TimeInstant(UTC: 1900000000);
      expect(q.valueSI.toDouble(), 1900000037);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, TimeInstant.timeInstantDimensions);
      expect(q.preferredUnits, TimeInstant.UTC);
      expect(q.relativeUncertainty, 0);
    });

    test('nearestDateTime', () {
      final t = TimeInstant.dateTime(DateTime(2015, 9, 23));
      final nearest = t.nearestDateTime;
      expect(nearest, isNotNull);
      expect(nearest.year, 2015);
      expect(nearest.month, 9);
      expect(nearest.day, 23);
    });

    test('FiscalYear', () {
      final fy = FiscalYear(2013);
      expect(fy, isNotNull);
      expect(fy.toString(), 'FY13');
    });

    test('CalendarYear', () {
      final cy = CalendarYear(2013);
      expect(cy, isNotNull);
      expect(cy.toString(), '2013');
    });
  });
}
