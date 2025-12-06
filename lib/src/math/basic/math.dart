library maths;

import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import '../../../advance_math.dart'
    hide Complex, Number, Integer, Double, Imaginary;
import '../../number/complex/complex.dart';

part 'basic.dart';
part 'statistics.dart';
part 'constants.dart';
part 'trigonometry.dart';
part 'logarithm.dart';
part 'special_functions.dart';

/// A generator of random byte, bool, int, BigInt, or double values.
///
/// The default implementation supplies a stream of pseudo-random bits that
/// are not suitable for cryptographic purposes.
///
/// Use the [Random.secure] constructor for cryptographic purposes.
///
/// Example 1:
/// To create a non-negative random integer uniformly distributed in the
/// range from 0, inclusive, to max, exclusive, use [nextInt(int max)].
///
/// ```dart
/// var intValue = Random().nextInt(10); // Value is >= 0 and < 10.
/// intValue = Random().nextInt(100) + 50; // Value is >= 50 and < 150.
/// ```
///
/// Example 2:
/// To create a non-negative random floating point value uniformly distributed
/// in the range from 0.0, inclusive, to 1.0, exclusive, use [nextDouble]
///
/// ```dart
/// var doubleValue = Random().nextDouble(); // Value is >= 0.0 and < 1.0.
/// doubleValue = Random().nextDouble() * 256; // Value is >= 0.0 and < 256.0.
/// ```
///
/// Example 3:
/// To create a random Boolean value, use [nextBool].
///
/// ```dart
/// var boolValue = Random().nextBool(); // true or false, with equal chance.
/// ```
class Random implements math.Random, AbstractRandomProvider {
  final math.Random _random;

  Random([int? seed]) : _random = math.Random(seed);

  /// Creates a cryptographically secure random number generator.
  ///
  /// If the program cannot provide a cryptographically secure source of random numbers,
  /// it throws an [UnsupportedError].
  Random.secure() : _random = math.Random.secure();

  @override
  bool nextBool() => _random.nextBool();

  @override
  double nextDouble() => _random.nextDouble();

  @override
  int nextInt(int max) => _random.nextInt(max);

  /// Generates a list of [length] random bytes.
  ///
  /// Example:
  /// ```dart
  /// var bytes = Random().nextBytes(10); // Generates 10 random bytes.
  /// ```
  Uint8List nextBytes(int length) {
    final Uint8List bytes = Uint8List(length);
    for (int i = 0; i < length; i++) {
      bytes[i] = _random.nextInt(256); // Generate a random byte (0-255)
    }
    return bytes;
  }

  /// Generates a random non-zero byte.
  ///
  /// Example:
  /// ```dart
  /// var nonZeroByte = Random().nextNonZeroByte();
  /// print('Random non-zero byte: $nonZeroByte');
  /// ```
  int nextNonZeroByte() {
    int byte;
    do {
      byte = _random.nextInt(256);
    } while (byte == 0);
    return byte;
  }

  /// Generates a list of random bytes within a specified range.
  ///
  /// Example:
  /// ```dart
  /// var bytes = Random().nextBytesInRange(10, 100, 5);
  /// print('Random bytes in range [10, 100): $bytes');
  /// ```
  Uint8List nextBytesInRange(int min, int max, int length) {
    final Uint8List bytes = Uint8List(length);
    for (int i = 0; i < length; i++) {
      bytes[i] = nextIntInRange(min, max);
    }
    return bytes;
  }

  /// Generates a random integer in the range [min, max).
  ///
  /// Example:
  /// ```dart
  /// var intValue = Random().nextIntInRange(50, 150); // Value is >= 50 and < 150.
  /// ```
  int nextIntInRange(int min, int max) => _random.nextInt(max - min) + min;

  /// Generates a random double in the range [min, max).
  ///
  /// Example:
  /// ```dart
  /// var doubleValue = Random().nextDoubleInRange(0.0, 256.0); // Value is >= 0.0 and < 256.0.
  /// ```
  double nextDoubleInRange(double min, double max) =>
      _random.nextDouble() * (max - min) + min;

