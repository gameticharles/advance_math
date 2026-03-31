import 'package:advance_math/advance_math.dart';

void main() {
  var A = Matrix([
    [4, 1, -1],
    [1, 4, -1],
    [-1, -1, 4]
  ]);
  print('Max: ${A.max()}');
  print('Column Max: ${A.max(axis: 0)}');
  print('Row Max: ${A.max(axis: 1)}');
  print('Min: ${A.min()}');
  print('Column Min: ${A.min(axis: 0)}');
  print('Row Min: ${A.min(axis: 1)}');
  print('Sum: ${A.sum()}');
  print('Absolute Sum: ${A.sum(absolute: true)}');
  print('Column Sum: ${A.sum(axis: 0)}');
  print('Row Sum: ${A.sum(axis: 1)}');
  print('Diagonal Sum: ${A.sum(axis: 2)}');
  print('Diagonal Sum TLBR: ${A.sum(axis: 3)}');
  print('Diagonal Sum TRBL: ${A.sum(axis: 4)}');
  print('Mean: ${A.mean()}');
  print('Median: ${A.median()}');
  print('Product: ${A.product()}');
  print('Variance: ${A.variance()}');
  print('Standard Deviation: ${A.standardDeviation()}');
}
