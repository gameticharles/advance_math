import 'dart:math';

import 'language_config.dart';

/// An English configuration for conversion
final LanguageConfig englishConfig = LanguageConfig(
  ones: {
    '0': "Zero",
    '1': "One",
    '2': "Two",
    '3': "Three",
    '4': "Four",
    '5': "Five",
    '6': "Six",
    '7': "Seven",
    '8': "Eight",
    '9': "Nine"
  },
  teens: {
    '10': "Ten",
    '11': "Eleven",
    '12': "Twelve",
    '13': "Thirteen",
    '14': "Fourteen",
    '15': "Fifteen",
    '16': "Sixteen",
    '17': "Seventeen",
    '18': "Eighteen",
    '19': "Nineteen"
  },
  tens: {
    '2': "Twenty",
    '3': "Thirty",
    '4': "Forty",
    '5': "Fifty",
    '6': "Sixty",
    '7': "Seventy",
    '8': "Eighty",
    '9': "Ninety"
  },
  hundreds: {
    '1': "One Hundred",
    '2': "Two Hundred",
    '3': "Three Hundred",
    '4': "Four Hundred",
    '5': "Five Hundred",
    '6': "Six Hundred",
    '7': "Seven Hundred",
    '8': "Eight Hundred",
    '9': "Nine Hundred"
  },
  magnitudes: [
    "",
    "Thousand",
    "Million",
    "Billion",
    "Trillion",
    "Quadrillion",
    "Quintillion",
    "Sextillion",
    "Septillion",
    "Octillion",
    "Nonillion",
    "Decillion",
    "Undecillion",
    "Duodecillion",
    "Tredecillion",
    "Quattuordecillion",
    "Quindecillion",
    "Sexdecillion",
    "Septendecillion",
    "Octodecillion",
    "Novemdecillion",
    "Vigintillion"
  ],
  fractionalSeparator: 'Point',
  negativeTerm: 'Negative',
  currencySuffix: 'Only',
  tensDelimiter: "-",
  ordinalSuffixes: {1: "st", 2: "nd", 3: "rd", -1: "th"},
  ordinalFunction: (value, {bool isFeminine = false}) {
    // Helper function to get the ordinal for numbers from 1 to 19
    String simpleOrdinal(int num) {
      if (num == 1) return 'First';
      if (num == 2) return 'Second';
      if (num == 3) return 'Third';
      if (num == 4) return 'Fourth';
      if (num == 5) return 'Fifth';
      if (num == 6) return 'Sixth';
      if (num == 7) return 'Seventh';
      if (num == 8) return 'Eighth';
      if (num == 9) return 'Ninth';
      if (num == 12) return 'Twelfth';

      return "${englishConfig.convertChunk(num)}${englishConfig.ordinalSuffixes[-1]!}";
    }

    String twoDigitOrdinal(int num) {
      if (num >= 10 && num < 20) {
        // Special cases for 11th to 19th
        return englishConfig.teens["$num"]! +
            englishConfig.ordinalSuffixes[-1]!;
      }
      if (num >= 20) {
        int tensPart = num ~/ 10;
        int onesPart = num % 10;
        var v = englishConfig.tens["$tensPart"]!;
        if (onesPart == 0) {
          return "${v.substring(0, v.length - 1)}ieth";
        } else {
          return "$v-${simpleOrdinal(onesPart)}";
        }
      }
      return simpleOrdinal(num);
    }

    if (value < 100) {
      return twoDigitOrdinal(value);
    }

    String cardinal = englishConfig.convertChunk(value);
    List<String> parts = cardinal.split(' ');

    // For numbers above 99, replace only the last part with its ordinal
    String lastPartOrdinal = twoDigitOrdinal(value % 100);
    parts[parts.length - 1] = lastPartOrdinal;

    return parts.join(' ');
  },
  reverseOrdinalFunction: (value) {
    value = value.replaceFirst('First', 'One');
    value = value.replaceFirst('Second', 'Two');
    value = value.replaceFirst('Third', 'Three');
    value = value.replaceFirst('Fourth', 'Four');
    value = value.replaceFirst('Fifth', 'Five');
    value = value.replaceFirst('Sixth', 'Six');
    value = value.replaceFirst('Seventh', 'Seven');
    value = value.replaceFirst('Eighth', 'Eight');
    value = value.replaceFirst('Ninth', 'Nine');
    value = value.replaceFirst('Twelfth', 'Twelve');

    // Split the input into words
    List<String> words = value.split(RegExp(r'[\s\-]'));

    if (words.last.endsWith('ieth')) {
      value = value.replaceFirst(
          words.last, '${words.last.substring(0, words.last.length - 4)}y');
    } else if (words.last.endsWith('th')) {
      value = value.replaceFirst(
          words.last, words.last.substring(0, words.last.length - 2));
    }

    return value;
  },
  chunkConversionRule: (num currentValue, String word, LanguageConfig config) {
    if (word == "Hundred") {
      return currentValue == 0 ? 100 : currentValue * 100;
    } else if (config.magnitudes.contains(word)) {
      num magnitudeValue = pow(10, config.magnitudes.indexOf(word) * 3);
      return currentValue * magnitudeValue;
    }

    return 0; // Default case, can be adjusted as needed
  },
  defaultConjunction: "And",
  unitsBeforeTens: false,
);

