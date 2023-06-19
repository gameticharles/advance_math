import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'time.dart';
import 'volume.dart';

/// The volume of fluid which passes per unit time.
/// See the [Wikipedia entry for Volumetric flow rate](https://en.wikipedia.org/wiki/Volumetric_flow_rate)
/// for more information.
class VolumeFlowRate extends Quantity {
  /// Constructs a VolumeFlowRate with cubic meters per second.
  /// Optionally specify a relative standard uncertainty.
  VolumeFlowRate({dynamic cubicMetersPerSecond, double uncert = 0.0})
      : super(cubicMetersPerSecond ?? 0.0, VolumeFlowRate.cubicMetersPerSecond,
            uncert);

  /// Constructs a instance without preferred units.
  VolumeFlowRate.misc(dynamic conv)
      : super.misc(conv, VolumeFlowRate.volumeFlowRateDimensions);

  /// Constructs a VolumeFlowRate based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  VolumeFlowRate.inUnits(dynamic value, VolumeFlowRateUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? VolumeFlowRate.cubicMetersPerSecond, uncert);

  /// Constructs a constant VolumeFlowRate.
  const VolumeFlowRate.constant(Number valueSI,
      {VolumeFlowRateUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, VolumeFlowRate.volumeFlowRateDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions volumeFlowRateDimensions = Dimensions.constant(
      <String, int>{'Length': 3, 'Time': -1},
      qType: VolumeFlowRate);

  /// The standard SI unit.
  static final VolumeFlowRateUnits cubicMetersPerSecond =
      VolumeFlowRateUnits.volumeTime(Volume.cubicMeters, Time.seconds);
}

/// Units acceptable for use in describing VolumeFlowRate quantities.
class VolumeFlowRateUnits extends VolumeFlowRate with Units {
  /// Constructs a instance.
  VolumeFlowRateUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance based on volume and time units.
  VolumeFlowRateUnits.volumeTime(VolumeUnits vu, TimeUnits tu)
      : super.misc(vu.valueSI / tu.valueSI) {
    name = '${vu.name} per ${tu.singular}';
    singular = '${vu.singular} per ${tu.singular}';
    convToMKS = vu.valueSI / tu.valueSI;
    abbrev1 = vu.abbrev1 != null && tu.abbrev1 != null
        ? '${vu.abbrev1} / ${tu.abbrev1}'
        : null;
    abbrev2 = vu.abbrev2 != null && tu.abbrev2 != null
        ? '${vu.abbrev2}/${tu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => VolumeFlowRate;

  /// Derive VolumeFlowRateUnits using this VolumeFlowRateUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      VolumeFlowRateUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