  /// Generates a random BigInt less than [max] using direct byte accumulation.
  ///
  /// Example:
  /// ```dart
  /// var bigIntValue = Random().nexBigInt2(BigInt.parse('1000000000000000000'));
  /// ```
  ///
  /// Advantages:
  /// - Simpler implementation.
  ///
  /// Disadvantages:
  /// - May skew the distribution of random numbers if `max` is not a power of 2.
  BigInt nexBigInt2(BigInt max) {
    final digits =
        (max.bitLength + 7) ~/ 8; // Number of bytes required for max value
    Uint8List bytes = nextBytes(digits); // Generate random bytes
    BigInt result = BigInt.from(0);

    for (int i = 0; i < bytes.length; i++) {
      result += BigInt.from(bytes[i]) << (8 * i);
    }

    return result.remainder(max);
  }

  /// Generates a random BigInt less than [max] using hex string parsing.
  ///
  /// Example:
  /// ```dart
  /// var bigIntValue = Random().nextBigInt(BigInt.parse('1000000000000000000'));
  /// ```
  ///
  /// Advantages:
  /// - Ensures uniform distribution within the range.
  ///
  /// Disadvantages:
  /// - More complex and potentially less efficient due to string parsing.
  BigInt nextBigInt(BigInt max) {
    int length = (max.bitLength + 7) >> 3;
    BigInt result;
    do {
      result = BigInt.parse(
          nextBytes(length)
              .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
              .join(),
          radix: 16);
    } while (result >= max);
    return result;
  }

  /// Generates a random BigInt in the range [min, max).
  /// Ensures the generated BigInt is within the specified range.
  ///
  /// Slightly less efficient due to the range checking loop.
  ///
  /// Example:
  /// ```dart
  /// var bigIntValue = Random().nextBigIntInRange(BigInt.from(10), BigInt.from(100));
  /// print('Random BigInt in range [10, 100): $bigIntValue');// Value is >= 10 and < 100.
  /// ```
  ///
  BigInt nextBigIntInRange(BigInt min, BigInt max) {
    if (min >= max) {
      throw ArgumentError('min must be less than max');
    }
    BigInt range = max - min;
    return min + nextBigInt(range);
  }

  /// Generates a random BigInt with a specified bit length.
  ///
  /// The generated BigInt will be in the range [2^(bitLength-1), 2^bitLength - 1].
  ///
  /// Throws an [ArgumentError] if [bitLength] is less than or equal to zero.
  ///
  /// Example:
  /// ```dart
  /// var bigIntValue = Random().nextBigIntWithBitLength(128);
  /// print('Random BigInt with bit length 128: $bigIntValue');
  /// ```
  BigInt nextBigIntWithBitLength(int bitLength) {
    if (bitLength <= 0) {
      throw ArgumentError('bitLength must be greater than zero');
    }
    BigInt min = BigInt.one << (bitLength - 1);
    BigInt max = (BigInt.one << bitLength) - BigInt.one;
    return nextBigIntInRange(min, max);
  }

  /// Randomly selects an element from the provided [list].
  ///
  /// Throws an [ArgumentError] if the [list] is empty.
  ///
  /// Example:
  /// ```dart
  /// var list = ['apple', 'banana', 'cherry', 'date'];
  /// var randomElement = Random().nextElementFromList(list);
  /// print('Randomly selected element: $randomElement');
  /// ```
  T nextElementFromList<T>(List<T> list) {
    if (list.isEmpty) {
      throw ArgumentError('List must not be empty');
    }
    int index = nextInt(list.length);
    return list[index];
  }

  /// Generates a random string of [length] characters from the given [charset].
  ///
  /// Example:
  /// ```dart
  /// var randomString = Random().nextString(10); // Generates a random string of 10 characters.
  /// ```
  String nextString(int length,
      {String charset =
          'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'}) {
    return String.fromCharCodes(Iterable.generate(
        length, (_) => charset.codeUnitAt(nextInt(charset.length))));
  }

  /// Generates a random DateTime within the given range.
  ///
  /// Example:
  /// ```dart
  /// var randomDate = Random().nextDateTime(DateTime(2020, 1, 1), DateTime(2021, 1, 1));
  /// ```
  DateTime nextDateTime(DateTime min, DateTime max) {
    if (min.isAfter(max)) {
      throw ArgumentError('min must be before max');
    }

    int minMillis = min.millisecondsSinceEpoch;
    int maxMillis = max.millisecondsSinceEpoch;
    int randomMillis = nextIntInRange(minMillis, maxMillis);
    return DateTime.fromMillisecondsSinceEpoch(randomMillis);
  }

