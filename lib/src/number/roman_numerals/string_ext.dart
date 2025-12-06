part of 'roman_numerals.dart';

class _ApostrophusData {
  var count = 0;
  var tally = false;
  var match = 0;

  void reset() {
    count = 0;
    tally = false;
    match = 0;
  }

  String get string {
    final first = 'C' * match;
    final last = 'Ↄ' * count;
    return '${first}I$last';
  }

  bool get isBalanced => count > 0 && count == match;
}

extension RomanNumeralsString on String {
  /// A map of common Roman numeral letters to their corresponding numeric values.
  /// This map includes the basic Roman numeral symbols: I, V, X, L, and C.
  /// These are the most commonly used Roman numeral symbols.
  static final _sharedRomanLettersToNumbers = {
    'I': 1,
    'V': 5,
    'X': 10,
    'L': 50,
    'C': 100,
  };

  /// A map of common Roman numeral letters to their corresponding numeric values.
  /// This map includes the basic Roman numeral symbols: M and D.
  /// These are commonly used Roman numeral symbols.
  static final _commonRomanLettersToNumbers = {'M': 1000, 'D': 500};

  /// A map of Roman numeral letters with a vinculum (overbar) to their corresponding numeric values.
  /// The vinculum is a diacritic mark used in Roman numerals to indicate a multiplication by 1000.
  /// This map includes the less common Roman numeral symbols with a vinculum, such as M̅, V̅, X̅, L̅, and C̅.
  static final _vinculumRomanLettersToNumbers = {
    'MV\u{0305}': 4000,
    'V\u{0305}': 5000,
    'MX\u{0305}': 9000,
    'X\u{0305}': 10000,
    'X\u{0305}L\u{0305}': 40000,
    'L\u{0305}': 50000,
    'X\u{0305}C\u{0305}': 90000,
    'C\u{0305}': 100000,
    'C\u{0305}D\u{0305}': 400000,
    'D\u{0305}': 500000,
    'C\u{0305}M\u{0305}': 900000,
    'M\u{0305}': 1000000
  };

  /// A map of compact apostrophus Roman numeral letters to their corresponding numeric values.
  /// This map includes less common Roman numeral symbols with an apostrophus, such as IↃ, CCIↄ, CIↃ, and others.
  /// The apostrophus is a diacritic mark used in some variants of Roman numerals to indicate a multiplication by 1000.
  static final _apostrophusRomanLettersToNumbers = {
    'IↃ': 500,
    'CCIↃ': 900,
    'CIↃ': 1000,
    'CIↃIↃↃ': 4000,
    'IↃↃ': 5000,
    'CIↃCCIↃↃ': 9000,
    'CCIↃↃ': 10000,
    'CCIↃↃIↃↃↃ': 40000,
    'IↃↃↃ': 50000,
    'CCIↃↃCCCIↃↃↃ': 90000,
    'CCCIↃↃↃ': 100000,
    'CCCIↃↃↃIↃↃↃↃ': 400000,
    'IↃↃↃↃ': 500000,
    'CCCIↃↃↃCCCCIↃↃↃↃ': 900000,
    'CCCCIↃↃↃↃ': 1000000
  };

  /// A map of compact apostrophus Roman numeral letters to their corresponding numeric values.
  /// This map includes less common Roman numeral symbols with an apostrophus, such as IↃ, CCIↄ, CIↃ, and others.
  /// The apostrophus is a diacritic mark used in some variants of Roman numerals to indicate a multiplication by 1000.
  static final _compactApostrophusRomanLettersToNumbers = {
    'D': 500,
    'Cↀ': 900,
    'ↀ': 1000,
    'ↀↁ': 4000,
    'ↁ': 5000,
    'ↀↂ': 9000,
    'ↂ': 10000,
    'ↂↇ': 40000,
    'ↇ': 50000,
    'ↂↈ': 90000,
    'ↈ': 100000
  };

