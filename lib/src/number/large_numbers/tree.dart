part of 'large.dart';

/// Simple TREE tree node for embeddings.
class Tree {
  final int label;
  final List<Tree> children;

  Tree(this.label, [this.children = const []]);

  bool isEmbeddedIn(Tree other) {
    if (label > other.label) return false;
    return _canMapChildren(children, other.children);
  }

  bool _canMapChildren(List<Tree> mine, List<Tree> theirs) {
    if (mine.isEmpty) return true;
    if (theirs.isEmpty) return false;

    for (var myChild in mine) {
      bool found = false;
      for (var theirChild in theirs) {
        if (myChild.isEmbeddedIn(theirChild)) {
          found = true;
          break;
        }
      }
      if (!found) return false;
    }
    return true;
  }

  @override
  String toString() =>
      children.isEmpty ? '($label)' : '($label ${children.join(' ')})';

  String toVisual([int indent = 0]) {
    final prefix = '  ' * indent;
    if (children.isEmpty) return '$prefix└─ $label';
    final lines = ['$prefix└─ $label'];
    for (var child in children) {
      lines.add(child.toVisual(indent + 1));
    }
    return lines.join('\n');
  }
}

/// TREE(n) approximations and small exact values.
class TreeFunction {
  static final Map<int, BigInt> _cache = {};

  static BigInt compute(int n, {bool approximate = false}) {
    if (n <= 0) throw ArgumentError('TREE(n) requires n ≥ 1');
    if (_cache.containsKey(n)) return _cache[n]!;

    BigInt result;
    if (n == 1) {
      result = BigInt.one;
    } else if (n == 2) {
      result = BigInt.from(3);
    } else {
      result = approximate ? _approxTree(n) : BigInt.from(-1);
      if (!approximate && ComputeConfig.verboseMode) {
        print('⚠️ TREE($n) too large — use Symbolic.tree($n) instead');
      }
    }

    _cache[n] = result;
    return result;
  }

  static BigInt _approxTree(int n) {
    BigInt result = BigInt.two;
    for (int i = 1; i <= n; i++) {
      result = _safePow(result, BigInt.from(n + 1));
      if (result.bitLength > ComputeConfig.maxBitLength) {
        if (ComputeConfig.verboseMode) {
          print('Overflow during TREE($n) approximation.');
        }
        return BigInt.from(-1);
      }
    }
    return result;
  }

  static BigInt _safePow(BigInt base, BigInt exp) {
    if (exp < BigInt.zero) throw ArgumentError('Negative exponent');
    BigInt res = BigInt.one;
    BigInt b = base;
    BigInt e = exp;
    while (e > BigInt.zero) {
      if (e.isOdd) res *= b;
      b *= b;
      e >>= 1;
      if (res.bitLength > ComputeConfig.maxBitLength) return BigInt.from(-1);
    }
    return res;
  }

  static String describe(int n, {bool approximate = false}) {
    if (n == 1) return 'TREE(1) = 1';
    if (n == 2) return 'TREE(2) = 3';
    if (!approximate) {
      return 'TREE($n) is incomprehensibly large (beyond all hyperoperations)';
    }

    final approx = compute(n, approximate: true);
    return approx == BigInt.from(-1)
        ? 'TREE($n) ≈ [overflow]'
        : 'TREE($n) ≈ ${approx.toCompactString()}';
  }

  static String visualExample() {
    final t1 = Tree(2);
    final t2 = Tree(2, [Tree(1)]);
    final t3 = Tree(1);
    return '''
TREE(2) Example Sequence:
${t1.toVisual()}

${t2.toVisual()}

${t3.toVisual()}

Length = 3 (no tree is embedded in a later one)''';
  }

  static void clearCache() => _cache.clear();
  static int getCacheSize() => _cache.length;
}
