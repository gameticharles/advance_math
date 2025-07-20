import '../si/types/kinematic_viscosity.dart';
import 'area_ext.dart';
import 'time_ext.dart';

/// The standard SI unit.
KinematicViscosityUnits metersSquaredPerSecond =
    KinematicViscosity.metersSquaredPerSecond;

/// Stokes as a unit.
KinematicViscosityUnits stokes =
    KinematicViscosityUnits('stokes', 'St', null, null, 1.0e-4, true);

/// Centistokes as a unit.
KinematicViscosityUnits centistokes =
    KinematicViscosityUnits('centistokes', 'cSt', null, null, 1.0e-6, false);

/// Square feet per second as a unit.
KinematicViscosityUnits squareFeetPerSecond =
    KinematicViscosityUnits.areaTime(squareFeet, seconds);
