import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('temperature ext', () {
    test('Fahrenheit', () {
      final f = Temperature.inUnits(1.23, Fahrenheit);
      expect(f.valueSI.toDouble(), closeTo(256.05555555, 0.000001));

      final k = Temperature(K: 200.4);
      final dynamic sum = f + k;
      expect(sum is Temperature, true);
      expect(sum.valueSI.toDouble(), closeTo(456.4555555555555, 0.000001));
    });

    test('Rankine', () {
      final r = Temperature.inUnits(100, Rankine);
      expect(r.valueSI.toDouble(), closeTo(55.555555555, 0.000001));

      final k = Temperature(K: 200.4);
      final dynamic sum = r + k;
      expect(sum is Temperature, true);
      expect(sum.valueSI.toDouble(), closeTo(255.9555555555, 0.000001));
    });

    test('deg F', () {
      final f = TemperatureInterval.inUnits(1.23, degF);
      expect(f.valueSI.toDouble(), closeTo(0.6833333333333333, 0.000001));

      final k = TemperatureInterval(K: 200.4);
      final dynamic sum = f + k;
      expect(sum is TemperatureInterval, true);
      expect(sum.valueSI.toDouble(), closeTo(201.0833333333333, 0.000001));
    });

    test('Rankine', () {
      final r = TemperatureInterval.inUnits(100, degR);
      expect(r.valueSI.toDouble(), closeTo(55.555555555, 0.000001));

      final k = TemperatureInterval(K: 200.4);
      final dynamic sum = r + k;
      expect(sum is TemperatureInterval, true);
      expect(sum.valueSI.toDouble(), closeTo(255.9555555555, 0.000001));
    });
  });
}
