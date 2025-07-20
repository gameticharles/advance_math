part of '/advance_math.dart';

/// Status of a memoized computation.
enum MemoizedStatus { notComputed, computed, expired }

/// Configuration options for memoization.
class MemoizeOptions {
  /// Maximum number of entries to keep in the cache (LRU eviction policy).
  /// If null, cache size is unlimited.
  final int? maxSize;

  /// Time-to-live for cached entries. After this duration, entries are considered expired.
  /// If null, entries don't expire based on time.
  final Duration? ttl;

  const MemoizeOptions({this.maxSize, this.ttl});

  /// Default options with unlimited cache size and no time-based expiration.
  static const unlimited = MemoizeOptions();

  /// Options for a small LRU cache (100 entries).
  static const smallLRU = MemoizeOptions(maxSize: 100);

  /// Options for a medium LRU cache (1000 entries).
  static const mediumLRU = MemoizeOptions(maxSize: 1000);

  /// Options for a large LRU cache (10000 entries).
  static const largeLRU = MemoizeOptions(maxSize: 10000);

  /// Options for short-lived cache entries (1 minute).
  static const shortLived = MemoizeOptions(ttl: Duration(minutes: 1));

  /// Options for medium-lived cache entries (10 minutes).
  static const mediumLived = MemoizeOptions(ttl: Duration(minutes: 10));

  /// Options for long-lived cache entries (1 hour).
  static const longLived = MemoizeOptions(ttl: Duration(hours: 1));
}

/// A powerful memoization system that can cache results of any function.
///
/// This system provides several ways to memoize functions:
/// 1. Using extension methods on functions (easiest approach)
/// 2. Using the `Memoize` factory methods (more control)
/// 3. Creating instances of `Memoized` classes directly (most control)
///
/// Example usage:
/// ```dart
/// // Simple function memoization with extension method
/// int fibonacci(int n) => n <= 1 ? n : fibonacci(n - 1) + fibonacci(n - 2);
/// final memoFib = fibonacci.memoize();
/// print(memoFib(40)); // Fast even for large values
///
/// // Memoize a function with multiple arguments
/// int add(int a, int b) => a + b;
/// final memoAdd = add.memoize();
/// print(memoAdd(5, 3)); // Cached based on both arguments
///
/// // Memoize with custom cache key
/// final memoWithCustomKey = Memoize.function2WithKey(
///   (User user, int value) => expensiveOperation(user, value),
///   (user, value) => '${user.id}:$value' // Custom key generator
/// );
///
/// // Memoize with LRU cache
/// final memoWithLRU = fibonacci.memoize(options: MemoizeOptions(maxSize: 100));
/// ```
class Memoize {
  /// Creates a memoized version of a function with no arguments.
  static Memoized0<R> function0<R>(R Function() fn,
          {MemoizeOptions options = MemoizeOptions.unlimited}) =>
      Memoized0(fn, options: options);

  /// Creates a memoized version of a function with one argument.
  static Memoized1<A, R> function1<A, R>(R Function(A) fn,
          {MemoizeOptions options = MemoizeOptions.unlimited}) =>
      Memoized1(fn, options: options);

  /// Creates a memoized version of a function with two arguments.
  static Memoized2<A, B, R> function2<A, B, R>(R Function(A, B) fn,
          {MemoizeOptions options = MemoizeOptions.unlimited}) =>
      Memoized2(fn, options: options);

  /// Creates a memoized version of a function with three arguments.
  static Memoized3<A, B, C, R> function3<A, B, C, R>(R Function(A, B, C) fn,
          {MemoizeOptions options = MemoizeOptions.unlimited}) =>
      Memoized3(fn, options: options);

  /// Creates a memoized version of a function with four arguments.
  static Memoized4<A, B, C, D, R> function4<A, B, C, D, R>(
          R Function(A, B, C, D) fn,
          {MemoizeOptions options = MemoizeOptions.unlimited}) =>
      Memoized4(fn, options: options);

  /// Creates a memoized version of a function with five arguments.
  static Memoized5<A, B, C, D, E, R> function5<A, B, C, D, E, R>(
          R Function(A, B, C, D, E) fn,
          {MemoizeOptions options = MemoizeOptions.unlimited}) =>
      Memoized5(fn, options: options);

