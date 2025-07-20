import '../../../number/number/double.dart';
import '../si/types/charge.dart';
import '../si/types/current.dart';
import '../si/types/time.dart';

/// The standard SI unit.
final ChargeUnits coulombs = Charge.coulombs;

/// Ampere hours as a unit.
final ChargeUnits ampereHours =
    ChargeUnits.currentTime(Current.amperes, Time.hours);

/// Carbon 12 faradays as a unit.
final ChargeUnits faradaysC12 = ChargeUnits(
    'faradays (carbon 12)', null, null, 'faraday (carbon 12)', 9.6486e4, false);

/// Chemical faradays as a unit.
final ChargeUnits faradaysChemical = ChargeUnits(
    'faradays (chemical)', null, null, 'faraday (chemical)', 9.64957e4, false);

/// Physical faradays as a unit.
final ChargeUnits faradaysPhysical = ChargeUnits(
    'faradays (physical)', null, null, 'faraday (physical)', 9.65219e4, false);

/// Statcoulombs as a unit.
final ChargeUnits statcoulombs =
    ChargeUnits('statcoulombs', null, null, null, 3.335640e-10, false);

// Convenience units.

/// A synonym for dekacoulombs.
final ChargeUnits abcoulombs = coulombs.deka() as ChargeUnits;

// Constants.

/// The electric charge carried by a single proton.
const Charge elementaryCharge =
    Charge.constant(Double.constant(1.602176634e-19));
