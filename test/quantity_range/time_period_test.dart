import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('TimePeriod', () {
    test('constructors', () {
      final period = TimePeriod(TimeInstant.dateTime(DateTime(1999)),
          TimeInstant.dateTime(DateTime(2007, 3)));
      expect(period, isNotNull);
      expect(period.q1 == TimeInstant.dateTime(DateTime(1999)), true);
      expect(period.q2 == TimeInstant.dateTime(DateTime(2007, 3)), true);
    });

    test('operator ==', () {
      final p1 = FiscalYear(2015);
      final p2 = FiscalYear(2017);
      final p3 = FiscalYear(2015);
      expect(p1 == p2, false);
      expect(p2 == p3, false);
      expect(p1 == p3, true);
      expect(p3 == p1, true);
    });

    test('hashCode', () {
      final p1 = FiscalYear(2015);
      final p2 = FiscalYear(2017);
      final p3 = FiscalYear(2015);

      expect(p1.hashCode == p2.hashCode, false);
      expect(p2.hashCode == p3.hashCode, false);
      expect(p1.hashCode == p3.hashCode, true);
    });
  });
}
