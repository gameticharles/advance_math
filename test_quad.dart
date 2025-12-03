import 'package:advance_math/advance_math.dart';

void main() {
  void check(String equation, String varName) {
    try {
      print('Solving $equation for $varName...');
      var parsed = Expression.parse(equation);
      var v = Variable(varName);
      var result = ExpressionSolver.solve(parsed, v);
      print('Result: $result');
    } catch (e, s) {
      print('Error: $e');
      print(s);
    }
  }

  // 1. Quadratic - this works now
  check('x^2-1=0', 'x');

  print('\n--- Test 2: Quadratic with double root ---');
  check('x^2+2*x+1=0', 'x');
}
