import 'package:advance_math/advance_math.dart';

void main(List<String> args) {
  /*
  
  */
  var A = Matrix([
    [1, 0, 0],
    [0, 1, 0],
    [0, 0, 1],
    [-1, 1, 0],
    [-1, 0, 1],
    [0, -1, 1],
  ]);

  var B = ColumnMatrix([0, 0, 0, -0.015, 0.102, 0.097]);
  var W = DiagonalMatrix([1 / 5, 1 / 10, 1 / 7, 1 / 7, 1 / 12, 1 / 9]);

  print('Design Matrix (A): \n$A\n');
  print('Matrix of Absolute Terms (B): \n$B\n');
  print('Weight (W): \n${W.round(5)}\n');

  var x = (A.transpose() * W * A).inverse() * (A.transpose() * W * B);
  print('Unknown Errors (x): \n$x\n');

  var V = B - A * x;
  print('Residuals (V): \n$V\n');

  var dV = (V.transpose() * W * V);
  var s = dV / (A.rowCount - A.columnCount);
  print('Unit Variance (𝛔^2): \n$s\n');

  var lsq = LeastSquares(A, B, W, method: EquationMethod.linear);
  lsq.fit();

  print('Unknown Errors (x): \n${lsq.beta}\n');
  print('Residuals (V): \n${lsq.residuals}\n');
  print('Unit Variance (𝛔^2): \n${lsq.unitVariance()}\n');
  print('Covariance: \n${lsq.covariance().round(6)}\n');
  print('Standard Deviation: \n${lsq.standardDeviation()}\n');
  print('Standard Error: \n${lsq.standardError()}\n');
  print('Confidence Level: \n${lsq.confidenceLevel()}\n');
  print('Detect Outliers 95% CL: \n${lsq.detectOutliers(0.95)}\n');
}
