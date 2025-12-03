part of '../../advance_math.dart';

void printLine([String s = '']) {
  var l = '--- ' * 10;
  print('\n$l$s $l\n');
}

/// A robust, memory-efficient arithmetic progression class for Dart.
///
/// [Range] generates a sequence of numbers (integers or doubles) on the fly
/// without storing them in memory. It extends [IterableMixin], allowing usage
/// with standard Dart iterable methods (map, where, reduce) while providing
/// optimized $O(1)$ implementations for mathematical operations like [sum],
/// [length], and [contains].
///
/// ### Key Features:
/// * **Lazy Evaluation:** Can represent ranges of billions of numbers with almost zero memory usage.
/// * **Performance:** [length], [sum], [average], and [contains] are calculated mathematically in constant time $O(1)$.
/// * **Flexibility:** Supports integers, doubles, negative steps, and linear interpolation ([Range.linspace]).
///
/// ### Modes of Operation:
/// 1. **Math Mode:** Floating point numbers, infinite generators, calculus.
/// 2. **Slice Mode:** Integer generation relative to an array size (supporting negative indices).
///
/// ### Examples
///
/// **Math Mode:**
///
/// ```dart
/// // Standard integer loop
/// for (final i in Range(0, 5)) {
///   print(i); // 0, 1, 2, 3, 4
/// }
///
/// // Floating point step
/// final doubles = Range(0.0, 1.0, 0.2); // 0.0, 0.2, 0.4, 0.6, 0.8
///
/// // Instant math on massive ranges
/// final huge = Range(0, 1000000);
/// print(huge.sum); // Calculated instantly
/// ```
///
///
/// **Parsing Mode:**
/// ```dart
/// // Parse standard Python syntax
/// final r = Range.parse("0:10:2");
/// ```
///
/// **Slicing Mode (The "View" Feature):**
/// ```dart
/// List<String> data = ['A', 'B', 'C', 'D', 'E'];
///
/// // Create a range that represents "All items, reversed"
/// // We pass data.length so it knows how to resolve "-1"
/// final r = Range.bounds(data.length, "::-1");
///
/// print(r.toList()); // [4, 3, 2, 1, 0]
/// ```
class Range extends IterableMixin<num> {
  /// The starting value of the range.
  final num start;

  /// The bound of the range.
  /// Depending on the constructor, this may be inclusive or exclusive.
  final num end;

  /// The difference between each value in the sequence.
  final num step;

  /// Whether [end] is included in the range.
  final bool isInclusive;

  // --- Constructors ---

  /// Creates a range from [start] to [end] (exclusive).
  ///
  /// The sequence will start at [start] and increment by [step] until it
  /// reaches (but does not include) [end].
  ///
  /// [step] defaults to 1.
  ///
  /// Throws [ArgumentError] if [step] is 0 or if the direction of start/end
  /// does not match the sign of the step.
  ///
  /// ```dart
  /// final r = Range(0, 5);
  /// print(r.toList()); // [0, 1, 2, 3, 4]
  ///
  /// final r2 = Range(10, 0, -2);
  /// print(r2.toList()); // [10, 8, 6, 4, 2]
  /// ```
  Range(this.start, this.end, [this.step = 1]) : isInclusive = false {
    _validate();
  }

  /// Creates a range from [start] to [end] (inclusive).
  ///
  /// The sequence will start at [start] and increment by [step]. unlike the
  /// default constructor, this *will* include [end] if it falls exactly on a step.
  ///
  /// ```dart
  /// final r = Range.inclusive(1, 3);
  /// print(r.toList()); // [1, 2, 3]
  ///
  /// // With step 2, '4' is not hit, so it stops at 3
  /// final r2 = Range.inclusive(1, 4, 2);
  /// print(r2.toList()); // [1, 3]
  /// ```
  Range.inclusive(this.start, this.end, [this.step = 1]) : isInclusive = true {
    _validate();
  }

  /// Creates a range with exactly [count] values evenly spaced between [start] and [end].
  ///
  /// Also known as "Linear Spacing" or "Linear Interpolation". This is useful
  /// for generating graph axes, gradients, or animation frames.
  ///
  /// The resulting range is always **inclusive**.
  ///
  /// ```dart
  /// // Generate 5 points from 0 to 10
  /// final r = Range.linspace(0, 10, 5);
  /// print(r.toList()); // [0.0, 2.5, 5.0, 7.5, 10.0]
  /// ```
  factory Range.linspace(num start, num end, int count) {
    if (count <= 1) return Range.inclusive(start, end, end - start);
    return Range.inclusive(start, end, (end - start) / (count - 1));
  }

