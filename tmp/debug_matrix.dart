import 'package:advance_math/advance_math.dart';

void main() {
  var A = Matrix([
    [4, 1, -1],
    [1, 4, -1],
    [-1, -1, 4]
  ]);
  
  try {
    print(A);
    print('Shape: ${A.shape}');
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
    print('Absolute Sum: ${A.sum(absolute: true)}');
    print('Determinant: ${A.determinant()}');
    print('Rank: ${A.rank()}');
    print('Trace: ${A.trace()}');
    print('Skewness: ${A.skewness()}');
    print('Kurtosis: ${A.kurtosis()}');
    print('Condition number: ${A.conditionNumber()}');
    print('Decomposition Condition number: ${A.decomposition.conditionNumber()}');

    print('Manhattan Norm(l1Norm): ${A.norm(Norm.manhattan)}');
    print('Frobenius/Euclidean Norm(l2Norm): ${A.norm(Norm.frobenius)}');
    print('Chebyshev/Infinity Norm: ${A.norm(Norm.chebyshev)}');
    print('Spectral Norm: ${A.norm(Norm.spectral)}');
    print('Trace/Nuclear Norm: ${A.norm(Norm.trace)}');
    print('Nullity: ${A.nullity()}');

    print('Normalize: ${A.normalize()}\n');
    print('Frobenius/Euclidean Normalize: ${A.normalize(Norm.frobenius)}\n');
    print('Row Echelon Form: ${A.rowEchelonForm()}\n');
    print('Reduced Row Echelon Form: ${A.reducedRowEchelonForm()}\n');
    print('Null Space: ${A.nullSpace()}\n');
    print('Row Space: ${A.rowSpace()}\n');
    print('Column Space: ${A.columnSpace()}\n');
    print('Matrix Properties:');
    A.matrixProperties().forEach((element) => print(' - $element'));
  } catch (e, s) {
    print('CAUGHT: $e');
    print(s);
  }
}