  /// Confirms or not confirms a valid Roman numeral value. This
  /// may change for the same [String] depending on the [RomanNumeralsConfig].
  bool isValidRomanNumeralValue({RomanNumeralsConfig? config}) {
    config ??= romanNumeralConfig;

    // Is it literally just a nulla token?
    if (this == config.nulla) {
      return true;
    }

    final numerals = {
      ..._sharedRomanLettersToNumbers,
      ..._commonRomanLettersToNumbers,
      ..._vinculumRomanLettersToNumbers,
    };

    // 1. Invalid Characters
    final invalidCharacters = r"([^MDCLXVI\(\)\u0305])";

    // 2. Invalid Repetitions
    final invalidRepeats =
        r"(D{2,}|\u0305D{2,}|L{2,}|\u0305L{2,}|V{2,}|\u0305V{2,})";
    // 3. Check for more than three consecutive I, X, or C characters
    final invalidConsecutive =
        r"(I{4,}|\u0305I{4,}|X{4,}|\u0305X{4,}|C{4,}|\u0305C{4,})";
    // 4. Invalid subtractive combinations
    final invalidSubtractives =
        r"(IL|IC|ID|IM|XD|XM|VX|VL|VC|VD|VM|LC|LD|LM|DM|\u0305IL|\u0305IC|\u0305ID|\u0305IM|\u0305XD|\u0305XM|\u0305VX|\u0305VL|\u0305VC|\u0305VD|\u0305VM|\u0305LC|\u0305LD|\u0305LM|\u0305DM)";

    if (RegExp(
            "$invalidCharacters|$invalidRepeats|$invalidConsecutive|$invalidSubtractives")
        .hasMatch(this)) {
      return false;
    }

    // 5. Bracket Check
    int openBrackets = split('(').length - 1;
    int closeBrackets = split(')').length - 1;
    if (openBrackets != closeBrackets) {
      return false;
    }

    // 6. Subtractive Notation Inside Brackets
    RegExp bracketPattern = RegExp(r"\(([^)]+)\)");
    Iterable<Match> matches = bracketPattern.allMatches(this);
    for (Match match in matches) {
      if (RegExp(r"[^M]").hasMatch(match.group(1)!)) {
        return false;
      }
    }

    // 7. Non-Decreasing Inside Brackets
    for (Match match in matches) {
      String bracketContent = match.group(1)!;
      for (int i = 1; i < bracketContent.length; i++) {
        if (numerals[bracketContent[i]]! > numerals[bracketContent[i - 1]]!) {
          return false;
        }
      }
    }

    // // Additional: Invalid Order (outside of subtractive notations)
    // // E.g., MC (1100) is valid, CM (900) is valid
    // List<String> romanChars = split('');
    // for (int i = 1; i < romanChars.length; i++) {
    //   if (numerals.containsKey(romanChars[i - 1] + romanChars[i])) {
    //     continue; // Skip valid subtractive pairs
    //   }
    //   if (numerals[romanChars[i]]! > numerals[romanChars[i - 1]]!) {
    //     return false;
    //   }
    // }

    /*
       Match expression reads as:
       - ^                # From the beginnging of the line.
       - if Common Roman Numerals:
       -   (M{0,3})       # There are 3 maximum 'M' matches.
       - else if Apostrophus:
       -   if compact:
       -     ((ↈ){0,3})                  # Maxium 3 millions
       -     ((ↂↈ)|(ↂↇ)|(ↇ)?(ↂ){0,3}) # 900k, 400k, or 0 to 3 100k following 0 or 1 500k
       -     ((ↀↂ)|(ↀↁ)|(ↁ)?(ↀ){0,3})    # 90k, 40k or 0 to 3 10k following 0 o 1 50k
       -     ((Cↀ)|(CCCC)|(D)?C{0,3})     # Then, match for 900, 400 - 4 C's allowed!
       -                                  #   then 0 to 3 100/C's following 0 or one 500/D's.
       -   else:
       -     ((CCCCIↃↃↃↃ){0,3})
       -     ((CCCIↃↃↃCCCCIↃↃↃↃ)|(CCCIↃↃↃIↃↃↃↃ)|(IↃↃↃↃ)?(CCCIↃↃↃ){0,3})
       -     ((CCIↃↃCCCIↃↃↃ)|(CCIↃↃIↃↃↃ)|(IↃↃↃ)?(CCIↃↃ){0,3})
       -     ((CIↃCCIↃↃ)|(CIↃIↃↃ)|(ⅠↃↃ)?(CIↃ){0,3})
       -     ((CCIↃ)|(CCCC)|(IↃ)?C{0,3})
       -     # The matching follows Vinculum style, but substituing the
       -     # overline for specific sequences.
       -     # Note: 4 CCCC's used for 400!
       - else if Vinculum:
       -   (M̅{0,3})         # There are 3 maximum 'M̅' matches for 3,000,000
       -   (C̅M̅|C̅D̅|D̅?C̅{0,3}) # Then, match for 900,000/C̅M̅, 400,000/C̅D̅, or 0 to 3 100,000/C̅'s following 0 or one 500,000/D̅'s.
       -   (X̅C̅|X̅L̅|L̅?X̅{0,3}) # Then, match for  90,000/X̅C̅,  40,000/X̅L̅, or 0 to 3  10,000/X̅'s following 0 or one 50/L̅'s.
       -   (MX̅|MV̅|V̅?M{0,3}) # Then, match for   9,000/MX̅,   4,000/MV̅, or 0 to 3   1,000/M's following 0 or one 5/V̅'s.
       - (CM|CD|D?C{0,3}) # Then, match for 900/CM, 400/CD, or 0 to 3 100/C's following 0 or one 500/D's.
       - (XC|XL|L?X{0,3}) # Then, match for 90/XC,  40/XL,  or 0 to 3 10/X's  following 0 or one 50/L's.
       - (IX|IV|V?I{0,3}) # Then, match for 9/IX,   4/IV,   or 0 to 3 1/X's   following 0 or one 5/V's.
       - $                # To the end of the line.
     
       The options provide for case-insensitive matching.
       */
    var expString = r'(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})';
    switch (config.configType) {
      case RomanNumeralsType.common:
        expString = r'(M{0,3})(CM|CD|D?C{0,3})' + expString;
        break;
      case RomanNumeralsType.apostrophus:
        final aConfig = config as ApostrophusRomanNumeralsConfig;
        if (aConfig.compact) {
          expString = r'((ↈ){0,3})'
              r'((ↂↈ)|(ↂↇ)|(ↇ)?(ↂ){0,3})'
              r'((ↀↂ)|(ↀↁ)|(ↁ)?(ↀ){0,3})'
              r'((Cↀ)|(CCCC)|(D)?C{0,3})'
              '$expString';
        } else {
          expString = r'((CCCCIↃↃↃↃ){0,3})'
              r'((CCCIↃↃↃCCCCIↃↃↃↃ)|(CCCIↃↃↃIↃↃↃↃ)|(IↃↃↃↃ)?(CCCIↃↃↃ){0,3})'
              r'((CCIↃↃCCCIↃↃↃ)|(CCIↃↃIↃↃↃ)|(IↃↃↃ)?(CCIↃↃ){0,3})'
              r'((CIↃCCIↃↃ)|(CIↃIↃↃ)|(ⅠↃↃ)?(CIↃ){0,3})'
              r'((CCIↃ)|(CCCC)|(IↃ)?C{0,3})'
              '$expString';
        }
        break;
      case RomanNumeralsType.vinculum:
        // With the unicode flag on for the RegExp below, the sequences
        // in this string for unicode can be matched.
        // https://api.flutter.dev/flutter/dart-core/RegExp/isUnicode.html
        // > In Unicode mode, the syntax of the RegExp pattern is more
        // > restricted, but some pattern features, like Unicode property
        // > escapes, are only available in this mode.
        expString = r'((M\u{0305}){0,3})'
            r'((C\u{0305}M\u{0305})|(C\u{0305}D\u{0305})|(D\u{0305})?(C\u{0305}){0,3})'
            r'((X\u{0305}C\u{0305})|(X\u{0305}L\u{0305})|(L\u{0305})?(X\u{0305}){0,3})'
            r'((MX\u{0305})|(MV\u{0305})|(V\u{0305})?(M){0,3})'
            r'(CM|CD|D?C{0,3})'
            '$expString';
        break;
    }
    expString = r'^' + expString + r'$';
    final exp = RegExp(expString, caseSensitive: false, unicode: true);

    matches = exp.allMatches(this);
    return matches.length == 1;
  }

