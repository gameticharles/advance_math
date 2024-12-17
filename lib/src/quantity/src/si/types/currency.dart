import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';

/// Money in any form when in actual use or circulation as a medium of exchange.
/// See the [Wikipedia entry for Currency](https://en.wikipedia.org/wiki/Currency)
/// for more information.
class Currency extends Quantity {
  final String? mainUnitSingular;
  final String? mainUnitPlural;
  final String? fractionalUnitSingular;
  final String? fractionalUnitPlural;

  /// Constructs a Currency with US dollars ([usd]).
  /// Optionally specify a relative standard uncertainty.
  // ignore:non_constant_identifier_names
  Currency({
    dynamic usd,
    double uncert = 0.0,
    this.mainUnitSingular,
    this.mainUnitPlural,
    this.fractionalUnitSingular,
    this.fractionalUnitPlural,
  }) : super(usd ?? 0.0, Currency.dollarsUS, uncert);

  /// Constructs a instance without preferred units.
  Currency.misc(dynamic conv, this.mainUnitSingular, this.mainUnitPlural,
      this.fractionalUnitSingular, this.fractionalUnitPlural)
      : super.misc(conv, Currency.currencyDimensions);

  /// Constructs a Currency based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Currency.inUnits(dynamic value, CurrencyUnits? units, [double uncert = 0.0])
      : mainUnitSingular = units?.mainUnitSingular ?? 'unknown',
        mainUnitPlural = units?.mainUnitPlural ?? 'unknown',
        fractionalUnitSingular = units?.fractionalUnitSingular ?? 'unknown',
        fractionalUnitPlural = units?.fractionalUnitPlural ?? 'unknown',
        super(value, units ?? Currency.dollarsUS, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions currencyDimensions =
      Dimensions.constant(<String, int>{}, qType: Currency);

  /// The unit of currency in the United States.
  static final CurrencyUnits dollarsUS = CurrencyUnits(
      'United States Dollars', '\$', 'USD', null, 1.0, false,
      mainUnitSingular: 'Dollar',
      mainUnitPlural: 'Dollars',
      fractionalUnitSingular: 'Cent',
      fractionalUnitPlural: 'Cents');
}

/// Units acceptable for use in describing Currency quantities.
class CurrencyUnits extends Currency with Units {
  /// Constructs a instance.
  CurrencyUnits(String name, String? abbrev1, String? abbrev2, String? singular,
      dynamic conv, bool metricBase,
      {required String mainUnitSingular,
      required String mainUnitPlural,
      required String fractionalUnitSingular,
      required String fractionalUnitPlural})
      : super.misc(conv, mainUnitSingular, mainUnitPlural,
            fractionalUnitSingular, fractionalUnitPlural) {
    this.name = name;
    this.singular = singular;
    convToMKS = objToNumber(conv);
    this.abbrev1 = abbrev1;
    this.abbrev2 = abbrev2;
    this.metricBase = metricBase;
    offset = offset.toDouble();
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
        mainUnitSingular: mainUnitSingular!,
        mainUnitPlural: mainUnitPlural!,
        fractionalUnitSingular: fractionalUnitSingular!,
        fractionalUnitPlural: fractionalUnitPlural!,
      );
}