  /// Creates a memoized version of a function with one argument and a custom key generator.
  static Memoized1WithKey<A, R> function1WithKey<A, R>(
          R Function(A) fn, String Function(A) keyFn,
          {MemoizeOptions options = MemoizeOptions.unlimited}) =>
      Memoized1WithKey(fn, keyFn, options: options);

  /// Creates a memoized version of a function with two arguments and a custom key generator.
  static Memoized2WithKey<A, B, R> function2WithKey<A, B, R>(
          R Function(A, B) fn, String Function(A, B) keyFn,
          {MemoizeOptions options = MemoizeOptions.unlimited}) =>
      Memoized2WithKey(fn, keyFn, options: options);

  /// Creates a memoized version of a function with variable arguments.
  static MemoizedVarArgs<R> functionVarArgs<R>(R Function(List<dynamic>) fn,
          {MemoizeOptions options = MemoizeOptions.unlimited}) =>
      MemoizedVarArgs(fn, options: options);

  /// Creates a memoized version of a function with variable arguments and a custom key generator.
  static MemoizedVarArgsWithKey<R> functionVarArgsWithKey<R>(
          R Function(List<dynamic>) fn, String Function(List<dynamic>) keyFn,
          {MemoizeOptions options = MemoizeOptions.unlimited}) =>
      MemoizedVarArgsWithKey(fn, keyFn, options: options);

  /// Creates a memoized version of an async function with one argument.
  static AsyncMemoized1<A, R> asyncFunction1<A, R>(Future<R> Function(A) fn,
          {MemoizeOptions options = MemoizeOptions.unlimited}) =>
      AsyncMemoized1(fn, options: options);

  /// Creates a memoized version of an async function with two arguments.
  static AsyncMemoized2<A, B, R> asyncFunction2<A, B, R>(
          Future<R> Function(A, B) fn,
          {MemoizeOptions options = MemoizeOptions.unlimited}) =>
      AsyncMemoized2(fn, options: options);
}

/// Base class for all memoized function wrappers.
abstract class MemoizedBase<R> {
  /// The current status of the memoized computation.
  MemoizedStatus _status = MemoizedStatus.notComputed;

  /// Configuration options for this memoized function.
  final MemoizeOptions options;

  MemoizedBase({this.options = MemoizeOptions.unlimited});

  /// Check if the memoized value is expired.
  bool get isExpired => _status == MemoizedStatus.expired;

  /// Check if the memoized value is not computed yet.
  bool get isNotComputedYet => _status == MemoizedStatus.notComputed;

  /// Check if the memoized value is successfully computed.
  bool get isComputed => _status == MemoizedStatus.computed;

  /// Marks the cached value as expired, so the next call will trigger a recomputation.
  void expire() => _status = MemoizedStatus.expired;

  /// Clears all cached values, forcing recomputation on next call.
  void clearCache();

  /// Returns the current cache size.
  int get cacheSize;

  /// Returns statistics about the cache usage.
  Map<String, dynamic> get cacheStats;
}

/// A simple LRU cache implementation.
class _LRUCache<K, V> {
  final int? maxSize;
  final Map<K, V> _cache = {};
  final List<K> _accessOrder = [];

  _LRUCache({this.maxSize});

  V? get(K key) {
    final value = _cache[key];
    if (value != null) {
      // Move to the end of the access list (most recently used)
      _accessOrder.remove(key);
      _accessOrder.add(key);
    }
    return value;
  }

  void put(K key, V value) {
    if (_cache.containsKey(key)) {
      // Update existing entry
      _cache[key] = value;
      _accessOrder.remove(key);
      _accessOrder.add(key);
    } else {
      // Add new entry
      _cache[key] = value;
      _accessOrder.add(key);

      // Evict least recently used if we're over capacity
      if (maxSize != null && _cache.length > maxSize!) {
        final lruKey = _accessOrder.removeAt(0);
        _cache.remove(lruKey);
      }
    }
  }

  bool containsKey(K key) => _cache.containsKey(key);

  void remove(K key) {
    _cache.remove(key);
    _accessOrder.remove(key);
  }

  void clear() {
    _cache.clear();
    _accessOrder.clear();
  }

