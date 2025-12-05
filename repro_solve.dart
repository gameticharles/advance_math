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

  // 1. Quadratic failure
  Expression pp = Polynomial.fromString('x^2-1', variable: Variable('x'));

  print('pp: ${pp.simplify()}');
  check('x^2-1=0', 'x');
  check('x^2+2*x+1=0', 'x');

  // 2. Factor failure
  check('(x-1)*(x-2)=0', 'x');

  // 3. Parameter failure
  check('x+a=0', 'x');
  check('2*a^2+4*a*6=128', 'a');

  // 4. System failure
  try {
    print('Solving system x+y=1, x-y=1...');
    var eqs = [Expression.parse('x+y=1'), Expression.parse('x-y=1')];
    var res = ExpressionSolver.solveEquations(eqs);
    print('Result: $res');
  } catch (e) {
    print('Error: $e');
  }
}
