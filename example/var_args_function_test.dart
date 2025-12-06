import 'package:advance_math/advance_math.dart';

// Within a class
class IntervalTimer {
  final List<Duration> timers = [];
  Duration totalDurationImpl() =>
      timers.fold<Duration>(Duration.zero, (p, v) => p + v);

  late final totalDuration = totalDurationImpl.memo;
}

void main() async {
  print('===== VarArgsFunction Tests =====\n');

  dynamic avg = VarArgsFunction<num>((args, kwargs) {
    // Check if the first argument is a List, and use it directly.
    if (args.length == 1 && args.first is List) {
      args = args.first;
    }
    return mean(args.map((e) => e as num).toList());
  });

  print(avg(1, 2, 3)); // prints: 2.0
  print(avg(1, 2, 3, 4, 5)); // prints: 3.0
  print(avg([1, 2, 3, 4, 5])); // prints: 3.0

  int add(int a, int b) => a + b;
  var varAdd = VarArgsFunction.fromFunction<int>(add);
  print(varAdd([5, 3])); // Outputs: 8
  // print(varAdd(5, 3)); // Error

  var add1 = VarArgsFunction<int>((args, _) => args[0] + args[1] + args[2]);
  var curriedAdd = add1.curry(3); // Specify we want to curry 3 arguments
  var add5 = curriedAdd(5); // Returns a function waiting for 2 more args
  var add5And10 = add5(10); // Returns a function waiting for 1 more arg
  print(add5And10(15)); // Outputs: 30 (5 + 10 + 15)

  // var double = VarArgsFunction<int>((args, _) => args[0] * 2);
  // var addOne = VarArgsFunction<int>((args, _) => args[0] + 1);
  // var doubleThenAddOne = double.compose(addOne);
  // print(doubleThenAddOne(5)); // Outputs: 11 (5*2 + 1)

  // Basic usage tests
  basicUsageTests();

  // Direct call method tests
  directCallTests();

  // Map method tests
  mapMethodTests();

  // Partial application tests
  partialApplicationTests();

  // Memoization tests
  memoizationTests();

  // Debounce tests
  debounceTests();

  // Throttle tests
  throttleTests();

  // Retry tests
  await retryTests();

  // Real-world examples
  realWorldExamples();
}

void basicUsageTests() {
  printLine('Basic Usage Tests');

  // Example 1: Handle only positional arguments
  dynamic superHeroes = VarArgsFunction<void>((args, kwargs) {
    for (final superHero in args) {
      print("There's no stopping $superHero");
    }
  });

  print('Calling superHeroes with positional arguments:');
  superHeroes('UberMan', 'Exceptional Woman', 'The Hunk');

  // Example 2: Handle both positional and named arguments
  dynamic myFunc = VarArgsFunction<String>((args, kwargs) {
    return 'Got args: $args, kwargs: $kwargs';
  });

  print('\nCalling myFunc with positional and named arguments:');
  print(myFunc(1, 2, 3, x: 'hello', y: 'world'));
  print(myFunc(10, 20, x: true, y: false));
  print(myFunc('A', 'B', 'C'));
}

void directCallTests() {
  printLine('Direct Call Tests');

  var calculator = VarArgsFunction<num>((args, kwargs) {
    String operation = kwargs['operation'] ?? 'sum';

    switch (operation) {
      case 'sum':
        return args.fold<num>(0, (a, b) => a + (b as num));
      case 'multiply':
        return args.fold<num>(1, (a, b) => a * (b as num));
      case 'average':
        return args.fold<num>(0, (a, b) => a + (b as num)) / args.length;
      default:
        throw ArgumentError('Unknown operation: $operation');
    }
  });

  print('Sum: ${calculator([1, 2, 3, 4, 5])}');
  print('Multiply: ${calculator([
        1,
        2,
        3,
        4,
        5
      ], kwargs: {
        'operation': 'multiply'
      })}');
  print('Average: ${calculator([
        1,
        2,
        3,
        4,
        5
      ], kwargs: {
        'operation': 'average'
      })}');

  // Test error handling
  try {
    calculator([1, 2, 3], kwargs: {'operation': 'unknown'});
  } catch (e) {
    print('Caught expected error: $e');
  }
}

