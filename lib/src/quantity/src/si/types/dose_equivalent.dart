import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';

/// Represents the stochastic health effects (probability of cancer induction and genetic damage)
/// of ionizing radiation on the human body.
/// See the [Wikipedia entry for Equivalent dose](https://en.wikipedia.org/wiki/Equivalent_dose)
/// for more information.
class DoseEquivalent extends Quantity {
  /// Constructs a DoseEquivalent with seiverts ([Sv]) or [rems].
  /// Optionally specify a relative standard uncertainty.
  // ignore: non_constant_identifier_names
  DoseEquivalent({dynamic Sv, dynamic rems, double uncert = 0.0})
      : super(
            Sv ?? rems ?? 0.0,
            rems != null ? DoseEquivalent.rems : DoseEquivalent.seiverts,
            uncert);

  /// Constructs a instance without preferred units.
  DoseEquivalent.misc(dynamic conv)
      : super.misc(conv, DoseEquivalent.doseEquivalentDimensions);

  /// Constructs a DoseEquivalent based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  DoseEquivalent.inUnits(dynamic value, DoseEquivalentUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? DoseEquivalent.seiverts, uncert);

  /// Constructs a constant DoseEquivalent.
  const DoseEquivalent.constant(Number valueSI,
      {DoseEquivalentUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, DoseEquivalent.doseEquivalentDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions doseEquivalentDimensions = Dimensions.constant(
      <String, int>{'Length': 2, 'Time': -2},
      qType: DoseEquivalent);

  /// The standard SI unit.
  static final DoseEquivalentUnits seiverts =
      DoseEquivalentUnits('seiverts', null, 'Sv', null, 1.0, true);

  /// Accepted for use with the SI, subject to further review.
  static final DoseEquivalentUnits rems =
      DoseEquivalentUnits('rems', null, null, null, 1.0e-2, true);
}

/// Units acceptable for use in describing DoseEquivalent quantities.
class DoseEquivalentUnits extends DoseEquivalent with Units {
  /// Constructs a instance.
  DoseEquivalentUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => DoseEquivalent;

  /// Derive DoseEquivalentUnits using this DoseEquivalentUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      DoseEquivalentUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
