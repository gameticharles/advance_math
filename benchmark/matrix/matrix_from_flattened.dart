import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:advance_math/advance_math.dart';

const numOfRows = 10000;
const numOfColumns = 1000;

class MatrixFromFlattenedBenchmark extends BenchmarkBase {
  MatrixFromFlattenedBenchmark()
      : super('Matrix initialization (fromFlattenedList)');

  late List _source;

  static void main() {
    MatrixFromFlattenedBenchmark().report();
  }

  @override
  void run() {
    Matrix.fromFlattenedList(_source, numOfRows, numOfColumns);
  }

  @override
  void setup() {
    _source =
        Vector.random(numOfRows * numOfColumns, min: -1000, max: 1000, seed: 12)
            .toList();
  }
}

void main() {
  MatrixFromFlattenedBenchmark.main();
}
