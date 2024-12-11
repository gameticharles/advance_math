import '../../../quantity_ext.dart';
import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'force.dart';

// Also MomentOfForce

/// The tendency of a force to rotate an object about an axis, fulcrum, or pivot.
/// See the [Wikipedia entry for Torque](https://en.wikipedia.org/wiki/Torque)
/// for more information.
class Torque extends Quantity {
  /// Constructs a Torque with newton meters ([Nm]).
  /// Optionally specify a relative standard uncertainty.
  // ignore: non_constant_identifier_names
  Torque({dynamic Nm, double uncert = 0.0})
      : super(Nm ?? 0.0, Torque.newtonMeters, uncert);

  /// Constructs a instance without preferred units.
  Torque.misc(dynamic conv) : super.misc(conv, Torque.torqueDimensions);

  /// Constructs a Torque based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Torque.inUnits(dynamic value, TorqueUnits? units, [double uncert = 0.0])
      : super(value, units ?? Torque.newtonMeters, uncert);

  /// Constructs a constant Torque.
  const Torque.constant(Number valueSI,
      {TorqueUnits? units, double uncert = 0.0})
      : super.constant(valueSI, Torque.torqueDimensions, units, uncert);

  /// Dimensions for this type of quantity (energy per angle rather than Length x Force).
  static const Dimensions torqueDimensions = Dimensions.constant(
      <String, int>{'Length': 2, 'Time': -2, 'Mass': 1, 'Angle': -1},
      qType: Torque);

  /// The standard SI unit.
  static final TorqueUnits newtonMeters =
      TorqueUnits.forceLength(Force.newtons, LengthUnits.meters);
}

/// Units acceptable for use in describing Torque quantities.
class TorqueUnits extends Torque with Units {
  /// Constructs a instance.
  TorqueUnits(String name, String? abbrev1, String? abbrev2, String? singular,
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

  /// Constructs a instance from force and length units.
  TorqueUnits.forceLength(ForceUnits fu, LengthUnits lu)
      : super.misc(fu.valueSI * lu.valueSI) {
    name = '${fu.singular} ${lu.name}';
    singular = '${fu.singular} ${lu.singular}';
    convToMKS = fu.valueSI * lu.valueSI;
    abbrev1 = fu.abbrev1 != null && lu.abbrev1 != null
        ? '${fu.abbrev1} ${lu.abbrev1}'
        : null;
    abbrev2 = fu.abbrev2 != null && lu.abbrev2 != null
        ? '${fu.abbrev2}${lu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => Torque;

  /// Derive TorqueUnits using this TorqueUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      TorqueUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
