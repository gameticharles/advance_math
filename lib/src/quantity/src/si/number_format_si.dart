import 'dart:math';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:intl/number_symbols.dart';
// ignore: implementation_imports
import 'package:intl/src/intl/number_parser_base.dart';
import '../../../number/number/complex.dart';
import '../../../number/number/double.dart';
import '../../../number/number/imaginary.dart';
import '../../../number/number/integer.dart';
import '../../../number/number/number.dart';
import '../../../number/number/precision.dart';
import 'quantity.dart';
import 'utilities.dart' show expUnicodeMap, logger;

/// NumberFormatSI implements the International System of Units (SI) style
/// conventions for displaying values of quantities.  Specifically:
///
/// - Three-digit groups of numbers with more than four digits are separated
/// by spaces instead of commas (for example, 299 792 458, not
/// 299,792,458) to avoid confusion with the decimal marker in European
/// literature.  This spacing is also used to the right of the decimal
/// marker (for example, 12 345.678 90).
/// - Uncertainty in the quantity's value may be optionally displayed...
/// e.g., 1.234(11) or 1.234 +/- 0.011.
///
/// The value will be displayed in "computer scientific notation" (e.g., 1.3E9)
/// if its exponent is less than -3 or greater than 6.  These thresholds are
/// arbitrary, but track with typical usage.  If the exponent does not pass one
/// of these thresholds then the number is simply displayed as a normal
/// decimal number (e.g., 1 234.567 89).
///
/// The standard DecimalFormat class is unable to apply grouping to digits
/// after the decimal.  Therefore, this class directly extends NumberFormat
/// and provides implementations for format and parse.
class NumberFormatSI implements NumberFormat {
  /// Constructs a instance.
  NumberFormatSI({this.unicode = false});

  final NumberFormat _scientific = NumberFormat.scientificPattern();

  /// Output in unicode (using unicode thin spaces instead of regular ascii spaces).
  bool unicode;

  /// [value] is expected to be a Quantity, Number or num object.
  @override
  String format(dynamic value) {
    String? realStr;
    String? imagStr;
    if (value is num) {
      realStr = value.toString();
    } else {
      final number = value is Number
          ? value
          : value is Quantity
              ? value.valueSI
              : null;
      if (number is Integer) {
        realStr = number.toInt().toString();
      } else if (number is Double) {
        realStr = number.toDouble().toString();
      } else if (number is Imaginary) {
        imagStr = number.value.toString();
      } else if (number is Complex) {
        if (number.real.value.toDouble() != 0) {
          realStr = number.real.isInteger == true
              ? '${number.real.toInt()}'
              : number.real.toString();
        }
        if (number.imag.value.toDouble() != 0) {
          imagStr = number.imag.value.isInteger == true
              ? '${number.imag.value.toInt()}'
              : number.imag.value.toString();
        }
        if (realStr == null && imagStr == null) realStr = '0';
      } else if (number is Precision) {
        realStr = number.toString();
      }
    }

    if (realStr?.isNotEmpty == true) realStr = adjustForExponent(realStr!);
    if (imagStr?.isNotEmpty == true) imagStr = adjustForExponent(imagStr!);

    final buf = StringBuffer();
    if (realStr?.isNotEmpty == true) buf.write(insertSpaces(realStr!));
    if (imagStr?.isNotEmpty == true) {
      if (buf.isNotEmpty) {
        if (imagStr?.startsWith('-') == true) {
          buf.write(' - ');
          imagStr = imagStr!.substring(1);
        } else {
          buf.write(' + ');
        }
      }
      final s = insertSpaces(imagStr!);
      final expIndex = _exponentIndex(s);
      if (expIndex == -1) {
        buf
          ..write(s)
          ..write('i');
      } else {
        buf
          ..write(s.substring(0, expIndex))
          ..write('i')
          ..write(s.substring(expIndex));
      }
    }

    return buf.toString();
  }

  /// Subclasses should override if they wish to modify the number string to
  /// include an exponent and move the decimal point.
  String adjustForExponent(String str) => str;

  /// Looks for the start of an exponent section.
  int _exponentIndex(String str) {
    var expIndex = str.indexOf(' x 10');
    if (expIndex == -1) expIndex = str.indexOf(' \u{00d7} 10');
    if (expIndex == -1) expIndex = str.indexOf('E');
    return expIndex;
  }

  /// Returns a String with spaces added according to SI guidelines.
  String insertSpaces(String str) {
    // Remove any exponent piece and add it back in after spaces have been added.
    final expIndex = _exponentIndex(str);
    final numStr = expIndex != -1 ? str.substring(0, expIndex) : str;

    final decimalIndex = numStr.indexOf('.');
    final preCount = decimalIndex != -1 ? decimalIndex : numStr.length;
    final postCount = decimalIndex != -1 ? numStr.length - decimalIndex - 1 : 0;

    final buf = StringBuffer();

    // Pre-decimal.
    if (preCount > 4) {
      final preStr =
          decimalIndex != -1 ? numStr.substring(0, decimalIndex) : numStr;
      final fullGroups = preStr.length ~/ 3;
      var cursor = preStr.length - fullGroups * 3;
      if (cursor != 0) buf.write(preStr.substring(0, cursor));
      while (cursor + 3 <= preStr.length) {
        if (cursor != 0) buf.write(unicode ? '\u{2009}' : ' ');
        buf.write(preStr.substring(cursor, cursor + 3));
        cursor += 3;
      }
    } else {
      if (decimalIndex != -1) {
        buf.write(numStr.substring(0, decimalIndex));
      } else {
        buf.write(numStr);
      }
    }

    // Decimal and post-decimal.
    if (decimalIndex != -1) {
      buf.write('.');
      if (postCount > 4) {
        // Insert a space after each grouping of 3.
        buf.write(numStr.substring(decimalIndex + 1, decimalIndex + 4));
        var cursor = 3;
        while (cursor < postCount) {
          buf
            ..write(unicode ? '\u{2009}' : ' ')
            ..write(numStr.substring(decimalIndex + 1 + cursor,
                min(decimalIndex + 4 + cursor, numStr.length)));
          cursor += 3;
        }
      } else {
        buf.write(numStr.substring(decimalIndex + 1));
      }
    }

    if (expIndex != -1) buf.write(str.substring(expIndex));

    return buf.toString();
  }

