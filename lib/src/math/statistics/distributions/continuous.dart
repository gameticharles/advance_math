import 'dart:math' as math;
import 'base.dart';

/// Normal (Gaussian) distribution.
class NormalDistribution extends ProbabilityDistribution {
  final num mu;
  final num sigma;

  NormalDistribution(this.mu, this.sigma) {
    if (sigma <= 0) throw ArgumentError('sigma must be positive');
  }

  @override
  num pdf(num x) {
    num z = (x - mu) / sigma;
    return (1 / (sigma * math.sqrt(2 * math.pi))) * math.exp(-0.5 * z * z);
  }

  @override
  num cdf(num x) {
    num z = (x - mu) / sigma;
    return 0.5 * (1 + _erf(z / math.sqrt(2)));
  }

  @override
  num quantile(num p) {
    if (p < 0 || p > 1) throw ArgumentError('p must be in [0, 1]');
    // Approximation using inverse error function
    return mu + sigma * math.sqrt(2) * _erfInv(2 * p - 1);
  }

  @override
  num mean() => mu;

  @override
  num variance() => sigma * sigma;

  @override
  num sample() {
    // Box-Muller transform
    num u1 = math.Random().nextDouble();
    num u2 = math.Random().nextDouble();
    num z = math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2);
    return mu + sigma * z;
  }

  /// Error function approximation.
  num _erf(num x) {
    // Abramowitz and Stegun approximation
    num t = 1 / (1 + 0.5 * x.abs());
    num tau = t *
        math.exp(-x * x -
            1.26551223 +
            t *
                (1.00002368 +
                    t *
                        (0.37409196 +
                            t *
                                (0.09678418 +
                                    t *
                                        (-0.18628806 +
                                            t *
                                                (0.27886807 +
                                                    t *
                                                        (-1.13520398 +
                                                            t *
                                                                (1.48851587 +
                                                                    t *
                                                                        (-0.82215223 +
                                                                            t * 0.17087277)))))))));
    return x >= 0 ? 1 - tau : tau - 1;
  }

  /// Inverse error function approximation.
  num _erfInv(num x) {
    if (x.abs() >= 1) return x.sign * double.infinity;

    num a = 0.147;
    num b = 2 / (math.pi * a) + math.log(1 - x * x) / 2;
    num c = math.log(1 - x * x) / a;

    num result = x.sign * math.sqrt(math.sqrt(b * b - c) - b);
    return result;
  }
}

/// Uniform continuous distribution.
class UniformDistribution extends ProbabilityDistribution {
  final num a;
  final num b;

  UniformDistribution(this.a, this.b) {
    if (a >= b) throw ArgumentError('a must be less than b');
  }

  @override
  num pdf(num x) => (x >= a && x <= b) ? 1 / (b - a) : 0;

  @override
  num cdf(num x) {
    if (x < a) return 0;
    if (x > b) return 1;
    return (x - a) / (b - a);
  }

  @override
  num quantile(num p) {
    if (p < 0 || p > 1) throw ArgumentError('p must be in [0, 1]');
    return a + p * (b - a);
  }

  @override
  num mean() => (a + b) / 2;

  @override
  num variance() => ((b - a) * (b - a)) / 12;

  @override
  num sample() => a + math.Random().nextDouble() * (b - a);
}

/// Exponential distribution.
class ExponentialDistribution extends ProbabilityDistribution {
  final num lambda;

  ExponentialDistribution(this.lambda) {
    if (lambda <= 0) throw ArgumentError('lambda must be positive');
  }

  @override
  num pdf(num x) => x >= 0 ? lambda * math.exp(-lambda * x) : 0;

  @override
  num cdf(num x) => x >= 0 ? 1 - math.exp(-lambda * x) : 0;

  @override
  num quantile(num p) {
    if (p < 0 || p > 1) throw ArgumentError('p must be in [0, 1]');
    return -math.log(1 - p) / lambda;
  }

  @override
  num mean() => 1 / lambda;

  @override
  num variance() => 1 / (lambda * lambda);

  @override
  num sample() => -math.log(1 - math.Random().nextDouble()) / lambda;
}

/// Gamma distribution.
class GammaDistribution extends ProbabilityDistribution {
  final num shape; // k or α
  final num scale; // θ

  GammaDistribution(this.shape, this.scale) {
    if (shape <= 0 || scale <= 0) {
      throw ArgumentError('shape and scale must be positive');
    }
  }

  @override
  num pdf(num x) {
    if (x <= 0) return 0;
    return (math.pow(x, shape - 1) * math.exp(-x / scale)) /
        (math.pow(scale, shape) * _gamma(shape));
  }

