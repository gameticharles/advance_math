import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';

/// The flow of electric charge.
/// See the [Wikipedia entry for Electric current](https://en.wikipedia.org/wiki/Electric_current)
/// for more information.
class Current extends Quantity {
  /// Constructs a Current with amperes ([A]) or milliamperes ([mA]).
  /// Optionally specify a relative standard uncertainty.
  Current({dynamic A, dynamic mA, double uncert = 0.0})
      : super(A ?? (mA ?? 0.0),
            mA != null ? Current.milliamperes : Current.amperes, uncert);

  /// Constructs a instance without preferred units.
  Current.misc(dynamic conv)
      : super.misc(conv, Current.electricCurrentDimensions);

  /// Constructs a Current based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Current.inUnits(dynamic value, CurrentUnits? units, [double uncert = 0.0])
      : super(value, units ?? Current.amperes, uncert);

  /// Constructs a constant electric Current.
  const Current.constant(Number valueSI,
      {CurrentUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, Current.electricCurrentDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions electricCurrentDimensions =
      Dimensions.constant(<String, int>{'Current': 1}, qType: Current);

  /// The standard SI unit.
  static final CurrentUnits amperes =
      CurrentUnits('amperes', 'A', null, null, 1.0, true);

  /// A common metric derivative.
  static final CurrentUnits milliamperes = amperes.milli() as CurrentUnits;
}

/// Units acceptable for use in describing [Current] quantities.
class CurrentUnits extends Current with Units {
  /// Constructs a instance.
  CurrentUnits(String name, String? abbrev1, String? abbrev2, String? singular,
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

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => Current;

  /// Derive CurrentUnits using this CurrentUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      CurrentUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
