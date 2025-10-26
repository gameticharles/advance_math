library large_number_library;

import 'dart:math';
import 'dart:core';

part 'config.dart';
part 'hyperoperations.dart';
part 'symbolic_base.dart';
part 'ackermann.dart';
part 'tree.dart';
part 'graham.dart';
part 'busy_beaver.dart';
part 'utils.dart';

/// ===============================
///  DEMONSTRATION
/// ===============================

void main() {
  print('╔════════════════════════════════════════╗');
  print('║   LARGE NUMBER COMPUTATION LIBRARY v3   ║');
  print('║    (Concrete + Symbolic Unified)        ║');
  print('╚════════════════════════════════════════╝');

  ComputeConfig.verboseMode = true;

  print('\n=== CONCRETE COMPUTATIONS ===');
  print('addition(5, 7) = ${addition(BigInt.from(5), BigInt.from(7))}');
  print(
      'multiplication(5, 7) = ${multiplication(BigInt.from(5), BigInt.from(7))}');
  print('expInt(2, 10) = ${expInt(BigInt.from(2), BigInt.from(10))}');
  print('tetration(3, 3) = ${tetration(BigInt.from(3), 3)}');
  print('pentation(2, 4) = ${pentation(BigInt.from(2), 4)}');
  print('hyperop(2, 3, 4) = ${hyperop(BigInt.from(2), 3, 4)}');

  print('\n=== SYMBOLIC EXPRESSIONS ===');
  final expr1 = Symbolic.tet(Symbolic.num(3), Symbolic.num(4));
  print(
      '${expr1.toExpression()} → ${expr1.isComputable ? "computable" : "symbolic only"}');

  final expr2 = Symbolic.graham(1);
  print('${expr2.toExpression()} → ${expr2.toDescription()}');

  final expr3 = Symbolic.tree(3);
  print('${expr3.toExpression()} → ${expr3.toDescription()}');

  print('\n=== ACKERMANN ===');
  print(Ackermann.describe(3, 4));
  print(Ackermann.describe(4, 2));

  print('\n=== GRAHAM\'S NUMBER ===');
  print(GrahamNumber.describe());

  print('\n=== BUSY BEAVER ===');
  print(BusyBeaver.describe());

  print('\n=== TREE FUNCTION ===');
  print(TreeFunction.visualExample());
  print(TreeFunction.describe(3));

  print('\n=== SYMBOLIC CHAIN ===');
  final chain = [
    Symbolic.pow(Symbolic.num(3), Symbolic.num(3)),
    Symbolic.tet(Symbolic.num(3), Symbolic.num(3)),
    Symbolic.pent(Symbolic.num(3), Symbolic.num(3)),
    Symbolic.ackermann(4, 4),
    Symbolic.graham(1),
    Symbolic.graham(),
    Symbolic.tree(3),
  ];

  for (var num in chain) {
    final val = num.tryCompute();
    print(
        '${num.toExpression().padRight(12)} → ${val?.toCompactString() ?? "[symbolic]"}');
  }

  GrowthComparison.compareAll();
  GrowthComparison.showKnownValues();

  print('\n=== CACHE STATS ===');
  CacheStats.show();
}
