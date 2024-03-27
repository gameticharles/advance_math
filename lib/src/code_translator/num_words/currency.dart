part of num_words;

final Currency usdCurrency = Currency(
  USD: 1.0,
  mainUnitSingular: 'Dollar',
  mainUnitPlural: 'Dollars',
  fractionalUnitSingular: 'Cent',
  fractionalUnitPlural: 'Cents',
);

final Currency euroCurrency = Currency.inUnits(
  1.0,
  CurrencyUnits(
    'Euro',
    '€',
    'EUR',
    'Euro',
    1.0,
    false,
    mainUnitSingular: 'Euro',
    mainUnitPlural: 'Euros',
    fractionalUnitSingular: 'Cent',
    fractionalUnitPlural: 'Cents',
  ),
);

final Currency cefaCurrency = Currency.inUnits(
  1.0,
  CurrencyUnits(
    'CFA Franc',
    'CFA',
    'XOF',
    'Franc',
    1.0,
    false,
    mainUnitSingular: 'Franc',
    mainUnitPlural: 'Francs',
    fractionalUnitSingular: 'Centime',
    fractionalUnitPlural: 'Centimes',
  ),
);
