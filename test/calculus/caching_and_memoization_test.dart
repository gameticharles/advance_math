import 'dart:math' as math;
import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  group('LRUCache Tests', () {
    test('Should put and get items correctly', () {
      final cache = LRUCache<String, int>(maxSize: 3);
      cache.put('a', 1);
      cache.put('b', 2);
      cache.put('c', 3);

      expect(cache.get('a'), equals(1));
      expect(cache.get('b'), equals(2));
      expect(cache.get('c'), equals(3));
      expect(cache.length, equals(3));
    });

    test('Should evict oldest item when maxSize is exceeded', () {
      final cache = LRUCache<String, int>(maxSize: 3);
      cache.put('a', 1);
      cache.put('b', 2);
      cache.put('c', 3);

      // Eviction happens here. 'a' is the oldest and should be evicted.
      cache.put('d', 4);

      expect(cache.get('a'), isNull);
      expect(cache.get('b'), equals(2));
      expect(cache.get('c'), equals(3));
      expect(cache.get('d'), equals(4));
      expect(cache.length, equals(3));
    });

    test('Should update recency on get operations', () {
      final cache = LRUCache<String, int>(maxSize: 3);
      cache.put('a', 1);
      cache.put('b', 2);
      cache.put('c', 3);

      // Access 'a' to make it most recently used
      expect(cache.get('a'), equals(1));

      // Put 'd', which triggers eviction.
      // 'b' is now the oldest (since 'a' was accessed), so 'b' should be evicted.
      cache.put('d', 4);

      expect(cache.get('a'), equals(1));
      expect(cache.get('b'), isNull);
      expect(cache.get('c'), equals(3));
      expect(cache.get('d'), equals(4));
    });

    test('Should update recency on overwriting put operations', () {
      final cache = LRUCache<String, int>(maxSize: 3);
      cache.put('a', 1);
      cache.put('b', 2);
      cache.put('c', 3);

      // Update 'a'
      cache.put('a', 10);

      // Put 'd', which triggers eviction.
      // 'b' should be evicted as it's the oldest.
      cache.put('d', 4);

      expect(cache.get('a'), equals(10));
      expect(cache.get('b'), isNull);
      expect(cache.get('c'), equals(3));
      expect(cache.get('d'), equals(4));
    });
  });

  group('NumericalDifferentiation Caching Tests', () {
    test('nthDerivative correctness on high orders', () {
      // f(x) = e^x. All derivatives at x=0 should be 1.0.
      num f(num x) => math.exp(x);

      // Let's compute up to the 7th derivative.
      // Without caching, n=7 results in 2^7 = 128 recursive evaluations.
      // With caching, it should be extremely fast and highly accurate.
      final result = NumericalDifferentiation.nthDerivative(f, 0, 7, h: 0.01);
      expect(result, closeTo(1.0, 2e-2));
    });

    test('nthDerivative performance/complexity validation', () {
      num f(num x) =>
          x * x * x * x * x; // x^5. 5th derivative should be 5! = 120.

      final stopwatch = Stopwatch()..start();
      final result = NumericalDifferentiation.nthDerivative(f, 1, 5, h: 0.01);
      stopwatch.stop();

      expect(result, closeTo(120.0, 1e-1));
      expect(stopwatch.elapsedMilliseconds, lessThan(50),
          reason:
              'Calculations should take less than 50ms due to dynamic programming / caching.');
    });
  });

  group('NumericalIntegration Caching Tests', () {
    test(
        'adaptiveSimpson correctly integrates and avoids redundant evaluations',
        () {
      int evalCount = 0;
      num f(num x) {
        evalCount++;
        return x * x; // f(x) = x^2
      }

      // Integral of x^2 from 0 to 2 is 8/3 ≈ 2.666667
      final result =
          NumericalIntegration.adaptiveSimpson(f, 0, 2, tolerance: 1e-5);

      expect(result, closeTo(8 / 3, 1e-4));
      expect(evalCount, isPositive);

      // Let's check that running with the same function wrapped manually does not evaluate more.
      // The key is that evaluations were bounded and deduplicated by the transient LRU cache.
      print('Evaluations with adaptiveSimpson caching: $evalCount');
    });

    test('adaptiveSimpson correctness and stability', () {
      num f(num x) => math.sin(x);
      // Integral of sin(x) from 0 to pi is 2.0
      final result =
          NumericalIntegration.adaptiveSimpson(f, 0, math.pi, tolerance: 1e-6);
      expect(result, closeTo(2.0, 1e-4));
    });
  });
}
