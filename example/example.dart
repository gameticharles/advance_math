import 'dart:collection';

import 'package:advance_math/advance_math.dart';

void printLine(String s) {
  var l = '--- ' * 10;
  print('\n$l$s $l\n');
}

bool testMagic(Matrix ms) {
  int n = ms.rowCount;
  int s = n * ((n * n) + 1) ~/ 2;

  bool diag1 = ms.diagonal().reduce((a, b) => a + b) == s;
  bool diag2 = ms
          .applyToRows((row) => row.reversed.toList())
          .diagonal()
          .reduce((a, b) => a + b) ==
      s;
  bool columns = ms.sum(axis: 0).every((sum) => sum == s);
  bool rows = ms.sum(axis: 1).every((sum) => sum == s);

  return columns && rows && diag1 && diag2;
}

void main() {
  var mat = Matrix.fromList([
    [2, 3, 3, 3],
    [9, 9, 8, 6],
    [1, 1, 2, 9]
  ]);

  var eMat = Matrix('1 2 3 4; 2 5 6 7; 3 6 8 9; 4 7 9 10');

  var ang = Length.inUnits(360.14554, LengthUnits.miles);
  print(ang.valueInUnits(LengthUnits.kilometers));

  printLine('Spherical Triangle');
  // Define a spherical triangle with one angle-side pair
  //var triangle = SphericalTriangle(a: pi / 2, b: pi / 2, c: pi / 2);
  var triangle = SphericalTriangle.fromAllSides(
    Angle(rad: pi / 2),
    Angle(rad: pi / 3),
    Angle(rad: pi / 4),
  );

  // Angles
  print('AngleA: ${triangle.angleA} ');
  print('AngleB: ${triangle.angleB} ');
  print('AngleC: ${triangle.angleC}');

  // Sides
  print('SideA: ${triangle.sideA}');
  print('SideB: ${triangle.sideB}');
  print('SideC: ${triangle.sideC} ');

  print(
      'Area: ${triangle.area} ≈ ${triangle.areaPercentage} % of unit sphere surface area');
  print(
      'Perimeter: ${triangle.perimeter} ≈ ${triangle.perimeterPercentage} % of unit sphere circumference');
  print('isValidTriangle: ${triangle.isValidTriangle()}');

  printLine('Test Vectors');

  //It's possible to use vector instances as keys for HashMap and
  //similar data structures and to look up a value by the vector-key,
  //since the hash code for equal vectors is the same
  final map = HashMap<Vector, bool>();

  map[Vector.fromList([1, 2, 3, 4, 5])] = true;

  print(map[Vector.fromList([1, 2, 3, 4, 5])]); // true
  print(Vector.fromList([1, 2, 3, 4, 5]).hashCode ==
      Vector.fromList([1, 2, 3, 4, 5]).hashCode); // true

  var xx = Vector([1, 2, 3, 4]);
  var yy = Vector([4, 5]);
  print('');
  print(xx.outerProduct(yy));

  print(-Vector([1, 2, 3]) + mat);

  print(xx * mat + xx.subVector(end: xx.length - 2));

  //Vector operations
  final vector1 = Vector([1.0, 2.0, 3.0, 4.0, 5.0]);
  final vector2 = Vector.fromList([2.0, 3.0, 4.0, 5.0, 6.0]);
  final result1 = vector1.distance(vector2, distance: DistanceType.cosine);
  print(result1); // 0.00506

  var result = vector1.normalize();
  print(result.round(3)); // [0.135, 0.270, 0.405, 0.539, 0.674]

  final vector = Vector.fromList([1.0, -2.0, 3.0, -4.0, 5.0]);
  result = vector.normalize(Norm.manhattan);
  print(result.round(3)); // [0.067, -0.133, 0.200, -0.267, 0.333]

  var result2 = vector1.rescale();
  print(result2); // [0.0, 0.25, 0.5, 0.75, 1.0]

  var vector3 = Vector.fromList([4.0, 5.0, 6.0, 7.0, 8.0]);
  result = vector3 - [2.0, 3.0, 2.0, 3.0, 2.0];
  print(result); // [2.0, 2.0, 4.0, 4.0, 6.0]

  var A = Matrix("1 2 3 4; 2 5 6 7; 3 6 8 9; 4 7 9 10");
  print(A);

  print('Shape: ${A.shape}');
  print('Max: ${A.max()}');
  print('Min: ${A.min()}');
  print('Sum: ${A.sum()}');
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
  print('Manhattan Norm(l1Norm): ${A.norm(Norm.manhattan)}');
  print('Frobenius/Euclidean Norm(l2Norm): ${A.norm(Norm.frobenius)}');
  print('Chebyshev/Infinity Norm: ${A.norm(Norm.chebyshev)}');
  print('Spectral Norm: ${A.norm(Norm.spectral)}');
  print('Trace/Nuclear Norm: ${A.norm(Norm.trace)}');
  print('Nullity: ${A.nullity()}');

  print('\nRow Echelon Form:\n${A.rowEchelonForm()}\n');
  print('Reduced Row Echelon Form:\n${A.reducedRowEchelonForm()}\n');
  print('Null Space:\n${A.nullSpace()}\n');
  print('Row Space:\n${A.rowSpace()}\n');
  print('Column Space:\n${A.columnSpace()}\n');

  printLine('Broadcast and Replicate Matrix');
  var newMats = mat.broadcast(Matrix("1;2;3"));
  for (var newMat in newMats) {
    print(newMat);
  }

  //Replicate the matrix
  print('\n\n${Matrix("1;2;3").replicateMatrix(6, 3)}');

  printLine('Random Matrix');
  var randMat = Matrix.random(5, 4);
  print(randMat.round(3));

  randMat = Matrix.factory.create(MatrixType.general, 5, 4,
      min: 0, max: 3, seed: 12, isDouble: true);
  print('\n${randMat.round(3)}');

  randMat = Matrix.factory
      .create(MatrixType.general, 5, 4, min: 0, max: 3, isDouble: true);
  print('\n${randMat.round(3)}');

  randMat = Matrix.factory.create(MatrixType.sparse, 5, 5,
      min: 0, max: 2, seed: 12, isDouble: true);

  print('\nProperties of the Matrix:\n${randMat.round(3)}\n');
  randMat.matrixProperties().forEach((element) => print(' - $element'));

  printLine('Matrix Properties');

  print('Properties of the Matrix:\n$eMat\n');
  eMat.matrixProperties().forEach((element) => print(' - $element'));

  printLine('SubMatrix or Partition of Matrix');

  var sliceArray = Matrix([
    [1, 2, 3, 4, 5],
    [6, 7, 8, 9, 10],
    [6, 7, 8, 9, 10]
  ]);

  var newArray = sliceArray.slice(0, 2, 1, 4);
  print(" sliced array: $newArray");

  newArray = sliceArray.subMatrix(
    rowStart: 0,
    rowEnd: 2,
    colStart: 1,
    colEnd: 4,
  );
  print("\nsub array: $newArray");

  newArray = sliceArray.subMatrix(
    columnIndices: [4, 4, 2],
  );
  print("\nsub array: $newArray");

  printLine('Eigen matrix');

  var matr = Matrix.fromList([
    [4, 1, 1],
    [1, 4, 1],
    [1, 1, 4]
  ]);

  var eigen = matr.eigen();
  print('Eigen Values:\n${eigen.values}\n');
  print('Eigenvectors:');
  for (Matrix eigenvector in eigen.vectors) {
    print(eigenvector.round(1));
  }
  print('Verification: ${eigen.verify(matr)}');
  print('Reconstruct Original:\n ${eigen.check}');

  List<Matrix> normalizedEigenvectors =
      eigen.vectors.map((vector) => vector.normalize()).toList();
  Eigen normalizedEigen = Eigen(eigen.values, normalizedEigenvectors);

  print('Normalized eigenvectors:');
  for (Matrix eigenvector in normalizedEigen.vectors) {
    print(eigenvector.round());
  }
  print('Reconstruct Original:\n ${normalizedEigen.check}');

  eigen = Eigen([
    6,
    3,
    3
  ], [
    Matrix([
      [1],
      [1],
      [1]
    ]),
    Matrix([
      [-1],
      [0],
      [1]
    ]),
    Matrix([
      [-1],
      [1],
      [0]
    ]),
  ]);
  print('Check Matrix: ${eigen.check}');

  // eigen = DivideAndConquer().divideAndConquer(eMat);
  // print('Eigen Values:\n${eigen.values}\n');
  // print('Eigen Values:\n${eigen.vectors}\n');
  // print('Check: ${eigen.verify(eMat)}');

  printLine('Element Search');
  var y = mat.where(
    (value) => value.contains(6),
  );
  print('Rows that contains 6:\n$y');

  printLine('Iterate through rows');
  // Iterate through the rows of the matrix using the default iterator
  for (List<dynamic> row in mat.rows) {
    print(row);
  }

  printLine('Iterate through columns');
  // Iterate through the columns of the matrix using the column iterator
  for (List<dynamic> column in mat.columns) {
    print(column);
  }
  printLine('Iterate through elements');
  // Iterate through the elements of the matrix using the element iterator
  for (dynamic element in mat.elements) {
    print(element);
  }

  printLine('Access Row and Column');

  print(mat);

  // Change element value
  mat[0][0] = 3;

  // Access item
  print('\nmat[1][2]: ${mat[1][2]}'); // 8

  // Access row
  print('Access row 0');
  print(mat[0]);
  print(mat.row(0));

  // Access column
  print(mat.column(0));

  // update row method 1
  mat[0] = [1, 2, 3, 4];
  print(mat);

  // update row method 2
  var v = mat.setRow(0, [4, 5, 6, 7]);
  print(v);

  // Update column
  v = mat.setColumn(0, [1, 4, 5]);
  print(v);

  // Insert row
  v = mat.insertRow(0, [8, 8, 8, 8]);
  print(v);

  // Insert column
  v = mat.insertColumn(4, [8, 8, 8, 8]);
  print(v);

  // Append Rows
  var tailRows = [
    [8, 8, 8, 8, 8],
    [8, 8, 8, 8, 8]
  ];

  print(mat.appendRows(tailRows));

  var tailColumns = Matrix.fromList([
    [8, 8],
    [8, 8],
    [8, 8],
    [8, 8]
  ]);

  print(mat.appendColumns(tailColumns));

  // Delete row
  print(mat.removeRow(0));

  // Delete column
  print(mat.removeColumn(0));

// Delete rows
  mat.removeRows([0, 1]);

// Delete columns
  mat.removeColumns([0, 2]);

  Matrix m = Matrix([
    [1, 2],
    [1, 2]
  ]);

  // flatten
  print(m.flatten());

  // transpose
  print(m.transpose());

  printLine('Arithmetic operations');

  var aa = Matrix([
    [1, 1],
    [1, 1]
  ]);

  var bb = Matrix([
    [2, 2],
    [2, 2]
  ]);
  print('aa:\n $aa');
  print('aa:\n $aa\n');

  print('Addition:\n${aa + bb}\n');

  print('Subtraction:\n${aa + bb}\n');

  print('Division:');
  var div = aa.elementDivide(Matrix([
    [2, 0],
    [2, 2]
  ]));
  print(div);

  print('\nDot operation:');
  var dot = [
    [1, 2],
    [3, 4]
  ].toMatrix().dot([
        [11, 12],
        [13, 14]
      ].toMatrix());
  print(dot);

  printLine('Creating Matrices');

  print('Arrange 1 to 10');
  var arrange = Matrix.range(10);
  print(arrange);

  print('Create Zero 2x2 Matrix');
  var zeros = Matrix.zeros(2, 2);
  print(zeros);

  print('Create Ones 2x3 Matrix');
  var ones = Matrix.ones(2, 3);
  print(ones);

  print('Sum');
  var sum1 = Matrix([
    [2, 2],
    [2, 2]
  ]);
  print(sum1.sum);

  // reshape
  var array = [
    [0, 1, 2, 3, 4, 5, 6, 7]
  ];
  print(array.toMatrix().reshape(4, 2));

  // linspace
  var linspace = Matrix.linspace(2, 3, 5);
  print(linspace);

  // diagonal
  var arr = [
    [1, 1, 1],
    [2, 2, 2],
    [3, 3, 3]
  ];
  print(arr.diagonal);
  print(Diagonal(arr.diagonal));

  //fill
  var fill = Matrix.fill(3, 3, 'matrix');
  print(fill);

  // compare object
  var compare = Matrix.compare(m, '>=', 2);
  print(compare);

  // concatenate

  // axis 0
  var l1 = Matrix([
    [1, 1, 1],
    [1, 1, 1],
    [1, 1, 1]
  ]);
  var l2 = Matrix([
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
  ]);
  var l3 = l1.concatenate([l2]);
  print(l3);

  // axis 1
  var a1 = Matrix([
    [1, 1, 1, 1],
    [1, 1, 1, 1],
    [1, 1, 1, 1]
  ]);
  var a2 = Matrix([
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  ]);

  var a3 = a2.concatenate([a1], axis: 1);
  print(a3);

  // min max
  var numbers = Matrix([
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
  ]);
  print(numbers.min());
  print(numbers.max());

  Matrix a = Matrix([
    [1, 2],
    [3, 4]
  ]);

// Index (row,column) of an element in the matrix
  var index = a.indexOf(3);
  print(index);
// Output: [1, 0]

// Swap rows
  var matrix = Matrix([
    [1, 2],
    [3, 4]
  ]);
  matrix.swapRows(0, 1);
  print(matrix);

// Swap columns
  matrix.swapColumns(0, 1);
  print(matrix);

  m = Matrix.fromList([
    [2, 3, 3, 3],
    [9, 9, 8, 6],
    [1, 1, 2, 9]
  ]);
  var cmp = Matrix.compare(m, '>', 2);
  print(cmp);

  var m1 = Matrix([
    [1, 2],
    [3, 4]
  ]);
  var m2 = Matrix([
    [1, 2],
    [3, 4]
  ]);
  print(m1 == m2); // Output: true
  print(m1.notEqual(m2)); // Output: false

  // Transpose of a matrix
  var transpose = matrix.transpose();
  print(transpose);

  // Inverse of Matrix
  var inverse = matrix.inverse();
  print(inverse);

  //Solve Matrix
  var mat1 = Matrix([
    [2, 1, 1],
    [1, 3, 2],
    [1, 0, 0]
  ]);
  var bbb = Matrix([
    [4],
    [5],
    [6]
  ]);

  var sol = mat1.linear.solve(bbb, method: LinearSystemMethod.leastSquares);
  print(sol);

  // Find the normalized matrix
  var normalize = matrix.normalize();
  print(normalize);

  Matrix x = Matrix.fromList([
    [2, 3, 3, 3],
    [9, 9, 8, 6],
    [1, 1, 2, 9],
    [0, 1, 1, 1]
  ]);

  //Sorting all elements in ascending order (default behavior):
  var sortedMatrix = x.sort();
  print(sortedMatrix);
  // Matrix: 4x4
  // ┌ 0 1 1 1 ┐
  // │ 1 1 2 2 │
  // │ 3 3 3 6 │
  // └ 8 9 9 9 ┘

  // Sorting all elements in descending order:
  var sortedMatrix1 = x.sort(ascending: false);
  print(sortedMatrix1);
  // Matrix: 4x4
  // ┌ 9 9 9 8 ┐
  // │ 6 3 3 3 │
  // │ 2 2 1 1 │
  // └ 1 1 1 0 ┘

// Sort by a single column in descending order
  var sortedMatrix2 = x.sort(columnIndices: [0]);
  print(sortedMatrix2);
  // Matrix: 4x4
  // ┌ 0 1 1 1 ┐
  // │ 1 1 2 9 │
  // │ 2 3 3 3 │
  // └ 9 9 8 6 ┘

// Sort by multiple columns in specified orders
  var sortedMatrix3 = x.sort(columnIndices: [1, 0]);
  print(sortedMatrix3);
  // Matrix: 4x4
  // ┌ 0 1 1 1 ┐
  // │ 1 1 2 9 │
  // │ 2 3 3 3 │
  // └ 9 9 8 6 ┘

// Sorting rows based on the values in column 2 (descending order):
  Matrix xSortedColumn2Descending =
      x.sort(columnIndices: [2], ascending: false);
  print(xSortedColumn2Descending);
  // Matrix: 4x4
  // ┌ 9 9 8 6 ┐
  // │ 2 3 3 3 │
  // │ 1 1 2 9 │
  // └ 0 1 1 1 ┘
}
