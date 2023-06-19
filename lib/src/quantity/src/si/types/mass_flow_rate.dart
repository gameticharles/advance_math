import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'mass.dart';
import 'time.dart';

/// The mass of a substance which passes per unit of time.
/// See the [Wikipedia entry for Mass flow rate](https://en.wikipedia.org/wiki/Mass_flow_rate)
/// for more information.
class MassFlowRate extends Quantity {
  /// Constructs a MassFlowRate with kilograms per second.
  /// Optionally specify a relative standard uncertainty.
  MassFlowRate({dynamic kilogramsPerSecond, double uncert = 0.0})
      : super(
            kilogramsPerSecond ?? 0.0, MassFlowRate.kilogramsPerSecond, uncert);

  /// Constructs a instance without preferred units.
  MassFlowRate.misc(dynamic conv)
      : super.misc(conv, MassFlowRate.massFlowRateDimensions);

  /// Constructs a MassFlowRate based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  MassFlowRate.inUnits(dynamic value, MassFlowRateUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? MassFlowRate.kilogramsPerSecond, uncert);

  /// Construct a constant MassFlowRate.
  const MassFlowRate.constant(Number valueSI,
      {MassFlowRateUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, MassFlowRate.massFlowRateDimensions, units, uncert);

  /// Dimensions for this type of quantity
  static const Dimensions massFlowRateDimensions = Dimensions.constant(
      <String, int>{'Mass': 1, 'Time': -1},
      qType: MassFlowRate);

  /// The standard SI unit.
  static final MassFlowRateUnits kilogramsPerSecond =
      MassFlowRateUnits.massTime(Mass.kilograms, Time.seconds);
}

/// Units acceptable for use in describing MassFlowRate quantities.
class MassFlowRateUnits extends MassFlowRate with Units {
  /// Constructs a instance.
  MassFlowRateUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance based on mass and time units.
  MassFlowRateUnits.massTime(MassUnits mu, TimeUnits tu)
      : super.misc(mu.valueSI * tu.valueSI) {
    name = '${mu.name} per ${tu.singular}';
    singular = '${mu.singular} per ${tu.singular}';
    convToMKS = mu.valueSI * tu.valueSI;
    abbrev1 = mu.abbrev1 != null && tu.abbrev1 != null
        ? '${mu.abbrev1} / ${tu.abbrev1}'
        : null;
    abbrev2 = mu.abbrev2 != null && tu.abbrev2 != null
        ? '${mu.abbrev2}${tu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply
  @override
  Type get quantityType => MassFlowRate;

  /// Derive MassFlowRateUnits using this MassFlowRateUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      MassFlowRateUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
