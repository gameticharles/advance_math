// ignore_for_file: non_constant_identifier_names

import 'package:advance_math/advance_math.dart';

var decp = Settings.DEFAULT_DECP;

class Scientific {
  late String coeff;
  late int exponent;
  late int sign;
  late String dec;
  late String wholes;

  Scientific(dynamic num) {
    if (num is! String) num = num.toString();

    if (num == 'undefined') {
      num = '0';
    }

    //convert to a string

    // Remove the sign
    if (num.startsWith('-')) {
      sign = -1;
      num = num.substring(1);
    } else {
      sign = 1;
    }

    if (isScientific(num)) {
      fromScientific(num);
    } else {
      convert(num);
    }
  }

  void fromScientific(String num) {
    final parts = num.toLowerCase().split('e');
    coeff = parts[0];
    exponent = int.parse(parts[1]);
  }

  void convert(String? num) {
    // Get wholes and decimals
    final parts = num!.split('.');
    String w = parts[0];
    String d = parts.length > 1 ? parts[1] : '';

    // Convert zero to blank strings
    w = Scientific.removeLeadingZeroes(w);
    d = Scientific.removeTrailingZeroes(d);

    // Find the location of the decimal place which is right after the wholes
    final dotLocation = w.length;

    // Add them together so we can move the dot
    final n = w + d;

    // Find the next number
    final zeroes = Scientific.leadingZeroes(n).length;

    // Set the exponent
    exponent = dotLocation - (zeroes + 1);

    // Set the coeff but first remove leading zeroes
    final coeff = Scientific.removeLeadingZeroes(n);
    if (coeff.isEmpty) {
      this.coeff = '0.0';
    } else {
      this.coeff = '${coeff[0]}.${coeff.length > 1 ? coeff.substring(1) : '0'}';
    }
    // The coeff decimal places
    final dec = this.coeff.split('.')[1];

    decp = dec == '0' ? 0 : dec.length;

    // Decimals
    this.dec = d;

    // Wholes
    wholes = w;
  }

  Scientific round(int num) {
    final n = copy();

    if (num == 0) {
      n.coeff = n.coeff[0];
    } else {
      final rounded = n.coeff.substring(0, num + 1);
      final nextTwo = n.coeff.substring(num + 1, num + 3);
      var ed = int.parse(nextTwo[0]);

      if (int.parse(nextTwo[1]) > 4) ed++;

      n.coeff = rounded + ed.toString();
    }

    return n;
  }

  Scientific copy() {
    return Scientific('0')
      ..coeff = coeff
      ..exponent = exponent
      ..sign = sign;
  }

  @override
  String toString([int n = 1]) {
    String retVal;

    if (Settings.SCIENTIFIC_IGNORE_ZERO_EXPONENTS &&
        exponent == 0 &&
        decp < n) {
      if (decp == 0) {
        retVal = wholes;
      } else {
        retVal = coeff;
      }
    } else {
      var coeff = n == 'undefined'
          ? this.coeff
          : Scientific.roundTo(this.coeff, min(n, (decp | 1)));
      retVal = exponent == 0 ? coeff : '${coeff}e$exponent';
    }

    return (sign == -1 ? '-' : '') + retVal;
  }

  static bool isScientific(String num) {
    return RegExp(r'\d+\.?\d*e[\+\-]*\d+', caseSensitive: false).hasMatch(num);
  }

  static String leadingZeroes(String num) {
    final match = RegExp(r'^(0*).*\$').firstMatch(num);
    return match?.group(1) ?? '';
  }

  /// Removes the leading zeroes from the number represented as a string.
  static String removeLeadingZeroes(String num) {
    final match = RegExp(r'^0*(.*)\$').firstMatch(num);
    return match != null ? match.group(1) ?? num : num;
  }

  /// Removes the trailing zeroes from the number represented as a string.
  static String removeTrailingZeroes(String num) {
    final match = RegExp(r'^0*\$').firstMatch(num);
    if (match != null && match.group(0) != null) {
      return num.substring(0, num.length - match.group(0)!.length);
    }
    return num;
  }

