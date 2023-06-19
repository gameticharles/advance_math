import '../number/double.dart';
import '../si/types/power.dart';
import 'energy_ext.dart';
import 'time_ext.dart';

/// The standard SI unit.
PowerUnits watts = Power.watts;

/// Square degrees as a unit.
PowerUnits btuThermsPerHour = PowerUnits.energyTime(btuThermo, hours);

/// Thermochemical BTUs per second as a unit.
PowerUnits btuThermsPerSecond = PowerUnits.energyTime(btuThermo, seconds);

/// Thermochemical calories as a unit.
PowerUnits caloriesThermoPerSecond = PowerUnits.energyTime(caloriesThermo, seconds);

/// Ergs per second as a unit.
PowerUnits ergsPerSecond = PowerUnits.energyTime(ergs, seconds);

/// Force de cheval as a unit.
PowerUnits forceDeCheval = PowerUnits('force de cheval', null, null, 'force de cheval', 735.5, false);

/// Horsepower (550 ft lbs/s) as a unit.
PowerUnits horsepower550 =
    PowerUnits('horsepower (550 ft lbs/s)', null, null, 'horsepower (550 ft lbs/s)', 745.70, false);

/// Horsepower (boiler) as a unit.
PowerUnits horsepowerBoiler = PowerUnits('horsepower (boiler)', null, null, 'horsepower (boiler)', 9809.5, false);

/// Horsepower (electric) as a unit.
PowerUnits horsepowerElectric = PowerUnits('horsepower (electric)', null, null, 'horsepower (electric)', 746.0, false);

/// Horsepower (metric) as a unit.
PowerUnits horsepowerMetric = PowerUnits('horsepower (metric)', null, null, 'horsepower (metric)', 735.5, false);

/// Horsepower (water) as a unit.
PowerUnits horsepowerWater = PowerUnits('horsepower (water)', null, null, 'horsepower (water)', 746.04, false);

/// A power commonly used as the reference power for calculation of sound power _levels_.
PowerUnits referenceSound = PowerUnits('reference (sound)', null, null, 'reference (sound)', 1.0e-12, false);

// Convenience units.

/// Shorthand kilowatts as a unit.
PowerUnits kilowatts = Power.kilowatts;

// Constants.

/// The solar luminosity constant is the radiant flux (power emitted in the form of photons) emitted by the Sun
/// (a typical value; the Sun's output actually varies slightly over time).
const Power solarLuminosity = Power.constant(Double.constant(3.846e26));
