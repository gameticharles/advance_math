part of '../../advance_math.dart';

/// A callback type used for functions that handle both positional and named arguments.
///
/// The callback accepts two parameters:
/// - [args]: A list of positional arguments.
/// - [kwargs]: A map of named arguments (key-value pairs).
typedef VarArgsCallback<T> = T Function(
    List<dynamic> args, Map<String, dynamic> kwargs);

/// A class that enables handling variable numbers of positional and named arguments
/// dynamically. This class intercepts method calls and passes the arguments to a
/// user-defined callback function.
///
/// Example usage:
/// ```dart
/// // Example 1: Handle only positional arguments
/// var superHeroes = VarArgsFunction<void>((args, kwargs) {
///   for (final superHero in args) {
///     print("There's no stopping $superHero");
///   }
/// });
/// superHeroes('UberMan', 'Exceptional Woman', 'The Hunk'); // Positional args only
///
/// // Example 2: Handle both positional and named arguments
/// var myFunc = VarArgsFunction<String>((args, kwargs) {
///   return 'Got args: $args, kwargs: $kwargs';
/// });
/// print(myFunc(1, 2, 3, x: 'hello', y: 'world')); // Positional + Named args
/// print(myFunc(10, 20, x: true, y: false)); // Another set of Positional + Named args
/// print(myFunc('A', 'B', 'C')); // Positional args only
/// ```
class VarArgsFunction<T> {
  /// A callback function that handles the positional and named arguments.
  final VarArgsCallback<T> callback;

  // A constant offset used to strip the `Symbol("...")` part of named arguments.
  static final _offset = 'Symbol("'.length;

  /// Constructor for creating a [VarArgsFunction] instance.
  ///
  /// The callback function will be invoked when the function is called, and it
  /// will receive both positional and named arguments.
  ///
  /// [callback]: The function that will process the collected arguments.
  VarArgsFunction(this.callback);

  /// Factory constructor to create a VarArgsFunction from a standard Dart function.
  ///
  /// This allows easy conversion of regular functions to VarArgsFunction:
  /// ```dart
  /// int add(int a, int b) => a + b;
  /// var varAdd = VarArgsFunction.fromFunction(add);
  /// print(varAdd(5, 3)); // Outputs: 8
  /// print(varAdd([5, 3])); // Also works: 8
  /// ```
  static VarArgsFunction<R> fromFunction<R>(Function function) {
    return VarArgsFunction<R>((args, kwargs) {
      // Process args to handle both direct arguments and list arguments
      List<dynamic> processedArgs;

      if (args.length == 1 && args.first is List) {
        // If the first argument is a list, use it as the arguments list
        processedArgs = args.first;
      } else {
        // Otherwise use the args directly
        processedArgs = args;
      }

      // Use reflection to call the function with the provided arguments
      return Function.apply(function, processedArgs,
          kwargs.map((key, value) => MapEntry(Symbol(key), value)));
    });
  }

  /// Makes the object directly callable like a function.
  ///
  /// This allows you to use the object as if it were a function:
  /// ```dart
  /// var func = VarArgsFunction<int>((args, kwargs) => args.length);
  /// print(func(1, 2, 3)); // Outputs: 3
  /// ```
  T call(dynamic args, {Map<String, dynamic> kwargs = const {}}) {
    try {
      // Handle different types of arguments
      List<dynamic> processedArgs;

      if (args is List) {
        // If args is already a list, use it directly
        processedArgs = args;
      } else {
        // If args is a single value, wrap it in a list
        processedArgs = [args];
      }

      return callback(processedArgs, kwargs);
    } catch (e) {
      throw ArgumentError('Error in direct call: $e');
    }
  }

  /// This method is overridden to capture any dynamic method calls made on
  /// the instance. It processes both positional and named arguments.
  ///
  /// The method:
  /// - Extracts positional arguments and stores them in a list.
  /// - Converts named arguments into a map of key-value pairs.
  /// - Passes both the positional arguments and the named arguments to the callback.
  @override
  T noSuchMethod(Invocation inv) {
    try {
      // Extract positional arguments
      List<dynamic> args = inv.positionalArguments;

      // Convert named arguments to Map<String, dynamic>
      Map<String, dynamic> kwargs = inv.namedArguments.map(
        (k, v) {
          var key = k.toString();
          return MapEntry(key.substring(_offset, key.length - 2), v);
        },
      );

      // Call the callback with the collected arguments
      return callback(args, kwargs);
    } catch (e) {
      throw ArgumentError('Error processing arguments: $e');
    }
  }

