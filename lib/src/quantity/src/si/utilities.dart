import 'dart:collection';
import 'package:logging/logging.dart';
import '../../quantity_ext.dart';
import 'dimensions.dart';
import 'dimensions_exception.dart';
import 'misc_quantity.dart';
import 'quantity.dart';
import 'types/absorbed_dose.dart';
import 'types/absorbed_dose_rate.dart';
import 'types/acceleration.dart';
import 'types/activity.dart';
import 'types/amount_of_substance.dart';
import 'types/angle.dart';
import 'types/angular_acceleration.dart';
import 'types/angular_momentum.dart';
import 'types/angular_speed.dart';
import 'types/area.dart';
import 'types/capacitance.dart';
import 'types/catalytic_activity.dart';
import 'types/charge.dart';
import 'types/charge_density.dart';
import 'types/concentration.dart';
import 'types/conductance.dart';
import 'types/currency.dart';
import 'types/current.dart';
import 'types/current_density.dart';
import 'types/dose_equivalent.dart';
import 'types/dynamic_viscosity.dart';
import 'types/electric_field_strength.dart';
import 'types/electric_flux_density.dart';
import 'types/electric_potential_difference.dart';
import 'types/energy.dart';
import 'types/energy_density.dart';
import 'types/energy_flux.dart';
import 'types/entropy.dart';
import 'types/exposure.dart';
import 'types/force.dart';
import 'types/frequency.dart';
import 'types/heat_flux_density.dart';
import 'types/illuminance.dart';
import 'types/inductance.dart';
import 'types/information.dart';
import 'types/information_rate.dart';
import 'types/kinematic_viscosity.dart';
import 'types/length.dart';
import 'types/level.dart';
import 'types/luminance.dart';
import 'types/luminous_flux.dart';
import 'types/luminous_intensity.dart';
import 'types/magnetic_field_strength.dart';
import 'types/magnetic_flux.dart';
import 'types/magnetic_flux_density.dart';
import 'types/mass.dart';
import 'types/mass_density.dart';
import 'types/mass_flow_rate.dart';
import 'types/mass_flux_density.dart';
import 'types/molar_energy.dart';
import 'types/molar_entropy.dart';
import 'types/permeability.dart';
import 'types/permittivity.dart';
import 'types/power.dart';
import 'types/pressure.dart';
import 'types/radiance.dart';
import 'types/radiant_intensity.dart';
import 'types/resistance.dart';
import 'types/scalar.dart';
import 'types/solid_angle.dart';
import 'types/specific_energy.dart';
import 'types/specific_heat_capacity.dart';
import 'types/specific_volume.dart';
import 'types/spectral_irradiance.dart';
import 'types/speed.dart';
import 'types/surface_tension.dart';
import 'types/temperature.dart';
import 'types/temperature_interval.dart';
import 'types/thermal_conductivity.dart';
import 'types/time.dart';
import 'types/time_instant.dart';
import 'types/torque.dart';
import 'types/volume.dart';
import 'types/volume_flow_rate.dart';
import 'types/wave_number.dart';
import 'units.dart';

/// Logger for use across entire library
Logger logger = Logger('quantity core')
  ..onRecord.listen((LogRecord record) {
    // ignore: avoid_print
    print('${record.level}: ${record.message}');
    // ignore: avoid_print
    if (record.error != null) print('   ERROR:  ${record.error}');
    // ignore: avoid_print
    if (record.stackTrace != null) print(record.stackTrace);
  });

/// Dynamic quantity typing may be turned off for increased
/// efficiency.  If false, the result of operations where
/// dimensions may change will be MiscQuantity type objects.
bool dynamicQuantityTyping = true;

