import '../si/types/mass_density.dart';
import 'mass_ext.dart';
import 'volume_ext.dart';

/// The standard SI unit.
MassDensityUnits kilogramsPerCubicMeter = MassDensity.kilogramsPerCubicMeter;

/// Grams per cubic centimeter as a unit.
MassDensityUnits gramsPerCubicCentimeter =
    MassDensityUnits.massVolume(grams, cubicCentimeters);

/// Pounds per cubic inch as a unit.
MassDensityUnits poundsPerCubicInch =
    MassDensityUnits.massVolume(poundsAvoirdupois, cubicInches);

/// Pounds per cubic foot as a unit.
MassDensityUnits poundsPerCubicFoot =
    MassDensityUnits.massVolume(poundsAvoirdupois, cubicFeet);

/// Slugs per cubic foot as a unit.
MassDensityUnits slugsPerCubicFoot =
    MassDensityUnits.massVolume(slugs, cubicFeet);
