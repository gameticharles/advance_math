import 'package:advance_math/advance_math.dart';

void main() {
  void check(String eqStr, String varName) {
    print('\n--- Testing $eqStr for $varName ---');
    try {
      var eq = Expression.parse(eqStr);
      var v = Variable(varName);

      // Check isPolynomial logic
      print('Checking isPolynomial...');
      var expanded = eq.expand().simplify();
      print('Expanded & Simplified: $expanded');
      var str = expanded
          .toString()
          .replaceAll('*', '')
          .replaceAll(RegExp(r'\.0(?!\d)'), '');
      print('Cleaned string: $str');
      var isPoly = Polynomial.isPolynomial(str, varName: varName);
      print('Is Polynomial: $isPoly');

      // Solve
      print('Solving...');
      var result = ExpressionSolver.solve(eq, v);
      print('Result: $result');
    } catch (e, s) {
      print('Error: $e');
      print(s);
    }
  }

  // 1. Quadratic with uncombined terms
  check('2*a^(2)+4*a*6=128', 'a');

  // 2. Cubic factors
  check('(x-1)*(x-2)*(x-3)=0', 'x');

  // 3. Failing factor case from solve_spec_test
  check('solve((x-1)*(-a*c-a*x+c*x+x^2),x)', 'x');

  // 4. Check isPolynomial for the quadratic factor
  print('\n--- Testing isPolynomial for -a*c-a*x+c*x+x^2 ---');
  var polyExpr = Expression.parse('-a*c-a*x+c*x+x^2');
  var polyStr = polyExpr
      .expand()
      .simplify()
      .toString()
      .replaceAll('*', '')
      .replaceAll(RegExp(r'\.0(?!\d)'), '');
  print('Poly String: $polyStr');
  print('Is Poly: ${Polynomial.isPolynomial(polyStr, varName: 'x')}');

  // 5. Debug Linear Solver
  print('\n--- Testing Linear Solver x/2+1=3 ---');
  check('solve(x/2+1=3, x)', 'x');

  // 6. Debug System Solver
  print('\n--- Testing System x+y=1, x-y=1 ---');
  var sysEqs = [Expression.parse('x+y=1'), Expression.parse('x-y=1')];
  var sysSol = ExpressionSolver.solveEquations(sysEqs);
  print('System Result: $sysSol');

  print('\n--- Testing solveEquations via Parser ---');
  check('solveEquations(["x+y=1", "x-y=1"])', 'x,y');

  // 3. System
  print('\n--- Testing System ---');
  var eqs = [
    Expression.parse('x+y=1'),
    Expression.parse('2*x=6'),
    Expression.parse('4*z+y=6')
  ];
  var res = ExpressionSolver.solveEquations(eqs);
  print('System Result: $res');
}
