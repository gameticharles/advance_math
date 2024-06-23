library maths;

import 'dart:math' as math;

import '../../quantity/quantity.dart';

part 'basic.dart';
part 'statistics.dart';
part 'constants.dart';
part 'trigonometry.dart';
part 'logarithm.dart';
part 'extension.dart';

/// A generator of random bool, int, or double values.
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

  ///Creates a cryptographically secure random number generator.
  ///
  ///If the program cannot provide a cryptographically secure source of random numbers, it throws an [UnsupportedError].
  Random.secure() : _random = math.Random.secure();

  @override
  bool nextBool() => _random.nextBool();

  @override
  double nextDouble() => _random.nextDouble();

  @override
  int nextInt(int max) => _random.nextInt(max);
}
