import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:advance_math/advance_math.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class MatrixFromRowsBenchmark extends BenchmarkBase {
  MatrixFromRowsBenchmark() : super('Matrix initialization (fromRows)');

  final _source = List<Row>.filled(
      numOfRows, Row.random(numOfColumns, min: -10000, max: 10000, seed: 12));

  static void main() {
    MatrixFromRowsBenchmark().report();
  }

  @override
  void run() {
    Matrix.fromRows(_source);
  }
}

void main() {
  MatrixFromRowsBenchmark.main();
}
