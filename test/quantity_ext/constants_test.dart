import 'dart:io';
import 'dart:math' show min;
import 'package:advance_math/src/quantity/domain/electromagnetic.dart';
import 'package:advance_math/src/quantity/domain/thermodynamic.dart';
import 'package:advance_math/src/quantity/domain/universal.dart';
import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

/// Maps the name used by NIST in its published constants file to the constant in the quantity package.
Map<String, Quantity> nistNameConstantMap = <String, Quantity>{
  'alpha particle mass': alphaParticleMass,
  'atomic mass constant': atomicMass,
  'Avogadro constant': avogadro,
  'Angstrom star': angstromStar,
  'Bohr magneton': bohrMagneton,
  'Bohr radius': bohrRadius,
  'Boltzmann constant': boltzmannConstant,
  'characteristic impedance of vacuum': characteristicImpedanceOfVacuum,
  'classical electron radius': classicalElectronRadius,
  'Compton wavelength': comptonWavelength,
  'conductance quantum': conductanceQuantum,
  'deuteron mass': deuteronMass,
  'electron g factor': electronGFactor,
  'electron mass': electronMass,
  'elementary charge': elementaryCharge,
  'Faraday constant': faradayConstant,
  'fine-structure constant': fineStructureConstant,
  'first radiation constant': firstRadiationConstant,
  'Hartree energy': hartreeEnergy,
  'helion mass': helionMass,
  'molar gas constant': gasConstantMolar,
  'Josephson constant': josephsonConstant,
  'Loschmidt constant (273.15 K, 101.325 kPa)': loschmidtStdAtm,
  'mag. flux quantum': magneticFluxQuantum,
  'molar Planck constant': molarPlanck,
  'molar volume of ideal gas (273.15 K, 100 kPa)': molarVolume100kPa,
  'molar volume of ideal gas (273.15 K, 101.325 kPa)': molarVolumeStdAtm,
  'muon g factor': muonGFactor,
  'muon mass': muonMass,
  'neutron g factor': neutronGFactor,
  'neutron mass': neutronMass,
  'Newtonian constant of gravitation': newtonianConstantOfGravitation,
  'nuclear magneton': nuclearMagneton,
  'Planck constant': planckConstant,
  'Planck constant over 2 pi': hBar,
  'Planck length': planckLength,
  'Planck mass': planckMass,
  'Planck temperature': planckTemperature,
  'Planck time': planckTime,
  'proton g factor': protonGFactor,
  'proton mass': protonMass,
  'Rydberg constant': rydberg,
  'Sackur-Tetrode constant (1 K, 100 kPa)': sackurTetrode100kPa,
  'Sackur-Tetrode constant (1 K, 101.325 kPa)': sackurTetrodeStdAtm,
  'second radiation constant': secondRadiationConstant,
  'speed of light in vacuum': speedOfLightVacuum,
  'Stefan-Boltzmann constant': stefanBoltzmann,
  'tau Compton wavelength': tauComptonWavelength,
  'tau mass': tauMass,
  'Thomson cross section': thomsonCrossSection,
  'vacuum electric permittivity': vacuumElectricPermittivity,
  'vacuum mag. permeability': vacuumMagneticPermeability,
  'von Klitzing constant': vonKlitzingConstant,
  'weak mixing angle': weakMixingAngle,
  'Wien wavelength displacement law constant': wienDisplacement
};

void main() {
  group('constants', () {
    test('check against NIST values', () {
      final lines =
          File('test/quantity_ext/txt/nist_constants.txt').readAsLinesSync();
      double value, uncert;
      for (final line in lines) {
        final name = line.substring(0, 60).trim();
        var valueStr = line.substring(60, 85);

        var approxValue = false;
        valueStr = valueStr.replaceAll(' ', '');
        if (valueStr.contains('...')) {
          valueStr = valueStr.replaceAll('...', '');
          uncert = 0.0;
          approxValue = true;
        } else {
          var uncertStr = line.substring(85, min(line.length, 110));
          if (uncertStr.contains('exact')) {
            uncert = 0.0;
          } else {
            uncertStr = uncertStr.replaceAll(' ', '');
            uncert = double.parse(uncertStr);
          }
        }

        value = double.parse(valueStr);

        if (nistNameConstantMap.containsKey(name)) {
          final q = nistNameConstantMap[name] as Quantity;
          if (approxValue) {
            expect(q.valueSI.toDouble() / value, closeTo(1.0, 0.000001));
          } else {
            expect(q.valueSI.toDouble(), value);
          }

          // Make sure the standard uncertainty is very close to expected (won't be exact because set by
          // *relative* standard uncertainty in library)
          expect(q.relativeUncertainty, (uncert / value).abs());
        }
      }
    });
  });
}