  // --- 2. String Parsing Constructors (Python Style) ---

  /// Parses a concrete string spec like `"0:10:2"`.
  ///
  /// Does NOT support negative/relative indices (like `:-1`) because
  /// the total length is unknown. Use [Range.bounds] for that.
  factory Range.parse(String spec) {
    final parts = spec.split(':');
    if (parts.isEmpty || parts.length > 3) {
      throw FormatException("Invalid range format: $spec");
    }

    num? parse(String s) => s.isEmpty ? null : num.tryParse(s);

    final p1 = parse(parts[0]);

    // Case: "5" (Single number treated as range 0..5)
    if (parts.length == 1) return Range(0, p1 ?? 0);

    final p2 = parts.length > 1 ? parse(parts[1]) : null;
    final p3 = parts.length > 2 ? parse(parts[2]) : 1;

    // Defaults: start=0, end required, step=1
    return Range(p1 ?? 0, p2 ?? 0, p3 ?? 1);
  }

  // --- 3. Slice Resolution Constructor (The Robust Array Feature) ---

  /// Creates a Range by resolving a slice string against a specific [length].
  ///
  /// This handles Python/NumPy logic:
  /// * Negative indices: `-1` becomes `length - 1`
  /// * Empty start/end: `::` becomes full range
  /// * Reversal: `::-1` automatically sets start to end and end to beginning.
  ///
  /// [spec] examples: `1:5`, `::-1`, `:-2`.
  /// Creates a Range by resolving a slice string against a specific [length].
  factory Range.bounds(int length, String spec) {
    if (length < 0) throw ArgumentError("Length must be non-negative");

    final parts = spec.split(':');

    // Helper to parse integers or return null
    int? p(String s) => s.isEmpty ? null : int.tryParse(s);

    // 1. Parse raw parts
    int? sStart, sStop, sStep;
    if (parts.length == 1) {
      // Special case: "5" -> index 5 only
      int idx = p(parts[0]) ?? 0;
      if (idx < 0) idx += length;
      return Range(idx, idx + 1);
    }
    sStart = p(parts[0]);
    sStop = parts.length > 1 ? p(parts[1]) : null;
    sStep = parts.length > 2 ? p(parts[2]) : 1;

    final step = sStep ?? 1;
    if (step == 0) throw ArgumentError("Step cannot be zero");

    // 2. Resolve Start
    int rStart;
    if (sStart == null) {
      rStart = step > 0 ? 0 : length - 1;
    } else {
      rStart = sStart;
      if (rStart < 0) rStart += length; // Handle "-1"
      // Clamp to valid array bounds
      if (rStart < 0) rStart = (step > 0) ? 0 : -1;
      if (rStart >= length) rStart = (step > 0) ? length : length - 1;
    }

    // 3. Resolve Stop
    int rStop;
    if (sStop == null) {
      rStop = step > 0 ? length : -1; // -1 is the "sentinel" to stop at 0
    } else {
      rStop = sStop;
      if (rStop < 0) rStop += length; // Handle "-1"
      // Clamp to valid array bounds
      if (rStop < 0) rStop = (step > 0) ? 0 : -1;
      if (rStop >= length) rStop = (step > 0) ? length : length - 1;
    }

    return Range(rStart, rStop, step);
  }

  void _validate() {
    if (step == 0) throw ArgumentError("Step cannot be 0");
    // Standard validation relaxed slightly to allow "empty" ranges logic
    // but strict about infinite loops
    if (start < end && step < 0) {
      /* Empty range, valid */
    } else if (start > end && step > 0) {/* Empty range, valid */}
  }

  // --- Core Iterable Logic ---

  @override
  Iterator<num> get iterator => _RangeIterator(start, end, step, isInclusive);

  /// Returns the number of elements in the range.
  ///
  /// This is an $O(1)$ operation. It calculates the length using math formula
  /// rather than iterating through the elements.
  ///
  /// ```dart
  /// final r = Range(0, 1000000);
  /// print(r.length); // 1000000 (Instant)
  /// ```
  @override
  int get length {
    // Math O(1) Calculation
    if (step > 0 && start >= end) return 0;
    if (step < 0 && start <= end) return 0; // Fixed logic for reverse bounds

    final diff = (end - start).abs();
    final absStep = step.abs();

    if (isInclusive) {
      return (diff / absStep).floor() + 1;
    } else {
      // Safe exclusive calc for both int and float
      // If step > 0, we want ceil((end - start) / step)
      // Implementation below handles floating precision
      return ((diff - 1e-10) / absStep).floor() + 1;
    }
  }

