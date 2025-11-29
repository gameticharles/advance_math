import 'package:advance_math/src/math/statistics/distributions/continuous.dart';
import 'package:advance_math/src/math/statistics/distributions/discrete.dart';
import 'package:test/test.dart';
import 'dart:math' as math;

void main() {
  group('Continuous Distributions', () {
    test('Normal distribution properties', () {
      var dist = NormalDistribution(0, 1); // Standard normal

      expect(dist.mean(), equals(0));
      expect(dist.variance(), equals(1));
      expect(dist.stdDev(), closeTo(1, 1e-10));

      // PDF at mean should be maximum
      expect(dist.pdf(0), closeTo(1 / math.sqrt(2 * math.pi), 1e-10));

      // CDF at mean should be 0.5
      expect(dist.cdf(0), closeTo(0.5, 0.01));

      // Quantile at 0.5 should be mean
      expect(dist.quantile(0.5), closeTo(0, 0.01));
    });

    test('Normal distribution sampling', () {
      var dist = NormalDistribution(10, 2);
      var samples = dist.samples(1000);

      num sampleMean = samples.reduce((a, b) => a + b) / samples.length;
      expect(sampleMean, closeTo(10, 0.5));
    });

    test('Uniform distribution', () {
      var dist = UniformDistribution(0, 10);

      expect(dist.mean(), equals(5));
      expect(dist.variance(), closeTo(100 / 12, 1e-10));

      expect(dist.pdf(5), equals(0.1));
      expect(dist.pdf(-1), equals(0));
      expect(dist.pdf(11), equals(0));

      expect(dist.cdf(5), equals(0.5));
      expect(dist.quantile(0.5), equals(5));
    });

    test('Exponential distribution', () {
      var dist = ExponentialDistribution(2);

      expect(dist.mean(), equals(0.5));
      expect(dist.variance(), equals(0.25));

      expect(dist.pdf(0), equals(2));
      expect(dist.cdf(0), equals(0));

      // CDF should approach 1
      expect(dist.cdf(10), closeTo(1, 1e-8));
    });
  });

  group('Discrete Distributions', () {
    test('Binomial distribution', () {
      var dist = BinomialDistribution(10, 0.5);

      expect(dist.mean(), equals(5));
      expect(dist.variance(), equals(2.5));

      // PDF at mode (mean for symmetric distribution)
      expect(dist.pdf(5), greaterThan(dist.pdf(0)));
      expect(dist.pdf(5), greaterThan(dist.pdf(10)));

      // CDF should be 1 at n
      expect(dist.cdf(10), equals(1));
    });

    test('Binomial distribution sampling', () {
      var dist = BinomialDistribution(100, 0.3);
      var samples = dist.samples(1000);

      num sampleMean = samples.reduce((a, b) => a + b) / samples.length;
      expect(sampleMean, closeTo(30, 3)); // Mean = n*p = 30
    });

    test('Poisson distribution', () {
      var dist = PoissonDistribution(5);

      expect(dist.mean(), equals(5));
      expect(dist.variance(), equals(5));

      // PDF at 0
      expect(dist.pdf(0), closeTo(math.exp(-5), 1e-10));

      // PDF is 0 for negative values
      expect(dist.pdf(-1), equals(0));
    });

    test('Poisson distribution sampling', () {
      var dist = PoissonDistribution(10);
      var samples = dist.samples(1000);

      num sampleMean = samples.reduce((a, b) => a + b) / samples.length;
      expect(sampleMean, closeTo(10, 1));
    });

    test('Gamma distribution', () {
      var dist = GammaDistribution(2, 2); // shape=2, scale=2

      expect(dist.mean(), equals(4)); // shape * scale
      expect(dist.variance(), equals(8)); // shape * scale²

      var samples = dist.samples(1000);
      num sampleMean = samples.reduce((a, b) => a + b) / samples.length;
      expect(sampleMean, closeTo(4, 0.5));
    });

    test('Chi-squared distribution', () {
      var dist = ChiSquaredDistribution(5);

      expect(dist.mean(), equals(5));
      expect(dist.variance(), equals(10));
    });

    test('Student T distribution', () {
      var dist = StudentTDistribution(10);

      expect(dist.mean(), equals(0));
      expect(dist.variance(), closeTo(10 / 8, 0.01));
    });

    test('Log-normal distribution', () {
      var dist = LogNormalDistribution(0, 1);

      // LogNormal(0,1) has mean = exp(0.5)
      expect(dist.mean(), closeTo(math.exp(0.5), 0.01));

      var samples = dist.samples(1000);
      // All samples should be positive
      expect(samples.every((s) => s > 0), isTrue);
    });
  });

  group('Additional Discrete Distributions', () {
    test('Geometric distribution', () {
      var dist = GeometricDistribution(0.5);

      expect(dist.mean(), equals(2)); // 1/p
      expect(dist.variance(), equals(2)); // (1-p)/p²

      // First trial (k=1) should have highest probability
      expect(dist.pdf(1), equals(0.5));
      expect(dist.pdf(2), equals(0.25));
    });

    test('Negative binomial distribution', () {
      var dist = NegativeBinomialDistribution(3, 0.5);

      expect(dist.mean(), equals(3)); // r(1-p)/p = 3*0.5/0.5

      var samples = dist.samples(500);
      num sampleMean = samples.reduce((a, b) => a + b) / samples.length;
      expect(sampleMean, closeTo(3, 1));
    });
  });
}
