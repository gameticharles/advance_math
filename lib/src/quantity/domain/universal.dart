/// Quantity types and constants with universal application.
library universal;

import '../quantity.dart';

export '../quantity.dart'
    show
        characteristicImpedanceOfVacuum,
        speedOfLightVacuum,
        vacuumMagneticPermeability,
        planckConstant,
        hBar,
        planckLength,
        planckMass,
        planckTemperature,
        planckTime,
        vacuumElectricPermittivity,
        Length,
        Mass,
        Speed,
        Permeability,
        Permittivity,
        Resistance,
        Temperature,
        Time,
        MiscQuantity,
        AngularMomentum,
        WaveNumber;

/// The symbol for the speed of light constant.
const Speed c = speedOfLightVacuum;

/// An alternative symbol for the speed of light constant.
const Speed c0 = c;

/// The symbol for the magnetic constant.
Permeability mu0 = vacuumMagneticPermeability;

/// The symbol for the electric constant.
Permittivity eps0 = vacuumElectricPermittivity;

/// The symbol for the characteristic impedance of vacuum.
// ignore: non_constant_identifier_names
Resistance Z0 = characteristicImpedanceOfVacuum;

/// An empirical physical constant involved in the calculation of gravitational effects.
const MiscQuantity newtonianConstantOfGravitation = MiscQuantity.constant(
    Double.constant(6.67430e-11),
    Dimensions.constant(<String, int>{'Length': 3, 'Mass': -1, 'Time': -2}),
    uncert: 0.000022474266964325848);

/// The symbol for the Newtonian constant of gravitation.
const MiscQuantity G = newtonianConstantOfGravitation;

/// The symbol for the Planck constant.
const AngularMomentum h = planckConstant;

/// Appears in the Balmer formula for spectral lines of the hydrogen atom. For a hydrogen atom, the effective mass
/// must be taken as the reduced mass of the proton and electron. In MKS, this gives the Rydberg constant.
const WaveNumber rydberg = WaveNumber.constant(Double.constant(10973731.568160),
    uncert: 1.9136608062230136e-12);
