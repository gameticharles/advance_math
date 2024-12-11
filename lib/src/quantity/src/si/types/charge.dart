import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'current.dart';
import 'time.dart';

/// The property of matter that causes it to experience a force when placed in an
/// electromagnetic field
/// See the [Wikipedia entry for Electric charge](https://en.wikipedia.org/wiki/Electric_charge)
/// for more information.
class Charge extends Quantity {
  /// Constructs a Charge with coulombs ([C]).
  /// Optionally specify a relative standard uncertainty.
  Charge({dynamic C, double uncert = 0.0})
      : super(C ?? 0.0, Charge.coulombs, uncert);

  /// Constructs a instance without preferred units.
  Charge.misc(dynamic conv) : super.misc(conv, Charge.electricChargeDimensions);

  /// Constructs a Charge based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Charge.inUnits(dynamic value, ChargeUnits? units, [double uncert = 0.0])
      : super(value, units ?? Charge.coulombs, uncert);

  /// Constructs a constant Charge.
  const Charge.constant(Number valueSI,
      {ChargeUnits? units, double uncert = 0.0})
      : super.constant(valueSI, Charge.electricChargeDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions electricChargeDimensions = Dimensions.constant(
      <String, int>{'Current': 1, 'Time': 1},
      qType: Charge);

  /// The standard SI unit.
  static final ChargeUnits coulombs =
      ChargeUnits('coulombs', null, 'C', null, 1.0, true);
}

/// Units acceptable for use in describing Charge quantities.
class ChargeUnits extends Charge with Units {
  /// Constructs a instance.
  ChargeUnits(String name, String? abbrev1, String? abbrev2, String? singular,
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

  /// Constructs a instance from an electric current and time.
  ChargeUnits.currentTime(CurrentUnits cu, TimeUnits tu)
      : super.misc(cu.valueSI * tu.valueSI) {
    name = '${cu.name} ${tu.name}';
    singular = '${cu.singular} ${tu.singular}';
    convToMKS = cu.valueSI * tu.valueSI;
    abbrev1 = cu.abbrev1 != null && tu.abbrev1 != null
        ? '${cu.abbrev1}${tu.abbrev1}'
        : null;
    abbrev2 = cu.abbrev2 != null && tu.abbrev2 != null
        ? '${cu.abbrev2}${tu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => Charge;

  /// Derive ChargeUnits using this ChargeUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      ChargeUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