/// A French configuration for conversion
final LanguageConfig frenchConfig = LanguageConfig(
  ones: {
    '0': "Zéro",
    '1': "Un",
    '2': "Deux",
    '3': "Trois",
    '4': "Quatre",
    '5': "Cinq",
    '6': "Six",
    '7': "Sept",
    '8': "Huit",
    '9': "Neuf"
  },
  teens: {
    '10': "Dix",
    '11': "Onze",
    '12': "Douze",
    '13': "Treize",
    '14': "Quatorze",
    '15': "Quinze",
    '16': "Seize",
    '17': "Dix-Sept",
    '18': "Dix-Huit",
    '19': "Dix-Neuf"
  },
  tens: {
    '2': "Vingt",
    '3': "Trente",
    '4': "Quarante",
    '5': "Cinquante",
    '6': "Soixante",
    '7': "Soixante-Dix",
    '8': "Quatre-Vingt",
    '9': "Quatre-Vingt-Dix"
  },
  hundreds: {
    '1': "Cent",
    '2': "Deux Cents",
    '3': "Trois Cents",
    '4': "Quatre Cents",
    '5': "Cinq Cents",
    '6': "Six Cents",
    '7': "Sept Cents",
    '8': "Huit Cents",
    '9': "Neuf Cents"
  },
  magnitudes: [
    "",
    "Mille",
    "Million",
    "Milliard",
    "Billion",
    "Billiard",
    "Trillion",
    "Trilliard",
    "Quadrillion",
    "Quadrilliard",
    "Quintillion",
    "Quintilliard",
    "Sextillion",
    "Sextilliard",
    "Septillion",
    "Septilliard",
    "Octillion",
    "Octilliard",
    "Nonillion",
    "Nonilliard",
    "Decillion",
    "Decilliard"
  ],
  fractionalSeparator: 'Point', //'Décimale',
  negativeTerm: 'Négatif',
  currencySuffix: 'Seulement',
  tensDelimiter: "-et-",
  ordinalSuffixes: {1: "er", 2: "e", 3: "e", -1: "ième"},
  ordinalFunction: (value, {bool isFeminine = false}) {
    // 1 is special: "premier" for masculine and "première" for feminine
    if (value == 1) {
      return isFeminine ? 'première' : 'premier';
    }

    // If the value ends in 01, 21, 31, ... and is not 11
    if (value % 10 == 1 && value != 11) {
      return "${frenchConfig.convertChunk(value - 1)}-et-${isFeminine ? 'Unième' : 'Un'}";
    }

    // For most other numbers, add the suffix "ième"
    return "${frenchConfig.convertChunk(value)}ième";
  },
  reverseOrdinalFunction: (value) {
    // For first: "première" to "premier"
    if (value.contains('première')) {
      value = value.replaceAll('première', 'premier');
    }

    if (value == 'premier') {
      value = value.replaceAll('premier', 'Un');
    }

    if (value.contains('un')) {
      value = value.replaceAll('un', 'Un');
    }

    // For numbers like twenty-one: "vingt-et-unième" to "vingt-et-un"
    if (value.contains('-et-unième')) {
      value = value.replaceAll('-et-unième', '-et-Un');
    }

    // Handle the word "cents"
    if (value.contains('Cents')) {
      value = value.replaceAll('Cents', 'Cent');
    }

    return value.replaceAll('ième', '');
  },
  defaultConjunction: "et",
  unitsBeforeTens: true,
);
