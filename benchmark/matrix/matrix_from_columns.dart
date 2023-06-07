import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:advance_math/advance_math.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class MatrixFromColumnsBenchmark extends BenchmarkBase {
  MatrixFromColumnsBenchmark() : super('Matrix initialization (fromColumns)');

  final _source = List.filled(numOfColumns,
      Column.random(numOfRows, min: -10000, max: 10000, seed: 12));

  static void main() {
    MatrixFromColumnsBenchmark().report();
  }

  @override
  void run() {
    Matrix.fromColumns(_source);
  }
}

void main() {
  MatrixFromColumnsBenchmark.main();
}