  @override
  num cdf(num x) {
    if (x <= 0) return 0;
    // Using lower incomplete gamma function
    return _lowerIncompleteGamma(shape, x / scale) / _gamma(shape);
  }

  @override
  num quantile(num p) {
    // Numerical approximation
    if (p <= 0) return 0;
    if (p >= 1) return double.infinity;

    // Newton's method
    num x = mean(); // Initial guess
    for (int i = 0; i < 20; i++) {
      num fx = cdf(x) - p;
      num fpx = pdf(x);
      if (fpx.abs() < 1e-10) break;
      num xNew = x - fx / fpx;
      if ((xNew - x).abs() < 1e-6) break;
      x = xNew > 0 ? xNew : x / 2;
    }
    return x;
  }

  @override
  num mean() => shape * scale;

  @override
  num variance() => shape * scale * scale;

  @override
  num sample() {
    // Marsaglia and Tsang method for shape >= 1
    if (shape >= 1) {
      num d = shape - 1.0 / 3.0;
      num c = 1.0 / math.sqrt(9.0 * d);
      var random = math.Random();

      while (true) {
        num x, v;
        do {
          x = NormalDistribution(0, 1).sample();
          v = 1.0 + c * x;
        } while (v <= 0);

        v = v * v * v;
        num u = random.nextDouble();

        if (u < 1 - 0.0331 * x * x * x * x) {
          return d * v * scale;
        }

        if (math.log(u) < 0.5 * x * x + d * (1 - v + math.log(v))) {
          return d * v * scale;
        }
      }
    } else {
      // For shape < 1, use Johnk's method
      return GammaDistribution(shape + 1, scale).sample() *
          math.pow(math.Random().nextDouble(), 1 / shape);
    }
  }

  num _gamma(num z) {
    return math.exp(_logGamma(z));
  }

  num _logGamma(num z) {
    const List<double> coef = [
      76.18009172947146,
      -86.50532032941677,
      24.01409824083091,
      -1.231739572450155,
      0.1208650973866179e-2,
      -0.5395239384953e-5,
    ];

    num x = z;
    num tmp = x + 5.5;
    tmp -= (x + 0.5) * math.log(tmp);
    num ser = 1.000000000190015;

    for (int j = 0; j < 6; j++) {
      ser += coef[j] / (x + j + 1);
    }

    return -tmp + math.log(2.5066282746310005 * ser / x);
  }

  num _lowerIncompleteGamma(num a, num x) {
    if (x <= 0) return 0;

    num sum = 1 / a;
    num term = 1 / a;

    for (int n = 1; n < 100; n++) {
      term *= x / (a + n);
      sum += term;
      if (term.abs() < 1e-10) break;
    }

    return sum * math.exp(-x + a * math.log(x) - _logGamma(a));
  }
}

/// Chi-squared distribution.
class ChiSquaredDistribution extends ProbabilityDistribution {
  final int degreesOfFreedom;

  ChiSquaredDistribution(this.degreesOfFreedom) {
    if (degreesOfFreedom <= 0) {
      throw ArgumentError('degrees of freedom must be positive');
    }
  }

  @override
  num pdf(num x) {
    if (x <= 0) return 0;
    GammaDistribution gamma = GammaDistribution(degreesOfFreedom / 2, 2);
    return gamma.pdf(x);
  }

  @override
  num cdf(num x) {
    if (x <= 0) return 0;
    GammaDistribution gamma = GammaDistribution(degreesOfFreedom / 2, 2);
    return gamma.cdf(x);
  }

  @override
  num quantile(num p) {
    GammaDistribution gamma = GammaDistribution(degreesOfFreedom / 2, 2);
    return gamma.quantile(p);
  }

  @override
  num mean() => degreesOfFreedom;

  @override
  num variance() => 2 * degreesOfFreedom;

  @override
  num sample() {
    GammaDistribution gamma = GammaDistribution(degreesOfFreedom / 2, 2);
    return gamma.sample();
  }
}

/// Student's t-distribution.
class StudentTDistribution extends ProbabilityDistribution {
  final int degreesOfFreedom;

  StudentTDistribution(this.degreesOfFreedom) {
    if (degreesOfFreedom <= 0) {
      throw ArgumentError('degrees of freedom must be positive');
    }
  }

  @override
  num pdf(num x) {
    num n = degreesOfFreedom;
    num coef = math.exp(_logGamma((n + 1) / 2) - _logGamma(n / 2)) /
        math.sqrt(n * math.pi);
    return coef * math.pow(1 + x * x / n, -(n + 1) / 2);
  }

