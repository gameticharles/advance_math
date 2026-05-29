import 'package:advance_math/advance_math.dart';

void main() {
  final expr = Expression.parse('solve(log(a*x-c)-b=21, x)');
  print(expr.evaluate());
  
  // Also check the target expression
  final e = Variable('e');
  final b = Variable('b');
  final target = Pow(e, Add(Literal(21), b));
  print('target.simplify: ${target.simplify()}');
  print('target.toString: $target');
}
