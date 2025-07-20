import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'energy.dart';
import 'time.dart';

// Also HeatFlowRate, RadiantFlux

/// Amount of energy per unit time.
/// See the [Wikipedia entry for Power (physics)](https://en.wikipedia.org/wiki/Power_(physics))
/// for more information.
class Power extends Quantity {
  /// Constructs a Power with watts ([W]), kilowatts ([kW]) or megawatts ([MW]).
  /// Optionally specify a relative standard uncertainty.
  // ignore: non_constant_identifier_names
  Power({dynamic W, dynamic kW, dynamic MW, double uncert = 0.0})
      : super(
            W ?? (kW ?? (MW ?? 0.0)),
            kW != null
                ? Power.kilowatts
                : (MW != null ? Power.megawatts : Power.watts),
            uncert);

  /// Constructs a instance without preferred units.
  Power.misc(dynamic conv) : super.misc(conv, Power.powerDimensions);

  /// Constructs a Power based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Power.inUnits(dynamic value, PowerUnits? units, [double uncert = 0.0])
      : super(value, units ?? Power.watts, uncert);

  /// Constructs a constant Power.
  const Power.constant(Number valueSI, {PowerUnits? units, double uncert = 0.0})
      : super.constant(valueSI, Power.powerDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions powerDimensions = Dimensions.constant(
      <String, int>{'Length': 2, 'Mass': 1, 'Time': -3},
      qType: Power);

  /// The standard SI unit.
  static final PowerUnits watts =
      PowerUnits('watts', null, 'W', null, 1.0, true);

  // Convenience.

  /// The metric unit for one thousand watts.
  static final PowerUnits kilowatts = watts.kilo() as PowerUnits;

  /// The metric unit for one million watts.
  static final PowerUnits megawatts = watts.mega() as PowerUnits;
}

/// Units acceptable for use in describing Power quantities.
class PowerUnits extends Power with Units {
  /// Constructs a instance.
  PowerUnits(String name, String? abbrev1, String? abbrev2, String? singular,
      dynamic conv,
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

  /// Constructs a instance based on energy and time units.
  PowerUnits.energyTime(EnergyUnits eu, TimeUnits tu)
      : super.misc(eu.valueSI / tu.valueSI) {
    name = '${eu.name} per ${tu.singular}';
    singular = '${eu.singular} per ${tu.singular}';
    convToMKS = eu.valueSI / tu.valueSI;
    abbrev1 = eu.abbrev1 != null && tu.abbrev1 != null
        ? '${eu.abbrev1} / ${tu.abbrev1}'
        : null;
    abbrev2 = eu.abbrev2 != null && tu.abbrev2 != null
        ? '${eu.abbrev2}${tu.abbrev2}'
        : null;
    metricBase = metricBase;
    offset = offset.toDouble();
  }

  /// Returns the Type of the Quantity to which these Units apply
  @override
  Type get quantityType => Power;

  /// Derive PowerUnits using this PowerUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      PowerUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}

/// Radiant flux is another way to express power.
class RadiantFlux extends Power {
  /// Constructs a constant RadiantFlux.
  const RadiantFlux.constant(super.valueSI, {super.units, super.uncert})
      : super.constant();
}
