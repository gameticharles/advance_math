part of '../../advance_math.dart';

/// A class that implements a compressed prime sieve using bit manipulation.
/// Each bit represents a boolean value indicating whether a number is prime or not.
/// This saves memory when creating the sieve. In this implementation, only odd numbers are stored
/// in individual integers, meaning that each integer can represent a range of 128 numbers
/// (even numbers are omitted because they are not prime, with the exception of 2 which is handled as a special case).
///
/// Time Complexity: ~O(n log log n)
///
/// Example usage:
/// ```dart
/// void main() {
///   final int limit = 200;
///   List<int> sieve = CompressedPrimeSieve.primeSieve(limit);
///
///   for (int i = 0; i <= limit; i++) {
///     if (CompressedPrimeSieve.isPrime(sieve, i)) {
///       print("$i is prime!");
///     }
///   }
/// }
/// ```
class CompressedPrimeSieve {
  static const int numBits = 128;
  static const int numBitsShift = 7; // 2^7 = 128

  /// Sets the bit representing [n] to 1 indicating this number is not prime.
  ///
  /// [arr] is the list of integers representing the bit array.
  /// [n] is the number to mark as not prime.
  static void setBit(List<int> arr, int n) {
    if ((n & 1) == 0) return; // n is even
    arr[n >> numBitsShift] |= 1 << ((n - 1) >> 1);
  }

  /// Returns true if the bit for [n] is off (meaning [n] is a prime).
  ///
  /// [arr] is the list of integers representing the bit array.
  /// [n] is the number to check for primality.
  /// Note: Do not use this method to access numbers outside your prime sieve range!
  static bool isNotSet(List<int> arr, int n) {
    if (n < 2) return false; // n is not prime
    if (n == 2) return true; // two is prime
    if ((n & 1) == 0) return false; // n is even
    int chunk = arr[n >> numBitsShift];
    int mask = 1 << ((n - 1) >> 1);
    return (chunk & mask) != mask;
  }

  /// Returns true or false depending on whether [n] is prime.
  ///
  /// [sieve] is the list of integers representing the bit array.
  /// [n] is the number to check for primality.
  static bool isPrime(List<int> sieve, int n) {
    return isNotSet(sieve, n);
  }

  /// Returns an array of integers with each bit indicating whether a number is prime or not.
  ///
  /// [limit] is the upper bound of the range for which the prime sieve is generated.
  /// Use the [isNotSet] and [setBit] methods to toggle the bits for each number.
  static List<int> primeSieve(int limit) {
    final int numChunks = (limit / numBits).ceil();
    final int sqrtLimit = math.sqrt(limit).toInt();
    List<int> chunks = List<int>.filled(numChunks, 0);
    chunks[0] = 1; // 1 is not prime
    for (int i = 3; i <= sqrtLimit; i += 2) {
      if (isNotSet(chunks, i)) {
        for (int j = i * i; j <= limit; j += i) {
          if (isNotSet(chunks, j)) {
            setBit(chunks, j);
          }
        }
      }
    }
    return chunks;
  }
}

// void main() {
//   final int limit = 200;
//   List<int> sieve = CompressedPrimeSieve.primeSieve(limit);

//   for (int i = 0; i <= limit; i++) {
//     if (CompressedPrimeSieve.isPrime(sieve, i)) {
//       print("$i is prime!");
//     }
//   }
// }
