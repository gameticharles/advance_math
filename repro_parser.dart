import 'package:advance_math/advance_math.dart';

void main() {
  void check(String expr, num expected) {
    try {
      var parsed = Expression.parse(expr);
      var result = parsed.evaluate();
      print(
          "Expr: '$expr' -> Parsed: '$parsed' -> Result: $result (Expected: $expected)");
    } catch (e) {
      print("Expr: '$expr' -> Error: $e");
    }
  }

  print('--- Modulo vs Percentage ---');
  check('10%4', 2);
  check('10%4+6', 8);
  check('3*3%9', 0);

  print('\n--- Percentage ---');
  check('10%', 0.1);
  check('50%+50%', 1.0);
}
