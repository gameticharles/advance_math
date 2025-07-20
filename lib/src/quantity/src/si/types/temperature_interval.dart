import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/quantity_exception.dart';
import '../../si/units.dart';
import 'temperature.dart';

/// The difference between two temperatures, where temperature is an objective comparative
/// measure of hot or cold.
/// See the [Wikipedia entry for Thermodynamic temperature](https://en.wikipedia.org/wiki/Thermodynamic_temperature)
/// for more information.
class TemperatureInterval extends Quantity {
  /// Constructs a TemperatureInterval with kelvin ([K]) or degrees Celsius ([degC]).
  /// Optionally specify a relative standard uncertainty.
  TemperatureInterval({dynamic K, dynamic degC, double uncert = 0.0})
      : super(
            K ?? (degC ?? 0.0),
            degC != null
                ? TemperatureInterval.degreesCelsius
                : TemperatureInterval.kelvins,
            uncert);

  /// Constructs a instance without preferred units.
  TemperatureInterval.misc(dynamic conv)
      : super.misc(conv, TemperatureInterval.temperatureIntervalDimensions);

  /// Constructs a TemperatureInterval based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  TemperatureInterval.inUnits(dynamic value, TemperatureIntervalUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? TemperatureInterval.kelvins, uncert);

  /// Constructs a constant TemperatureInterval.
  const TemperatureInterval.constant(Number valueSI,
      {TemperatureIntervalUnits? units, double uncert = 0.0})
      : super.constant(valueSI,
            TemperatureInterval.temperatureIntervalDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions temperatureIntervalDimensions = Dimensions.constant(
      <String, int>{'Temperature': 1},
      qType: TemperatureInterval);

  /// The standard SI unit.
  static final TemperatureIntervalUnits kelvins =
      TemperatureIntervalUnits('kelvins', null, 'K', null, 1.0, true);

  /// Derived SI unit.
  static final TemperatureIntervalUnits degreesCelsius =
      TemperatureIntervalUnits(
          'degrees Celsius', 'deg C', null, 'degree Celsius', 1.0, true);

  /// Override the addition operator to manage the [Temperature]/`TemperatureInterval` relationship.
  /// * Adding a `Temperature` returns a [Temperature] object.
  /// * Adding a `TemperatureInterval` returns a [TemperatureInterval] object.
  @override
  Quantity operator +(dynamic addend) {
    if (addend is TemperatureInterval) {
      final newValueSI = valueSI + addend.valueSI;
      final ur = Quantity.calcRelativeCombinedUncertaintySumDiff(
          this, addend, newValueSI);
      return TemperatureInterval(K: newValueSI, uncert: ur);
    } else if (addend is Temperature) {
      final newValueSI = valueSI + addend.valueSI;
      final ur = Quantity.calcRelativeCombinedUncertaintySumDiff(
          this, addend, newValueSI);
      return Temperature(K: newValueSI, uncert: ur);
    } else {
      return super + addend;
    }
  }

  /// Override the subtraction operator to manage the [Temperature]/`TemperatureInterval` relationship.
  /// * Subtracting a `TemperatureInterval` returns a `TemperatureInterval` object.
  /// * Attempting to subtract a `Temperature` from a `TemperatureInterval` throws a
  /// [QuantityException] as a physically nonsensical operation.
  @override
  Quantity operator -(dynamic subtrahend) {
    if (subtrahend is TemperatureInterval) {
      final newValueSI = valueSI - subtrahend.valueSI;
      final ur = Quantity.calcRelativeCombinedUncertaintySumDiff(
          this, subtrahend, newValueSI);
      return TemperatureInterval(K: newValueSI, uncert: ur);
    } else if (subtrahend is Temperature) {
      throw const QuantityException(
          'Subtracting a Temperature from a TemperatureInterval is not supported.');
    } else {
      return super - subtrahend;
    }
  }

  /// Returns the [Temperature] equal to this temperature interval measured from 0 degrees kelvin.
  Temperature toTemperature() =>
      Temperature(K: valueSI, uncert: relativeUncertainty);
}

/// Units acceptable for use in describing TemperatureInterval quantities.
class TemperatureIntervalUnits extends TemperatureInterval with Units {
  /// Constructs a instance.
  TemperatureIntervalUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => TemperatureInterval;

  /// Derive TemperatureIntervalUnits using this TemperatureIntervalUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      TemperatureIntervalUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