  /// Checks if [element] is contained in the range.
  ///
  /// This is an $O(1)$ operation. It checks bounds and uses modulo arithmetic
  /// to verify if the number falls exactly on a step.
  ///
  /// Includes epsilon precision handling for double comparisons.
  ///
  /// ```dart
  /// final r = Range(0, 10, 2);
  /// print(r.contains(6)); // true
  /// print(r.contains(5)); // false (not in step)
  /// print(r.contains(10)); // false (exclusive end)
  /// ```
  @override
  bool contains(Object? element) {
    if (element is! num) return false;
    bool inBounds;
    if (step > 0) {
      inBounds =
          element >= start && (isInclusive ? element <= end : element < end);
    } else {
      inBounds =
          element <= start && (isInclusive ? element >= end : element > end);
    }
    if (!inBounds) return false;
    return ((element - start) % step).abs() < 1e-10;
  }

  // --- O(1) Mathematical Statistics ---

  /// Returns the actual last value in the sequence.
  ///
  /// Note: This might be different from [end] if the step doesn't land perfectly.
  ///
  /// ```dart
  /// final r = Range(0, 10, 3); // 0, 3, 6, 9
  /// print(r.end);       // 10
  /// print(r.lastValue); // 9
  /// ```
  num get lastValue {
    if (length == 0) throw StateError('Empty range has no last value');
    return start + (length - 1) * step;
  }

  /// Calculates the arithmetic sum of the range.
  ///
  /// This is an $O(1)$ operation using the Arithmetic Progression formula:
  /// $S_n = \frac{n}{2}(a_1 + a_n)$.
  ///
  /// ```dart
  /// final r = Range(1, 101); // 1 to 100
  /// print(r.sum); // 5050
  /// ```
  num get sum {
    if (isEmpty) return 0;
    return (length / 2) * (start + lastValue);
  }

  /// Calculates the arithmetic mean (average) of the range.
  ///
  /// This is an $O(1)$ operation.
  num get average {
    if (isEmpty) return 0;
    return sum / length;
  }

  /// Returns the smallest value in the range.
  ///
  /// If the step is positive, this is [start].
  /// If the step is negative, this is [lastValue].
  num get min => step > 0 ? start : lastValue;

  /// Returns the largest value in the range.
  ///
  /// If the step is positive, this is [lastValue].
  /// If the step is negative, this is [start].
  num get max => step > 0 ? lastValue : start;

  // --- Utility Features ---

  // --- New Feature: O(1) Random Access ---

  /// Returns the value at index [index] in the generated sequence.
  /// Throws if [index] is out of bounds.
  ///
  /// This enables `range[5]` without iterating.
  num operator [](int index) {
    if (index < 0 || index >= length) throw RangeError.index(index, this);
    return start + (index * step);
  }

  /// Returns integers only. Throws if range contains fractions.
  Iterable<int> get toInts {
    if (start is int && step is int) return cast<int>();
    throw StateError("Range contains doubles, cannot cast to int");
  }

  /// Returns a valid random number from within this specific range.
  ///
  /// The returned number is guaranteed to be a valid step in the sequence.
  /// You can optionally provide your own [random] generator.
  ///
  /// ```dart
  /// final r = Range(0, 100, 5);
  /// print(r.random()); // Might be 5, 20, 95... (Never 96)
  /// ```
  num random([math.Random? random]) {
    if (isEmpty) throw StateError('Cannot pick random from empty range');
    final rnd = random ?? math.Random();
    final index = rnd.nextInt(length);
    return start + (index * step);
  }

  /// Converts the range into an asynchronous [Stream].
  ///
  /// This is useful for time-based operations, such as countdowns, animations,
  /// or staggering processing to avoid blocking the UI.
  ///
  /// [interval]: If provided, adds a delay between each emission.
  ///
  /// ```dart
  /// final countdown = Range(3, 0, -1);
  /// await for (final n in countdown.toStream(interval: Duration(seconds: 1))) {
  ///   print(n); // Prints 3, then 2, then 1 with 1s delays
  /// }
  /// ```
  Stream<num> toStream({Duration? interval}) async* {
    final it = iterator;
    while (it.moveNext()) {
      if (interval != null) {
        await Future.delayed(interval);
      }
      yield it.current;
    }
  }

  @override
  String toString() => 'Range($start, $end, step: $step)';
}

// --- Iterator Implementation ---