  int get length => _cache.length;

  List<K> get keys => _accessOrder.toList();
}

/// Memoization wrapper for a function with no arguments.
class Memoized0<R> extends MemoizedBase<R> {
  final R Function() _fn;
  late R _value;
  DateTime? _computedAt;
  bool _hasValue = false;

  Memoized0(this._fn, {super.options});

  R call({bool forceRecompute = false}) {
    final ttl = options.ttl;
    final isTimeExpired = ttl != null &&
        _computedAt != null &&
        DateTime.now().difference(_computedAt!) > ttl;

    if (isNotComputedYet ||
        isExpired ||
        forceRecompute ||
        isTimeExpired ||
        !_hasValue) {
      _value = _fn();
      _status = MemoizedStatus.computed;
      _computedAt = DateTime.now();
      _hasValue = true;
    }
    return _value;
  }

  @override
  void clearCache() {
    _status = MemoizedStatus.notComputed;
    _hasValue = false;
    _computedAt = null;
  }

  @override
  int get cacheSize => _hasValue ? 1 : 0;

  @override
  Map<String, dynamic> get cacheStats => {
        'cacheSize': cacheSize,
        'hasValue': _hasValue,
        'computedAt': _computedAt?.toIso8601String(),
        'status': _status.toString(),
      };
}

/// Memoization wrapper for a function with one argument.
class Memoized1<A, R> extends MemoizedBase<R> {
  final R Function(A) _fn;
  final _LRUCache<A, _CacheEntry<R>> _cache;

  Memoized1(this._fn, {super.options})
      : _cache = _LRUCache(maxSize: options.maxSize);

  R call(A a, {bool forceRecompute = false}) {
    final ttl = options.ttl;
    final entry = _cache.get(a);

    final isTimeExpired = ttl != null &&
        entry != null &&
        DateTime.now().difference(entry.timestamp) > ttl;

    if (entry == null || isExpired || forceRecompute || isTimeExpired) {
      final result = _fn(a);
      _cache.put(a, _CacheEntry(result, DateTime.now()));
      _status = MemoizedStatus.computed;
      return result;
    }

    return entry.value;
  }

  @override
  void clearCache() {
    _cache.clear();
    _status = MemoizedStatus.notComputed;
  }

  @override
  int get cacheSize => _cache.length;

  @override
  Map<String, dynamic> get cacheStats => {
        'cacheSize': cacheSize,
        'status': _status.toString(),
      };
}

/// Memoization wrapper for a function with one argument and a custom key generator.
class Memoized1WithKey<A, R> extends MemoizedBase<R> {
  final R Function(A) _fn;
  final String Function(A) _keyFn;
  final _LRUCache<String, _CacheEntry<R>> _cache;

  Memoized1WithKey(this._fn, this._keyFn, {super.options})
      : _cache = _LRUCache(maxSize: options.maxSize);

  R call(A a, {bool forceRecompute = false}) {
    final key = _keyFn(a);
    final ttl = options.ttl;
    final entry = _cache.get(key);

    final isTimeExpired = ttl != null &&
        entry != null &&
        DateTime.now().difference(entry.timestamp) > ttl;

    if (entry == null || isExpired || forceRecompute || isTimeExpired) {
      final result = _fn(a);
      _cache.put(key, _CacheEntry(result, DateTime.now()));
      _status = MemoizedStatus.computed;
      return result;
    }

    return entry.value;
  }

  @override
  void clearCache() {
    _cache.clear();
    _status = MemoizedStatus.notComputed;
  }

  @override
  int get cacheSize => _cache.length;

  @override
  Map<String, dynamic> get cacheStats => {
        'cacheSize': cacheSize,
        'status': _status.toString(),
      };
}

/// Memoization wrapper for a function with two arguments.
class Memoized2<A, B, R> extends MemoizedBase<R> {
  final R Function(A, B) _fn;
  final _LRUCache<String, _CacheEntry<R>> _cache;

  Memoized2(this._fn, {super.options})
      : _cache = _LRUCache(maxSize: options.maxSize);

