// ignore_for_file: unnecessary_type_check

import 'package:advance_math/src/quantity/domain/universal.dart';
import 'package:test/test.dart';

void main() {
  group('Universal', () {
    test('constants', () {
      expect(characteristicImpedanceOfVacuum is Resistance, true);
      expect(characteristicImpedanceOfVacuum.valueSI.toDouble(), 376.730313668);

      expect(speedOfLightVacuum is Speed, true);
      expect(speedOfLightVacuum.valueSI.toDouble(), 2.99792458e8);

      expect(vacuumMagneticPermeability is Permeability, true);
      expect(vacuumMagneticPermeability.valueSI.toDouble(), 1.25663706212e-6);

      expect(planckConstant is AngularMomentum, true);
      expect(planckConstant.valueSI.toDouble(), 6.62607015e-34);

      expect(hBar is AngularMomentum, true);
      expect(hBar.valueSI.toDouble(), 1.05457181777777777e-34);

      expect(planckLength is Length, true);
      expect(planckLength.valueSI.toDouble(), 1.616255e-35);

      expect(planckMass is Mass, true);
      expect(planckMass.valueSI.toDouble(), 2.176434e-8);

      expect(planckTemperature is Temperature, true);
      expect(planckTemperature.valueSI.toDouble(), 1.416784e32);

      expect(planckTime is Time, true);
      expect(planckTime.valueSI.toDouble(), 5.391247e-44);

      expect(vacuumElectricPermittivity is Permittivity, true);
      expect(vacuumElectricPermittivity.valueSI.toDouble(), 8.8541878128e-12);

      expect(newtonianConstantOfGravitation is MiscQuantity, true);
      expect(newtonianConstantOfGravitation.valueSI.toDouble(), 6.67430e-11);

      expect(rydberg is WaveNumber, true);
      expect(rydberg.valueSI.toDouble(), 10973731.568160);
    });

    test('synonyms', () {
      expect(c, speedOfLightVacuum);
      expect(c0, c);
      expect(mu0, vacuumMagneticPermeability);
      expect(eps0 == vacuumMagneticPermeability, false);
      expect(eps0, vacuumElectricPermittivity);
      expect(Z0, characteristicImpedanceOfVacuum);
      expect(G, newtonianConstantOfGravitation);
      expect(h, planckConstant);
    });
  });
}
