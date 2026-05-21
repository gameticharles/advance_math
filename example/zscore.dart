import 'package:advance_math/advance_math.dart';

import 'dart:math' as dmath;

// Mocking math.erf for standalone testing if needed
class LocalMath {
  // High-precision approximation of the error function (erf)
  double erf(double x) {
    // Abramowitz and Stegun formula 7.1.26
    const p = 0.3275911;
    const a1 = 0.254829592;
    const a2 = -0.284496736;
    const a3 = 1.421413741;
    const a4 = -1.453152027;
    const a5 = 1.061405429;

    final sign = x < 0 ? -1 : 1;
    final absX = x.abs();

    final t = 1.0 / (1.0 + p * absX);
    final y = 1.0 -
        (((((a5 * t + a4) * t + a3) * t + a2) * t + a1) * t) *
            dmath.exp(-absX * absX);

    return sign * y;
  }
}

final math = LocalMath();

void main() {
  print('================================================================');
  print('🧪 ULTIMATE DIAGNOSTIC TEST SUITE FOR THE Z-SCORE STATISTICAL ENGINE');
  print('================================================================\n');

  int passedTests = 0;
  int totalTests = 0;

  void assertMetric(
      String testName, double computed, double expected, double tolerance) {
    totalTests++;
    final delta = (computed - expected).abs();
    if (delta <= tolerance) {
      print('✅ [PASSED] $testName');
      print(
          '   Computed: ${computed.toStringAsFixed(6)} | Expected: ${expected.toStringAsFixed(6)} (Δ: ${delta.toStringAsExponential(3)})\n');
      passedTests++;
    } else {
      print('❌ [FAILED] $testName');
      print(
          '   Computed: ${computed.toStringAsFixed(6)} | Expected: ${expected.toStringAsFixed(6)} (Δ: ${delta.toStringAsExponential(3)})\n');
    }
  }

  // ---------------------------------------------------------------------------
  // PILLAR 1: CRITICAL Z-BENCHMARKS
  // ---------------------------------------------------------------------------
  print('--- Pillar 1: Validating Standard Z-Score Benchmarks ---');
  // Two-tailed 95% confidence -> standard Z alpha/2 cutoff is 1.960
  assertMetric('95% Two-Tailed Z-Score',
      ZScore.computeCriticalZ(0.05, twoTailed: true), 1.95996, 1e-4);
  // One-tailed 95% confidence -> standard Z alpha cutoff is 1.645
  assertMetric('95% One-Tailed Z-Score',
      ZScore.computeCriticalZ(0.05, twoTailed: false), 1.64485, 1e-4);
  // Two-tailed 99% confidence -> standard Z alpha/2 cutoff is 2.576
  assertMetric('99% Two-Tailed Z-Score',
      ZScore.computeCriticalZ(0.01, twoTailed: true), 2.57582, 1e-4);

  // ---------------------------------------------------------------------------
  // PILLAR 2: CORNISH-FISHER SMALL-SAMPLE ACCURACY (Student's t)
  // ---------------------------------------------------------------------------
  print(
      '\n--- Pillar 2: Validating Cornish-Fisher Expansion (Small Samples) ---');
  // df = 14 represents exactly a 15-point observation loop (your field sample)
  // Text Book Critical Value for t(0.05, 14) two-tailed is exactly 2.144787
  assertMetric('t-Critical (Two-Tailed 95%, df=14)',
      ZScore.computeCriticalT(0.05, df: 14, twoTailed: true), 2.14479, 1e-4);
  assertMetric('t-Critical (One-Tailed 95%, df=14)',
      ZScore.computeCriticalT(0.05, df: 14, twoTailed: false), 1.76131, 1e-4);

  // Severe small sample stress test: df = 2
  // Textbook value for t(0.05, 2) two-tailed is exactly 4.30265
  assertMetric('Extreme Small Sample t-Critical (95%, df=2)',
      ZScore.computeCriticalT(0.05, df: 2, twoTailed: true), 4.30265, 1e-3);

  // ---------------------------------------------------------------------------
  // PILLAR 3: ASYMPTOTIC CONVERGENCE (df → ∞)
  // ---------------------------------------------------------------------------
  print('\n--- Pillar 3: Validating Seamless Infinity Convergence ---');
  // At df = 10,000, the t-distribution must fall back precisely to the normal distribution profile
  final tLargeDf = ZScore.computeCriticalT(0.05, df: 10000, twoTailed: true);
  final zBenchmark = ZScore.computeCriticalZ(0.05, twoTailed: true);
  assertMetric(
      'Convergence Match: t(df=10000) vs Z-score', tLargeDf, zBenchmark, 1e-7);

  // ---------------------------------------------------------------------------
  // PILLAR 4: INVARIANT SYMMETRY & SIGN VERIFICATION
  // ---------------------------------------------------------------------------
  print('\n--- Pillar 4: Invariant Sign Corrections (Patched Fixes) ---');
  // Verifying that a negative outlying Z-score doesn't invert confidence math into negative planes
  final confFromNegZ = ZScore.computeConfidenceLevel(-1.95996, twoTailed: true);
  assertMetric(
      'Symmetric Confidence Level from Negative Z', confFromNegZ, 95.0, 1e-2);

  // Verifying that negative coordinates or deviations don't create impossible p-values
  final pFromNegZ = ZScore.computeTwoTailedPValue(-1.95996);
  assertMetric('Two-Tailed p-Value from Negative Z', pFromNegZ, 0.05, 1e-2);

  // ---------------------------------------------------------------------------
  // PILLAR 5: EXTREME-TAIL OUTLIER STRESS TEST (Blunder Detection Boundary)
  // ---------------------------------------------------------------------------
  print('\n--- Pillar 5: Outlier Stress Test (Extreme-Tail Clamping) ---');
  // For standard blunder processing (e.g. Baarda Data Snooping), check alpha thresholds down to 1e-11
  final extremeAlpha = 1e-11;
  final tExtreme =
      ZScore.computeCriticalT(extremeAlpha, df: 5, twoTailed: true);

  // FIXED: Corrected expected analytical value for heavy-tailed t-distribution at df=5
  assertMetric('Asymptotic Bisection Boundary (alpha=10⁻¹¹ , df=5)', tExtreme,
      285.527759, 1e-4);

  print('================================================================');
  print(
      '🏁 DIAGNOSTIC REPORT: $passedTests / $totalTests COMPLIANCE MODULES PASSED');
  print('================================================================');
}
