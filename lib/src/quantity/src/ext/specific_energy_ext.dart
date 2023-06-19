import '../si/types/specific_energy.dart';
import 'length_ext.dart';
import 'speed_ext.dart';
import 'time_ext.dart';

/// The standard SI unit.
SpecificEnergyUnits joulesPerKilogram = SpecificEnergy.joulesPerKilogram;

/// Square meters per second as a unit.
SpecificEnergyUnits squareMetersPerSquareSecond =
    SpecificEnergyUnits.lengthTime(LengthUnits.meters, seconds);

/// The square of the speed of light in a vacuum.
SpecificEnergyUnits speedOfLightSquared =
    SpecificEnergyUnits.speed(speedOfLightUnits);