void mapMethodTests() {
  printLine('Map Method Tests');

  dynamic countArgs = VarArgsFunction<int>((args, _) => args.length);
  var doubleCount = countArgs.map((count) => count * 2);
  var formatCount = countArgs.map((count) => 'Number of arguments: $count');

  print('Original count: ${countArgs(1, 2, 3)}');
  print('Doubled count: ${doubleCount(1, 2, 3)}');
  print('Formatted count: ${formatCount(1, 2, 3)}');

  // Chaining maps
  var complexTransform = countArgs
      .map((count) => count * 2)
      .map((doubled) => doubled + 10)
      .map((result) => 'Final result: $result');

  print('Chained transformation: ${complexTransform(1, 2, 3, 4)}');
}

void partialApplicationTests() {
  printLine('Partial Application Tests');

  dynamic greet = VarArgsFunction<String>((args, kwargs) {
    var name = args.isNotEmpty ? args[0] : 'Guest';
    var greeting = kwargs['greeting'] ?? 'Hello';
    var punctuation = kwargs['excited'] == true ? '!' : '.';
    return '$greeting, $name$punctuation';
  });

  // Create partially applied functions
  dynamic greetJohn = greet.partial(['John']);

  // These need to be dynamic to use the function-like syntax
  dynamic sayHi = greet.partial([], {'greeting': 'Hi'});
  dynamic excitedGreeting = greet.partial([], {'excited': true});

  print('Default greeting: ${greet()}');
  print('Greeting John: ${greetJohn()}');

  // This works because sayHi is dynamic, allowing noSuchMethod to be called
  print('Saying Hi: ${sayHi('Alice')}');
  print('Excited greeting: ${excitedGreeting('Bob')}');

  // For this to work, we need to make the result dynamic as well
  dynamic combinedPartial =
      sayHi.partial(['Charlie', 'Gameti'], {'excited': true});
  print('Combined partial: ${combinedPartial()}');
}

