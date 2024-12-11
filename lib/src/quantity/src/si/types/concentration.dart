import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'amount_of_substance.dart';
import 'volume.dart';

/// The abundance of a constituent divided by the total volume of a mixture.
/// See the [Wikipedia entry for Concentration](https://en.wikipedia.org/wiki/Concentration)
/// for more information.
class Concentration extends Quantity {
  /// Constructs a Concentration with moles per cubic meter.
  /// Optionally specify a relative standard uncertainty.
  Concentration({dynamic molesPerCubicMeter, double uncert = 0.0})
      : super(molesPerCubicMeter ?? 0.0, Concentration.molesPerCubicMeter,
            uncert);

  /// Constructs a instance without preferred units.
  Concentration.misc(dynamic conv)
      : super.misc(conv, Concentration.concentrationDimensions);

  /// Constructs a Concentration based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Concentration.inUnits(dynamic value, ConcentrationUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? Concentration.molesPerCubicMeter, uncert);

  /// Constructs a constant Concentration.
  const Concentration.constant(Number valueSI,
      {ConcentrationUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, Concentration.concentrationDimensions, units, uncert);

  /// Dimensions for this type of quantity
  static const Dimensions concentrationDimensions = Dimensions.constant(
      <String, int>{'Amount': 1, 'Length': -3},
      qType: Concentration);

  /// The standard SI unit **/
  static final ConcentrationUnits molesPerCubicMeter =
      ConcentrationUnits.amountVolume(
          AmountOfSubstance.moles, Volume.cubicMeters);
}

/// Units acceptable for use in describing Concentration quantities.
class ConcentrationUnits extends Concentration with Units {
  /// Constructs a instance.
  ConcentrationUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs concentration units from an amount of substance and volume.
  ConcentrationUnits.amountVolume(AmountOfSubstanceUnits asu, VolumeUnits vu)
      : super.misc(asu.valueSI * vu.valueSI) {
    name = '${asu.name} per ${vu.singular}';
    singular = '${asu.singular} per ${vu.singular}';
    convToMKS = asu.valueSI * vu.valueSI;
    abbrev1 = asu.abbrev1 != null && vu.abbrev1 != null
        ? '${asu.abbrev1} / ${vu.abbrev1}'
        : null;
    abbrev2 = asu.abbrev2 != null && vu.abbrev2 != null
        ? '${asu.abbrev2}/${vu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply
  @override
  Type get quantityType => Concentration;

  /// Derive ConcentrationUnits using this ConcentrationUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      ConcentrationUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
