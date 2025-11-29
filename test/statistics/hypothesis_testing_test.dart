import 'package:advance_math/src/math/statistics/hypothesis_testing.dart';
import 'package:test/test.dart';

void main() {
  group('Hypothesis Testing', () {
    test('Two-sample t-test detects difference in means', () {
      // Sample 1: mean ≈ 5
      List<num> sample1 = [4.5, 5.0, 5.5, 4.8, 5.2, 4.9, 5.1];
      // Sample 2: mean ≈ 7
      List<num> sample2 = [6.8, 7.2, 7.0, 6.9, 7.1, 7.3, 6.7];

      var result = HypothesisTesting.tTest(sample1, sample2);

      expect(result.testName, equals('Two-sample t-test'));
      expect(result.pValue, lessThan(0.05)); // Should detect difference
      expect(result.reject, isTrue);
      expect(result.statistic.abs(), greaterThan(2)); // Large t-statistic
    });

    test('Two-sample t-test does not reject for similar samples', () {
      List<num> sample1 = [5.0, 5.1, 4.9, 5.0, 5.1];
      List<num> sample2 = [5.0, 5.2, 4.8, 5.1, 4.9];

      var result = HypothesisTesting.tTest(sample1, sample2);

      expect(result.reject, isFalse);
      expect(result.pValue, greaterThan(0.05));
    });

    test('One-sample t-test', () {
      // Sample with mean ≈ 5, test against mu0 = 10
      List<num> sample = [4.5, 5.0, 5.5, 4.8, 5.2, 4.9, 5.1, 5.0];

      var result = HypothesisTesting.tTestOneSample(sample, 10);

      expect(result.testName, equals('One-sample t-test'));
      expect(result.reject, isTrue); // Should reject mu = 10
      expect(result.pValue, lessThan(0.05));
    });

    test('Z-test with known population standard deviation', () {
      // Sample with mean ≈ 100
      List<num> sample = [98, 102, 99, 101, 100, 103, 97, 101];
      num mu0 = 95; // Test against different mean
      num sigma = 5; // Known population std dev

      var result = HypothesisTesting.zTest(sample, mu0, sigma);

      expect(result.testName, equals('Z-test'));
      expect(result.reject, isTrue);
      expect(result.pValue, lessThan(0.05));
    });

    test('Chi-square goodness-of-fit test', () {
      // Testing if a die is fair
      // Observed: rolled 60 times
      List<num> observed = [12, 8, 11, 10, 9, 10];
      // Expected: each face should appear 10 times
      List<num> expected = [10, 10, 10, 10, 10, 10];

      var result = HypothesisTesting.chiSquareTest(observed, expected);

      expect(result.testName, equals('Chi-square test'));
      expect(result.degreesOfFreedom, equals(5));
      // This should not reject (values are close to expected)
      expect(result.reject, isFalse);
    });

    test('Chi-square test computes statistic correctly', () {
      List<num> observed = [30, 2, 2, 2, 2, 22];
      List<num> expected = [10, 10, 10, 10, 10, 10];

      var result = HypothesisTesting.chiSquareTest(observed, expected);

      // Chi-square statistic should be large for these differences
      expect(result.statistic, greaterThan(20));
      expect(result.degreesOfFreedom, equals(5));
    });

    test('ANOVA detects difference among groups', () {
      // Three groups with different means
      List<num> group1 = [5.0, 5.2, 4.8, 5.1, 4.9];
      List<num> group2 = [7.0, 7.2, 6.8, 7.1, 6.9];
      List<num> group3 = [9.0, 9.2, 8.8, 9.1, 8.9];

      var result = HypothesisTesting.anovaTest([group1, group2, group3]);

      expect(result.testName, equals('One-way ANOVA'));
      expect(result.reject, isTrue);
      expect(result.pValue, lessThan(0.05));
      expect(result.statistic, greaterThan(1)); // F-statistic should be large
    });

    test('ANOVA does not reject for similar groups', () {
      List<num> group1 = [5.0, 5.1, 4.9, 5.0];
      List<num> group2 = [5.1, 5.0, 5.2, 4.8];
      List<num> group3 = [4.9, 5.0, 5.1, 5.0];

      var result = HypothesisTesting.anovaTest([group1, group2, group3]);

      expect(result.reject, isFalse);
      expect(result.pValue, greaterThan(0.05));
    });
  });
}
