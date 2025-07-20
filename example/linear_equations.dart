import 'package:advance_math/advance_math.dart';

void main() {
  var mat = Matrix([
    [4.0, 2.0, 1.0],
    [16.0, 4.0, 1.0],
    [64.0, 8.0, 1.0]
  ]);

  // var eMat1 = Matrix("-26 -32 -25; 31 42 23; -11 -15 -4");
  // var eMat2 = Matrix([
  //   [1, 2, 3, 4],
  //   [5, 6, 7, 8],
  //   [9, 10, 11, 12],
  //   [13, 14, 15, 16]
  // ]);

  print('Properties of the Matrix:\n$mat\n');
  mat.matrixProperties().forEach((element) => print(' - $element'));

  var A = Matrix([
    [-7, -2, 9, 4],
    [-4, -9, 3, 0],
    [-3, 4, 6, -2],
    [6, 7, -4, -8]
  ]);

  // var A = Matrix('4 4 ; -3 3');
  var svd = A.decomposition.singularValueDecomposition();

  print(svd.S);
  print(svd.U);
  print(svd.V);
  print(svd.checkMatrix.round(1));

  printLine();
  var matrix = Matrix([
    [1, 2],
    [3, 4]
  ]);

  var result = matrix.inverse();
  print(matrix.isSingularMatrix());
  print(result.round(1));

  printLine();

  Matrix a = Matrix([
    [1, 2],
    [3, 4],
    [5, 6]
  ]);

  svd = a.decomposition.singularValueDecomposition();
  var S = svd.S;
  var U = svd.U;
  var V = svd.V;
  print('S = $S');
  print('U = $U');
  print('V = $V');
  print(svd.checkMatrix.round(1));

  printLine("Try inverse");

  print(a.inverse());

  printLine("Try pseudo inverse");

  Matrix aPseudoInverse = a.pseudoInverse();
  print(aPseudoInverse);
}
