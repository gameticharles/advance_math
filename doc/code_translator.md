# Code Translator Module

This module provides utilities for translating data between different codes or formats, such as Morse code and numerical representations to words.

## Table of Contents
- [Morse Code Translator (`MorseCode`)](#morse-code-translator)
  - [Overview](#morse-code-overview)
  - [Supported Characters](#morse-code-supported-characters)
  - [Usage](#morse-code-usage)
    - [Encoding to Morse Code](#encoding-to-morse-code)
    - [Decoding from Morse Code](#decoding-from-morse-code)
  - [Customization](#morse-code-customization)
    - [Logging](#logging)
    - [Rate Limiting](#rate-limiting)
    - [Caching (Decoding)](#caching-decoding)
- [Number to Words Converter (`NumWords`)](#number-to-words-converter)
  - [Overview](#num-words-overview)
  - [Usage](#num-words-usage)
    - [Basic Conversion (Numbers to Cardinal Words)](#basic-conversion-numbers-to-cardinal-words)
    - [Language Support](#language-support)
    - [Ordinal Numbers](#ordinal-numbers)
    - [Decimal and Currency Conversion](#decimal-and-currency-conversion)
    - [Year Conversion](#year-conversion)
    - [Converting Words to Numbers (`toNum`)](#converting-words-to-numbers-tonum)
  - [Error Handling and Limitations](#num-words-error-handling-and-limitations)

---

## Morse Code Translator (`MorseCode`)
*(Documentation for the `MorseCode` class from `lib/src/code_translator/morse_code.dart`)*

### Morse Code Overview
The `MorseCode` class provides a straightforward way to translate text into Morse code and vice-versa. Morse code is a method of transmitting text information as a series of on-off tones, lights, or clicks. It is named after Samuel Morse, an inventor of the telegraph.

This class supports:
-   Encoding standard alphanumeric characters and common punctuation into Morse code.
-   Decoding Morse code sequences back into text.
-   Customizable delimiters for characters, words, and newlines.
-   Optional logging for debugging.
-   A rate limiter to prevent overly frequent calls.
-   Caching for decoded messages to improve performance.

### Morse Code Supported Characters
The internal Morse code map supports the following characters for encoding:
-   **Letters**: A-Z (case-insensitive input, converted to uppercase)
-   **Digits**: 0-9
-   **Punctuation**: `.` (period), `,` (comma), `?` (question mark), `'` (apostrophe), `!` (exclamation mark), `/` (slash), `(` (parenthesis open), `)` (parenthesis close), `&` (ampersand), `:` (colon), `;` (semicolon), `=` (equals), `+` (plus), `-` (minus), `_` (underscore), `"` (quotation mark), `$` (dollar sign), `@` (at sign).
-   **Whitespace**: Space (` `) is typically encoded as `/`. Newline (`\n`) is handled by `newlineDelimiter`.

Inputting characters not in this set will result in a `FormatException` during encoding.

### Morse Code Usage

First, create an instance of the `MorseCode` class.
```dart
final morseTranslator = MorseCode();
```

#### Encoding to Morse Code
The `encode()` method converts a plain text string into its Morse code representation.

**Signature:**
`String encode(String input, {String charDelimiter = ' ', String wordDelimiter = '   ', String newlineDelimiter = '|'})`

**Parameters:**
-   `input: String`: The string to encode.
-   `charDelimiter: String`: Separator for Morse codes of individual characters (default: `' '`).
-   `wordDelimiter: String`: Separator for Morse codes of words (default: `'   '`). This is applied by replacing occurrences of `' ' + charDelimiter` (a space followed by the character delimiter, which arises from the space character in the input mapping to `'/'` followed by a `charDelimiter`) with `wordDelimiter`.
-   `newlineDelimiter: String`: Represents `\n` in the output (default: `'|'`).

**Dart Code Example:**
```dart
final translator = MorseCode();

String text1 = "HELLO WORLD";
// Default: ' ' maps to '/', charDelimiter is ' ', wordDelimiter is '   '
// "H E L L O" -> ".... . .-.. .-.. ---"
// " " -> "/"
// "W O R L D" -> ".-- --- .-. .-.. -.."
// Result: ".... . .-.. .-.. --- / .-- --- .-. .-.. -.." (space between char codes, / between word codes)
String morse1 = translator.encode(text1);
print("'$text1' => '$morse1'");
// Output: 'HELLO WORLD' => '.... . .-.. .-.. --- / .-- --- .-. .-.. -..'

String text2 = "SOS";
String morse2 = translator.encode(text2, charDelimiter: '_'); // Using underscore between characters
print("'$text2' => '$morse2'");
// Output: 'SOS' => '..._---_...'

String text3 = "HI\nTHERE";
// Default newlineDelimiter is '|'. Default charDelimiter is ' '.
// "H I" -> ".... .."
// "\n" -> "|"
// "T H E R E" -> "- .... . .-. ."
String morse3 = translator.encode(text3);
print("'$text3' => '$morse3'");
// Output: 'HI\nTHERE' => '.... ..|- .... . .-. .'

String morseCustomDelimiters = translator.encode("NEXT WORD", charDelimiter: '.', wordDelimiter: " /BREAK/ ", newlineDelimiter: "[NL]");
print("'NEXT WORD' (custom) => '$morseCustomDelimiters'");
// Output: 'NEXT WORD' (custom) => '-.. . -..- - /BREAK/ .-- --- .-. .-.. -..'

try {
  translator.encode("InvalidChar#");
} catch (e) {
  print("Error encoding: $e"); // FormatException
}
```

#### Decoding from Morse Code
The `decode()` method converts a Morse code string back into plain text.

**Signature:**
`String decode(String morseCode, {String charDelimiter = ' ', String wordDelimiter = '   ', String newlineDelimiter = '|'})`

**Parameters:**
-   `morseCode: String`: The Morse code string.
-   `charDelimiter: String`: Separator for Morse characters (default: `' '`).
-   `wordDelimiter: String`: Separator for words (default: `'   '`). The logic first splits by `wordDelimiter`, then processes parts. The `'/'` character is inherently treated as a space by the reverse map.
-   `newlineDelimiter: String`: Represents `\n` in the input Morse (default: `'|'`).

**Dart Code Example:**
```dart
final translator = MorseCode();

String morse1 = ".... . .-.. .-.. --- / .-- --- .-. .-.. -..";
// Decodes using default charDelimiter ' ' and also recognizing '/' as a space.
String decoded1 = translator.decode(morse1);
print("'$morse1' => '$decoded1'"); // Output: 'HELLO WORLD'

String morse2 = "..._---_...";
String decoded2 = translator.decode(morse2, charDelimiter: '_');
print("'$morse2' => '$decoded2'"); // Output: 'SOS'

String morse3 = ".-- .- .. -|.... . .-. .";
String decoded3 = translator.decode(morse3, newlineDelimiter: '|');
print("'$morse3' => '$decoded3'"); // Output: 'WAIT\nHERE'

// Example matching custom encode
String morseCustom = '-.. . -..- - /BREAK/ .-- --- .-. .-.. -..';
String decodedCustom = translator.decode(morseCustom, charDelimiter: '.', wordDelimiter: " /BREAK/ ");
print("'$morseCustom' => '$decodedCustom'"); // Output: 'NEXT WORD'

try {
  translator.decode(".... . .-.. .-.. --- / ..-.---"); // ..-.--- is not a valid Morse sequence
} catch (e) {
  print("Error decoding: $e"); // FormatException
}
```

### Morse Code Customization

#### Logging
-   **Constructor**: `MorseCode(loggingEnabled: bool)` (default `false`).
-   **Method**: `setLogging(bool enabled)` to toggle after instantiation.
    When enabled, prints internal steps to the console.
    ```dart
    final loggerMorse = MorseCode(loggingEnabled: true);
    loggerMorse.encode("LOG");
    loggerMorse.setLogging(false);
    ```

#### Rate Limiting
-   The `MorseCode` class uses a `RateLimiter` (from `rate_limiter.dart`) internally to prevent abuse, particularly for the `decode` method.
-   The default `RateLimiter` has predefined limits (e.g., a certain number of requests per period). If these limits are exceeded, the `decode` method may throw an exception.
-   A custom `RateLimiter` instance can be passed to the `MorseCode` constructor for specific rate control needs.
-   **Implication**: If you plan to use `decode` in a high-frequency context, be aware of potential rate limiting. You might need to handle exceptions or configure a more permissive `RateLimiter`.

#### Caching (Decoding)
-   The `decode()` method uses an internal `HashMap` to cache results.
-   **Implication**: If the same Morse code string is decoded multiple times, subsequent calls are faster as the result is retrieved from the cache. This is beneficial for repetitive decoding tasks.

---

## Number to Words Converter (`NumWords`)
*(Documentation for `NumWords` from `lib/src/code_translator/num_words/num_words.dart` and associated part files like `language_config.dart`, `languages.dart`, `currency.dart`)*

### Num Words Overview
The `NumWords` class converts numerical values (integers and decimals) into their word representations (e.g., 123 to "One Hundred And Twenty-Three"). It supports multiple languages, ordinal number conversion, and currency formatting.

Key features:
-   **Multi-language**: English (`'en'`) and French (`'fr'`) are supported by default. Extensible via `LanguageConfig`.
-   **Cardinal & Ordinal**: Converts to "one, two" or "first, second".
-   **Decimals & Currency**: Handles decimal parts and can integrate currency units.
-   **Words to Number**: Provides `toNum()` to parse word strings back to numbers.

### Num Words Usage

Initialize `NumWords`, optionally with custom language configurations or a default currency.
```dart
// import 'package:advance_math/num_words.dart'; // Main import for NumWords

final converter = NumWords(); // Default with English and French

// For currency examples:
final gbp = Currency(
  mainUnitSingular: "pound", mainUnitPlural: "pounds",
  fractionalUnitSingular: "penny", fractionalUnitPlural: "pence",
  mainSymbol: "£", fractionalSymbol: "p"
);
```

#### Basic Conversion (Numbers to Cardinal Words)
Use the `toWords()` method.

**Signature:**
`String toWords(num value, {String lang = 'en', String? conjunction, Currency? currency, int decimalPlaces = 2, bool useOrdinal = false, bool isFeminine = false})`

**Parameters:**
-   `value: num`: The number to convert.
-   `lang: String`: Language code (default: `'en'`).
-   `conjunction: String?`: Word like "and" (e.g., "one hundred **and** twenty-three"). Uses language default if null.
-   `currency: Currency?`: `Currency` object for currency words.
-   `decimalPlaces: int`: Decimal places for fractional part (default: `2`).
-   `useOrdinal: bool`: If `true`, converts to ordinal (default: `false`).
-   `isFeminine: bool`: For feminine ordinal forms in gendered languages (default: `false`).

**Dart Code Example (Cardinal):**
```dart
print(converter.toWords(12345));
// Output (en): Twelve Thousand Three Hundred And Forty-Five

print(converter.toWords(1000000.00));
// Output (en): One Million

print(converter.toWords(-50));
// Output (en): Negative Fifty
```

#### Language Support
Specify language via the `lang` parameter in `toWords()` or `toNum()`.
English (`'en'`) and French (`'fr'`) are included by default.
```dart
print("Num: 21");
print("EN: ${converter.toWords(21, lang: 'en')}"); // Output: Twenty-One
print("FR: ${converter.toWords(21, lang: 'fr')}"); // Output: Vingt-et-Un

print("\nNum: 88");
print("EN: ${converter.toWords(88, lang: 'en')}"); // Output: Eighty-Eight
print("FR: ${converter.toWords(88, lang: 'fr')}"); // Output: Quatre-Vingt-Huit
```
To add more languages, provide a custom `Map<String, LanguageConfig>` to the `NumWords` constructor.

#### Ordinal Numbers
Set `useOrdinal: true` in `toWords()`. Use `isFeminine: true` for feminine forms if supported by the language (e.g., French).
```dart
print("Ordinal EN:");
print("1: ${converter.toWords(1, useOrdinal: true)}");   // Output: First
print("22: ${converter.toWords(22, useOrdinal: true)}"); // Output: Twenty-Second
print("103: ${converter.toWords(103, useOrdinal: true)}"); // Output: One Hundred And Third

print("\nOrdinal FR:");
print("1 (masc): ${converter.toWords(1, lang: 'fr', useOrdinal: true)}");                 // Output: Premier
print("1 (fem):  ${converter.toWords(1, lang: 'fr', useOrdinal: true, isFeminine: true)}"); // Output: Première
print("2 (masc): ${converter.toWords(2, lang: 'fr', useOrdinal: true)}");                 // Output: Deuxième
```
Ordinal conversion primarily applies to the integer part of a number.

#### Decimal and Currency Conversion
The `toWords()` method handles decimal parts and can integrate currency information.
-   The `decimalPlaces` parameter controls the precision of the fractional part.
-   The `currency` parameter takes a `Currency` object.

**`Currency` Class:**
*(from `lib/src/code_translator/num_words/currency.dart`)*
Defines currency properties:
- `mainUnitSingular`, `mainUnitPlural` (e.g., "dollar", "dollars")
- `fractionalUnitSingular`, `fractionalUnitPlural` (e.g., "cent", "cents")
- `mainSymbol`, `fractionalSymbol` (e.g., "$", "¢")
- `decimalSeparator` (char for decimal point, default `.`)
- `thousandsSeparator` (char for thousands, default `,`)

```dart
final converter = NumWords();
final eur = Currency(
    mainUnitSingular: "euro", mainUnitPlural: "euros",
    fractionalUnitSingular: "cent", fractionalUnitPlural: "cents",
    mainSymbol: "€"
);

print(converter.toWords(123.45, currency: eur, lang: 'en'));
// Output (en): One Hundred And Twenty-Three euros And Forty-Five cents

print(converter.toWords(1.00, currency: eur, lang: 'en'));
// Output (en): One euro

print(converter.toWords(0.75, currency: eur, lang: 'en', decimalPlaces: 2));
// Output (en): Seventy-Five cents

print(converter.toWords(5678.9, lang: 'fr', currency: eur, decimalPlaces: 1));
// Output (fr): Cinq Mille Six Cent Soixante-Dix-Huit euros Et Neuf centimes (approx.)
// Note: French handling of "cents" vs "centimes" depends on LanguageConfig.
```
The `LanguageConfig.fractionalSeparator` defines how the decimal point is verbalized (e.g., "Point" in English).

#### Year Conversion
Years are converted as standard numbers. There is no special colloquial formatting (e.g., "nineteen ninety-five").
```dart
print(converter.toWords(1995)); // Output: One Thousand Nine Hundred And Ninety-Five
print(converter.toWords(2024)); // Output: Two Thousand And Twenty-Four
```

#### Converting Words to Numbers (`toNum`)
The `toNum()` method parses a word string back into a numerical value.

**Signature:**
`num toNum(String input, {String lang = 'en', String? conjunction, Currency? currency})`

**Parameters:**
-   `input: String`: The word representation.
-   `lang: String`: Language code (default: `'en'`).
-   `conjunction: String?`: Expected conjunction word.
-   `currency: Currency?`: If currency terms are in `input`, provide `Currency` to help strip them.

**Dart Code Example:**
```dart
final converter = NumWords();
final eur = Currency(mainUnitSingular: "euro", mainUnitPlural: "euros", fractionalUnitSingular: "cent", fractionalUnitPlural: "cents");

print(converter.toNum("One Hundred And Twenty-Three")); // Output: 123
print(converter.toNum("Forty-Five Point Sixty-Seven")); // Output: 45.67
print(converter.toNum("Negative Fifty"));             // Output: -50

print(converter.toNum("One Hundred And Twenty-Three euros And Forty-Five cents", currency: eur)); // Output: 123.45
print(converter.toNum("Deux Cent Trente-Quatre euros Et Cinquante centimes", lang: 'fr', currency: eur)); // Output: 234.50
```
The parser handles various word forms, magnitudes, and decimal/currency components based on the specified `LanguageConfig`.

### NumWords Error Handling and Limitations
-   **Language Support**: Throws `ArgumentError` if an unsupported language code is provided to `toWords` or `toNum` and no corresponding `LanguageConfig` is found.
-   **Maximum/Minimum Number Size**: While `num` can handle large doubles, the practical limit for word conversion depends on the defined `magnitudes` in `LanguageConfig` (e.g., up to trillions, quadrillions). Extremely large numbers beyond these magnitudes may not convert correctly or fully.
-   **Decimal Precision in `toWords`**: The `decimalPlaces` parameter in `toWords` rounds the fractional part.
-   **Parsing Ambiguity in `toNum`**: Complex or non-standard wordings might not parse correctly. It expects a fairly standard structure. Ordinal word parsing (e.g., "First") is reversed to its cardinal equivalent before numerical conversion.
-   **Floating Point Inaccuracies**: When converting `double` values to words, the precision of the input `double` itself can affect the fractional part. Using `Decimal` or `Rational` as input to `NumWords(value.toDecimal().convert(...))` or similar (if `NumWords` were adapted for `Decimal` input) would offer higher precision for the source number. The current `NumWords` primarily takes `num`.

---
