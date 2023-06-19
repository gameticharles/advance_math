import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';

/// The total luminous flux incident on a surface, per unit area.
/// See the [Wikipedia entry for Illuminance](https://en.wikipedia.org/wiki/Illuminance)
/// for more information.
class Illuminance extends Quantity {
  /// Constructs an Illuminance with [lux].
  /// Optionally specify a relative standard uncertainty.
  Illuminance({dynamic lux, double uncert = 0.0})
      : super(lux ?? 0.0, Illuminance.lux, uncert);

  /// Constructs a instance without preferred units.
  Illuminance.misc(dynamic conv)
      : super.misc(conv, Illuminance.illuminanceDimensions);

  /// Constructs a Illuminance based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Illuminance.inUnits(dynamic value, IlluminanceUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? Illuminance.lux, uncert);

  /// Constructs a constant Illuminance.
  const Illuminance.constant(Number valueSI,
      {IlluminanceUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, Illuminance.illuminanceDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions illuminanceDimensions = Dimensions.constant(
      <String, int>{'Length': -2, 'Intensity': 1, 'Solid Angle': 1},
      qType: Illuminance);

  /// The standard SI unit.
  // Note: singular same as plural
  static final IlluminanceUnits lux =
      IlluminanceUnits('lux', null, 'lx', 'lux', 1.0, true);
}

/// Units acceptable for use in describing Illuminance quantities.
class IlluminanceUnits extends Illuminance with Units {
  /// Constructs a instance.
  IlluminanceUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Returns the Type of the Quantity to which these Units apply
  @override
  Type get quantityType => Illuminance;

  /// Derive IlluminanceUnits using this IlluminanceUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      IlluminanceUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
