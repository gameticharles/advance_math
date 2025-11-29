import 'dart:math' as math;
import 'base.dart';

/// Binomial distribution.
class BinomialDistribution extends ProbabilityDistribution {
  final int n;
  final num p;

  BinomialDistribution(this.n, this.p) {
    if (n < 0) throw ArgumentError('n must be non-negative');
    if (p < 0 || p > 1) throw ArgumentError('p must be in [0, 1]');
  }

  @override
  num pdf(num k) {
    if (k < 0 || k > n || k != k.floor()) return 0;
    return _binomialCoefficient(n, k.toInt()) *
        math.pow(p, k) *
        math.pow(1 - p, n - k);
  }

  @override
  num cdf(num k) {
    if (k < 0) return 0;
    if (k >= n) return 1;

    num sum = 0;
    for (int i = 0; i <= k.floor(); i++) {
      sum += pdf(i);
    }
    return sum;
  }

  @override
  num quantile(num prob) {
    if (prob < 0 || prob > 1) throw ArgumentError('prob must be in [0, 1]');

    num cumulative = 0;
    for (int k = 0; k <= n; k++) {
      cumulative += pdf(k);
      if (cumulative >= prob) return k;
    }
    return n;
  }

  @override
  num mean() => n * p;

  @override
  num variance() => n * p * (1 - p);

  @override
  num sample() {
    // Sum of Bernoulli trials
    int count = 0;
    var random = math.Random();
    for (int i = 0; i < n; i++) {
      if (random.nextDouble() < p) count++;
    }
    return count;
  }

  num _binomialCoefficient(int n, int k) {
    if (k > n) return 0;
    if (k == 0 || k == n) return 1;

    k = math.min(k, n - k); // Optimization
    num result = 1;
    for (int i = 0; i < k; i++) {
      result *= (n - i);
      result /= (i + 1);
    }
    return result;
  }
}

/// Poisson distribution.
class PoissonDistribution extends ProbabilityDistribution {
  final num lambda;

  PoissonDistribution(this.lambda) {
    if (lambda <= 0) throw ArgumentError('lambda must be positive');
  }

  @override
  num pdf(num k) {
    if (k < 0 || k != k.floor()) return 0;
    return math.exp(-lambda) * math.pow(lambda, k) / _factorial(k.toInt());
  }

  @override
  num cdf(num k) {
    if (k < 0) return 0;

    num sum = 0;
    for (int i = 0; i <= k.floor(); i++) {
      sum += pdf(i);
    }
    return sum;
  }

  @override
  num quantile(num p) {
    if (p < 0 || p > 1) throw ArgumentError('p must be in [0, 1]');

    num cumulative = 0;
    int k = 0;
    while (cumulative < p) {
      cumulative += pdf(k);
      k++;
    }
    return k - 1;
  }

  @override
  num mean() => lambda;

  @override
  num variance() => lambda;

  @override
  num sample() {
    // Knuth's algorithm
    num L = math.exp(-lambda);
    int k = 0;
    num p = 1.0;
    var random = math.Random();

    do {
      k++;
      p *= random.nextDouble();
    } while (p > L);

    return k - 1;
  }

  num _factorial(int n) {
    if (n <= 1) return 1;
    num result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }
}

/// Geometric distribution (number of trials until first success).
class GeometricDistribution extends ProbabilityDistribution {
  final num p;

  GeometricDistribution(this.p) {
    if (p <= 0 || p > 1) throw ArgumentError('p must be in (0, 1]');
  }

  @override
  num pdf(num k) {
    if (k < 1 || k != k.floor()) return 0;
    return math.pow(1 - p, k - 1) * p;
  }

  @override
  num cdf(num k) {
    if (k < 1) return 0;
    return 1 - math.pow(1 - p, k.floor());
  }

  @override
  num quantile(num prob) {
    if (prob < 0 || prob > 1) throw ArgumentError('prob must be in [0, 1]');
    if (prob == 0) return 1;
    return (math.log(1 - prob) / math.log(1 - p)).ceil();
  }

  @override
  num mean() => 1 / p;

  @override
  num variance() => (1 - p) / (p * p);

  @override
  num sample() {
    // Count trials until success
    int trials = 0;
    var random = math.Random();
    do {
      trials++;
    } while (random.nextDouble() >= p);
    return trials;
  }
}

/// Negative binomial distribution (number of trials until r successes).
class NegativeBinomialDistribution extends ProbabilityDistribution {
  final int r; // Number of successes
  final num p; // Success probability

  NegativeBinomialDistribution(this.r, this.p) {
    if (r <= 0) throw ArgumentError('r must be positive');
    if (p <= 0 || p > 1) throw ArgumentError('p must be in (0, 1]');
  }

  @override
  num pdf(num k) {
    if (k < 0 || k != k.floor()) return 0;
    int kInt = k.toInt();
    return _binomialCoefficient(kInt + r - 1, kInt) *
        math.pow(p, r) *
        math.pow(1 - p, kInt);
  }

  @override
  num cdf(num k) {
    if (k < 0) return 0;

    num sum = 0;
    for (int i = 0; i <= k.floor(); i++) {
      sum += pdf(i);
    }
    return sum;
  }

  @override
  num quantile(num prob) {
    if (prob < 0 || prob > 1) throw ArgumentError('prob must be in [0, 1]');

    num cumulative = 0;
    int k = 0;
    while (cumulative < prob) {
      cumulative += pdf(k);
      k++;
      if (k > 10000) break; // Safety limit
    }
    return k - 1;
  }

  @override
  num mean() => r * (1 - p) / p;

  @override
  num variance() => r * (1 - p) / (p * p);

  @override
  num sample() {
    // Sum of r geometric random variables
    int total = 0;
    for (int i = 0; i < r; i++) {
      total += GeometricDistribution(p).sample().toInt() - 1;
    }
    return total;
  }

  num _binomialCoefficient(int n, int k) {
    if (k > n) return 0;
    if (k == 0 || k == n) return 1;

    k = math.min(k, n - k);
    num result = 1;
    for (int i = 0; i < k; i++) {
      result *= (n - i);
      result /= (i + 1);
    }
    return result;
  }
}