  /// Generates a random number from a Gaussian (normal) distribution.
  ///
  /// The generated value follows a Gaussian distribution with the specified
  /// [mean] (default is 0.0) and [stddev] (default is 1.0).
  ///
  /// Uses the Box-Muller transform to generate values.
  ///
  /// Example:
  /// ```dart
  /// var gaussianValue = Random().nextGaussian(mean: 10.0, stddev: 2.0);
  /// print('Random value from Gaussian distribution: $gaussianValue');
  /// ```
  double nextGaussian({double mean = 0.0, double stddev = 1.0}) {
    double u1 = _random.nextDouble();
    double u2 = _random.nextDouble();
    double z0 = sqrt(-2.0 * log(u1)) * cos(2.0 * pi * u2);
    return mean + z0 * stddev;
  }

  /// Generates a random UUID (version 4).
  ///
  /// Example:
  /// ```dart
  /// var uuid = Random().nextUUID(); // Generates a random UUID.
  /// ```
  String nextUUID() {
    final Uint8List bytes = nextBytes(16);
    bytes[6] = (bytes[6] & 0x0F) | 0x40; // Set the version to 4
    bytes[8] = (bytes[8] & 0x3F) | 0x80; // Set the variant to RFC 4122

    final List<String> chars = [];
    for (int i = 0; i < 16; i++) {
      chars.add(bytes[i].toRadixString(16).padLeft(2, '0'));
    }

    return '${chars.sublist(0, 4).join()}-${chars.sublist(4, 6).join()}-${chars.sublist(6, 8).join()}-${chars.sublist(8, 10).join()}-${chars.sublist(10, 16).join()}';
  }

  /// Generates a list of unique random integers within a specified range.
  ///
  /// Example:
  /// ```dart
  /// var uniqueInts = Random().nextNonRepeatingIntList(1, 10, 5);
  /// print('Unique random integers: $uniqueInts');
  /// ```
  List<int> nextNonRepeatingIntList(int min, int max, int length) {
    if (max - min < length) {
      throw ArgumentError('Range is too small for the specified length');
    }
    Set<int> set = {};
    while (set.length < length) {
      set.add(nextIntInRange(min, max));
    }
    return set.toList();
  }

  /// Shuffles a list in place using the Fisher-Yates shuffle algorithm.
  ///
  /// Example:
  /// ```dart
  /// var list = [1, 2, 3, 4, 5];
  /// Random().shuffleList(list);
  /// print('Shuffled list: $list');
  /// ```
  List<T> shuffleList<T>(List<T> list) {
    for (int i = list.length - 1; i > 0; i--) {
      int j = nextInt(i + 1);
      T temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }

    return list;
  }
}

/// ASCII character range constants
const asciiStart = 33; // '!'
const asciiEnd = 126; // '~'

/// Enum to specify the type of characters for random string generation.
enum CharacterType { numeric, lowerAlpha, upperAlpha, ascii }

/// Character ranges mapped to enums.
const Map<CharacterType, List<int>> characterRanges = {
  CharacterType.numeric: [48, 57], // '0'-'9'
  CharacterType.lowerAlpha: [97, 122], // 'a'-'z'
  CharacterType.upperAlpha: [65, 90], // 'A'-'Z'
  CharacterType.ascii: [asciiStart, asciiEnd], // All printable ASCII
};

/// Default random instance.
final _internal = Random();

/// Abstract provider for custom random number generators.
///
/// Implementations must provide methods to generate random doubles and integers.
abstract class AbstractRandomProvider {
  /// Returns a random double in the range [0.0, 1.0).
  double nextDouble();

  /// Returns a random integer in the range [0, max).
  int nextInt(int max);
}

/// Default provider using the `dart:math` Random.
///
/// Example:
/// ```dart
/// final provider = DefaultRandomProvider();
/// print(provider.nextDouble()); // Random double in range [0.0, 1.0)
/// ```
class DefaultRandomProvider implements AbstractRandomProvider {
  const DefaultRandomProvider();

