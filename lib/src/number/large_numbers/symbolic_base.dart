part of 'large.dart';

/// ============================================
///  LARGE NUMBER COMPUTATION LIBRARY v3
/// ============================================
///
/// Features:
/// - Hyperoperations (successor → pentation and beyond)
/// - Symbolic expression system for incomputable numbers
/// - Ackermann function with memoization
/// - TREE function with structural embedding
/// - Busy Beaver & Graham's number summaries
/// - BigInt-safe arithmetic with overflow control
/// - Configurable compute limits and verbosity
///
/// Merged best features from v2 (concrete) + symbolic system
/// ============================================

/// Abstract representation of possibly-large numbers (concrete or symbolic).
abstract class LargeNumber {
  /// Short expression form.
  String toExpression();

  /// Human description (multi-line allowed).
  String toDescription();

  /// Whether this LargeNumber is likely computable within limits.
  bool get isComputable;

  /// Attempt to compute a BigInt value, or return null if symbolic.
  BigInt? tryCompute();

  @override
  String toString() => toExpression();
}

/// Concrete wrapper for a BigInt.
class ConcreteNumber extends LargeNumber {
  final BigInt value;
  ConcreteNumber(this.value);

  @override
  String toExpression() => value.toString();

  @override
  String toDescription() => 'Concrete value: ${value.toString()}';

  @override
  bool get isComputable => true;

  @override
  BigInt? tryCompute() => value;
}

/// Simple HyperOperation symbolic node.
class HyperOperation extends LargeNumber {
  final LargeNumber base;
  final LargeNumber operand;
  final int level;

  HyperOperation(this.base, this.operand, this.level);

  @override
  String toExpression() {
    if (level <= 2) {
      final ops = ['+', '+', '×', '^'];
      return '${base.toExpression()}${ops[level]}${operand.toExpression()}';
    }
    final arrows = '↑' * (level - 2);
    return '${base.toExpression()}$arrows${operand.toExpression()}';
  }

  @override
  String toDescription() {
    final opName = _levelName(level);
    return '$opName of ${base.toExpression()} and ${operand.toExpression()}';
  }

  String _levelName(int lvl) {
    const names = [
      'Successor',
      'Sum',
      'Product',
      'Power',
      'Tetration',
      'Pentation',
      'Hexation'
    ];
    return lvl < names.length ? names[lvl] : 'Level-$lvl hyperop';
  }

  @override
  bool get isComputable {
    if (!base.isComputable || !operand.isComputable) return false;
    final b = base.tryCompute();
    final o = operand.tryCompute();
    if (b == null || o == null) return false;

    // Conservative estimates
    if (level >= 4 && o > BigInt.from(4)) return false;
    if (level >= 5 && o > BigInt.from(3)) return false;
    if (level >= 6 && o > BigInt.from(2)) return false;

    return true;
  }

  @override
  BigInt? tryCompute() {
    if (!isComputable) return null;
    try {
      final b = base.tryCompute();
      final o = operand.tryCompute();
      if (b == null || o == null) return null;
      return hyperop(b, o.toInt(), level);
    } catch (e) {
      return null;
    }
  }
}

class SymbolicTree extends LargeNumber {
  final int n;

  SymbolicTree(this.n);

  @override
  String toExpression() => 'TREE($n)';

  @override
  String toDescription() {
    if (n == 1) return 'TREE(1) = 1';
    if (n == 2) return 'TREE(2) = 3';
    if (n == 3) {
      return 'TREE(3) is incomprehensibly large, far exceeding Graham\'s number';
    }
    return 'TREE($n) grows faster than any computable function';
  }

  @override
  bool get isComputable => n <= 2;

  @override
  BigInt? tryCompute() {
    if (n == 1) return BigInt.one;
    if (n == 2) return BigInt.from(3);
    return null;
  }
}

class SymbolicAckermann extends LargeNumber {
  final int m;
  final int n;

  SymbolicAckermann(this.m, this.n);

  @override
  String toExpression() => 'A($m, $n)';

  @override
  String toDescription() => 'Ackermann function at m=$m, n=$n';

  @override
  bool get isComputable {
    if (m > 4) return false;
    if (m == 4 && n > 2) return false;
    return true;
  }

  @override
  BigInt? tryCompute() {
    if (!isComputable) return null;
    try {
      return Ackermann.compute(m, n);
    } catch (e) {
      return null;
    }
  }
}

class SymbolicGraham extends LargeNumber {
  final int layer;

  SymbolicGraham([this.layer = 64]);

  @override
  String toExpression() => layer == 64 ? 'G' : 'g($layer)';

  @override
  String toDescription() {
    if (layer == 1) return 'g(1) = 3↑↑↑↑3';
    if (layer == 64) return 'Graham\'s number (g(64))';
    return 'g($layer) = 3 with g(${layer - 1}) up-arrows between';
  }

  @override
  bool get isComputable => false;

  @override
  BigInt? tryCompute() => null;
}

class SymbolicBusyBeaver extends LargeNumber {
  final int n;

  SymbolicBusyBeaver(this.n);

  @override
  String toExpression() => 'BB($n)';

  @override
  String toDescription() => 'Busy Beaver function for $n states';

  @override
  bool get isComputable => n <= 4;

  @override
  BigInt? tryCompute() {
    if (BusyBeaver.knownValues.containsKey(n)) {
      return BigInt.from(BusyBeaver.knownValues[n]!);
    }
    return null;
  }
}

/// Helper to create symbolic expressions
class Symbolic {
  static LargeNumber num(int value) => ConcreteNumber(BigInt.from(value));
  static LargeNumber bignum(BigInt value) => ConcreteNumber(value);

  static LargeNumber add(LargeNumber a, LargeNumber b) =>
      HyperOperation(a, b, 1);
  static LargeNumber mul(LargeNumber a, LargeNumber b) =>
      HyperOperation(a, b, 2);
  static LargeNumber pow(LargeNumber a, LargeNumber b) =>
      HyperOperation(a, b, 3);
  static LargeNumber tet(LargeNumber a, LargeNumber b) =>
      HyperOperation(a, b, 4);
  static LargeNumber pent(LargeNumber a, LargeNumber b) =>
      HyperOperation(a, b, 5);
  static LargeNumber hex(LargeNumber a, LargeNumber b) =>
      HyperOperation(a, b, 6);
  static LargeNumber hyperop(LargeNumber a, LargeNumber b, int level) =>
      HyperOperation(a, b, level);

  static LargeNumber tree(int n) => SymbolicTree(n);
  static LargeNumber ackermann(int m, int n) => SymbolicAckermann(m, n);
  static LargeNumber graham([int layer = 64]) => SymbolicGraham(layer);
  static LargeNumber busyBeaver(int n) => SymbolicBusyBeaver(n);
}
