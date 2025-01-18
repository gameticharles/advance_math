part of '/advance_math.dart';

/// A callback type used for functions that handle both positional and named arguments.
///
/// The callback accepts two parameters:
/// - [args]: A list of positional arguments.
/// - [kwargs]: A map of named arguments (key-value pairs).
typedef VarArgsCallback = dynamic Function(
    List<dynamic> args, Map<String, dynamic> kwargs);

/// A class that enables handling variable numbers of positional and named arguments
/// dynamically. This class intercepts method calls and passes the arguments to a
/// user-defined callback function.
///
/// Example usage:
/// ```dart
/// // Example 1: Handle only positional arguments
/// dynamic superHeroes = VarArgsFunction((args, kwargs) {
///   for (final superHero in args) {
///     print("There's no stopping $superHero");
///   }
/// });
/// superHeroes('UberMan', 'Exceptional Woman', 'The Hunk'); // Positional args only
///
/// // Example 2: Handle both positional and named arguments
/// dynamic myFunc = VarArgsFunction((args, kwargs) {
///   print('Got args: $args, kwargs: $kwargs');
/// });
/// myFunc(1, 2, 3, x: 'hello', y: 'world'); // Positional + Named args
/// myFunc(10, 20, x: true, y: false); // Another set of Positional + Named args
/// myFunc('A', 'B', 'C'); // Positional args only
/// ```
class VarArgsFunction {
  /// A callback function that handles the positional and named arguments.
  final VarArgsCallback callback;

  // A constant offset used to strip the `Symbol("...")` part of named arguments.
  static final _offset = 'Symbol("'.length;

  /// Constructor for creating a [VarArgsFunction] instance.
  ///
  /// The callback function will be invoked when the function is called, and it
  /// will receive both positional and named arguments.
  ///
  /// [callback]: The function that will process the collected arguments.
  VarArgsFunction(this.callback);

  /// This method is overridden to capture any dynamic method calls made on
  /// the instance. It processes both positional and named arguments.
  ///
  /// The method:
  /// - Extracts positional arguments and stores them in a list.
  /// - Converts named arguments into a map of key-value pairs.
  /// - Passes both the positional arguments and the named arguments to the callback.
  @override
  dynamic noSuchMethod(Invocation inv) {
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
  }
}
