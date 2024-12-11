import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'area.dart';
import 'power.dart';

/// The rate of transfer of energy through a surface.
/// See the [Wikipedia entry for Energy density](https://en.wikipedia.org/wiki/Energy_density)
/// for more information.
class EnergyFlux extends Quantity {
  /// Constructs an EnergyFlux with watts per square meter.
  /// Optionally specify a relative standard uncertainty.
  EnergyFlux({dynamic wattsPerSquareMeter, double uncert = 0.0})
      : super(
            wattsPerSquareMeter ?? 0.0, EnergyFlux.wattsPerSquareMeter, uncert);

  /// Constructs a instance without preferred units.
  EnergyFlux.misc(dynamic conv)
      : super.misc(conv, EnergyFlux.energyFluxDimensions);

  /// Constructs a EnergyFlux based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  EnergyFlux.inUnits(dynamic value, EnergyFluxUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? EnergyFlux.wattsPerSquareMeter, uncert);

  /// Constructs a constant EnergyFlux.
  const EnergyFlux.constant(Number valueSI,
      {EnergyFluxUnits? units, double uncert = 0.0})
      : super.constant(valueSI, EnergyFlux.energyFluxDimensions, units, uncert);

  /// Dimensions for this type of quantity
  static const Dimensions energyFluxDimensions = Dimensions.constant(
      <String, int>{'Length': 2, 'Mass': 1, 'Time': -3},
      qType: EnergyFlux);

  /// The standard SI unit.
  static final EnergyFluxUnits wattsPerSquareMeter =
      EnergyFluxUnits.powerArea(Power.watts, Area.squareMeters);
}

/// Units acceptable for use in describing EnergyFlux quantities.
class EnergyFluxUnits extends EnergyFlux with Units {
  /// Constructs a instance.
  EnergyFluxUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance from power and area units.
  EnergyFluxUnits.powerArea(PowerUnits pu, AreaUnits au)
      : super.misc(pu.valueSI * au.valueSI) {
    name = '${pu.name} per ${au.singular}';
    singular = '${pu.singular} per ${au.singular}';
    convToMKS = pu.valueSI * au.valueSI;
    abbrev1 = pu.abbrev1 != null && au.abbrev1 != null
        ? '${pu.abbrev1} / ${au.abbrev1}'
        : null;
    abbrev2 = pu.abbrev2 != null && au.abbrev2 != null
        ? '${pu.abbrev2}/${au.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => EnergyFlux;

  /// Derive EnergyFluxUnits using this EnergyFluxUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      EnergyFluxUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
