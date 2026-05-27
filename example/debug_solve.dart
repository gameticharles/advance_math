import 'package:advance_math/advance_math.dart';

void main() {
  // Trace the Pow simplification path
  print('=== Direct Pow test ===');
  
  // Test: Pow(Literal(-8), Literal(0.5)).simplify()
  final p = Pow(Literal(-8), Literal(0.5));
  final pSimp = p.simplify();
  print('sqrt(-8) = $pSimp (${pSimp.runtimeType})');
  if (pSimp is Multiply) {
    print('  left: ${pSimp.left} (${pSimp.left.runtimeType})');
    if (pSimp.left is Literal) {
      print('  left.value: ${(pSimp.left as Literal).value} (${(pSimp.left as Literal).value.runtimeType})');
    }
    print('  right: ${pSimp.right} (${pSimp.right.runtimeType})');
  }
  
  // Now test dividing by 4
  print('\n=== rootDisc / 4 ===');
  final divided = Divide(pSimp, Literal(4));
  final divSimp = divided.simplify();
  print('result = $divSimp (${divSimp.runtimeType})');
  if (divSimp is Multiply) {
    print('  left: ${divSimp.left} (${divSimp.left.runtimeType})');
    if (divSimp.left is Multiply) {
      final l = divSimp.left as Multiply;
      print('    left.left: ${l.left} (${l.left.runtimeType})');
      if (l.left is Literal) print('      value: ${(l.left as Literal).value} (${(l.left as Literal).value.runtimeType})');
      print('    left.right: ${l.right} (${l.right.runtimeType})');
      if (l.right is Literal) print('      value: ${(l.right as Literal).value} (${(l.right as Literal).value.runtimeType})');
    }
    if (divSimp.left is Literal) {
      print('    value: ${(divSimp.left as Literal).value} (${(divSimp.left as Literal).value.runtimeType})');
    }
    print('  right: ${divSimp.right} (${divSimp.right.runtimeType})');
  }
  if (divSimp is Literal) {
    print('  value: ${(divSimp as Literal).value} (${(divSimp as Literal).value.runtimeType})');
  }

  // Test the full quadratic  
  print('\n=== Full quadratic ===');
  final quad = Quadratic(a: Literal(2), b: Literal(0), c: Literal(1));
  final roots = quad.roots();
  print('roots length: ${roots.length}');
  for (int i = 0; i < roots.length; i++) {
    print('root[$i] = ${roots[i]} (${roots[i].runtimeType})');
    if (roots[i] is Multiply) {
      final r = roots[i] as Multiply;
      print('  left: ${r.left} (${r.left.runtimeType})');
      print('  right: ${r.right} (${r.right.runtimeType})');
    }
  }
}
