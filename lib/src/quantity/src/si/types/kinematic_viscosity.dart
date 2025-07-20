import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'area.dart';
import 'time.dart';

/// The resistance to flow of a fluid, equal to its absolute viscosity divided by its density.
/// See the [Wikipedia entry for Viscosity](https://en.wikipedia.org/wiki/Viscosity)
/// for more information.
class KinematicViscosity extends Quantity {
  /// Constructs a KinematicViscosity with meters squared per second.
  /// Optionally specify a relative standard uncertainty.
  KinematicViscosity({dynamic metersSquaredPerSecond, double uncert = 0.0})
      : super(metersSquaredPerSecond ?? 0.0,
            KinematicViscosity.metersSquaredPerSecond, uncert);

  /// Constructs a instance without preferred units.
  KinematicViscosity.misc(dynamic conv)
      : super.misc(conv, KinematicViscosity.kinematicViscosityDimensions);

  /// Constructs a KinematicViscosity based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  KinematicViscosity.inUnits(dynamic value, KinematicViscosityUnits? units,
      [double uncert = 0.0])
      : super(
            value, units ?? KinematicViscosity.metersSquaredPerSecond, uncert);

  /// Constructs a constant KinematicViscosity.
  const KinematicViscosity.constant(Number valueSI,
      {KinematicViscosityUnits? units, double uncert = 0.0})
      : super.constant(valueSI, KinematicViscosity.kinematicViscosityDimensions,
            units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions kinematicViscosityDimensions = Dimensions.constant(
      <String, int>{'Length': 2, 'Time': -1},
      qType: KinematicViscosity);

  /// The standard SI unit.
  static final KinematicViscosityUnits metersSquaredPerSecond =
      KinematicViscosityUnits.areaTime(Area.squareMeters, Time.seconds);
}

/// Units acceptable for use in describing KinematicViscosity quantities.
class KinematicViscosityUnits extends KinematicViscosity with Units {
  /// Constructs a instance.
  KinematicViscosityUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance based on area and time units.
  KinematicViscosityUnits.areaTime(AreaUnits au, TimeUnits tu)
      : super.misc(au.valueSI * tu.valueSI) {
    name = '${au.name} per ${tu.singular}';
    singular = '${au.singular} per ${tu.singular}';
    convToMKS = au.valueSI * tu.valueSI;
    abbrev1 = au.abbrev1 != null && tu.abbrev1 != null
        ? '${au.abbrev1} / ${tu.abbrev1}'
        : null;
    abbrev2 = au.abbrev2 != null && tu.abbrev2 != null
        ? '${au.abbrev2}${tu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply
  @override
  Type get quantityType => KinematicViscosity;

  /// Derive KinematicViscosityUnits using this KinematicViscosityUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      KinematicViscosityUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