  /// Creates a new VarArgsFunction that applies a transformation to the result
  /// of this function.
  ///
  /// This allows for function composition:
  /// ```dart
  /// var countArgs = VarArgsFunction<int>((args, _) => args.length);
  /// var doubleCount = countArgs.map((count) => count * 2);
  /// print(doubleCount(1, 2, 3)); // Outputs: 6
  /// ```
  VarArgsFunction<R> map<R>(R Function(T result) transform) {
    return VarArgsFunction<R>((args, kwargs) {
      final result = callback(args, kwargs);
      return transform(result);
    });
  }

  /// Implements currying, converting a function that takes multiple arguments
  /// into a sequence of functions that each take a single argument.
  ///
  /// ```dart
  /// var add = VarArgsFunction<int>((args, _) => args[0] + args[1] + args[2]);
  /// var curriedAdd = add.curry(3); // Specify we want to curry 3 arguments
  /// var add5 = curriedAdd(5); // Returns a function waiting for 2 more args
  /// var add5And10 = add5(10); // Returns a function waiting for 1 more arg
  /// print(add5And10(15)); // Outputs: 30 (5 + 10 + 15)
  /// ```
  Function curry(int arity) {
    if (arity <= 0) {
      throw ArgumentError('Arity must be greater than 0');
    }

    // Helper function to implement the currying
    Function curryHelper(List<dynamic> collectedArgs, int remaining) {
      return (arg) {
        final newArgs = [...collectedArgs, arg];
        if (remaining <= 1) {
          // If we've collected all arguments, call the original function
          return callback(newArgs, {});
        } else {
          // Otherwise, return a function that collects the next argument
          return curryHelper(newArgs, remaining - 1);
        }
      };
    }

    return curryHelper([], arity);
  }

  /// Creates a new VarArgsFunction with pre-filled arguments.
  ///
  /// This is similar to partial application in functional programming:
  /// ```dart
  /// var greet = VarArgsFunction<String>((args, kwargs) {
  ///   var name = args.isNotEmpty ? args[0] : 'Guest';
  ///   var greeting = kwargs['greeting'] ?? 'Hello';
  ///   return '$greeting, $name!';
  /// });
  ///
  /// var greetJohn = greet.partial(['John']);
  /// print(greetJohn()); // Outputs: Hello, John!
  ///
  /// var sayHi = greet.partial([], {'greeting': 'Hi'});
  /// print(sayHi('Alice')); // Outputs: Hi, Alice!
  /// ```
  VarArgsFunction<T> partial(
      [List<dynamic> preArgs = const [],
      Map<String, dynamic> preKwargs = const {}]) {
    return VarArgsFunction<T>((args, kwargs) {
      final combinedArgs = [...preArgs, ...args];
      final combinedKwargs = {...preKwargs, ...kwargs};
      return callback(combinedArgs, combinedKwargs);
    });
  }

  /// Creates a memoized version of this function that caches results.
  ///
  /// This is useful for expensive computations:
  /// ```dart
  /// var fibonacci = VarArgsFunction<int>((args, _) {
  ///   int n = args[0];
  ///   if (n <= 1) return n;
  ///   return fib(n - 1) + fib(n - 2);
  /// }).memoized();
  ///
  /// print(fibonacci(30)); // Fast, even for large values
  /// ```
  VarArgsFunction<T> memoized() {
    final cache = <String, T>{};

    return VarArgsFunction<T>((args, kwargs) {
      // Create a cache key from the arguments
      final key = '${args.toString()}|${kwargs.toString()}';

      if (!cache.containsKey(key)) {
        cache[key] = callback(args, kwargs);
      }

      return cache[key]!;
    });
  }

