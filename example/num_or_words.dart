import 'package:advance_math/advance_math.dart';

void main() {
  void displayConversion(NumWords converter, num value,
      {String lang = 'en',
      int decimalPlaces = 2,
      bool useOrdinal = false,
      bool isFeminine = false,
      Currency? currency}) {
    var result = converter.toWords(value,
        lang: lang,
        decimalPlaces: decimalPlaces,
        useOrdinal: useOrdinal,
        isFeminine: isFeminine,
        currency: currency);
    print(result);
    print(converter.toNum(result, lang: lang, currency: currency));
    print('---');
  }

  var converter = NumWords();

  print('--- French ---');
  displayConversion(converter, 301, lang: 'fr', useOrdinal: true);
  displayConversion(converter, 123, lang: 'fr', decimalPlaces: 10);
  displayConversion(converter, 6743, lang: 'fr', decimalPlaces: 10);
  displayConversion(converter, 123.6743, lang: 'fr', decimalPlaces: 10);
  displayConversion(converter, 123.6743, lang: 'fr', currency: cefaCurrency);
  displayConversion(converter, 84656789, lang: 'fr');
  displayConversion(converter, 9181601, lang: 'fr');
  displayConversion(converter, 8666529123484656789, lang: 'fr');

  print('\n--- English ---');
  displayConversion(converter, 301, lang: 'en', useOrdinal: true);
  displayConversion(converter, 123, lang: 'en', decimalPlaces: 10);
  displayConversion(converter, 6743, lang: 'en', decimalPlaces: 10);
  displayConversion(converter, 123.6743, lang: 'en', decimalPlaces: 10);
  displayConversion(converter, 123.6743, lang: 'en', currency: usdCurrency);
  displayConversion(converter, 84656789, lang: 'en');
  displayConversion(converter, 9181601, lang: 'en');
  displayConversion(converter, 8666529123484656789, lang: 'en');
}
