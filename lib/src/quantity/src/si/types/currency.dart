import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';

/// Money in any form when in actual use or circulation as a medium of exchange.
/// See the [Wikipedia entry for Currency](https://en.wikipedia.org/wiki/Currency)
/// for more information.
class Currency extends Quantity {
  /// Constructs a Currency with US dollars ([USD]).
  /// Optionally specify a relative standard uncertainty.
  // ignore:non_constant_identifier_names
  Currency({dynamic USD, double uncert = 0.0})
      : super(USD ?? 0.0, Currency.dollarsUS, uncert);

  /// Constructs a instance without preferred units.
  Currency.misc(dynamic conv) : super.misc(conv, Currency.currencyDimensions);

  /// Constructs a Currency based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Currency.inUnits(dynamic value, CurrencyUnits? units, [double uncert = 0.0])
      : super(value, units ?? Currency.dollarsUS, uncert);

  /// Constructs a constant Currency.
  const Currency.constant(Number valueSI,
      {CurrencyUnits? units, double uncert = 0.0})
      : super.constant(valueSI, Currency.currencyDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions currencyDimensions =
      Dimensions.constant(<String, int>{}, qType: Currency);

  /// The unit of currency in the United States.
  static final CurrencyUnits dollarsUS =
      CurrencyUnits('United States Dollars', '\$', 'USD', null, 1.0, false);

  /// One U.S. Cent is equal to 0.01 U.S. Dollar.
  static final CurrencyUnits centsUS =
      CurrencyUnits('United States Cents', 'cents', null, null, 0.01, false);
}

/// Units acceptable for use in describing Currency quantities.
class CurrencyUnits extends Currency with Units {
  /// Constructs a instance.
  CurrencyUnits(String name, String? abbrev1, String? abbrev2, String? singular,
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

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => Currency;

  /// Derive CurrencyUnits using this CurrencyUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      CurrencyUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
