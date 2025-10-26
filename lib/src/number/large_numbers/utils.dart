part of 'large.dart';

/// ===============================
///  BIGINT EXTENSIONS
/// ===============================

extension BigIntLargeNumberExt on BigInt {
  int toIntSafe() {
    if (this > BigInt.from(1 << 62)) {
      throw RangeError('Value too large to convert to int');
    }
    return toInt();
  }

  int toIntOrLimit() {
    final limit = BigInt.from(ComputeConfig.maxIterations);
    return (this > limit ? limit : this).toInt();
  }

  String toCompactString() {
    if (this < BigInt.from(1000000)) return toString();
    final str = toString();
    if (str.length <= 20) return str;
    return '${str.substring(0, 10)}...${str.substring(str.length - 10)} '
        '(${str.length} digits)';
  }
}

/// Cache utilities and demonstration helpers.
class CacheStats {
  static void show() {
    print('Hyperoperation cache: ${getHyperCacheSize()}');
    print('Ackermann cache: ${Ackermann.getCacheSize()}');
    print('TREE cache: ${TreeFunction.getCacheSize()}');
  }

  static void clearAll() {
    clearHyperCache();
    Ackermann.clearCache();
    TreeFunction.clearCache();
  }
}

class GrowthComparison {
  static void compareAll() {
    print('\n╔════════════════════════════════════════╗');
    print('║      GROWTH RATE COMPARISON            ║');
    print('╚════════════════════════════════════════╝\n');

    print('For n = 3:\n');
    print('Polynomial:      n³ = ${pow(3, 3)}');
    print('Exponential:     3³ = ${expDouble(3, 3)}');
    print('Tetration:       3^^3 = ${tetration(BigInt.from(3), 3)}');
    print('Ackermann:       ${Ackermann.describe(3, 3)}');
    print('Graham g(1):     3↑↑↑↑3 = [incomputable]');
    print("Graham's G:      g(64) = [incomprehensible]");
    print('TREE(3):         [makes Graham look tiny!]');
    print('BB(3):           ${BusyBeaver.compute(3)}');
  }

  static void showKnownValues() {
    print('\n╔════════════════════════════════════════╗');
    print('║         KNOWN EXACT VALUES             ║');
    print('╚════════════════════════════════════════╝\n');

    print('Ackermann:');
    for (int m = 0; m <= 3; m++) {
      for (int n = 0; n <= 3; n++) {
        print('  ${Ackermann.describe(m, n)}');
      }
    }

    print('\nBusy Beaver:');
    for (int n = 1; n <= 6; n++) {
      print('  ${BusyBeaver.compute(n)}');
    }

    print('\nTREE:');
    for (int n = 1; n <= 3; n++) {
      print('  ${TreeFunction.describe(n)}');
    }
  }
}