  /// Create Roman numeral [int] from [String]. Rules for creation are read from
  /// the optional [config].
  int? toRomanNumeralValue({RomanNumeralsConfig? config}) {
    config ??= romanNumeralConfig;

    // Process as negative number
    if (startsWith('-')) {
      final positiveValue = substring(1).toRomanNumeralValue(config: config);
      return positiveValue != null ? -positiveValue : null;
    }

    // Guard against malformed string sequences, and return early if the string itself is invalid
    if (!isValidRomanNumeralValue(config: config)) {
      return null;
    }

    // Since we used the internal validator, we can now naively (i.e. simply and readably) parse the
    // Roman numeral string, since we know that it is in a valid form.
    Map<String, int> useMap = {};
    switch (config.configType) {
      case RomanNumeralsType.common:
        useMap = {
          ..._sharedRomanLettersToNumbers,
          ..._commonRomanLettersToNumbers
        };
        break;
      case RomanNumeralsType.apostrophus:
        final aConfig = config as ApostrophusRomanNumeralsConfig;
        if (aConfig.compact) {
          useMap = {
            ..._sharedRomanLettersToNumbers,
            ..._compactApostrophusRomanLettersToNumbers
          };
        } else {
          useMap = {
            ..._sharedRomanLettersToNumbers,
            ..._apostrophusRomanLettersToNumbers
          };
        }
        break;
      case RomanNumeralsType.vinculum:
        useMap = {
          ..._sharedRomanLettersToNumbers,
          ..._commonRomanLettersToNumbers,
          ..._vinculumRomanLettersToNumbers
        };
        break;
    }

    final nulla = config.nulla;
    useMap[nulla] = 0;

    var accum = 0;
    var curMax = 0;
    var curVal = 0;
    var failed = false;

    var strIter = characters.toUpperCase().iteratorAtEnd;
    var isApostrophus = false;
    if (config.configType == RomanNumeralsType.apostrophus) {
      final aConfig = config as ApostrophusRomanNumeralsConfig;
      isApostrophus = !aConfig.compact;
    }
    var ad = _ApostrophusData();
    while (strIter.moveBack()) {
      var c = strIter.current;
      if (isApostrophus) {
        if (c == 'Ↄ') {
          if (ad.tally && ad.match > 0) {
            // If we have a tally, and there are already some matches,
            // then we cannot get another Ↄ until we've confirmed
            // it's not a 5'r or that the C/Ↄ is balanced.
            failed = true;
            break;
          } else if (ad.tally && ad.match == 0) {
            // We found a valid 5'er form. Move the iterator back so
            // it's found again next loop. Continue to calculate the 5'er.
            strIter.moveNext();
            c = ad.string;
            ad.reset();
          } else {
            // Keep counting the Ↄ's
            ad.count += 1;
            continue;
          }
        } else if (ad.count > 0) {
          if (c == 'I') {
            if (!ad.tally) {
              // If you hit a legit apostrophus I, continue at
              // the top of the loop, so we don't subtract the I.
              ad.tally = true;
              continue;
            } else {
              // Something is wrong, we just got an I, but we already
              // have an apostrophus I.
              failed = true;
              break;
            }
          } else if (c == 'C') {
            if (!ad.tally) {
              // You can't have a matching C w/o the tally mark I.
              failed = true;
              break;
            } else {
              // Keep counting the C's.
              ad.match += 1;
            }
          } // Else, you got some other chracter that might be starting
          // the next sequence around. Leave it be for now.

          if (ad.tally && ad.isBalanced) {
            // We have a valid 10's form of the apostrophus, we can
            // continue to calculating it's value and bumping the
            // accumulator.
            c = ad.string;
            ad.reset();
          } else {
            // If we aren't balanced for the 10's form of the apostrophus
            // we continue to the top of the loop.
            continue;
          }
        }
      }

      // If the Apostrophus parsing already failed, just return null now.
      if (failed) {
        return null;
      }

      // Alright, single character or apostrophus sequence, we can lookup
      // the value and calculate our accumulation.
      var got = useMap[c];
      if (got == null) {
        // This is an exceptional case. I shouild increase the loudness
        // if this happens.
        return null;
      } else {
        curVal = got;
        if (curVal >= curMax) {
          accum += curVal;
          curMax = curVal;
        } else {
          accum -= curVal;
        }
      }
    }
    return accum;
  }
}
