import 'package:advance_math/advance_math.dart';

void testExpr(String label, String expr, [Map<String, dynamic>? ctx]) {
  try {
    final context = {...defaultContext, ...?ctx};
    final result = ExpressionParser().parse(expr).evaluate(context);
    print('✅ $label: $expr  →  $result');
  } catch (e) {
    print('❌ $label: $expr  →  ERROR: $e');
  }
}

void main() {
  print('\n=== STAT FUNCTIONS via Expression ===\n');

  // --- mean, median, mode, variance, stdDev ---
  testExpr('mean list',    'mean([1,2,3,4,5])');
  testExpr('mean varargs', 'mean(1,2,3,4,5)');
  testExpr('avg varargs',  'avg(1,2,3)');
  testExpr('median',       'median([1,2,3,4,5])');
  testExpr('mode',         'mode([1,2,2,3])');
  testExpr('variance',     'variance([1,2,3,4,5])');
  testExpr('stdDev',       'stdDev([1,2,3,4,5])');
  testExpr('stdErrMean',   'stdErrMean([1,2,3,4,5])');
  testExpr('tValue',       'tValue([1,2,3,4,5])');
  testExpr('quartiles',    'quartiles([1,2,3,4,5,6,7])');

  print('');
  // --- sum, min, max, product ---
  testExpr('sum list',     'sum([1,2,3])');
  testExpr('sum varargs',  'sum(1,2,3)');
  testExpr('min',          'min([3,1,4,1,5])');
  testExpr('max',          'max([3,1,4,1,5])');
  testExpr('product list', 'product([2,3,4])');
  testExpr('product varargs','product(2,3,4)');

  print('');
  // --- combinatorics ---
  testExpr('nPr(5,2)',      'nPr(5,2)');
  testExpr('nCr(5,2)',      'nCr(5,2)');
  testExpr('permutations',  'permutations(5,2)');
  testExpr('combinations',  'combinations(5,2)');
  testExpr('sumTo(10)',     'sumTo(10)');

  print('');
  // --- gcf, gcd, lcm ---
  testExpr('gcf',           'gcf(12,18,24)');
  testExpr('gcd numbers',   'gcd(12,18)');
  testExpr('lcm',           'lcm(4,6)');

  print('');
  // --- correlation, confidenceInterval, regression ---
  testExpr('correlation',   'correlation([1,2,3],[1,2,3])');
  testExpr('confidenceInterval', 'confidenceInterval([1,2,3,4,5], 0.95)');
  testExpr('regression',    'regression([1,2,3],[2,4,6])');
  testExpr('stdErrEst',     'stdErrEst([1,2,3],[2,4,6])');

  print('');
  // --- range_stat, iqr, covariance ---
  testExpr('range_stat',    'range_stat(1,5,3,2,4)');
  testExpr('iqr',           'iqr(1,2,3,4,5,6,7)');
  testExpr('covariance',    'covariance([1,2,3],[2,4,6])');

  print('');
  // --- ZScore functions ---
  testExpr('zscore',         'zscore(1.5)');
  testExpr('zscore_from_raw','zscore_from_raw(75, 70, 10)');
  testExpr('percentile',     'percentile(1.5)');
  testExpr('p_value',        'p_value(1.96)');
  testExpr('cdf',            'cdf(1.96)');
  testExpr('pdf',            'pdf(0)');
  testExpr('z_to_t',         'z_to_t(1.96)');
  testExpr('confidence_interval', 'confidence_interval(100, 15, 30, 0.95)');
}
