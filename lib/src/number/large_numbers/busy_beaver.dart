part of 'large.dart';

/// Busy Beaver known summaries.
class BusyBeaver {
  static const Map<int, int> knownValues = {1: 1, 2: 6, 3: 21, 4: 107};
  static const Map<int, String> lowerBounds = {
    5: '≥ 47,176,870',
    6: '> 10↑↑15'
  };

  static String compute(int n) {
    if (n <= 0) throw ArgumentError('n must be positive');
    if (knownValues.containsKey(n)) return 'BB($n) = ${knownValues[n]}';
    if (lowerBounds.containsKey(n)) return 'BB($n) ${lowerBounds[n]}';
    return 'BB($n) is unknown (uncomputable)';
  }

  static String describe() => '''
Busy Beaver Function BB(n):
  - Max steps a halting n-state Turing machine can take
  - Uncomputable; grows faster than any computable function
  - BB(745) > Graham's Number
  - BB(n) < TREE(n) for small n
  - Known: ${knownValues.keys.join(', ')}''';
}
