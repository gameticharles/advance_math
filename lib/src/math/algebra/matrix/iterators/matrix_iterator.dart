part of algebra;

/// A custom iterator for traversing the elements of a [Matrix] in row-major or column-major order.
///
/// This iterator can be used to iterate through the rows or columns of a matrix.
/// When constructed with the optional `columnMajor` parameter set to `true`, the iterator will
/// traverse the matrix in column-major order. Otherwise, it will traverse the matrix in row-major order
/// (the default behavior).
class MatrixIterator implements Iterator<List<dynamic>> {
  final Matrix _matrix;
  final bool _columnMajor;
  int _current;
  final int _max;

  /// Constructs a new [MatrixIterator] instance.
  ///
  /// The [Matrix] to be iterated over should be provided as the `_matrix` parameter.
  /// If the optional `columnMajor` parameter is set to `true`, the iterator will traverse the matrix
  /// in column-major order. Otherwise, it will traverse the matrix in row-major order (the default behavior).
  MatrixIterator(this._matrix, {bool columnMajor = false})
      : _columnMajor = columnMajor,
        _current = -1,
        _max = columnMajor ? _matrix.columnCount : _matrix.rowCount;

  /// Returns the current row or column of the matrix, depending on the traversal order.
  ///
  /// If the iterator is in a valid state (i.e., the current position is within the matrix bounds),
  /// this getter returns the current row or column as a [List] of [dynamic] elements. If the iterator
  /// is not in a valid state, this getter returns an empty [List].
  @override
  List<dynamic> get current {
    if (_current >= 0 && _current < _max) {
      return _columnMajor ? _matrix.column(_current)._data : _matrix[_current];
    }
    return List.empty();
  }

  /// Advances the iterator to the next row or column.
  ///
  /// Returns `true` if the iterator successfully advanced to the next row or column,
  /// and `false` if the iterator has reached the end of the matrix.
  @override
  bool moveNext() {
    if (_current < _max - 1) {
      _current++;
      return true;
    }
    return false;
  }
}
