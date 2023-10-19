typedef Base20Converter = String Function(int value);

/// Represents the configuration for converting numbers to words in a specific language.
/// This configuration includes mappings for number segments, conjunctions, delimiters, and other language-specific nuances.
class LanguageConfig {
  /// Maps single digit numbers to their word representation.
  final Map<String, String> ones;

  /// Maps numbers from 10 to 19 to their word representation.
  final Map<String, String> teens;

  /// Maps tens (20, 30, ..., 90) to their word representation.
  final Map<String, String> tens;

  /// Maps hundreds (100, 200, ..., 900) to their word representation.
  final Map<String, String> hundreds;

  /// List to handle magnitudes like thousands, millions, etc.
  final List<String> magnitudes;

  /// Suffixes for ordinal numbers, e.g., 1st, 2nd, 3rd, etc.
  final Map<int, String> ordinalSuffixes;

  /// Function to generate ordinal representation for numbers.
  final String Function(int value, {bool isFeminine})? ordinalFunction;

  /// Function to generate reverse ordinal representation to it's masculine
  final String Function(String value)? reverseOrdinalFunction;

  /// Default conjunction used in the language (e.g., "and" in English).
  final String defaultConjunction;

  /// Whether a conjunction is used when expressing thousands.
  final bool conjunctionInThousands;

  /// Delimiter used between tens and ones (e.g., "-" in "Twenty-One").
  final String tensDelimiter;

  /// Determines the order of units and tens. If true, "One Twenty" instead of "Twenty-One".
  final bool unitsBeforeTens;

  /// Term used for negative numbers.
  final String negativeTerm;

  /// Suffix used when expressing currency amounts (e.g., "only" after "Ten Dollars").
  final String? currencySuffix;

  /// Converter function for base-20 languages.
  final Base20Converter? base20Converter;

  /// Indicates whether the language uses a base-20 system.
  final bool usesBase20;

  /// Indicates if the word order places hundreds before tens and ones.
  final bool hundredsBeforeTensAndOnes;

  /// Provides special word representation for specific numbers.
  final Map<int, String> specialExceptions;

  /// Default separator for fractional parts in the word representation.
  final String fractionalSeparator;

  final num Function(num currentValue, String word, LanguageConfig config)?
      chunkConversionRule;

  /// Creates a new instance of [LanguageConfig] with the given parameters.
  LanguageConfig({
    required this.ones,
    required this.teens,
    required this.tens,
    required this.hundreds,
    required this.magnitudes,
    required this.ordinalSuffixes,
    this.ordinalFunction,
    this.reverseOrdinalFunction,
    this.chunkConversionRule,
    required this.tensDelimiter,
    this.currencySuffix,
    required this.defaultConjunction,
    this.base20Converter,
    this.conjunctionInThousands = true,
    required this.unitsBeforeTens,
    required this.negativeTerm,
    required this.fractionalSeparator,

    // Metadata parameters with default values
    this.usesBase20 = false,
    this.hundredsBeforeTensAndOnes = true,
    this.specialExceptions = const {},
  });

  /// Returns the word representation for a given magnitude index.
  String getMagnitude(int index) {
    if (index < magnitudes.length) {
      return magnitudes[index];
    }
    throw RangeError('Magnitude index out of range.');
  }

  /// Converts a number chunk (up to 3 digits) into words.
  String convertChunk(int chunkValue) {
    if (chunkValue == 0) return "";

    List<int> chunks = [];
    while (chunkValue > 0) {
      chunks.add(chunkValue % 1000);
      chunkValue ~/= 1000;
    }

    List<String> words = [];
    for (int idx = 0; idx < chunks.length; idx++) {
      String chunkWord = _convertThreeDigits(chunks[idx]);
      if (chunkWord.isNotEmpty) {
        if (idx > 0) {
          chunkWord += " ${magnitudes[idx]}";
          if (conjunctionInThousands &&
              chunks[idx - 1] < 100 &&
              chunks[idx - 1] != 0) {
            chunkWord += " $defaultConjunction";
          }
        }
        words.insert(0, chunkWord);
      }
    }

    return words.join(" ");
  }

  /// Converts a three-digit number into words.
  String _convertThreeDigits(int value) {
    // Use the metadata in conversion logic. For example:
    if (specialExceptions.containsKey(value)) {
      return specialExceptions[value]!;
    }

    // Return if value is 0
    if (value == 0) return "";

    List<String> parts = [];

    // Handle hundreds
    if (value >= 100) {
      parts.add(hundreds["${value ~/ 100}"]!);
      value %= 100;
      if (value > 0) {
        parts.add(defaultConjunction);
      }
    }

    // Handle base-20 logic
    if (usesBase20 && value >= 20 && value < 100) {
      if (base20Converter != null) {
        parts.add(base20Converter!(value));
      } else {
        throw ArgumentError(
            "Language is configured to use base-20, but no base20Converter provided.");
      }
    } else if (value >= 20) {
      String tensPart = tens["${value ~/ 10}"]!;
      value %= 10;

      if (value > 0) {
        tensPart += tensDelimiter + ones["$value"]!;
      }
      parts.add(tensPart);
    } else if (value >= 10) {
      parts.add(teens["$value"]!);
    } else if (value > 0) {
      parts.add(ones["$value"]!);
    }

    // If the language has hundreds after tens and ones, adjust the order
    if (!hundredsBeforeTensAndOnes) {
      String? hundredsPart = parts.removeAt(0);
      parts.add(hundredsPart);
    }

    return parts.join(" ");
  }

  /// Returns the ordinal representation of a number.
  String getOrdinal(int value, bool isFeminine) {
    if (ordinalFunction != null) {
      return ordinalFunction!(value, isFeminine: isFeminine);
    }

    String cardinal = convertChunk(value);
    int lastTwoDigits = value % 100;

    if (ordinalSuffixes.containsKey(lastTwoDigits)) {
      return cardinal + ordinalSuffixes[lastTwoDigits]!;
    }

    int lastDigit = value % 10;
    if (ordinalSuffixes.containsKey(lastDigit)) {
      return cardinal + ordinalSuffixes[lastDigit]!;
    }

    // Default case (this would often be "th" for English, for example)
    return cardinal + ordinalSuffixes[-1]!;
  }

  /// Converts a decimal value into words.
  String convertDecimal(int decimalValue) {
    if (decimalValue < 1000) {
      return _convertThreeDigits(decimalValue);
    } else {
      return convertChunk(decimalValue);
    }
  }
}
