# Advance Math Library for Dart

[![Pub package](https://img.shields.io/pub/v/advance_math.svg?logo=dart&logoColor=00b9fc)](https://pub.dartlang.org/packages/advance_math)
[![Null Safety](https://img.shields.io/badge/null-safety-brightgreen)](https://dart.dev/null-safety)
[![Likes](https://img.shields.io/pub/likes/advance_math)](https://pub.dartlang.org/packages/advance_math/score)
[![Points](https://img.shields.io/pub/points/advance_math)](https://pub.dartlang.org/packages/advance_math/score)
[![SDK Version](https://badgen.net/pub/sdk-version/advance_math)](https://pub.dartlang.org/packages/advance_math)

[![Last Commits](https://img.shields.io/github/last-commit/gameticharles/advance_math?ogo=github&logoColor=white)](https://github.com/gameticharles/advance_math/commits/master)
[![Pull Requests](https://img.shields.io/github/issues-pr/gameticharles/advance_math?ogo=github&logoColor=white)](https://github.com/gameticharles/advance_math/pulls)
[![Code size](https://img.shields.io/github/languages/code-size/gameticharles/advance_math?ogo=github&logoColor=white)](https://github.com/gameticharles/advance_math)
[![License](https://img.shields.io/github/license/gameticharles/advance_math?ogo=github&logoColor=white)](https://github.com/gameticharles/advance_math/blob/main/LICENSE)

[![Stars](https://img.shields.io/github/stars/gameticharles/advance_math)](https://github.com/gameticharles/advance_math/stargazers)
[![Forks](https://img.shields.io/github/forks/gameticharles/advance_math)](https://github.com/gameticharles/advance_math/network/members)
[![Github watchers](https://img.shields.io./github/watchers/gameticharles/advance_math)](https://github.com/gameticharles/advance_math/MyBadges)
[![Issues](https://img.shields.io./github/issues-raw/gameticharles/advance_math)](https://github.com/gameticharles/advance_math/issues)

Advance math is a comprehensive Dart library that enriches mathematical programming in Dart with a wide range of features beyond vectors and matrices. Offering functionality for complex numbers, advanced linear algebra, statistics, geometry, and more. The library opens up new possibilities for mathematical computation and data analysis. Whether you're developing a cutting-edge machine learning application, or simply need to perform calculations with complex numbers. It also provides the tools you need in a well-organized and easy-to-use package.

## Features

- Basic statistics: Statistics operations like mean, median, mode, min, max, variance, standardDeviation, quartiles,permutations, combinations, greatest common divisor(gcd), least common multiple(lcm).
- Convert number types to words. It also supports to currency formats for cheques and ordinal words representations.
- Morse code translations for encoding and decoding.
- Logarithmic operations: natural logarithm of a number, base-10 logarithm and logarithm of a number to a given base.
- Support angle conversion (degrees, minutes, seconds, radians, gradians, DMS).
- Trigonometry: It provides computation on all the trigonometric functions on the angle. These includes inverse and hyperbolic function (sin, cos, tan, asin, acos, atan, sinh, cosh, tanh, asinh, acosh, atanh, sec, csc, cot, asec, acsc, acot, sech, csch, coth, asech, acsch, acoth, vers, covers, havers, exsec, excsc).
- Angle operation: Supports addition, subtraction, multiplication, and division. Also supports comparisons, normalize, interpolation, and small-differencing on angles.
- Geometry: Geometries like Point, Line, Polygon, Circle, Triangle, SphericalTriangle, etc with specific functionalities and methods are implemented.
- Polynomial functions: Solve and find roots of a function to any degree (including Linear, Quadratic, Cubic, Quartic etc).
- Roman numerals: Convert roman numerals to integers and vice versa. It also supports basic arithmetic operations and comparisons.
- Matrix creation, filling and generation: Methods for filling the matrix with specific values or generating matrices with certain properties, such as zero, ones, identity, diagonal, list, or random matrices.
  - Import and export matrices to and from other formats (e.g., CSV, JSON, binary)
  - Matrix operations: Implement common matrix operations such as addition, subtraction, multiplication (element-wise and matrix-matrix), and division (element-wise) etc.
  - Matrix transformation methods: Add methods for matrix transformations, such as transpose, inverse, pseudoInverse, and rank etc.
  - Matrix manipulation (concatenate, sort, removeRow, removeRows, removeCol, removeCols, reshape, swapping rows and columns etc.)
  - Statistical methods: Methods for calculating statistical properties of the matrix, such as min, max, sum, mean, median, mode, skewness, standard deviation, and variance.
  - Element-wise operations: Methods for performing element-wise operations on the matrix, such as applying a function to each element or filtering elements based on a condition.
  - Solving linear systems of equations (Using Inverse Matrix, LU Decomposition,Gauss-Jordan Elimination, Ridge Regression, Gauss Elimination, Least Squares, Jacobi, Successive Over-Relaxation (SOR), Gauss-Seidel method, Gram Schmidt, Conjugate Gradient, Montante's Method (Bareiss algorithm) and Cramers Rule)
  - Solve matrix decompositions like LU decomposition, QR decomposition, LQ decomposition, Cholesky, Singular Value Decomposition (SVD) with different algorithms Crout's, Doolittle, Gauss Elimination Method, Gram Schmidt, Householder, Partial and Complete Pivoting, etc.
  - Matrix slicing and partitioning: Methods for extracting sub-Matrices or slices from the matrix.
  - Matrix concatenation and stacking: Methods for concatenating or stacking matrices horizontally or vertically.
  - Matrix norms: Methods for calculating matrix norms, such as L1 (Marathan), L2 (Euclidean), and infinity norms.
  - Determine the properties of a matrix.
  - From the matrix, row and columns of the matrix are iterables and also iterate on every element.
  - Eigen values and vectors.
- Supports vectors, complex numbers and complex vectors with most of the basic functionalities and operations.
- Supports math expressions with context and functions.
- Enhanced expression creation with multiple approaches: explicit Literal objects, toExpression() extension method, and ex() helper function.

## Todo

- Implement Expression
- Improve speed and performance

## Usage

### Import the library

```dart
import 'package:advance_math/advance_math.dart';
```

<details>
<summary>LOGARITHM</summary>

# Logarithm

Base-10 logarithm of a number is also implemented.

```dart
print(log10(100));  // Output: 2.0
```

Compute the natural logarithm of of a number using the function below. It also supports computes logarithm to any base.

```dart
// Natural log of `e`
print(log(math.e));  // Output: 1.0

//log to any base. Example log to base 10 on 100
print(log(100, 10)); // prints: 2.0
```

Compute the logarithm of a number to a given base.

```dart
print(logBase(10, 100));  // Output: 2.0
print(logBase(2, 8));  // Output: 3.0
print(logBase(2, 32));  // Output: 5.0
```

</details>

<details>
<summary>CODE TRANSLATOR</summary>

# Morse Code

This library provides a class, `MorseCode`, for encoding and decoding messages using the Morse code system. It offers custom delimiters for characters, words, and new lines in Morse code. The class also includes a rate limiter to prevent abuse of the encode/decode functions and optional logging for debugging purposes.

```dart
main(){
  // Create an instance of morse code translator
  var translator = MorseCode();

  // Convert words to morse code
  var encoded = translator.encode('SOS');
  print('Encoded: $encoded'); // Encoded: ... --- ...
  print('');

  // Convert the morse code to words
  var decoded = translator.decode(encoded);
  print('Decoded: $decoded'); // Decoded: SOS
}
```

## Rate Limiting and Logging

The `MorseCodeTranslator` class includes a rate limiter to prevent abuse of the encode/decode functions. You can enable or disable logging by setting the `loggingEnabled` flag to `true` or `false`. When logging is enabled, informational messages will be logged to the console.

## Caching

To improve efficiency, the translator caches previously decoded Morse code strings. This allows for faster decoding of repeated messages without having to recompute them.

```dart
void main() {
  // Create an instance of rate limiter
  var rateLimiter = RateLimiter(
    maxRequests: 10,
    interval: Duration(seconds: 10),
  );

  // An instance of morse code translator with logging enabled and rate limiter parsed
  var translator = MorseCode(
    loggingEnabled: true,
    rateLimiter: rateLimiter,
  );

  encoded = translator.encode('Enable logging for debugging');
  print('Encoded: $encoded');

  decoded = translator.decode(encoded);
  print('Decoded: $decoded');

  print('');
  print('Decoded directly');
  String decodingValue =
      ".... .. / - .... . .-. . / .... --- .-- / .- .-. . / -.-- --- ..- ..--..";
  decoded = translator.decode(decodingValue);
  print('Decoded: $decoded');
}

// Encoding input: Enable logging for debugging
// Encoded: . -. .- -... .-.. . / .-.. --- --. --. .. -. --. / ..-. --- .-. / -.. . -... ..- --. --. .. -. --.
// Decoded: ENABLE LOGGING FOR DEBUGGING
//
// Decoded directly
// Decoded: HI THERE HOW ARE YOU?
```

# NumOrWords

NumOrWords (Numbers or Words) is a Dart class designed to convert numerical values into their word representations and vice-versa. It is highly customizable, catering to multiple languages, currency representations, and more.

## Features

- **Basic Number Conversion**: Convert any number into its word representation.
- **Currency Representation**: Represent numbers in their currency form (e.g., Dollars, Euros).
- **Decimal Precision**: Define the precision for decimal numbers.
- **Ordinal Numbers**: Convert numbers into their ordinal form (e.g., 1st, 2nd, 3rd).
- **Multiple Languages Support**: Easily extendable for multiple languages.
- **Number Extension**: Conveniently use the Dart extension on numbers for quick conversion.

## Basic Usage

To begin, instantiate the `NumOrWords` class by providing language configurations.

```dart
var converter = NumOrWords(languages: {'en': englishConfig});
```

### Converting a Number to Words

Simply call the `convert` method on the converter instance.

```dart
print(converter.toWords(45.6743));  // Forty-Five Point Six Seven Four Three
```

### Defining Decimal Precision

You can also specify the precision for decimal numbers.

```dart
print(converter.toWords(45.6743, decimalPlaces: 10));  // Forty-Five Point Six Seven Four Three
```

### Currency Representation

To represent numbers in their currency form, specify the currency.

```dart
print(converter.convert(45.6743, currency: usd));  // Forty-Five Dollars And Sixty-Seven Cents Only
```

## Using the Number Extension

For convenience, the package also provides an extension on the number type.

```dart
print(45.67.toWords(currency: usd));  // Forty-Five Dollars And Sixty-Seven Cents Only
```

## Advanced Number Conversions

The package can handle a variety of number forms and scenarios.

```dart
print(converter.toWords(0));  // Zero
print(converter.toWords(1));  // One
print(converter.toWords(10));  // Ten
print(converter.toWords(100));  // One Hundred
print(converter.toWords(101));  // One Hundred And One
print(converter.toWords(111));  // One Hundred And Eleven
```

### Ordinal Numbers

To convert numbers into their ordinal form, use the `useOrdinal` parameter.

```dart
print(converter.toWords(111, useOrdinal: true));  // One Hundred And Eleventh
print(converter.toWords(13, useOrdinal: true));  // Thirteenth
print(converter.toWords(21, useOrdinal: true));  // Twenty-First
print(converter.toWords(30, useOrdinal: true));  // Thirtieth
print(converter.toWords(40, useOrdinal: true));  // Fortieth
```

### Words to Numver

The supports only French and English for the mean time. You can convert number to either English or French and back to number with losing precision.

```dart
  void displayConversion(NumOrWords converter, num value,
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

  var converter = NumOrWords();

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
  displayConversion(converter, 9181601, lang: 'en');
  displayConversion(converter, 8666529123484656789, lang: 'en');


// --- French ---
// Trois Cents-et-Un
// 301
// ---
// Cent et Vingt-et-Trois
// 123
// ---
// Six Mille Sept Cents et Quarante-et-Trois
// 6743
// ---
// Cent et Vingt-et-Trois Point Six Mille Sept Cents et Quarante-et-Trois
// 123.6743
// ---
// Cent et Vingt-et-Trois Francs et Soixante-et-Sept Centimes Seulement
// 123.67
// ---
// Quatre-Vingt-et-Quatre Million Six Cents et Cinquante-et-Six Mille Sept Cents et Quatre-Vingt-et-Neuf
// 84656789
// ---
// Neuf Million Cent et Quatre-Vingt-et-Un Mille Six Cents et Un
// 9181601
// ---
// Huit Trillion Six Cents et Soixante-et-Six Billiard Cinq Cents et Vingt-et-Neuf Billion Cent et Vingt-et-Trois Milliard Quatre Cents et Quatre-Vingt-et-Quatre Million Six Cents et Cinquante-et-Six Mille Sept Cents et Quatre-Vingt-et-Neuf
// 8666529123484656789
// ---
//
// --- English ---
// Three Hundred And First
// 301
// ---
// One Hundred And Twenty-Three
// 123
// ---
// Six Thousand Seven Hundred And Forty-Three
// 6743
// ---
// One Hundred And Twenty-Three Point Six Thousand Seven Hundred And Forty-Three
// 123.6743
// ---
// One Hundred And Twenty-Three Dollars And Sixty-Seven Cents Only
// 123.67
// ---
// Nine Million One Hundred And Eighty-One Thousand Six Hundred And One
// 9181601
// ---
// Eight Quintillion Six Hundred And Sixty-Six Quadrillion Five Hundred And Twenty-Nine Trillion One Hundred And Twenty-Three Billion Four Hundred And Eighty-Four Million Six Hundred And Fifty-Six Thousand Seven Hundred And Eighty-Nine
// 8666529123484656789
// ---
```

## LanguageConfig and Currency Configurations

The `LanguageConfig` and `Currency` classes are central to the NumOrWords package. They allow for deep customization and extensibility to cater to different languages and currency formats.

### Currency Configuration

For currency representation, you can define the singular and plural forms of both main and fractional units using the `Currency` class.

These configurations (`Currency` and `LanguageConfig`) form the backbone of the NumOrWords package. By leveraging their flexibility, users can accurately convert numbers to word representations for a vast range of languages and currency formats. Whether you're targeting a single language or a global audience, NumOrWords ensures precision and extensibility.

**Example:**

```dart
final Currency usd = Currency.inUnits(
  1.0,
  CurrencyUnits(
    'United States Dollars',
    '\$',
    'USD',
    null,
    1.0,
    false,
  mainUnitSingular: 'Dollar',
  mainUnitPlural: 'Dollars',
  fractionalUnitSingular: 'Cent',
  fractionalUnitPlural: 'Cents',
  ),
);

```

In the above example, the `Currency` configuration is set for US Dollars, with "Dollar" as the singular form, "Dollars" as the plural, "Cent" as the fractional singular, and "Cents" as the fractional plural.

### LanguageConfig

The `LanguageConfig` class provides a comprehensive configuration for number-word conversion in a specific language. It defines the word representations for different number sections, such as ones, tens, hundreds, magnitudes, etc., and also handles special conditions like ordinals.

**Example:**

```dart
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

```

In the provided example, the `LanguageConfig` is set for English. It specifies the words for ones, tens, hundreds, etc., and also handles the logic for ordinals. The configuration also includes details like the word for negative numbers (`Negative`), currency suffix (`Only`), and the delimiter used between tens and ones (`-`).

### Extending for Multiple Languages

To support multiple languages, simply extend the `LanguageConfig` for each language and provide it to the `NumOrWords` class.

## Conclusion

NumOrWords offers a comprehensive solution for converting numbers into words, supporting a wide range of use-cases and customization. Whether you need simple word representation or complex multi-language support with currency, NumOrWords has got you covered.

</details>

<details>
<summary>ZScore</summary>

# ZScore

Computes Z-scores based on a given confidence level.
The class provides functionalities to compute Z-scores, which are used in statistical hypothesis testing.

The Z-score represents how many standard deviations an element is from the mean.

```dart
var confidenceLevels = [
    10,
    20,
    30,
    40,
    50,
    60,
    70,
    80,
    85,
    90,
    95,
    99.0,
    99.999,
    99.99999,
    99.9999999
  ];
  for (var cl in confidenceLevels) {
    double zScore = ZScore.computeZScore(cl);
    print("Z-score for $cl% confidence level is $zScore");
  }

// Z-score for 10% confidence level is 0.12538099310291884
// Z-score for 20% confidence level is 0.25293326782658254
// Z-score for 30% confidence level is 0.3848770849965131
// Z-score for 40% confidence level is 0.5240018703826799
// Z-score for 50% confidence level is 0.6741891400433162
// Z-score for 60% confidence level is 0.8414567173547839
// Z-score for 70% confidence level is 1.0364314851895606
// Z-score for 80% confidence level is 1.281728756502709
// Z-score for 85% confidence level is 1.4398004696260025
// Z-score for 90% confidence level is 1.645211440143815
// Z-score for 95% confidence level is 1.9603949169253396
// Z-score for 99.0% confidence level is 2.5762360813095704
// Z-score for 99.999% confidence level is 4.417087697546128
// Z-score for 99.99999% confidence level is 5.326446072058037
// Z-score for 99.9999999% confidence level is 6.109029815669355
```

Compute the confidence level using the Z-Scroe value

```dart
print(ZScore.computeConfidenceLevel(1.9603949169253396)); // 95.00503548449109
print(ZScore.computeConfidenceLevel(5.326446072058037)); // 99.99998998470075
```

Confidence interval around a sample mean, you generally need the sample mean (x), the sample size (n), and the standard deviation (σ) or the standard error of the sample mean (SE). The Z-score corresponding to the desired confidence level is also required.

```dart
var interval = ZScore.computeConfidenceInterval(50, 100, 10, 95);
print("Confidence Interval: (${interval.lower}, ${interval.upper})");
// Output: Confidence Interval: (48.040605084588995, 51.959394915411005)
```

Compute the Probability Density Function (PDF) and Cumulative Density Function (CDF) for a standard normal distribution to the ZScore class.

```dart
print(ZScore.computeCDF(0)); // 0.49999998499999976
print(ZScore.computePDF(0)); // 0.3989422804014327
```

other computational functions includes:

```dart
// Compute p-value from a given Z-score.
print(ZScore.computePValue(1.96)); // 0.025

// Convert Z-score to T-score.
print(ZScore.convertZToT(1.96)); // 69.6

// Compute the percentile from a given Z-score.
print(ZScore.computePercentile(1.96)); // 97.5

// Compute Z-score from a raw score.
print(ZScore.computeZScoreFromRawScore(110, 100, 15)); // 0.6666666666666666
```

</details>

<details>
<summary>ANGLE</summary>

# Angle Class

The `Angle` class is part of the `advanced_math` library. It's designed to make working with angles straightforward in a variety of units, including degrees, radians, gradians, and DMS (Degrees, Minutes, Seconds).

## Features

1. Create an Angle object with any of the four units. The class will automatically convert it to all other units and store them as properties:

```dart
var angleDeg = Angle.degrees(45);
var angleRad = Angle.radians(math.pi / 4);
var angleGrad = Angle.gradians(50);
var angleDMS = Angle.dms([45, 0, 0]);
```

2. Get the smallest difference between two angles:

```dart
num diff = angleDeg.smallestDifference(angleRad);
```

3. Interpolate between two angles:

```dart
Angle interpolated = angleDeg.interpolate(angleRad, 0.5);
```

4. Convert an angle from one unit to another:

```dart
double rad = Angle.convert(180, AngleType.degrees, AngleType.radians);  // Converts 180 degrees to radians
print(rad);  // Outputs: 3.141592653589793

double grad = Angle.convert(1, AngleType.radians, AngleType.gradians);  // Converts 1 radian to gradians
print(grad);  // Outputs: 63.661977236758134
```

5. Convert degrees to gradians, radians, minutes or seconds, and vice versa:

```dart
double minutes = degrees2Minutes(1);  // Output: 60.0
double degreesFromMinutes = minutes2Degrees(60);  // Output: 1.0
double seconds = degrees2Seconds(1);  // Output: 3600.0
double degreesFromSeconds = seconds2Degrees(3600);  // Output: 1.0
```

6. Perform all the possible trignometry functions on the angle:

```dart
var angle = Angle.degrees(45);
var t1 = angle.sin();
var t2 = angle.cos();
var t3 = angle.tan();
var t4 = angle.tanh();
var t5 = angle.atanh();
```

These features provide an easy-to-use interface for handling various angle calculations, especially for applications that require geometric computations or work with geospatial data. The `Angle` class is an essential part of the `advanced_math` library and can be useful for anyone who needs advanced mathematical operations in Dart.

</details>

<details>
<summary>GEOMETRY</summary>

# Geometry Library

This library provides a suite of classes and functions to work with geometric objects and perform geometric calculations.

## Usage

### Point

A `Point` represents a point in a 2D space.

```dart
Point p1 = Point(3, 4); // 2D point
print(p1.x); // prints: 3
print(p1.y); // prints: 4

var p2 = Point(1, 2, 3);  // 3D point
print(p2.is3DPoint) // true

var p = Point.fromPolarCoordinates(5, radians(53.13));
print(p); // Output: Point(3.0000000000000004, 3.9999999999999996)

var p = Point.fromSphericalCoordinates(5, radians(53.13), radians(30));
print(p); // Output: Point(1.50, 1.999997320371271, 4.330127018922194)

```

A `Point3D` represents a point in a 3D space.

```dart
Point3D p1 = Point3D(3, 4, 2); // 3D point
print(p1.x); // prints: 3
print(p1.y); // prints: 4

```

Compute Distances
Example 1:

```dart
var p1 = Point(3, 4);
var p2 = Point(6, 8);
print(p1.distanceTo(p2)); // Output: 5.0

var point1 = Point(2, 3);
var point2 = Point(5, 11);
print(point1.slopeTo(point2)); // Output: 2.6666666666666665
```

Example 2:

```dart
var point1 = Point(1, 2, 3);
var point2 = Point(4, 5, 6);
print(point1.distanceTo(point2)); // Output: 5.196152422706632
print(point1.midpointTo(point2)); // Output: Point(2.5, 3.5, 4.5)
```

Arithmetics of points

```dart
var point1 = Point(2, 2);
var point2 = Point(1, 1);
print(point1 - point2); // Output: Point(1.0, 1.0)
print(point1 + point2); // Output: Point(3.0, 3.0)
print(point1 * 2); // Output: Point(4.0, 4.0)
print(point1 / 2); // Output: Point(1.0, 1.0)
```

Others include: bearingTo, distanceToLine, isCollinear etc

```dart
var point = Point(2, 0);
var origin = Point(1, 0);
Angle angle = Angle.radians(math.pi / 2)
var rotated = point.rotateBy(angle, origin)
print(rotated); // Output: Point(1, 1)

var point = Point(1, 2, 3);
print(point.move(1, -1, 2)); // Output: Point(2, 1, 5)
print(point.scale(2)); // Output: Point(2, 4, 6)
print(point.reflect(Point(0, 0, 0))); // Output: Point(-1, -2, -3)
```

### Line

A `Line` represents a line in a 2D space, defined by two points.

```dart
var line1 = Line(p1: Point(1, 1), p2: Point(2, 2));
print(line1); // Output: Line(Point(1.0, 1.0), Point(2.0, 2.0))

var line2 = Line(gradient: 1, intercept: 0);
print(line2); // Output: Line(Point(0.0, 0.0), Point(1.0, 1.0))

var line3 = Line(gradient: 2.0, intercept: 2.0, x: 3.0);
print(line3); // Output: Line(Point(3.0, 8.0), Point(4.0, 10.0))

var line4 = Line(y: 1.0, gradient: 2.0, intercept: 3.0);
print(line4); // Output: Line(Point(-1.0, 1.0), Point(0.0, 3.0))

var line5 = Line(y: 1.0, gradient: -0.5, intercept: 7.0);
print(line5); // Output: Line(Point(-12.0, 1.0), Point(-11.0, 5.5))

var line6 = Line(y: 1.0, gradient: 2.0, x: 1.0);
print(line6); // Output: Line(Point(1.0, 1.0), Point(2.0, 3.0))
```

### Plane

A class that represents a plane in a three-dimensional space.
Each instance of this class is defined by a [Point] and a normal [Vector].

```dart
var point = Point(1, 2, 3);
var normal = Vector(1, 0, 0);
var plane = Plane(point, normal);
print(plane);  // Output: Plane(point: Point(1, 2, 3), normal: Vector(1, 0, 0))
var pivot = Point(2, 3, 4);
var perpendicularLine = plane.perpendicularLine(pivot);
print(perpendicularLine);  // Output: Plane(Point(2, 3, 4), Vector(1, 0, 0))
var otherPoint = Point(1, 3, 4);
var newPlane = plane.parallelThroughPoint(otherPoint);
print(newPlane);  // Output: Plane(point: Point(1, 3, 4), normal: Vector(1, 0, 0))
```

### Circle

A `Circle` is represented by a center point and a radius.

```dart
var center = Point(0, 0);
var circle = Circle(center, 5);
print(circle.area()); // Output: 78.53981633974483
print(circle.circumference()); // Output: 31.41592653589793
print(circle.isPointInside(Point(3, 4))); // Output: true
```

### Polygon

A `Polygon` is represented by a list of points. The points should be ordered either clockwise or counter-clockwise.

```dart
Point p1 = Point(0, 0);
Point p2 = Point(1, 0);
Point p3 = Point(0, 1);
Polygon triangle = Polygon([p1, p2, p3]);
print(triangle.area); // prints: 0.5
```

Other things you could do with polygon are area with different methods, compute lengths, scale, perimeter etc.

```dart
var vertices = [
  Point(1613.26, 2418.11),
  Point(1806.71, 2523.16),
  Point(1942.17, 2366.84),
  Point(1901.89, 2203.18),
  Point(1652.08, 2259.26)
];

var polygon = Polygon(vertices: vertices);
print(polygon);
print('');

print('Area:');
print("Shoelace formula: ${polygon.shoelace()}");
print("Triangulation: ${polygon.triangulation()}");
print("Trapezoidal rule: ${polygon.trapezoidal()}");
print("Monte Carlo method (10,000 points): ${polygon.monteCarlo()}");
print("Green's theorem: ${polygon.greensTheorem()}");

print("\nCentroid: ${polygon.centroid()}");
print("Moment of inertia: ${polygon.momentOfInertia()}");

print("\nAngle Between Side 1 and 2: ${polygon.angleBetweenSides(0, 1)}");
print("Length of side 1: ${polygon.sideLengthIrregular(0)}");
print("Length of side 2: ${polygon.sideLengthIrregular(1)}");

print(
    "\nIs Point(1806.71, 2523.16) inside: ${polygon.isPointInsidePolygon(Point(1806.71, 2400.16))}");
print("Is convex: ${polygon.isConvex()}");

print("\nBounding box: ${polygon.boundingBox()}");

print("\nOriginal: ${polygon.vertices}");
polygon.scale(2.5);
print("\nScaled by 2.5: ${polygon.vertices}");

polygon.scale(1 / 2.5);
print("\nUnScale by 1/2.5: ${polygon.vertices}");

polygon.translate(1.0, 1.0);
print("\nTranslated by (1.0, 1.0): ${polygon.vertices}");

print(
    "\nNearest point on the polygon to (1920.17, 2200.18): ${polygon.nearestPointOnPolygon(Point(1920.17, 2200.18))}");

printLine('Regular Polygon');

var regPolygon = RegularPolygon(numSides: 5, sideLength: 4);

print("Area: ${regPolygon.areaPolygon()}");
print("Perimeter: ${regPolygon.perimeter()}");
print("Interior angle: ${regPolygon.interiorAngle()}");
print("Exterior angle: ${regPolygon.exteriorAngle()}\n\n");

var perimeter = regPolygon.perimeter();
var area = regPolygon.areaPolygon();
var circumradius = regPolygon.circumradius();
var inradius = regPolygon.inradius();

polygon = Polygon(numSides: regPolygon.numSides);

print(
    "Side length from perimeter: ${polygon.getSideLength(perimeter: perimeter)}");
print("Side length from area: ${polygon.getSideLength(area: area)}");
print(
    "Side length from circumradius: ${polygon.getSideLength(circumradius: circumradius)}");
print(
    "Side length from inradius: ${polygon.getSideLength(inradius: inradius)}");
```

Results:

```txt

Polygon(
num_sides=5,
side_length=null,
vertices=[Point(1613.26, 2418.11), Point(1806.71, 2523.16), Point(1942.17, 2366.84), Point(1901.89, 2203.18), Point(1652.08, 2259.26)])

Area:
Shoelace formula: 68935.01805000007
Triangulation: 68935.01804999998
Trapezoidal rule: 68935.01805000001
Monte Carlo method (10,000 points): 69777.18425340003
Green's theorem: 68935.01805000007

Centroid: Point(1783.2220000000002, 2354.11)
Moment of inertia: 219478041763.1118

Angle Between Side 1 and 2: 1.313000433887411
Length of side 1: 220.13269861608467
Length of side 2: 206.84620857052207

Is Point(1806.71, 2523.16) inside: true
Is convex: true

Bounding box: [Point(1613.26, 2203.18), Point(1942.17, 2203.18), Point(1942.17, 2523.16), Point(1613.26, 2523.16)]

Original: [Point(1613.26, 2418.11), Point(1806.71, 2523.16), Point(1942.17, 2366.84), Point(1901.89, 2203.18), Point(1652.08, 2259.26)]

Scaled by 2.5: [Point(4033.15, 6045.275000000001), Point(4516.775, 6307.9), Point(4855.425, 5917.1), Point(4754.725, 5507.95), Point(4130.2, 5648.150000000001)]

UnScale by 1/2.5: [Point(1613.2600000000002, 2418.11), Point(1806.71, 2523.16), Point(1942.17, 2366.84), Point(1901.8900000000003, 2203.18), Point(1652.08, 2259.26)]

Translated by (1.0, 1.0): [Point(1614.2600000000002, 2419.11), Point(1807.71, 2524.16), Point(1943.17, 2367.84), Point(1902.8900000000003, 2204.18), Point(1653.08, 2260.26)]

Nearest point on the polygon to (1920.17, 2200.18): Point(1920.17, 2200.18)

--- --- --- --- --- --- --- --- --- --- Regular Polygon --- --- --- --- --- --- --- --- --- ---

Area: 27.52763840942347
Perimeter: 20.0
Interior angle: 108.0
Exterior angle: 72.0


Side length from perimeter: 4.0
Side length from area: 4.0
Side length from circumradius: 4.0
Side length from inradius: 4.0
```

### Triangle

A `Triangle` is a special kind of polygon. It can be created by providing the lengths of its sides, or its coordinates.

```dart
Triangle triangle1 = Triangle(a: 3, b: 4, c: 5);
print(triangle1.area(AreaMethod.heron)); // prints: 6.0

Triangle triangle2 = Triangle(A: Point(0, 0), B: Point(3, 0), C: Point(0, 4));
print(triangle2.area(AreaMethod.coordinates)); // prints: 6.0
```

### SphericalTriangle

A `SphericalTriangle` is a triangle on the surface of a sphere. It can be created by providing the lengths of its sides and the radius of the sphere.

```dart
  var triangle = SphericalTriangle.fromAllSides( Angle(rad: pi / 2), Angle(rad: pi / 3), Angle(rad: pi / 4));

  // Angles
  print('AngleA: ${triangle.angleA} '); // AngleA: Angle: 35.26438968275524° or 0.6154797086703871 rad or [35, 15, 51.802857918852396]
  print('AngleB: ${triangle.angleB} '); // AngleB: Angle: 125.26438968275677° or 2.186276035465284 rad or [125, 15, 51.80285792437758]
  print('AngleC: ${triangle.angleC}'); // AngleC: Angle: 45.00000000000074° or 0.785398163397448 rad or [45, 0, 2.660272002685815e-9]

  // Sides
  print('SideA: ${triangle.sideA}'); // SideA: Angle: 90.00000000000152° or 1.5707963267948966 rad or [90, 0, 5.474021236295812e-9]
  print('SideB: ${triangle.sideB}'); // SideB: Angle: 60.00000000000101° or 1.0471975511965976 rad or [60, 0, 3.632294465205632e-9]
  print('SideC: ${triangle.sideC} '); // SideC: Angle: 45.00000000000076° or 0.7853981633974483 rad or [45, 0, 2.737010618147906e-9]

  print('Area: ${triangle.area} ≈ ${triangle.areaPercentage} % of unit sphere surface area'); // Area: 0.445561253943326 ≈ 3.545663800765179 % of unit sphere surface area
  print('Perimeter: ${triangle.perimeter} ≈ ${triangle.perimeterPercentage} % of unit sphere circumference'); // Perimeter: 3.4033920413889422 ≈ 54.166666666666664 % of unit sphere circumference
  print('isValidTriangle: ${triangle.isValidTriangle()}'); // isValidTriangle: true
```

</details>

<details>
<summary>POLYNOMIALS</summary>

# Polynomials

The Geometry Library provides comprehensive support for Polynomials. This includes polynomials of different degrees, from linear to quartic, as well as a general polynomial implementation using the Durand-Kerner method for degrees of 5 or higher.

## Usage

### Linear

Linear polynomials are of the form ax + b = 0.

```dart
Linear linear = Linear.num(a: 2, b: -3);
print(linear.roots()); // Output: [1.5]
```

### Quadratic

Quadratic polynomials are of the form ax² + bx + c = 0.

```dart
Quadratic quad = Quadratic.num(a: 2, b: -3, c: -2);
print(quad.roots()); // Output: [2.0, -0.5]
print(quad.vertex()); // Output: [0.75, -3.125]
```

### Cubic

Cubic polynomials are of the form ax³ + bx² + cx + d = 0.

```dart
Cubic cubic = Cubic.num(a: -1, b: 1, c: 1, d: 2);
print(cubic.roots()); // Output: [-1.0, -1.0, 2.0]
```

### Quartic

Quartic polynomials are of the form ax⁴ + bx³ + cx² + dx + e = 0.

```dart
Quartic quartic = Quartic.num(a: -1, b: -8, c: 0, d: 0, e: -1);
print(quartic.roots()); // Output: [1.0, -1.0, -1.0, -1.0]
```

### Durand-Kerner

This is a general polynomial implementation that uses the Durand-Kerner method to find the roots of a polynomial with a degree of 5 or higher.

```dart
DurandKerner dk = DurandKerner.num([1, 5, 1, 4, 0, 3, 2]);
print(dk.degree); // 6
print(dk); // x⁶ + 5x⁵ + x⁴ + 4x³ + 3x + 2
print(dk.roots());
// [-0.34289017575006814 + 0.9530107213799093i, -0.34289017581899034 - 0.9530107213040406i, 0.5696766117867249 + 0.6923844884012686i, -4.9651242864231895, 0.5696766117855657 - 0.6923844884824355i, -0.4884485856011231]
```

### Additional Features

Each of these polynomials can be differentiated, integrated, simplified, and evaluated.

```dart
Polynomial poly = Polynomial.fromList([3, -6, 12]);
print(poly); // 3x² - 6x + 12
print(poly.simplify()); // x² - 2x + 4
print(poly.roots()); // [1 + 1.7320508075688774i, 1 - 1.7320508075688774i]
print(poly.differentiate()); // 6x - 6
print(poly.integrate()); // x³ - 3x² + 12x
print(poly.evaluate(2)); // 12.0
```

```dart
Polynomial p = Polynomial.fromString("x^5 - x^4 - x + 1");
print(p.coefficients); // [1.0, -1.0, 0, 0, -1.0, 1.0]
print(p); // x⁵ - x⁴ - x + 1.0
print(p.evaluate(Complex(-19 / 8, 7.119033245839726e-16))); // -104.00619506835938
print(p.roots());
// [2.481185557213347e-11 - 0.9999999999737949i, -1.0000000000550548 + 3.5929979905099436e-11i, 1.0000004031257346 + 2.7703711854406305e-7i, 5.095265802549413e-11 + 1.0000000000706935i, 1.0000004031257346 + 2.7703711854406305e-7i]
print('');
```

</details>

<details>
<summary>ROMAN NUMERALS</summary>

# Roman Numerals

A Dart class designed to provide efficient conversions between Roman numerals and integers. This class also supports arithmetic operations directly on Roman numeral representations.

## Features

- Convert integers to Roman numerals and vice versa.
- Supports numbers up to 3,999 using standard Roman numerals.
- Supports numbers above 3,999 using parentheses notation.
- Provides arithmetic operations on Roman numerals.
- Caches recent conversions for performance.

## Usage

### Instantiation

```dart
RomanNumerals romanFive = RomanNumerals(5);
print(romanFive) // V
print(RomanNumerals(69)); // LXIX
print(RomanNumerals(8785)); // (VIII)DCCLXXXV
```

### Conversion from Roman to Integer

```dart
RomanNumerals romanYear = RomanNumerals.fromRoman("MMXXIII");
print(romanYear.value);  // Outputs: 2023
print(RomanNumerals.fromRoman('(VIII)DCCLXXXV').value); // 8785
```

### Arithmetic Operations

```dart
RomanNumerals a = RomanNumerals.fromRoman('MMXXIII'); // 2023
RomanNumerals b = RomanNumerals.fromRoman('X'); // 10

print(a + b); // MMXXXIII
print(a - b); // MMXIII
print(a * b); // (XX)CCXXX
print(a / b); // CCII
print(a % b); // III

print(RomanNumerals.fromRoman('MXXII') - RomanNumerals.fromRoman('LXX') - RomanNumerals.fromRoman('LII')); // CM
print(RomanNumerals.fromRoman('(M)') - RomanNumerals.fromRoman('(CC)DXXV')); // (DCCXCIX)CDLXXV
print(RomanNumerals.fromRoman('(DCCXCIX)CDLXXV').value); // 799475
```

Also support shifting the bits of this integer to the left by [shiftAmount].

```dart
print(a << 1); // (IV)XLVI
print(RomanNumerals.fromRoman('(IV)XLVI').value);
print((a >> 1).value); // 1011
```

### Logical, Comparison Operations

```dart
RomanNumerals a = RomanNumerals.fromRoman('MMXXIII'); // 2023
RomanNumerals b = RomanNumerals.fromRoman('X'); // 10

print(a & b); // II (bitwise AND)
print(a | b); // MMXXXI (bitwise OR)
print(a ^ b); // MMXXIX (bitwise XOR)
print(a == b); // false
print(a > b); // true
print(a < b); // false
print(a >= b); // true
print(a <= b); // false
```

### Date to and from Roman numerals

```dart
  print(RomanNumerals.dateToRoman('August 22, 1989', format: 'MMMM d, y', sep: '・')); // Outputs: VIII・XXII・MCMLXXXIX
  print(RomanNumerals.dateToRoman('Dec-23, 2017', format: 'MMM-d, y')); // Outputs: XII • XXIII • MMXVII
  print(RomanNumerals.dateToRoman('Jul-21, 2016', format: 'MMM-d, y')); // Outputs: VII • XXI • MMXVI

  print(RomanNumerals.romanToDate('VIII・XXII・MCMLXXXIX', format: 'MMMM d, y', sep: '・')); // Outputs: August 22, 1989
```

</details>

<details>
<summary>MATRIX</summary>

# Matrix

## Create a Matrix

You can create a Matrix object in different ways:

Create a 2x2 Matrix from string

```dart
Matrix a = Matrix("1 2 3; 4 5 6; 7 8 9");
print(a);
// Output:
// Matrix: 3x3
// ┌ 1 2 3 ┐
// │ 4 5 6 │
// └ 7 8 9 ┘
```

Create a matrix from a list of lists

```dart
Matrix b = Matrix([[1, 2], [3, 4]]);
print(b);
// Output:
// Matrix: 2x2
// ┌ 1 2 ┐
// └ 3 4 ┘
```

Create a matrix from a list of diagonal objects

```dart
Matrix d = Matrix.fromDiagonal([1, 2, 3]);
print(d);
// Output:
// Matrix: 3x3
// ┌ 1 0 0 ┐
// │ 0 2 0 │
// └ 0 0 3 ┘
```

Create a matrix from a flattened array

```dart
final source = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];
final ma = Matrix.fromFlattenedList(source, 2, 6);
print(ma);
// Output:
// Matrix: 2x6
// ┌ 1 2 3 4 5 6 ┐
// └ 7 8 9 0 0 0 ┘
```

Create a matrix from list of columns

```dart
var col1 = ColumnMatrix([1, 2, 3]);
var col2 = ColumnMatrix([4, 5, 6]);
var col3 = ColumnMatrix([7, 8, 9]);
var matrix = Matrix.fromColumns([col1, col2, col3]);
print(matrix);
// Output:
// Matrix: 3x3
// ┌ 1 4 7 ┐
// | 2 5 8 |
// └ 3 6 9 ┘
```

Create a matrix from list of rows

```dart
var row1 = RowMatrix([1, 2, 3]);
var row2 = RowMatrix([4, 5, 6]);
var row3 = RowMatrix([7, 8, 9]);
var matrix = Matrix.fromRows([row1, row2, row3]);
print(matrix);
// Output:
// Matrix: 3x3
// ┌ 1 2 3 ┐
// | 4 5 6 |
// └ 7 8 9 ┘
```

Create a from a list of lists

```dart
Matrix c = [[1, '2', true],[3, '4', false]].toMatrix()
print(c);
// Output:
// Matrix: 2x3
// ┌ 1 2  true ┐
// └ 3 4 false ┘
```

Create a 2x2 matrix with all zeros

```dart
Matrix zeros = Matrix.zeros(2, 2);
print(zeros)
// Output:
// Matrix: 2x2
// ┌ 0 0 ┐
// └ 0 0 ┘
```

Create a 2x3 matrix with all ones

```dart
Matrix ones = Matrix.ones(2, 3);
print(ones)
// Output:
// Matrix: 2x3
// ┌ 1 1 1 ┐
// └ 1 1 1 ┘
```

Create a 2x2 identity matrix

```dart
Matrix identity = Matrix.eye(2);
print(identity)
// Output:
// Matrix: 2x2
// ┌ 1 0 ┐
// └ 0 1 ┘
```

Create a matrix that is filled with same object

```dart
Matrix e = Matrix.fill(2, 3, 7);
print(e);
// Output:
// Matrix: 2x3
// ┌ 7 7 7 ┐
// └ 7 7 7 ┘
```

Create a matrix from linspace and create a diagonal matrix

```dart
Matrix f = Matrix.linspace(0, 10, 3);
print(f);
// Output:
// Matrix: 1x3
// [ 0.0 5.0 10.0 ]
```

Create from a range or arrange at a step

```dart
var m = Matrix.range(6, start: 1, step: 2, isColumn: false);
print(m);
// Output:
// Matrix: 1x3
// [ 1  3  5 ]
```

Create a random matrix within arange of values

```dart
var randomMatrix = Matrix.random(3, 4, min: 1, max: 10, isDouble: true);
print(randomMatrix);
// Output:
// Matrix: 3x4
// ┌ 3  5  9  2 ┐
// │ 1  7  6  8 │
// └ 4  9  1  3 ┘
```

Create a specific random matrix from the matrix factory

```dart
var randomMatrix = Matrix.factory
  .create(MatrixType.general, 5, 4, min: 0, max: 3, isDouble: true);
print('\n${randomMatrix.round(3)}');
```

Create a specific type of matrix from a random seed with range

```dart
randMat = Matrix.factory.create(MatrixType.general, 5, 4,
    min: 0, max: 3, seed: 12, isDouble: true);
print('\n${randMat.round(3)}');

// Output:
// Matrix: 5x4
// ┌ 1.949 1.388 2.833 1.723 ┐
// │ 0.121 1.954 2.386 2.407 │
// │ 2.758  2.81 1.026 0.737 │
// │ 1.951  0.37 0.075 0.069 │
// └ 2.274 1.932 2.659 0.196 ┘
```

```dart
var randomMatrix = Matrix.factory
    .create(MatrixType.sparse, 5, 5, min: 0, max: 2, seed: 12, isDouble: true);

print('\nProperties of the Matrix:\n${randomMatrix.round(3)}\n');
randomMatrix.matrixProperties().forEach((element) => print(' - $element'));

// Properties of the Matrix:
// Matrix: 5x5
// ┌ 0.0 1.149   0.0 0.0   0.0 ┐
// │ 0.0   0.0 0.925 0.0 1.302 │
// │ 0.0   0.0   0.0 0.0   0.0 │
// │ 0.0   0.0   0.0 0.0   0.0 │
// └ 0.0   0.0   0.0 0.0   0.0 ┘
//
//  - Square Matrix
//  - Upper Triangular Matrix
//  - Singular Matrix
//  - Vandermonde Matrix
//  - Nilpotent Matrix
//  - Sparse Matrix
```

## Check Matrix Properties

Easy much easier to query the properties of a matrix.

```dart
var A = Matrix([
    [4, 1, -1],
    [1, 4, -1],
    [-1, -1, 4]
  ]);
print(A);

print('Shape: ${A.shape}');
print('Max: ${A.max()}');
print('Column Max: ${A.max(axis: 0)}');
print('Row Max: ${A.max(axis: 1)}');
print('Min: ${A.min()}');
print('Column Min: ${A.min(axis: 0)}');
print('Row Min: ${A.min(axis: 1)}');
print('Sum: ${A.sum()}');
print('Absolute Sum: ${A.sum(absolute: true)}');
print('Column Sum: ${A.sum(axis: 0)}');
print('Row Sum: ${A.sum(axis: 1)}');
print('Diagonal Sum: ${A.sum(axis: 2)}');
print('Diagonal Sum TLBR: ${A.sum(axis: 3)}');
print('Diagonal Sum TRBL: ${A.sum(axis: 4)}');
print('Mean: ${A.mean()}');
print('Median: ${A.median()}');
print('Product: ${A.product()}');
print('Variance: ${A.variance()}');
print('Standard Deviation: ${A.standardDeviation()}');
print('Absolute Sum: ${A.sum(absolute: true)}');
print('Determinant: ${A.determinant()}');
print('Rank: ${A.rank()}');
print('Trace: ${A.trace()}');
print('Skewness: ${A.skewness()}');
print('Kurtosis: ${A.kurtosis()}');
print('Condition number: ${A.conditionNumber()}');
print('Decomposition Condition number: ${A.decomposition.conditionNumber()}');

print('Manhattan Norm(l1Norm): ${A.norm(Norm.manhattan)}');
print('Frobenius/Euclidean Norm(l2Norm): ${A.norm(Norm.frobenius)}');
print('Chebyshev/Infinity Norm: ${A.norm(Norm.chebyshev)}');
print('Spectral Norm: ${A.norm(Norm.spectral)}');
print('Trace/Nuclear Norm: ${A.norm(Norm.trace)}');
print('Nullity: ${A.nullity()}');

print('Normalize: ${A.normalize()}\n');
print('Frobenius/Euclidean Normalize: ${A.normalize(Norm.frobenius)}\n');
print('Row Echelon Form: ${A.rowEchelonForm()}\n');
print('Reduced Row Echelon Form: ${A.reducedRowEchelonForm()}\n');
print('Null Space: ${A.nullSpace()}\n');
print('Row Space: ${A.rowSpace()}\n');
print('Column Space: ${A.columnSpace()}\n');
print('Matrix Properties:');
A.matrixProperties().forEach((element) => print(' - $element'));

// Output:
// Matrix: 3x3
// ┌  4  1 -1 ┐
// │  1  4 -1 │
// └ -1 -1  4 ┘
//
// Shape: [3, 3]
// Max: 4
// Column Max: [4, 4, 4]
// Row Max: [4, 4, 4]
// Min: -1
// Column Min: [-1, -1, -1]
// Row Min: [-1, -1, -1]
// Sum: 10
// Absolute Sum: 18
// Column Sum: [4, 4, 2]
// Row Sum: [4, 4, 2]
// Diagonal Sum: 12
// Diagonal Sum TLBR: [-1, 0, 12, 0, -1]
// Diagonal Sum TRBL: [4, 2, 2, -2, 4]
// Mean: 1.1111111111111112
// Median: 1
// Product: 64
// Variance: 4.765432098765432
// Standard Deviation: 2.1829869671542776
// Absolute Sum: 18
// Determinant: 54.0
// Rank: 3
// Trace: 12
// Skewness: 0.3705316948061136
// Kurtosis: -1.58891513866144
// Condition number: 3.6742346141747673
// Decomposition Condition number: 1.9999999999999998
// Manhattan Norm(l1Norm): 6.0
// Frobenius/Euclidean Norm(l2Norm): 7.3484692283495345
// Chebyshev/Infinity Norm: 6.0
// Spectral Norm: 5.999999999999999
// Trace/Nuclear Norm: 12.0
// Nullity: 0
// Normalize: Matrix: 3x3
// ┌   1.0  0.25 -0.25 ┐
// │  0.25   1.0 -0.25 │
// └ -0.25 -0.25   1.0 ┘

// Frobenius/Euclidean Normalize: Matrix: 3x3
// ┌   0.5443310539518174  0.13608276348795434 -0.13608276348795434 ┐
// │  0.13608276348795434   0.5443310539518174 -0.13608276348795434 │
// └ -0.13608276348795434 -0.13608276348795434   0.5443310539518174 ┘

// Row Echelon Form: Matrix: 3x3
// ┌ 1.0 0.25 -0.25 ┐
// │ 0.0  1.0  -0.2 │
// └ 0.0  0.0   1.0 ┘

// Reduced Row Echelon Form: Matrix: 3x3
// ┌ 1.0 0.0 0.0 ┐
// │ 0.0 1.0 0.0 │
// └ 0.0 0.0 1.0 ┘

// Null Space: Matrix: 0x0
// [ ]

// Row Space: Matrix: 3x3
// ┌  4  1 -1 ┐
// │  1  4 -1 │
// └ -1 -1  4 ┘
// Column Space: Matrix: 3x3
// ┌  4  1 -1 ┐
// │  1  4 -1 │
// └ -1 -1  4 ┘

// Matrix Properties:
//  - Square Matrix
//  - Full Rank Matrix
//  - Symmetric Matrix
//  - Non-Singular Matrix
//  - Positive Definite Matrix
//  - Diagonally Dominant Matrix
//  - Strictly Diagonally Dominant Matrix
```

## Matrix Copy

Copy another original matrix

```dart
var a = Matrix();
a.copy(y); // Copy another matrix
```

Copy the elements of the another matrix and resize the current matrix

```dart
var matrixA = Matrix([[1, 2], [3, 4]]);
var matrixB = Matrix([[5, 6], [7, 8], [9, 10]]);
matrixA.copyFrom(matrixB, resize: true);
print(matrixA);
// Output:
// 5  6
// 7  8
// 9 10
```

Copy the elements of the another matrix but retain the current matrix size

```dart
var matrixA = Matrix([[1, 2, 3], [4, 5, 6], [7, 8, 9]]);
var matrixB = Matrix([[10, 11], [12, 13]]);
matrixA.copyFrom(matrixB, retainSize: true);
print(matrixA);
// Output:
// 10 11 3
// 12 13 6
// 7  8  9
```

## Matrix Interoperability

To convert a matrix to a json-serializable map one may use toJson method:

### to<->from JSON

You can serialize the matrix to a json-serializable map and deserialize back to a matrix object.

```dart
final matrix = Matrix.fromList([
    [11.0, 12.0, 13.0, 14.0],
    [15.0, 16.0, 0.0, 18.0],
    [21.0, 22.0, -23.0, 24.0],
    [24.0, 32.0, 53.0, 74.0],
  ]);

// Convert to JSON representation
final serialized = matrix.toJson();
```

To restore a serialized matrix one may use Matrix.fromJson constructor:

```dart
final matrix = Matrix.fromJson(serialized);
```

### to<->from CSV

You can write csv file and read it back to a matrix object.

```dart
String csv = '''
1.0,2.0,3.0
4.0,5.0,6.0
7.0,8.0,9.0
''';
Matrix matrix = await Matrix.fromCSV(csv: csv);
print(matrix);

// Alternatively, read the CSV from a file:
Matrix matrixFromFile = await Matrix.fromCSV(inputFilePath: 'input.csv');
print(matrixFromFile);

// Output:
// Matrix: 3x3
// ┌ 1.0 2.0 3.0 ┐
// │ 4.0 5.0 6.0 │
// └ 7.0 8.0 9.0 ┘
```

Write to a csv file

````dart
String csv = matrix.toCSV(outputFilePath: 'output.csv');
print(csv);

// Output:
// ```
// 1.0,2.0,3.0
// 4.0,5.0,6.0
// 7.0,8.0,9.0
// ```
````

### to<->from Binary Data

You can serialize the matrix to a json-serializable map and deserialize back to a matrix object.

```dart
ByteData bd1 = matrix.toBinary(jsonFormat: false); // Binary format
ByteData bd2 = matrix.toBinary(jsonFormat: true); // JSON format
```

To restore a serialized matrix one may use Matrix.fromBinary constructor:

```dart
Matrix m1 = Matrix.fromBinary(bd1, jsonFormat: false); // Binary format
Matrix m2 = Matrix.fromBinary(bd2, jsonFormat: true); // JSON format
```

## Matrix Operations

Perform matrix arithmetic operations:

```dart
Matrix a = Matrix([
  [1, 2],
  [3, 4]
]);

Matrix b = Matrix([
  [5, 6],
  [7, 8]
]);

// Addition of two square matrices
Matrix sum = a + b;
print(sum);
// Output:
// Matrix: 2x2
// ┌  6  8 ┐
// └ 10 12 ┘

// Addition of a matrix and a scalar
print(a + 2);
// Output:
// Matrix: 2x2
// ┌ 3 4 ┐
// └ 5 6 ┘

// Subtraction of two square matrices
Matrix difference = a - b;
print(difference);
// Output:
// Matrix: 2x2
// ┌ -4 -4 ┐
// └ -4 -4 ┘

// Matrix Scaler multiplication
Matrix scaler = a * 2;
print(scaler);
// Output:
// Matrix: 2x2
// ┌ 2 4 ┐
// └ 6 8 ┘

// Matrix dot product
Matrix product = a * Column([4,5]);
print(product);
// Output:
// Matrix: 2x1
// ┌ 14.0 ┐
// └ 32.0 ┘

// Matrix division
Matrix division = b / 2;
print(division);
// Output:
// Matrix: 2x2
// ┌ 2.5 3.0 ┐
// └ 3.5 4.0 ┘

// NB: For element-wise division, use elementDivision()
Matrix elementDivision = a.elementDivide(b);
print(elementDivision);
// Output:
// Matrix: 2x2
// ┌                 0.2 0.3333333333333333 ┐
// └ 0.42857142857142855                0.5 ┘

// Matrix exponent
Matrix expo = b ^ 2;
print(expo);
// Output:
// Matrix: 2x2
// ┌ 67  78 ┐
// └ 91 106 ┘

// Negate Matrix
Matrix negated = -a;
print(negated);
// Output:
// Matrix: 2x2
// ┌ -1 -2 ┐
// └ -3 -4 ┘

// Element-wise operation with function
var result = a.elementWise(b, (x, y) => x * y);
print(result);
// Output:
// Matrix: 2x2
// ┌  5 12 ┐
// └ 21 32 ┘

var matrix = Matrix([[-1, 2], [3, -4]]);
var abs = matrix.abs();
print(abs);
// Output:
// Matrix: 2x2
// ┌ 1 2 ┐
// └ 3 4 ┘

// Matrix Reciprocal round to 2 decimal places
var matrix = Matrix([[1, 2], [3, 4]]);
var reciprocal = matrix.reciprocal();
print(reciprocal.round(2));
// Output:
// Matrix: 2x2
// ┌                1.0  0.5 ┐
// └ 0.3333333333333333 0.25 ┘

// Round the elements to a decimal place
print(reciprocal.round(2));
// Output:
// Matrix: 2x2
// ┌  1.0  0.5 ┐
// └ 0.33 0.25 ┘

// Matrix dot product
var matrixB = Matrix([[2, 0], [1, 2]]);
var result = matrix.dot(matrixB);
print(result);
// Output:
// Matrix: 2x2
// ┌  4 4 ┐
// └ 10 8 ┘

// Determinant of a matrix
var determinant = matrix.determinant();
print(determinant); // Output: -2.0

// Inverse of Matrix
var inverse = matrix.inverse();
print(inverse);
// Output:
// Matrix: 2x2
// ┌ -0.5  1.5 ┐
// └  1.0 -2.0 ┘

// Transpose of a matrix
var transpose = matrix.transpose();
print(transpose);
// Output:
// Matrix: 2x2
// ┌ 4.0 2.0 ┐
// └ 3.0 1.0 ┘

// Find the normalized matrix
var normalize = matrix.normalize();
print(normalize);
// Output:
// Matrix: 2x2
// ┌ 1.0 0.75 ┐
// └ 0.5 0.25 ┘

// Norm of a matrix
var norm = matrix.norm();
print(norm); // Output: 5.477225575051661

// Sum of all the elements in a matrix
var sum = matrix.sum();
print(sum); // Output: 10

// determine the trace of a matrix
var trace = matrix.trace();
print(trace); // Output: 5
```

You can also perform matrix `cumsum` similar to numpy's function but with more flexibilities.

```dart
var arr = Matrix([
    [1, 5, 6],
    [4, 7, 2],
    [3, 1, 9]
  ]);

  print(arr.cumsum(continuous: true));
  // [ 1  6 12 16 23 25 28 29 38 ]

  print(arr.cumsum(continuous: false));
  // [ 1  6 12 4 11 13 3  4 13 ]

  print(arr.cumsum(continuous: false, axis: 0));
  // Matrix: 3x3
  // ┌ 1  5  6 ┐
  // │ 5 12  8 │
  // └ 8 13 17 ┘

  print(arr.cumsum(continuous: true, axis: 0));
  // Matrix: 3x3
  // ┌ 1 13 27 ┐
  // │ 5 20 29 │
  // └ 8 21 38 ┘

  print(arr.cumsum(continuous: false, axis: 1));
  // Matrix: 3x3
  // ┌ 1  6 12 ┐
  // │ 4 11 13 │
  // └ 3  4 13 ┘

  print(arr.cumsum(continuous: true, axis: 1));
  // Matrix: 3x3
  // ┌  1  6 12 ┐
  // │ 16 23 25 │
  // └ 28 29 38 ┘

  print(arr.cumsum(continuous: false, axis: 2));
  // Matrix: 3x3
  // ┌ 1 5  6 ┐
  // │ 4 8  7 │
  // └ 3 5 17 ┘

  print(arr.cumsum(continuous: true, axis: 2));
  // Matrix: 3x3
  // ┌ 9 30 38 ┐
  // │ 7 16 32 │
  // └ 3 8  25 ┘

  print(arr.cumsum(continuous: false, axis: 3));
  // Matrix: 3x3
  // ┌ 1 9  16 ┐
  // │ 4 10 3  │
  // └ 3 1  9  ┘

  print(arr.cumsum(continuous: true, axis: 3));
  // Matrix: 3x3
  // ┌ 38 37 28 ┐
  // │ 32 22 12 │
  // └ 15 10  9 ┘

  print(arr.cumsum(continuous: false, axis: 4));
  // Matrix: 3x3
  // ┌ 1  5  6 ┐
  // │ 9  13 2 │
  // └ 16 3  9 ┘

  print(arr.cumsum(continuous: true, axis: 4));
  // Matrix: 3x3
  // ┌ 38 33 18 ┐
  // │ 37 25 11 │
  // └ 28 12  9 ┘
```

## Assessing the elements of a matrix

Matrix can be accessed as components

```dart
var v = Matrix([
  [1, 2, 3],
  [4, 5, 6],
  [1, 3, 5]
]);
var b = Matrix([
  [7, 8, 9],
  [4, 6, 8],
  [1, 2, 3]
]);

var r = RowMatrix([7, 8, 9]);
var c = ColumnMatrix([7, 4, 1]);
var d = DiagonalMatrix([1, 2, 3]);

print(d);
// Output:
// 1 0 0
// 0 2 0
// 0 0 3
```

Change or use element value

```dart
v[1][2] = 0;

var u = v[1][2] + r[0][1];
print(u); // 9

var z = v[0][0] + c[0][0];
print(z); // 8

var y = v[1][2] + b[1][1];
print(y); // 9

var k = v.row(1); // Get all elements in row 1
print(k); // [1,2,3]

var n = v.column(1); // Get all elements in column 1
print(n); // [1,4,1]
```

Index (row,column) of an element in the matrix

```dart
var mat = Matrix.fromList([
  [2, 3, 3, 3],
  [9, 9, 8, 6],
  [1, 1, 2, 9]
]);

var index = mat.indexOf(8);
print(index);
// Output: [1, 2]

var indices = mat.indexOf(3, findAll: true);
print(indices);
// Output: [[0, 1], [0, 2], [0, 3]]
```

Access Row and Column

```dart
var mat = Matrix.fromList([
  [2, 3, 3, 3],
  [9, 9, 8, 6],
  [1, 1, 2, 9]
]);

print(mat[0]);
print(mat.row(0));

// Access column
print(mat.column(0));

// update row method 1
mat[0] = [1, 2, 3, 4];
print(mat);

// update row method 2
var v = mat.setRow(0, [4, 5, 6, 7]);
print(v);

// Update column
v = mat.setColumn(0, [1, 4, 5]);
print(v);

// Insert row
v = mat.insertRow(0, [8, 8, 8, 8]);
print(v);

// Insert column
v = mat.insertColumn(4, [8, 8, 8, 8]);
print(v);

// Delete row
print(mat.removeRow(0));

// Delete column
print(mat.removeColumn(0));

// Delete rows
mat.removeRows([0, 1]);

// Delete columns
mat.removeColumns([0, 2]);
```

### Iterable objects from a matrix

You can get the iterable from a matrix object. Consider the matrix below:

```dart
var mat = Matrix.fromList([
  [2, 3, 3, 3],
  [9, 9, 8, 6],
  [1, 1, 2, 9]
]);
```

Iterate through the rows of the matrix using the default iterator

```dart
for (List<dynamic> row in mat.rows) {
  print(row);
}
```

Iterate through the columns of the matrix using the column iterator

```dart
for (List<dynamic> column in mat.columns) {
  print(column);
}
```

Iterate through the elements of the matrix using the element iterator

```dart
for (dynamic element in mat.elements) {
  print(element);
}
```

Iterate through elements in the matrix using foreach method

```dart
var m = Matrix([[1, 2], [3, 4]]);
m.forEach((x) => print(x));
// Output:
// 1
// 2
// 3
// 4
```

## Partition of Matrix

```dart
// create a matrix
  Matrix m = Matrix([
    [1, 2, 3, 4, 5],
    [6, 7, 8, 9, 10],
    [5, 7, 8, 9, 10]
  ]);

// Extract a subMatrix with rows 1 to 2 and columns 1 to 2
Matrix sub = m.subMatrix(rowRange: "1:2", colRange: "0:1");

Matrix sub = m.subMatrix(rowStart: 1, rowEnd: 2, colStart: 0, colEnd: 1);

// sub-matrix will be:
// [
//   [6]
// ]

sub = m.subMatrix(rowList: [0, 2], colList: [0, 2, 4]);
// sub will be:
// [
//   [1, 3, 5],
//   [5, 8, 10]
// ]

sub = m.subMatrix(columnIndices: [4, 4, 2]);
 print("\nsub array: $sub");
// sub array: Matrix: 3x3
// ┌  5  5 3 ┐
// │ 10 10 8 │
// └ 10 10 8 ┘

// Get a sub-matrix
Matrix subMatrix = m.slice(0, 1, 1, 3);
```

## Manipulating the matrix

Manipulate the matrices

1. concatenate on axis 0

```dart
var l1 = Matrix([
  [1, 1, 1],
  [1, 1, 1],
  [1, 1, 1]
]);
var l2 = Matrix([
  [0, 0, 0],
  [0, 0, 0],
  [0, 0, 0],
  [0, 0, 0],
]);
var l3 = Matrix().concatenate([l1, l2]);
print(l3);
// Output:
// Matrix: 7x3
// ┌ 1 1 1 ┐
// │ 1 1 1 │
// │ 1 1 1 │
// │ 0 0 0 │
// │ 0 0 0 │
// │ 0 0 0 │
// └ 0 0 0 ┘
```

2. concatenate on axis 1

```dart
var a1 = Matrix([
  [1, 1, 1, 1],
  [1, 1, 1, 1],
  [1, 1, 1, 1]
]);
var a2 = Matrix([
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
]);

var a3 = Matrix().concatenate([a2, a1], axis: 1);

a3 = a2.concatenate([a1], axis: 1);
print(a3);
// Output:
// Matrix: 3x14
// ┌ 0 0 0 0 0 0 0 0 0 0 1 1 1 1 ┐
// │ 0 0 0 0 0 0 0 0 0 0 1 1 1 1 │
// └ 0 0 0 0 0 0 0 0 0 0 1 1 1 1 ┘
```

Reshape the matrix

```dart
var matrix = Matrix([[1, 2], [3, 4]]);
var reshaped = matrix.reshape(1, 4);
print(reshaped);
// Output:
// 1  2  3  4
```

## Solving Linear Systems of Equations

Use the solve method to solve a linear system of equations:

```dart
Matrix a = Matrix([[2, 1, 1], [1, 3, 2], [1, 0, 0]]);;

Matrix b = Matrix([[4], [5], [6]]);

// Solve the linear system Ax = b
Matrix x = a.linear.solve(b, method: LinearSystemMethod.gaussElimination);
print(x.round(1));
// Output:
// Matrix: 3x1
// ┌   6.0 ┐
// │  15.0 │
// └ -23.0 ┘
```

You can also use the the decompositions to solve a linear system of equations

```dart
Matrix A = Matrix([
  [4, 1, -1],
  [1, 4, -1],
  [-1, -1, 4]
]);
Matrix b = Matrix([
  [6],
  [25],
  [14]
]);

//Solve using the Schur Decomposition
SchurDecomposition schur = A.decomposition.schurDecomposition();

//Solve using the QR Decomposition Householder
QRDecomposition qr = A.decomposition.qrDecompositionHouseholder();

// Solve for x using the object
var x = qr.solve(b).round();
print(x);

// Output:
// Matrix: 3x1
// ┌ 1 ┐
// │ 7 │
// └ 6 ┘
```

## Boolean Operations

Some functions in the library that results in boolean values

```dart
// Check contain or not
var matrix1 = Matrix([[1, 2], [3, 4]]);
var matrix2 = Matrix([[5, 6], [7, 8]]);
var matrix3 = Matrix([[1, 2, 3], [3, 4, 5], [5, 6, 7]]);
var targetMatrix = Matrix([[1, 2], [3, 4]]);

print(targetMatrix.containsIn([matrix1, matrix2])); // Output: true
print(targetMatrix.containsIn([matrix2, matrix3])); // Output: false

print(targetMatrix.notIn([matrix2, matrix3])); // Output: true
print(targetMatrix.notIn([matrix1, matrix2])); // Output: false

print(targetMatrix.isSubMatrix(matrix3)); // Output: true
```

Check Equality of Matrix

```dart
var m1 = Matrix([[1, 2], [3, 4]]);
var m2 = Matrix([[1, 2], [3, 4]]);
print(m1 == m2); // Output: true

print(m1.notEqual(m2)); // Output: false

```

Compare elements of Matrix

```dart
var m = Matrix.fromList([
    [2, 3, 3, 3],
    [9, 9, 8, 6],
    [1, 1, 2, 9]
  ]);
var result = Matrix.compare(m, '>', 2);
print(result);
// Output:
// Matrix: 3x4
// ┌ false  true  true true ┐
// │  true  true  true true │
// └ false false false true ┘
```

## Sorting Matrix

```dart
Matrix x = Matrix.fromList([
  [2, 3, 3, 3],
  [9, 9, 8, 6],
  [1, 1, 2, 9],
  [0, 1, 1, 1]
]);

//Sorting all elements in ascending order (default behavior):
var sortedMatrix = x.sort();
print(sortedMatrix);
// Matrix: 4x4
// ┌ 0 1 1 1 ┐
// │ 1 1 2 2 │
// │ 3 3 3 6 │
// └ 8 9 9 9 ┘

// Sorting all elements in descending order:
var sortedMatrix1 = x.sort(ascending: false);
print(sortedMatrix1);
// Matrix: 4x4
// ┌ 9 9 9 8 ┐
// │ 6 3 3 3 │
// │ 2 2 1 1 │
// └ 1 1 1 0 ┘

// Sort by a single column in descending order
var sortedMatrix2 = x.sort(columnIndices: [0]);
print(sortedMatrix2);
// Matrix: 4x4
// ┌ 0 1 1 1 ┐
// │ 1 1 2 9 │
// │ 2 3 3 3 │
// └ 9 9 8 6 ┘

// Sort by multiple columns in specified orders
var sortedMatrix3 = x.sort(columnIndices: [1, 0]);
print(sortedMatrix3);
// Matrix: 4x4
// ┌ 0 1 1 1 ┐
// │ 1 1 2 9 │
// │ 2 3 3 3 │
// └ 9 9 8 6 ┘

// Sorting rows based on the values in column 2 (descending order):
Matrix xSortedColumn2Descending =
    x.sort(columnIndices: [2], ascending: false);
print(xSortedColumn2Descending);
// Matrix: 4x4
// ┌ 9 9 8 6 ┐
// │ 2 3 3 3 │
// │ 1 1 2 9 │
// └ 0 1 1 1 ┘
```

## Roll Matrix

Roll elements along a given axis. Elements that roll beyond the last position are re-introduced at the first.

This function work exactly like the NumPy's roll.

- shift : int or tuple of ints
  The number of places by which elements are shifted. If a tuple, then axis must be a tuple of the same size, and each of the given axes is shifted by the corresponding number. If an int while axis is a tuple of ints, then the same value is used for all given axes.
- axis : int or tuple of ints or null
  Axis or axes along which elements are shifted. By default, the array is flattened before shifting, after which the original shape is restored.

```dart
Matrix x2 = Matrix([
  [0, 1, 2, 3, 4],
  [5, 6, 7, 8, 9]
]);

print(x2.roll(1));
// Matrix: 2x5
// ┌ 9 0 1 2 3 ┐
// └ 4 5 6 7 8 ┘

print(x2.roll(-1));
// Matrix: 2x5
// ┌ 1 2 3 4 5 ┐
// └ 6 7 8 9 0 ┘

print(x2.roll(1, axis: 0));
// Matrix: 2x5
// ┌ 5 6 7 8 9 ┐
// └ 0 1 2 3 4 ┘

print(x2.roll(-1, axis: 0));
// Matrix: 2x5
// ┌ 5 6 7 8 9 ┐
// └ 0 1 2 3 4 ┘

print(x2.roll(1, axis: 1));
// Matrix: 2x5
// ┌ 4 0 1 2 3 ┐
// └ 9 5 6 7 8 ┘

print(x2.roll(-1, axis: 1));
// Matrix: 2x5
// ┌ 1 2 3 4 0 ┐
// └ 6 7 8 9 5 ┘

print(x2.roll((1, 1), axis: (1, 0)));
// Matrix: 2x5
// ┌ 9 5 6 7 8 ┐
// └ 4 0 1 2 3 ┘

print(x2.roll((2, 1), axis: (1, 0)));
// Matrix: 2x5
// ┌ 8 9 5 6 7 ┐
// └ 3 4 0 1 2 ┘

print(x2.roll((1, 2), axis: (1, 0)));
// Matrix: 2x5
// ┌ 8 9 5 6 7 ┐
// └ 3 4 0 1 2 ┘

print(x2.roll((1, 2)));
// Matrix: 2x5
// ┌ 7 8 9 0 1 ┐
// └ 2 3 4 5 6 ┘

// Shift Value Larger than Matrix Size
print(x2.roll(7));
// Matrix: 2x5
// ┌ 3 4 5 6 7 ┐
// └ 8 9 0 1 2 ┘
```

## Eigen Values and Vectors

```dart
var matr = Matrix.fromList([
  [4, 1, 1],
  [1, 4, 1],
  [1, 1, 4]
]);

var eigen = matr.eigen();
print('Eigen Values:\n${eigen.values}\n');
print('Eigenvectors:');
for (Matrix eigenvector in eigen.vectors) {
  print(eigenvector.round(1));
}

print('\nVerification: ${eigen.verify(matr)}');
print('Reconstruct Original:\n ${eigen.check}\n');

List<Matrix> normalizedEigenvectors =
    eigen.vectors.map((vector) => vector.normalize()).toList();
Eigen normalizedEigen = Eigen(eigen.values, normalizedEigenvectors);

print('Normalized eigenvectors:');
for (Matrix eigenvector in normalizedEigen.vectors) {
  print(eigenvector.round());
}
print('Reconstruct Original:\n ${normalizedEigen.check}\n');

eigen = Eigen([
    6,
    3,
    3
  ], [
  ColumnMatrix([1, 1, 1]),
  ColumnMatrix([-1, 1, 0]),
  ColumnMatrix([-1, 0, 1]),
]);
print('Check Matrix: ${eigen.check}');
```

```txt
Eigen Values:
[5.999999999999997, 2.9999999999999996, 3.000000000000001]

Eigenvectors:
Matrix: 3x1
┌ 0.6 ┐
│ 0.6 │
└ 0.6 ┘
Matrix: 3x1
┌ -0.7 ┐
│  0.7 │
└  0.0 ┘
Matrix: 3x1
┌ -0.4 ┐
│ -0.4 │
└  0.8 ┘

Verification: true
Reconstruct Original:
 Matrix: 3x3
┌  4.000000000058206 1.0000000000145517 1.0000000000145504 ┐
│ 1.0000000000145506 3.9999999999708953 0.9999999999708946 │
└ 1.0000000000145506 0.9999999999708964 3.9999999999708966 ┘

Normalized eigenvectors:
Matrix: 3x1
┌ 1 ┐
│ 1 │
└ 1 ┘
Matrix: 3x1
┌ -1 ┐
│  1 │
└  0 ┘
Matrix: 3x1
┌ 0 ┐
│ 0 │
└ 1 ┘

Reconstruct Original:
 Matrix: 3x3
┌  4.000000000058206 1.0000000000145512 1.0000000000145506 ┐
│ 1.0000000000145506 3.9999999999708953 0.9999999999708954 │
└ 1.0000000000145506 0.9999999999708962 3.9999999999708966 ┘

Check Matrix: Matrix: 3x3
┌ 4.0 1.0 1.0 ┐
│ 1.0 4.0 1.0 │
└ 1.0 1.0 4.0 ┘
```

## Other Functions of matrices

The Matrix class provides various other functions for matrix manipulation and analysis.

```dart

// Swap rows
var matrix = Matrix([[1, 2], [3, 4]]);
matrix.swapRows(0, 1);
print(matrix);
// Output:
// Matrix: 2x2
// ┌ 3 4 ┐
// └ 1 2 ┘

// Swap columns
matrix.swapColumns(0, 1);
print(matrix);
// Output:
// Matrix: 2x2
// ┌ 4 3 ┐
// └ 2 1 ┘

// Get the leading diagonal of the matrix
var m = Matrix([[1, 2], [3, 4]]);
var diag = m.diagonal();
print(diag);
// Output: [1, 4]

// Iterate through elements in the matrix using map function
var doubled = m.map((x) => x * 2);
print(doubled);
// Output:
// Matrix: 2x2
// ┌ 2 4 ┐
// └ 6 8 ┘
```

</details>

<details>
<summary>VECTOR</summary>

## Create a new vector

- `Vector(int length, {bool isDouble = true})`: Creates a [Vector] of given length with all elements initialized to 0.
- `Vector.fromList(List<num> data)`: Constructs a [Vector] from a list of numerical values.
- `Vector.random(int length,{double min = 0, double max = 1, bool isDouble = true, math.Random? random, int? seed})`: Constructs a [Vector] from a list of random numerical values.
- `Vector.linspace(int start, int end, [int number = 50])`: Creates a row Vector with equally spaced values between the start and end values (inclusive).
- `Vector.range(int end, {int start = 1, int step = 1}) & Vector.arrange(int end, {int start = 1, int step = 1})`: Creates a Vector with values in the specified range, incremented by the specified step size.

```dart
// Create a vector of length 3 with all elements initialized to 0
var v1 = Vector(3);

// Create a vector from a list of values
var v2 = Vector([1, 2, 3]);
v2 = Vector.fromList([1, 2, 3]);

// Create a vector with random values between 0 and 1
var v3 = Vector.random(3);

// Create a vector with 50 values equally spaced between 0 and 1
var v4 = Vector.linspace(0, 1);

// Create a vector with values 1, 3, 5, 7, 9
var v5 = Vector.range(10, start: 1, step: 2);
v5 = Vector.arrange(10, start: 1, step: 2);
```

## Operators

Supports operations for element-wise operations by scalar value or vector

```dart
// Get the value at index 2 of v2
var val = v2[2];

// Set the value at index 1 of v1 to 7
v1[1] = 7;

// Add v1 and v2
var v6 = v1 + v2;

// Subtract v2 from v1
var v7 = v1 - v2;

// Multiply v1 by a scalar
var v8 = v1 * 3.5;

// Divide v2 by a scalar
var v9 = v2 / 2;
```

## Vector Operations

- `double dot(Vector other)`: Calculates the dot product of the vector with another vector.
- `Vector cross(Vector other)`: Calculates the cross product of the vector with another vector.
- `double get magnitude`: Returns the magnitude (or norm) of the vector.
- `double get direction`: Returns the direction (or angle) of the vector, in radians.
- `double norm()`: Returns the norm (or length) of this vector.
- `Vector normalize()`: Returns this vector normalized.
- `bool isZero()`: Returns true if this is a zero vector, i.e., all its elements are zero.
- `bool isUnit()`: Returns true if this is a unit vector, i.e., its norm is 1.

```dart
// Calculate the dot product of v1 and v2
var dotProduct = v1.dot(v2);

// Calculate the cross product of two 3D vectors
var crossProduct = Vector.fromList([1, 2, 3]).cross(Vector.fromList([4, 5, 6]));

// Get the magnitude of v1
var magnitude = v1.magnitude;

// Get the direction of v1
var direction = v1.direction;

// Get the norm of v1
var norm = v1.norm();

// Normalize v1
var normalizedV1 = v1.normalize();
```

Others metrics include:

- `List<num> toList()`: Converts the vector to a list of numerical values.
- `int get length`: Returns the length (number of elements) of the vector.
- `void setAll(num value)`: Sets all elements of this vector to [value].
- `double distance(Vector other)`: Returns the Euclidean distance between this vector and [other].
- `Vector projection(Vector other)`: Returns the projection of this vector onto [other].
- `double angle(Vector other)`: Returns the angle (in radians) between this vector and [other].
- `List<double> toSpherical()`: Converts the Vector from Cartesian to Spherical coordinates.
- `void fromSpherical(List<num> sphericalCoordinates)`: Converts the Vector from Spherical to Cartesian coordinates.

```dart
Vector v = Vector([1, 2, 3]);
print(v);  // Output: [1, 2, 3]

// Convert v1 to a list
var list = v1.toList();

// Get the length of v1
var length = v1.length;

// Set all elements of v1 to 5
v1.setAll(5);

// Calculate the Euclidean distance between v1 and v2
var distance = v1.distance(v2);

// Calculate the projection of v1 onto v2
var projection = v1.projection(v2);

// Calculate the angle between v1 and v2
var angle = v1.angle(v2);

// Convert v1 to spherical coordinates
var spherical = v1.toSpherical();

// Create a vector from spherical coordinates
var v10 = Vector(3);
v10.fromSpherical(spherical);
```

## Vector Subset

```dart
// Extraction
var u1 = Vector.fromList([5, 0, 2, 4]);
var v1 = u1.getVector(['x', 'x', 'y']);
print(v1); // Output: [5.0, 5.0, 0.0)]
print(v1.runtimeType); // Vector3

u1 = Vector.fromList([5, 0, 2]);
v1 = u1.subVector(range: '1:2');
print(v1); // Output: [5.0, 5.0, 0.0, 2.0]
print(v1.runtimeType); // Vector4

var v = Vector.fromList([1, 2, 3, 4, 5]);
var subVector = v.subVector(indices: [0, 2, 4, 1, 1]);
print(subVector);  // Output: [1.0, 3.0, 5.0, 2.0, 2.0]
print(subVector.runtimeType); // Vector
```

It's possible to use vector instances as keys for HashMap and similar data structures and to look up a value by the vector-key, since the hash code for equal vectors is the same.

```dart
final map = HashMap<Vector, bool>();

map[Vector.fromList([1, 2, 3, 4, 5])] = true;

print(map[Vector.fromList([1, 2, 3, 4, 5])]); // true
print(Vector.fromList([1, 2, 3, 4, 5]).hashCode ==
      Vector.fromList([1, 2, 3, 4, 5]).hashCode); // true

```

Additional features

```dart
var xx = Vector([1, 2, 3, 4]);
var yy = Vector([4, 5]);
print('');
print(xx.outerProduct(yy));
// Matrix: 4x2
// ┌  4  5 ┐
// │  8 10 │
// │ 12 15 │
// └ 16 20 ┘

var mat = Matrix.fromList([
  [2, 3, 3, 3],
  [9, 9, 8, 6],
  [1, 1, 2, 9]
]);

print(-Vector([1, 2, 3]) + mat);
// Matrix: 3x4
// ┌  1  2  2 2 ┐
// │  7  7  6 4 │
// └ -2 -2 -1 6 ┘

print(xx * mat + xx.subVector(end: xx.length - 2)); // [30.0, 77.0, 48.0]

//Vector operations
final vector1 = Vector([1.0, 2.0, 3.0, 4.0, 5.0]);
final vector2 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
final result1 = vector1.distance(vector2, distance: DistanceType.cosine);
print(result1); // 0.005063323673817899

var result = vector1.normalize();
print(result.round(3)); // [0.135, 0.270, 0.405, 0.539, 0.674]

final vector = Vector.fromList([1.0, -2.0, 3.0, -4.0, 5.0]);
result = vector.normalize(Norm.manhattan);
print(result.round(3)); // [0.067, -0.133, 0.200, -0.267, 0.333]

var result2 = vector1.rescale();
print(result2); // [0.0, 0.25, 0.5, 0.75, 1.0]

var vector3 = Vector.fromList([4.0, 5.0, 6.0, 7.0, 8.0]);
result = vector3 - [2.0, 3.0, 2.0, 3.0, 2.0];
print(result); // [2.0, 2.0, 4.0, 4.0, 6.0]
```

</details>

<details>
<summary>COMPLEX NUMBERS & COMPLEX VECTORS</summary>

## Complex Numbers and ComplexVectors

This library provides efficient and easy-to-use classes for representing and manipulating vectors, complex numbers, and complex vectors in Dart. This document serves as an introduction to these classes, featuring a variety of examples to demonstrate their usage.

### Complex Numbers

Complex numbers extend the concept of the one-dimensional number line to the two-dimensional complex plane by using the number i, where i^2 = -1.

Complex numbers are crucial in many areas of mathematics and engineering.

The Complex class in this library lets you create complex numbers, access their real and imaginary parts, and obtain their conjugate.

#### Constructors

The class provides several constructors to create complex numbers in different ways:

```dart
var z1 = Complex(1, 2); // Creates a complex number 1 + 2i
var z2 = Complex.fromPolar(2, pi / 2); // Creates a complex number from polar coordinates
var z3 = Complex.fromReal(1); // Creates a complex number with only a real part
var z4 = Complex.fromImaginary(2); // Creates a complex number with only an imaginary part
var z5 = Complex.parse('2 + 2i'); // Parses a complex number from a string
```

Access its properties

```dart
// Creating a new complex number
Complex z = Complex(3, 2);
print(z);  // Output: 3 + 2i

// Accessing the real and imaginary parts
print(z.real);  // Output: 3
print(z.imaginary);  // Output: 2

// Conjugation
Complex conjugate = z.conjugate();
print(conjugate);  // Output: 3 - 2i

```

#### Operations

The class supports all basic arithmetic operations, including addition, subtraction, multiplication, division, and exponentiation:

```dart
var z1 = Complex(1, 2);
var z2 = Complex(2, 3);

var sum = z1 + z2; // Adds two complex numbers
var difference = z1 - z2; // Subtracts two complex numbers
var product = z1 * z2; // Multiplies two complex numbers
var quotient = z1 / z2; // Divides two complex numbers
var mod = z1 % 2; // Modulo operation of complex numbers
var power = z1 ^ 2; // Raises a complex number to a power

```

#### Power Operator

The power operator (^) raises the complex number to the power of the given number. The result is another complex number.

```dart
var z = Complex(2, 3); // 2 + 3i
var z_power = z ^ 2;

print(z_power); // Output: -5 + 12i
```

In this example, the complex number z is raised to the power of 2. The result is another complex number -5 + 12i.

```dart
var z = Complex(1, 2); // 1 + 2i
var z_power = z ^ Complex(2, 1); // (2 + i)

print(z_power); // Output: -1.6401010184280038 + 0.202050398556709i

```

In this example, the complex number z is raised to the power of another complex number 2 + i. The result is another complex number -1.6401010184280038 + 0.202050398556709i.

#### Other methods

The class also provides several other methods to work with complex numbers

```dart
var z = Complex(1, 2);

var magnitude = z.magnitude; // Gets the magnitude (or absolute value) of the complex number
var angle = z.angle; // Gets the angle (or argument or phase) in radians of the complex number
var conjugate = z.conjugate; // Gets the conjugate of the complex number
var real = z.real; // Gets the real part of the complex number
var imaginary = z.imaginary; // Gets the imaginary part of the complex number
var sqrt = z.sqrt(); // Gets the square root of the complex number
var exp = z.exp(); // Gets the exponential of the complex number
var ln = z.ln(); // Gets the natural logarithm (base e) of the complex number
var sin = z.sin(); // Gets the sine of the complex number
var cos = z.cos(); // Gets the cosine of the complex number
var tan = z.tan(); // Gets the tangent of the complex number
```

### Complex vectors

ComplexVectors are a type of vector where the elements are complex numbers. They are especially important in quantum mechanics and signal processing.

The ComplexVector class provides ways to create complex vectors, perform operations on them such as addition, and calculate their norm and normalized form.

```dart
// Creating a new complex vector
ComplexVector cv = ComplexVector(2);
cv[0] = Complex(1, 2);
cv[1] = Complex(3, 4);
print(cv);  // Output: [(1 + 2i), (3 + 4i)]

// Accessing elements
print(cv[0]);  // Output: 1 + 2i

// Vector operations (example: addition)
ComplexVector cv2 = ComplexVector.fromList([Complex(5, 6), Complex(7, 8)]);
ComplexVector sum = cv + cv2;
print(sum);  // Output: [(6 + 8i), (10 + 12i)]

// Norm and normalization
double norm = cv.norm();
ComplexVector normalized = cv.normalize();
print(norm);  // Output: 5.477225575051661
print(normalized);  // Output: [(0.18257418583505536 + 0.3651483716701107i), (0.5477225575051661 + 0.7302967433402214i)]
```

The above sections provide a basic introduction to vectors, complex numbers, and complex vectors. The full API of these classes offers even more possibilities, including conversions to other forms of vectors, multiplication by scalars, and more. These classes aim to make mathematical programming in Dart efficient, flexible, and enjoyable.

</details>

<details>
<summary>EXPRESSIONS</summary>

This module demonstrates the usage of mathematical expressions in Dart. It includes examples of handling positional and named arguments, evaluating various mathematical expressions, and performing operations on polynomials and multi-variable polynomials.

## Features in expression library

- **Enhanced Expression Creation**: Three intuitive approaches for creating expressions with numeric literals
  - Explicit Literal objects (traditional approach)
  - Extension method `toExpression()` for fluent APIs
  - Helper function `ex()` for concise syntax
- Examples
  - Positional and Named Arguments
  - Average Function
  - Evaluating Expressions
  - Simple Math
  - Complex Math
  - Conditional Math
  - Logic Math
  - String Math
  - DateTime Math
  - Polynomials
  - Multi-variable Polynomials
  - Expression Math
- Extension Methods

## Examples

### Positional and Named Arguments

This example demonstrates handling positional and named arguments using the `VarArgsFunction`.

```dart
dynamic superHeroes = VarArgsFunction((args, kwargs) {
  for (final superHero in args) {
    print("There's no stopping $superHero");
  }
});

superHeroes('UberMan', 'Exceptional Woman', 'The Hunk'); // Positional args only

dynamic myFunc = VarArgsFunction((args, kwargs) {
  print('Got args: $args, kwargs: $kwargs');
});

myFunc(1, 2, 3, x: 'hello', y: 'world'); // Positional + Named args
myFunc(10, 20, x: true, y: false); // Another set of Positional + Named args
myFunc('A', 'B', 'C'); // Positional args only
```

### Average Function

This example demonstrates using the `avg` function to calculate the average of numbers.

```dart
print(avg([1, 2, 3, 4, 5])); // This will print the average of the numbers
print(avg(1, 2, 3, 4, 5));
```

### Helper Functions and Constants

These are helper function to support the examples:

```dart
// Create custom context
final context1 = {
  'x': 3.0,
  'y': 4.0,
  'z': 2,
  'a': true,
  'b': [1, 2, 3],
  'pi': pi,
  'e': e,
};

// Merge it with the default context
final context = {...defaultContext, ...context1};

var parsec = ExpressionParser();
void printExpressionResult(String expression, dynamic context) {
  try {
    var result = parsec.parse(expression).evaluate(context);
    print('Expression: $expression => $result');
  } catch (e) {
    print('Error evaluating expression `$expression`: $e');
  }
}

void evaluateExpressions(
    List<String> expressions, String category, dynamic context) {
  printLine(category);
  for (var expr in expressions) {
    printExpressionResult(expr, context);
  }
}

```

### Evaluating Expressions

This example demonstrates evaluating a list of expressions.

```dart
final testCases = [
  "1 + 2 * 3",
  "x + y - z",
  "(1 + 2) * 3",
  "foo.bar.baz",
  "foo(bar, baz)",
  "b[z]",
  "1 + 2 * (3 - 4)",
  "true",
  "null",
  "[1, 2, 3]",
  "{'a': 1, 'b': 2}",
  "'hello world'",
  '"this is \\nJSEP"',
  'a ? y : x',
  "-1",
  '!true',
  '1 - -2',
  '5! + 1',
  '(2 + 3)!',
  '3 != 3',
  '5! != 120',
  '5! + 3!',
  'x! != y'
];

evaluateExpressions(testCases, "Test Cases", context);
```

### Simple Math

This example demonstrates evaluating simple mathematical expressions.

```dart
List<String> expressions = [
  '(5 + 1) + (6 - 2)',
  '4 + 4 * 3',
  '6*x + 4',
  'pi',
  '10.5 / 5.25',
  'abs(-5)',
  'sqrt(49)+10',
  'cos(x) + 2',
  'sqrt(x) - 3',
  'sqrt(x) + sin(pi/2)',
  'sqrt(16) + cbrt(8)',
  'log10(10)',
  'round(4.4)',
  '(3^3)^2',
  '3^(3^(2))',
  '3^2',
  'factorial(10)',
  'bigIntNChooseRModPrime(500, 250, 1000000007)',
  'string(10)',
  'roundTo(123.4567, 2)',
  'mean([1, 2, 3, 4, 5])',
  'nPr(5, 3)',
  '5P3',
  'nCr(5, 3)',
  '5C3',
  '5P3 + 5C3',
  'cosh(60)',
  'acosh(60)',
  'acot(0.5)',
  'csc(60)',
  'atan2(3,2)'
];

evaluateExpressions(expressions, "Simple Math equations", context);
```

### Complex Math

This example demonstrates evaluating complex mathematical expressions.

```dart
List<String> expressions = [
  'log10(10) + ln(e) + log(10)',
  'sin(1) + cos(0) + tan(0.15722)',
  'max(1, 2) + min(3, 4) + sum(5, 6)',
  'avg([9, 9.8, 10])',
  'pow(2, 3)',
  'round(4.559, 2)'
];

evaluateExpressions(expressions, "Complex Math equations", context);
```

### Conditional Math

This example demonstrates evaluating conditional expressions.

```dart
List<String> expressions = [
  '4 > 2 ? "bigger" : "smaller"',
  '2 == 2 ? true : false',
  '2 != 2 ? true : false',
  '"this" == "this" ? "yes" : "no"',
  '"this" != "that" ? "yes" : "no"'
];

evaluateExpressions(expressions, "IF THEN ELSE equations", context);
```

### Logic Math

This example demonstrates evaluating logical expressions.

```dart
List<String> expressions = [
  '!true',
  'true and false',
  'true or false',
  '(3==3) and (3!=3)',
  'exp(1) == e'
];

evaluateExpressions(expressions, "Logic equations", context);
```

### String Math

This example demonstrates evaluating string-related expressions.

```dart
List<String> expressions = [
  'length("test string")',
  'toUpper("test string")',
  'toLower("TEST STRING")',
  'concat("Hello ", "World")',
  'link("Title", "http://foo.bar")',
  'str2number("5")',
  'left("Hello World", 5)',
  'right("Hello World", 5)',
  'number("5")'
];

evaluateExpressions(expressions, "String equations", context);
```

### DateTime Math

This example demonstrates evaluating date and time-related expressions.

```dart
List<String> expressions = [
  'now',
  'daysDiff(now, "2018-10-04")',
  'daysDiff("2018-01-01", "2018-12-31")',
  'hoursDiff("2018-01-01", "2018-01-02")',
  'hoursDiff("2019-02-01T08:00", "2019-02-01T12:00")',
  'hoursDiff("2019-02-01T08:20", "2019-02-01T12:00")',
  'hoursDiff("2018-01-01", "2018-01-01")'
];

evaluateExpressions(expressions, "DateTime Math equations", context);
```

### Polynomials

This example demonstrates performing operations on polynomials.

```dart
printLine('Polynomials');
var p = Polynomial.fromString('x^2 + 2x + 1');
print(p.factorize());
print(p.factorizeString());
print(p.roots());

Polynomial P = Polynomial.fromString("x^4 + 6x^2 + 4");
print(P);
Polynomial Q = Polynomial.fromString('(x-2) - 9');
print(Q);

print(Expression.parse('(x-2)^2 - 9').expand());

print(Q.factorizeString());
print(Q.factorize());
print(Q.roots());
print(P / Q);

var result = RationalFunction(P, Q);

print("Quotient: ${result.quotient}");
print("Remainder: ${result.remainder}");
```

### Multi-variable Polynomials

This example demonstrates performing operations on multi-variable polynomials.

```dart
printLine("Multi Polynomial");
var polynomial = MultiVariablePolynomial([
  Term(3, {'x': 2, 'y': 1}),
  Term(2, {'x': 1}),
  Term(1, {'y': 2}),
  Term(4, {})
]);

var result = polynomial.evaluate({'x': 2, 'y': 3});

print(polynomial);
print(result);

var parsedPolynomial = MultiVariablePolynomial.fromString("7x^2y^3 + 2x + 5");
print(parsedPolynomial);

print(polynomial * parsedPolynomial);
```

### Expression Math

This example demonstrates performing various operations on expressions.

```dart
printLine("Expressions Math");
Variable x = Variable('x'), y = Variable('y');
var one = Literal(1);
var two = Literal(2);
var expr = Add(Pow(x, two), one);
print(expr);
print(expr.integrate());
print(Expression.parse('(x^2) + 1').integrate().simplify());

print(Add(Multiply(Literal(6), Variable('x')), Literal(4)).integrate());
print(Expression.parse('6 * x + 4').integrate());

print(Expression.parse('6 * x + 4').evaluate({'x': 2}));

Pow xSquare = Pow(x, Literal(2));
var yCos = Trigonometric('cos', y);
Literal three = Literal(3);
Expression exp = (xSquare + yCos) / three;
print(exp);

print(Ln(Add(xSquare, Literal(1))).differentiate());

print((Cos(x) + Sin(x)).integrate());

print(Csc(x).integrate());
print(Pow(Csc(x), Literal(2)).integrate());
print(Csc(Multiply(Literal(2), x)).integrate());
print(Csc(Multiply(Literal(3), x)).integrate());
print(Csc(Add(Multiply(Literal(4), x), Literal(1))).integrate());

print(Csc(x, n: 2).differentiate());

print(Add(Multiply(Literal(2), x), Add(Add(Literal(5), x), Multiply(Literal(2), x))).simplify());

print(Add(Multiply(Literal(8), y), Multiply(Literal(2), x)).simplify().evaluate({'x': 1}));

print(Add(Multiply(Literal(8), y), Multiply(Literal(2), x)).simplify().evaluate({'x': 1, 'y': 2}));

exp = Add(Add(Multiply(Literal(2), xSquare), Multiply(Literal(3), xSquare)), Add(Literal(4) * Multiply(x, y), Literal(2) * Multiply(x, y))).simplify();
print(exp.getVariables());
print(exp.getVariableTerms());

exp = Subtract(Multiply(Literal(1), x), Literal(-5));
print(exp);
print(exp.simplify());
print(Pow(Add(x, y), Literal(2)));
print(Pow(Pow(Literal(3), Literal(3)), Literal(2)).evaluate());
print(Pow(Literal(3), Pow(Literal(3), Literal(2))).evaluate());
print(Expression.parse(r'3^(3^(2))').evaluate());
print(Expression.parse('10^2').evaluate());
print(Pow(Literal(10), Literal(2)).evaluate());

x = Variable('x');
final expr1 = 2.toExpression() + x; // num + Expression
final expr2 = x + 2; // Expression + num

print('Expression 1: $expr1');
print('Expression 2: $expr2');

final expr3 = ex(3) * (x ^ ex(2)) - ex(4) / x;
print('Expression 3: $expr3');
```

### Enhanced Expression Creation

The library provides three intuitive approaches for creating expressions with numeric literals, solving common type inference issues:

#### Method 1: Explicit Literal Objects (Traditional)

```dart
final x = Variable('x');
final expr = Literal(2) * x + Literal(3);
print('Result: ${expr.evaluate({'x': 5})}'); // 13
```

#### Method 2: Extension Method (toExpression)

```dart
final x = Variable('x');
final expr = 2.toExpression() * x + 3.toExpression();
print('Result: ${expr.evaluate({'x': 5})}'); // 13
```

#### Method 3: Helper Function (ex)

```dart
final x = Variable('x');
final expr = ex(2) * x + ex(3);
print('Result: ${expr.evaluate({'x': 5})}'); // 13
```

#### Complex Expression Example

```dart
final x = Variable('x');
final y = Variable('y');

// Polynomial: 3x² + 2xy - 5y + 7
final polynomial = ex(3) * (x ^ ex(2)) +
                   2.toExpression() * x * y -
                   ex(5) * y +
                   Literal(7);

print('P(2,3) = ${polynomial.evaluate({'x': 2, 'y': 3})}');
```

#### Calculus Operations

```dart
// Differentiation
final func = (x ^ ex(3)) + 2.toExpression() * (x ^ ex(2)) - ex(5) * x + ex(7);
print('f\'(x) = ${func.differentiate()}');

// Integration
final integrand = 6.toExpression() * (x ^ ex(2)) + 4.toExpression() * x - ex(3);
print('∫f(x)dx = ${integrand.integrate()}');
```

All three methods produce equivalent results and can be mixed within the same expression. Choose the approach that best fits your coding style:

- **Use `ex()` for simple expressions**: `ex(2) * x + ex(3)`
- **Use `toExpression()` for fluent APIs**: `2.toExpression() * x + 3.toExpression()`
- **Use `Literal()` for explicit control**: `Literal(2) * x + Literal(3)`
- **Mix approaches for complex expressions**: `2.toExpression() * x + ex(3) * y - Literal(1)`

For comprehensive examples and troubleshooting, see:

- `example/enhanced_expression_creation.dart`
- `doc/enhanced_expression_creation.md`
- `doc/expression_troubleshooting.md`
- `doc/expression_migration_guide.md`

## Extension Methods

This project includes extension methods for the `num` type to allow for operator overloading with expressions.

```dart
extension E on num {
  Expression operator +(Expression other) => Literal(this) + other;
  Expression operator -(Expression other) => Literal(this) - other;
  Expression operator *(Expression other) => Literal(this) * other;
  Expression operator /(Expression other) => Literal(this) / other;
  Expression operator ^(Expression other) => Literal(this) ^ other;
  Expression operator -() => -Literal(this);
}
```

These extension methods allow for more intuitive and readable code when working with expressions.

</details>

## Testing

Tests are located in the test directory. To run tests, execute dart test in the project root.

## Contributing Features and bugs

### :beer: Pull requests are welcome

Don't forget that `open-source` makes no sense without contributors. No matter how big your changes are, it helps us a lot even it is a line of change.

There might be a lot of grammar issues in the docs. It's a big help to us to fix them if you are fluent in English.

Reporting bugs and issues are contribution too, yes it is.

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/gameticharles/advance_math/issues

## Author

Charles Gameti: [gameticharles@GitHub][github_cg].

[github_cg]: https://github.com/gameticharles

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