  R call(A a, B b, {bool forceRecompute = false}) {
    final key = '${a.hashCode}:${b.hashCode}';
    final ttl = options.ttl;
    final entry = _cache.get(key);

    final isTimeExpired = ttl != null &&
        entry != null &&
        DateTime.now().difference(entry.timestamp) > ttl;

    if (entry == null || isExpired || forceRecompute || isTimeExpired) {
      final result = _fn(a, b);
      _cache.put(key, _CacheEntry(result, DateTime.now()));
      _status = MemoizedStatus.computed;
      return result;
    }

    return entry.value;
  }

  @override
  void clearCache() {
    _cache.clear();
    _status = MemoizedStatus.notComputed;
  }

  @override
  int get cacheSize => _cache.length;

  @override
  Map<String, dynamic> get cacheStats => {
        'cacheSize': cacheSize,
        'status': _status.toString(),
      };
}

/// Memoization wrapper for a function with two arguments and a custom key generator.
class Memoized2WithKey<A, B, R> extends MemoizedBase<R> {
  final R Function(A, B) _fn;
  final String Function(A, B) _keyFn;
  final _LRUCache<String, _CacheEntry<R>> _cache;

  Memoized2WithKey(this._fn, this._keyFn, {super.options})
      : _cache = _LRUCache(maxSize: options.maxSize);

  R call(A a, B b, {bool forceRecompute = false}) {
    final key = _keyFn(a, b);
    final ttl = options.ttl;
    final entry = _cache.get(key);

    final isTimeExpired = ttl != null &&
        entry != null &&
        DateTime.now().difference(entry.timestamp) > ttl;

    if (entry == null || isExpired || forceRecompute || isTimeExpired) {
      final result = _fn(a, b);
      _cache.put(key, _CacheEntry(result, DateTime.now()));
      _status = MemoizedStatus.computed;
      return result;
    }

    return entry.value;
  }

  @override
  void clearCache() {
    _cache.clear();
    _status = MemoizedStatus.notComputed;
  }

  @override
  int get cacheSize => _cache.length;

  @override
  Map<String, dynamic> get cacheStats => {
        'cacheSize': cacheSize,
        'status': _status.toString(),
      };
}

/// Memoization wrapper for a function with three arguments.
class Memoized3<A, B, C, R> extends MemoizedBase<R> {
  final R Function(A, B, C) _fn;
  final _LRUCache<String, _CacheEntry<R>> _cache;

  Memoized3(this._fn, {super.options})
      : _cache = _LRUCache(maxSize: options.maxSize);

  R call(A a, B b, C c, {bool forceRecompute = false}) {
    final key = '${a.hashCode}:${b.hashCode}:${c.hashCode}';
    final ttl = options.ttl;
    final entry = _cache.get(key);

    final isTimeExpired = ttl != null &&
        entry != null &&
        DateTime.now().difference(entry.timestamp) > ttl;

    if (entry == null || isExpired || forceRecompute || isTimeExpired) {
      final result = _fn(a, b, c);
      _cache.put(key, _CacheEntry(result, DateTime.now()));
      _status = MemoizedStatus.computed;
      return result;
    }

    return entry.value;
  }

  @override
  void clearCache() {
    _cache.clear();
    _status = MemoizedStatus.notComputed;
  }

  @override
  int get cacheSize => _cache.length;

  @override
  Map<String, dynamic> get cacheStats => {
        'cacheSize': cacheSize,
        'status': _status.toString(),
      };
}

/// Memoization wrapper for a function with four arguments.
class Memoized4<A, B, C, D, R> extends MemoizedBase<R> {
  final R Function(A, B, C, D) _fn;
  final _LRUCache<String, _CacheEntry<R>> _cache;

  Memoized4(this._fn, {super.options})
      : _cache = _LRUCache(maxSize: options.maxSize);

  R call(A a, B b, C c, D d, {bool forceRecompute = false}) {
    final key = '${a.hashCode}:${b.hashCode}:${c.hashCode}:${d.hashCode}';
    final ttl = options.ttl;
    final entry = _cache.get(key);

    final isTimeExpired = ttl != null &&
        entry != null &&
        DateTime.now().difference(entry.timestamp) > ttl;

    if (entry == null || isExpired || forceRecompute || isTimeExpired) {
      final result = _fn(a, b, c, d);
      _cache.put(key, _CacheEntry(result, DateTime.now()));
      _status = MemoizedStatus.computed;
      return result;
    }

    return entry.value;
  }

