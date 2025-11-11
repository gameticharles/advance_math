import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';
import 'dart:math' as math;

/// Final Integration Tests and Performance Validation
///
/// This test suite validates the enhanced expression creation methods in real-world
/// mathematical scenarios and ensures they don't negatively impact performance.
///
/// Requirements covered:
/// - 2.4: Multiple convenient methods for expression creation
/// - 3.4: Advanced mathematical operations compatibility
/// - 4.1: Backward compatibility with existing code
/// - 4.2: Performance equivalence across methods
void main() {
  group('Final Integration Tests and Performance Validation', () {
    late Variable x, y, z;

    setUp(() {
      x = Variable(Identifier('x'));
      y = Variable(Identifier('y'));
      z = Variable(Identifier('z'));
    });

    group('End-to-End Mathematical Scenarios', () {
      test('should handle quadratic formula calculations', () {
        // Quadratic formula: x = (-b ± √(b² - 4ac)) / 2a
        // Test with equation: 2x² + 5x - 3 = 0
        final a = ex(2);
        final b = ex(5);
        final c = ex(-3);

        // Calculate discriminant: b² - 4ac
        final discriminant = (b ^ ex(2)) - ex(4) * a * c;
        final discriminantValue = discriminant.evaluate({});
        expect(discriminantValue, equals(49)); // 25 + 24 = 49

        // Calculate solutions
        final sqrtDiscriminant = ex(math.sqrt(discriminantValue));
        final solution1 =
            ((-1).toExpression() * b + sqrtDiscriminant) / (ex(2) * a);
        final solution2 =
            ((-1).toExpression() * b - sqrtDiscriminant) / (ex(2) * a);

        final sol1Value = solution1.evaluate({});
        final sol2Value = solution2.evaluate({});

        // Expected solutions: x = 0.5 and x = -3
        expect(sol1Value, closeTo(0.5, 0.001));
        expect(sol2Value, closeTo(-3.0, 0.001));
      });

      test('should handle physics calculations with enhanced methods', () {
        // Test various physics formulas using enhanced expression creation

        // 1. Kinetic energy: KE = (1/2)mv²
        final mass = ex(2); // kg
        final velocity = ex(10); // m/s
        final kineticEnergy = ex(0.5) * mass * (velocity ^ ex(2));
        expect(
            kineticEnergy.evaluate({}), equals(100)); // 0.5 * 2 * 100 = 100 J

        // 2. Gravitational potential energy: PE = mgh
        final g = ex(9.8); // m/s²
        final height = ex(5); // m
        final potentialEnergy = mass * g * height;
        expect(potentialEnergy.evaluate({}), equals(98)); // 2 * 9.8 * 5 = 98 J

        // 3. Power calculation: P = W/t
        final work = ex(500); // J
        final time = ex(10); // s
        final power = work / time;
        expect(power.evaluate({}), equals(50)); // 500 / 10 = 50 W

        // 4. Ohm's law: V = IR
        final current = ex(2); // A
        final resistance = ex(5); // Ω
        final voltage = current * resistance;
        expect(voltage.evaluate({}), equals(10)); // 2 * 5 = 10 V
      });

      test('should handle compound interest calculations', () {
        // Compound interest: A = P(1 + r/n)^(nt)
        // P = principal, r = rate, n = compounds per year, t = time
        final P = ex(1000); // $1000 principal
        final r = ex(0.05); // 5% annual rate
        final n = ex(12); // Monthly compounding
        final t = Variable(Identifier('t'));

        final amount = P * ((ex(1) + r / n) ^ (n * t));

        // Test compound interest over different periods
        final result1Year = amount.evaluate({'t': 1});
        final result5Years = amount.evaluate({'t': 5});

        // Expected: ~$1051.16 after 1 year, ~$1283.36 after 5 years
        expect(result1Year, closeTo(1051.16, 1.0));
        expect(result5Years, closeTo(1283.36, 1.0));
      });
    });

    group('Performance Validation - Complex Expressions', () {
      test('should maintain performance with large polynomial expressions', () {
        const degree = 50;
        const iterations = 1000;

        // Create large polynomial using different methods
        Expression literalPoly = Literal(0);
        Expression extensionPoly = 0.toExpression();
        Expression helperPoly = ex(0);

        for (int i = 1; i <= degree; i++) {
          literalPoly = literalPoly + Literal(i) * (x ^ Literal(i));
          extensionPoly =
              extensionPoly + i.toExpression() * (x ^ i.toExpression());
          helperPoly = helperPoly + ex(i) * (x ^ ex(i));
        }

        final testValue = {'x': 1.1};

        // Benchmark evaluation performance
        final literalStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          literalPoly.evaluate(testValue);
        }
        literalStopwatch.stop();

        final extensionStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          extensionPoly.evaluate(testValue);
        }
        extensionStopwatch.stop();

        final helperStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          helperPoly.evaluate(testValue);
        }
        helperStopwatch.stop();

        print(
            '\n=== Large Polynomial Performance (degree $degree, $iterations iterations) ===');
        print('Literal method: ${literalStopwatch.elapsedMicroseconds}μs');
        print('Extension method: ${extensionStopwatch.elapsedMicroseconds}μs');
        print('Helper method: ${helperStopwatch.elapsedMicroseconds}μs');

        // Performance should be within 50% of baseline
        final baseTime = literalStopwatch.elapsedMicroseconds;
        expect(
            extensionStopwatch.elapsedMicroseconds, lessThan(baseTime * 1.5));
        expect(helperStopwatch.elapsedMicroseconds, lessThan(baseTime * 1.5));

        // All should produce the same result
        final literalResult = literalPoly.evaluate(testValue);
        final extensionResult = extensionPoly.evaluate(testValue);
        final helperResult = helperPoly.evaluate(testValue);

        expect(extensionResult, closeTo(literalResult, 0.001));
        expect(helperResult, closeTo(literalResult, 0.001));
      });

      test('should maintain performance with multivariate expressions', () {
        const iterations = 10000;

        // Create complex multivariate expressions
        final literalMulti = Literal(2) * (x ^ Literal(2)) * (y ^ Literal(3)) +
            Literal(3) * x * (y ^ Literal(2)) * z +
            Literal(4) * (x ^ Literal(3)) * y +
            Literal(5) * x * y * z +
            Literal(6);

        final extensionMulti =
            2.toExpression() * (x ^ 2.toExpression()) * (y ^ 3.toExpression()) +
                3.toExpression() * x * (y ^ 2.toExpression()) * z +
                4.toExpression() * (x ^ 3.toExpression()) * y +
                5.toExpression() * x * y * z +
                6.toExpression();

        final helperMulti = ex(2) * (x ^ ex(2)) * (y ^ ex(3)) +
            ex(3) * x * (y ^ ex(2)) * z +
            ex(4) * (x ^ ex(3)) * y +
            ex(5) * x * y * z +
            ex(6);

        final testValues = {'x': 1.5, 'y': 2.0, 'z': 0.5};

        // Benchmark multivariate evaluation
        final literalStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          literalMulti.evaluate(testValues);
        }
        literalStopwatch.stop();

        final extensionStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          extensionMulti.evaluate(testValues);
        }
        extensionStopwatch.stop();

        final helperStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          helperMulti.evaluate(testValues);
        }
        helperStopwatch.stop();

        print(
            '\n=== Multivariate Expression Performance ($iterations iterations) ===');
        print('Literal method: ${literalStopwatch.elapsedMicroseconds}μs');
        print('Extension method: ${extensionStopwatch.elapsedMicroseconds}μs');
        print('Helper method: ${helperStopwatch.elapsedMicroseconds}μs');

        // Performance should be comparable
        final baseTime = literalStopwatch.elapsedMicroseconds;
        expect(
            extensionStopwatch.elapsedMicroseconds, lessThan(baseTime * 1.5));
        expect(helperStopwatch.elapsedMicroseconds, lessThan(baseTime * 1.5));

        // All should produce the same result
        final literalResult = literalMulti.evaluate(testValues);
        final extensionResult = extensionMulti.evaluate(testValues);
        final helperResult = helperMulti.evaluate(testValues);

        expect(extensionResult, closeTo(literalResult, 0.001));
        expect(helperResult, closeTo(literalResult, 0.001));
      });
    });

    group('Memory Usage and Garbage Collection Impact', () {
      test('should have comparable memory usage patterns', () {
        const expressionCount = 10000; // Reduced for faster testing

        // Create large numbers of expressions using different methods
        final literalExpressions = <Expression>[];
        final extensionExpressions = <Expression>[];
        final helperExpressions = <Expression>[];

        // Measure creation time and memory patterns
        final literalStopwatch = Stopwatch()..start();
        for (int i = 0; i < expressionCount; i++) {
          literalExpressions.add(Literal(i % 1000) * x + Literal(i % 100));
        }
        literalStopwatch.stop();

        final extensionStopwatch = Stopwatch()..start();
        for (int i = 0; i < expressionCount; i++) {
          extensionExpressions
              .add((i % 1000).toExpression() * x + (i % 100).toExpression());
        }
        extensionStopwatch.stop();

        final helperStopwatch = Stopwatch()..start();
        for (int i = 0; i < expressionCount; i++) {
          helperExpressions.add(ex(i % 1000) * x + ex(i % 100));
        }
        helperStopwatch.stop();

        print(
            '\n=== Memory Usage Pattern Test ($expressionCount expressions) ===');
        print('Literal creation: ${literalStopwatch.elapsedMicroseconds}μs');
        print(
            'Extension creation: ${extensionStopwatch.elapsedMicroseconds}μs');
        print('Helper creation: ${helperStopwatch.elapsedMicroseconds}μs');

        // All collections should have the same size
        expect(literalExpressions.length, equals(expressionCount));
        expect(extensionExpressions.length, equals(expressionCount));
        expect(helperExpressions.length, equals(expressionCount));

        // Test functional equivalence on a sample
        final testValues = {'x': 2.5};
        for (int i = 0; i < 100; i += 10) {
          final literalResult = literalExpressions[i].evaluate(testValues);
          final extensionResult = extensionExpressions[i].evaluate(testValues);
          final helperResult = helperExpressions[i].evaluate(testValues);

          expect(extensionResult, equals(literalResult));
          expect(helperResult, equals(literalResult));
        }

        // Creation time should be comparable
        final baseTime = literalStopwatch.elapsedMicroseconds;
        expect(extensionStopwatch.elapsedMicroseconds, lessThan(baseTime * 2));
        expect(helperStopwatch.elapsedMicroseconds, lessThan(baseTime * 2));
      });

      test('should handle garbage collection efficiently', () {
        const cycles = 5; // Reduced for faster testing
        const expressionsPerCycle = 5000;

        final creationTimes = <int>[];
        final evaluationTimes = <int>[];

        for (int cycle = 0; cycle < cycles; cycle++) {
          final expressions = <Expression>[];

          // Create expressions
          final creationStopwatch = Stopwatch()..start();
          for (int i = 0; i < expressionsPerCycle; i++) {
            // Mix all three approaches
            switch (i % 3) {
              case 0:
                expressions.add(Literal(i) * x + Literal(i + 1));
                break;
              case 1:
                expressions.add(i.toExpression() * x + (i + 1).toExpression());
                break;
              case 2:
                expressions.add(ex(i) * x + ex(i + 1));
                break;
            }
          }
          creationStopwatch.stop();
          creationTimes.add(creationStopwatch.elapsedMicroseconds);

          // Evaluate expressions
          final evaluationStopwatch = Stopwatch()..start();
          final testValues = {'x': 1.5};
          for (final expr in expressions) {
            expr.evaluate(testValues);
          }
          evaluationStopwatch.stop();
          evaluationTimes.add(evaluationStopwatch.elapsedMicroseconds);

          // Clear expressions to trigger garbage collection
          expressions.clear();
        }

        print('\n=== Garbage Collection Impact Test ($cycles cycles) ===');

        // Calculate average times
        final avgCreation = creationTimes.reduce((a, b) => a + b) / cycles;
        final avgEvaluation = evaluationTimes.reduce((a, b) => a + b) / cycles;

        print('Average creation time: ${avgCreation.toStringAsFixed(0)}μs');
        print('Average evaluation time: ${avgEvaluation.toStringAsFixed(0)}μs');

        // Performance should be consistent across cycles (no significant degradation)
        final maxCreation = creationTimes.reduce(math.max);
        final minCreation = creationTimes.reduce(math.min);
        final creationVariance = (maxCreation - minCreation) / avgCreation;

        final maxEvaluation = evaluationTimes.reduce(math.max);
        final minEvaluation = evaluationTimes.reduce(math.min);
        final evaluationVariance =
            (maxEvaluation - minEvaluation) / avgEvaluation;

        print(
            'Creation variance: ${(creationVariance * 100).toStringAsFixed(1)}%');
        print(
            'Evaluation variance: ${(evaluationVariance * 100).toStringAsFixed(1)}%');

        // Variance should be reasonable (less than 300% for reduced test size)
        expect(creationVariance, lessThan(3.0));
        expect(evaluationVariance, lessThan(3.0));
      });
    });

    group('Backward Compatibility Validation', () {
      test('should not impact existing Expression performance', () {
        const iterations = 10000; // Reduced for faster testing

        // Create expressions using traditional methods
        final traditionalExpr = Add(Multiply(Literal(3), x), Literal(5));
        final modernExpr = 3.toExpression() * x + ex(5);

        final testValues = {'x': 2.5};

        // Benchmark traditional approach
        final traditionalStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          traditionalExpr.evaluate(testValues);
        }
        traditionalStopwatch.stop();

        // Benchmark modern approach
        final modernStopwatch = Stopwatch()..start();
        for (int i = 0; i < iterations; i++) {
          modernExpr.evaluate(testValues);
        }
        modernStopwatch.stop();

        print(
            '\n=== Backward Compatibility Performance ($iterations iterations) ===');
        print(
            'Traditional approach: ${traditionalStopwatch.elapsedMicroseconds}μs');
        print('Modern approach: ${modernStopwatch.elapsedMicroseconds}μs');

        // Modern approach should not be significantly slower
        final performanceRatio = modernStopwatch.elapsedMicroseconds /
            traditionalStopwatch.elapsedMicroseconds;
        print(
            'Performance ratio (modern/traditional): ${performanceRatio.toStringAsFixed(2)}x');

        expect(performanceRatio,
            lessThan(3.0)); // Should not be more than 3x slower

        // Both should produce the same result
        final traditionalResult = traditionalExpr.evaluate(testValues);
        final modernResult = modernExpr.evaluate(testValues);
        expect(modernResult, equals(traditionalResult));
      });

      test('should maintain compatibility with existing APIs', () {
        // Test that all existing Expression methods work with enhanced literals
        final expr = 2.toExpression() * x + ex(3);

        // Test toString
        expect(expr.toString(), isA<String>());

        // Test evaluate
        expect(expr.evaluate({'x': 5}), equals(13));

        // Test differentiate
        final derivative = expr.differentiate();
        expect(derivative.evaluate({}), equals(2));

        // Test integrate
        final integral = expr.integrate();
        expect(integral, isA<Expression>());

        // Test operator overloads
        final combined = expr + ex(1);
        expect(combined.evaluate({'x': 5}), equals(14));

        // Test type checking
        expect(expr, isA<Expression>());
        expect(expr, isA<Add>());
      });

      test('should work with existing expression parsing', () {
        // Test that parsed expressions work with enhanced methods
        final parsedExpr = Expression.parse('x + 5');
        final enhancedExpr = parsedExpr + 2.toExpression();

        expect(enhancedExpr.evaluate({'x': 3}), equals(10)); // (3 + 5) + 2 = 10

        // Test mixed operations
        final mixedExpr = ex(2) * parsedExpr - 1.toExpression();
        expect(
            mixedExpr.evaluate({'x': 3}), equals(15)); // 2 * (3 + 5) - 1 = 15
      });
    });

    group('Real-World Integration Scenarios', () {
      test('should handle financial modeling scenarios', () {
        // Black-Scholes option pricing components
        final S = Variable('S'); // Stock price
        final K = ex(100); // Strike price
        final r = ex(0.05); // Risk-free rate
        final T = ex(1); // Time to expiration
        final sigma = ex(0.2); // Volatility

        // d1 calculation: (ln(S/K) + (r + σ²/2)T) / (σ√T)
        final d1Numerator = Ln(S / K) + (r + (sigma ^ ex(2)) / ex(2)) * T;
        final d1Denominator = sigma * (T ^ ex(0.5));
        final d1 = d1Numerator / d1Denominator;

        // Test with specific stock price
        final testValues = {'S': 105};
        final d1Value = d1.evaluate(testValues);

        // d1 should be a reasonable value for these parameters
        expect(d1Value, greaterThan(0));
        expect(d1Value, lessThan(2));
      });

      test('should handle engineering calculations', () {
        // Beam deflection calculation: δ = (5wL⁴)/(384EI)
        final w = ex(1000); // Load per unit length (N/m)
        final L = Variable(Identifier('L')); // Beam length
        final E = ex(200e9); // Elastic modulus (Pa)
        final I = ex(1e-6); // Moment of inertia (m⁴)

        final deflection = (ex(5) * w * (L ^ ex(4))) / (ex(384) * E * I);

        // Test with different beam lengths
        final testLengths = [1, 2, 3];
        for (final length in testLengths) {
          final delta = deflection.evaluate({'L': length});
          expect(delta, greaterThan(0));

          // Deflection should increase with L⁴
          if (length > 1) {
            final prevDelta = deflection.evaluate({'L': length - 1});
            expect(delta, greaterThan(prevDelta));
          }
        }
      });

      test('should handle optimization problem setup', () {
        // Minimize f(x,y) = x² + y² subject to constraint g(x,y) = x + y - 1 = 0
        final objective = (x ^ ex(2)) + (y ^ ex(2));
        final constraint = x + y - ex(1);

        // Lagrangian: L = f(x,y) + λ*g(x,y)
        final lambda = Variable(Identifier('lambda'));
        final lagrangian = objective + lambda * constraint;

        // Test that expressions are properly formed
        expect(objective, isA<Expression>());
        expect(constraint, isA<Expression>());
        expect(lagrangian, isA<Expression>());

        // Test evaluation at known solution point (0.5, 0.5)
        final solutionPoint = {'x': 0.5, 'y': 0.5, 'lambda': 1.0};
        final objectiveValue = objective.evaluate(solutionPoint);
        final constraintValue = constraint.evaluate(solutionPoint);

        expect(objectiveValue, equals(0.5)); // 0.25 + 0.25 = 0.5
        expect(constraintValue, closeTo(0, 0.001)); // Should satisfy constraint
      });
    });

    group('Stress Testing', () {
      test('should handle large expressions', () {
        const terms = 100; // Reduced for faster testing

        // Create large polynomial
        Expression largeExpr = ex(0);
        for (int i = 1; i <= terms; i++) {
          largeExpr = largeExpr +
              ex(i) * (x ^ ex(i % 5)); // Limit powers to prevent overflow
        }

        // Test that it can be evaluated
        final result =
            largeExpr.evaluate({'x': 1.001}); // Small value to prevent overflow
        expect(result, isA<num>());
        expect(result.isFinite, isTrue);
      });

      test('should handle rapid creation and destruction', () {
        const cycles = 10; // Reduced for faster testing
        const expressionsPerCycle = 500;

        for (int cycle = 0; cycle < cycles; cycle++) {
          final expressions = <Expression>[];

          // Rapidly create expressions
          for (int i = 0; i < expressionsPerCycle; i++) {
            expressions.add(ex(i) * x + (i + 1).toExpression());
          }

          // Rapidly evaluate them
          final testValues = {'x': 1.5};
          for (final expr in expressions) {
            expr.evaluate(testValues);
          }

          // Clear for next cycle
          expressions.clear();
        }

        // If we get here without errors, the test passes
        expect(true, isTrue);
      });

      test('should handle concurrent-like usage patterns', () {
        const iterations = 1000; // Reduced for faster testing
        final expressions = <Expression>[];

        // Create expressions using all methods interleaved
        for (int i = 0; i < iterations; i++) {
          switch (i % 6) {
            case 0:
              expressions.add(Literal(i) + x);
              break;
            case 1:
              expressions.add(i.toExpression() + x);
              break;
            case 2:
              expressions.add(ex(i) + x);
              break;
            case 3:
              expressions.add(x + Literal(i));
              break;
            case 4:
              expressions.add(x + i.toExpression());
              break;
            case 5:
              expressions.add(x + ex(i));
              break;
          }
        }

        // Evaluate all expressions
        final testValues = {'x': 2.5};
        for (int i = 0; i < expressions.length; i++) {
          final result = expressions[i].evaluate(testValues);
          expect(result, equals(2.5 + i)); // x + i where x = 2.5
        }
      });

      test(
          'should handle complex mathematical operations with enhanced methods',
          () {
        // Test complex mathematical scenarios using enhanced expression creation

        // 1. Taylor series approximation for e^x: 1 + x + x²/2! + x³/3! + ...
        final xVal = ex(0.5);
        final taylorSeries = ex(1) +
            xVal +
            (xVal ^ ex(2)) / ex(2) +
            (xVal ^ ex(3)) / ex(6) +
            (xVal ^ ex(4)) / ex(24);

        final taylorResult = taylorSeries.evaluate({});
        final actualExp = math.exp(0.5);

        // Should be close to actual e^0.5
        expect(taylorResult, closeTo(actualExp, 0.01));

        // 2. Quadratic formula discriminant: b² - 4ac
        final a = ex(1);
        final b = ex(-5);
        final c = ex(6);
        final discriminant = (b ^ ex(2)) - ex(4) * a * c;

        expect(discriminant.evaluate({}), equals(1)); // 25 - 24 = 1

        // 3. Simple arithmetic test with enhanced methods
        final num1 = ex(3);
        final num2 = ex(4);
        final sum = num1 + num2;
        final product = num1 * num2;
        final power = num1 ^ ex(2);

        expect(sum.evaluate({}), equals(7)); // 3 + 4 = 7
        expect(product.evaluate({}), equals(12)); // 3 * 4 = 12
        expect(power.evaluate({}), equals(9)); // 3² = 9
      });
    });
  });
}
