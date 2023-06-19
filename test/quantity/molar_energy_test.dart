import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('MolarEnergy', () {
    test('constructors', () {
      var a = MolarEnergy();
      expect(a, isNotNull);
      expect(a.valueSI, Double.zero);
      expect(a.valueSI is Integer, true);
      expect(a.dimensions, MolarEnergy.molarEnergyDimensions);
      expect(a.preferredUnits, MolarEnergy.joulesPerMole);

      a = MolarEnergy(joulesPerMole: 2.4);
      expect(a, isNotNull);
      expect(a.valueSI.toDouble(), 2.4);
      expect(a.valueSI is Double, true);
      expect(a.dimensions, MolarEnergy.molarEnergyDimensions);
      expect(a.preferredUnits, MolarEnergy.joulesPerMole);
    });
  });
}
