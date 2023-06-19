import '../../../quantity_ext.dart';
import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'force.dart';

/// The elastic tendency of liquids which makes them acquire the least surface area possible.
/// See the [Wikipedia entry for Surface tension](https://en.wikipedia.org/wiki/Surface_tension)
/// for more information.
class SurfaceTension extends Quantity {
  /// Constructs a SurfaceTension with newtons per meter.
  /// Optionally specify a relative standard uncertainty.
  SurfaceTension({dynamic newtonsPerMeter, double uncert = 0.0})
      : super(newtonsPerMeter ?? 0.0, SurfaceTension.newtonsPerMeter, uncert);

  /// Constructs a instance without preferred units.
  SurfaceTension.misc(dynamic conv)
      : super.misc(conv, SurfaceTension.surfaceTensionDimensions);

  /// Constructs a SurfaceTension based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  SurfaceTension.inUnits(dynamic value, SurfaceTensionUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? SurfaceTension.newtonsPerMeter, uncert);

  /// Constructs a constant SurfaceTension.
  const SurfaceTension.constant(Number valueSI,
      {SurfaceTensionUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, SurfaceTension.surfaceTensionDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions surfaceTensionDimensions = Dimensions.constant(
      <String, int>{'Mass': 1, 'Time': -2},
      qType: SurfaceTension);

  /// The standard SI unit.
  static final SurfaceTensionUnits newtonsPerMeter =
      SurfaceTensionUnits.forcePerLength(Force.newtons, LengthUnits.meters);
}

/// Units acceptable for use in describing SurfaceTension quantities.
class SurfaceTensionUnits extends SurfaceTension with Units {
  /// Constructs a instance.
  SurfaceTensionUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance based on force and length units.
  SurfaceTensionUnits.forcePerLength(ForceUnits fu, LengthUnits lu)
      : super.misc(fu.valueSI / lu.valueSI) {
    name = '${fu.name} per ${lu.singular}';
    singular = '${fu.singular} per ${lu.singular}';
    convToMKS = fu.valueSI / lu.valueSI;
    abbrev1 = fu.abbrev1 != null && lu.abbrev1 != null
        ? '${fu.abbrev1} / ${lu.abbrev1}'
        : null;
    abbrev2 = fu.abbrev2 != null && lu.abbrev2 != null
        ? '${fu.abbrev2}/${lu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => SurfaceTension;

  /// Derive SurfaceTensionUnits using this SurfaceTensionUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      SurfaceTensionUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