/// Maps each quantity type to a function that can be used to create an instance of that type.
final LinkedHashMap<Type, Function> _typeInstantiatorMap =
    LinkedHashMap<Type, Function>.from(<Type, Function>{
  AbsorbedDose: (dynamic value, AbsorbedDoseUnits? units, double uncert) =>
      AbsorbedDose.inUnits(value, units, uncert),
  AbsorbedDoseRate:
      (dynamic value, AbsorbedDoseRateUnits? units, double uncert) =>
          AbsorbedDoseRate.inUnits(value, units, uncert),
  Acceleration: (dynamic value, AccelerationUnits? units, double uncert) =>
      Acceleration.inUnits(value, units, uncert),
  Activity: (dynamic value, ActivityUnits? units, double uncert) =>
      Activity.inUnits(value, units, uncert),
  AmountOfSubstance:
      (dynamic value, AmountOfSubstanceUnits? units, double uncert) =>
          AmountOfSubstance.inUnits(value, units, uncert),
  Angle: (dynamic value, AngleUnits? units, double uncert) =>
      Angle.inUnits(value, units, uncert),
  AngularAcceleration:
      (dynamic value, AngularAccelerationUnits? units, double uncert) =>
          AngularAcceleration.inUnits(value, units, uncert),
  AngularMomentum:
      (dynamic value, AngularMomentumUnits? units, double uncert) =>
          AngularMomentum.inUnits(value, units, uncert),
  AngularSpeed: (dynamic value, AngularSpeedUnits? units, double uncert) =>
      AngularSpeed.inUnits(value, units, uncert),
  Area: (dynamic value, AreaUnits? units, double uncert) =>
      Area.inUnits(value, units, uncert),
  Capacitance: (dynamic value, CapacitanceUnits? units, double uncert) =>
      Capacitance.inUnits(value, units, uncert),
  CatalyticActivity:
      (dynamic value, CatalyticActivityUnits? units, double uncert) =>
          CatalyticActivity.inUnits(value, units, uncert),
  Charge: (dynamic value, ChargeUnits? units, double uncert) =>
      Charge.inUnits(value, units, uncert),
  ChargeDensity: (dynamic value, ChargeDensityUnits? units, double uncert) =>
      ChargeDensity.inUnits(value, units, uncert),
  Concentration: (dynamic value, ConcentrationUnits? units, double uncert) =>
      Concentration.inUnits(value, units, uncert),
  Conductance: (dynamic value, ConductanceUnits? units, double uncert) =>
      Conductance.inUnits(value, units, uncert),
  Currency: (dynamic value, CurrencyUnits? units, double uncert) =>
      Currency.inUnits(value, units, uncert),
  Current: (dynamic value, CurrentUnits? units, double uncert) =>
      Current.inUnits(value, units, uncert),
  CurrentDensity: (dynamic value, CurrentDensityUnits? units, double uncert) =>
      CurrentDensity.inUnits(value, units, uncert),
  DoseEquivalent: (dynamic value, DoseEquivalentUnits? units, double uncert) =>
      DoseEquivalent.inUnits(value, units, uncert),
  DynamicViscosity:
      (dynamic value, DynamicViscosityUnits? units, double uncert) =>
          DynamicViscosity.inUnits(value, units, uncert),
  ElectricFieldStrength:
      (dynamic value, ElectricFieldStrengthUnits? units, double uncert) =>
          ElectricFieldStrength.inUnits(value, units, uncert),
  ElectricFluxDensity:
      (dynamic value, ElectricFluxDensityUnits? units, double uncert) =>
          ElectricFluxDensity.inUnits(value, units, uncert),
  ElectricPotentialDifference:
      (dynamic value, ElectricPotentialDifferenceUnits? units, double uncert) =>
          ElectricPotentialDifference.inUnits(value, units, uncert),
  Energy: (dynamic value, EnergyUnits? units, double uncert) =>
      Energy.inUnits(value, units, uncert),
  EnergyDensity: (dynamic value, EnergyDensityUnits? units, double uncert) =>
      EnergyDensity.inUnits(value, units, uncert),
  EnergyFlux: (dynamic value, EnergyFluxUnits? units, double uncert) =>
      EnergyFlux.inUnits(value, units, uncert),
  Entropy: (dynamic value, EntropyUnits? units, double uncert) =>
      Entropy.inUnits(value, units, uncert),
  Exposure: (dynamic value, ExposureUnits? units, double uncert) =>
      Exposure.inUnits(value, units, uncert),
  FieldLevel: (dynamic value, LevelUnits? units, double uncert) =>
      FieldLevel.inUnits(value, units, uncert),
  Force: (dynamic value, ForceUnits? units, double uncert) =>
      Force.inUnits(value, units, uncert),
  Frequency: (dynamic value, FrequencyUnits? units, double uncert) =>
      Frequency.inUnits(value, units, uncert),
  HeatFluxDensity:
      (dynamic value, HeatFluxDensityUnits? units, double uncert) =>
          HeatFluxDensity.inUnits(value, units, uncert),
  Illuminance: (dynamic value, IlluminanceUnits? units, double uncert) =>
      Illuminance.inUnits(value, units, uncert),
  Inductance: (dynamic value, InductanceUnits? units, double uncert) =>
      Inductance.inUnits(value, units, uncert),
  Information: (dynamic value, InformationUnits? units, double uncert) =>
      Information.inUnits(value, units, uncert),
  InformationRate:
      (dynamic value, InformationRateUnits? units, double uncert) =>
          InformationRate.inUnits(value, units, uncert),
  KinematicViscosity:
      (dynamic value, KinematicViscosityUnits? units, double uncert) =>
          KinematicViscosity.inUnits(value, units, uncert),
  Length: (dynamic value, LengthUnits? units, double uncert) =>
      Length.inUnits(value, units, uncert),
  Luminance: (dynamic value, LuminanceUnits? units, double uncert) =>
      Luminance.inUnits(value, units, uncert),
  LuminousFlux: (dynamic value, LuminousFluxUnits? units, double uncert) =>
      LuminousFlux.inUnits(value, units, uncert),
  LuminousIntensity:
      (dynamic value, LuminousIntensityUnits? units, double uncert) =>
          LuminousIntensity.inUnits(value, units, uncert),
  MagneticFieldStrength:
      (dynamic value, MagneticFieldStrengthUnits? units, double uncert) =>
          MagneticFieldStrength.inUnits(value, units, uncert),
  MagneticFlux: (dynamic value, MagneticFluxUnits? units, double uncert) =>
      MagneticFlux.inUnits(value, units, uncert),
  MagneticFluxDensity:
      (dynamic value, MagneticFluxDensityUnits? units, double uncert) =>
          MagneticFluxDensity.inUnits(value, units, uncert),
  Mass: (dynamic value, MassUnits? units, double uncert) =>
      Mass.inUnits(value, units, uncert),
  MassDensity: (dynamic value, MassDensityUnits? units, double uncert) =>
      MassDensity.inUnits(value, units, uncert),
  MassFlowRate: (dynamic value, MassFlowRateUnits? units, double uncert) =>
      MassFlowRate.inUnits(value, units, uncert),
  MassFluxDensity:
      (dynamic value, MassFluxDensityUnits? units, double uncert) =>
          MassFluxDensity.inUnits(value, units, uncert),
  MolarEnergy: (dynamic value, MolarEnergyUnits? units, double uncert) =>
      MolarEnergy.inUnits(value, units, uncert),
  MolarEntropy: (dynamic value, MolarEntropyUnits? units, double uncert) =>
      MolarEntropy.inUnits(value, units, uncert),
  Permeability: (dynamic value, PermeabilityUnits? units, double uncert) =>
      Permeability.inUnits(value, units, uncert),
  Permittivity: (dynamic value, PermittivityUnits? units, double uncert) =>
      Permittivity.inUnits(value, units, uncert),
  Power: (dynamic value, PowerUnits? units, double uncert) =>
      Power.inUnits(value, units, uncert),
  PowerLevel: (dynamic value, LevelUnits? units, double uncert) =>
      PowerLevel.inUnits(value, units, uncert),
  Pressure: (dynamic value, PressureUnits? units, double uncert) =>
      Pressure.inUnits(value, units, uncert),
  Radiance: (dynamic value, RadianceUnits? units, double uncert) =>
      Radiance.inUnits(value, units, uncert),
  RadiantIntensity:
      (dynamic value, RadiantIntensityUnits? units, double uncert) =>
          RadiantIntensity.inUnits(value, units, uncert),
  Resistance: (dynamic value, ResistanceUnits? units, double uncert) =>
      Resistance.inUnits(value, units, uncert),
  Scalar: (dynamic value, ScalarUnits? units, double uncert) =>
      Scalar.inUnits(value, units, uncert),
  SolidAngle: (dynamic value, SolidAngleUnits? units, double uncert) =>
      SolidAngle.inUnits(value, units, uncert),
  SpecificEnergy: (dynamic value, SpecificEnergyUnits? units, double uncert) =>
      SpecificEnergy.inUnits(value, units, uncert),
  SpecificHeatCapacity:
      (dynamic value, SpecificHeatCapacityUnits? units, double uncert) =>
          SpecificHeatCapacity.inUnits(value, units, uncert),
  SpecificVolume: (dynamic value, SpecificVolumeUnits? units, double uncert) =>
      SpecificVolume.inUnits(value, units, uncert),
  SpectralIrradiance:
      (dynamic value, SpectralIrradianceUnits? units, double uncert) =>
          SpectralIrradiance.inUnits(value, units, uncert),
  Speed: (dynamic value, SpeedUnits? units, double uncert) =>
      Speed.inUnits(value, units, uncert),
  SurfaceTension: (dynamic value, SurfaceTensionUnits? units, double uncert) =>
      SurfaceTension.inUnits(value, units, uncert),
  Temperature: (dynamic value, TemperatureUnits? units, double uncert) =>
      Temperature.inUnits(value, units, uncert),
  TemperatureInterval:
      (dynamic value, TemperatureIntervalUnits? units, double uncert) =>
          TemperatureInterval.inUnits(value, units, uncert),
  ThermalConductivity:
      (dynamic value, ThermalConductivityUnits? units, double uncert) =>
          ThermalConductivity.inUnits(value, units, uncert),
  Time: (dynamic value, TimeUnits? units, double uncert) =>
      Time.inUnits(value, units, uncert),
  TimeInstant: (dynamic value, TimeInstantUnits? units, double uncert) =>
      TimeInstant.inUnits(value, units, uncert),
  Torque: (dynamic value, TorqueUnits? units, double uncert) =>
      Torque.inUnits(value, units, uncert),
  Volume: (dynamic value, VolumeUnits? units, double uncert) =>
      Volume.inUnits(value, units, uncert),
  VolumeFlowRate: (dynamic value, VolumeFlowRateUnits? units, double uncert) =>
      VolumeFlowRate.inUnits(value, units, uncert),
  WaveNumber: (dynamic value, WaveNumberUnits? units, double uncert) =>
      WaveNumber.inUnits(value, units, uncert)
});

