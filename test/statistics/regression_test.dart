import 'package:advance_math/src/math/statistics/regression.dart';
import 'package:advance_math/src/math/algebra/algebra.dart';
import 'package:test/test.dart';

void main() {
  group('Regression - Linear', () {
    test('Simple linear regression', () {
      List<num> x = [1, 2, 3, 4, 5];
      List<num> y = [2, 4, 6, 8, 10]; // Perfect line: y = 2x

      var result = Regression.linear(x, y);

      expect(result.coefficients[0], closeTo(0, 0.01)); // Intercept ≈ 0
      expect(result.coefficients[1], closeTo(2, 0.01)); // Slope ≈ 2
      expect(result.rSquared, closeTo(1, 0.01)); // Perfect fit
    });

    test('Linear regression with noise', () {
      List<num> x = [1, 2, 3, 4, 5];
      List<num> y = [2.1, 3.9, 6.1, 7.9, 10.1]; // Approximately y = 2x

      var result = Regression.linear(x, y);

      expect(result.coefficients[1], closeTo(2, 0.2));
      expect(result.rSquared, greaterThan(0.95));
    });

    test('Linear regression predict method', () {
      List<num> x = [1, 2, 3, 4, 5];
      List<num> y = [2, 4, 6, 8, 10];

      var result = Regression.linear(x, y);

      // Predict for x=6
      num prediction = result.predict([6]);
      expect(prediction, closeTo(12, 0.1));
    });
  });

  group('Regression - Multiple Linear', () {
    test('Multiple linear regression', () {
      // Simple test: x1 and x2
      Matrix X = Matrix([
        [1.0, 1.0],
        [2.0, 2.0],
        [3.0, 1.0],
        [4.0, 4.0],
      ]);
      List<num> y = [3, 5, 5, 9];

      var result = Regression.multipleLinear(X, y);

      // Just check that we get reasonable coefficients and good fit
      expect(result.coefficients.length, equals(3)); // Intercept + 2 features
      expect(result.rSquared, greaterThan(0.9));
    });
  });

  group('Regression - Polynomial', () {
    test('Polynomial regression degree 2', () {
      List<num> x = [1, 2, 3, 4, 5];
      List<num> y = [1, 4, 9, 16, 25]; // y = x²

      var result = Regression.polynomial(x, y, 2);

      expect(result.rSquared, greaterThan(0.99));
      // Coefficient for x² should be close to 1
      expect(result.coefficients[2].abs(), greaterThan(0.5));
    });

    test('Polynomial regression degree 3', () {
      List<num> x = [-2, -1, 0, 1, 2];
      List<num> y = [-8, -1, 0, 1, 8]; // y = x³

      var result = Regression.polynomial(x, y, 3);

      expect(result.rSquared, greaterThan(0.99));
    });
  });

  group('Regression - Ridge', () {
    test('Ridge regression with regularization', () {
      Matrix X = Matrix([
        [1.0, 2.0],
        [2.0, 3.0],
        [3.0, 4.0],
        [4.0, 5.0],
      ]);
      List<num> y = [3, 5, 7, 9];

      var result = Regression.ridge(X, y, alpha: 0.1);

      expect(result.coefficients.length, equals(3)); // Intercept + 2 features
      expect(result.rSquared, greaterThan(0.5));
    });

    test('Ridge vs OLS comparison', () {
      Matrix X = Matrix([
        [1.0],
        [2.0],
        [3.0],
        [4.0],
      ]);
      List<num> y = [2, 4, 6, 8];

      var ols = Regression.multipleLinear(X, y);
      var ridge = Regression.ridge(X, y, alpha: 0.5);

      // Ridge coefficients should be smaller (shrinkage)
      expect(ridge.coefficients[1].abs(),
          lessThanOrEqualTo(ols.coefficients[1].abs()));
    });
  });

  group('Regression - Logistic', () {
    test('Logistic regression binary classification', () {
      Matrix X = Matrix([
        [1.0],
        [2.0],
        [3.0],
        [4.0],
        [5.0],
        [6.0],
      ]);
      List<num> y = [0, 0, 0, 1, 1, 1]; // Binary labels

      var result = Regression.logistic(X, y, maxIter: 1000, learningRate: 0.1);

      expect(result.coefficients.length, equals(2));

      // Predictions should be between 0 and 1
      expect(result.predictions.every((p) => p >= 0 && p <= 1), isTrue);

      // Lower x values should predict closer to 0
      expect(result.predictions[0], lessThan(0.5));
      // Higher x values should predict closer to 1
      expect(result.predictions.last, greaterThan(0.5));
    });
  });
}
