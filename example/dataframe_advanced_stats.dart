import 'package:advance_math/advance_math.dart';
import 'package:dartframe/dartframe.dart';

void main() {
  print('=== Advance Math + DartFrame Advanced Stats Demo ===\n');

  // 1. Create a DataFrame with sample data
  final data = {
    'A': [10, 20, 30, 40, 50],
    'B': [12, 24, 33, 45, 52], // Highly correlated with A
    'C': [50, 40, 30, 20, 10], // Negatively correlated with A
    'D': [5, 5, 5, 5, 5], // Zero variance
  };

  final df = DataFrame.fromMap(data);
  print('DataFrame:\n$df\n');

  // 2. Descriptive Stats
  print('--- Descriptive Stats for column A ---');
  print('Sum: ${df.sumColumn('A')}');
  print('Mean: ${df.meanColumn('A')}');
  print('Median: ${df.medianColumn('A')}');
  print('StdDev: ${df.stdDevColumn('A').toStringAsFixed(4)}');
  print('Skewness: ${df.skewnessColumn('A')}');
  print(
      'Kurtosis: ${df.kurtosisColumn('A')} (Expected ~ -1.3 for uniform-like)');
  print('Summary: ${df.describeColumn('A')}\n');

  // 3. Correlation
  print('--- Correlation Matrix ---');
  final corrMat = df.correlationMatrix(['A', 'B', 'C']);
  print('Correlation Matrix:\n$corrMat\n');
  print('Corr(A, B): ${df.correlation('A', 'B').toStringAsFixed(4)}');
  print('Corr(A, C): ${df.correlation('A', 'C').toStringAsFixed(4)}\n');

  // 4. Preprocessing
  print('--- Preprocessing ---');
  print('Original A: ${df['A']!.toList()}');
  print('Normalized A: ${df.normalizeColumn('A')}');
  print('Standardized A: ${df.standardizeColumn('A')}\n');

  // 5. Advanced Hypothesis Testing
  print('--- Hypothesis Testing ---');
  // Z-Test: Test if A comes from pop mean 25 (sigma=15)
  // Mean is 30, so z = (30-25)/(15/sqrt(5)) = 5 / 6.7 = 0.745
  final zRes = df.zTest('A', 25, 15);
  print(
      'Z-Test (mu=25, sigma=15): ${zRes.statistic.toStringAsFixed(4)}, p=${zRes.pValue.toStringAsFixed(4)}');

  // Chi-Square: Observed B vs Expected A
  final chiRes = df.chiSquareTest('B', 'A');
  print(
      'Chi-Square (B vs A): ${chiRes.statistic.toStringAsFixed(4)}, p=${chiRes.pValue.toStringAsFixed(4)}');
}
