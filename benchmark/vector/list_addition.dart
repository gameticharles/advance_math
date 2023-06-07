import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';

const amountOfElements = 10000000;

class RegularListsAdditionBenchmark extends BenchmarkBase {
  RegularListsAdditionBenchmark()
      : super('Regular lists addition; '
            '$amountOfElements elements');

  late List list1;
  late List list2;

  static void main() {
    RegularListsAdditionBenchmark().report();
  }

  @override
  void run() {
    final result = List.filled(amountOfElements, 0.0);

    for (var i = 0; i < amountOfElements; i++) {
      result[i] = list1[i] + list2[i];
    }
  }

  @override
  void setup() {
    final generator = Random(13);

    list1 = List.generate(
        amountOfElements, (_) => generator.nextDouble() * 2000 - 1000);

    list2 = List.generate(
        amountOfElements, (_) => generator.nextDouble() * 2000 - 1000);
  }
}

void main() {
  RegularListsAdditionBenchmark.main();
}