  /// Creates a memoized version of this function with a custom key generator.
  ///
  /// This allows for more efficient caching when the default string representation
  /// of arguments is not optimal:
  /// ```dart
  /// var processData = VarArgsFunction<Result>((args, _) {
  ///   // Expensive operation on large data object
  ///   return processLargeData(args[0]);
  /// }).memoizedWithKey((args, _) => args[0].id.toString());
  ///
  /// // Now caching is based on the ID, not the entire object
  /// ```
  VarArgsFunction<T> memoizedWithKey(
      String Function(List<dynamic>, Map<String, dynamic>) keyGenerator) {
    final cache = <String, T>{};

    return VarArgsFunction<T>((args, kwargs) {
      final key = keyGenerator(args, kwargs);

      if (!cache.containsKey(key)) {
        cache[key] = callback(args, kwargs);
      }

      return cache[key]!;
    });
  }

  /// Creates a debounced version of this function that only executes
  /// after a specified delay has passed without any new invocations.
  ///
  /// This is useful for functions that are called frequently but should
  /// only execute after the calls have stopped for a certain period:
  /// ```dart
  /// var search = VarArgsFunction<void>((args, _) {
  ///   print('Searching for: ${args[0]}');
  ///   // Perform expensive search operation
  /// }).debounced(Duration(milliseconds: 300));
  ///
  /// // These rapid calls will only trigger one search after 300ms
  /// search('a');
  /// search('ap');
  /// search('app');
  /// search('appl');
  /// search('apple'); // Only this one will be executed
  /// ```
  FutureVarArgsFunction<T> debounced(Duration delay) {
    Timer? timer;

    return FutureVarArgsFunction<T>((args, kwargs) {
      if (timer != null) {
        timer!.cancel();
      }

      final completer = Completer<T>();

      timer = Timer(delay, () {
        try {
          final result = callback(args, kwargs);
          completer.complete(result);
        } catch (e) {
          completer.completeError(e);
        }
      });

      return completer.future;
    });
  }

  /// Creates a throttled version of this function that executes at most
  /// once per specified duration, regardless of how many times it's called.
  ///
  /// This is useful for limiting the rate at which a function can execute:
  /// ```dart
  /// var saveData = VarArgsFunction<void>((args, _) {
  ///   print('Saving data: ${args[0]}');
  ///   // Perform expensive save operation
  /// }).throttled(Duration(seconds: 2));
  ///
  /// // Even if called rapidly, this will execute at most once every 2 seconds
  /// saveData('data1');
  /// saveData('data2'); // Ignored
  /// saveData('data3'); // Ignored
  /// // After 2 seconds, the next call will execute
  /// ```
  FutureVarArgsFunction<T> throttled(Duration interval) {
    DateTime? lastExecuted;
    T? lastResult;

    return FutureVarArgsFunction<T>((args, kwargs) {
      final now = DateTime.now();
      final completer = Completer<T>();

      if (lastExecuted == null || now.difference(lastExecuted!) >= interval) {
        lastExecuted = now;
        try {
          lastResult = callback(args, kwargs);
          completer.complete(lastResult);
        } catch (e) {
          completer.completeError(e);
        }
      } else {
        // If we're still in the throttle period, return the last result
        completer.complete(lastResult);
      }

      return completer.future;
    });
  }

  /// Creates a version of this function that will retry execution
  /// a specified number of times if it throws an exception.
  ///
  /// This is useful for operations that might fail temporarily:
  /// ```dart
  /// var fetchData = VarArgsFunction<String>((args, _) {
  ///   // Simulate a network request that might fail
  ///   if (Random().nextBool()) {
  ///     throw Exception('Network error');
  ///   }
  ///   return 'Data for ${args[0]}';
  /// }).withRetry(3, Duration(seconds: 1));
  ///
  /// try {
  ///   print(fetchData('user123')); // Will retry up to 3 times
  /// } catch (e) {
  ///   print('Failed after retries: $e');
  /// }
  /// ```
  FutureVarArgsFunction<T> withRetry(int maxRetries, [Duration? delay]) {
    return FutureVarArgsFunction<T>((args, kwargs) async {
      int attempts = 0;
      dynamic lastError;

      // First attempt
      try {
        attempts++;
        final result = callback(args, kwargs);
        if (result is Future<T>) {
          return result;
        }
        return result;
      } catch (e) {
        lastError = e;
        // Continue to retries
      }

      // Retry attempts (up to maxRetries)
      while (attempts <= maxRetries) {
        try {
          // Add delay between retries if specified
          if (delay != null) {
            await Future.delayed(delay);
          }
          // print('Retry attempt $attempts of $maxRetries');
          final result = callback(args, kwargs);
          if (result is Future<T>) {
            return result;
          }
          return result;
        } catch (e) {
          lastError = e;

          if (attempts >= maxRetries) {
            break;
          }
          attempts++;
        }
      }

      throw Exception('Failed after $maxRetries retries: $lastError');
    });
  }

