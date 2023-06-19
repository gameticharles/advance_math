// ignore_for_file: non_constant_identifier_names

import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';

/// The number of occurrences of a repeating event per unit time.
/// See the [Wikipedia entry for Frequency](https://en.wikipedia.org/wiki/Frequency)
/// for more information.
class Frequency extends Quantity {
  /// Constructs a Frequency with hertz ([Hz]), kilohertz ([kHz]), megahertz ([MHz])
  /// or gigahertz ([GHz]).
  /// Optionally specify a relative standard uncertainty.
  Frequency(
      {dynamic Hz, dynamic kHz, dynamic MHz, dynamic GHz, double uncert = 0.0})
      : super(
            Hz ?? (kHz ?? (MHz ?? (GHz ?? 0.0))),
            kHz != null
                ? Frequency.kilohertz
                : (MHz != null
                    ? Frequency.megahertz
                    : (GHz != null ? Frequency.gigahertz : Frequency.hertz)),
            uncert);

  /// Constructs a instance without preferred units.
  Frequency.misc(dynamic conv)
      : super.misc(conv, Frequency.frequencyDimensions);

  /// Constructs a Frequency based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Frequency.inUnits(dynamic value, FrequencyUnits? units, [double uncert = 0.0])
      : super(value, units ?? Frequency.hertz, uncert);

  /// Constructs a constant Frequency.
  const Frequency.constant(Number valueSI,
      {FrequencyUnits? units, double uncert = 0.0})
      : super.constant(valueSI, Frequency.frequencyDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions frequencyDimensions =
      Dimensions.constant(<String, int>{'Time': -1}, qType: Frequency);

  /// The standard SI unit.
  static final FrequencyUnits hertz =
      FrequencyUnits('hertz', 'Hz', null, 'hertz', 1.0, true);

  // Convenience units.

  /// The metric unit for one thousand hertz.
  static final FrequencyUnits kilohertz = hertz.kilo() as FrequencyUnits;

  /// The metric unit for one million hertz.
  static final FrequencyUnits megahertz = hertz.mega() as FrequencyUnits;

  /// The metric unit for one billion hertz.
  static final FrequencyUnits gigahertz = hertz.giga() as FrequencyUnits;
}

/// Units acceptable for use in describing Frequency quantities.
class FrequencyUnits extends Frequency with Units {
  /// Constructs a instance.
  FrequencyUnits(String name, String? abbrev1, String? abbrev2,
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
  Type get quantityType => Frequency;

  /// Derive FrequencyUnits using this FrequencyUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      FrequencyUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
