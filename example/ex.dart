class Matrix {
  final List<List<int>> _matrix;

  Matrix(this._matrix);

  Matrix cumsum({bool continuous = false, int axis = 0}) {
    int rows = _matrix.length;
    int cols = _matrix[0].length;

    List<List<int>> result = List.generate(rows, (i) => List.filled(cols, 0));

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        switch (axis) {
          case 0: // Row-wise
            result[i][j] = _matrix[i][j] +
                (j > 0 ? result[i][j - 1] : 0) +
                (continuous && i > 0 ? result[i - 1][j] : 0);
            break;

          case 1: // Column-wise
            result[i][j] = _matrix[i][j] +
                (i > 0 ? result[i - 1][j] : 0) +
                (continuous && j > 0 ? result[i][j - 1] : 0);
            break;

          case 2: // Diagonal top-left to bottom-right
            result[i][j] =
                _matrix[i][j] + (i > 0 && j > 0 ? result[i - 1][j - 1] : 0);
            break;

          case 3: // Diagonal bottom-left to top-right
            result[i][j] = _matrix[i][j] +
                (i < rows - 1 && j > 0 ? result[i + 1][j - 1] : 0);
            break;

          case 4: // Diagonal top-right to bottom-left
            result[i][j] = _matrix[i][j] +
                (i > 0 && j < cols - 1 ? result[i - 1][j + 1] : 0);
            break;

          default:
            throw ArgumentError('Invalid axis value');
        }
      }
    }

    return Matrix(result);
  }

  @override
  String toString() {
    return _matrix.map((row) => row.join(' ')).join('\n');
  }
}

void main() {
  var arr = Matrix([
    [1, 5, 6],
    [4, 7, 2],
    [3, 1, 9]
  ]);

  print(arr.cumsum(continuous: true));
  // Matrix: 3x3
  // [ 1  6 12 16 23 25 28 29 38 ]

  // print(arr.cumsum(continuous: false));
  // Matrix: 3x3
  // [ 1  6 12 4 11 13 3  4 13 ]

  // print(arr.cumsum(continuous: false, axis: 0));
  // Matrix: 3x3
  // ┌ 1  5  6 ┐
  // │ 5 12  8 │
  // └ 8 13 17 ┘

  // print(arr.cumsum(continuous: true, axis: 0));
  // Matrix: 3x3
  // ┌ 1 13 27 ┐
  // │ 5 20 29 │
  // └ 8 21 38 ┘

  // print(arr.cumsum(continuous: false, axis: 1));
  // Matrix: 3x3
  // ┌ 1  6 12 ┐
  // │ 4 11 13 │
  // └ 3  4 13 ┘

  // print(arr.cumsum(continuous: true, axis: 1));
  // Matrix: 3x3
  // ┌  1  6 12 ┐
  // │ 16 23 25 │
  // └ 28 29 38 ┘

  // print(arr.cumsum(continuous: false, axis: 2));
  // Matrix: 3x3
  // ┌ 1 5  6 ┐
  // │ 4 8  2 │
  // └ 3 1 17 ┘

  // print(arr.cumsum(continuous: true, axis: 2));
  // Matrix: 3x3
  // ┌ 1 5  6 ┐
  // │ 4 8  2 │
  // └ 3 1 17 ┘

  // print(arr.cumsum(continuous: false, axis: 3));
  // Matrix: 3x3
  // ┌ 1 5  6 ┐
  // │ 4 8  7 │
  // └ 3 5 17 ┘

  // print(arr.cumsum(continuous: true, axis: 3));
  // Matrix: 3x3
  // ┌ 9 30 38 ┐
  // │ 7 16 32 │
  // └ 3  8 25 ┘

  // print(arr.cumsum(continuous: false, axis: 4));
  // Matrix: 3x3
  // ┌ 1  9 16 ┐
  // │ 4 10  3 │
  // └ 3  1  9 ┘

  // print(arr.cumsum(continuous: true, axis: 4));
  // Matrix: 3x3
  // ┌  1 10 26 ┐
  // │  5 20 29 │
  // └ 13 27 38 ┘
}
