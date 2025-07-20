import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Currency', () {
    test('constructors', () {
      var q = Currency();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Currency.currencyDimensions);
      expect(q.preferredUnits, Currency.dollarsUS);
      expect(q.relativeUncertainty, 0);

      q = Currency(usd: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Currency.currencyDimensions);
      expect(q.preferredUnits, Currency.dollarsUS);
      expect(q.relativeUncertainty, 0.001);
    });

    test('operator +', () {
      final c1 = Currency(usd: 12.34);
      final c2 = Currency(usd: 56.78);
      dynamic sum = c1 + c2;
      expect(sum is Currency, true);
      expect(sum.valueSI.toDouble(), 69.12);

      // Adding Scalar allowed
      sum = c1 + Scalar(value: 23);
      expect(sum is Currency, true);
      expect(sum.valueSI.toDouble(), 35.34);

      // Adding num allowed
      sum = c1 + 14.05;
      expect(sum is Currency, true);
      expect(sum.valueSI.toDouble(), 26.39);
    });

    test('operator -', () {
      final c1 = Currency(usd: 12.34);
      final c2 = Currency(usd: 56.78);
      dynamic diff = c2 - c1;
      expect(diff is Currency, true);
      expect(diff.valueSI.toDouble(), 44.44);
      diff = c1 - c2;
      expect(diff is Currency, true);
      expect(diff.valueSI.toDouble(), -44.44);

      // Subtracting Scalar allowed
      diff = c2 - Scalar(value: 23);
      expect(diff is Currency, true);
      expect(diff.valueSI.toDouble(), closeTo(33.78, 0.00001));

      // Subtracting num allowed
      diff = c2 - 14.05;
      expect(diff is Currency, true);
      expect(diff.valueSI.toDouble(), closeTo(42.73, 0.00001));
    });

    test('operator *', () {
      final c1 = Currency(usd: 12.34);

      dynamic prod = c1 * 2;
      expect(prod is Currency, true);
      expect(prod.valueSI.toDouble(), closeTo(24.68, 0.00001));

      prod = c1 * Integer(3);
      expect(prod is Currency, true);
      expect(prod.valueSI.toDouble(), closeTo(37.02, 0.00001));

      prod = c1 * Double(4.5);
      expect(prod is Currency, true);
      expect(prod.valueSI.toDouble(), closeTo(12.34 * 4.5, 0.00001));

      prod = c1 * Scalar(value: 8.1);
      expect(prod is Currency, true);
      expect(prod.valueSI.toDouble(), closeTo(12.34 * 8.1, 0.00001));
    });

    test('operator /', () {
      final c1 = Currency(usd: 12.34);

      dynamic prod = c1 / 2;
      expect(prod is Currency, true);
      expect(prod.valueSI.toDouble(), closeTo(6.17, 0.00001));

      prod = c1 / Integer(3);
      expect(prod is Currency, true);
      expect(prod.valueSI.toDouble(), closeTo(12.34 / 3, 0.00001));

      prod = c1 / Double(4.5);
      expect(prod is Currency, true);
      expect(prod.valueSI.toDouble(), closeTo(12.34 / 4.5, 0.00001));

      prod = c1 / Scalar(value: 8.1);
      expect(prod is Currency, true);
      expect(prod.valueSI.toDouble(), closeTo(12.34 / 8.1, 0.00001));
    });
  });
}
