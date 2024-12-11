import '../../../quantity_ext.dart';
import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'time.dart';

/// A measure of the _effective concentration_ of a species in a mixture.
/// See the [Wikipedia entry for Thermodynamic activity](https://en.wikipedia.org/wiki/Thermodynamic_activity)
/// for more information.
class Activity extends Quantity {
  /// Construct an Activity with either becquerels ([Bq]) or curies ([Ci]).
  /// Optionally specify a relative standard uncertainty.
  // ignore: non_constant_identifier_names
  Activity({dynamic Bq, dynamic Ci, double uncert = 0.0})
      : super(Bq ?? (Ci ?? 0.0),
            Ci != null ? Activity.curies : Activity.becquerels, uncert);

  /// Constructs a instance without preferred units.
  Activity.misc(dynamic conv) : super.misc(conv, Activity.activityDimensions);

  /// Constructs a Activity based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Activity.inUnits(dynamic value, ActivityUnits? units, [double uncert = 0.0])
      : super(value, units ?? Activity.becquerels, uncert);

  /// Constructs a constant Activity.
  const Activity.constant(Number valueSI,
      {ActivityUnits? units, double uncert = 0.0})
      : super.constant(valueSI, Activity.activityDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions activityDimensions =
      Dimensions.constant(<String, int>{'Time': -1}, qType: Activity);

  /// The standard SI unit.
  static final ActivityUnits becquerels =
      ActivityUnits('becquerels', null, 'Bq', null, 1.0, true);

  /// Accepted for use with the SI, subject to further review.
  static final ActivityUnits curies =
      ActivityUnits('curies', null, 'Ci', null, 3.7e10, false);
}

/// Units acceptable for use in describing Activity quantities.
class ActivityUnits extends Activity with Units {
  /// Constructs a instance.
  ActivityUnits(String name, String? abbrev1, String? abbrev2, String? singular,
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

  /// Constructs a instance from length and time units.
  ActivityUnits.lengthTimeUnits(LengthUnits lu, TimeUnits su)
      : super.misc(lu.valueSI * su.valueSI) {
    name = '${lu.name} per ${su.singular} squared';
    singular = '${lu.singular} per ${su.singular} squared';
    convToMKS = lu.valueSI * su.valueSI;
    abbrev1 = lu.abbrev1 != null && su.abbrev1 != null
        ? '${lu.abbrev1} / ${su.abbrev1}'
        : null;
    abbrev2 = lu.abbrev2 != null && su.abbrev2 != null
        ? '${lu.abbrev2}${su.abbrev2}'
        : null;
    metricBase = metricBase;
    offset = offset.toDouble();
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => Activity;

  /// Derive ActivityUnits using this ActivityUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      ActivityUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
