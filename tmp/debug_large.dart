import 'package:advance_math/advance_math.dart';

void main() {
  var ep = ExpressionParser();

  // Large negative number test
  print('=== LARGE NEGATIVE ===');
  var expr1 = ep.parse('pfactor(-10000000114421840327308)');
  print('Type: ${ep.parse('-10000000114421840327308').runtimeType}');
  print('Value: ${ep.parse('-10000000114421840327308')}');
  try {
    var v = ep.parse('-10000000114421840327308').evaluate();
    print('Eval: $v type: ${v.runtimeType}');
  } catch (e) {
    print('Eval error: $e');
  }
  print('pfactor(-10000000114421840327308): $expr1');

  // Verify manually:
  // -10000000114421840327308 = -2^2 * 480827 * 7 * 8345706745687 * 89
  // Let's check: 4 * 480827 * 7 * 8345706745687 * 89
  BigInt n = BigInt.from(4) *
      BigInt.from(480827) *
      BigInt.from(7) *
      BigInt.parse('8345706745687') *
      BigInt.from(89);
  print('Manual check: $n'); // should be 10000000114421840327308

  // The number as BigInt
  BigInt big = BigInt.parse('10000000114421840327308');
  print('BigInt: $big');

  // Also test pfactor(-7877474663)
  print('\n=== NEGATIVE MEDIUM ===');
  var expr2 = ep.parse('pfactor(-7877474663)');
  print('pfactor(-7877474663): $expr2');
  // Expected: (-97)*(180871)*(449)

  // Test that eval gets the right number
  var numExpr = ep.parse('-7877474663');
  print('Type: ${numExpr.runtimeType}');
  print('Val: $numExpr');
  try {
    var v = numExpr.evaluate();
    print('Eval: $v type: ${v.runtimeType}');
  } catch (e) {
    print('Eval error: $e');
  }
}
