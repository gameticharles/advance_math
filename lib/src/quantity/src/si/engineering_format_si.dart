import '../si/utilities.dart' show unicodeExponent;
import 'number_format_si.dart';

/// A version of scientific notation in which the exponent of ten must be divisible by
/// three (e.g., 123.345 x 10^3).
class EngineeringFormatSI extends NumberFormatSI {
  /// Constructs a instance.
  EngineeringFormatSI({super.unicode});

  /// Move the decimal point.
  @override
  String adjustForExponent(String str) {
    if (str.isNotEmpty != true) return str;
    var trimmed = str.trim();
    var sign = '';
    if (trimmed.startsWith('-')) {
      sign = '-';
      trimmed = trimmed.substring(1);
    } else if (trimmed.startsWith('+')) {
      trimmed = trimmed.substring(1);
    }

    final dotIndex = trimmed.indexOf('.');
    final eIndex = trimmed.toLowerCase().indexOf('e');

    var firstNonZeroDigit = -1;
    for (var i = 0; i < trimmed.length; i++) {
      final s = trimmed[i];
      if (s != '0' && s != '.' && s != '-' && s != '+') {
        firstNonZeroDigit = i;
        break;
      }
    }

    if (firstNonZeroDigit == -1) return '0.0';

    final includedExponent =
        eIndex != -1 ? num.parse(trimmed.substring(eIndex + 1)) : 0;

    final length = eIndex != -1 ? eIndex : trimmed.length;
    var exp = (dotIndex == -1 ? length - 1 : dotIndex - firstNonZeroDigit) +
        includedExponent;
    if (dotIndex > firstNonZeroDigit) exp--;

    final num effExp = exp < 0 ? ((exp + 1) ~/ 3) * 3 - 3 : (exp ~/ 3) * 3;
    final adj = (exp - effExp).floor();

    var engStr = eIndex != -1
        ? trimmed.substring(firstNonZeroDigit, eIndex)
        : trimmed.substring(firstNonZeroDigit);
    if (engStr.length == 1 && firstNonZeroDigit < dotIndex) {
      engStr = '$engStr.0';
    } else {
      // Insert the decimal point after the first non zero digit.
      engStr = engStr.replaceAll('.', '');
      if (engStr.length < adj + 1) engStr = engStr.padRight(adj + 1, '0');
      engStr = '${engStr.substring(0, adj + 1)}.${engStr.substring(adj + 1)}';
      if (engStr.endsWith('.')) engStr = '${engStr}0';
    }

    engStr = NumberFormatSI.removeInsignificantZeros(engStr);

    // Prepend the sign.
    engStr = '$sign$engStr';

    // Append the exponent.
    if (effExp != 0) {
      engStr = unicode
          ? '$engStr \u{00d7} 10${unicodeExponent(effExp)}'
          : '$engStr x 10^$effExp';
    }

    return engStr;
  }
}
