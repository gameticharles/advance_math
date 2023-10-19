import '../quantity/number.dart';
import '../quantity/src/si/types/currency.dart';
import 'languages.dart';
import 'num_words.dart';

extension NumOrWordsExtension on num {
  String toWords({
    String lang = 'en',
    String? conjunction,
    Currency? currency,
    int decimalPlaces = 2,
    bool useOrdinal = false,
  }) {
    var converter =
        NumOrWords(languages: {'en': englishConfig, 'fr': frenchConfig});
    return converter.toWords(
      this,
      lang: lang,
      conjunction: conjunction,
      currency: currency,
      decimalPlaces: decimalPlaces,
    );
  }
}

extension NumberToWordsExtension on Number {
  String toWords({
    String lang = 'en',
    String? conjunction,
    Currency? currency,
    int decimalPlaces = 2,
    bool useOrdinal = false,
  }) {
    var converter =
        NumOrWords(languages: {'en': englishConfig, 'fr': frenchConfig});
    return converter.toWords(
      numberToNum(this),
      lang: lang,
      conjunction: conjunction,
      currency: currency,
      decimalPlaces: decimalPlaces,
    );
  }
}