void memoizationTests() {
  printLine('Memoization Tests');

  // Create a function that simulates an expensive computation
  int computeCount = 0;
  dynamic expensiveComputation = VarArgsFunction<int>((args, _) {
    // Extract the value, whether it's passed directly or as part of a list
    int n;
    if (args.length == 1 && args[0] is int) {
      n = args[0];
    } else if (args.length == 1 && args[0] is List && args[0].isNotEmpty) {
      n = args[0][0];
    } else {
      throw ArgumentError(
          'Expected a single integer or a list containing an integer');
    }

    computeCount++;

    // Add artificial delay to simulate expensive computation
    final sw = Stopwatch()..start();

    // Make the computation more intensive for better timing measurement
    if (n <= 1) return n;

    int a = 0, b = 1;
    // Add some artificial work to make the computation more measurable
    for (int i = 2; i <= n; i++) {
      // Add a small delay to make the computation more noticeable
      for (int j = 0; j < 100000; j++) {
        // Busy work to make the computation take longer
        if (j % 10000 == 0) {
          a = a + 1 - 1; // Meaningless operation to prevent optimization
        }
      }
      int c = a + b;
      a = b;
      b = c;
    }

    final elapsed = sw.elapsedMicroseconds;
    print(
        'Computing fibonacci($n) - call #$computeCount (took ${elapsed / 1000} ms)');

    return b;
  });

  // Create a memoized version
  var memoizedComputation = expensiveComputation.memoized();

  // Test values to benchmark
  final testValues = [10, 20, 30, 35, 50];

  // Results storage
  final results = <String, Map<int, int>>{
    'non-memoized': {},
    'memoized-first': {},
    'memoized-second': {},
  };

  // Run benchmarks
  print('\n📊 Running benchmarks...');
  print('┌${'─' * 60}┐');
  print(
      '│ ${'Test'.padRight(15)}│ ${'Value'.padRight(8)}│ ${'Time (ms)'.padRight(15)}│ ${'Result'.padRight(15)}│');
  print('├${'─' * 60}┤');

  // Test non-memoized function
  for (final n in testValues) {
    final sw = Stopwatch()..start();
    final result = expensiveComputation(n);
    final elapsed = sw.elapsedMicroseconds;
    results['non-memoized']![n] = elapsed;

    print(
        '│ ${'Non-memoized'.padRight(15)}│ ${n.toString().padRight(8)}│ ${(elapsed / 1000).toStringAsFixed(3).padRight(15)}│ ${result.toString().padRight(15)}│');
  }

  print('├${'─' * 60}┤');

  // Test memoized function (first call)
  for (final n in testValues) {
    final sw = Stopwatch()..start();
    final result = memoizedComputation(n);
    final elapsed = sw.elapsedMicroseconds;
    results['memoized-first']![n] = elapsed;

    print(
        '│ ${'Memoized (1st)'.padRight(15)}│ ${n.toString().padRight(8)}│ ${(elapsed / 1000).toStringAsFixed(3).padRight(15)}│ ${result.toString().padRight(15)}│');
  }

  print('├${'─' * 60}┤');

  // Test memoized function (second call)
  for (final n in testValues) {
    final sw = Stopwatch()..start();
    final result = memoizedComputation(n);
    final elapsed = sw.elapsedMicroseconds;
    results['memoized-second']![n] = elapsed;

    print(
        '│ ${'Memoized (2nd)'.padRight(15)}│ ${n.toString().padRight(8)}│ ${(elapsed / 1000).toStringAsFixed(3).padRight(15)}│ ${result.toString().padRight(15)}│');
  }

  print('└${'─' * 60}┘');

  // Print performance summary
  print('\n📈 Performance Summary:');
  print('┌${'─' * 60}┐');
  print(
      '│ ${'Value'.padRight(8)}│ ${'Speedup (1st call)'.padRight(20)}│ ${'Speedup (2nd call)'.padRight(20)}│');
  print('├${'─' * 60}┤');

  for (final n in testValues) {
    final nonMemoized = results['non-memoized']![n]!;
    final memoizedFirst = results['memoized-first']![n]!;
    final memoizedSecond = results['memoized-second']![n]!;

    final firstCallSpeedup = nonMemoized / memoizedFirst;
    final secondCallSpeedup = nonMemoized / memoizedSecond;

    print(
        '│ ${n.toString().padRight(8)}│ ${firstCallSpeedup.toStringAsFixed(2).padRight(20)}x│ ${secondCallSpeedup.toStringAsFixed(2).padRight(20)}x│');
  }

  print('└${'─' * 60}┘');

  // Calculate average speedup
  final avgFirstCallSpeedup = testValues
          .map((n) =>
              results['non-memoized']![n]! / results['memoized-first']![n]!)
          .reduce((a, b) => a + b) /
      testValues.length;

  final avgSecondCallSpeedup = testValues
          .map((n) =>
              results['non-memoized']![n]! / results['memoized-second']![n]!)
          .reduce((a, b) => a + b) /
      testValues.length;

  print('\n🚀 On average, memoization provides:');
  print(
      '   - ${avgFirstCallSpeedup.toStringAsFixed(2)}x speedup on first call');
  print(
      '   - ${avgSecondCallSpeedup.toStringAsFixed(2)}x speedup on subsequent calls');

  // Memory usage note
  print('\n💾 Note: Memoization trades memory for speed by caching results.');
  print('   The memory usage grows with the number of unique inputs.');

  printLine();
  var res = time(() => print('Hello'));
  print('Result: ${res.result}, Time: ${res.elapsed.inMilliseconds}ms');

  printLine("Memoization: Wraps a function and caches its result.");
  var sum = (() => 1.to(999999999).sum());
  res = time(() => sum());
  print('Result: ${res.result}, Time: ${res.elapsed.inMilliseconds}ms');

  var sumMemo = sum.memoize();
  for (var i = 0; i < 10; i++) {
    res = time(() => sumMemo()); // Computes the sum
    print('Result: ${res.result}, Time: ${res.elapsed.inMilliseconds}ms');
  }

  printLine("Fibonacci");
  res = time(() => fib(9999));
  print('Result: ${res.result}, Time: ${res.elapsed.inMilliseconds}ms');

  // Simple function memoization
  final memoFib = fib.memoize();
  for (var i = 0; i < 10; i++) {
    res = time(() => memoFib(9999)); // Computes the sum
    print('Result: ${res.result}, Time: ${res.elapsed.inMilliseconds}ms');
  }

  // Memoized1<ReturnType, ArgumentType>

  late final Memoized1<int, int> fib3;
  fib3 = Memoized1((int n) {
    if (n <= 1) return n;
    return fib3(n - 1) + fib3(n - 2);
  });

  print(fib3(500));

  printLine("Expiry");
  var numbers = 1.to(30000000);
  final calculateSum = (() => numbers.sum()).memoize();

  res = time(calculateSum());
  print('Result: ${res.result}, Time: ${res.elapsed.inMilliseconds}ms');

  numbers = 1.to(9043483);
  calculateSum.expire(); // Cache is cleared but not computed
  res = time(calculateSum());
  print('Result: ${res.result}, Time: ${res.elapsed.inMilliseconds}ms');

  printLine();

  printLine();
  // Multi-argument function
  int add2(int a, int b) => a + b;
  final memoAdd = add2.memoize();
  print(memoAdd(5, 3)); // Cached based on both arguments

  // // Custom key for complex objects
  // class User { final int id; User(this.id); }
  // final processUser = ((User user) => expensiveOperation(user))
  //     .memoizeWithKey((user) => user.id.toString());

  // // Async function
  // final fetchData = ((String url) => http.get(url)).memoize();
  // await fetchData('https://api.example.com'); // Cached after first call

  // Variable arguments
  final varArgsFn = Memoize.functionVarArgs((List<dynamic> args) {
    return args.reduce((a, b) => a + b);
  });
  print(varArgsFn([1, 2, 3, 4])); // Sum: 10
}

