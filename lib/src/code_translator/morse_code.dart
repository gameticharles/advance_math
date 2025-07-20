import 'dart:collection';

part 'rate_limiter.dart';

/// A class to encode and decode Morse code messages.
///
/// It supports a custom delimiter for characters, words and new line in Morse code.
/// The class provides functionality to enable logging for debugging purposes
/// and uses a `RateLimiter` to prevent abuse of the encode/decode functions.
///
/// Example:
/// ```
/// var translator = MorseCode(loggingEnabled: true);
/// var encoded = translator.encode('SOS');
/// print('Encoded: $encoded');  // Encoded: ... --- ...
///
/// var decoded = translator.decode('... --- ...');
/// print('Decoded: $decoded');  // Decoded: SOS
/// ```
class MorseCode {
  static const Map<String, String> _morseCodeMap = {
    'A': '.-',
    'B': '-...',
    'C': '-.-.',
    'D': '-..',
    'E': '.',
    'F': '..-.',
    'G': '--.',
    'H': '....',
    'I': '..',
    'J': '.---',
    'K': '-.-',
    'L': '.-..',
    'M': '--',
    'N': '-.',
    'O': '---',
    'P': '.--.',
    'Q': '--.-',
    'R': '.-.',
    'S': '...',
    'T': '-',
    'U': '..-',
    'V': '...-',
    'W': '.--',
    'X': '-..-',
    'Y': '-.--',
    'Z': '--..',
    '1': '.----',
    '2': '..---',
    '3': '...--',
    '4': '....-',
    '5': '.....',
    '6': '-....',
    '7': '--...',
    '8': '---..',
    '9': '----.',
    '0': '-----',
    '.': '.-.-.-',
    ',': '--..--',
    '?': '..--..',
    '\'': '.----.',
    '!': '-.-.--',
    '/': '-..-.',
    '(': '-.--.',
    ')': '-.--.-',
    '&': '.-...',
    ':': '---...',
    ';': '-.-.-.',
    '=': '-...-',
    '+': '.-.-.',
    '-': '-....-',
    '_': '..--.-',
    '"': '.-..-.',
    '\$': '...-..-',
    '@': '.--.-.',
    '\n': '|', // Newline symbol
    ' ': '/'
  };

  /// A reverse mapping from Morse code to the alphanumeric character for decoding.
  final Map<String, String> _reverseMorseCodeMap;

  /// A cache to store previously decoded Morse code for efficiency.
  final HashMap<String, String> _cache = HashMap<String, String>();

  /// A rate limiter to prevent abuse of the encode/decode functions.
  final RateLimiter _rateLimiter;

  /// A flag to enable logging for debugging purposes.
  bool _loggingEnabled;

  /// Constructs a `MorseCode` with optional logging and rate limiting.
  ///
  /// Parameters:
  /// - `loggingEnabled`: If set to `true`, enables logging of actions.
  /// - `rateLimiter`: An optional `RateLimiter` to limit the rate of operations.
  MorseCode({bool loggingEnabled = false, RateLimiter? rateLimiter})
      : _loggingEnabled = loggingEnabled,
        _reverseMorseCodeMap =
            _morseCodeMap.map((key, value) => MapEntry(value, key)),
        _rateLimiter = rateLimiter ?? RateLimiter();

  /// Encodes the given [input] string into Morse code.
  ///
  /// Throws a `FormatException` if [input] contains characters not represented in Morse code.
  ///
  /// Parameters:
  /// - `input`: The string to encode into Morse code.
  /// - `charDelimiter`: The delimiter used between Morse code characters. Default is a space.
  /// - `wordDelimiter`: The delimiter used between Morse code words. Default is three spaces.
  /// - `newlineDelimiter`: represents newlines in the Morse code.
  ///
  /// Returns:
  /// - A `String` representing the encoded Morse code message.
  ///
  /// Example:
  /// ```
  /// var translator = MorseCodeTranslator();
  /// var encoded = translator.encode('HELLO\nWORLD', newlineDelimiter: '|');
  /// print(encoded); // Outputs: ".... . .-.. .-.. --- |/ .-- --- .-. .-.. -.."
  /// ```
  String encode(String input,
      {String charDelimiter = ' ',
      String wordDelimiter = '   ',
      String newlineDelimiter = '|'}) {
    try {
      // Correctly escape the dash and place it at the end of the character set
      if (!RegExp('^[A-Za-z0-9 .,!?\'/()&:;=+_"\$@-]*\$').hasMatch(input)) {
        _log('Input contains invalid characters');
        throw FormatException('Input contains invalid characters');
      }

      _log('Encoding input: $input');

      return input
          .toUpperCase()
          .split('')
          .map((char) =>
              _morseCodeMap[char] ??
              (throw FormatException('Unsupported character: $char')))
          .join(charDelimiter)
          .replaceAll('\n$charDelimiter',
              newlineDelimiter + charDelimiter) // Handle newlines
          .replaceAll(' $charDelimiter', wordDelimiter);
    } catch (e) {
      _log('Error encoding input: $e');
      rethrow;
    }
  }

  /// Decodes the given [morseCode] string from Morse code to alphanumeric text.
  ///
  /// Parameters:
  /// - `morseCode`: The Morse code to decode into a text string.
  /// - `charDelimiter`: The delimiter used between Morse code characters. Default is a space.
  /// - `wordDelimiter`: The delimiter used between Morse code words. Default is three spaces.
  ///
  /// Returns:
  /// - A `String` representing the decoded text message.
  ///
  /// Throws:
  /// - `FormatException` if the Morse code contains invalid characters.
  /// - `Exception` from the `RateLimiter` if the rate limit is exceeded.
  ///
  /// Example:
  /// ```
  /// var translator = MorseCodeTranslator();
  /// var decoded = translator.decode('.... . .-.. .-.. --- |/ .-- --- .-. .-.. -..',
  ///                                 newlineDelimiter: '|');
  /// print(decoded); // Outputs: "HELLO\nWORLD"
  /// ```
  String decode(String morseCode,
      {String charDelimiter = ' ',
      String wordDelimiter = '   ',
      String newlineDelimiter = '|'}) {
    try {
      _rateLimiter.checkRateLimiting();

      if (!RegExp(r'^[\.\- \/|\n]+$').hasMatch(morseCode)) {
        throw FormatException('Morse code contains invalid characters');
      }

      if (_cache.containsKey(morseCode)) {
        return _cache[morseCode]!;
      }

      var normalizedMorseCode =
          morseCode.trim().replaceAll(RegExp(' +'), charDelimiter);
      var decodedWords = normalizedMorseCode
          .split(wordDelimiter)
          .map((word) => word
              .split(charDelimiter)
              .map((code) =>
                  _reverseMorseCodeMap[code] ??
                  (code == newlineDelimiter
                      ? '\n'
                      : throw FormatException(
                          'Unsupported Morse code sequence: $code')))
              .join(''))
          .join(' ');

      _cache[morseCode] = decodedWords;
      return decodedWords;
    } catch (e) {
      _log('Error decoding Morse code: $e');
      rethrow;
    }
  }

  /// Logs a [message] if logging is enabled.
  ///
  /// Parameters:
  /// - `message`: The message to log.
  void _log(String message) {
    if (_loggingEnabled) {
      print(message);
    }
  }

  /// Enables or disables logging based on the [enabled] flag.
  ///
  /// Parameters:
  /// - `enabled`: A boolean value to turn logging on or off.
  void setLogging(bool enabled) {
    _loggingEnabled = enabled;
  }
}
