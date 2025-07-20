import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('TemperatureInterval', () {
    test('constructors', () {
      // default ctor, K 0
      var a = TemperatureInterval();
      expect(a.valueSI, Integer.zero);
      expect(a.valueSI is Integer, true);
      expect(a.dimensions, TemperatureInterval.temperatureIntervalDimensions);
      expect(a.preferredUnits, TemperatureInterval.kelvins);
      expect(a.relativeUncertainty, 0);

      // default ctor, K +
      a = TemperatureInterval(K: 42);
      expect(a.valueSI.toDouble(), 42);
      expect(a.valueSI is Integer, true);
      expect(a.dimensions, TemperatureInterval.temperatureIntervalDimensions);
      expect(a.preferredUnits, TemperatureInterval.kelvins);
      expect(a.relativeUncertainty, 0);

      // default ctor, K -
      a = TemperatureInterval(K: -99.33);
      expect(a.valueSI.toDouble(), -99.33);
      expect(a.valueSI is Double, true);
      expect(a.dimensions, TemperatureInterval.temperatureIntervalDimensions);
      expect(a.preferredUnits, TemperatureInterval.kelvins);
      expect(a.relativeUncertainty, 0);

      // kelvins and degC are equivalent temperature intervals

      // default ctor, degC +
      a = TemperatureInterval(degC: 100);
      expect(a.valueSI.toDouble(), 100);
      expect(a.valueSI is Integer, true);
      expect(a.dimensions, TemperatureInterval.temperatureIntervalDimensions);
      expect(a.preferredUnits, TemperatureInterval.degreesCelsius);
      expect(a.relativeUncertainty, 0);

      // default ctor, degC -
      a = TemperatureInterval(degC: -53.4);
      expect(a.valueSI.toDouble(), -53.4);
      expect(a.valueSI is Double, true);
      expect(a.dimensions, TemperatureInterval.temperatureIntervalDimensions);
      expect(a.preferredUnits, TemperatureInterval.degreesCelsius);
      expect(a.relativeUncertainty, 0);
    });

    test('operator +', () {
      final a = TemperatureInterval(K: 12.34);
      final b = TemperatureInterval(K: 56.78);
      dynamic sum = a + b;
      expect(sum is TemperatureInterval, true);
      expect(sum.valueSI.toDouble(), 69.12);

      final c = TemperatureInterval(degC: 34);
      sum = a + c;
      expect(sum is TemperatureInterval, true);
      expect(sum.valueSI.toDouble(), closeTo(46.34, 0.000001));

      final d = Temperature(K: 12.3);
      sum = b + d;
      expect(sum is Temperature, true);
      expect(sum.valueSI.toDouble(), closeTo(69.08, 0.000001));
    });

    test('operator -', () {
      final a = TemperatureInterval(K: 56.78);
      final b = TemperatureInterval(K: 12.34);
      dynamic diff = a - b;
      expect(diff is TemperatureInterval, true);
      expect(diff.valueSI.toDouble(), 44.44);
      diff = b - a;
      expect(diff is TemperatureInterval, true);
      expect(diff.valueSI.toDouble(), -44.44);

      // Subtracting Temperature from TemperatureInterval unsupported
      final c = Temperature(C: 34);
      dynamic exception;
      try {
        diff = a - c;
      } catch (e) {
        exception = e;
      }
      expect(exception is QuantityException, true);
    });
  });
}
