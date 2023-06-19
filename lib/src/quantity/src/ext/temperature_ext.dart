import '../number/double.dart';
import '../si/types/temperature.dart';
import '../si/types/temperature_interval.dart';

/// The standard SI unit.
final TemperatureUnits kelvins = Temperature.kelvins;

/// A synonym for degrees Kelvin.
// ignore:non_constant_identifier_names
final TemperatureIntervalUnits degK = TemperatureInterval.kelvins;

/// Degrees in the Celsius scale.
final TemperatureUnits degreesCelsius = Temperature.degreesCelsius;

/// A ratio used in the conversion between metric temperature scales and Fahrenheit.
const double fiveNinths = 5.0 / 9.0;

/// Fahrenheit scale units.
// ignore:non_constant_identifier_names
final TemperatureUnits Fahrenheit = TemperatureUnits(
    'degrees Fahrenheit', 'F', null, 'degree Fahrenheit', fiveNinths, false, 273.15 - (fiveNinths * 32.0));

/// Rankine scale units.
// ignore:non_constant_identifier_names
final TemperatureUnits Rankine =
    TemperatureUnits('degrees Rankine', 'deg R', null, 'degree Rankine', fiveNinths, false, 0);

/// Degrees in the Fahrenheit scale.
final TemperatureIntervalUnits degreesFahrenheit =
    TemperatureIntervalUnits('degrees Fahrenheit', 'deg F', null, 'degree Fahrenheit', fiveNinths, false, 0.0);

/// A synonym for [degreesFahrenheit].
final TemperatureIntervalUnits degF = degreesFahrenheit;

/// Degrees in the Rankine scale.
final TemperatureIntervalUnits degreesRankine =
    TemperatureIntervalUnits('degrees Rankine', 'deg R', null, 'degree Rankine', fiveNinths, false, 0.0);

/// A synonym for [degreesRankine].
final TemperatureIntervalUnits degR = degreesRankine;

// Constants

/// Contemporary models of physical cosmology postulate that the highest possible temperature is the Planck temperature.
const Temperature planckTemperature =
    Temperature.constant(Double.constant(1.416784e32), uncert: 0.000011293182305841964);
