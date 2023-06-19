// ignore_for_file: unnecessary_type_check

import 'package:advance_math/src/quantity/quantity.dart';
import 'package:test/test.dart';

void main() {
  group('Mass', () {
    test('constructors', () {
      var q = Mass();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Mass.massDimensions);
      expect(q.preferredUnits, Mass.kilograms);
      expect(q.relativeUncertainty, 0);

      q = Mass(kg: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Mass.massDimensions);
      expect(q.preferredUnits, Mass.kilograms);
      expect(q.relativeUncertainty, 0.001);

      q = Mass(g: 1);
      expect(q.valueSI.toDouble(), 0.001);
      expect(q.valueSI is Double, true);
      expect(q.dimensions, Mass.massDimensions);
      expect(q.preferredUnits, Mass.grams);
      expect(q.relativeUncertainty, 0);

      q = Mass(u: 1);
      expect(q.valueSI.toDouble(), 1.66053886e-27);
      expect(q.valueSI is Double, true);
      expect(q.dimensions, Mass.massDimensions);
      expect(q.preferredUnits, Mass.unifiedAtomicMassUnits);
      expect(q.relativeUncertainty, 0);
    });

    test('toEnergy', () {
      var m = Mass(kg: 1);
      var e = m.toEnergy();

      expect(e is Energy, true);
      expect(e.valueSI.toDouble(), 8.9875517873681764e16);

      m = Mass(g: 1);
      e = m.toEnergy();
      expect(e.valueSI.toDouble(), 8.9875517873681764e13);

      m = Mass(kg: 2.2);
      e = m.toEnergy();
      expect(e.valueSI.toDouble(), 1.97726139322099870e17);
    });
  });
}
