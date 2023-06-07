import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:advance_math/advance_math.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class MatrixFromListBenchmark extends BenchmarkBase {
  MatrixFromListBenchmark() : super('Matrix initialization (fromList)');

  final _source = List.filled(
    numOfRows,
    Vector.random(numOfColumns, min: -10000, max: 10000, seed: 12).toList(),
  );

  static void main() {
    MatrixFromListBenchmark().report();
  }

  @override
  void run() {
    Matrix.fromList(_source);
  }
}

void main() {
  MatrixFromListBenchmark.main();
}
