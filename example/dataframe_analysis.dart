import 'package:advance_math/advance_math.dart';
import 'package:dartframe/dartframe.dart';

void main() {
  print('=== Advance Math + DartFrame Integration Demo ===\n');

  // 1. Create a DataFrame with sample data
  // Scenario: Advertising spend (TV, Radio, Newspaper) and Sales
  final data = {
    'TV': [230.1, 44.5, 17.2, 151.5, 180.8, 8.7, 57.5, 120.2, 8.6, 199.8],
    'Radio': [37.8, 39.3, 45.9, 41.3, 10.8, 48.9, 32.8, 19.6, 2.1, 2.6],
    'Newspaper': [69.2, 45.1, 69.3, 58.5, 58.4, 75.0, 23.5, 11.6, 1.0, 21.2],
    'Sales': [22.1, 10.4, 9.3, 18.5, 12.9, 7.2, 11.8, 13.2, 4.8, 10.6],
    'Time': [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], // Dummy time index
  };

  final df = DataFrame.fromMap(data);
  print('DataFrame Shape: ${df.shape}');
  print('Columns: ${df.columns}\n');

  // 2. Simple Linear Regression (TV vs Sales)
  print('--- Simple Linear Regression (TV vs Sales) ---');
  try {
    final result = df.linearRegression('TV', 'Sales');
    print('R²: ${result.rSquared.toStringAsFixed(4)}');
    print('Coefficients: ${result.coefficients}');
    print('Prediction for TV=100: ${result.predict([100]).toStringAsFixed(2)}');
  } catch (e) {
    print('Error: $e');
  }
  print('');

  // 3. Multiple Linear Regression (TV + Radio + Newspaper vs Sales)
  print('--- Multiple Linear Regression (All vs Sales) ---');
  try {
    final result =
        df.multipleLinearRegression(['TV', 'Radio', 'Newspaper'], 'Sales');
    print('R²: ${result.rSquared.toStringAsFixed(4)}');
    print('Adjusted R²: ${result.adjustedRSquared?.toStringAsFixed(4)}');
    print('Coefficients: ${result.coefficients}');
  } catch (e) {
    print('Error: $e');
  }
  print('');

  // 4. Time Series Analysis (Moving Average on Sales)
  print('--- Time Series: Moving Average (Sales, window=3) ---');
  try {
    final ma = df.movingAverage('Sales', 3);
    print('Original Sales: ${df['Sales']!.toList()}');
    print('Moving Average: $ma');
  } catch (e) {
    print('Error: $e');
  }
  print('');

  // 5. Hypothesis Testing (T-Test: TV vs Radio impact? Just comparing means here)
  print('--- Hypothesis Testing: T-Test (TV vs Radio spend) ---');
  try {
    final tTest = df.tTestPair('TV', 'Radio', equalVariance: false);
    print('Statistic: ${tTest.statistic.toStringAsFixed(4)}');
    print('P-Value: ${tTest.pValue.toStringAsFixed(4)}');
    print('Reject Null (alpha=0.05)? ${tTest.reject}');
  } catch (e) {
    print('Error: $e');
  }
}
