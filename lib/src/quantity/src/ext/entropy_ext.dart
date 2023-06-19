import '../number/double.dart';
import '../si/types/entropy.dart';
import '../si/types/temperature_interval.dart';
import 'energy_ext.dart';

/// The standard SI unit.
final EntropyUnits joulesPerKelvin = Entropy.joulesPerKelvin;

/// Entropy as a 'charge'; identical to [joulesPerKelvin].
final EntropyUnits thermalCoulomb = joulesPerKelvin;

/// Boltzmann constant as a unit.
final EntropyUnits boltzmannUnit = EntropyUnits('Boltzmanns', 'kB', 'k', null, 1.3806503e-23, false);

/// The erg per clausius unit of entropy.
final EntropyUnits clausius = EntropyUnits('Clausius', null, 'Cl', null, 4.184, false);

/// The erg per kelvin unit of entropy.
final EntropyUnits ergPerKelvin = EntropyUnits.energyTemperature(ergs, TemperatureInterval.kelvins);

// CONSTANTS

/// The Boltzmann constant is a physical constant that relates the average
/// relative kinetic energy of particles in a gas with the temperature of the gas.
const Entropy boltzmannConstant = Entropy.constant(Double.constant(1.380649e-23));