  @override
  void clearCache() {
    _cache.clear();
    _status = MemoizedStatus.notComputed;
  }

  @override
  int get cacheSize => _cache.length;

  @override
  Map<String, dynamic> get cacheStats => {
        'cacheSize': cacheSize,
        'status': _status.toString(),
      };
}

/// Memoization wrapper for a function with five arguments.
class Memoized5<A, B, C, D, E, R> extends MemoizedBase<R> {
  final R Function(A, B, C, D, E) _fn;
  final _LRUCache<String, _CacheEntry<R>> _cache;

  Memoized5(this._fn, {super.options})
      : _cache = _LRUCache(maxSize: options.maxSize);

  R call(A a, B b, C c, D d, E e, {bool forceRecompute = false}) {
    final key =
        '${a.hashCode}:${b.hashCode}:${c.hashCode}:${d.hashCode}:${e.hashCode}';
    final ttl = options.ttl;
    final entry = _cache.get(key);

    final isTimeExpired = ttl != null &&
        entry != null &&
        DateTime.now().difference(entry.timestamp) > ttl;

    if (entry == null || isExpired || forceRecompute || isTimeExpired) {
      final result = _fn(a, b, c, d, e);
      _cache.put(key, _CacheEntry(result, DateTime.now()));
      _status = MemoizedStatus.computed;
      return result;
    }

    return entry.value;
  }

  @override
  void clearCache() {
    _cache.clear();
    _status = MemoizedStatus.notComputed;
  }

  @override
  int get cacheSize => _cache.length;

  @override
  Map<String, dynamic> get cacheStats => {
        'cacheSize': cacheSize,
        'status': _status.toString(),
      };
}

/// Memoization wrapper for a function with variable arguments.
class MemoizedVarArgs<R> extends MemoizedBase<R> {
  final R Function(List<dynamic>) _fn;
  final _LRUCache<String, _CacheEntry<R>> _cache;

  MemoizedVarArgs(this._fn, {super.options})
      : _cache = _LRUCache(maxSize: options.maxSize);

  R call(List<dynamic> args, {bool forceRecompute = false}) {
    final key = args.map((a) => a.hashCode).join(':');
    final ttl = options.ttl;
    final entry = _cache.get(key);

    final isTimeExpired = ttl != null &&
        entry != null &&
        DateTime.now().difference(entry.timestamp) > ttl;

    if (entry == null || isExpired || forceRecompute || isTimeExpired) {
      final result = _fn(args);
      _cache.put(key, _CacheEntry(result, DateTime.now()));
      _status = MemoizedStatus.computed;
      return result;
    }

    return entry.value;
  }

  @override
  void clearCache() {
    _cache.clear();
    _status = MemoizedStatus.notComputed;
  }

  @override
  int get cacheSize => _cache.length;

  @override
  Map<String, dynamic> get cacheStats => {
        'cacheSize': cacheSize,
        'status': _status.toString(),
      };
}

/// Memoization wrapper for a function with variable arguments and a custom key generator.
class MemoizedVarArgsWithKey<R> extends MemoizedBase<R> {
  final R Function(List<dynamic>) _fn;
  final String Function(List<dynamic>) _keyFn;
  final _LRUCache<String, _CacheEntry<R>> _cache;

  MemoizedVarArgsWithKey(this._fn, this._keyFn, {super.options})
      : _cache = _LRUCache(maxSize: options.maxSize);

  R call(List<dynamic> args, {bool forceRecompute = false}) {
    final key = _keyFn(args);
    final ttl = options.ttl;
    final entry = _cache.get(key);

    final isTimeExpired = ttl != null &&
        entry != null &&
        DateTime.now().difference(entry.timestamp) > ttl;

    if (entry == null || isExpired || forceRecompute || isTimeExpired) {
      final result = _fn(args);
      _cache.put(key, _CacheEntry(result, DateTime.now()));
      _status = MemoizedStatus.computed;
      return result;
    }

    return entry.value;
  }

  @override
  void clearCache() {
    _cache.clear();
    _status = MemoizedStatus.notComputed;
  }

  @override
  int get cacheSize => _cache.length;

