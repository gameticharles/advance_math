library maths;

import 'dart:math' as math;
import 'dart:typed_data';

import '../../quantity/quantity.dart';

part 'basic.dart';
part 'statistics.dart';
part 'constants.dart';
part 'trigonometry.dart';
part 'logarithm.dart';
part 'extension.dart';

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
class Random implements math.Random {
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
