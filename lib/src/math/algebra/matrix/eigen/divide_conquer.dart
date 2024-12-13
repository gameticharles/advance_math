part of '../../algebra.dart';

class DivideAndConquer {
  // Helper function: Tridiagonalization
  Matrix tridiagonalize(Matrix A) {
    return A.tridiagonalize();
  }

  // Helper function: Find a suitable pivot
  int findPivot(Matrix T) {
    int n = T.rowCount;

    // Find the smallest off-diagonal element in the last row
    int pivot = n - 2;
    double minValue = (T[n - 1][n - 2] as num).toDouble().abs();

    for (int i = n - 3; i >= 0; i--) {
      double value = (T[n - 1][i] as num).toDouble().abs();
      if (value < minValue) {
        minValue = value;
        pivot = i;
      }
    }

    return pivot;
  }

  // Helper function: Solve eigenvalue problems for smaller matrices
  Eigen solveSmallEigenProblem(Matrix T) {
    T = _Utils.toNumMatrix(T);
    int n = T.rowCount;
    if (n == 1) {
      // For 1x1 matrices, the eigenvalue is the only element
      double eigenvalue = T[0][0];
      Matrix eigenvector = Matrix.eye(1, isDouble: true);
      return Eigen([eigenvalue], [eigenvector]);
    } else if (n == 2) {
      // For 2x2 matrices, use the analytical formula to find eigenvalues
      double a = T[0][0];
      double b = T[0][1];
      double c = T[1][0];
      double d = T[1][1];

      double trace = a + d;
      double determinant = a * d - b * c;
      double sqrtTerm = math.sqrt(trace * trace - 4 * determinant);

      double lambda1 = (trace + sqrtTerm) / 2;
      double lambda2 = (trace - sqrtTerm) / 2;

      Matrix eigenvector1 = Matrix.fromList([
        [-b / (a - lambda1)],
        [1]
      ]);
      Matrix eigenvector2 = Matrix.fromList([
        [-b / (a - lambda2)],
        [1]
      ]);

      return Eigen([lambda1, lambda2], [eigenvector1, eigenvector2]);
    } else {
      // For larger matrices, call the divideAndConquer() function recursively
      return divideAndConquer(T);
    }
  }

  // Helper function: Combine eigenvectors
  List<Matrix> combineEigenvectors(List<Matrix> w1, List<Matrix> w2, Matrix P) {
    int n1 = w1.length;
    int n2 = w2.length;

    List<Matrix> combinedEigenvectors = [];

    // For each eigenvector in w1 and w2, create a new eigenvector as a linear
    // combination of the eigenvectors in w1 and w2 using the columns of the P matrix
    for (int i = 0; i < n1; i++) {
      Matrix newEigenvector =
          (P.slice(0, P.rowCount + 1, 0, n1 + 1)).transpose() * w1[i];
      combinedEigenvectors.add(newEigenvector);
    }

    for (int i = 0; i < n2; i++) {
      Matrix newEigenvector =
          (P.slice(0, P.rowCount + 1, n1, P.columnCount + 1)).transpose() *
              w2[i];
      combinedEigenvectors.add(newEigenvector);
    }

    return combinedEigenvectors;
  }

  // The main function for the Divide-and-Conquer algorithm.
  Eigen divideAndConquer(Matrix A) {
    A = _Utils.toNumMatrix(A);
    // Step 1: Tridiagonalization
    Matrix T = tridiagonalize(A);
    Matrix P =
        A; // Assuming tridiagonalize() returns the transformation matrix P

    // Step 2: Divide
    int pivot = findPivot(T);
    Matrix t1 = T.slice(0, 1, pivot + 1, pivot + 2);
    Matrix t2 = T.slice(
        pivot + 1, pivot + 2, T.rowCount - pivot - 1, T.columnCount - pivot);

    // Step 3: Conquer
    Eigen eigen1 = solveSmallEigenProblem(t1);
    Eigen eigen2 = solveSmallEigenProblem(t2);
    print(eigen1.values);

    // Step 4: Combine
    List<Matrix> combinedEigenvectors =
        combineEigenvectors(eigen1.vectors, eigen2.vectors, P);

    // Step 5: Reconstruction
    List<double> eigenvalues = [];
    eigenvalues.addAll(eigen1.values);
    eigenvalues.addAll(eigen2.values);

    return Eigen(eigenvalues, combinedEigenvectors);
  }
}