///  Returns whether or not [q] is one of the seven SI base quantities.
///
///  * If a quantity is not one of the seven base SI quantities, then it is a derived quantity.
///  * The seven base SI Quantities are [Length], [Mass], [Duration],
///  [Temperature], [Current], [LuminousIntensity] and [AmountOfSubstance].
bool siBaseQuantity(Quantity q) =>
    q is Length ||
    q is Mass ||
    q is Time ||
    q is Current ||
    q is TemperatureInterval ||
    q is Temperature ||
    q is AmountOfSubstance ||
    q is LuminousIntensity;

/// Returns whether or not the magnitude of the difference between two
/// quantities is less than or equal to the specified [tolerance].
bool areWithin(Quantity q1, Quantity q2, Quantity tolerance) {
  if (q1.dimensions != q2.dimensions || q2.dimensions != tolerance.dimensions) {
    throw DimensionsException(
        'The two quantities and tolerance must have the same dimensions');
  }

  return (q1 - q2).abs().valueSI <= tolerance.valueSI;
}

/// Returns whether or not [q] is a derived quantity (as
/// opposed to one of the seven base SI quantities).
///
/// * If a quantity is not one of the seven base SI quantities, then it is
///   a derived quantity.
/// * The seven base SI Quantities are Length, Mass, Duration,
///   Temperature, ElectricCurrent, LuminousIntensity and AmountOfSubstance.
/// * The two auxiliary angle-related base quantities (Angle and SolidAngle)
///   will return true as they are not proper base quantities but special
///   cases of Scalar quantities used by convention.
bool siDerivedQuantity(Quantity q) => !siBaseQuantity(q);

