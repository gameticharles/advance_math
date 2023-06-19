import 'package:advance_math/advance_math.dart';

void printLine(String s) {
  var l = '--- ' * 10;
  print('\n$l$s $l\n');
}

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

  // var A = Matrix([
  //   [-7, -2, 9, 4],
  //   [-4, -9, 3, 0],
  //   [-3, 4, 6, -2],
  //   [6, 7, -4, -8]
  // ]);

  var A = Matrix('4 4 ; -3 3');
  var eig = A.decomposition.singularValueDecomposition();

  print(eig.S);
  print(eig.U);
  print(eig.V);
  print(eig.checkMatrix);
}