  @override
  Map<String, dynamic> get cacheStats => {
        'cacheSize': cacheSize,
        'status': _status.toString(),
      };
}

/// Memoization wrapper for an async function with one argument.
class AsyncMemoized1<A, R> extends MemoizedBase<Future<R>> {
  final Future<R> Function(A) _fn;
  final _LRUCache<A, _CacheEntry<Future<R>>> _cache;

  AsyncMemoized1(this._fn, {super.options})
      : _cache = _LRUCache(maxSize: options.maxSize);

  Future<R> call(A a, {bool forceRecompute = false}) {
    final ttl = options.ttl;
    final entry = _cache.get(a);

    final isTimeExpired = ttl != null &&
        entry != null &&
        DateTime.now().difference(entry.timestamp) > ttl;

    if (entry == null || isExpired || forceRecompute || isTimeExpired) {
      final result = _fn(a);
      _cache.put(a, _CacheEntry(result, DateTime.now()));
      _status = MemoizedStatus.computed;
      return result;
    }

    return entry.value;
  }

  @override
  void clearCache() {
    _cache.clear();
    _status = MemoizedStatus.notComputed;
  }

  @override
  int get cacheSize => _cache.length;

  @override
  Map<String, dynamic> get cacheStats => {
        'cacheSize': cacheSize,
        'status': _status.toString(),
      };
}

/// Memoization wrapper for an async function with two arguments.
class AsyncMemoized2<A, B, R> extends MemoizedBase<Future<R>> {
  final Future<R> Function(A, B) _fn;
  final _LRUCache<String, _CacheEntry<Future<R>>> _cache;

  AsyncMemoized2(this._fn, {super.options})
      : _cache = _LRUCache(maxSize: options.maxSize);

  Future<R> call(A a, B b, {bool forceRecompute = false}) {
    final key = '${a.hashCode}:${b.hashCode}';
    final ttl = options.ttl;
    final entry = _cache.get(key);

    final isTimeExpired = ttl != null &&
        entry != null &&
        DateTime.now().difference(entry.timestamp) > ttl;

    if (entry == null || isExpired || forceRecompute || isTimeExpired) {
      final result = _fn(a, b);
      _cache.put(key, _CacheEntry(result, DateTime.now()));
      _status = MemoizedStatus.computed;
      return result;
    }

    return entry.value;
  }

  @override
  void clearCache() {
    _cache.clear();
    _status = MemoizedStatus.notComputed;
  }

  @override
  int get cacheSize => _cache.length;

  @override
  Map<String, dynamic> get cacheStats => {
        'cacheSize': cacheSize,
        'status': _status.toString(),
      };
}

/// Cache entry with timestamp for TTL support
class _CacheEntry<T> {
  final T value;
  final DateTime timestamp;

  _CacheEntry(this.value, this.timestamp);
}

/// Extension methods for memoizing functions with different arities.
extension MemoizeFunction0Ext<R> on R Function() {
  /// Creates a memoized version of this function.
  ///
  /// Example:
  /// ```dart
  /// final sum = (() => 1.to(999999999).sum()).memoize();
  /// print(sum());  // Computes the sum
  /// print(sum());  // Returns the cached sum
  /// ```
  Memoized0<R> memoize({MemoizeOptions options = MemoizeOptions.unlimited}) =>
      Memoized0(this, options: options);

  /// Shorthand for memoize() - creates a memoized version of this function.
  Memoized0<R> get memo => memoize();
}

extension MemoizeFunction1Ext<A, R> on R Function(A) {
  /// Creates a memoized version of this function.
  ///
  /// Example:
  /// ```dart
  /// final fibonacci = ((int n) {
  ///   if (n <= 1) return n;
  ///   return fibonacci(n-1) + fibonacci(n-2);
  /// }).memoize();
  /// print(fibonacci(40));  // Fast even for large values
  /// ```
  Memoized1<A, R> memoize(
          {MemoizeOptions options = MemoizeOptions.unlimited}) =>
      Memoized1(this, options: options);

  /// Creates a memoized version of this function with a custom key generator.
  ///
  /// Example:
  /// ```dart
  /// final processUser = ((User user) => expensiveOperation(user))
  ///     .memoizeWithKey((user) => user.id.toString());
  /// ```
  Memoized1WithKey<A, R> memoizeWithKey(String Function(A) keyFn,
          {MemoizeOptions options = MemoizeOptions.unlimited}) =>
      Memoized1WithKey(this, keyFn, options: options);

