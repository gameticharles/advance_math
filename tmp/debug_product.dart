import 'package:advance_math/advance_math.dart';

void main() {
  var ep = ExpressionParser();

  // Test product(n!,n,1,10)
  var prodExpr = ep.parse('product(n!,n,1,10)');
  print('product type: ${prodExpr.runtimeType}');
  print('product toString: $prodExpr');
  try {
    var v = prodExpr.evaluate();
    print('product eval: $v type: ${v.runtimeType}');
  } catch (e) {
    print('product eval error: $e');
  }

  // What is product(n!,n,1,10) mathematically?
  // = 1! * 2! * 3! * ... * 10!
  // = 1 * 2 * 6 * 24 * 120 * 720 * 5040 * 40320 * 362880 * 3628800
  BigInt result = BigInt.one;
  for (int i = 1; i <= 10; i++) {
    BigInt f = BigInt.one;
    for (int j = 2; j <= i; j++) {
      f *= BigInt.from(j);
    }
    result *= f;
    print('$i! = $f');
  }
  print('product = $result');
}
