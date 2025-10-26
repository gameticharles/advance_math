part of 'large.dart';

/// Ackermann with memoization and safety.
class Ackermann {
  static final Map<String, BigInt> _cache = {};

  /// Compute A(m,n) with memoization.
  static BigInt compute(int m, int n) {
    if (m < 0 || n < 0) throw ArgumentError('m and n must be non-negative');

    final key = '$m:$n';
    if (_cache.containsKey(key)) return _cache[key]!;

    BigInt result;

    if (m == 0) {
      result = BigInt.from(n + 1);
    } else if (n == 0) {
      result = compute(m - 1, 1);
    } else {
      result = compute(m - 1, compute(m, n - 1).toIntOrLimit());
    }

    _cache[key] = result;
    return result;
  }

  /// Describe A(m,n) safely.
  static String describe(int m, int n) {
    try {
      final result = compute(m, n);
      return 'A($m, $n) = ${result.toCompactString()}';
    } catch (e) {
      return 'A($m, $n) = [overflow: $e]';
    }
  }

  static void clearCache() => _cache.clear();
  static int getCacheSize() => _cache.length;
}
