// ignore_for_file: non_constant_identifier_names

import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'information.dart';
import 'time.dart';

/// The flow of information, per unit time.
/// See the [Wikipedia entry for Information](https://en.wikipedia.org/wiki/Information)
/// for more information.
class InformationRate extends Quantity {
  /// Construct an InformationRate with bits per second ([bps]), kilobits per second ([kbps]),
  /// megabits per second ([Mbps]), gigabits per second ([Gbps]) or terabits per second ([Tbps]).
  /// Optionally specify a relative standard uncertainty.

  InformationRate(
      {dynamic bps,
      dynamic kbps,
      dynamic Mbps,
      dynamic Gbps,
      dynamic Tbps,
      double uncert = 0.0})
      : super(
            bps ?? (kbps ?? (Mbps ?? (Gbps ?? (Tbps ?? 0.0)))),
            kbps != null
                ? InformationRate.kilobitsPerSecond
                : (Mbps != null
                    ? InformationRate.megabitsPerSecond
                    : (Gbps != null
                        ? InformationRate.gigabitsPerSecond
                        : (Tbps != null
                            ? InformationRate.terabitsPerSecond
                            : InformationRate.bitsPerSecond))),
            uncert);

  /// Constructs a instance without preferred units.
  InformationRate.misc(dynamic conv)
      : super.misc(conv, InformationRate.informationRateDimensions);

  /// Constructs a InformationRate based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  InformationRate.inUnits(dynamic value, InformationRateUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? InformationRate.bitsPerSecond, uncert);

  /// Constructs a constant InformationRate.
  const InformationRate.constant(Number valueSI,
      {InformationRateUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, InformationRate.informationRateDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions informationRateDimensions =
      Dimensions.constant(<String, int>{'Time': -1}, qType: InformationRate);

  /// The standard SI unit.
  static final InformationRateUnits bitsPerSecond =
      InformationRateUnits.informationTime(Information.bits, Time.seconds);

  // Common metric units.

  /// The metric unit for one thousand bits per second.
  static final InformationRateUnits kilobitsPerSecond =
      InformationRateUnits.informationTime(Information.kilobits, Time.seconds);

  /// The metric unit for one million bits per second.
  static final InformationRateUnits megabitsPerSecond =
      InformationRateUnits.informationTime(Information.megabits, Time.seconds);

  /// The metric unit for one billion bits per second.
  static final InformationRateUnits gigabitsPerSecond =
      InformationRateUnits.informationTime(Information.gigabits, Time.seconds);

  /// The metric unit for one trillion bits per second.
  static final InformationRateUnits terabitsPerSecond =
      InformationRateUnits.informationTime(Information.terabits, Time.seconds);
}

/// Units acceptable for use in describing InformationRate quantities.
class InformationRateUnits extends InformationRate with Units {
  /// Constructs a instance.
  InformationRateUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance from information and time units.
  InformationRateUnits.informationTime(InformationUnits iu, TimeUnits tu)
      : super.misc(iu.valueSI * tu.valueSI) {
    name = '${iu.name} per ${tu.singular}';
    singular = '${iu.singular} per ${tu.singular}';
    convToMKS = iu.valueSI * tu.valueSI;
    abbrev1 = iu.abbrev1 != null && tu.abbrev1 != null
        ? '${iu.abbrev1} / ${tu.abbrev1}'
        : null;
    abbrev2 = iu.abbrev2 != null && tu.abbrev2 != null
        ? '${iu.abbrev2}${tu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => InformationRate;

  /// Derive InformationRateUnits using this InformationRateUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      InformationRateUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
