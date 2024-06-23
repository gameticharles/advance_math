part of 'num_words.dart';

extension NumWordsExtension on num {
  String toWords({
    String lang = 'en',
    String? conjunction,
    Currency? currency,
    int decimalPlaces = 2,
    bool useOrdinal = false,
  }) {
    var converter =
        NumWords(languages: {'en': englishConfig, 'fr': frenchConfig});
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
        NumWords(languages: {'en': englishConfig, 'fr': frenchConfig});
    return converter.toWords(
      numberToNum(this),
      lang: lang,
      conjunction: conjunction,
      currency: currency,
      decimalPlaces: decimalPlaces,
    );
  }
}
