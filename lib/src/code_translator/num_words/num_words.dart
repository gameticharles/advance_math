import 'package:advance_math/advance_math.dart';

part 'currency.dart';
part 'language_config.dart';
part 'languages.dart';
part 'ext.dart';

/// A utility class to convert numerical values to their word representation
/// in various languages with support for currency and ordinal conversion.
///
/// ```dart
/// var converter = NumOrWords(languages: {'en': englishConfig});
/// print(converter.convert(45.67));  // Outputs: Forty-Five Point Sixty-Seven
/// ```
class NumWords {
  /// Map of supported languages and their configurations.
  final Map<String, LanguageConfig> languages;

  /// Default currency configuration for the conversion.
  final Currency? defaultCurrency;

  /// Creates an instance of [NumWords] with English as the default language.
  ///
  /// ```dart
  /// var converter = NumOrWords();
  /// ```
  ///
  /// [languages] is a map of supported languages and their configurations. By default, only English is supported.
  /// [defaultCurrency] provides a default currency configuration for the conversion.
  /// [fractionalSeparator] specifies the default separator for fractional parts.
  NumWords({
    Map<String, LanguageConfig>? languages,
    this.defaultCurrency,
  }) : languages = languages ?? {'en': englishConfig, 'fr': frenchConfig};

  /// Converts a given [value] to its word representation.
  ///
  /// - [value]: The numerical value to be converted.
  /// - [lang]: The language in which the conversion should be made. Default is 'en'.
  /// - [conjunction]: The word to use before the last item in a list. If not provided, the default conjunction of the language will be used.
  /// - [currency]: The currency configuration to be used in the conversion.
  /// - [decimalPlaces]: Number of decimal places to consider in the conversion. Default is 2.
  /// - [useOrdinal]: Whether to return the ordinal representation of the number. Default is false.
  ///
  /// Returns the word representation of the provided number.
  ///
  /// ```dart
  /// var converter = NumOrWords();
  /// print(converter.convert(123));  // Outputs: One Hundred And Twenty-Three
  /// print(converter.convert(123, useOrdinal: true));  // Outputs: One Hundred And Twenty-Third
  /// ```
  String toWords(
    num value, {
    String lang = 'en',
    String? conjunction,
    Currency? currency,
    int decimalPlaces = 2,
    bool useOrdinal = false,
    bool isFeminine = false,
  }) {
    // Ensure the chosen language is supported
    if (!languages.containsKey(lang)) {
      throw ArgumentError('Language not supported.');
    }

    LanguageConfig config = languages[lang]!;

    // Use provided conjunction or default to the language's default conjunction
    conjunction = conjunction ?? config.defaultConjunction;

    // Use provided currency or default to the provided default currency
    currency = currency ?? defaultCurrency;

    if (value == 0) {
      return config.ones['0']!;
    }

    if (useOrdinal) {
      return _convertToOrdinal(value, config, isFeminine);
    } else {
      return _convertToCardinal(
          value, config, conjunction, currency, decimalPlaces);
    }
  }

  num toNum(
    String input, {
    String lang = 'en',
    String? conjunction,
    Currency? currency,
  }) {
    // Ensure the chosen language is supported
    if (!languages.containsKey(lang)) {
      throw ArgumentError('Language not supported.');
    }
    bool isNegative = false;

    LanguageConfig config = languages[lang]!;

    // Use provided conjunction or default to the language's default conjunction
    conjunction = conjunction ?? config.defaultConjunction;

    // Use provided currency or default to the provided default currency
    currency = currency ?? defaultCurrency;

    if (config.currencySuffix != null) {
      input = input.replaceAll(config.currencySuffix!, '');
    }
    if (config.tensDelimiter.isNotEmpty) {
      input = input.replaceAll(config.tensDelimiter, ' ');
    }

    //Remove Currencies
    if (currency != null) {
      var l = ' ${config.defaultConjunction} ';
      var li = input.lastIndexOf(l);
      input = input.replaceRange(
          li, li + l.length, '${config.fractionalSeparator} ');
      input = input.replaceAll(currency.mainUnitPlural!, '');
      input = input.replaceAll(currency.mainUnitSingular!, '');
      input = input.replaceAll(currency.fractionalUnitPlural!, '');
      input = input.replaceAll(currency.fractionalUnitSingular!, '');
      input = input.trim();
    }

    // Split input into main and fractional parts
    List<String> parts = input.split(config.fractionalSeparator);
    String mainPart = parts[0].trim();
    String? fractionalPart;
    if (parts.length > 1) {
      fractionalPart = parts[1].trim();
    }

    if (config.negativeTerm.isNotEmpty &&
        mainPart.contains(config.negativeTerm)) {
      isNegative = true;
      mainPart = mainPart.replaceAll(config.negativeTerm, '');
    }

    // Convert main part to number
    num totalValue = _convertStringToNum(mainPart, config);

    // Convert fractional part to number
    if (fractionalPart != null) {
      num fractionalValue = _convertStringToNum(fractionalPart, config);
      totalValue +=
          (fractionalValue / pow(10, fractionalValue.toString().length));
    }

    // Apply negative if needed
    if (isNegative) {
      totalValue = -totalValue;
    }

    return totalValue;
  }