  static String roundTo(String c, int n) {
    final coeff = double.parse(c).roundTo(n);
    final m = coeff.toString().split('.').last;
    final d = n - m.length;
    //if we're asking for more significant figures
    if (d > 0) {
      return coeff.toString() + List.filled(d, '0').join();
    }
    return coeff.toString();
  }
}

class Settings {
  // Enables/Disables call peekers. False means callPeekers are disabled and true means callPeekers are enabled.
  static bool callPeekers = false;

  // The max number up to which to cache primes. Making this too high causes performance issues.
  static int init_primes = 1000;

  static List exclude = [];
  // If you don't care about division by zero for example then this can be set to true.
  // Has some nasty side effects so choose carefully.
  static bool suppress_errors = false;

  // The global used to invoke the library to parse to a number. Normally cos(9) for example returns
  // cos(9) for convenience but parse to number will always try to return a number if set to true.
  static bool PARSE2NUMBER = false;

  // This flag forces a clone to be returned when add, subtract, etc... is called
  static bool SAFE = false;

  // The symbol to use for imaginary symbols
  static String IMAGINARY = 'i';

  // Allow certain characters
  static List<String> ALLOW_CHARS = ['π'];

  // Allow nerdamer to convert multi-character variables
  static bool USE_MULTICHARACTER_VARS = true;

  // Allow changing of power operator
  static String POWER_OPERATOR = '^';

  // The variable validation regex
  static RegExp VALIDATION_REGEX = RegExp(
      r'^[a-z_αAβBγΓδΔϵEζZηHθΘιIκKλΛμMνNξΞoOπΠρPσΣτTυϒϕΦχXψΨωΩ∞][0-9a-z_αAβBγΓδΔϵEζZηHθΘιIκKλΛμMνNξΞoOπΠρPσΣτTυϒϕΦχXψΨωΩ]*$');

  // The regex used to determine which characters should be included in implied multiplication
  static RegExp IMPLIED_MULTIPLICATION_REGEX = RegExp(
      r'([\+\-\/\*]*[0-9]+)([a-z_αAβBγΓδΔϵEζZηHθΘιIκKλΛμMνNξΞoOπΠρPσΣτTυϒϕΦχXψΨωΩ]+[\+\-\/\*]*)');

  // Aliases
  static Map<String, String> ALIASES = {
    'π': 'pi',
    '∞': 'Infinity',
  };

  static bool POSITIVE_MULTIPLIERS = false;

  // Cached items
  static Map CACHE = {};

  // Print out warnings or not
  static bool SILENCE_WARNINGS = false;

  // Precision
  static int PRECISION = 21;

  // The Expression defaults to this value for decimal places
  static int EXPRESSION_DECP = 19;

  // The text function defaults to this value for decimal places
  static int DEFAULT_DECP = 16;

  // Function mappings
  static String VECTOR = 'vector';
  static String PARENTHESIS = 'parens';
  static String SQRT = 'sqrt';
  static String ABS = 'abs';
  static String FACTORIAL = 'factorial';
  static String DOUBLEFACTORIAL = 'dfactorial';

  // Reference pi and e
  static String LONG_PI =
      '3.14159265358979323846264338327950288419716939937510582097494459230781640628620899862803482534211706798214' +
          '808651328230664709384460955058223172535940812848111745028410270193852110555964462294895493038196';
  static String LONG_E =
      '2.718281828459045235360287471352662497757247093699959574966967627724076630353547594571382178525166427427466' +
          '39193200305992181741359662904357290033429526059563073813232862794349076323382988075319525101901';

  static double PI = 3.141592653589793;
  static double E = 2.718281828459045;

  static String LOG = 'log';
  static String LOG10 = 'log10';
  static String LOG10_LATEX = 'log_{10}';
  static int MAX_EXP = 200000;

  // The number of scientific places to round to
  static int SCIENTIFIC_MAX_DECIMAL_PLACES = 14;

  // True if ints should not be converted to
  static bool SCIENTIFIC_IGNORE_ZERO_EXPONENTS = true;
}
