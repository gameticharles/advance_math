import 'matrix/matrix_from_columns.dart';
import 'matrix/matrix_from_diagonal.dart';
import 'matrix/matrix_from_flattened.dart';
import 'matrix/matrix_from_list.dart';
import 'matrix/matrix_from_rows.dart';

import 'vector/list_addition.dart';

void main() {
  // Matrix benchmarks
  MatrixFromFlattenedBenchmark.main();
  MatrixDiagonalBenchmark.main();
  MatrixFromListBenchmark.main();
  MatrixFromColumnsBenchmark.main();
  MatrixFromRowsBenchmark.main();

  //Vector benchmarks
  RegularListsAdditionBenchmark.main();
}
