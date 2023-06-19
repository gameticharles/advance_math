import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';

/// The increase in rate of a chemical reaction caused by the presence of a catalyst.
/// See the [Wikipedia entry for Catalysis](https://en.wikipedia.org/wiki/Catalysis)
/// for more information.
class CatalyticActivity extends Quantity {
  /// Constructs a CatalyticActivity with katals ([kat]).
  /// Optionally specify a relative standard uncertainty.
  CatalyticActivity({dynamic kat, double uncert = 0.0})
      : super(kat ?? 0.0, CatalyticActivity.katals, uncert);

  /// Constructs a instance without preferred units.
  CatalyticActivity.misc(dynamic conv)
      : super.misc(conv, CatalyticActivity.catalyticActivityDimensions);

  /// Constructs a CatalyticActivity based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  CatalyticActivity.inUnits(dynamic value, CatalyticActivityUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? CatalyticActivity.katals, uncert);

  /// Constructs a constant CatalyticActivity.
  const CatalyticActivity.constant(Number valueSI,
      {CatalyticActivityUnits? units, double uncert = 0.0})
      : super.constant(valueSI, CatalyticActivity.catalyticActivityDimensions,
            units, uncert);

  /// Dimensions for this type of quantity
  static const Dimensions catalyticActivityDimensions = Dimensions.constant(
      <String, int>{'Amount': 1, 'Time': -1},
      qType: CatalyticActivity);

  /// The standard SI unit **/
  static final CatalyticActivityUnits katals =
      CatalyticActivityUnits('katals', 'kat', null, 'katal', 1.0, true);
}

/// Units acceptable for use in describing CatalyticActivity quantities.
class CatalyticActivityUnits extends CatalyticActivity with Units {
  /// Constructs a instance.
  CatalyticActivityUnits(String name, String? abbrev1, String? abbrev2,
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
  Type get quantityType => CatalyticActivity;

  /// Derive CatalyticActivityUnits using this CatalyticActivityUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      CatalyticActivityUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
