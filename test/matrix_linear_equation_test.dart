import 'package:advance_math/advance_math.dart';
import 'package:test/test.dart';

void main() {
  var res = Matrix([
    [1],
    [7],
    [6]
  ]);
  Matrix A = Matrix([
    [4, 1, -1],
    [1, 4, -1],
    [-1, -1, 4]
  ]);
  Matrix b = Matrix([
    [6],
    [25],
    [14]
  ]);

  test('Inverse Matrix', () {
    expect(A.linear.solve(b, method: LinearSystemMethod.inverseMatrix).round(),
        res);
  });

  test('LU Decomposition', () {
    expect(
        A.linear.solve(b, method: LinearSystemMethod.luDecomposition).round(),
        res);
  });

  test('Gauss-Jordan Elimination', () {
    expect(
        A.linear
            .solve(b, method: LinearSystemMethod.gaussJordanElimination)
            .round(),
        res);
  });

  test('Ridge Regression', () {
    expect(
        A.linear.solve(b, method: LinearSystemMethod.ridgeRegression).round(),
        res);
  });

  test('Gauss Elimination', () {
    expect(
        A.linear.solve(b, method: LinearSystemMethod.gaussElimination).round(),
        res);
  });

  test('Least Squares', () {
    expect(A.linear.solve(b, method: LinearSystemMethod.leastSquares).round(),
        res);
  });

  test('Jacobi', () {
    expect(A.linear.solve(b, method: LinearSystemMethod.jacobi).round(), res);
  });

  test('Successive Over-Relaxation (SOR)', () {
    expect(A.linear.solve(b, method: LinearSystemMethod.sor).round(), res);
  });

  test('Gauss-Seidel method', () {
    expect(
        A.linear.solve(b, method: LinearSystemMethod.gaussSeidel).round(), res);
  });

  test('Gram Schmidt method', () {
    expect(
        A.linear.solve(b, method: LinearSystemMethod.gramSchmidt).round(), res);
  });

  test('Conjugate Gradient', () {
    expect(
        A.linear.solve(b, method: LinearSystemMethod.conjugateGradient).round(),
        res);
  });

  test('Montante\'s Method (Bareiss algorithm)', () {
    expect(A.linear.solve(b, method: LinearSystemMethod.bareiss).round(), res);
  });

  test('Cramers Rule', () {
    expect(
        A.linear.solve(b, method: LinearSystemMethod.cramersRule).round(), res);
  });
}
