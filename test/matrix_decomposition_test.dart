import 'package:advance_math/advance_math.dart';
import 'package:test/test.dart';

void main() {
  test('QR decomposition Gram Schmidt', () {
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

    var qr = A.decomposition.qrDecompositionGramSchmidt();
    expect(qr.checkMatrix.round(), A,
        reason: 'Check matrix if the result can reconstruct the matrix A');
    expect(
        qr.solve(b).round(),
        Matrix([
          [1],
          [7],
          [6]
        ]),
        reason: 'Solve linear equation');
  });

  test('QR decomposition Householder', () {
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

    var qr = A.decomposition.qrDecompositionHouseholder();
    expect(qr.checkMatrix.round(), A,
        reason: 'Check matrix if the result can reconstruct the matrix A');
    expect(
        qr.solve(b).round(),
        Matrix([
          [1],
          [7],
          [6]
        ]),
        reason: 'Solve linear equation');
  });

  test('LQ decomposition', () {
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

    var lq = A.decomposition.lqDecomposition();
    expect(lq.checkMatrix.round(), A,
        reason: 'Check matrix if the result can reconstruct the matrix A');
    expect(
        lq.solve(b).round(),
        Matrix([
          [1],
          [8],
          [6]
        ]),
        reason: 'Solve linear equation');
  });

  test('Cholesky Decomposition', () {
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

    var cho = A.decomposition.choleskyDecomposition();
    expect(cho.checkMatrix.round(), A,
        reason: 'Check matrix if the result can reconstruct the matrix A');
    expect(
        cho.solve(b).round(),
        Matrix([
          [1],
          [7],
          [6]
        ]),
        reason: 'Solve linear equation');
  });

  test('Eigenvalue Decomposition', () {
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

    var egd = A.decomposition.eigenvalueDecomposition();
    expect(egd.checkMatrix.round(), A,
        reason: 'Check matrix if the result can reconstruct the matrix A');
    expect(
        egd.solve(b).round(),
        Matrix([
          [1],
          [7],
          [6]
        ]),
        reason: 'Solve linear equation');
  });

  test('Singular Value Decomposition', () {
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

    var svd = A.decomposition.singularValueDecomposition();
    expect(svd.checkMatrix.round(), A);
    expect(
        svd.solve(b).round(),
        Matrix([
          [1],
          [7],
          [6]
        ]));
  });

  test('Schur Decomposition', () {
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

    var schur = A.decomposition.schurDecomposition();
    expect(schur.checkMatrix.round(), A);
    expect(
        schur.solve(b).round(),
        Matrix([
          [1],
          [7],
          [6]
        ]));
  });

  test('LU Decomposition Doolittle\'s algorithm', () {
    Matrix A = Matrix([
      [4.0, 2.0, 1.0],
      [16.0, 4.0, 1.0],
      [64.0, 8.0, 1.0]
    ]);
    Matrix b = Column([106.8, 177.2, 279.2]);

    var lu = A.decomposition.luDecompositionDoolittle();
    expect(lu.checkMatrix.round(), A);
    expect(
        lu.solve(b).round(),
        Matrix([
          [-2],
          [45],
          [23]
        ]));
  });

  test('LU Decomposition Doolittle Partial Pivoting', () {
    Matrix A = Matrix([
      [4.0, 2.0, 1.0],
      [16.0, 4.0, 1.0],
      [64.0, 8.0, 1.0]
    ]);
    Matrix b = Column([106.8, 177.2, 279.2]);

    var lu = A.decomposition.luDecompositionDoolittlePartialPivoting();
    expect(lu.checkMatrix.round(), A);
    expect(
        lu.solve(b).round(),
        Matrix([
          [-2],
          [45],
          [23]
        ]));
  });

  test('LU Decomposition Doolittle Complete Pivoting', () {
    Matrix A = Matrix([
      [4.0, 2.0, 1.0],
      [16.0, 4.0, 1.0],
      [64.0, 8.0, 1.0]
    ]);
    Matrix b = Column([106.8, 177.2, 279.2]);

    var lu = A.decomposition.luDecompositionDoolittleCompletePivoting();

    expect(lu.checkMatrix.round(), A);
    expect(
        lu.solve(b).round(),
        Matrix([
          [-2],
          [45],
          [23]
        ]));
  });

  test('LU Decomposition Crout', () {
    Matrix A = Matrix([
      [4.0, 2.0, 1.0],
      [16.0, 4.0, 1.0],
      [64.0, 8.0, 1.0]
    ]);
    Matrix b = Column([106.8, 177.2, 279.2]);

    var lu = A.decomposition.luDecompositionCrout();
    expect(lu.checkMatrix.round(), A);
    expect(
        lu.solve(b).round(),
        Matrix([
          [-2],
          [45],
          [23]
        ]));
  });

  test('LU Decomposition Gauss', () {
    Matrix A = Matrix([
      [4.0, 2.0, 1.0],
      [16.0, 4.0, 1.0],
      [64.0, 8.0, 1.0]
    ]);
    Matrix b = Column([106.8, 177.2, 279.2]);

    var lu = A.decomposition.luDecompositionGauss();
    expect(lu.checkMatrix.round(), A);
    expect(
        lu.solve(b).round(),
        Matrix([
          [-2],
          [45],
          [23]
        ]));
  });
}