/// Returns an iterable of Type objects representing all of the quantity types
/// supported by this library (for example, Angle, Length, etc.).
///
///  * The Iterable provides the types in alphabetical order.
///  * [MiscQuantity] is not included (as it is a catch-all for
///    all quantity types that are NOT explicitly supported).
Iterable<Type> get allQuantityTypes => _typeInstantiatorMap.keys;

/// Creates a instance of a typed quantity of type [t] having the specified
/// [value] in [units].
///
/// If type [t] is not recognized a [MiscQuantity] with [value] and the dimensions
/// of [units] will be created and returned instead.  If units are null and the
/// the type is not recognized, then [dimensions] must be provided in order to
/// construct a MiscQuantity.  A DimensionsException will be thrown if null units
/// and null dimensions are detected for types that don't have an associated
/// instantiator.
///
/// The quantity's relative uncertainty can optionally be provided (defaults to 0).
Quantity createTypedQuantityInstance(Type t, dynamic value, Units? units,
    {double uncert = 0.0, Dimensions? dimensions}) {
  final quantityInstantiator = _typeInstantiatorMap[t];
  if (quantityInstantiator != null) {
    return Function.apply(quantityInstantiator, <dynamic>[value, units, uncert])
        as Quantity;
  }

  // Fall back to MiscQuantity.
  if (dimensions == null) {
    throw DimensionsException(
        'Dimensions must be provided if units are not when creating an instance of an unrecognized quantity type');
  }
  return MiscQuantity(value, (units as Quantity).dimensions, uncert);
}

/// Maps a digit, decimal point or minus sign string to a unicode exponent character.
const Map<String, String> expUnicodeMap = <String, String>{
  '0': '\u{2070}',
  '1': '\u{00b9}',
  '2': '\u{00b2}',
  '3': '\u{00b3}',
  '4': '\u{2074}',
  '5': '\u{2075}',
  '6': '\u{2076}',
  '7': '\u{2077}',
  '8': '\u{2078}',
  '9': '\u{2079}',
  '.': '\u{02d9}',
  '-': '\u{207b}',
};

/// Returns the unicode symbols that represent an exponent.
String unicodeExponent(num exp) {
  final neg = exp < 0 ? '\u{207b}' : '';
  final absExp = exp.abs();
  final expStr = absExp.toString();
  final buf = StringBuffer()..write(neg);
  for (var place = 0; place < expStr.length; place++) {
    buf.write(expUnicodeMap[expStr[place]]);
  }

  return buf.toString();
}
