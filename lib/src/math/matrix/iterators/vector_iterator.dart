part of matrix;

class VectorIterator implements Iterator<num> {
  final Vector _vector;
  int _current;
  final int _max;

  /// Constructs a new [VectorIterator] instance.
  VectorIterator(this._vector)
      : _current = -1,
        _max = _vector.length;

  @override
  num get current {
    if (_current >= 0 && _current < _max) {
      return _vector[_current];
    }
    return double.nan;
  }

  @override
  bool moveNext() {
    if (_current < _max - 1) {
      _current++;
      return true;
    }
    return false;
  }
}
