import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('QuantityRange', () {
    test('constructors', () {
      final range =
          QuantityRange<Scalar>(Scalar(value: 5), Scalar(value: 23.3));
      expect(range, isNotNull);
      expect(range.q1 == Scalar(value: 5), true);
      expect(range.q2 == Scalar(value: 23.3), true);
    });

    test('min/max values', () {
      var range =
          QuantityRange<Scalar>(Scalar(value: 15.2), Scalar(value: -1003.3));
      expect(range.minValue == Scalar(value: -1003.3), true);
      expect(range.maxValue == Scalar(value: 15.2), true);

      range =
          QuantityRange<Scalar>(Scalar(value: -1003.3), Scalar(value: 15.2));
      expect(range.minValue == Scalar(value: -1003.3), true);
      expect(range.maxValue == Scalar(value: 15.2), true);

      final range2 = QuantityRange<Length>(Length(m: 10000), Length(km: 1000));
      expect(
          areWithin(range2.minValue, Length(km: 10), Length(m: 0.001)), true);
      expect(range2.maxValue == Length(km: 1000), true);
    });

    test('operator ==', () {
      final range1 = QuantityRange<Length>(Length(m: 6.5), Length(m: 18.3));
      final range2 = QuantityRange<Length>(Length(m: 6.8), Length(m: 21.3));
      final range3 = QuantityRange<Length>(Length(m: 6.5), Length(m: 18.3));

      expect(range1 == range1, true);
      expect(range1 == range2, false);
      expect(range2 == range3, false);
      expect(range1 == range3, true);
      expect(range3 == range1, true);
    });

    test('hashCode', () {
      final range1 = QuantityRange<Length>(Length(m: 6.5), Length(m: 18.3));
      final range2 = QuantityRange<Length>(Length(m: 6.8), Length(m: 21.3));
      final range3 = QuantityRange<Length>(Length(m: 6.5), Length(m: 18.3));

      expect(range1.hashCode == range2.hashCode, false);
      expect(range2.hashCode == range3.hashCode, false);
      expect(range1.hashCode == range3.hashCode, true);
    });
  });
}
