import '../si/types/force.dart';

/// The standard SI unit.
final ForceUnits newtons = Force.newtons;

/// Dynes as a unit.
ForceUnits dynes = ForceUnits('dynes', null, null, null, 1.0e-5, true);

/// Kilograms force as a unit.
ForceUnits kilogramsForce = ForceUnits(
    'kilograms force', 'kgf', null, 'kilogram force', 9.80665, false);

/// Kips as a unit.
ForceUnits kips =
    ForceUnits('kips', null, null, null, 4.4482216152605e3, false);

/// Avoirdupois pounds force as a unit.
ForceUnits poundsForceAvoirdupois = ForceUnits('pounds force (avoirdupois)',
    'lbf', null, 'pound force (avoirdupois)', 4.4482216152605, false);

/// Avoirdupois ounces force as a unit.
ForceUnits ouncesForceAvoirdupois = ForceUnits('ounces force (avoirdupois)',
    null, null, 'ounce force (avoirdupois)', 2.7801385e-1, false);

/// Poundals as a unit.
ForceUnits poundals =
    ForceUnits('poundals', null, null, null, 1.38254954376e-1, false);

// Convenience.

/// A synonym for kilograms force.
ForceUnits kiloponds = kilogramsForce;