void debounceTests() {
  printLine('Debounce Tests');

  print('Debounce tests require async operations.');
  print('In a real application, you would see the debounced function');
  print(
      'only execute once after the specified delay, even if called multiple times.');

  // Create a debounced function
  var searchFunction = VarArgsFunction<void>((args, _) {
    print('Searching for: ${args[0]}');
  }).debounced(Duration(milliseconds: 300));

  print('Calling search function multiple times in quick succession:');

  // Since we can't properly demonstrate debouncing in a synchronous test,
  // we'll just show the concept with print statements
  print(searchFunction("a"));
  print(searchFunction("ap"));
  print(searchFunction("app"));
  print(searchFunction("appl"));
  print(searchFunction("apple"));

  print('\nIn a real application with debouncing:');
  print('- Only the last call ("apple") would execute after 300ms');
  print('- Previous calls would be cancelled');
  print('- This prevents excessive function calls during rapid input');

  print('\nExample use case:');
  print('- Search-as-you-type functionality');
  print('- Window resize handlers');
  print('- Form validation on input');
}

void throttleTests() {
  printLine('Throttle Tests');

  print('Throttle tests require time-based operations.');
  print('In a real application, the throttled function would execute');
  print('at most once per specified interval, regardless of call frequency.');

  dynamic saveFunction = VarArgsFunction<void>((args, _) {
    print('Saving data: ${args[0]}');
  }).throttled(Duration(seconds: 2));

  print('Calling save function multiple times in quick succession:');
  print(saveFunction("data1")); // - would execute
  print(saveFunction("data2")); // - would be ignored
  print(saveFunction("data3")); // - would be ignored
  print('After 2 seconds, the next call would execute.');

  print('\nIn a real application with throttling:');
  print('- First call executes immediately');
  print(
      '- Subsequent calls within the throttle period (2 seconds) are ignored');
  print('- After the throttle period, the next call would execute');

  print('\nExample use cases:');
  print('- Limiting API requests');
  print('- Scroll or resize event handlers');
  print('- Button click handlers (prevent double-clicks)');
}