  @override
  num cdf(num x) {
    // Approximation for large df
    if (degreesOfFreedom > 30) {
      return NormalDistribution(0, 1).cdf(x);
    }

    num n = degreesOfFreedom;
    num t = x;
    num a = (t + math.sqrt(t * t + n)) / (2 * math.sqrt(t * t + n));

    return _incompleteBeta(n / 2, n / 2, a);
  }

  @override
  num quantile(num p) {
    // Approximation using normal for large df
    if (degreesOfFreedom > 30) {
      return NormalDistribution(0, 1).quantile(p);
    }

    // Numerical approximation
    num low = -10, high = 10;
    for (int i = 0; i < 50; i++) {
      num mid = (low + high) / 2;
      if (cdf(mid) < p) {
        low = mid;
      } else {
        high = mid;
      }
      if ((high - low).abs() < 1e-6) break;
    }
    return (low + high) / 2;
  }

  @override
  num mean() => degreesOfFreedom > 1 ? 0 : double.nan;

  @override
  num variance() {
    if (degreesOfFreedom > 2) {
      return degreesOfFreedom / (degreesOfFreedom - 2);
    }
    return double.nan;
  }

  @override
  num sample() {
    // t = Z / sqrt(V/n) where Z ~ N(0,1) and V ~ Chi²(n)
    num z = NormalDistribution(0, 1).sample();
    num v = ChiSquaredDistribution(degreesOfFreedom).sample();
    return z / math.sqrt(v / degreesOfFreedom);
  }

  num _logGamma(num z) {
    const List<double> coef = [
      76.18009172947146,
      -86.50532032941677,
      24.01409824083091,
      -1.231739572450155,
      0.1208650973866179e-2,
      -0.5395239384953e-5,
    ];

    num x = z;
    num tmp = x + 5.5;
    tmp -= (x + 0.5) * math.log(tmp);
    num ser = 1.000000000190015;

    for (int j = 0; j < 6; j++) {
      ser += coef[j] / (x + j + 1);
    }

    return -tmp + math.log(2.5066282746310005 * ser / x);
  }

  num _incompleteBeta(num a, num b, num x) {
    if (x <= 0) return 0;
    if (x >= 1) return 1;

    num bt = math.exp(_logGamma(a + b) -
        _logGamma(a) -
        _logGamma(b) +
        a * math.log(x) +
        b * math.log(1 - x));

    if (x < (a + 1) / (a + b + 2)) {
      return bt * _betaCF(a, b, x) / a;
    } else {
      return 1 - bt * _betaCF(b, a, 1 - x) / b;
    }
  }

  num _betaCF(num a, num b, num x) {
    const int maxIter = 100;
    const double eps = 1e-10;

    num qab = a + b;
    num qap = a + 1;
    num qam = a - 1;
    num c = 1.0;
    num d = 1 - qab * x / qap;

    if (d.abs() < eps) d = eps;
    d = 1 / d;
    num h = d;

    for (int m = 1; m <= maxIter; m++) {
      num m2 = 2 * m;
      num aa = m * (b - m) * x / ((qam + m2) * (a + m2));
      d = 1 + aa * d;
      if (d.abs() < eps) d = eps;
      c = 1 + aa / c;
      if (c.abs() < eps) c = eps;
      d = 1 / d;
      h *= d * c;

      aa = -(a + m) * (qab + m) * x / ((a + m2) * (qap + m2));
      d = 1 + aa * d;
      if (d.abs() < eps) d = eps;
      c = 1 + aa / c;
      if (c.abs() < eps) c = eps;
      d = 1 / d;
      num del = d * c;
      h *= del;

      if ((del - 1).abs() < eps) break;
    }

    return h;
  }
}

/// Log-normal distribution.
class LogNormalDistribution extends ProbabilityDistribution {
  final num mu;
  final num sigma;

  LogNormalDistribution(this.mu, this.sigma) {
    if (sigma <= 0) throw ArgumentError('sigma must be positive');
  }

  @override
  num pdf(num x) {
    if (x <= 0) return 0;
    num z = (math.log(x) - mu) / sigma;
    return (1 / (x * sigma * math.sqrt(2 * math.pi))) * math.exp(-0.5 * z * z);
  }

  @override
  num cdf(num x) {
    if (x <= 0) return 0;
    return NormalDistribution(mu, sigma).cdf(math.log(x));
  }

  @override
  num quantile(num p) {
    num z = NormalDistribution(mu, sigma).quantile(p);
    return math.exp(z);
  }

  @override
  num mean() => math.exp(mu + sigma * sigma / 2);

  @override
  num variance() {
    num exp2sigma2 = math.exp(sigma * sigma);
    return (exp2sigma2 - 1) * math.exp(2 * mu + sigma * sigma);
  }

  @override
  num sample() => math.exp(NormalDistribution(mu, sigma).sample());
}
