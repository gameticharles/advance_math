import 'package:advance_math/advance_math.dart';

void main() {
  var exprStr = '(x-1)*(-a*c - a*x + c*x + x^2)';
  var expr = Expression.parse(exprStr);
  print('Original: $expr');

  var simplified = expr.simplify();
  print('Simplified: $simplified');

  var expanded = expr.expand().simplify();
  print('Expanded & Simplified: $expanded');

  // Check if Polynomial.fromString handles it
  try {
    var poly = Polynomial.fromString(expanded.toString());
    print('Polynomial parsed successfully: $poly');
    print('Degree: ${poly.degree}');
    print('Coefficients: ${poly.coefficients}');

    print('Attempting to solve original factored expression...');

    // Test parsing of the quadratic part specifically
    var quadraticPart = Expression.parse('-a*c-a*x+c*x+x^2');
    print('Testing quadratic part parsing: $quadraticPart');
    var x = Variable('x');
    try {
      var polyQuad =
          Polynomial.fromString(quadraticPart.toString(), variable: x);
      print('Quadratic part parsed successfully: $polyQuad');
    } catch (e) {
      print('Quadratic part parsing FAILED: $e');
    }

    // Assuming 'originalFactored' refers to the initial 'expr'
    var originalFactored = expr;
    var solutions = ExpressionSolver.solve(originalFactored, x);
    print('Solutions: $solutions');
  } catch (e, stack) {
    print('Solver failed: $e');
    print(stack);
  }
}
