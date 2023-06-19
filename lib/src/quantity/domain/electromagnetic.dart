/// Quantity types, units and constants commonly encountered in the fields dealing with
/// electromagnetics.
library electromagnetic;

import '../quantity.dart';

export '../quantity.dart'
    show
        elementaryCharge,
        vacuumMagneticPermeability,
        conductanceQuantum,
        vonKlitzingConstant,
        magneticFluxQuantum,
        Charge,
        MagneticFlux,
        Conductance,
        MiscQuantity,
        Resistance,
        Permeability;

/// The quantized unit of electrical conductance.
/// It appears when measuring the conductance of a quantum point contact
// ignore: constant_identifier_names
const Conductance G0 = conductanceQuantum;

/// The inverse of the magnetic flux quantum.
const MiscQuantity josephsonConstant = MiscQuantity.constant(
    Double.constant(483597848444444.44),
    Dimensions.constant(
        <String, int>{'Length': -2, 'Mass': -1, 'Current': 1, 'Time': 2}));

/// The common symbol for the Josephson constant.
// ignore: constant_identifier_names
const MiscQuantity KJ = josephsonConstant;

/// The common symbol for the von Klitzing constant.
// ignore: constant_identifier_names
const Resistance RK = vonKlitzingConstant;

/// Useful for expressing the magnetic moment of an electron caused by either its orbital or spin angular momentum.
const MiscQuantity bohrMagneton = MiscQuantity.constant(
    Double.constant(9.2740100783e-24),
    Dimensions.constant(<String, int>{'Length': 2, 'Current': 1}),
    uncert: 3.019190163003642e-10);

/// The common symbol for the Bohr Magneton constant.
const MiscQuantity muB = bohrMagneton;

/// Useful for expressing magnetic dipole moments of heavy particles.
const MiscQuantity nuclearMagneton = MiscQuantity.constant(
    Double.constant(5.0507837461e-27),
    Dimensions.constant(<String, int>{'Length': 2, 'Current': 1}),
    uncert: 2.9698361193116537e-10);

/// The common symbol for the Nuclear Magneton constant.
const MiscQuantity muN = nuclearMagneton;

/// A synonym for the magnetic constant.
const Permeability vacuum = vacuumMagneticPermeability;
