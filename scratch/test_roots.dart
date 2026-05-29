import 'package:advance_math/advance_math.dart';

void main() {
  final expr = Expression.parse('-1+11000*(-100*(10+x)^(-1)+20)^(-2)*(10+x)^(-2)');
  print('parsed: $expr');
  
  try {
    final combined = ExpressionSolver.solve(expr, Variable('x'));
    print('solve: $combined');
  } catch (e, stack) {
    print('error: $e');
    print(stack);
  }
}