  @override
  double nextDouble() => _internal.nextDouble();

  @override
  int nextInt(int max) => _internal.nextInt(max);
}

/// Provider using a seeded random number generator for deterministic behavior.
///
/// Example:
/// ```dart
/// final provider = SeededRandomProvider(12345);
/// print(provider.nextDouble()); // Deterministic output
/// ```
class SeededRandomProvider implements AbstractRandomProvider {
  final Random _random;

  SeededRandomProvider(int seed) : _random = Random(seed);

  @override
  double nextDouble() => _random.nextDouble();

  @override
  int nextInt(int max) => _random.nextInt(max);
}

/// Provider for cryptographic secure random numbers.
///
/// Example:
/// ```dart
/// final provider = CryptographicRandomProvider();
/// print(provider.nextDouble()); // Secure random double in range [0.0, 1.0)
/// ```
class CryptographicRandomProvider implements AbstractRandomProvider {
  final Random _secureRandom = Random.secure();

  @override
  double nextDouble() => _secureRandom.nextDouble();

  @override
  int nextInt(int max) => _secureRandom.nextInt(max);
}

/// Generates a random integer between [from] and [to], inclusive.
///
/// Throws [ArgumentError] if `from > to`.
///
/// Example:
/// ```dart
/// print(randomBetween(1, 10)); // Random integer between 1 and 10
/// ```
int randomBetween(int from, int to, {AbstractRandomProvider? provider}) {
  if (from > to) {
    throw ArgumentError('$from cannot be greater than $to');
  }

  final rand = provider ?? const DefaultRandomProvider();
  return (rand.nextDouble() * (to - from + 1)).toInt() + from;
}

/// Generates a random string of the specified [length] using characters
/// from the given [type].
///
/// Example:
/// ```dart
/// print(randomString(5, CharacterType.lowerAlpha)); // Random lowercase string
/// ```
String randomString(int length, CharacterType type,
    {AbstractRandomProvider? provider}) {
  final range = characterRanges[type]!;
  return String.fromCharCodes(List.generate(
      length, (_) => randomBetween(range[0], range[1], provider: provider)));
}

/// Generates a random numeric string of the specified [length].
///
/// Example:
/// ```dart
/// print(randomNumeric(5)); // Random numeric string of length 5
/// ```
String randomNumeric(int length, {AbstractRandomProvider? provider}) =>
    randomString(length, CharacterType.numeric, provider: provider);

/// Generates a random alphabetic string of the specified [length].
///
/// Example:
/// ```dart
/// print(randomAlpha(10)); // Random alphabetic string of length 10
/// ```
String randomAlpha(int length, {AbstractRandomProvider? provider}) {
  final lowerAlphaLength = randomBetween(0, length, provider: provider);
  final upperAlphaLength = length - lowerAlphaLength;

  final lowerAlpha = randomString(lowerAlphaLength, CharacterType.lowerAlpha,
      provider: provider);
  final upperAlpha = randomString(upperAlphaLength, CharacterType.upperAlpha,
      provider: provider);

  return randomMerge(lowerAlpha, upperAlpha);
}

/// Generates a random alphanumeric string of the specified [length].
///
/// Example:
/// ```dart
/// print(randomAlphaNumeric(8)); // Random alphanumeric string of length 8
/// ```
String randomAlphaNumeric(int length, {AbstractRandomProvider? provider}) {
  final alphaLength = randomBetween(0, length, provider: provider);
  final numericLength = length - alphaLength;

  final alpha = randomAlpha(alphaLength, provider: provider);
  final numeric = randomNumeric(numericLength, provider: provider);

  return randomMerge(alpha, numeric);
}

/// Merges two strings [a] and [b], shuffles their characters, and returns the result.
///
/// Example:
/// ```dart
/// print(randomMerge("abc", "123")); // Random shuffle of "abc123"
/// ```
String randomMerge(String a, String b) {
  final chars = [...a.codeUnits, ...b.codeUnits];
  chars.shuffle(_internal);
  return String.fromCharCodes(chars);
}

