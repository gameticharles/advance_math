import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'area.dart';
import 'current.dart';

/// The electric current per unit area of cross section.
/// See the [Wikipedia entry for Current density](https://en.wikipedia.org/wiki/Current_density)
/// for more information.
class CurrentDensity extends Quantity {
  /// Constructs a CurrentDensity with amperes per square meter.
  /// Optionally specify a relative standard uncertainty.
  CurrentDensity({dynamic amperesPerSquareMeter, double uncert = 0.0})
      : super(amperesPerSquareMeter ?? 0.0,
            CurrentDensity.amperesPerSquareMeter, uncert);

  /// Constructs a instance without preferred units.
  CurrentDensity.misc(dynamic conv)
      : super.misc(conv, CurrentDensity.electricCurrentDensityDimensions);

  /// Constructs a CurrentDensity based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  CurrentDensity.inUnits(dynamic value, CurrentDensityUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? CurrentDensity.amperesPerSquareMeter, uncert);

  /// Constructs a constant CurrentDensity.
  const CurrentDensity.constant(Number valueSI,
      {CurrentDensityUnits? units, double uncert = 0.0})
      : super.constant(valueSI, CurrentDensity.electricCurrentDensityDimensions,
            units, uncert);

  /// Dimensions for this type of quantity
  static const Dimensions electricCurrentDensityDimensions =
      Dimensions.constant(<String, int>{'Current': 1, 'Length': -2},
          qType: CurrentDensity);

  /// The standard SI unit.
  static final CurrentDensityUnits amperesPerSquareMeter =
      CurrentDensityUnits.currentArea(Current.amperes, Area.squareMeters);
}

/// Units acceptable for use in describing CurrentDensity quantities.
class CurrentDensityUnits extends CurrentDensity with Units {
  /// Constructs a instance.
  CurrentDensityUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance from current and area quantities.
  CurrentDensityUnits.currentArea(CurrentUnits ecu, AreaUnits au)
      : super.misc(ecu.valueSI * au.valueSI) {
    name = '${ecu.name} per ${au.singular}';
    singular = '${ecu.singular} per ${au.singular}';
    convToMKS = ecu.valueSI * au.valueSI;
    abbrev1 = ecu.abbrev1 != null && au.abbrev1 != null
        ? '${ecu.abbrev1} / ${au.abbrev1}'
        : null;
    abbrev2 = ecu.abbrev2 != null && au.abbrev2 != null
        ? '${ecu.abbrev2}/${au.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply
  @override
  Type get quantityType => CurrentDensity;

  /// Derive CurrentDensityUnits using this CurrentDensityUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      CurrentDensityUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
