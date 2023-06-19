import '../number/double.dart';
import '../si/types/magnetic_flux.dart';

/// The standard SI unit.
MagneticFluxUnits webers = MagneticFlux.webers;

/// A maxwell is one one-hundred-millionth of a weber.
MagneticFluxUnits maxwells = MagneticFluxUnits('maxwells', null, null, null, 1.0e-8, true);

/// Unit poles as a unit.
MagneticFluxUnits unitPoles = MagneticFluxUnits('unit poles', null, null, null, 1.2566e-7, false);

// Constants

/// The magnetic flux quantum constant is a combination of two other physical constants:
/// the Planck constant h and the electron charge e. Its value is, therefore, the same for any superconductor.
const MagneticFlux magneticFluxQuantum = MagneticFlux.constant(Double.constant(2.0678338488888888e-15));
