import '../si/types/magnetic_flux_density.dart';

/// The standard SI unit.
MagneticFluxDensityUnits teslas = MagneticFluxDensity.teslas;

/// One gauss is one ten-thousandth of a tesla.
MagneticFluxDensityUnits gauss =
    MagneticFluxDensityUnits('gauss', null, null, 'gauss', 1.0e-4, true);

/// Unit poles density as a unit.
MagneticFluxDensityUnits unitPolesDensity =
    MagneticFluxDensityUnits('unit poles', null, null, null, 1.2566e-7, false);

/// Magnetic field atomic unit.
MagneticFluxDensityUnits magFieldAtomicUnit = MagneticFluxDensityUnits(
    'magnetic field, atomic unit', null, null, null, 1.7153e3, false);

// Convenience Units.

/// A synonym for nanoteslas.
MagneticFluxDensityUnits magneticGammas =
    teslas.nano() as MagneticFluxDensityUnits;
