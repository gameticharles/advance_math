import '../si/types/pressure.dart';
import 'area_ext.dart';
import 'force_ext.dart';

/// The standard SI unit.
PressureUnits pascals = Pressure.pascals;

/// Shorthand bars unit.
PressureUnits bars = Pressure.bars;

/// Standard atmospheres as a unit.
PressureUnits atmospheres = PressureUnits(
    'atmospheres (std)', null, null, 'atmosphere (std)', 1.01325e5, false);

/// Technical atmospheres as a unit.
PressureUnits atmospheresTechnical = PressureUnits(
    'atmospheres (tech)', null, null, 'atmosphere (tech)', 9.80665e4, false);

/// Baryes as a unit.
PressureUnits baryes = PressureUnits('baryes', null, null, null, 1.0e-1, false);

/// Centimeters of mercury at 0 degrees Celsius.
PressureUnits cmMercury0 = PressureUnits('centimeters of mercury (0 deg C)',
    null, null, 'centimeter of mercury (0 deg C)', 1.33322e3, false);

/// Centimeters of water at 4 degrees Celsius.
PressureUnits cmWater4 = PressureUnits('centimeters of water (4 deg C)', null,
    null, 'centimeter of water (4 deg C)', 9.80638e1, false);

/// Feet of water at 39.2 degrees Fahrenheit.
PressureUnits ftWater39 = PressureUnits('feet of water (39.2 deg F)', null,
    null, 'foot of water (39.2 deg F)', 2.98898e3, false);

/// Inches of mercury at 32 degrees Fahrenheit.
PressureUnits inMercury32 = PressureUnits('inches of mercury (32 deg F)', null,
    null, 'inch of mercury (32 deg F)', 3.386389e3, false);

/// Inches of water at 39.2 degrees Fahrenheit.
PressureUnits inWater39 = PressureUnits('inches of water (39.2 deg F)', null,
    null, 'inch of water (39.2 deg F)', 2.49082e2, false);

/// Pounds per square inch as a unit.
PressureUnits psi =
    PressureUnits.forceArea(poundsForceAvoirdupois, squareInches);

/// Torrs as a unit.
PressureUnits torrs =
    PressureUnits('torrs', null, null, null, 1.33322e2, false);

/// A pressure often used as the reference pressure for calculation of
///  sound pressure __levels__.
PressureUnits referenceSoundAir = PressureUnits(
    'reference sound pressure (air)',
    null,
    null,
    'reference sound pressure (air)',
    2.0e-5,
    false);

/// A pressure commonly used as the reference pressure for calculation of
///  sound pressure __levels__.
PressureUnits referenceSoundWater = PressureUnits(
    'reference sound pressure (water)',
    null,
    null,
    'reference sound pressure (water)',
    1.0e-6,
    false);

// Convenience units.

/// A synonym for pascals.
PressureUnits newtonsPerSquareMeter = pascals;

/// A millibar as a unit.
PressureUnits millibars = pascals.hecto() as PressureUnits;
