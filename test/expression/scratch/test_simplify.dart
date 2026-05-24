import 'package:advance_math/advance_math.dart';

void main() {
  var p = Expression.parse('integrate(2*x^2+x, x)');
  print('Parsed: $p');
  print('Simplified: ${p.simplify()}');
  print('Simplified RuntimeType: ${p.simplify().runtimeType}');
  if (p.simplify() is Add) {
    var add = p.simplify() as Add;
    print('Left: ${add.left} (${add.left.runtimeType})');
    if (add.left is Multiply) {
      var mul = add.left as Multiply;
      print('Left.left: ${mul.left} (${mul.left.runtimeType})');
      if (mul.left is Literal) {
        print('Left.left.value: ${(mul.left as Literal).value} (${(mul.left as Literal).value.runtimeType})');
      }
    }
    print('Right: ${add.right} (${add.right.runtimeType})');
  }
}