  /// Removes any zeros at the end of a number string that follow a decimal point (except for one that immediately
  /// follows the decimal point).
  static String removeInsignificantZeros(String str) {
    try {
      if (str.isNotEmpty != true) return str;
      final dotIndex = str.indexOf('.');
      if (dotIndex == -1) return str;
      final eIndex = str.toLowerCase().indexOf('e');
      final decimalCount =
          eIndex == -1 ? str.length - dotIndex - 1 : eIndex - dotIndex - 1;
      if (decimalCount < 2) return str;
      final lastDigitIndex = eIndex == -1 ? str.length - 1 : eIndex - 1;
      int endIndex;
      for (endIndex = lastDigitIndex; endIndex > dotIndex + 1; endIndex--) {
        if (str.substring(endIndex, endIndex + 1) != '0') break;
      }
      return eIndex == -1
          ? str.substring(0, endIndex + 1)
          : '${str.substring(0, endIndex + 1)}${str.substring(eIndex)}';
    } catch (e, s) {
      logger.severe('Problem removing insignificant zeros', e, s);
      return str;
    }
  }

  @override
  num parse(String text) {
    // Replace spaces, unicode characters and exponential notation before parsing.
    var adj = text
        .replaceAll(' ', '')
        .replaceAll('\u{2009}', '')
        .replaceAll('x10^', 'E')
        .replaceAll('x10', 'E');
    for (final char in expUnicodeMap.keys) {
      final unicodeChar = expUnicodeMap[char]!;
      adj = adj.replaceAll(unicodeChar, char);
    }
    return _scientific.parse(adj);
  }

  @override
  late String? currencyName = _scientific.currencyName;

  @override
  int get maximumFractionDigits => _scientific.maximumFractionDigits;

  @override
  set maximumFractionDigits(int value) {
    _scientific.maximumFractionDigits = value;
  }

  @override
  int get maximumIntegerDigits => _scientific.maximumIntegerDigits;

  @override
  set maximumIntegerDigits(int value) {
    _scientific.maximumIntegerDigits = value;
  }

  @override
  int get minimumExponentDigits => _scientific.minimumExponentDigits;

  @override
  set minimumExponentDigits(int value) {
    _scientific.minimumExponentDigits = value;
  }

  @override
  int get minimumFractionDigits => _scientific.minimumFractionDigits;

  @override
  set minimumFractionDigits(int value) {
    _scientific.minimumFractionDigits = value;
  }

  @override
  int get minimumIntegerDigits => _scientific.minimumIntegerDigits;

  @override
  set minimumIntegerDigits(int value) {
    _scientific.minimumIntegerDigits = value;
  }

  @override
  int? get significantDigits =>
      maximumSignificantDigits! ~/ minimumSignificantDigits!;

  // @override
  // int? get maximumSignificantDigits => _scientific.maximumSignificantDigits;

  // @override
  // int? get minimumSignificantDigits => _scientific.minimumSignificantDigits;

  // @override
  // bool get minimumSignificantDigitsStrict =>
  //     _scientific.minimumSignificantDigitsStrict;

  @override
  late int? maximumSignificantDigits;

  @override
  late int? minimumSignificantDigits;

  @override
  late bool minimumSignificantDigitsStrict;

  @override
  set significantDigits(int? value) {
    _scientific.significantDigits = value;
  }

  @override
  bool get significantDigitsInUse => _scientific.significantDigitsInUse;

  @override
  set significantDigitsInUse(bool value) {
    _scientific.significantDigitsInUse = value;
  }

  @override
  String get currencySymbol => _scientific.currencySymbol;

  @override
  int? get decimalDigits => _scientific.decimalDigits;

  @override
  String get locale => _scientific.locale;

  @override
  int get localeZero => _scientific.localeZero;

  @override
  int get multiplier => _scientific.multiplier;

  @override
  String get negativePrefix => _scientific.negativePrefix;

  @override
  String get negativeSuffix => _scientific.negativeSuffix;

  @override
  String get positivePrefix => _scientific.positivePrefix;

  @override
  String get positiveSuffix => _scientific.positiveSuffix;

  @override
  String simpleCurrencySymbol(String currencyCode) =>
      _scientific.simpleCurrencySymbol(currencyCode);

  @override
  NumberSymbols get symbols => _scientific.symbols;

  @override
  void turnOffGrouping() => _scientific.turnOffGrouping();

  @override
  R parseWith<R, P extends NumberParserBase<R>>(
      P Function(NumberFormat p1, String p2) parserGenerator, String text) {
    // TODO: implement parseWith
    throw UnimplementedError();
  }

  @override
  num? tryParse(String text) {
    // TODO: implement tryParse
    throw UnimplementedError();
  }

  @override
  R? tryParseWith<R, P extends NumberParserBase<R>>(
      P Function(NumberFormat p1, String p2) parserGenerator, String text) {
    // TODO: implement tryParseWith
    throw UnimplementedError();
  }
}
