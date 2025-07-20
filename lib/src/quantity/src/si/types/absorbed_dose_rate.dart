import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'absorbed_dose.dart';
import 'time.dart';

/// The rate of mean energy imparted to matter per unit mass by ionizing radiation.
/// See the [Wikipedia entry for Absorbed Dose](https://en.wikipedia.org/wiki/Absorbed_dose)
/// for more information.
class AbsorbedDoseRate extends Quantity {
  /// Construct an AbsorbedDoseRate with either grays per second or rads per second.
  /// Optionally specify a relative standard uncertainty.
  AbsorbedDoseRate(
      {dynamic graysPerSecond, dynamic radsPerSecond, double uncert = 0.0})
      : super(
            graysPerSecond ?? (radsPerSecond ?? 0.0),
            radsPerSecond != null
                ? AbsorbedDoseRate.radsPerSecond
                : AbsorbedDoseRate.graysPerSecond,
            uncert);

  /// Constructs a instance without preferred units.
  AbsorbedDoseRate.misc(dynamic conv)
      : super.misc(conv, AbsorbedDoseRate.absorbedDoseRateDimensions);

  /// Constructs an AbsorbedDoseRate based on the [value]
  /// and the conversion factor intrinsic to the provided [units].
  AbsorbedDoseRate.inUnits(dynamic value, AbsorbedDoseRateUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? AbsorbedDoseRate.graysPerSecond, uncert);

  /// Constructs a constant AbsorbedDoseRate with its SI value.
  const AbsorbedDoseRate.constant(Number valueSI,
      {AbsorbedDoseRateUnits? units, double uncert = 0.0})
      : super.constant(valueSI, AbsorbedDoseRate.absorbedDoseRateDimensions,
            units, uncert);

  /// Dimensions for this type of quantity
  static const Dimensions absorbedDoseRateDimensions = Dimensions.constant(
      <String, int>{'Length': 2, 'Time': -3},
      qType: AbsorbedDoseRate);

  /// The standard SI unit.
  static final AbsorbedDoseRateUnits graysPerSecond =
      AbsorbedDoseRateUnits.absorbedDoseTime(AbsorbedDose.grays, Time.seconds);

  /// Accepted for use with the SI.
  static final AbsorbedDoseRateUnits radsPerSecond =
      AbsorbedDoseRateUnits.absorbedDoseTime(AbsorbedDose.rads, Time.seconds);
}

/// Units acceptable for use in describing AbsorbedDoseRate quantities.
class AbsorbedDoseRateUnits extends AbsorbedDoseRate with Units {
  /// Constructs a instance.
  AbsorbedDoseRateUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance based on absorbed dose and time units.
  AbsorbedDoseRateUnits.absorbedDoseTime(AbsorbedDoseUnits adu, TimeUnits tu)
      : super.misc(adu.valueSI * tu.valueSI) {
    name = '${adu.name} per ${tu.singular} squared';
    singular = '${adu.singular} per ${tu.singular} squared';
    convToMKS = adu.valueSI * tu.valueSI;
    abbrev1 = adu.abbrev1 != null && tu.abbrev1 != null
        ? '${adu.abbrev1} / ${tu.abbrev1}'
        : null;
    abbrev2 = adu.abbrev2 != null && tu.abbrev2 != null
        ? '${adu.abbrev2}${tu.abbrev2}'
        : null;
    metricBase = metricBase;
    offset = offset.toDouble();
  }

  /// Returns the Type of the Quantity to which these Units apply
  @override
  Type get quantityType => AbsorbedDoseRate;

  /// Derive AbsorbedDoseRateUnits using this AbsorbedDoseRateUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      AbsorbedDoseRateUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