/// Measures the execution time of a function, expression, or computation and returns
/// a tuple containing both the result and the elapsed duration.
///
/// This function can be used in multiple ways:
/// 1. With a function reference: `time(() => factorial(20))`
/// 2. With a direct expression: `time(factorial(20))`
/// 3. With a callback that receives a measurement function: `time((measure) => measure(factorial)(20))`
///
/// Example 1 - With function reference:
/// ```dart
/// final result = time(() => factorial(20));
/// print('Result: ${result.result}, Time: ${result.elapsed.inMilliseconds}ms');
/// ```
///
/// Example 2 - With direct expression:
/// ```dart
/// final result = time(factorial(20));
/// print('Result: ${result.result}, Time: ${result.elapsed.inMilliseconds}ms');
/// ```
///
/// Example 3 - With measurement callback:
/// ```dart
/// final result = time((measure) {
///   final wrappedFactorial = measure(factorial);
///   return wrappedFactorial(20);
/// });
/// print('Result: ${result.result}, Time: ${result.elapsed.inMilliseconds}ms');
/// ```
///
/// Example 4 - Measuring multiple operations:
/// ```dart
/// final result = time((measure) {
///   final a = measure(() => operation1())(arg1);
///   final b = measure(() => operation2())(arg2);
///   return a + b;
/// });
/// ```
///
/// The returned [Duration] can be inspected using properties like:
/// - [Duration.inMicroseconds]
/// - [Duration.inMilliseconds]
/// - [Duration.inSeconds]
///
/// For more precise measurements of very fast operations, consider using
/// [Stopwatch] directly with [Stopwatch.elapsedMicroseconds].
({T result, Duration elapsed}) time<T>(dynamic functionOrValue) {
  // Case 1: Measurement callback with access to measure function
  if (functionOrValue is Function(Function)) {
    final sw = Stopwatch()..start();

    // Create a measure function that wraps any function to track its execution time
    measure(fn) {
      return (fn is Function)
          ? ((dynamic args) {
              final innerSw = Stopwatch()..start();
              final result = args != null ? fn(args) : fn();
              innerSw.stop();
              print('Operation took: ${innerSw.elapsed.inMicroseconds}μs');
              return result;
            })
          : fn;
    }

    final result = functionOrValue(measure);
    sw.stop();
    return (result: result as T, elapsed: sw.elapsed);
  }
  // Case 2: Function was passed
  else if (functionOrValue is Function) {
    final sw = Stopwatch()..start();
    final result = functionOrValue();
    sw.stop();
    return (result: result as T, elapsed: sw.elapsed);
  }
  // Case 3: Direct value was passed
  else {
    return (result: functionOrValue as T, elapsed: Duration.zero);
  }
}

/// Measures the execution time of an asynchronous function and returns a tuple
/// containing both the result and the elapsed duration.
///
/// Example:
/// ```dart
/// final result = await timeAsync(() async => await fetchData());
/// print('Result: ${result.result}, Time: ${result.elapsed.inMilliseconds}ms');
/// ```
///
/// For measuring multiple async operations:
/// ```dart
/// final result = await timeAsync((measure) async {
///   final a = await measure(() => fetchData1())();
///   final b = await measure(() => fetchData2())();
///   return combineResults(a, b);
/// });
/// ```
Future<({T result, Duration elapsed})> timeAsync<T>(
    dynamic functionOrValue) async {
  // Case 1: Measurement callback with access to measure function
  if (functionOrValue is Function(Function)) {
    final sw = Stopwatch()..start();

    // Create a measure function that wraps any async function to track its execution time
    Future<R> Function() measure<R>(dynamic fn) {
      return () async {
        final innerSw = Stopwatch()..start();
        final result = fn is Future ? await fn : await fn();
        innerSw.stop();
        print('Async operation took: ${innerSw.elapsed.inMicroseconds}μs');
        return result;
      };
    }

    final result = await functionOrValue(measure);
    sw.stop();
    return (result: result as T, elapsed: sw.elapsed);
  }
  // Case 2: Async function was passed
  else if (functionOrValue is Function) {
    final sw = Stopwatch()..start();
    final result = await functionOrValue();
    sw.stop();
    return (result: result as T, elapsed: sw.elapsed);
  }
  // Case 3: Direct value or Future was passed
  else {
    final value =
        functionOrValue is Future ? await functionOrValue : functionOrValue;
    return (result: value as T, elapsed: Duration.zero);
  }
}
