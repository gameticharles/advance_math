import 'package:advance_math/advance_math.dart';

void main(List<String> args) {
  Matrix A = Matrix.fromList([
    [0, 1, 1],
    [2, 1, 0],
    [3, 4, 5]
  ]);

  final B = Matrix.fromList([
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
  ]);

  print(A);
  print(B);
  print(A.rank());

  Decomposition dec = B.decomposition.luDecompositionDoolittle();
  print(dec);
  print(dec.checkMatrix);

  final C = Matrix([
    [0, 1, 1],
    [2, 1, 0],
    [3, 4, 5]
  ]);
  dec = C.decomposition.eigenvalueDecomposition();
  print(dec);
  print(dec.checkMatrix);
}
