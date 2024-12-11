import '../../../quantity_ext.dart';
import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'time.dart';

/// The mean energy imparted to matter per unit mass by ionizing radiation.
/// See the [Wikipedia entry for Absorbed Dose](https://en.wikipedia.org/wiki/Absorbed_dose)
/// for more information.
class AbsorbedDose extends Quantity {
  /// Construct an AbsorbedDose with either grays ([Gy]) or rads ([rads]).
  /// Optionally specify a relative standard uncertainty.
  // ignore: non_constant_identifier_names
  AbsorbedDose({dynamic Gy, dynamic rads, double uncert = 0.0})
      : super(Gy ?? (rads ?? 0.0),
            rads != null ? AbsorbedDose.rads : AbsorbedDose.grays, uncert);

  /// Constructs a instance without preferred units.
  AbsorbedDose.misc(dynamic conv)
      : super.misc(conv, AbsorbedDose.absorbedDoseDimensions);

  /// Constructs an AbsorbedDose based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  AbsorbedDose.inUnits(dynamic value, AbsorbedDoseUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? AbsorbedDose.grays, uncert);

  /// Constructs a constant AbsorbedDose.
  const AbsorbedDose.constant(Number valueSI,
      {AbsorbedDoseUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, AbsorbedDose.absorbedDoseDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions absorbedDoseDimensions = Dimensions.constant(
      <String, int>{'Length': 2, 'Time': -2},
      qType: AbsorbedDose);

  /// The standard SI unit.
  static final AbsorbedDoseUnits grays =
      AbsorbedDoseUnits('grays', null, 'Gy', null, 1.0, true);

  /// Accepted for use with the SI, subject to further review.
  // Note:  do not use 'rad' for singular to avoid confusion with
  // Angle's radians during parsing & output
  static final AbsorbedDoseUnits rads =
      AbsorbedDoseUnits('rads', null, null, 'rads', 1.0e-2, true);
}

/// Units acceptable for use in describing AbsorbedDose quantities.
class AbsorbedDoseUnits extends AbsorbedDose with Units {
  /// Constructs a instance.
  AbsorbedDoseUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance based on length and time units.
  AbsorbedDoseUnits.lengthTimeUnits(LengthUnits lu, TimeUnits su)
      : super.misc(lu.valueSI * su.valueSI) {
    name = '${lu.name} per ${su.singular} squared';
    singular = '${lu.singular} per ${su.singular} squared';
    convToMKS = lu.valueSI * su.valueSI;
    abbrev1 = lu.abbrev1 != null && su.abbrev1 != null
        ? '${lu.abbrev1} / ${su.abbrev1}'
        : null;
    abbrev2 = lu.abbrev2 != null && su.abbrev2 != null
        ? '${lu.abbrev2}${su.abbrev2}'
        : null;
    metricBase = metricBase;
    offset = offset.toDouble();
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => AbsorbedDose;

  /// Derive AbsorbedDoseUnits using this AbsorbedDoseUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      AbsorbedDoseUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
