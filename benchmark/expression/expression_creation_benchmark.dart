import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:advance_math/advance_math.dart';

/// Benchmark for Literal constructor expression creation
class LiteralCreationBenchmark extends BenchmarkBase {
  LiteralCreationBenchmark()
      : super('Expression Creation - Literal Constructor');

  static void main() {
    LiteralCreationBenchmark().report();
  }

  @override
  void run() {
    for (int i = 0; i < 1000; i++) {
      Literal(i.toDouble());
    }
  }
}

/// Benchmark for toExpression() extension method
class ExtensionCreationBenchmark extends BenchmarkBase {
  ExtensionCreationBenchmark()
      : super('Expression Creation - toExpression() Extension');

  static void main() {
    ExtensionCreationBenchmark().report();
  }

  @override
  void run() {
    for (int i = 0; i < 1000; i++) {
      i.toDouble().toExpression();
    }
  }
}

/// Benchmark for ex() helper function
class HelperCreationBenchmark extends BenchmarkBase {
  HelperCreationBenchmark()
      : super('Expression Creation - ex() Helper Function');

  static void main() {
    HelperCreationBenchmark().report();
  }

  @override
  void run() {
    for (int i = 0; i < 1000; i++) {
      ex(i.toDouble());
    }
  }
}

/// Benchmark for complex expression creation using Literal constructor
class LiteralComplexExpressionBenchmark extends BenchmarkBase {
  LiteralComplexExpressionBenchmark()
      : super('Complex Expression - Literal Constructor');

  late Variable x;

  @override
  void setup() {
    x = Variable(Identifier('x'));
  }

  static void main() {
    LiteralComplexExpressionBenchmark().report();
  }

  @override
  void run() {
    for (int i = 0; i < 100; i++) {
      // Create: 2*x^2 + 3*x + 1
      final expr = Literal(2) * (x ^ Literal(2)) + Literal(3) * x + Literal(1);
      expr.toString(); // Force expression tree construction
    }
  }
}

/// Benchmark for complex expression creation using extension method
class ExtensionComplexExpressionBenchmark extends BenchmarkBase {
  ExtensionComplexExpressionBenchmark()
      : super('Complex Expression - toExpression() Extension');

  late Variable x;

  @override
  void setup() {
    x = Variable(Identifier('x'));
  }

  static void main() {
    ExtensionComplexExpressionBenchmark().report();
  }

  @override
  void run() {
    for (int i = 0; i < 100; i++) {
      // Create: 2*x^2 + 3*x + 1
      final expr = 2.toExpression() * (x ^ 2.toExpression()) +
          3.toExpression() * x +
          1.toExpression();
      expr.toString(); // Force expression tree construction
    }
  }
}

/// Benchmark for complex expression creation using helper function
class HelperComplexExpressionBenchmark extends BenchmarkBase {
  HelperComplexExpressionBenchmark()
      : super('Complex Expression - ex() Helper Function');

  late Variable x;

  @override
  void setup() {
    x = Variable(Identifier('x'));
  }

  static void main() {
    HelperComplexExpressionBenchmark().report();
  }

  @override
  void run() {
    for (int i = 0; i < 100; i++) {
      // Create: 2*x^2 + 3*x + 1
      final expr = ex(2) * (x ^ ex(2)) + ex(3) * x + ex(1);
      expr.toString(); // Force expression tree construction
    }
  }
}

/// Benchmark for expression evaluation using Literal-created expressions
class LiteralEvaluationBenchmark extends BenchmarkBase {
  LiteralEvaluationBenchmark()
      : super('Expression Evaluation - Literal Created');

  late Variable x;
  late Expression expr;
  late Map<String, num> testValues;

  @override
  void setup() {
    x = Variable(Identifier('x'));
    expr = Literal(3) * x + Literal(2);
    testValues = {'x': 2.5};
  }

  static void main() {
    LiteralEvaluationBenchmark().report();
  }

  @override
  void run() {
    for (int i = 0; i < 1000; i++) {
      expr.evaluate(testValues);
    }
  }
}

/// Benchmark for expression evaluation using extension-created expressions
class ExtensionEvaluationBenchmark extends BenchmarkBase {
  ExtensionEvaluationBenchmark()
      : super('Expression Evaluation - Extension Created');

  late Variable x;
  late Expression expr;
  late Map<String, num> testValues;

  @override
  void setup() {
    x = Variable(Identifier('x'));
    expr = 3.toExpression() * x + 2.toExpression();
    testValues = {'x': 2.5};
  }

  static void main() {
    ExtensionEvaluationBenchmark().report();
  }

  @override
  void run() {
    for (int i = 0; i < 1000; i++) {
      expr.evaluate(testValues);
    }
  }
}

/// Benchmark for expression evaluation using helper-created expressions
class HelperEvaluationBenchmark extends BenchmarkBase {
  HelperEvaluationBenchmark() : super('Expression Evaluation - Helper Created');

  late Variable x;
  late Expression expr;
  late Map<String, num> testValues;

  @override
  void setup() {
    x = Variable(Identifier('x'));
    expr = ex(3) * x + ex(2);
    testValues = {'x': 2.5};
  }

  static void main() {
    HelperEvaluationBenchmark().report();
  }

  @override
  void run() {
    for (int i = 0; i < 1000; i++) {
      expr.evaluate(testValues);
    }
  }
}

/// Benchmark for mixed approach expression creation
class MixedApproachBenchmark extends BenchmarkBase {
  MixedApproachBenchmark() : super('Mixed Approach Expression Creation');

  late Variable x;
  late Variable y;

  @override
  void setup() {
    x = Variable(Identifier('x'));
    y = Variable(Identifier('y'));
  }

  static void main() {
    MixedApproachBenchmark().report();
  }

  @override
  void run() {
    for (int i = 0; i < 100; i++) {
      // Create expression using mixed approaches: ex(2)*x + 3.toExpression()*y - Literal(1)
      final expr = ex(2) * x + 3.toExpression() * y - Literal(1);
      expr.toString(); // Force expression tree construction
    }
  }
}

/// Main function to run all benchmarks
void main() {
  print('=== Expression Creation Performance Benchmarks ===\n');

  print('--- Simple Expression Creation ---');
  LiteralCreationBenchmark.main();
  ExtensionCreationBenchmark.main();
  HelperCreationBenchmark.main();

  print('\n--- Complex Expression Creation ---');
  LiteralComplexExpressionBenchmark.main();
  ExtensionComplexExpressionBenchmark.main();
  HelperComplexExpressionBenchmark.main();

  print('\n--- Expression Evaluation ---');
  LiteralEvaluationBenchmark.main();
  ExtensionEvaluationBenchmark.main();
  HelperEvaluationBenchmark.main();

  print('\n--- Mixed Approach ---');
  MixedApproachBenchmark.main();

  print('\n=== Benchmark Complete ===');
}