  /// Shorthand for memoize() - creates a memoized version of this function.
  Memoized1<A, R> get memo => memoize();
}

extension MemoizeFunction2Ext<A, B, R> on R Function(A, B) {
  /// Creates a memoized version of this function.
  Memoized2<A, B, R> memoize(
          {MemoizeOptions options = MemoizeOptions.unlimited}) =>
      Memoized2(this, options: options);

  /// Creates a memoized version of this function with a custom key generator.
  Memoized2WithKey<A, B, R> memoizeWithKey(String Function(A, B) keyFn,
          {MemoizeOptions options = MemoizeOptions.unlimited}) =>
      Memoized2WithKey(this, keyFn, options: options);

  /// Shorthand for memoize() - creates a memoized version of this function.
  Memoized2<A, B, R> get memo => memoize();
}

extension MemoizeFunction3Ext<A, B, C, R> on R Function(A, B, C) {
  /// Creates a memoized version of this function.
  Memoized3<A, B, C, R> memoize(
          {MemoizeOptions options = MemoizeOptions.unlimited}) =>
      Memoized3(this, options: options);

  /// Shorthand for memoize() - creates a memoized version of this function.
  Memoized3<A, B, C, R> get memo => memoize();
}

extension MemoizeFunction4Ext<A, B, C, D, R> on R Function(A, B, C, D) {
  /// Creates a memoized version of this function.
  Memoized4<A, B, C, D, R> memoize(
          {MemoizeOptions options = MemoizeOptions.unlimited}) =>
      Memoized4(this, options: options);

  /// Shorthand for memoize() - creates a memoized version of this function.
  Memoized4<A, B, C, D, R> get memo => memoize();
}

extension MemoizeFunction5Ext<A, B, C, D, E, R> on R Function(A, B, C, D, E) {
  /// Creates a memoized version of this function.
  Memoized5<A, B, C, D, E, R> memoize(
          {MemoizeOptions options = MemoizeOptions.unlimited}) =>
      Memoized5(this, options: options);

  /// Shorthand for memoize() - creates a memoized version of this function.
  Memoized5<A, B, C, D, E, R> get memo => memoize();
}

extension MemoizeAsyncFunction1Ext<A, R> on Future<R> Function(A) {
  /// Creates a memoized version of this async function.
  AsyncMemoized1<A, R> memoize(
          {MemoizeOptions options = MemoizeOptions.unlimited}) =>
      AsyncMemoized1(this, options: options);

  /// Shorthand for memoize() - creates a memoized version of this async function.
  AsyncMemoized1<A, R> get memo => memoize();
}

extension MemoizeAsyncFunction2Ext<A, B, R> on Future<R> Function(A, B) {
  /// Creates a memoized version of this async function.
  AsyncMemoized2<A, B, R> memoize(
          {MemoizeOptions options = MemoizeOptions.unlimited}) =>
      AsyncMemoized2(this, options: options);

  /// Shorthand for memoize() - creates a memoized version of this async function.
  AsyncMemoized2<A, B, R> get memo => memoize();
}

/// Extension methods for recursive memoization
extension RecursiveMemoizeExt<A, R> on R Function(A) {
  /// Creates a recursively memoized function.
  ///
  /// This is particularly useful for recursive functions like Fibonacci.
  ///
  /// Example:
  /// ```dart
  /// late final Memoized1<int, int> fib;
  /// fib = ((int n) {
  ///   if (n <= 1) return n;
  ///   return fib(n-1) + fib(n-2);
  /// }).memoizeRecursive();
  /// print(fib(100));  // Very fast even for large values
  /// ```
  Memoized1<A, R> memoizeRecursive(
      {MemoizeOptions options = MemoizeOptions.unlimited}) {
    late Memoized1<A, R> memoized;
    R wrappedFn(A a) => this(a);
    memoized = Memoized1(wrappedFn, options: options);
    return memoized;
  }

  /// Shorthand for memoize() - creates a memoized version of this async function.
  Memoized1<A, R> get memo => memoize();
}
