import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:advance_math/advance_math.dart';

const size = 10000;

class MatrixDiagonalBenchmark extends BenchmarkBase {
  MatrixDiagonalBenchmark() : super('Matrix initialization (diagonal)');

  late final List<dynamic> _source = Vector.random(size, seed: 12).toList();

  static void main() {
    MatrixDiagonalBenchmark().report();
  }

  @override
  void run() {
    Matrix.fromDiagonal(_source);
  }
}

void main() {
  MatrixDiagonalBenchmark.main();
}
