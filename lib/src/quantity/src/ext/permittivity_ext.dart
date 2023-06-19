import '../number/double.dart';
import '../si/types/permittivity.dart';

/// The standard SI unit.
PermittivityUnits faradsPerMeter = Permittivity.faradsPerMeter;

// Constants.

/// A constant of proportionality that exists between electric displacement and electric field intensity.
const Permittivity vacuumElectricPermittivity =
    Permittivity.constant(Double.constant(8.8541878128e-12), uncert: 1.468231787584925e-10);
