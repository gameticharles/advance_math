import 'dart:math' as math;
import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'acceleration.dart';
import 'mass.dart';

/// Any interaction that, when unopposed, changes the motion of an object.
/// See the [Wikipedia entry for Force](https://en.wikipedia.org/wiki/Force)
/// for more information.
class Force extends Quantity {
  /// Constructs a Force with newtons ([N]).
  /// Optionally specify a relative standard uncertainty.
  Force({dynamic N, double uncert = 0.0})
      : super(N ?? 0.0, Force.newtons, uncert);

  /// Constructs a instance without preferred units.
  Force.misc(dynamic conv) : super.misc(conv, Force.forceDimensions);

  /// Constructs a Force based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Force.inUnits(dynamic value, ForceUnits? units, [double uncert = 0.0])
      : super(value, units ?? Force.newtons, uncert);

  /// Constructs a constant Force.
  const Force.constant(Number valueSI, {ForceUnits? units, double uncert = 0.0})
      : super.constant(valueSI, Force.forceDimensions, units, uncert);

  /// Constructs a instance from mass and acceleration.
  Force.ma(Mass m, Acceleration a)
      : super(
            m.valueSI * a.valueSI,
            Force.newtons,
            math.sqrt(m.relativeUncertainty * m.relativeUncertainty +
                a.relativeUncertainty * a.relativeUncertainty));

  /// Dimensions for this type of quantity.
  static const Dimensions forceDimensions = Dimensions.constant(
      <String, int>{'Length': 1, 'Mass': 1, 'Time': -2},
      qType: Force);

  /// The standard SI unit.
  static final ForceUnits newtons =
      ForceUnits('newtons', null, 'N', null, 1.0, true);
}

/// Units acceptable for use in describing Force quantities.
class ForceUnits extends Force with Units {
  /// Constructs a instance.
  ForceUnits(String name, String? abbrev1, String? abbrev2, String? singular,
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

  /// Returns the Type of the Quantity to which these Units apply
  @override
  Type get quantityType => Force;

  /// Derive ForceUnits using this ForceUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      ForceUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
