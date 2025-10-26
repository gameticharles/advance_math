part of 'large.dart';

///  HYPEROPERATION SYSTEM
/// Supports:
///   level 0: successor (a + 1)
///   level 1: addition
///   level 2: multiplication
///   level 3: exponentiation
///   level 4: tetration
///   level 5: pentation
///   and beyond...
///
/// Features:
///  - Uses BigInt for large integer operations.
///  - Memoization cache for efficiency.
///  - Graceful overflow protection.
/// ===============================
BigInt hyperop(BigInt a, int b, int level) {
  if (level < 0) throw ArgumentError('Level must be non-negative');
  if (b < 0 && level >= 3) {
    throw ArgumentError('Negative exponent not supported for level >= 3');
  }

  final key = '$a:$b:$level';
  if (_hyperCache.containsKey(key)) return _hyperCache[key]!;

  BigInt result;

  if (level == 0) {
    result = a + BigInt.one;
  } else if (level == 1) {
    result = a + BigInt.from(b);
  } else if (level == 2) {
    result = a * BigInt.from(b);
  } else if (b == 0) {
    result = (level >= 3) ? BigInt.one : BigInt.zero;
  } else if (b == 1) {
    result = a;
  } else {
    // Symbolic fallback for huge values
    if (ComputeConfig.useSymbolicFallback && level >= 4 && b > 4) {
      final arrows = '↑' * (level - 2);
      throw RangeError(
          'Too large to compute: $a$arrows$b\nUse Symbolic.hyperop() instead');
    }

    result = a;
    for (int i = 1; i < b; i++) {
      result = hyperop(a, result.toIntOrLimit(), level - 1);
      if (result.bitLength > ComputeConfig.maxBitLength) {
        throw RangeError(
            'Result exceeds ${ComputeConfig.maxBitLength} bits at level $level');
      }
    }
  }

  _hyperCache[key] = result;
  return result;
}

/// ===== Utility Wrappers =====
BigInt addition(BigInt a, BigInt b) => hyperop(a, b.toIntOrLimit(), 1);
BigInt multiplication(BigInt a, BigInt b) => hyperop(a, b.toIntOrLimit(), 2);
BigInt expInt(BigInt a, BigInt b) => hyperop(a, b.toIntOrLimit(), 3);
BigInt tetration(BigInt a, int b) => hyperop(a, b, 4);
BigInt pentation(BigInt a, int b) => hyperop(a, b, 5);
BigInt hexation(BigInt a, int b) => hyperop(a, b, 6);

/// ===== Mixed-Type Convenience Wrappers =====
double expDouble(double a, double b) => pow(a, b).toDouble();

/// Clear the memoization cache
void clearHyperCache() => _hyperCache.clear();

/// Get cache statistics
int getHyperCacheSize() => _hyperCache.length;

final Map<String, BigInt> _hyperCache = {};
