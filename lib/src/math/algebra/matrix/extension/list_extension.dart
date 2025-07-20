part of '../../algebra.dart';

extension MatrixListExtension on List<List<dynamic>> {
  /// The shape of an array is the number of elements in each dimension.
  List get shape => Matrix(this).shape;

  /// Used to get a copy of an given array collapsed into one dimension
  List<dynamic> get flatten => Matrix(this).flatten();

  /// Reverse the axes of an array and returns the modified array.
  Matrix get transpose => Matrix(this).transpose();

  /// Create a matrix with the list
  Matrix toMatrix() => Matrix(this);

  /// Function returns the sum of array elements
  dynamic sum({bool absolute = false, int? axis}) =>
      Matrix(this).sum(absolute: absolute, axis: axis);

  /// To find a diagonal element from a given matrix and gives output as one dimensional matrix
  List<dynamic> get diagonal => Matrix(this).diagonal();

  /// Reshaping means changing the shape of an array.
  List reshape(int row, int column) => Matrix().reshape(row, column).toList();

  /// find min value of given matrix
  List min({int? axis}) => Matrix(this).min(axis: axis);

  /// find max value of given matrix
  List max({int? axis}) => Matrix(this).max(axis: axis);

  /// flip (`reverse`) the matrix along the given axis and returns the modified array.
  List flip({int axis = 0}) => Matrix(this).flip(axis: axis).toList();
}

extension ScanList<T> on List<T> {
  List scan(T Function(T previousValue, T element) combine,
      {bool continuous = false}) {
    dynamic value = 0;
    return map((element) {
      value = continuous
          ? (value == null ? element : combine(value, element))
          : element;
      return value;
    }).toList();
  }
}
