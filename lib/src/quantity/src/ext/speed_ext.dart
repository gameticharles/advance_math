import '../number/double.dart';
import '../si/types/speed.dart';
import 'length_ext.dart';
import 'time_ext.dart';

/// The standard SI unit.
SpeedUnits metersPerSecond = Speed.metersPerSecond;

/// The speed of light as a unit.
SpeedUnits speedOfLightUnits = SpeedUnits(
    'speed of light', 'c0', 'c', 'speed of light', 2.99792458e8, false);

/// Feet per hour as a unit.
SpeedUnits feetPerHour = SpeedUnits.lengthTime(LengthUnits.feet, hours);

/// Feet per minute as a unit.
SpeedUnits feetPerMinute = SpeedUnits.lengthTime(LengthUnits.feet, minutes);

/// Feet per second as a unit.
SpeedUnits feetPerSecond = SpeedUnits.lengthTime(LengthUnits.feet, seconds);

/// Inches per second as a unit.
SpeedUnits inchesPerSecond = SpeedUnits.lengthTime(LengthUnits.inches, seconds);

/// Kilometers per hour as a unit.
SpeedUnits kilometersPerHour =
    SpeedUnits.lengthTime(LengthUnits.kilometers, hours);

/// Miles per hour as a unit.
SpeedUnits milesPerHour = SpeedUnits.lengthTime(LengthUnits.miles, hours);

/// Miles per minute as a unit.
SpeedUnits milesPerMinute = SpeedUnits.lengthTime(LengthUnits.miles, minutes);

/// Miles per second as a unit.
SpeedUnits milesPerSecond = SpeedUnits.lengthTime(LengthUnits.miles, seconds);

/// Knots, tersely.
SpeedUnits knots = Speed.knots;

// CONSTANTS.

/// Speed of light in a vacuum.
const Speed speedOfLightVacuum = Speed.constant(Double.constant(299792458));

/// Speed of sound in air at 0 deg C.
const Speed speedOfSoundAir0C = Speed.constant(Double.constant(331.6));
