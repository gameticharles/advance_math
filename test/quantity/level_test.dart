import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('FieldLevel', () {
    test('constructors', () {
      var q = FieldLevel(Force(N: 10), Force(N: 10));
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Level.levelDimensions);
      expect(q.preferredUnits, Level.nepers);
      expect(q.relativeUncertainty, 0);

      q = FieldLevel(Force(N: 100), Force(N: 10));
      expect(q.valueSI.toDouble(), 1.151292546497023);
      expect(q.valueSI is Double, true);
      expect(q.dimensions, Level.levelDimensions);
      expect(q.preferredUnits, Level.nepers);
      expect(q.relativeUncertainty, 0);
    });
  });

  group('PowerLevel', () {
    test('constructors', () {
      var q = PowerLevel(Power(W: 10), Power(W: 10));
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Level.levelDimensions);
      expect(q.preferredUnits, Level.nepers);
      expect(q.relativeUncertainty, 0);

      q = PowerLevel(Power(W: 100), Power(W: 10));
      expect(q.valueSI.toDouble(), 1.151292546497023);
      expect(q.valueSI is Double, true);
      expect(q.dimensions, Level.levelDimensions);
      expect(q.preferredUnits, Level.nepers);
      expect(q.relativeUncertainty, 0);
    });
  });
}
