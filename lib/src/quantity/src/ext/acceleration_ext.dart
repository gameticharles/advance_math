import '../ext/length_ext.dart';
import '../ext/time_ext.dart';
import '../si/types/acceleration.dart';

/// A synonym for the standard SI-MKS unit of acceleration.
final AccelerationUnits meterPerSecondSquared =
    Acceleration.metersPerSecondSquared;

/// A commonly used English unit of acceleration.
final AccelerationUnits footPerSecondSquared =
    AccelerationUnits.lengthTimeUnits(LengthUnits.feet, seconds);

/// A commonly used English unit of acceleration.
final AccelerationUnits inchPerSecondSquared =
    AccelerationUnits.lengthTimeUnits(LengthUnits.inches, seconds);

/// A unit based on the acceleration experienced by a free-falling body at the Earth's surface.
// Note:  don't use 'g' as abbreviation (conflict with grams and presents problems for parsing)
final AccelerationUnits gees =
    AccelerationUnits('gees', null, null, null, 9.80665, false);

/// The more formal name for [gees].
final AccelerationUnits standardAccelerationOfGravity = gees;

/// Defined as 0.01 meter per second squared.
final AccelerationUnits galileos =
    AccelerationUnits('galileos', 'gals', null, null, 0.01, true);

/// Synonymous with [galileos].
final AccelerationUnits gals = galileos;
