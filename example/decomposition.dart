import 'package:advance_math/advance_math.dart';

void main() {
  var mat = Matrix([
    [4.0, 2.0, 1.0],
    [16.0, 4.0, 1.0],
    [64.0, 8.0, 1.0]
  ]);
  var b = ColumnMatrix([106.8, 177.2, 279.2]);

  Matrix A = Matrix([
    [4, 1, -1],
    [1, 4, -1],
    [-1, -1, 4]
  ]);
  Matrix b0 = Matrix.fromList([
    [6],
    [25],
    [14]
  ]);

  printLine('Properties of the Matrix');
  print('\n$mat\n');
  print('\nInverse:\n${mat.inverse()}\n');
  print('l1Norm: ${mat.norm(Norm.manhattan)}');
  print('l2Norm: ${mat.norm()}');
  print('Rank: ${mat.rank()}');
  print('Determinant: ${mat.determinant()}');
  print('Trace: ${mat.trace()}');
  print('Condition number: ${mat.conditionNumber()}');
  mat.matrixProperties().forEach((element) => print(' - $element'));

  print('\n\n$A\n');
  print('\nInverse:\n${A.inverse()}\n');
  print('l1Norm: ${A.norm(Norm.manhattan)}');
  print('l2Norm: ${A.norm()}');
  print('Rank: ${A.rank()}');
  print('Determinant: ${A.determinant()}');
  print('Trace: ${A.trace()}');
  print('Condition number: ${A.conditionNumber()}');
  print('Decomposition Condition number: ${A.decomposition.conditionNumber()}');
  A.matrixProperties().forEach((element) => print(' - $element'));

  print(A.rowEchelonForm());
  print(A.reducedRowEchelonForm());

  printLine('Solve linear Equations');

  print('Solve Decomposition: ${mat.decomposition.solve(b)}\n');

  printLine('QR decomposition Gram Schmidt');
  var qr1 = A.decomposition.qrDecompositionGramSchmidt();
  print(qr1.Q);
  print(qr1.R);
  print(qr1.Q.isOrthogonalMatrix());
  print(qr1.R.isUpperTriangular());
  print(qr1.checkMatrix);
  print(qr1.solve(b0));
  print(A.isAlmostEqual(qr1.checkMatrix));

  printLine('QR decomposition Householder');

  var qr2 = A.decomposition.qrDecompositionHouseholder();
  print(qr2.Q);
  print(qr2.R);
  print(qr2.Q.isOrthogonalMatrix());
  print(qr2.R.isUpperTriangular());
  print(qr2.checkMatrix);
  print(qr2.solve(b0));

  printLine('LQ decomposition');

  var lq = A.decomposition.lqDecomposition();
  print("L:\n ${lq.L}");
  print("Q:\n ${lq.Q}");
  print(lq.checkMatrix);
  print(lq.solve(b0));

  printLine('Cholesky Decomposition');

  var choleskyDec = A.decomposition.choleskyDecomposition();
  print('L:\n${choleskyDec.L}\n');
  print('isLowerTriangular: ${A.isLowerTriangular()}');
  print('isPositiveDefiniteMatrix: ${A.isPositiveDefiniteMatrix()}');
  print(choleskyDec.checkMatrix);
  print(choleskyDec.solve(b0));

  printLine('Eigenvalue Decomposition');

  var egd = A.decomposition.eigenvalueDecomposition();
  print("D:\n ${egd.D}");
  print("V:\n ${egd.V}");
  //print(egd.verify(b0));
  print(egd.checkMatrix);

  egd = EigenvalueDecompositions.decompose(mat);
  print("\n\nD:\n ${egd.D}");
  print("V:\n ${egd.V}");
  //print(egd.verify(b0));
  print(egd.checkMatrix);

  printLine('Single Value Decomposition');

  var svd = A.decomposition.singularValueDecomposition();
  print("U:\n ${svd.U}");
  print("S:\n ${svd.S}");
  print("V:\n ${svd.V}");
  print(svd.checkMatrix.round());
  print("Is equal to original: ${A.isAlmostEqual(svd.checkMatrix.round())}");
  print(svd.solve(b0));

  Matrix positiveDefiniteMatrix = Matrix([
    [3, -1, 1],
    [-1, 3, 1],
    [1, 1, 2]
  ]);
  svd = positiveDefiniteMatrix.decomposition.singularValueDecomposition();
  print(svd);
  print(svd.checkMatrix.round());
  print("Is equal to original: ${positiveDefiniteMatrix.isAlmostEqual(svd.checkMatrix.round())}");


  printLine('Schur Decomposition');

  // Note: It is generally preferable to use other decomposition methods, such
  // as LU or QR decomposition, to solve linear systems, as they are specifically
  // designed for this purpose.
  var schur = A.decomposition.schurDecomposition();
  print("T:\n ${schur.T}");
  print("Q:\n ${schur.Q}");
  print("isOrthogonalMatrix: ${schur.isOrthogonalMatrix}");
  print(schur.checkMatrix);
  print(schur.solve(b0));

  printLine('LU Decomposition Doolittle\'s algorithm');

  var lud = mat.decomposition.luDecompositionDoolittle();
  print("L:\n ${lud.L}");
  print("U:\n ${lud.U}");
  print(lud.checkMatrix);
  print(lud.solve(b));

  printLine('LU Decomposition Doolittle Partial Pivoting');

  lud = mat.decomposition.luDecompositionDoolittlePartialPivoting();
  print("L:\n ${lud.L}");
  print("U:\n ${lud.U}");
  print("P:\n ${lud.P}");
  print(lud.checkMatrix);
  print(lud.solve(b));

  printLine('LU Decomposition Doolittle Complete Pivoting');

  lud = mat.decomposition.luDecompositionDoolittleCompletePivoting();
  print("L:\n ${lud.L}");
  print("U:\n ${lud.U}");
  print("P:\n ${lud.P}");
  print("Q:\n ${lud.Q}");
  print(lud.checkMatrix);
  print(lud.solve(b));

  printLine('LU Decomposition Crout');

  lud = mat.decomposition.luDecompositionCrout();
  print("L:\n ${lud.L}");
  print("U:\n ${lud.U}");
  print(lud.checkMatrix);
  print(lud.solve(b));

  printLine('LU Decomposition Gauss');

  lud = mat.decomposition.luDecompositionGauss();
  print("L:\n ${lud.L}");
  print("U:\n ${lud.U}");
  print("P:\n ${lud.P}");
  print(lud.checkMatrix);
  print(lud.solve(b));
}
