import '../../../quantity_ext.dart';
import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'power.dart';
import 'temperature_interval.dart';

/// The ability of a material to conduct heat.
/// See the [Wikipedia entry for Thermal conductivity](https://en.wikipedia.org/wiki/Thermal_conductivity)
/// for more information.
class ThermalConductivity extends Quantity {
  /// Constructs a ThermalConductivity with watts per meter kelvin.
  /// Optionally specify a relative standard uncertainty.
  ThermalConductivity({dynamic wattsPerMeterKelvin, double uncert = 0.0})
      : super(wattsPerMeterKelvin ?? 0.0,
            ThermalConductivity.wattsPerMeterKelvin, uncert);

  /// Constructs a instance without preferred units.
  ThermalConductivity.misc(dynamic conv)
      : super.misc(conv, ThermalConductivity.thermalConductivityDimensions);

  /// Constructs a ThermalConductivity based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  ThermalConductivity.inUnits(dynamic value, ThermalConductivityUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? ThermalConductivity.wattsPerMeterKelvin, uncert);

  /// Constructs a constant ThermalConductivity.
  const ThermalConductivity.constant(Number valueSI,
      {ThermalConductivityUnits? units, double uncert = 0.0})
      : super.constant(valueSI,
            ThermalConductivity.thermalConductivityDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions thermalConductivityDimensions = Dimensions.constant(
      <String, int>{'Length': 1, 'Mass': 1, 'Time': -3, 'Temperature': -1},
      qType: ThermalConductivity);

  /// The standard SI unit.
  static final ThermalConductivityUnits wattsPerMeterKelvin =
      ThermalConductivityUnits.powerLengthTemperature(
          Power.watts, LengthUnits.meters, TemperatureInterval.kelvins);
}

/// Units acceptable for use in describing ThermalConductivity quantities.
class ThermalConductivityUnits extends ThermalConductivity with Units {
  /// Constructs a instance.
  ThermalConductivityUnits(String name, String? abbrev1, String? abbrev2,
      String? singular, dynamic conv,
      [bool metricBase = false, num offset = 0.0])
      : super.misc(conv) {
    this.name = name;
    this.singular = singular;
    convToMKS = objToNumber(conv);
    this.abbrev1 = abbrev1;
    this.abbrev2 = abbrev2;
    this.metricBase = metricBase;
    this.offset = offset.toDouble();
  }

  /// Constructs a instance based on power, length and temperature interval units.
  ThermalConductivityUnits.powerLengthTemperature(
      PowerUnits pu, LengthUnits lu, TemperatureIntervalUnits tiu)
      : super.misc(pu.valueSI / (lu.valueSI * tiu.valueSI)) {
    name = '${pu.name} per ${lu.singular} ${tiu.singular}';
    singular = '${pu.singular} per ${lu.singular} ${tiu.singular}';
    convToMKS = pu.valueSI / (lu.valueSI * tiu.valueSI);
    abbrev1 = pu.abbrev1 != null && lu.abbrev1 != null
        ? '${pu.abbrev1} / ${lu.abbrev1} ${tiu.abbrev1}'
        : null;
    abbrev2 = pu.abbrev2 != null && lu.abbrev2 != null
        ? '${pu.abbrev2}/${lu.abbrev2}${tiu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply
  @override
  Type get quantityType => ThermalConductivity;

  /// Derive ThermalConductivityUnits using this ThermalConductivityUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      ThermalConductivityUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
