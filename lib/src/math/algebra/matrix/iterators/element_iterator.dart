part of algebra;

/// A custom iterator for traversing the elements of a [Matrix] in row-major order.
///
/// This iterator can be used to iterate through individual elements of a matrix,
/// allowing you to access each element one by one in a linear fashion.
class MatrixElementIterator implements Iterator<dynamic> {
  final Matrix _matrix;
  int _currentRow;
  int _currentCol;

  /// Constructs a new [MatrixElementIterator] instance.
  ///
  /// The [Matrix] to be iterated over should be provided as the `_matrix` parameter.
  MatrixElementIterator(this._matrix)
      : _currentRow = 0,
        _currentCol = -1;

  /// Returns the current element of the matrix.
  ///
  /// If the iterator is in a valid state (i.e., the current position is within the matrix bounds),
  /// this getter returns the current element. If the iterator is not in a valid state, this getter
  /// returns `null`.
  @override
  dynamic get current {
    if (_currentRow < _matrix.rowCount && _currentCol < _matrix.columnCount) {
      return _matrix[_currentRow][_currentCol];
    }
    return null;
  }

  /// Advances the iterator to the next element.
  ///
  /// Returns `true` if the iterator successfully advanced to the next element,
  /// and `false` if the iterator has reached the end of the matrix.
  @override
  bool moveNext() {
    if (_currentCol < _matrix.columnCount - 1) {
      _currentCol++;
      return true;
    } else if (_currentRow < _matrix.rowCount - 1) {
      _currentRow++;
      _currentCol = 0;
      return true;
    }
    return false;
  }
}

class VectorElementIterator implements Iterator<dynamic> {
  final Vector _vector;
  int _currentCol;

  VectorElementIterator(this._vector) : _currentCol = -1;

  @override
  dynamic get current =>
      _currentCol < _vector.length ? _vector[_currentCol] : null;

  @override
  bool moveNext() {
    if (_currentCol < _vector.length - 1) {
      _currentCol++;
      return true;
    }
    return false;
  }
}