  /// Composes this function with another function, creating a new function
  /// that passes the result of this function as input to the other function.
  ///
  /// ```dart
  /// var double = VarArgsFunction<int>((args, _) => args[0] * 2);
  /// var addOne = VarArgsFunction<int>((args, _) => args[0] + 1);
  /// var doubleThenAddOne = double.compose(addOne);
  /// print(doubleThenAddOne(5)); // Outputs: 11 (5*2 + 1)
  /// ```
  VarArgsFunction<R> compose<R>(VarArgsFunction<R> Function(T) g) {
    return VarArgsFunction<R>((args, kwargs) {
      final result = callback(args, kwargs);
      return g(result)([]);
    });
  }

  /// Converts this VarArgsFunction to a standard Dart function with the specified
  /// signature. This is useful when you need to pass the function to APIs that
  /// expect specific function signatures.
  ///
  /// ```dart
  /// var sum = VarArgsFunction<int>((args, _) => args.reduce((a, b) => a + b));
  /// // Convert to a function that takes two int parameters
  /// int Function(int, int) binarySum = sum.toFunction((a, b) => sum([a, b]));
  /// print(binarySum(5, 3)); // Outputs: 8
  /// ```
  R Function() toFunction<R>(R Function() fn) => fn;
}

/// A specialized version of VarArgsFunction that returns Future results.
/// This helps maintain proper type information for async operations.
class FutureVarArgsFunction<T> extends VarArgsFunction<Future<T>> {
  /// Constructor for creating a [FutureVarArgsFunction] instance.
  FutureVarArgsFunction(super.callback);

  /// Creates a new FutureVarArgsFunction that applies a transformation to the result
  /// of this function.
  FutureVarArgsFunction<R> mapFuture<R>(R Function(T result) transform) {
    return FutureVarArgsFunction<R>((args, kwargs) async {
      final result = await callback(args, kwargs);
      return transform(result);
    });
  }

  /// Adds a timeout to this future function, throwing an exception if the
  /// operation takes longer than the specified duration.
  FutureVarArgsFunction<T> withTimeout(Duration timeout) {
    return FutureVarArgsFunction<T>((args, kwargs) {
      return callback(args, kwargs).timeout(timeout);
    });
  }

  /// Adds a fallback value to return if the operation fails.
  FutureVarArgsFunction<T> withFallback(T fallbackValue) {
    return FutureVarArgsFunction<T>((args, kwargs) {
      return callback(args, kwargs).catchError((_) => fallbackValue);
    });
  }

  /// Composes this async function with another function, creating a new function
  /// that passes the result of this function as input to the other function.
  ///
  /// ```dart
  /// var fetchData = FutureVarArgsFunction<String>((args, _) async {
  ///   await Future.delayed(Duration(milliseconds: 100));
  ///   return 'Data: ${args[0]}';
  /// });
  /// var processData = VarArgsFunction<int>((args, _) => args[0].toString().length);
  /// var fetchAndProcess = fetchData.composeAsync(processData);
  /// fetchAndProcess('user123').then((length) => print(length)); // Outputs the length of 'Data: user123'
  /// ```
  FutureVarArgsFunction<R> composeAsync<R>(VarArgsFunction<R> Function(T) g) {
    return FutureVarArgsFunction<R>((args, kwargs) async {
      final result = await callback(args, kwargs);
      return g(result)([]);
    });
  }
}