Future retryTests() async {
  printLine('Retry Tests');

  // Create a function that fails sometimes with a different random value each time
  var unreliableFunction = VarArgsFunction<String>((args, _) {
    // Generate a new random value each time the function is called
    var randomValue = Random().nextDouble();
    print('Attempt with random value: $randomValue');

    if (randomValue < 0.7) {
      throw Exception('Random failure (value: $randomValue)');
    }
    return 'Success with ${args[0]}';
  });

  // Create a version with retry
  var reliableFunction = unreliableFunction.withRetry(5);

  print('Calling unreliable function with retry:');

  // Since withRetry returns a Future, we need to handle it properly
  await reliableFunction('test data').then((result) {
    print(result);
    print('Function succeeded!');
  }).catchError((e) {
    print('Function failed after retries: $e');
  });

  print('\nExplanation of retry mechanism:');
  print('- The function has a 70% chance of failure on each attempt');
  print('- With 5 retries, it has 5 chances to succeed');
  print('- If all attempts fail, it throws an exception');
  print('- If any attempt succeeds, it returns the successful result');
}

void realWorldExamples() {
  printLine('Real-World Examples');

  // Example 1: Mathematical operations
  dynamic calculator = VarArgsFunction<num>((args, kwargs) {
    String operation = kwargs['operation'] ?? 'add';

    switch (operation) {
      case 'add':
        return args.reduce((a, b) => (a as num) + (b as num));
      case 'subtract':
        return args.reduce((a, b) => (a as num) - (b as num));
      case 'multiply':
        return args.reduce((a, b) => (a as num) * (b as num));
      case 'divide':
        return args.reduce((a, b) => (a as num) / (b as num));
      case 'power':
        return args.reduce((a, b) => pow(a as num, b as num));
      default:
        throw ArgumentError('Unknown operation: $operation');
    }
  });

  print('Addition: ${calculator(10, 5, operation: 'add')}');
  print('Subtraction: ${calculator(10, 5, operation: 'subtract')}');
  print('Multiplication: ${calculator(10, 5, operation: 'multiply')}');
  print('Division: ${calculator(10, 5, operation: 'divide')}');
  print('Power: ${calculator(10, 2, operation: 'power')}');

  // Example 2: String formatting
  dynamic formatter = VarArgsFunction<String>((args, kwargs) {
    String template = args[0];
    Map<String, dynamic> values = {...kwargs};

    // Replace placeholders in the template with values
    String result = template;
    values.forEach((key, value) {
      result = result.replaceAll('{$key}', value.toString());
    });

    return result;
  });

  print(formatter('Hello, {name}! You have {count} new messages.',
      name: 'John', count: 5));

  // Example 3: Fibonacci with memoization
  dynamic fibonacci = VarArgsFunction<int>((args, _) {
    int n = args[0];

    // Direct calculation for small values
    if (n <= 1) return n;

    // For larger values, use the recursive definition
    return fib(n - 1) + fib(n - 2);
  }).memoized();

  print('Fibonacci of 30: ${fibonacci(30)}');

  // Example 4: Command pattern
  dynamic commandProcessor = VarArgsFunction<String>((args, kwargs) {
    String command = args[0].toLowerCase();

    switch (command) {
      case 'create':
        return 'Creating ${args[1]} with properties: $kwargs';
      case 'update':
        return 'Updating ${args[1]} with properties: $kwargs';
      case 'delete':
        return 'Deleting ${args[1]}';
      case 'get':
        return 'Getting ${args[1]}';
      default:
        return 'Unknown command: $command';
    }
  });

  print(commandProcessor('create', 'user', name: 'John', age: 30));
  print(commandProcessor('update', 'user', id: 123, name: 'John Doe'));
  print(commandProcessor('delete', 'user', id: 123));
  print(commandProcessor('get', 'user', id: 123));
}