  num _convertStringToNum(String input, LanguageConfig config) {
    // Reverse the ordinal to masculine string
    input = config.reverseOrdinalFunction!(input);

    // Split the input into words
    List<String> words = input.split(RegExp(r'[\s\-]'));
    words.removeWhere(
        (word) => word.isEmpty || word == config.defaultConjunction);

    // Handle compound words
    for (int i = 0; i < words.length - 1; i++) {
      String compound = '${words[i]}-${words[i + 1]}';
      if (config.tens.containsValue(compound)) {
        words[i] = compound;
        words.removeAt(i + 1);
      }
    }

    num totalValue = 0;
    num currentValue = 0;

    for (String word in words) {
      if (config.ones.containsValue(word)) {
        currentValue += getKeyByValue(config.ones, word);
      } else if (config.teens.containsValue(word)) {
        currentValue += getKeyByValue(config.teens, word);
      } else if (config.tens.containsValue(word)) {
        currentValue += getKeyByValue(config.tens, word) * 10;
      } else if (config == frenchConfig) {
        if (config.hundreds.containsValue(word)) {
          currentValue = currentValue == 0
              ? getKeyByValue(config.hundreds, word) * 100
              : currentValue * getKeyByValue(config.hundreds, word) * 100;
        } else if (config.magnitudes.contains(word)) {
          num magnitudeValue = pow(10, config.magnitudes.indexOf(word) * 3);
          totalValue += currentValue * magnitudeValue;
          currentValue = 0;
        } else if (config.chunkConversionRule != null) {
          currentValue =
              config.chunkConversionRule!(currentValue, word, config);
          totalValue += currentValue;
          currentValue = 0;
        }
      } else if (config == englishConfig) {
        if (config.hundreds.containsValue(word)) {
          currentValue = currentValue == 0
              ? getKeyByValue(config.hundreds, word) * 100
              : currentValue * getKeyByValue(config.hundreds, word);
        } else if (config.magnitudes.contains(word)) {
          num magnitudeValue = pow(10, config.magnitudes.indexOf(word) * 3);
          totalValue += currentValue * magnitudeValue;
          currentValue = 0;
        } else if (config.chunkConversionRule != null) {
          currentValue =
              config.chunkConversionRule!(currentValue, word, config);
        }
      } else {
        throw ArgumentError('Unrecognized word: $word');
      }
    }

    totalValue += currentValue;

    return totalValue;
  }

  // Helper function to get a key by value from a map
  int getKeyByValue(Map<String, String> map, String value) {
    return int.parse(
        map.keys.firstWhere((k) => map[k] == value, orElse: () => '0'));
  }

  /// Converts a given [value] to its cardinal word representation.
  ///
  /// [value]: The numerical value to be converted.
  /// [config]: The language configuration to be used in the conversion.
  /// [conjunction]: The word to use before the last item in a list.
  /// [currency]: The currency configuration to be used in the conversion.
  /// [decimalPlaces]: Number of decimal places to consider in the conversion.
  ///
  /// Returns the cardinal word representation of the provided number.
  ///
  /// This is a private method and is not typically directly called.
  String _convertToCardinal(num value, LanguageConfig config,
      String? conjunction, Currency? currency, int decimalPlaces) {
    bool isNegative = value < 0;
    value = value.abs();

    // Calculate the actual fractional part's length
    int actualFractionLength = (value.toString().split('.').length > 1)
        ? value.toString().split('.')[1].length
        : 0;

    // Determine the right decimal places to use
    int finalDecimalPlaces = (actualFractionLength < decimalPlaces)
        ? actualFractionLength
        : decimalPlaces;

    // Multiplier calculation based on finalDecimalPlaces
    int multiplier = pow(10, finalDecimalPlaces).toInt();

    // Separate the value into main and fractional parts
    int mainPart = value.toInt();
    int fractionalPart = ((value - mainPart) * multiplier).round();

    String mainWords = config.convertChunk(mainPart);
    String fractionalWords =
        fractionalPart > 0 ? config.convertDecimal(fractionalPart) : "";

    if (currency != null) {
      if (mainPart == 1) {
        mainWords += " ${currency.mainUnitSingular}";
      } else {
        mainWords += " ${currency.mainUnitPlural}";
      }
    }

    if (fractionalPart > 0 && currency != null) {
      if (fractionalPart == 1) {
        fractionalWords += " ${currency.fractionalUnitSingular}";
      } else {
        fractionalWords += " ${currency.fractionalUnitPlural}";
      }
    }

    String combined;
    if (mainWords.isNotEmpty && fractionalWords.isNotEmpty) {
      combined =
          "$mainWords ${currency != null ? conjunction : config.fractionalSeparator} $fractionalWords";
    } else {
      combined = mainWords + fractionalWords;
    }

    if (isNegative) {
      combined = "${config.negativeTerm} $combined";
    }

    if (config.currencySuffix != null && currency != null) {
      combined += " ${config.currencySuffix}";
    }

    return combined.trim();
  }

  /// Converts a given [value] to its ordinal word representation.
  ///
  /// [value]: The numerical value to be converted.
  /// [config]: The language configuration to be used in the conversion.
  ///
  /// Returns the ordinal word representation of the provided number.
  ///
  /// This is a private method and is not typically directly called.
  String _convertToOrdinal(num value, LanguageConfig config, bool isFeminine) {
    if (value < 0) {
      return "${config.negativeTerm} ${_convertToOrdinal(value.abs(), config, isFeminine)}";
    }

    return config.getOrdinal(value.toInt(), isFeminine);
  }
}