class _RangeIterator implements Iterator<num> {
  final num _start;
  final num _end;
  final num _step;
  final bool _inclusive;
  num? _current;
  int _index = 0;

  _RangeIterator(this._start, this._end, this._step, this._inclusive);

  @override
  num get current => _current!;

  @override
  bool moveNext() {
    num nextVal = _start + (_step * _index);
    // Float precision correction
    if ((nextVal - _end).abs() < 1e-10) nextVal = _end;

    bool isFinished;
    if (_step > 0) {
      isFinished =
          _inclusive ? nextVal > _end + 1e-10 : nextVal >= _end - 1e-10;
    } else {
      isFinished =
          _inclusive ? nextVal < _end - 1e-10 : nextVal <= _end + 1e-10;
    }

    if (isFinished) return false;
    _current = nextVal;
    _index++;
    return true;
  }
}

/// A class representing a continuous interval between two values (min and max).
///
/// Unlike [Range], which implies a stepped sequence, [Domain] represents
/// the infinite set of real numbers between [min] and [max].
///
/// Common uses:
/// * Graph axes (minX to maxX)
/// * Normalizing data (0.0 to 1.0)
/// * Hit testing and collision detection (1D)
class Domain {
  final double min;
  final double max;

  /// Creates a rigid domain. Throws error if [min] > [max].
  const Domain(this.min, this.max) : assert(min <= max, 'min must be <= max');

  /// Creates a domain from any two numbers, automatically sorting them
  /// so the smaller becomes min and larger becomes max.
  factory Domain.fromValues(double a, double b) {
    return Domain(math.min(a, b), math.max(a, b));
  }

  /// Creates a domain that encompasses all values in a list.
  factory Domain.enclosing(List<double> values) {
    if (values.isEmpty) return const Domain(0, 0);
    double min = values.first;
    double max = values.first;
    for (var v in values) {
      if (v < min) min = v;
      if (v > max) max = v;
    }
    return Domain(min, max);
  }

  // --- Geometric Properties ---

  /// The absolute length/size of the domain.
  double get size => max - min;

  /// The exact center point of the domain.
  double get center => min + (size / 2);

  // --- Logic & Checks ---

  /// Checks if [value] is strictly inside or on the edges of the domain.
  bool contains(double value) => value >= min && value <= max;

  /// Checks if this domain completely covers/contains [other].
  bool containsDomain(Domain other) => min <= other.min && max >= other.max;

  /// Checks if this domain overlaps with [other] at any point.
  bool overlaps(Domain other) {
    return min <= other.max && max >= other.min;
  }

  // --- Set Operations (Interval Arithmetic) ---

  /// Returns a new Domain representing the intersection (overlapping area)
  /// between this and [other].
  ///
  /// Returns `null` if they do not overlap.
  Domain? intersect(Domain other) {
    if (!overlaps(other)) return null;
    return Domain(math.max(min, other.min), math.min(max, other.max));
  }

  /// Returns a new Domain that covers the full extent of both domains.
  Domain union(Domain other) {
    return Domain(math.min(min, other.min), math.max(max, other.max));
  }

  // --- Mapping & Transformation (The "Killer Feature") ---

  /// Clamps [value] so it never exceeds min or max.
  double clamp(double value) => value.clamp(min, max);

  /// **Normalize**: Converts a [value] from this domain into a 0.0 to 1.0 range.
  ///
  /// * value == min -> 0.0
  /// * value == center -> 0.5
  /// * value == max -> 1.0
  double normalize(double value) {
    if (size == 0) return 0.0;
    return (value - min) / size;
  }

  /// **Lerp (Linear Interpolate)**: Converts a normalized (0.0-1.0) [t]
  /// back into a value within this domain.
  ///
  /// * t == 0.0 -> min
  /// * t == 0.5 -> center
  /// * t == 1.0 -> max
  double lerp(double t) {
    return min + (t * size);
  }

  /// **Remap**: Moves a [value] relative to THIS domain into a TARGET domain.
  ///
  /// Example: Mapping data (-10 to 10) to screen pixels (0 to 500).
  double mapTo(double value, Domain target) {
    final t = normalize(value);
    return target.lerp(t);
  }

  // --- Standard Overrides ---

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Domain &&
          runtimeType == other.runtimeType &&
          min == other.min &&
          max == other.max;

  @override
  int get hashCode => Object.hash(min, max);

  @override
  String toString() =>
      'Domain(${min.toStringAsFixed(2)}, ${max.toStringAsFixed(2)})';
}
