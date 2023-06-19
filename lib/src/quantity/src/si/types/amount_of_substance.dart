import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';

/// The size of an ensemble of elementary entities, such as atoms, molecules, electrons, and other particles.
/// See the [Wikipedia entry for Amount of substance](https://en.wikipedia.org/wiki/Amount_of_substance)
/// for more information.
class AmountOfSubstance extends Quantity {
  /// Construct an AmountOfSubstance with moles ([mol])
  /// or kilomoles ([kmol]).
  /// Optionally specify a relative standard uncertainty.
  AmountOfSubstance({dynamic mol, dynamic kmol, double uncert = 0.0})
      : super(
            mol ?? (kmol ?? 0.0),
            kmol != null
                ? AmountOfSubstance.kilomoles
                : AmountOfSubstance.moles,
            uncert);

  /// Constructs a instance without preferred units.
  AmountOfSubstance.misc(dynamic conv)
      : super.misc(conv, AmountOfSubstance.amountOfSubstanceDimensions);

  /// Constructs a AmountOfSubstance based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  AmountOfSubstance.inUnits(dynamic value, AmountOfSubstanceUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? AmountOfSubstance.moles, uncert);

  /// Constructs a constant AmountOfSubstance.
  const AmountOfSubstance.constant(Number valueSI,
      {AmountOfSubstanceUnits? units, double uncert = 0.0})
      : super.constant(valueSI, AmountOfSubstance.amountOfSubstanceDimensions,
            units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions amountOfSubstanceDimensions =
      Dimensions.constant(<String, int>{'Amount': 1}, qType: AmountOfSubstance);

  /// The standard SI unit.
  static final AmountOfSubstanceUnits moles =
      AmountOfSubstanceUnits('moles', null, 'mol', null, 1.0, true);

  /// A common metric derivative of the standard SI unit.
  static final AmountOfSubstanceUnits kilomoles =
      moles.kilo() as AmountOfSubstanceUnits;
}

/// Units acceptable for use in describing [AmountOfSubstance] quantities.
class AmountOfSubstanceUnits extends AmountOfSubstance with Units {
  /// Constructs a instance.
  AmountOfSubstanceUnits(String name, String? abbrev1, String? abbrev2,
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
  Type get quantityType => AmountOfSubstance;

  /// Derive AmountOfSubstanceUnits using this AmountOfSubstanceUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      AmountOfSubstanceUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
